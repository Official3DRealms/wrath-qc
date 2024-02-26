$frame symbol_stand

$frame symbol_frwrd

$frame symbol_frwrdloop

$frame symbol_back

$frame symbol_backloop

$frame symbol_right

$frame symbol_rightloop

$frame symbol_left

$frame symbol_leftloop

$frame symbol_fly

$frame symbol_flytoattack


.float frame_time;
.float frame_active;

.float symbol_projectile_count;
.float symbol_projectilea;
.float symbol_projectileb;
.float symbol_projectilec;
.float symbol_projectiled;

void() symb_run1;
//void() symb_side1;

//void()symb_left1;
//void()symb_right1;


void()	symbolAttackFinished =
{
	self.symbol_projectile_count = 0;
	self.colormod = '1 1 1';
	self.frame_time = 0;
	self.frame_active = 0;
	self.think = symb_run1;
};

void() projectile_symbol_touch = 
{ 
	local float damg;
	if (other == self.owner)
		return;
	if(other.solid == SOLID_TRIGGER)
		return;
	if(other.wrathflags & FL_PROJECTILE)
		return;
	

	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = symbol_damage;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	setmodel(self, "models/projectiles/proj_slag1_explo.md3");
	sound7(self, CHAN_BODY, "enemies/symbol/impact.ogg", 1, 0.25, random(75,100), 0);
	self.touch = SUB_Null;
	self.nextthink = time;
	self.movetype = 0; 
	self.think = slag_explode1;
};

void() symbol_proj_think =
{

	float speed = vlen (self.velocity);
	if(speed < symbol_proj_speed * symbol_proj_aceleration)
		self.velocity = self.velocity * 1.1; 

	if(speed < 10)
	self.lifetime = 0;

	if((self.lifetime < time ) || (speed < 10))
	{	
		self.movetype = 0; 
		self.think = slag_explode1;
		sound7(self, CHAN_BODY, "enemies/symbol/impact.ogg", 1, 0.25, random(80,120), 0);
	}
	else
		self.think = symbol_proj_think;
	self.nextthink = time + 0.05;

};
void() symbol_proj_prethink =
{
	sound7(self, CHAN_WEAPON, "items/artifacts/artifactG_pickup.ogg", 1, 0.1, random(150,175), 0);
	sound(self, CHAN_BODY, "enemies/symbol/proj_loop.ogg", 1, 0.33);
	self.think = symbol_proj_think;
	self.nextthink = time;
};

.vector projectile_old_velocity;
void(entity e, string tagname, float spread, float enemyorigin) symbol_missileattack = 
{ 
	e.effects = EF_MUZZLEFLASH;

	local entity projectile;
	projectile = spawn();
	projectile.owner = e;
	setmodel(projectile, "models/projectiles/proj_symbol.md3");
	projectile.traileffectnum = particleeffectnum("oppressor_proj_trail");
	local vector tagorg;
	makevectors (self.angles);
	tagorg = tag_origin(tagname, e);
	projectile.classname = "symbol_projectile";
	projectile.origin = tagorg + v_forward * 6;
	projectile.wrathflags += FL_PROJECTILE;
	//projectile.effects = EF_ADDITIVE + 128;
	projectile.solid = SOLID_TRIGGER;
	projectile.movetype = MOVETYPE_FLYMISSILE;
	projectile.lifetime = time + 15;
	setsize (projectile,'-16 -16 -16','16 16 16');


	if(enemyorigin == 1)
    {
		float playerspeed = (vlen (self.enemy.velocity));
		vector nextpos = (normalize (self.enemy.velocity)) * playerspeed;	
		vector newplayerorg = self.enemy.origin + '0 0 12' + (nextpos * 0.3);
		self.projectile_old_velocity = newplayerorg;
	}
	else
		newplayerorg = self.projectile_old_velocity;


	vector pvec = newplayerorg;
	if (spread)
		vector vec = normalize(pvec - (self.origin + v_right * 12 * spread));
	else
		vec = normalize(pvec - self.origin);

		projectile.velocity = vec * (symbol_proj_speed + spread * 10);
	projectile.think = symbol_proj_prethink;
	projectile.nextthink = time + random(0.01,0.05);
	projectile.angles = vectoangles(projectile.velocity);
	projectile.touch = projectile_symbol_touch;

};

