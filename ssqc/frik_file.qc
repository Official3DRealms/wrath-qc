/////////////////////////////////////////////
////////////CLIENT FRIK_FILE////////////
/////////////////////////////////////////////
float sliding_fps;
float sliding_ammount_d;
float sliding_ammount_i;
float jumpad_noinput_time;
float lava_speed;
float lava_damage;
float lava_damage_time;
float player_zviewofs;
void() check_player= 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("player.txt", FILE_READ);
	readtext = fgets(readfrik);
	sliding_fps = stof(readtext);
	readtext = fgets(readfrik);
	sliding_ammount_d = stof(readtext);
	readtext = fgets(readfrik);
	sliding_ammount_i = stof(readtext);
	readtext = fgets(readfrik);
	jumpad_noinput_time = stof(readtext);
	readtext = fgets(readfrik);
	lava_speed = stof(readtext);
	readtext = fgets(readfrik);
	lava_damage = stof(readtext);
	readtext = fgets(readfrik);
	lava_damage_time = stof(readtext);
	readtext = fgets(readfrik);
	player_zviewofs = stof(readtext);
	fclose(readfrik);
};


float lunge_vel;
float lunge_velz;
float lunge_velzog;
.string melee_model;

void() check_melee = { self.melee_model = "models/weapons/melee/v_gauntlet.md3";	// strzone(readtext);
	self.dvweapon_x = 4;	//stof(readtext);        
	self.dvweapon_y = -7;	// stof(readtext);         
	self.dvweapon_z = -7;	//stof(readtext);         
	self.dvweapon_scale = 1;	//stof(readtext);         
	self.vweaponangles_x = 0;	// stof(readtext);
	self.vweaponangles_y = 0;	//stof(readtext);
	self.vweaponangles_z = 0;	//stof(readtext);
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/melee.txt", FILE_READ);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	readtext = fgets(readfrik);
	lunge_vel = stof(readtext);
	readtext = fgets(readfrik);
	lunge_velz = stof(readtext);
	readtext = fgets(readfrik);
	lunge_velzog = stof(readtext);
	fclose(readfrik);
};
float mace_damage;          // primary fire damage 
float mace_additional_damage;          // primary fire damage 
float mace_proj_damage;           // projectile impact damage 
float mace_proj_splashdamage;          // projectile splash damage 
float mace_proj_speed;           // projectile speed
float mace_proj_splashradius;
float mace_proj_homingfactor;            // projectile homing strength /*?????????*/
float mace_proj_acelerationfactor;            // projectile homing strength /*?????????*/


void() check_mace = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/mace.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.macevweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.macevweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.macevweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.macevweapon_scale = stof(readtext);	
	readtext = fgets(readfrik);
	mace_damage = stof(readtext);
	readtext = fgets(readfrik);
	mace_additional_damage = stof(readtext);
	readtext = fgets(readfrik);
	mace_proj_damage = stof(readtext);
	readtext = fgets(readfrik);
	mace_proj_splashdamage = stof(readtext);
	readtext = fgets(readfrik);
	mace_proj_splashradius = stof(readtext);
	readtext = fgets(readfrik);
	mace_proj_speed = stof(readtext);
	readtext = fgets(readfrik);
	mace_proj_homingfactor = stof(readtext);
	readtext = fgets(readfrik);
	mace_proj_acelerationfactor = stof(readtext);
	fclose(readfrik);
};
//vweaponangles

//string wviewmodel;
void() check_vmodel = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/viewmodel.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.vvweapon_model = strzone(readtext);
	readtext = fgets(readfrik);
	self.vvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.vvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.vvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.vvweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	self.vvweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.vvweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.vvweaponangles_z = stof(readtext);
	fclose(readfrik);
};

void() check_shotgun_pos = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/shotgun_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.svweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.svweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.svweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.sweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.sweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.sweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_svweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_svweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_svweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_sweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_sweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_sweaponangles_z = stof(readtext);
	fclose(readfrik);
};

void() check_shotgun = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/shotgun.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.shotgun_damage1 = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_damage1_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_time1 = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_time2 = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_spread1 = stof(readtext);
	readtext = fgets(readfrik);
	self.svweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	shotbbox = stov(readtext);
	readtext = fgets(readfrik);
	self.buckshot_count = stof(readtext);
	readtext = fgets(readfrik);
	self.charge_shotgun_count = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_proj_speed = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_proj_dmg = stof(readtext);
	readtext = fgets(readfrik);
	self.shotgun_proj_dmg_mp = stof(readtext);
	readtext = fgets(readfrik);
	proj_shotgun_drunkfactorv = stof(readtext);
	readtext = fgets(readfrik);
	proj_shotgun_drunkfactorh = stof(readtext);
	readtext = fgets(readfrik);
	proj_shotgun_timing = stof(readtext);
	readtext = fgets(readfrik);
	proj_shotgun_bbox = stov(readtext);
	fclose(readfrik);
};
float coach_proj_vel;
void() check_revolver_pos = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/revolver_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.cgvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.cgvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.cgvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.cgweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.cgweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.cgweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cgvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cgvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cgvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cgweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cgweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cgweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);	fclose(readfrik);
};
void() check_revolver = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/revolver.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.revolver_damage1 = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_damage1_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_damage2 = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_damage2_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_time1 = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_time2 = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_spread1 = stof(readtext);
	readtext = fgets(readfrik);
	self.revolver_spread2 = stof(readtext);
	readtext = fgets(readfrik);
	self.cgvweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	coachbbox = stov(readtext);
	readtext = fgets(readfrik);
	coach_proj_vel = stof(readtext);
	fclose(readfrik);
};
vector bboxretcher;
vector bboxretcher2;

float retcherdamg;
float retcherdamg2;
float retcherdamg_mp;
float retcherdamg2_mp;
float retchersplashdamage;
float retchersplashradius;
float retchersplashdamage_mp;
float retchersplashradius_mp;
float retcheraoeradius;
float retcheraoetime;
float retcheraoedamage;
float retcheraoedamage_mp;
float retcheraoeframetime;
float retcher_proj_velz;
float retcher_proj_vel;
float retcher_proj_grav;

void() check_retcher_pos = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/retcher_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.rvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.rvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.rvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.rweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.rweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.rweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_rvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_rvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_rvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_rweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_rweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.rweaponangles_z = stof(readtext);	fclose(readfrik);
};

void() check_retcher = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/retcher.txt", FILE_READ);
	readtext = fgets(readfrik);
	retcherdamg = stof(readtext);
	readtext = fgets(readfrik);
	retcherdamg_mp = stof(readtext);
	readtext = fgets(readfrik);
	retcherdamg2 = stof(readtext);
	readtext = fgets(readfrik);
	retcherdamg2_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.voidbombs_time1 = stof(readtext);
	readtext = fgets(readfrik);
	self.voidbombs_time2 = stof(readtext);
	readtext = fgets(readfrik);
	self.rvweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	bboxretcher = stov(readtext);
	readtext = fgets(readfrik);
	bboxretcher2 = stov(readtext);
	readtext = fgets(readfrik);
	retchersplashdamage = stof(readtext);
	readtext = fgets(readfrik);
	retchersplashdamage_mp = stof(readtext);
	readtext = fgets(readfrik);
	retchersplashradius = stof(readtext);
	readtext = fgets(readfrik);
	retchersplashradius_mp = stof(readtext);
	readtext = fgets(readfrik);
	retcheraoeradius = stof(readtext);
	readtext = fgets(readfrik);
	retcheraoetime = stof(readtext);
	readtext = fgets(readfrik);
	retcheraoedamage = stof(readtext);
	readtext = fgets(readfrik);
	retcheraoedamage_mp = stof(readtext);
	readtext = fgets(readfrik);
	retcheraoeframetime = stof(readtext);
	readtext = fgets(readfrik);
	retcher_proj_velz = stof(readtext);
	readtext = fgets(readfrik);
	retcher_proj_vel = stof(readtext);
	readtext = fgets(readfrik);
	retcher_proj_grav = stof(readtext);

	fclose(readfrik);
};


