void () login = {
	uri_get("http://localhost:8080", 10, "application/x-www-form-urlencoded", "token=aabab");
}

void(float reqid, float responsecode, string resourcebody) URI_Get_Callback = {
	if (!responsecode) {
		bprint(2, " - ");
		bprint(2,resourcebody);
		bprint(2, "\n");
	}
	else {
		bprint(2, responsecode);
		bprint(2, "\n");
	}
}