void() symb_idlesound =
{
	local float wr;
	wr = random() * 5;

	if (self.waitmin < time)
	{
	 	self.waitmin = time + 2;
	 	if (wr > 4.5) 
	 		sound (self, CHAN_VOICE, "symbol/widle1.wav", 1,  ATTN_IDLE);

	 	if (wr < 1.5)
	 		sound (self, CHAN_VOICE, "symbol/widle2.wav", 1, ATTN_IDLE);
	}
	return;
};

void()	symb_stand1	=
{
	if(self.frame_time < time)
	{	
		self.frame = $symbol_stand;
		self.frame_time = time + 3;
		symb_idlesound();
	}
	self.think = symb_stand1;
	ai_stand();
	self.nextthink = time + 0.1;
};

void()	symb_walk2	=
{
	if(self.frame_time <= time) 
	{	
		self.frame = $symbol_frwrdloop;
		self.frame_time = time + 0.5;
		symb_idlesound();
	}
	self.think = symb_walk2;
	ai_walk(symbol_walkspeed);
	self.nextthink = time + 0.05;
};

void()	symb_walk1	=
{
	self.colormod = '1 1 3';
	if(self.frame_time <= time)
	{	
		if(self.frame_active != 1)
		{
			self.frame = $symbol_frwrdloop;
			self.frame_time = time + 0.5;
			self.frame_active = 1;
			self.think = symb_walk1;
			symb_idlesound();
		}
		else
		{
			self.think = symb_walk2;
			self.frame_active = 0;
		}
	}
	else
		self.think = symb_walk1;

	ai_walk(symbol_walkspeed);
	self.nextthink = time + 0.05;
};
.float flying_time;

float () symbolCheckForward =
{
	vector source;
	makevectors(self.v_angle);
	source = self.origin;
	traceline(source + v_forward * -12, source + v_forward *128, FALSE, self);
	if (trace_fraction == 1)
		return 1;
	else
		return 0;

};
.float symbolCheckDirectiontime;
void(float right_dir) symbolCheckDirection =
{
	vector source;
	makevectors(self.v_angle);
	source = self.origin;
	traceline(source, source + v_right * 64 * right_dir, MOVE_WORLDONLY, self);

	if (trace_fraction != 1)
	 {
		self.pipes.nextthink = time;
		self.symbolCheckDirectiontime = time + random (2,5);
	}
};

void(float distforward, float distside)ai_symbol_run =
{
	vector v_angles;
	v_angles_y =self.angles_y;
	makevectors (v_angles);
	self.gravity = 0;
	self.velocity = v_forward *distforward * 6;
	self.velocity += v_right *distside * 6;
	self.velocity_z = 0;
	if((self.origin_z - self.enemy.origin_z) > 192)
		self.velocity_z = -64;
	else if((self.enemy.origin_z - self.origin_z) > 192)
		self.velocity_z = 64;

};


void() symb_check_speed =
{


	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	ChangeYaw();

	vector dist = self.enemy.origin - self.origin;
    dist_z = 0;
	float d = vlen(dist);

	float symbol_speed = symbol_runspeed;
	
	if(self.symbolCheckDirectiontime < time)
	{
		if(self.pipes.cnt > 0)
			symbolCheckDirection(1);
		else
			symbolCheckDirection(-1);
	}

    if (d <= 512 )
	{
		if(visible(self.enemy))
		{	
			ai_symbol_run(0, symbol_speed * self.pipes.cnt);
			self.frame = $symbol_frwrd;
		}
		else
		{
			self.frame = $symbol_frwrd;
		    ai_symbol_run(symbol_speed * 0.5,symbol_speed * self.pipes.cnt * 1.2);
		}
	}

    else if (d > 512 && d <= 1024)
	{
   		ai_symbol_run(symbol_speed * (d/400),symbol_speed * self.pipes.cnt);
		self.frame = $symbol_frwrd;
	}

    else if (d >= 1024)
	{
		ai_symbol_run(symbol_speed * 2,symbol_speed * self.pipes.cnt * 0.25);
		self.frame = $symbol_frwrd;
	}

};
void()symb_postfast1;
.float symb_flying_away;

void() symb_side_fly =
{
	if(self.pipes.cnt > 0)
		symbolCheckDirection(1);
	else
		symbolCheckDirection(-1);
	self.frame = $symbol_frwrd;

	float speed = vlen (self.velocity);
    if(speed >= symbol_runspeed* 0.5) 
	{
    	symb_check_speed();
		self.colormod = '0 0 0';
	}
    else
    {
		self.colormod = '1 0 0';
	    self.velocity = normalize(self.velocity) * -symbol_runspeed;
		self.velocity_z += random(64,128);	
		self.symb_flying_away = time + random(0.5,2);
    }
	if(self.symb_flying_away < time)
		ai_symbol_run(0, symbol_runspeed * self.pipes.cnt);


	if(self.frame_time < time)
	{	
		self.frame_time = time + random(2,3);
		self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
		ChangeYaw();
	}
	else
		self.think = symb_run1;

	self.nextthink = time + 0.05;
};