void() check_slagcannon_pos = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/slagcannon_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.cvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.cvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.cvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.cweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.cweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.cweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_cweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	fclose(readfrik);
};
void() check_slagcannon = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/slagcannon.txt", FILE_READ);
	readtext = fgets(readfrik);
	slagcannon_damage1 = stof(readtext);
	readtext = fgets(readfrik);
	slagcannon_damage1_mp = stof(readtext);
	readtext = fgets(readfrik);
	slagcannon_damage2 = stof(readtext);
	readtext = fgets(readfrik);
	slagcannon_damage2_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.slagcannon_time1 = stof(readtext);
	readtext = fgets(readfrik);
	self.slagcannon_time2 = stof(readtext);
	readtext = fgets(readfrik);
	self.cvweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	self.slagcannonspread = stof(readtext);
	readtext = fgets(readfrik);
	bboxslag = stov(readtext);
	readtext = fgets(readfrik);
	bboxslag2 = stov(readtext);
	readtext = fgets(readfrik);
	slagspeed = stof(readtext);
	readtext = fgets(readfrik);
	slagspeed2 = stof(readtext);
	readtext = fgets(readfrik);
	slagsplashradius = stof(readtext);
	readtext = fgets(readfrik);
	slagsplashradius2 = stof(readtext);
	readtext = fgets(readfrik);
	slagsplashdamage = stof(readtext);
	readtext = fgets(readfrik);
	slagsplashdamage_mp = stof(readtext);
	readtext = fgets(readfrik);
	slagsplashdamage2 = stof(readtext);
	readtext = fgets(readfrik);
	slagsplashdamage2_mp = stof(readtext);
	readtext = fgets(readfrik);
	slagrocketjump = stof(readtext);
	fclose(readfrik);
};
vector bboxspitter;
vector bboxspitter2;
float spitterdamg;
float spitterdamg2;
float spitterdamg_mp;
float spitterdamg2_mp;
float spittervel;
float spittervel2;
float spitter_svpf;
float spitter_svsf;
void() check_spitter_pos = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/spitter_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.pvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.pvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.pvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.pweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.pweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.pweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_pvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_pvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_pvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_pweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_pweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_pweaponangles_z = stof(readtext);	
	fclose(readfrik);
};

void() check_spitter = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/spitter.txt", FILE_READ);
	readtext = fgets(readfrik);
	spitterdamg = stof(readtext);
	readtext = fgets(readfrik);
	spitterdamg_mp = stof(readtext);
	readtext = fgets(readfrik);
	spitterdamg2 = stof(readtext);
	readtext = fgets(readfrik);
	spitterdamg2_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.flamethrower_time1 = stof(readtext);      
	readtext = fgets(readfrik);
	self.flamethrower_time2 = stof(readtext);     
	readtext = fgets(readfrik);
	self.pvweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	bboxspitter = stov(readtext);
	readtext = fgets(readfrik);
	bboxspitter2 = stov(readtext);
	readtext = fgets(readfrik);
	spittervel = stof(readtext);
	readtext = fgets(readfrik);
	spittervel2 = stof(readtext);
	readtext = fgets(readfrik);
	spitter_svpf = stof(readtext);
	readtext = fgets(readfrik);
	spitter_svsf = stof(readtext);
	fclose(readfrik);
};
.float lance_muzzle_scale;
void() check_lance= { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/lance.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.lance_damage = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_damage_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_damage2 = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_damage2_mp = stof(readtext);
	readtext = fgets(readfrik);
	self.lvweapon_scale = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_muzzle_scale = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_time = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_time2 = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_alpha_time = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_viewzoom = stof(readtext);
	readtext = fgets(readfrik);
	self.lance_viewzoom_rate = stof(readtext);
	fclose(readfrik);
};
void() check_lance_pos= { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/lance_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.lvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.lvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.lvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.lweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.lweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.lweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_lvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_lvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_lvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_lweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_lweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_lweaponangles_z = stof(readtext);
	fclose(readfrik);
};

.vector chvweapon;
.vector chvweaponangles;
.vector centered_chvweapon;
.vector centered_chvweaponangles;

void() check_crystal_pos = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/crystal_pos.txt", FILE_READ);
	readtext = fgets(readfrik);
	self.chvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.chvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.chvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.chvweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.chvweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.chvweaponangles_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_chvweapon_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_chvweapon_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_chvweapon_z = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_chvweaponangles_x = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_chvweaponangles_y = stof(readtext);
	readtext = fgets(readfrik);
	self.centered_chvweaponangles_z = stof(readtext);
	fclose(readfrik);
};
float crystal1_damage;
float crystal1_damage_mp;
float crystal1secondary_damage;
float crystal1secondary_damage_mp;
float crystal2_damage;
float crystal2_damage_mp;

void() check_crystal = 
{ 
local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/crystal.txt", FILE_READ);
	readtext = fgets(readfrik);
	crystal1_damage = stof(readtext);
	readtext = fgets(readfrik);
	crystal1_damage_mp = stof(readtext);
	readtext = fgets(readfrik);
	crystal1secondary_damage = stof(readtext);
	readtext = fgets(readfrik);
	crystal1secondary_damage_mp = stof(readtext);
	readtext = fgets(readfrik);
	crystal2_damage = stof(readtext);
	readtext = fgets(readfrik);
	crystal2_damage_mp = stof(readtext);
	fclose(readfrik);
};

void() Check_FrikFile = { check_melee();
	check_revolver();
	check_revolver_pos();
	check_shotgun();
	check_shotgun_pos();
	check_retcher();
	check_retcher_pos();
	check_slagcannon();
	check_slagcannon_pos();
	check_spitter();
	check_spitter_pos();
	check_vmodel();
	check_lance();
	check_lance_pos();
	check_mace();
	check_player();
	check_crystal();
	check_crystal_pos();
};

/////////////////////////////////////////////
////////////ITEMS FRIK_FILE/////////////
/////////////////////////////////////////////


float attar_vel;//projectile vel
float attar_velz;//projectile angle
float attar_grav;//projectile gravity
vector attar_pbbox;//projectile bbox size
vector attar_pbboxn;//projectile bbox size negative
vector attar_bbox;//AOE bbox size
vector attar_bboxn;//AOE bbox size negative
float attar_time;//AOE duration
float attar_effect_time;//affected enemy duration
void() check_attar = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("artifacts/attar.txt", FILE_READ);
	readtext = fgets(readfrik);
	attar_vel = stof(readtext);
	readtext = fgets(readfrik);
	attar_velz = stof(readtext);
	readtext = fgets(readfrik);
	attar_grav = stof(readtext);
	readtext = fgets(readfrik);
	attar_pbbox = stov(readtext);
	readtext = fgets(readfrik);
	attar_pbboxn = stov(readtext);
	readtext = fgets(readfrik);
	attar_bbox = stov(readtext);
	readtext = fgets(readfrik);
	attar_bboxn = stov(readtext);
	readtext = fgets(readfrik);
	attar_time = stof(readtext);
	readtext = fgets(readfrik);
	attar_effect_time = stof(readtext);
	fclose(readfrik);
};
float shockwave_radius;		//total radius
float shockwave_dmg;		//initial damage
float shockwave_critical_radius;		//critical zone radius
float shockwave_time;		//explosion duration (in seconds)

void() check_shockwave = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("artifacts/shockwave.txt", FILE_READ);
	readtext = fgets(readfrik);
	shockwave_radius = stof(readtext);
	readtext = fgets(readfrik);
	shockwave_dmg = stof(readtext);
	readtext = fgets(readfrik);
	shockwave_critical_radius = stof(readtext);
	readtext = fgets(readfrik);
	shockwave_time = stof(readtext);
	fclose(readfrik);
};



float shotgun_ammount;
float revolver_ammount;
float spitter_ammount;
float retcher_ammount;
float cannon_ammount;
float lance_ammount;
float crystal_ammount;
float mace_ammount;

void() check_itemammount = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("items/ammount.txt", FILE_READ);
	readtext = fgets(readfrik);
	revolver_ammount = stof(readtext);
	readtext = fgets(readfrik);
	shotgun_ammount = stof(readtext);
	readtext = fgets(readfrik);
	spitter_ammount = stof(readtext);
	readtext = fgets(readfrik);
	retcher_ammount = stof(readtext);
	readtext = fgets(readfrik);
	cannon_ammount = stof(readtext);
	readtext = fgets(readfrik);
	lance_ammount = stof(readtext);
	readtext = fgets(readfrik);
	crystal_ammount = stof(readtext);
	readtext = fgets(readfrik);
	mace_ammount = stof(readtext);
	readtext = fgets(readfrik);
	fclose(readfrik);
};
/*		self.ammo_revolver = max_ammo_revolver;
		self.ammo_shotgun = max_ammo_shotgun;
		//self.ammo_bombs = 250;
		self.ammo_spitter = max_ammo_spitter;
		self.ammo_cannon = max_ammo_cannon;
		self.ammo_retcher = max_ammo_retcher;
		self.ammo_lance = max_ammo_lance;*/


float max_ammo_revolver;
float max_ammo_shotgun;
float max_ammo_spitter;
float max_ammo_retcher;
float max_ammo_cannon;
float max_ammo_lance;
float max_ammo_crystal;


void() check_maxammo = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("items/maxammo.txt", FILE_READ);
	readtext = fgets(readfrik);
	max_ammo_revolver = stof(readtext);
	readtext = fgets(readfrik);
	max_ammo_shotgun = stof(readtext);
	readtext = fgets(readfrik);
	max_ammo_spitter = stof(readtext);
	readtext = fgets(readfrik);
	max_ammo_retcher = stof(readtext);
	readtext = fgets(readfrik);
	max_ammo_cannon = stof(readtext);
	readtext = fgets(readfrik);
	max_ammo_lance = stof(readtext);
	readtext = fgets(readfrik);
	max_ammo_crystal = stof(readtext);
	fclose(readfrik);
};
float artifact_lightlev;
vector artifact_light_col;
float dark_helm_lightlev;
vector dark_helm_light_col;
float dark_armor_lightlev;
vector dark_armor_light_col;
float dark_shard_lightlev;
vector dark_shard_light_col;
float helm_lightlev;
vector helm_light_col;
float armor_lightlev;
vector armor_light_col;
float shard_lightlev;
vector shard_light_col;
float cofferkey_lightlev;
vector cofferkey_light_col;

