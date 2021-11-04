void () SUB_Remove = {
    remove(self);
};

void (float att_delay) Attack_Finished = {
    if (player.tfstate & TFSTATE_TRANQUILISED)
        player.attack_finished = time + att_delay * 2;
    else
        player.attack_finished = time + att_delay;
};


void () PreDrawProjectile = {
	if (servercommandframe >= self.clientframe) {
		remove(self);
	}
}

void () W_FireRocket = {

	local entity newmis;
	vector org = getviewprop(VF_ORIGIN);
    newmis = spawn();
    newmis.drawmask = MASK_ENGINE;
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLYMISSILE;
    newmis.solid = SOLID_BBOX;
    newmis.predraw = PreDrawProjectile;

    makevectors(view_angles);
    newmis.velocity = v_forward;
    newmis.velocity = newmis.velocity * PC_SOLDIER_ROCKET_SPEED;
    newmis.angles = vectoangles(newmis.velocity);
    newmis.touch = SUB_Remove;
  
    newmis.nextthink = time + 5;
    newmis.think = SUB_Remove;
    
  	newmis.classname = "proj_rocket";
  	newmis.clientframe = clientcommandframe;
    precache_model("progs/missile.mdl");
    setmodel(newmis, "progs/missile.mdl");
    setsize(newmis, '0 0 0', '0 0 0');
    setorigin(newmis, org + v_forward * 8 + '0 0 0');

};

void () W_Attack = {
	local float r;
    if (time <= player.attack_finished) {
        return;
    }
    player.current_weapon = getstatf(STAT_CURRENT_WEAPON);
    player.currentammo = getstatf(STAT_AMMO);
    player.tfstate = getstatf(STAT_TFSTATE);

	if (player.current_weapon == WEAP_ROCKET_LAUNCHER) {
			Attack_Finished(0.8);
        	W_FireRocket();
    }

    
};