void()	symb_run1	=
{

	self.movetype = MOVETYPE_FLY;	
	if(self.flags & FL_FLY)
		self.flags -= FL_FLY;
	if(self.symb_flying_away > time)
	{
		self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
		ChangeYaw();
		self.think = symb_run1;
		self.nextthink = time + 0.05;
		return;
	}
	if(self.origin == self.oldorigin)
		self.think = symb_postfast1;
	self.vweapon.cnt = 0;

	float speed = vlen (self.velocity);
    if(speed >= symbol_runspeed* 0.5) 
    	symb_check_speed();
    else
    {
	    self.velocity = normalize(self.velocity) * -symbol_runspeed;
		self.symb_flying_away = time + random(0.5,2);
    }
	if ((self.attack_finished < time) )
	{	
		self.ideal_yaw = enemy_yaw;
		ChangeYaw();
		self.think = self.th_missile;
	}
	else
		self.think = symb_run1;

	self.oldorigin = self.origin;
	self.nextthink = time + 0.05;
};

void()	symb_fast1	=
{
	ai_face(); 
	if(self.frame_time < time)
	{	
		if(self.frame_active != 1)
		{
			self.frame_time = time + 1;
			self.frame_active = 1;
			self.think = symb_fast1;
			symb_idlesound();
			self.attack_finished = time + 0.15;
		}
		else
		{
			symbolAttackFinished ();
			self.think = symb_side_fly;
			self.frame_active = 0;
		}
	}
	else
		self.think = symb_fast1;

	if((self.attack_finished < time) && (self.frame_active == 1) &&(visible(self.enemy)))
	{
		self.vweapon.cnt = 1.2;
		self.attack_finished = time + random(1.5, 3);


		float symbol_angles = 1.5;
		sound (self, CHAN_WEAPON, "enemies/symbol/fire.ogg", 1, 0.1);
		if(visible(self.enemy))
		{
			symbol_missileattack(self,"tag_muzzfle_a",-7 * symbol_angles,1);
			symbol_missileattack(self,"tag_muzzfle_b",7* symbol_angles,1);
			symbol_missileattack(self,"tag_muzfzle_c",-3* symbol_angles,1);
			symbol_missileattack(self,"tag_muzfzle_d",3* symbol_angles,1);
			symbol_missileattack(self,"tag_no",0,1);
		}
	}


	self.nextthink = time + 0.05;
};

void()	symb_fastb5	=
{
	self.vweapon.cnt = 1.2;
	self.think = symb_side_fly;

		self.attack_finished = time + random(1.3, 3);

	float symbol_angles = 1.5;
	sound (self, CHAN_WEAPON, "enemies/symbol/fire.ogg", 1, 0.1);
	if(visible(self.enemy))
	{
		symbol_missileattack(self,"tag_no",0,0);
		symbol_missileattack(self,"tag_muzzfle_a",-12 * symbol_angles,0);
		symbol_missileattack(self,"tag_muzzfle_b",12* symbol_angles,0);
	}
	self.nextthink = time + 0.15;
};
void()	symb_fastb4	=
{
	ai_face(); 
	self.vweapon.cnt = 0.8;
	self.think = symb_fastb5;
	self.nextthink = time + 0.15;
};

void()	symb_fastb3	=
{
	self.vweapon.cnt = 1.2;
	self.think = symb_fastb4;
	float symbol_angles = 1.5;

	sound (self, CHAN_WEAPON, "enemies/symbol/fire.ogg", 1, 0.1);
	if(visible(self.enemy))
	{
		symbol_missileattack(self,"tag_muzfzle_c",-6* symbol_angles,0);
		symbol_missileattack(self,"tag_muzfzle_d",6* symbol_angles,0);
	}
	self.nextthink = time + 0.15;
};

void()	symb_fastb2	=
{
	self.vweapon.cnt = 0.8;
	self.think = symb_fastb3;
	self.nextthink = time + 0.15;
};