void() check_itemlight = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("items/light.txt", FILE_READ);
	readtext = fgets(readfrik);
	artifact_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	artifact_light_col = stov(readtext);
	readtext = fgets(readfrik);
	dark_helm_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	dark_helm_light_col = stov(readtext);
	readtext = fgets(readfrik);
	dark_armor_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	dark_armor_light_col = stov(readtext);
	readtext = fgets(readfrik);
	dark_shard_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	dark_shard_light_col = stov(readtext);
	readtext = fgets(readfrik);
	helm_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	helm_light_col = stov(readtext);
	readtext = fgets(readfrik);
	armor_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	armor_light_col = stov(readtext);
	readtext = fgets(readfrik);
	shard_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	shard_light_col = stov(readtext);
	readtext = fgets(readfrik);
	cofferkey_lightlev = stof(readtext);
	readtext = fgets(readfrik);
	cofferkey_light_col = stov(readtext);
	fclose(readfrik);
};


float coffer_item_bounce;
float coffer_item_gravity;
float coffer_item_vel;
float coffer_item_delay;

void() check_coffer =
{
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("items/coffer.txt", FILE_READ);
	readtext = fgets(readfrik);
	coffer_item_gravity = stof(readtext);
	readtext = fgets(readfrik);
	coffer_item_bounce = stof(readtext);
	readtext = fgets(readfrik);
	coffer_item_vel= stof(readtext);
	readtext = fgets(readfrik);
	coffer_item_delay= stof(readtext);
	fclose(readfrik);
};	
void() check_itemsize = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("items/size.txt", FILE_READ);
	readtext = fgets(readfrik);
	artifact_nsize = stov(readtext);
	readtext = fgets(readfrik);
	artifact_size = stov(readtext);
	readtext = fgets(readfrik);
	dark_helm_nsize = stov(readtext);
	readtext = fgets(readfrik);
	dark_helm_size = stov(readtext);
	readtext = fgets(readfrik);
	dark_armor_nsize = stov(readtext);
	readtext = fgets(readfrik);
	dark_armor_size = stov(readtext);
	readtext = fgets(readfrik);
	dark_shard_nsize = stov(readtext);
	readtext = fgets(readfrik);
	dark_shard_size = stov(readtext);
	readtext = fgets(readfrik);
	helm_nsize = stov(readtext);
	readtext = fgets(readfrik);
	helm_size = stov(readtext);
	readtext = fgets(readfrik);
	armor_nsize = stov(readtext);
	readtext = fgets(readfrik);
	armor_size = stov(readtext);
	readtext = fgets(readfrik);
	shard_nsize = stov(readtext);
	readtext = fgets(readfrik);
	shard_size = stov(readtext);
	readtext = fgets(readfrik);
	heart_size = stov(readtext);
	readtext = fgets(readfrik);
	chalice_size = stov(readtext);
	readtext = fgets(readfrik);
	vial_size = stov(readtext);
	readtext = fgets(readfrik);
	beaker_size = stov(readtext);
	readtext = fgets(readfrik);
	resin_size = stov(readtext);
	readtext = fgets(readfrik);
	resinl_size = stov(readtext);
	readtext = fgets(readfrik);
	ore_size = stov(readtext);
	readtext = fgets(readfrik);
	orel_size = stov(readtext);
	readtext = fgets(readfrik);
	explosives_size = stov(readtext);
	readtext = fgets(readfrik);
	explosivesl_size = stov(readtext);
	readtext = fgets(readfrik);
	shells_size = stov(readtext);
	readtext = fgets(readfrik);
	shellsl_size = stov(readtext);
	readtext = fgets(readfrik);
	slag_nsize = stov(readtext);
	readtext = fgets(readfrik);
	slag_size = stov(readtext);
	readtext = fgets(readfrik);
	spitter_nsize = stov(readtext);
	readtext = fgets(readfrik);
	spitter_size = stov(readtext);
	readtext = fgets(readfrik);
	retcher_nsize = stov(readtext);
	readtext = fgets(readfrik);
	retcher_size = stov(readtext);
	readtext = fgets(readfrik);
	coach_nsize = stov(readtext);
	readtext = fgets(readfrik);
	coach_size = stov(readtext);
	readtext = fgets(readfrik);
	coffer_key_nsize = stov(readtext);
	readtext = fgets(readfrik);
	coffer_key_size = stov(readtext);
	readtext = fgets(readfrik);
	retcher_proj_size = stov(readtext);
	readtext = fgets(readfrik);
	shells_size_invader = stov(readtext);
	fclose(readfrik);
};
vector flash_color;
float flash_alpha;
float flash_fade;

void() check_itemflash = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("items/flash.txt", FILE_READ);
	readtext = fgets(readfrik);
	flash_color = stov (readtext);
	readtext = fgets(readfrik);
	flash_alpha = stof (readtext);
	readtext = fgets(readfrik);
	flash_fade = stof (readtext);
	fclose(readfrik);
};

vector sigil_flash_color;
float sigil_flash_alpha;
float sigil_flash_fade;

void() check_itemsigil_flash = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("sigil/fly_flash.txt", FILE_READ);
	readtext = fgets(readfrik);
	sigil_flash_color = stov (readtext);
	readtext = fgets(readfrik);
	sigil_flash_alpha = stof (readtext);
	readtext = fgets(readfrik);
	sigil_flash_fade = stof (readtext);
	fclose(readfrik);
};

/////////////////////////////////////////////
////////////ENEMIES FRIK_FILE/////////
/////////////////////////////////////////////


float affpl;
float affpm;
float affph;




float opp_health;
vector opp_bbox;
vector opp_bboxn;
float opp_wvel;
float opp_dmg;
float opp_projvelfactor;
float opp_projvel;
float opp_projvel2;
float opp_dr_run;
float opp_dr_attack;
float opp_dtp;
float opp_dtg;
float opp_rtp;
float opp_near;
float opp_mid;
float opp_far;
float opp_zzc;
float opp_zzd;
float opp_zzmd;
//float opp_dr_idle;
vector opp_proj_size;

void() check_op_vel = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/oppressor.txt", FILE_READ);
	readtext = fgets(readfrik); 
	opp_health = stof(readtext);
	readtext = fgets(readfrik); 
	opp_bbox = stov(readtext);
	readtext = fgets(readfrik); 
	opp_bboxn = stov(readtext);
	readtext = fgets(readfrik); 
	opp_wvel = stof(readtext);
	readtext = fgets(readfrik); 
	opp_dmg = stof(readtext);
	readtext = fgets(readfrik); 
	opp_projvelfactor = stof(readtext);
	readtext = fgets(readfrik); 
	opp_projvel = stof(readtext);
	readtext = fgets(readfrik); 
	opp_projvel2 = stof(readtext);
	readtext = fgets(readfrik); 
	opp_dr_run = stof(readtext);
	readtext = fgets(readfrik); 
	opp_dr_attack = stof(readtext);
	readtext = fgets(readfrik); 
	opp_dtp = stof(readtext); // damage needed to pain
	readtext = fgets(readfrik);  
	opp_dtg = stof(readtext); // damage needed to gib
	readtext = fgets(readfrik);  
	opp_rtp = stof(readtext); // dice roll to pain
	readtext = fgets(readfrik); 
	opp_near = stof(readtext);
	readtext = fgets(readfrik); 
	opp_mid = stof(readtext);
	readtext = fgets(readfrik); 
	opp_far = stof(readtext);
	readtext = fgets(readfrik); 
	opp_zzc = stof(readtext);
	readtext = fgets(readfrik); 
	opp_zzd = stof(readtext);
	readtext = fgets(readfrik); 
	opp_zzmd = stof(readtext);
	readtext = fgets(readfrik); 
	opp_proj_size = stov(readtext);
	fclose(readfrik);
};

float affwvel1;
float affwvel2;
float affwvel3;
float affwvel4;
float affwvel5;
float affwvel6;
float affwvel7;
float affwvel8;
float affwvel9;
float affwvel10;
float affwvel11;
float affwvel12;
float affwvel13;
float affwvel14;
vector afflictedbbox;
vector afflictednbbox;
float afflictedhealth;
float afflicteddamage;
float afflicteddamage2;
vector afflictedpbbox;
float afflictedpvel;
float aff_dr_idle;
float aff_dr_walk;
float aff_dr_attack;
float aff_dr_run;
float damageexplosionafflicted;
float radiusexplosionafflicted;
float damagedexplosionafflicted;
float radiusdexplosionafflicted;
float afflicted_damagetomonsters;
float afflicted_pushfactor;
float afflicted_suicide_distance;

