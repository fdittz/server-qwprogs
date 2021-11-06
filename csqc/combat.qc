void () SUB_Remove = {
    remove(self);
};

void (entity projectile) HideProjectile = {
	setmodel(projectile, "");
    setsize(projectile, '0 0 0', '0 0 0');
}

void () ExplodeProjectile = {
	self.velocity = '0 0 0';
	HideProjectile(self);
	te_explosion(self.origin);
}

void () ParseExplosion = {
	local vector org;
	local string s;
	local entity te;
	org_x = readcoord();
	org_y = readcoord();
	org_z = readcoord();
	s = readstring();
	
	
	te = find(world, digest, s);
	if (te != world) { // we have a fake projectile that probably has exploded, so remove it and do not create any explosion effects
		remove(te);
	}
	else { // no fake projectiles found, create explosion effects
		sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
		te_explosion(org);
	}
}


void (float att_delay) Attack_Finished = {
    if (player.tfstate & TFSTATE_TRANQUILISED)
        player.attack_finished = time + att_delay * 2;
    else
        player.attack_finished = time + att_delay;
};


void (entity projectile) PreDrawProjectile = {
	//remove projectile when server catches up
	if (servercommandframe >= projectile.clientframe) {
		remove(projectile);
	}
}

void () PreDrawRocket = {	
	if (vlen(self.origin - self.oldorigin) >= 80) { // making so the fake rocket doesn't spawn in player's face;
		if (!self.starttime)
			self.starttime = time;
		precache_model("progs/missile.mdl");
    	setmodel(self, "progs/missile.mdl");
    	setsize(self, '0 0 0', '0 0 0');
    	local vector oldorg = self.origin - self.velocity * (time - self.starttime);
    	
    	trailparticles(particleeffectnum("tr_rocket"), self, self.origin, oldorg);
		dynamiclight_add(self.origin, 400, '1 1 1');

	}
	PreDrawProjectile(self);
}


void () W_FireRocket = {

	local entity newmis;
	local vector org;
	local vector neworg;

	org = getentity(player_localentnum, GE_ORIGIN); //doesn't change with v_viewheight
    newmis = spawn();
    newmis.drawmask = MASK_ENGINE;
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLYMISSILE;
    newmis.solid = SOLID_BBOX;
    newmis.predraw = PreDrawRocket;

    makevectors(view_angles);
    newmis.velocity = v_forward;
    newmis.velocity = newmis.velocity * PC_SOLDIER_ROCKET_SPEED;
    newmis.angles = vectoangles(newmis.velocity);
    newmis.touch = ExplodeProjectile;
  
    newmis.nextthink = time + 5;
    newmis.think = SUB_Remove;
    
  	newmis.classname = "proj_rocket";
  	newmis.digest = digest_hex("MD4", strcat(newmis.classname, ftos(clientcommandframe), vtos(org)));
  	newmis.clientframe = clientcommandframe;
    
    neworg = org + v_forward * 8 + '0 0 16';
    newmis.oldorigin = neworg;    
    setorigin(newmis, neworg);
    print("CSQC ORIGIN: ");
    print(vtos(newmis.origin));
    print("\n");
    sendevent("ReceiveProjectile", "ss",newmis.classname, newmis.digest);


};

void () W_Attack = {
	local float r;
    
    player.current_weapon = getstatf(STAT_CURRENT_WEAPON);
    player.currentammo = getstatf(STAT_AMMO);
    player.tfstate = getstatf(STAT_TFSTATE);

    if (time <= player.attack_finished) {
        return;
    }
    
    if (player.tfstate & TFSTATE_RELOADING) {
        return;
    }

	if (player.current_weapon == WEAP_ROCKET_LAUNCHER) {
			Attack_Finished(0.8);
        	W_FireRocket();
    }

    
};