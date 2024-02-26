vector artr1, artn, artin, artic, arti_pos;
float artrns,artirns, artns, artics;
vector health_pos;
vector healthsep;
vector health_pos2;
vector healthsep2;
vector health_pos3;
vector healthsep3;
float health_scale;
vector ammo_pos;
float ammo_scale;
vector ammo_pos2;

void() check_health =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/health.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	health_pos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	health_pos_y = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	healthsep_x = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	health_scale = stof(readtext);         
	readtext = fgets(readparms);                
	health_pos2_x = stof(readtext);       
	readtext = fgets(readparms);              
	health_pos2_y = stof(readtext);         
	readtext = fgets(readparms);               
	healthsep2_x = stof(readtext);         
	readtext = fgets(readparms);                
	health_pos3_x = stof(readtext);       
	readtext = fgets(readparms);              
	health_pos3_y = stof(readtext);         
	readtext = fgets(readparms);               
	healthsep3_x = stof(readtext);         
	fclose (readparms);    
};

vector hmsgpos;
float hms;
float ap;
float yp;
float api;
vector dmsgpos;

void() check_hudmessages =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/hudmessages.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	hmsgpos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	hmsgpos_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	hms = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	ap = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	yp= stof(readtext);         
	readtext = fgets(readparms);                //read the text
	api = stof(readtext);
	readtext = fgets(readparms);                //read the text
	dmsgpos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	dmsgpos_y  = stof(readtext);         
	fclose (readparms);    
};

void() check_artifactring =
{
/*
1				//	scale of soul tether icon
-84				//	x position soul tether icon (206 center, -84 side,)
-47				//	y position soul tether icon (-35 lower, )
-4				//	x position for number soul tether ammount relative to soul tether icon
-2				//	y position for number soul tether ammount relative to soul tether icon
1				//	scale of number soul tether ammount
5				//	x position for icon relative to ring 
1				//	y position for icon relative to ring
1				//	artifact icon scale
-84				//	x position artifact icon (206 center, -84 side,)
-47				//	y position artifact icon (-35 lower, )
-4				//	x position for number soul tether ammount relative to soul tether icon
-2				//	y position for number soul tether ammount relative to soul tether icon
1				//	scale of number soul tether ammount
*/
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/tether_artifact.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	artns = stof(readtext);
	readtext = fgets(readparms);                //read the text
	artr1_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	artr1_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	artn_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	artn_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	artrns = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	artic_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	artic_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	artics = stof(readtext);
	readtext = fgets(readparms);                //read the text
	arti_pos_x = stof(readtext);
	readtext = fgets(readparms);                //read the text
	arti_pos_y = stof(readtext);
	readtext = fgets(readparms);                //read the text
	artin_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	artin_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	artirns = stof(readtext);         
	fclose (readparms);    
};

vector armr_pos;
vector armr_pos2;
vector drmr_pos;
float armr_scale;

void() check_armor =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/armor.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	armr_pos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	armr_pos_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	armr_pos2_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	drmr_pos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	drmr_pos_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	armr_scale = stof(readtext);         
	fclose (readparms);    
};

void() check_ammo =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/ammo.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	ammo_pos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	ammo_pos_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	ammo_scale = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	ammo_pos2_x = stof(readtext);         
	fclose (readparms);    
};

vector radialpos;
float radialscale;
float radialflag;
float radialflag2;
vector artifactdescpos;
vector bigiconpos;
void() check_radial =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/radial.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	radialpos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	radialpos_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	radialscale  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	radialflag  = stof(readtext);
	readtext = fgets(readparms);
	artifactdescpos_x = stof(readtext); 
	readtext = fgets(readparms);
	artifactdescpos_y = stof(readtext); 
	readtext = fgets(readparms);
	bigiconpos_x = stof(readtext); 
	readtext = fgets(readparms);
	bigiconpos_y = stof(readtext); 
	readtext = fgets(readparms);                //read the text
	radialflag2  = stof(readtext);
	fclose (readparms);    
};

float r_si;
vector r_si1;
vector r_si2;
vector r_si3;
vector r_si4;
vector r_si5;
vector r_si6;
vector r_si7;
vector r_si8;
vector r_si9;
vector r_si10;
float r_ic;
vector r_ic1;
vector r_ic2;
vector r_ic3;
vector r_ic4;
vector r_ic5;
vector r_ic6;
vector r_ic7;
vector r_ic8;
vector r_ic9;
vector r_ic10;

void() check_radialicon =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/artifact_icon.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	r_ic = stof(readtext);        
	readtext = fgets(readparms);               
	r_ic1_x = stof(readtext);        
	readtext = fgets(readparms);               
	r_ic1_y = stof(readtext);        
	readtext = fgets(readparms);               
	r_ic2_x = stof(readtext);        
	readtext = fgets(readparms);               
	r_ic2_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic3_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic3_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic4_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic4_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic5_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic5_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic6_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic6_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic7_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic7_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic8_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic8_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic9_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic9_y = stof(readtext);
	readtext = fgets(readparms);
	r_ic10_x = stof(readtext);
	readtext = fgets(readparms);
	r_ic10_y = stof(readtext);
	fclose (readparms);    
};

void() check_radialnum =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/artifact_num.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	r_si = stof(readtext);        
	readtext = fgets(readparms);               
	r_si1_x = stof(readtext);        
	readtext = fgets(readparms);               
	r_si1_y = stof(readtext);        
	readtext = fgets(readparms);               
	r_si2_x = stof(readtext);        
	readtext = fgets(readparms);               
	r_si2_y = stof(readtext);
	readtext = fgets(readparms);
	r_si3_x = stof(readtext);
	readtext = fgets(readparms);
	r_si3_y = stof(readtext);
	readtext = fgets(readparms);
	r_si4_x = stof(readtext);
	readtext = fgets(readparms);
	r_si4_y = stof(readtext);
	readtext = fgets(readparms);
	r_si5_x = stof(readtext);
	readtext = fgets(readparms);
	r_si5_y = stof(readtext);
	readtext = fgets(readparms);
	r_si6_x = stof(readtext);
	readtext = fgets(readparms);
	r_si6_y = stof(readtext);
	readtext = fgets(readparms);
	r_si7_x = stof(readtext);
	readtext = fgets(readparms);
	r_si7_y = stof(readtext);
	readtext = fgets(readparms);
	r_si8_x = stof(readtext);
	readtext = fgets(readparms);
	r_si8_y = stof(readtext);
	readtext = fgets(readparms);
	r_si9_x = stof(readtext);
	readtext = fgets(readparms);
	r_si9_y = stof(readtext);
	readtext = fgets(readparms);
	r_si10_x = stof(readtext);
	readtext = fgets(readparms);
	r_si10_y = stof(readtext);
	fclose (readparms);      
};

vector keypos;
float keysep;
float keyscale;
float keyflag;

void() check_keys =
{
	local float readparms;
	local string readtext;
	readparms = fopen ("hud/keys.txt", FILE_READ);    //open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);                //read the text
	keypos_x = stof(readtext);        //turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);                //read the text
	keypos_y  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	keysep  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	keyscale  = stof(readtext);         
	readtext = fgets(readparms);                //read the text
	keyflag  = stof(readtext);         
	fclose (readparms);    
};

void () check_frikfile =
{
	check_artifactring();
	check_health();
	check_armor();
	check_radial();
	check_ammo ();
	check_radialicon();
	check_radialnum();
	check_hudmessages ();
	check_keys();
};

////////////////end of qc file