void() check_af_vel = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/afflicted_vel.txt", FILE_READ);
	readtext = fgets(readfrik);
	affwvel1 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel2 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel3 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel4 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel5 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel6 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel7 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel8 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel9 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel10 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel11 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel12 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel13 = stof(readtext);
	readtext = fgets(readfrik);
	affwvel14 = stof(readtext);
	readtext = fgets(readfrik);
	afflictedhealth = stof(readtext);
	readtext = fgets(readfrik);
	afflicteddamage = stof(readtext);
	readtext = fgets(readfrik);
	afflicteddamage2 = stof(readtext);
	readtext = fgets(readfrik);
	afflictednbbox = stov(readtext);
	readtext = fgets(readfrik);
	afflictedbbox = stov(readtext);
	readtext = fgets(readfrik);
	afflictedpbbox = stov(readtext);
	readtext = fgets(readfrik);
	afflictedpvel = stof(readtext);
	readtext = fgets(readfrik);
	aff_dr_idle = stof(readtext);
	readtext = fgets(readfrik);
	aff_dr_walk = stof(readtext);
	readtext = fgets(readfrik);
	aff_dr_attack = stof(readtext);
	readtext = fgets(readfrik);
	aff_dr_run = stof(readtext);
	readtext = fgets(readfrik);
	damageexplosionafflicted = stof(readtext);
	readtext = fgets(readfrik);
	radiusexplosionafflicted = stof(readtext);
	readtext = fgets(readfrik);
	affpl = stof(readtext);
	readtext = fgets(readfrik);
	affpm = stof(readtext);
	readtext = fgets(readfrik);
	affph = stof(readtext);
	readtext = fgets(readfrik);
	damagedexplosionafflicted = stof(readtext);
	readtext = fgets(readfrik);
	radiusdexplosionafflicted = stof(readtext);
	readtext = fgets(readfrik);
	afflicted_damagetomonsters = stof(readtext);	//  	
	readtext = fgets(readfrik);
	afflicted_pushfactor = stof(readtext);	//  	
	readtext = fgets(readfrik);
	afflicted_suicide_distance = stof(readtext);	//  	
	fclose(readfrik);
};

vector aff_gib1;
vector aff_gib2;
vector aff_gib3;
vector aff_gib4;
vector aff_gib5;
vector aff_gib6;
vector aff_gib7;
vector aff_gib8;
vector aff_gib9;
vector aff_gib10;
vector aff_gib11;
vector aff_gib12;
vector aff_gib13;
vector aff_gib14;
vector aff_gib15;
vector aff_gib16;
vector aff_gib17;
vector aff_gib18;
vector aff_gib19;
vector aff_gib20;

void() check_afflicted_gibs = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/afflicted_gibs.txt", FILE_READ);
	readtext = fgets(readfrik);
	aff_gib1 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib2 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib3 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib4 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib5 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib6 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib7 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib8 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib9 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib10 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib11 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib12 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib13 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib14 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib15 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib16 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib17 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib18 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib19 = stov(readtext);
	readtext = fgets(readfrik);
	aff_gib20 = stov(readtext);

	fclose(readfrik);
};



/*
float hereod;
float heredmg;
float herevel;
float herelif;

void()check_here_vel=
{
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath ("enemies/heretic_vel.txt", FILE_READ);    
	readtext = fgets(readfrik);   
	herepl = stof(readtext);
	readtext = fgets(readfrik);   
	herepm = stof(readtext);
	readtext = fgets(readfrik);   
	hereph = stof(readtext);
	readtext = fgets(readfrik);   
	heredmg = stof(readtext);
	readtext = fgets(readfrik);   
	hereod = stof(readtext);
	readtext = fgets(readfrik);   
	herevel = stof(readtext);
	readtext = fgets(readfrik);   
	herelif = stof(readtext);
	fclose (readfrik); 
};
*/
float lpdmg;
float mpdmg;
float hpdmg;

void() check_damg_pain = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("weapons/damagepercent.txt", FILE_READ);
	readtext = fgets(readfrik);
	lpdmg = stof(readtext);
	readtext = fgets(readfrik);
	mpdmg = stof(readtext);
	readtext = fgets(readfrik);
	hpdmg = stof(readtext);
	fclose(readfrik);
};
float exec_rangeattack;
float exec_vwalk1;


float exec_atta1;
float exec_atta2;
float exec_atta3;
float exec_atta4;
float exec_atta5;
float exec_atta6;
float exec_atta7;
float exec_atta8;
float exec_atta9;
float exec_atta10;
float exec_attb1;
float exec_attb2;
float exec_attb3;
float exec_attb4;
float exec_attb5;
float exec_attb6;
float exec_attb7;
float exec_attb8;
float exec_attb9;
float exec_attb10;
float exec_attc1;
float exec_attc2;
float exec_attc3;
float exec_attc4;
float exec_attc5;
float exec_attc6;
float exec_attc7;
float exec_attc8;
float exec_attc9;
float exec_attc10;
float exec_attd1;
float exec_attd2;
float exec_attd3;
float exec_attd4;
float exec_attd5;
float exec_attd6;
float exec_attd7;
float exec_attd8;
float exec_attd9;
float exec_attd10;
float exec_charge1;
float exec_charge2;
float exec_charge3;
float exec_charge4;
float exec_charge5;
float exec_charge6;
float exec_chsh1;
float exec_chsh2;
float exec_chsh3;
float exec_chsh4;
float exec_chsh5;
float exec_chsh6;

float exec_health;
float exec_damage;
float exec_chargedamage;
float exec_impactdamage;
float exec_radius;
float exec_chargetime;

void() check_exec_vel = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/exec_vel.txt", FILE_READ);
	readtext = fgets(readfrik);
	exec_health = stof(readtext);
	readtext = fgets(readfrik);
	exec_damage = stof(readtext);
	readtext = fgets(readfrik);
	exec_rangeattack = stof(readtext);
	readtext = fgets(readfrik);
	exec_chargedamage = stof(readtext);
	readtext = fgets(readfrik);
	exec_impactdamage = stof(readtext);
	readtext = fgets(readfrik);
	exec_radius = stof(readtext);
	readtext = fgets(readfrik);
	exec_chargetime = stof(readtext);
	readtext = fgets(readfrik);
	exec_vwalk1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta2 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta3 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta4 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta5 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta6 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta7 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta8 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta9 = stof(readtext);
	readtext = fgets(readfrik);
	exec_atta10 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb2 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb3 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb4 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb5 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb6 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb7 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb8 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb9 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attb10 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc2 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc3 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc4 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc5 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc6 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc7 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc8 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc9 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attc10 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd2 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd3 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd4 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd5 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd6 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd7 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd8 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd9 = stof(readtext);
	readtext = fgets(readfrik);
	exec_attd10 = stof(readtext);
	readtext = fgets(readfrik);
	exec_charge1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_charge2 = stof(readtext);
	readtext = fgets(readfrik);
	exec_charge3 = stof(readtext);
	readtext = fgets(readfrik);
	exec_charge4 = stof(readtext);
	readtext = fgets(readfrik);
	exec_charge5 = stof(readtext);
	readtext = fgets(readfrik);
	exec_charge6 = stof(readtext);
	readtext = fgets(readfrik);
	exec_chsh1 = stof(readtext);
	readtext = fgets(readfrik);
	exec_chsh2 = stof(readtext);
	readtext = fgets(readfrik);
	exec_chsh3 = stof(readtext);
	readtext = fgets(readfrik);
	exec_chsh4 = stof(readtext);
	readtext = fgets(readfrik);
	exec_chsh5 = stof(readtext);
	readtext = fgets(readfrik);
	exec_chsh6 = stof(readtext);
	fclose(readfrik);

};

float fn_vwalk1;
float fn_vwalk2;
float fn_vwalk3;
float fn_vwalk4;
float fn_vwalk5;
float fn_vwalk6;
float fn_vwalk7;
float fn_vwalk8;
float fn_vwalk9;
float fn_vwalk10;
float fn_vwalk11;
float fn_vwalk12;
float fn_vwalk13;
float fn_vwalk14;
float fn_vwalk15;
float fn_vwalk16;
float fn_vwalk17;
float fn_vwalk18;
float fn_vwalk19;
float fn_vwalk20;

void() check_fallen2 = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/fallen_vel.txt", FILE_READ);
	readtext = fgets(readfrik);
	fn_vwalk1 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk2 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk3 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk4 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk5 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk6 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk7 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk8 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk9 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk10 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk11 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk12 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk13 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk14 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk15 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk16 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk17 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk18 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk19 = stof(readtext);
	readtext = fgets(readfrik);
	fn_vwalk20 = stof(readtext);
	readtext = fgets(readfrik);
	fclose(readfrik);
};

///////////////////////////

float dummyhealth;
float dummyws;
float dummywth;
float dummyrs;
float dummyrt;
float dummyattp;
float dummyad;
float dummyat;
float dummyath;
float dummypat;
float dummysad;
float dummysat;
float dummyspat;
float dummydtp;
float dummypt;
float dummypth;
vector dummybbox;