void()	symb_fastb1	=
{
	self.vweapon.cnt = 1.2;
	ai_face(); 
	self.velocity = '0 0 0';
	self.think = symb_fastb2;
	float symbol_angles = 1.5;

	sound (self, CHAN_WEAPON, "enemies/symbol/fire.ogg", 1, 0.1);
	if(visible(self.enemy))
		symbol_missileattack(self,"tag_no",0,1);
	self.nextthink = time + 0.15;
};
void()	symb_fastb0	=
{
	self.vweapon.cnt = 1;
	ai_face(); 
	self.think = symb_fastb1;
	self.nextthink = time + 0.15;
};
void() symb_postfast1 = 
{
	self.velocity_z = symbol_upspeed;
	if(self.frame_time < time)
	{
		if(self.frame_active != 1)
		{		
			self.frame_active = 1;
			self.frame_time = time + 0.55;
			self.think = symb_postfast1;
		}
		else
		{		
			self.pipes.frame_time = time + 0.5; 
			self.frame_active = 0;
			self.think = symb_fast1;
		}
	}
	else
		self.think = symb_postfast1;
	self.nextthink = time + 0.05;
};
float()zoom_up_check = 
{
	vector source;
	makevectors(self.v_angle);
	source = self.origin;
	traceline(source, source + v_up * 128, MOVE_WORLDONLY, self);
	if (trace_fraction == 1)
		return 1;
	else
		return 0;
};
void()	symb_prefast1 =
{
	ai_face();
	float dist = vlen (self.origin - self.enemy.origin);
	if (dist < 1)
		dist = 1;
	float distance_to_zoom = 128 * (1- (dist/1024));
	
	if((dist < 1024) && ((self.origin_z - self.enemy.origin_z) < distance_to_zoom) &&(zoom_up_check())) 
	{
		self.movetype = MOVETYPE_FLY;
		//self.velocity = '0 0 0';
		//self.velocity_z = 0; 
		self.pipes.frame_time = time + 0.5; 
		self.frame_active = 0;
		self.frame_time = 0;
		self.frame_time = 0; 
		self.frame_active = 0; 
		self.frame = $symbol_fly;
		self.think = symb_postfast1;
	}
	else
	{	
		float roll_dice = random();
		if((visible(self.enemy)) && roll_dice > 0.5)
		{	
			self.frame = $symbol_flytoattack;
			self.frame_active = 0;
			self.frame_time = 0;
			self.think = symb_fastb0;
			self.vweapon.cnt = 0.8;
		}
		else
			self.think = symb_run1;
	}
	self.nextthink = time;
};

void()	symb_pain1	=[	$symbol_back,		symb_pain2	] {self.sustained_damage = 0;};
void()	symb_pain2	=[	$symbol_back,		symb_pain3	] {};
void()	symb_pain3	=[	$symbol_back,		symb_pain4	] {};
void()	symb_pain4	=[	$symbol_back,		symb_run1	] {};

void()	symb_death1	=[	$symbol_stand,		symb_death2	] 
{

	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 100 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound (self, CHAN_VOICE, "symbol/wdeath.wav", 1, ATTN_NORM);
};

void()	symb_death2	=[	$symbol_stand,		symb_death3	] {};
void()	symb_death3	=[	$symbol_stand,		symb_death4	] {self.solid = SOLID_NOT;};
void()	symb_death4	=[	$symbol_stand,		symb_death5	] {};
void()	symb_death5	=[	$symbol_stand,		symb_death6	] {};
void()	symb_death6	=[	$symbol_stand,		symb_death7	] {};
void()	symb_death7	=[	$symbol_stand,		symb_death8	] {};
void()	symb_death8	=[	$symbol_stand,		symb_death8	] {};