void() check_dummy = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/dummy.txt", FILE_READ);
	readtext = fgets(readfrik);
	dummyhealth = stof(readtext);	//helath
	readtext = fgets(readfrik);
	dummyws = stof(readtext);	//walk speed
	readtext = fgets(readfrik);
	dummywth = stof(readtext);	//walk chance to attack (?? has no sense)
	readtext = fgets(readfrik);
	dummyrs = stof(readtext);	//run speed
	readtext = fgets(readfrik);
	dummyrt = stof(readtext);	//run time cycle
	readtext = fgets(readfrik);
	dummyattp = stof(readtext);	//attack type
	readtext = fgets(readfrik);
	dummyad = stof(readtext);	//attack damage (projectile)
	readtext = fgets(readfrik);
	dummyat = stof(readtext);	//attack time (projectile)
	readtext = fgets(readfrik);
	dummyath = stof(readtext);	// chance to attack
	readtext = fgets(readfrik);
	dummypat = stof(readtext);	//preattack time (projectile)
	readtext = fgets(readfrik);
	dummysad = stof(readtext);	//sattack damage (projectile)
	readtext = fgets(readfrik);
	dummysat = stof(readtext);	//sattack time (projectile)
	readtext = fgets(readfrik);
	dummyspat = stof(readtext);	//spreattack time (projectile)
	readtext = fgets(readfrik);
	dummydtp = stof(readtext);	// damage to pain
	readtext = fgets(readfrik);
	dummypt = stof(readtext);	// pain time
	readtext = fgets(readfrik);
	dummypth = stof(readtext);	// pain think chance (run or attack)
	readtext = fgets(readfrik);
	dummybbox = stov(readtext);	//size (origin is in center)
	fclose(readfrik);
};

///////////////////////////

float invader_health;
float invader_ws;
float invader_wth;
float invader_rs;
float invader_rt;
float invader_rth;	//runing think
float invader_attp;
float invader_ad;
float invader_at;
float invader_ath;
float invader_pat;
float invader_sad;
float invader_sat;
float invader_spat;
float invader_dtp;
float invader_pt;
float invader_pth;
vector invader_bbox;
float invader_nproj;
float invader_shotgun_spread1;
float invader_projvel;
float invader_lungevel;
float invader_far;
float invader_mid;
float invader_near;
float invader_rtp;	//roll to pain
float invader_zzc;
float invader_zzd;
float invader_zzmd;
float invader_itadr;
float invader_gdv;

void() check_invader = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/invader.txt", FILE_READ);
	readtext = fgets(readfrik);
	invader_health = stof(readtext);
	readtext = fgets(readfrik);
	invader_ws = stof(readtext);
	readtext = fgets(readfrik);
	invader_wth = stof(readtext);
	readtext = fgets(readfrik);
	invader_rs = stof(readtext);
	readtext = fgets(readfrik);
	invader_rt = stof(readtext);
	readtext = fgets(readfrik);
	invader_rth = stof(readtext);	// runing think
	readtext = fgets(readfrik);
	invader_attp = stof(readtext);
	readtext = fgets(readfrik);
	invader_ad = stof(readtext);
	readtext = fgets(readfrik);
	invader_at = stof(readtext);
	readtext = fgets(readfrik);
	invader_ath = stof(readtext);	// chance to attack
	readtext = fgets(readfrik);
	invader_pat = stof(readtext);
	readtext = fgets(readfrik);
	invader_sad = stof(readtext);
	readtext = fgets(readfrik);
	invader_sat = stof(readtext);
	readtext = fgets(readfrik);
	invader_spat = stof(readtext);
	readtext = fgets(readfrik);
	invader_dtp = stof(readtext);
	readtext = fgets(readfrik);
	invader_pt = stof(readtext);
	readtext = fgets(readfrik);
	invader_pth = stof(readtext);
	readtext = fgets(readfrik);
	invader_bbox = stov(readtext);
	readtext = fgets(readfrik);
	invader_nproj = stof(readtext);
	readtext = fgets(readfrik);
	invader_shotgun_spread1 = stof(readtext);
	readtext = fgets(readfrik);
	invader_projvel = stof(readtext);
	readtext = fgets(readfrik);
	invader_lungevel = stof(readtext);
	readtext = fgets(readfrik);
	invader_far = stof(readtext);
	readtext = fgets(readfrik);
	invader_mid = stof(readtext);
	readtext = fgets(readfrik);
	invader_near = stof(readtext);
	readtext = fgets(readfrik);
	invader_rtp = stof(readtext);
	readtext = fgets(readfrik);
	invader_zzc = stof(readtext);
	readtext = fgets(readfrik);
	invader_zzd = stof(readtext);
	readtext = fgets(readfrik);
	invader_zzmd = stof(readtext);
	readtext = fgets(readfrik);
	invader_itadr = stof(readtext);
	readtext = fgets(readfrik);
	invader_gdv = stof(readtext);
	fclose(readfrik);
};

vector inv_gib1;
vector inv_gib2;
vector inv_gib3;
vector inv_gib4;
vector inv_gib5;
vector inv_gib6;
vector inv_gib7;
vector inv_gib8;
vector inv_gib9;
vector inv_gib10;
vector inv_gib11;
vector inv_gib12;
vector inv_gib13;
vector inv_gib14;
vector inv_gib15;
vector inv_gib16;
vector inv_gib17;
vector inv_gib18;
vector inv_gib19;
vector inv_gib20;

void() check_invader_gibs = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/invader_gibs.txt", FILE_READ);
	readtext = fgets(readfrik);
	inv_gib1 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib2 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib3 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib4 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib5 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib6 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib7 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib8 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib9 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib10 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib11 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib12 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib13 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib14 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib15 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib16 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib17 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib18 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib19 = stov(readtext);
	readtext = fgets(readfrik);
	inv_gib20 = stov(readtext);

	fclose(readfrik);
};

///////////////////////////

float wretch_health;
float wretch_ws;
float wretch_wth;
float wretch_rs;
float wretch_rt;
float wretch_rth;	//runing think
float wretch_attp;
float wretch_ad;
float wretch_at;
float wretch_ath;
float wretch_pat;
float wretch_sad;
float wretch_sat;
float wretch_spat;
float wretch_dtp;
float wretch_pt;
float wretch_pth;
vector wretch_bbox;
float wretch_far;
float wretch_mid;
float wretch_near;
float wretch_projvel;
float wretch_rtp;	//roll to pain
float wretch_dtg;	//roll to pain
float wretch_rtsh; 
float wretch_zzc;
float wretch_zzd;
float wretch_zzmd;
float wretch_itadr;
float wretch_sht; 
float wretch_shv; 
float wretch_shvb; 
float wretch_shsps;
//float wretch_shg;	// spining head gravity
//vector wretch_shkv;	// kick velocity
vector wretch_shbbox;
vector wretch_shbboxn;
float wretch_explo_damage; 
float wretch_explo_damage_player; 
float wretch_explo_radius; 
float wretch_pushfactor; 
float wretch_shg;	// spining head gravity
vector wretch_shkv;	// kick velocity

void() check_wretch = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/wretch.txt", FILE_READ);
	readtext = fgets(readfrik);
	wretch_health = stof(readtext);
	readtext = fgets(readfrik);
	wretch_ws = stof(readtext);
	readtext = fgets(readfrik);
	wretch_wth = stof(readtext);
	readtext = fgets(readfrik);
	wretch_rs = stof(readtext);
	readtext = fgets(readfrik);
	wretch_rt = stof(readtext);
	readtext = fgets(readfrik);
	wretch_rth = stof(readtext);	// runing think
	readtext = fgets(readfrik);
	wretch_attp = stof(readtext);
	readtext = fgets(readfrik);
	wretch_ad = stof(readtext);
	readtext = fgets(readfrik);
	wretch_at = stof(readtext);
	readtext = fgets(readfrik);
	wretch_ath = stof(readtext);	// chance to attack
	readtext = fgets(readfrik);
	wretch_pat = stof(readtext);
	readtext = fgets(readfrik);
	wretch_sad = stof(readtext);
	readtext = fgets(readfrik);
	wretch_sat = stof(readtext);
	readtext = fgets(readfrik);
	wretch_spat = stof(readtext);
	readtext = fgets(readfrik);
	wretch_dtp = stof(readtext);
	readtext = fgets(readfrik);
	wretch_pt = stof(readtext);
	readtext = fgets(readfrik);
	wretch_pth = stof(readtext);
	readtext = fgets(readfrik);
	wretch_bbox = stov(readtext);
	readtext = fgets(readfrik);
	wretch_far = stof(readtext);
	readtext = fgets(readfrik);
	wretch_mid = stof(readtext);
	readtext = fgets(readfrik);
	wretch_near = stof(readtext);
	readtext = fgets(readfrik);
	wretch_projvel = stof(readtext);
	readtext = fgets(readfrik);
	wretch_rtp = stof(readtext);
	readtext = fgets(readfrik);
	wretch_dtg = stof(readtext);
	readtext = fgets(readfrik);
	wretch_rtsh = stof(readtext);
	readtext = fgets(readfrik);
	wretch_zzc = stof(readtext);
	readtext = fgets(readfrik);
	wretch_zzd = stof(readtext);
	readtext = fgets(readfrik);
	wretch_zzmd = stof(readtext);
	readtext = fgets(readfrik);
	wretch_itadr = stof(readtext);
	readtext = fgets(readfrik);
	wretch_sht = stof(readtext);
	readtext = fgets(readfrik);
	wretch_shv = stof(readtext);
	readtext = fgets(readfrik);
	wretch_shvb = stof(readtext);
	readtext = fgets(readfrik);
	wretch_shsps = stof(readtext);// spning head shoots per second
	readtext = fgets(readfrik);
	wretch_shg = stof(readtext);
	readtext = fgets(readfrik);
	wretch_shkv = stov(readtext);
	readtext = fgets(readfrik);
	wretch_shbbox = stov(readtext);
	readtext = fgets(readfrik);
	wretch_shbboxn = stov(readtext);
	readtext = fgets(readfrik);
	wretch_explo_damage = stof(readtext);
	readtext = fgets(readfrik);
	wretch_explo_damage_player = stof(readtext);
	readtext = fgets(readfrik);
	wretch_explo_radius = stof(readtext);
	readtext = fgets(readfrik);
	wretch_pushfactor = stof(readtext);
	fclose(readfrik);
};
vector wre_gib1;
vector wre_gib2;
vector wre_gib3;
vector wre_gib4;
vector wre_gib5;
vector wre_gib6;
vector wre_gib7;
vector wre_gib8;
vector wre_gib9;
vector wre_gib10;
vector wre_gib11;
vector wre_gib12;
vector wre_gib13;
vector wre_gib14;
vector wre_gib15;
vector wre_gib16;
vector wre_gib17;
vector wre_gib18;
vector wre_gib19;
vector wre_gib20;
vector wre_gib21;
vector wre_gib22;
vector wre_gib23;
vector wre_gib24;
vector wre_gib25;

void() check_wretch_gibs = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/wretch_gibs.txt", FILE_READ);
	readtext = fgets(readfrik);
	wre_gib1 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib2 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib3 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib4 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib5 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib6 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib7 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib8 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib9 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib10 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib11 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib12 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib13 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib14 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib15 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib16 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib17 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib18 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib19 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib20 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib21 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib22 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib23 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib24 = stov(readtext);
	readtext = fgets(readfrik);
	wre_gib25 = stov(readtext);
	fclose(readfrik);
};
/////////////////////////////////////////

float incisor_health;
float incisor_ws;
float incisor_wth;
float incisor_rs;
float incisor_rt;
float incisor_rth;	//runing think
float incisor_attp;
float incisor_ad;
float incisor_at;
float incisor_ath;
float incisor_pat;
float incisor_sad;
float incisor_sat;
float incisor_spat;
float incisor_dtp;
float incisor_pt;
float incisor_pth;
vector incisor_bbox;
float incisor_far;
float incisor_mid;
float incisor_near;
float incisor_projvel;
float incisor_firerate;
float incisor_projcount;
float incisor_rtp;	//roll to pain
float incisor_zzc;
float incisor_zzd;
float incisor_zzmd;
float incisor_itadr;

void() check_incisor = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/incisor.txt", FILE_READ);
	readtext = fgets(readfrik);
	incisor_health = stof(readtext);
	readtext = fgets(readfrik);
	incisor_ws = stof(readtext);
	readtext = fgets(readfrik);
	incisor_wth = stof(readtext);
	readtext = fgets(readfrik);
	incisor_rs = stof(readtext);
	readtext = fgets(readfrik);
	incisor_rt = stof(readtext);
	readtext = fgets(readfrik);
	incisor_rth = stof(readtext);	// runing think
	readtext = fgets(readfrik);
	incisor_attp = stof(readtext);
	readtext = fgets(readfrik);
	incisor_ad = stof(readtext);
	readtext = fgets(readfrik);
	incisor_at = stof(readtext);
	readtext = fgets(readfrik);
	incisor_ath = stof(readtext);	// chance to attack
	readtext = fgets(readfrik);
	incisor_pat = stof(readtext);
	readtext = fgets(readfrik);
	incisor_sad = stof(readtext);
	readtext = fgets(readfrik);
	incisor_sat = stof(readtext);
	readtext = fgets(readfrik);
	incisor_spat = stof(readtext);
	readtext = fgets(readfrik);
	incisor_dtp = stof(readtext);
	readtext = fgets(readfrik);
	incisor_pt = stof(readtext);
	readtext = fgets(readfrik);
	incisor_pth = stof(readtext);
	readtext = fgets(readfrik);
	incisor_bbox = stov(readtext);
	readtext = fgets(readfrik);
	incisor_far = stof(readtext);
	readtext = fgets(readfrik);
	incisor_mid = stof(readtext);
	readtext = fgets(readfrik);
	incisor_near = stof(readtext);
	readtext = fgets(readfrik);
	incisor_projvel = stof(readtext);
	readtext = fgets(readfrik);
	incisor_firerate = stof(readtext);
	readtext = fgets(readfrik);
	incisor_projcount = stof(readtext);
	readtext = fgets(readfrik);
	incisor_rtp = stof(readtext);
	readtext = fgets(readfrik);
	incisor_zzc = stof(readtext);
	readtext = fgets(readfrik);
	incisor_zzd = stof(readtext);
	readtext = fgets(readfrik);
	incisor_zzmd = stof(readtext);
	readtext = fgets(readfrik);
	incisor_itadr = stof(readtext);

	fclose(readfrik);
};

////////////////
///////////////////////////

float stricken_health;
float stricken_wth;
float stricken_rth;	//runing think
float stricken_ad;
float stricken_ath;
float stricken_sad;
float stricken_dtp;
float stricken_pth;
vector stricken_bbox;
vector stricken_nbbox;
float stricken_far;
float stricken_mid;
float stricken_near;
float stricken_projvel;
float stricken_splashdmg;
float stricken_splashradius;
float stricken_rtp;	//roll to pain
float stricken_zzc;
float stricken_zzd;
float stricken_zzmd;
float stricken_heightstep;
float stricken_lowhealth;
float stricken_spreadintensity;
float stricken_dexplosionradius;
float stricken_dexplosiondamage;
float stricken_dexplosiondamagemonsters;
float stricken_walkradius;
float stricken_damagetomonsters;
float stricken_pushfactor;

void() check_stricken = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/stricken.txt", FILE_READ);
	readtext = fgets(readfrik);
	stricken_health = stof(readtext);	// health
	readtext = fgets(readfrik);
	stricken_wth = stof(readtext);	// walking think
	readtext = fgets(readfrik);
	stricken_rth = stof(readtext);	// runing think
	readtext = fgets(readfrik);
	stricken_ad = stof(readtext);	// attack damage
	readtext = fgets(readfrik);
	stricken_ath = stof(readtext);	// attack think
	readtext = fgets(readfrik);
	stricken_sad = stof(readtext);	// secondary attack damage
	readtext = fgets(readfrik);
	stricken_dtp = stof(readtext);	//damage to pain
	readtext = fgets(readfrik);
	stricken_rtp = stof(readtext);	// pain chance
	readtext = fgets(readfrik);
	stricken_pth = stof(readtext);	// chance pain to run or attack
	readtext = fgets(readfrik);
	stricken_bbox = stov(readtext);	/// boox
	readtext = fgets(readfrik);
	stricken_nbbox = stov(readtext);	/// boox
	readtext = fgets(readfrik);
	stricken_far = stof(readtext);	// far
	readtext = fgets(readfrik);
	stricken_mid = stof(readtext);	// mid
	readtext = fgets(readfrik);
	stricken_near = stof(readtext);	// close
	readtext = fgets(readfrik);
	stricken_projvel = stof(readtext);	// projectile velocity
	readtext = fgets(readfrik);
	stricken_splashdmg = stof(readtext);	//    splash damage
	readtext = fgets(readfrik);
	stricken_splashradius = stof(readtext);	//    splash radius
	readtext = fgets(readfrik);
	stricken_zzc = stof(readtext);	//    zigzag chance
	readtext = fgets(readfrik);
	stricken_zzd = stof(readtext);	//    zigzag max deviance
	readtext = fgets(readfrik);
	stricken_zzmd = stof(readtext);	//    zigzag min deviance
	readtext = fgets(readfrik);
	stricken_heightstep = stof(readtext);	//    stepheight
	readtext = fgets(readfrik);
	stricken_lowhealth = stof(readtext);	//   low health
	readtext = fgets(readfrik);
	stricken_spreadintensity = stof(readtext);	//   spread low health projectile
	readtext = fgets(readfrik);
	stricken_dexplosionradius = stof(readtext);	//   
	readtext = fgets(readfrik);
	stricken_dexplosiondamage = stof(readtext);	//   
	readtext = fgets(readfrik);
	stricken_dexplosiondamagemonsters = stof(readtext);	//   
	readtext = fgets(readfrik);
	stricken_walkradius = stof(readtext);	//   
	readtext = fgets(readfrik);
	stricken_damagetomonsters = stof(readtext);	//  
	readtext = fgets(readfrik);
	stricken_pushfactor = stof(readtext);	//  

	fclose(readfrik);
};