void() symb_die =
{
	vector tagorg = tag_origin("tag_head", self);
	pointparticles(particleeffectnum("wretch_bloodshower"), tagorg , '0 0 0', 1);
	explo_blood(2, tagorg);	
	explo_blood(9, tagorg);	
	remove(self.pipes);
	
	tagorg = tag_origin("tag_c_bl", self);ThrowGib3(self, "models/enemies/symbol/gibs/c_bl.md3", 0, 0.75, 1, 1, tagorg, relvel('-0 -80 50', self), 0, 3);	//forward, right, up
	tagorg = tag_origin("tag_c_br", self);ThrowGib3(self, "models/enemies/symbol/gibs/c_br.md3", 0, 0.75, 1, 1, tagorg, relvel('0 80 50', self), 0, 3);

	tagorg = tag_origin("tag_c_tl", self);ThrowGib3(self, "models/enemies/symbol/gibs/c_tl.md3", 0, 0.75, 1, 1, tagorg, relvel('0 -120 150', self), 0, 3);
	tagorg = tag_origin("tag_c_tr", self);ThrowGib3(self, "models/enemies/symbol/gibs/c_tr.md3", 0, 0.75, 1, 1, tagorg, relvel('0 120 150', self), 0, 3);

	tagorg = tag_origin("tag_t_fl", self);ThrowGib3(self, "models/enemies/symbol/gibs/t_fl.md3", 0, 0.75, 1, 1, tagorg, relvel('120 -100 120', self), 0, 3);
	tagorg = tag_origin("tag_t_fm", self);ThrowGib3(self, "models/enemies/symbol/gibs/t_fm.md3", 0, 0.75, 1, 1, tagorg, relvel('120 0 120', self), 0, 3);
	tagorg = tag_origin("tag_t_fr", self);ThrowGib3(self, "models/enemies/symbol/gibs/t_fr.md3", 0, 0.75, 1, 1, tagorg, relvel('120 100 120', self), 0, 3);
	
	tagorg = tag_origin("tag_t_bl", self);ThrowGib3(self, "models/enemies/symbol/gibs/t_bl.md3", 0, 0.75, 1, 1, tagorg, relvel('-120 -90 50', self), 0, 3);
	tagorg = tag_origin("tag_t_bm", self);ThrowGib3(self, "models/enemies/symbol/gibs/t_bm.md3", 0, 0.75, 1, 1, tagorg, relvel('-120 -0 50', self), 0, 3);
	tagorg = tag_origin("tag_t_br", self);ThrowGib3(self, "models/enemies/symbol/gibs/t_br.md3", 0, 0.75, 1, 1, tagorg, relvel('-120 90 50', self), 0, 3);

	tagorg = tag_origin("tag_head", self);ThrowGib3(self, "models/enemies/symbol/gibs/head.md3", 0, 0.75, 1, 1, tagorg, relvel('90 -0 170', self), 0, 3);
	remove(self);

};


void(entity attacker, float damage) symb_Pain =
{

	sound (self, CHAN_VOICE, "symbol/wpain.wav", 1, ATTN_NORM);
	self.pain_finished = time + random(1.5,2);
	symb_pain1 ();
};


void() precache_monster_symbol =
{
	precache_model("models/enemies/symbol/symbol.md3");
	precache_model("models/projectiles/proj_symbol.md3");
};

void()symb_glow_controller_think = 
{
	if(self.cnt > 0)
	{
		if(self.owner.glowmod_x <=self.cnt)
		{
			self.owner.glowmod_x += 0.05;
			self.owner.glowmod_y += 0.05;
			self.owner.glowmod_z += 0.05;
		}	
	}
	else
	{
		if(self.owner.glowmod_x >= self.cnt)
		{
			self.owner.glowmod_x -= 0.05;
			self.owner.glowmod_y -= 0.05;
			self.owner.glowmod_z -= 0.05;
		}	
	}	
	if(self.owner.glowmod_x <= 0)
	{
		self.owner.glowmod_x = 0.01;
		self.owner.glowmod_y = 0.01;
		self.owner.glowmod_z = 0.01;
	}	
	self.think = symb_glow_controller_think;
	self.nextthink = time + 0.05;
};


void()desacelerator_think =
{
	if(self.cnt > 0)
		self.cnt = random(-1.25,-1);
	else
		self.cnt = random(1,1.25);

	self.nextthink = time + random(5,12);
};

void() monster_symbol =
{

	if (deathmatch)
	{
		remove(self);
		return;
	}
	total_monsters = total_monsters + 1;
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	//setmodel(self, "");

	self.damagetopain = symbol_dtp;
	self.netname = "Symbol";
	precache_model("models/enemies/symbol/symbol.md3");
	setmodel (self,"models/enemies/symbol/symbol.md3");
	self.classname = "monster_symbol";
	setsize(self, symbol_bboxn , symbol_bbox);
	self.health = symbol_health;
	self.scale = 1;
	self.th_stand = symb_stand1;
	self.th_walk = symb_walk1;
	self.th_run = symb_run1;
	self.th_missile = symb_prefast1;
	self.th_pain = symb_Pain;
	self.th_die = symb_die;

	entity desacelerator = spawn();
	desacelerator.owner = self;
	desacelerator.think = desacelerator_think;
	desacelerator.nextthink = time;
	self.pipes = desacelerator;

	entity glow_controller = spawn();
	glow_controller.owner = self;
	glow_controller.think = symb_glow_controller_think;
	glow_controller.nextthink = time;
	self.vweapon = glow_controller;

	flymonster_start ();
};