vector str_gib1;
vector str_gib2;
vector str_gib3;
vector str_gib4;
vector str_gib5;
vector str_gib6;
vector str_gib7;
vector str_gib8;
vector str_gib9;
vector str_gib10;
vector str_gib11;
vector str_gib12;
vector str_gib13;
vector str_gib14;
vector str_gib15;
vector str_gib16;
vector str_gib17;
vector str_gib18;
vector str_gib19;
vector str_gib20;

void() check_stricken_gibs = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/stricken_gibs.txt", FILE_READ);
	readtext = fgets(readfrik);
	str_gib1 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib2 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib3 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib4 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib5 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib6 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib7 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib8 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib9 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib10 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib11 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib12 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib13 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib14 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib15 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib16 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib17 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib18 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib19 = stov(readtext);
	readtext = fgets(readfrik);
	str_gib20 = stov(readtext);

	fclose(readfrik);
};
///////////////////////////

float heretic_health;
float heretic_ith;
float heretic_ws;
float heretic_wth;
float heretic_rs;
float heretic_rt;
float heretic_rth;	//runing think
float heretic_ad;
float heretic_ath;
float heretic_sad;
float heretic_dtp;
float heretic_pth;
vector heretic_bbox;
float heretic_far;
float heretic_mid;
float heretic_near;
float heretic_projvel;
float heretic_rsr;
float heretic_rtp;	//roll to pain
float heretic_zzc;
float heretic_zzd;
float heretic_zzmd;
float her_radius;
float her_chargetime;
void() check_heretic = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/heretic.txt", FILE_READ);
	readtext = fgets(readfrik);
	heretic_health = stof(readtext);	// health
	readtext = fgets(readfrik);
	heretic_ws = stof(readtext);	// walk speed
	readtext = fgets(readfrik);
	heretic_wth = stof(readtext);	//  walk think
	readtext = fgets(readfrik);
	heretic_ith = stof(readtext);	// health
	readtext = fgets(readfrik);
	heretic_rs = stof(readtext);	// run speed
	readtext = fgets(readfrik);
	heretic_rt = stof(readtext);	/// runc cycle duration
	readtext = fgets(readfrik);
	heretic_rth = stof(readtext);	// runing think
	readtext = fgets(readfrik);
	heretic_rsr = stof(readtext);	// chase speed
	readtext = fgets(readfrik);
	heretic_projvel = stof(readtext);	// projectile vel
	readtext = fgets(readfrik);
	heretic_ad = stof(readtext);	// projectile damage	
	readtext = fgets(readfrik);
	heretic_ath = stof(readtext);	// chance to attack after attack
	readtext = fgets(readfrik);
	heretic_sad = stof(readtext);	// melee attack camage
	readtext = fgets(readfrik);
	heretic_dtp = stof(readtext);	// damage to pain
	readtext = fgets(readfrik);
	heretic_rtp = stof(readtext);	// painchance
	readtext = fgets(readfrik);
	heretic_pth = stof(readtext);	// pain think
	readtext = fgets(readfrik);
	heretic_bbox = stov(readtext);	// boox
	readtext = fgets(readfrik);
	heretic_far = stof(readtext);	// far
	readtext = fgets(readfrik);
	heretic_mid = stof(readtext);	// mid
	readtext = fgets(readfrik);
	heretic_near = stof(readtext);	// near
	readtext = fgets(readfrik);
	heretic_zzc = stof(readtext);
	readtext = fgets(readfrik);
	heretic_zzd = stof(readtext);
	readtext = fgets(readfrik);
	heretic_zzmd = stof(readtext);
	readtext = fgets(readfrik);
	her_radius = stof(readtext);
	readtext = fgets(readfrik);
	her_chargetime = stof(readtext);

	fclose(readfrik);
};

vector her_gib1;
vector her_gib2;
vector her_gib3;
vector her_gib4;
vector her_gib5;
vector her_gib6;
vector her_gib7;
vector her_gib8;
vector her_gib9;
vector her_gib10;
vector her_gib11;
vector her_gib12;
vector her_gib13;
vector her_gib14;
vector her_gib15;
vector her_gib16;
vector her_gib17;
vector her_gib18;
vector her_gib19;
vector her_gib20;

void() check_heretic_gibs = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/heretic_gibs.txt", FILE_READ);
	readtext = fgets(readfrik);
	her_gib1 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib2 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib3 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib4 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib5 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib6 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib7 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib8 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib9 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib10 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib11 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib12 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib13 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib14 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib15 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib16 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib17 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib18 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib19 = stov(readtext);
	readtext = fgets(readfrik);
	her_gib20 = stov(readtext);

	fclose(readfrik);
};

//////////////////////
///////////////////////////
.float zigzag_time;
.float zigzaging;
.float zigzagdeviance;

float widow_health;
float widow_ws;
float widow_wth;
float widow_rs;
float widow_rt;
float widow_rth;	//runing think
float widow_attp;
float widow_ad;
float widow_at;
float widow_ath;
float widow_pat;
float widow_sad;
float widow_sat;
float widow_spat;
float widow_dtp;
float widow_pt;
float widow_pth;
vector widow_bbox;
float widow_far;
float widow_mid;
float widow_near;
float widow_projvel;
float widow_rtp;	//roll to pain
float widow_zzc;
float widow_zzd;
float widow_zzmd;
float widow_itadr;

.float wknd;

float widod;
vector widowbbox;
vector widownbbox;
float widowhealth;
float widowdamage;
float widpl;
float widpm;
float widph;



void() check_wd_vel = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/widow_vel.txt", FILE_READ);
	readtext = fgets(readfrik);
	widowhealth = stof(readtext);
	readtext = fgets(readfrik);
	widowdamage = stof(readtext);
	readtext = fgets(readfrik);
	widownbbox = stov(readtext);
	readtext = fgets(readfrik);
	widowbbox = stov(readtext);
	readtext = fgets(readfrik);
	widpl = stof(readtext);
	readtext = fgets(readfrik);
	widpm = stof(readtext);
	readtext = fgets(readfrik);
	widph = stof(readtext);
	readtext = fgets(readfrik);
	widod = stof(readtext);
	fclose(readfrik);
};


void() check_widow = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/widow.txt", FILE_READ);
	readtext = fgets(readfrik);
	widow_health = stof(readtext);
	readtext = fgets(readfrik);
	widow_ws = stof(readtext);
	readtext = fgets(readfrik);
	widow_wth = stof(readtext);
	readtext = fgets(readfrik);
	widow_rs = stof(readtext);
	readtext = fgets(readfrik);
	widow_rt = stof(readtext);
	readtext = fgets(readfrik);
	widow_rth = stof(readtext);	// runing think
	readtext = fgets(readfrik);
	widow_attp = stof(readtext);
	readtext = fgets(readfrik);
	widow_ad = stof(readtext);
	readtext = fgets(readfrik);
	widow_at = stof(readtext);
	readtext = fgets(readfrik);
	widow_ath = stof(readtext);	// chance to attack
	readtext = fgets(readfrik);
	widow_pat = stof(readtext);
	readtext = fgets(readfrik);
	widow_sad = stof(readtext);
	readtext = fgets(readfrik);
	widow_sat = stof(readtext);
	readtext = fgets(readfrik);
	widow_spat = stof(readtext);
	readtext = fgets(readfrik);
	widow_dtp = stof(readtext);
	readtext = fgets(readfrik);
	widow_pt = stof(readtext);
	readtext = fgets(readfrik);
	widow_pth = stof(readtext);
	readtext = fgets(readfrik);
	widow_bbox = stov(readtext);
	readtext = fgets(readfrik);
	widow_far = stof(readtext);
	readtext = fgets(readfrik);
	widow_mid = stof(readtext);
	readtext = fgets(readfrik);
	widow_near = stof(readtext);
	readtext = fgets(readfrik);
	widow_projvel = stof(readtext);
	readtext = fgets(readfrik);
	widow_rtp = stof(readtext);
	readtext = fgets(readfrik);
	widow_zzc = stof(readtext);
	readtext = fgets(readfrik);
	widow_zzd = stof(readtext);
	readtext = fgets(readfrik);
	widow_zzmd = stof(readtext);
	readtext = fgets(readfrik);
	widow_itadr = stof(readtext);

	fclose(readfrik);
};



float incisorod;
vector incisorbbox;
vector incisornbbox;
float incisorhealth;
float incisordamage;
float incisorpl;
float incisorpm;
float incisorph;



void() check_incisor_vel = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/incisor_vel.txt", FILE_READ);
	readtext = fgets(readfrik);
	incisorhealth = stof(readtext);
	readtext = fgets(readfrik);
	incisordamage = stof(readtext);
	readtext = fgets(readfrik);
	incisornbbox = stov(readtext);
	readtext = fgets(readfrik);
	incisorbbox = stov(readtext);
	readtext = fgets(readfrik);
	incisorpl = stof(readtext);
	readtext = fgets(readfrik);
	incisorpm = stof(readtext);
	readtext = fgets(readfrik);
	incisorph = stof(readtext);
	readtext = fgets(readfrik);
	incisorod = stof(readtext);
	fclose(readfrik);
};


float wraith_health;
float wraith_damage;
void() check_wraith = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/wraith.txt", FILE_READ);
	readtext = fgets(readfrik);
	wraith_health = stof(readtext);
	readtext = fgets(readfrik);
	wraith_damage = stof(readtext);

	fclose(readfrik);
};



float symbol_health;
float symbol_walkspeed;
float symbol_runspeed;
float symbol_runsidespeed;
float symbol_upspeed;
float symbol_damage;
float symbol_proj_speed;
float symbol_proj_aceleration;
float symbol_proj_angle;
float symbol_dtp;
float symbol_far;
float symbol_mid;
float symbol_near;
vector symbol_bbox;
vector symbol_bboxn;

void() check_symbol = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/symbol.txt", FILE_READ);
	readtext = fgets(readfrik);
	symbol_health = stof(readtext);	//helath
	readtext = fgets(readfrik);
	symbol_walkspeed = stof(readtext);	//walk speed
	readtext = fgets(readfrik);
	symbol_runspeed = stof(readtext);	//run speed
	readtext = fgets(readfrik);
	symbol_runsidespeed = stof(readtext);	//run speed
	readtext = fgets(readfrik);
	symbol_upspeed = stof(readtext);	//run speed
	readtext = fgets(readfrik);
	symbol_damage = stof(readtext);	//damage
	readtext = fgets(readfrik);
	symbol_proj_speed = stof(readtext);	//symbol projectile speed
	readtext = fgets(readfrik);
	symbol_proj_aceleration = stof(readtext);	//symbol projectile aceleration
	readtext = fgets(readfrik);
	symbol_proj_angle = stof(readtext);	//symbol projectile angle factor
	readtext = fgets(readfrik);
	symbol_dtp = stof(readtext);	//symbol damage to pain
	readtext = fgets(readfrik);
	symbol_far = stof(readtext);
	readtext = fgets(readfrik);
	symbol_mid = stof(readtext);
	readtext = fgets(readfrik);
	symbol_near = stof(readtext);
	readtext = fgets(readfrik);
	symbol_bbox = stov(readtext);	//size (origin is in center)
	readtext = fgets(readfrik);
	symbol_bboxn = stov(readtext);	//size negative (origin is in center)
	fclose(readfrik);
};
float martyr_health;
float martyr_radius;
float martyr_orb_offset;
float martyr_flight_dist;

void() check_martyr = { local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/martyr.txt", FILE_READ);
	readtext = fgets(readfrik);
	martyr_health = stof(readtext);	// health
	readtext = fgets(readfrik);
	martyr_radius = stof(readtext);	// 
	readtext = fgets(readfrik);
	martyr_orb_offset = stof(readtext);	// 
	readtext = fgets(readfrik);
	martyr_flight_dist = stof(readtext);	// 

	fclose(readfrik);
};

float boss1_proj1_vel;
float boss1_proj1_dd;
float boss1_proj1_sd;
float boss1_proj1_rv;

float boss1_proj1_ammount;
float boss1_proj1_angle;

float boss1_proj2_vel;
float boss1_proj2_homingcount;
float boss1_proj2_dd;
float boss1_proj2_sd;
float boss1_proj2_rv;

void() check_boss1 = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/boss1.txt", FILE_READ);
	readtext = fgets(readfrik);
	boss1_proj1_vel = stof(readtext);	// speed
	readtext = fgets(readfrik);

	boss1_proj1_dd = stof(readtext);	// direct damage
	readtext = fgets(readfrik);
	boss1_proj1_sd = stof(readtext);	// damage splash
	readtext = fgets(readfrik);
	boss1_proj1_rv = stof(readtext);	// radius splash
	readtext = fgets(readfrik);

	boss1_proj1_ammount = stof(readtext);	// radius splash
	readtext = fgets(readfrik);

	boss1_proj1_angle = stof(readtext);	// radius splash
	readtext = fgets(readfrik);

	boss1_proj2_vel = stof(readtext);	// speed2
	readtext = fgets(readfrik);
	boss1_proj2_homingcount = stof(readtext);	// homing count 
	readtext = fgets(readfrik);
	boss1_proj2_dd = stof(readtext);	// direct damage
	readtext = fgets(readfrik);
	boss1_proj2_sd = stof(readtext);	// damage splash
	readtext = fgets(readfrik);
	boss1_proj2_rv = stof(readtext);	// radius splash
	readtext = fgets(readfrik);

	fclose(readfrik);
};


float boss2_healtha;
float boss2_healthb;
float boss2_speed;
float boss2_rottime;
float boss2_beamdamage;
float boss2_projdamage;
float boss2_projradius;
float boss2_projspeed;
float boss2_stage2transitiontime;

void() check_boss2 = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/boss2.txt", FILE_READ);
	readtext = fgets(readfrik);
	boss2_healtha = stof(readtext);
	readtext = fgets(readfrik);
	boss2_healthb = stof(readtext);
	readtext = fgets(readfrik);
	boss2_speed = stof(readtext);
	readtext = fgets(readfrik);
	boss2_rottime = stof(readtext);
	readtext = fgets(readfrik);
	boss2_beamdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss2_projdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss2_projradius = stof(readtext);
	readtext = fgets(readfrik);
	boss2_projspeed = stof(readtext);
	readtext = fgets(readfrik);
	boss2_stage2transitiontime = stof(readtext);

	fclose(readfrik);
};

float boss3_health;
float boss3_mutilationahealth;
float boss3_mutilationbhealth;
float boss3_mutilationchealth;
float boss3_pushdamage;
float boss3_regularprojdamage;
float boss3_regularprojsplashradius;
float boss3_regularprojsplashdamage;
float boss3_homingprojdamage;
float boss3_homingprojsplashradius;
float boss3_homingprojsplashdamage;
float boss3_fallennumbera;
float boss3_fallennumberb;
float boss3_fallennumberc;


void() check_boss3 = 
{ 
	local float readfrik;
	local string readtext;
	readfrik = fopen_wrath("enemies/boss3.txt", FILE_READ);
	readtext = fgets(readfrik);
	boss3_health = stof(readtext);
	readtext = fgets(readfrik);
	boss3_mutilationahealth = stof(readtext);
	readtext = fgets(readfrik);
	boss3_mutilationbhealth = stof(readtext);
	readtext = fgets(readfrik);
	boss3_mutilationchealth = stof(readtext);
	readtext = fgets(readfrik);
	boss3_pushdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss3_regularprojdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss3_regularprojsplashradius = stof(readtext);
	readtext = fgets(readfrik);
	boss3_regularprojsplashdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss3_homingprojdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss3_homingprojsplashradius = stof(readtext);
	readtext = fgets(readfrik);
	boss3_homingprojsplashdamage = stof(readtext);
	readtext = fgets(readfrik);
	boss3_fallennumbera = stof(readtext);
	readtext = fgets(readfrik);
	boss3_fallennumberb = stof(readtext);
	readtext = fgets(readfrik);
	boss3_fallennumberc = stof(readtext);
	fclose(readfrik);
};
////////////////////////////////////////////////////////////////////////

void() check_enemies_frik = { check_op_vel();
	check_af_vel();
	check_wd_vel();
	check_incisor_vel();
	check_exec_vel();
	check_damg_pain();
	//check_dummy();
	check_invader();
	check_wretch();
	check_incisor();
	check_stricken();
	check_heretic_gibs();
	check_invader_gibs();
	check_stricken_gibs();
	check_wretch_gibs();
	check_afflicted_gibs();
	check_heretic();
	check_fallen2();
	check_widow();
	check_wraith();
	check_symbol();
	check_martyr();
	check_boss1();
	check_boss2();
	check_boss3();
};
////////////////////////////
////////////////////////////////////////////////////////////////////////

void() Precache = { local float f;	// file handle, basically assigns a number to whatever file is open
	local string ln;	// ln = line of the file being read
	f = fopen_wrath("system/precache.txt", FILE_READ);	// opens "system/precache.txt" to be read
	if (f != -1)	// if f = -1 then the file could not be found
	{
		ln = fgets(f);	// this line sets ln to the string read from the file with the file handle of f
		while (ln != string_null)	// while there is still text to be read do the following
		{
			if (strstrofs(ln, ".wav", 0) != -1)	// this checks if the file extension is .wav for a sound file
				precache_sound(ln);	// if it is a sound, then it precaches said sound
			if (strstrofs(ln, ".ogg", 0) != -1)	// this checks if the file extension is .wav for a sound file
				precache_sound(ln);	// if it is a sound, then it precaches said sound
			if (strstrofs(ln, ".md3", 0) != -1)	// this checks if the file extension is .wav for a sound file
				precache_model(ln);	// so precache the model
			if (strstrofs(ln, ".mdl", 0) != -1)	// this checks if the file extension is .wav for a sound file
				precache_model(ln);	// so precache the model
			if (strstrofs(ln, ".spr", 0) != -1)	// this checks if the file extension is .wav for a sound file
				precache_model(ln);	// so precache the model
			ln = fgets(f);	// get a new line from the file
		}
	}

	fclose(f);	// when the while loop is over (no lines left in file) close file with the handle f
};

///////////////////////////////////end of qc file
