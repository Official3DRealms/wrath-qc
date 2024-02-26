/*
==============================================================================

symbol

==============================================================================
*/

$frame symbolbase

$frame symbolidle1 symbolidle2 symbolidle3 symbolidle4 symbolidle5 symbolidle6 symbolidle7 symbolidle8 symbolidle9 symbolidle10 symbolidle11 symbolidle12 symbolidle13 symbolidle14 symbolidle15 symbolidle16 symbolidle17 symbolidle18 symbolidle19 symbolidle20

$frame symbolwalk1 symbolwalk2 symbolwalk3 symbolwalk4 symbolwalk5 symbolwalk6 symbolwalk7 symbolwalk8 symbolwalk9 symbolwalk10 symbolwalk11 symbolwalk12 symbolwalk13 symbolwalk14 symbolwalk15 symbolwalk16 symbolwalk17 symbolwalk18 symbolwalk19 symbolwalk20

//$frame symbolrun1 symbolrun2 symbolrun3 symbolrun4 symbolrun5 symbolrun6 symbolrun7 symbolrun8 symbolrun9 symbolrun10 symbolrun11 symbolrun12 symbolrun13 symbolrun14 symbolrun15 symbolrun16 symbolrun17 symbolrun18 symbolrun19

$frame symbolshoot1 symbolshoot2 symbolshoot3 symbolshoot4 symbolshoot5 symbolshoot6 symbolshoot7 symbolshoot8 symbolshoot9 symbolshoot10 symbolshoot11 symbolshoot12 symbolshoot13 symbolshoot14 symbolshoot15 symbolshoot16 symbolshoot17 symbolshoot18 symbolshoot19 symbolshoot20 symbolshoot21 symbolshoot22 symbolshoot23 symbolshoot24 symbolshoot25 symbolshoot26 symbolshoot27 symbolshoot28 symbolshoot29 symbolshoot30

$frame symbolflyup1 symbolflyup2 symbolflyup3 symbolflyup4 symbolflyup5 symbolflyup6 symbolflyup7 symbolflyup8 symbolflyup9 symbolflyup10 symbolflyup11 symbolflyup12 symbolflyup13 symbolflyup14 symbolflyup15 symbolflyup16 symbolflyup17 symbolflyup18 symbolflyup19 symbolflyup20 symbolflyup21 symbolflyup22 symbolflyup23 symbolflyup24 symbolflyup25 symbolflyup26 symbolflyup27 symbolflyup28 symbolflyup29 symbolflyup30

$frame symbolpain1 symbolpain2 symbolpain3 symbolpain4 symbolpain5 symbolpain6 symbolpain7 symbolpain8 symbolpain9 symbolpain10 symbolpain11 symbolpain12 symbolpain13 symbolpain14 symbolpain15 symbolpain16 symbolpain17 symbolpain18 symbolpain19 symbolpain20 symbolpain21 symbolpain22 symbolpain23 symbolpain24 symbolpain25 symbolpain26 symbolpain27 symbolpain28 symbolpain29 symbolpain30 symbolpain31 symbolpain32 symbolpain33 symbolpain34 symbolpain35 symbolpain36 symbolpain37 symbolpain38 symbolpain39

$frame symbolpainb1 symbolpainb2 symbolpainb3 symbolpainb4 symbolpainb5 symbolpainb6 symbolpainb7 symbolpainb8 symbolpainb9 

/*
==============================================================================

symbol

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

void() symbol_run1;
void() symbol_side1;
void() symbolAttackFinished;
void() symbol_run1b;
void() symbol_run1 = 
{ 
	if (self.enemy != world)
		self.think = symbolAttackFinished;
	else
		self.think = symbol_run1b;


	if(time > self.touchtime)
	{
	//	sound(self, CHAN_VOICE2, "enemies/symbol/idle_loop.ogg", 0.5, 0.15);
		self.touchtime = time + soundlength("enemies/symbol/idle_loop.ogg");
	}

	self.pflags = 0;
	self.nextthink = time;
};

/*
=================
symbolCheckAttack
=================
*/
float() symbolCheckAttack = { local vector spot1, spot2;
	local entity targ;
	local float chance;
	self.movetype = MOVETYPE_STEP;
	if (time < self.attack_finished)
		return FALSE;

	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			symbol_run1();
		}
		return FALSE;
	}

	targ = self.enemy;

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline(spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{
		// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			symbol_run1();
		}
		return FALSE;
	}

	if (enemy_range == RANGE_MELEE)
		chance = 1;

	else if (enemy_range == RANGE_NEAR)
		chance = 1;

	else if (enemy_range == RANGE_MID)
		chance = 0;

	else
		chance = 0;

	if (chance == 1)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			symbol_run1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			symbol_side1();
		}
	}

	return FALSE;
};

/*
=================
symbolAttackFinished
=================
*/
void() symbolshoot1;
void() symbolshoot;

void() symbolAttackFinished = { local float renemy_range;
	local vector spot1, spot2;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = self.enemy.origin;

	renemy_range = vlen(spot1 - spot2);
	self.movetype = MOVETYPE_STEP;

    self.sight_time = 0;

	if (renemy_range > 1024 || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = symbol_run1b;
	}
	else
	{

		local float rnd;
		rnd = random();
		if (rnd > 0.7)
		{
			self.attack_state = AS_SLIDING;
			ai_face();
			self.think = symbol_side1;
		}
		else
			self.think = symbolshoot;
	}
	self.nextthink = time + 0.025;
};

void() symbolCheckDistance = { local float renemy_range;
	local vector spot1, spot2;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = self.enemy.origin;
	renemy_range = vlen(spot1 - spot2);

	if (renemy_range > 1024 || !enemy_vis || (self.attack_finished > time))
	{
		self.attack_state = AS_STRAIGHT;
		self.think = symbol_run1b;
	}
	else
	{

		local float rnd;
		rnd = random();
		if (rnd > 0.9)
		{
			self.attack_state = AS_SLIDING;
			ai_face();
			self.think = symbol_side1;
		}
		else
			self.think = symbolshoot;
	}
	self.nextthink = time + 0.025;

};

.float righty_dir;
.float lefty_dir;

void() symbol_checkr_direction = { local vector source;

	makevectors(self.v_angle);
	source = self.origin;
	tracebox(source, '-1 -1 -1', '1 1 1', source + v_right *128, FALSE, self);
	if (trace_fraction == 1)
		self.righty_dir = 1;
	else
		self.righty_dir = 0;
};
void() symbol_checkl_direction = { local vector source;

	makevectors(self.v_angle);
	source = self.origin;
	tracebox(source, '-1 -1 -1', '1 1 1', source + v_right *-128, FALSE, self);
	if (trace_fraction == 1)
		self.lefty_dir = 1;
	else
		self.lefty_dir = 0;
};

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void() proj_symbol_explo = { self.alpha -= 0.1;
	self.frame += 1;
	if (self.alpha < 0)
		self.think = SUB_Remove;
	else
		self.think = proj_symbol_explo;
	self.nextthink = time + 0.05;
}


void() symbol_idlesound = { local float wr;
	wr = random() *5;

	if (self.waitmin < time)
	{
		self.waitmin = time + 2;
		if (wr > 4.5)
			sound(self, CHAN_VOICE, "enemies/symbol/sight1.ogg", 1, 0.2);

		if (wr < 1.5)
			sound(self, CHAN_VOICE, "enemies/symbol/sight2.ogg", 1, 0.2);
	}
	return;
};

void() symbol_stand1 =
{

	if(time > self.touchtime)
	{
		//sound(self, CHAN_VOICE2, "enemies/symbol/idle_loop.ogg", 0.5, 0.15);
		self.touchtime = time + soundlength("enemies/symbol/idle_loop.ogg");
	}
	self.frame = $symbolidle1 + self.pframe;
	self.pframe ++;
	if(self.pframe >= 19)
		self.pframe = 0;
	self.glowmod = '0.5 0.5 0.5';

	if ((self.sight_time < time) && (!(self.spawnflags &1)) && (self.pframe == 1))
	{
		chattersound("enemies/symbol/idle", 3, 1);
		self.sight_time = time + random(5,10);
	}
	self.think = symbol_stand1;
	ai_stand();
	self.nextthink = time + 0.1;
};


void() symbol_walk1 =[$symbolidle1, symbol_walk2]
{
	ai_walk(8);
	self.glowmod = '0.5 0.5 0.5';
	if (self.sight_time < time)
	{
		local float r;
		r = random();
		if (r > 0.5)
			chattersound("enemies/symbol/chatter", 3, 1);
		self.sight_time = time + 7.5;
	}
};
void() symbol_walk2 =[$symbolidle2, symbol_walk3]{ai_walk(8);};
void() symbol_walk3 =[$symbolidle3, symbol_walk4]{ai_walk(8);};
void() symbol_walk4 =[$symbolidle4, symbol_walk5]{ai_walk(8);};
void() symbol_walk5 =[$symbolidle5, symbol_walk6]{ai_walk(8);};
void() symbol_walk6 =[$symbolidle6, symbol_walk7]{ai_walk(8);};
void() symbol_walk7 =[$symbolidle7, symbol_walk8]{ai_walk(8);};
void() symbol_walk8 =[$symbolidle8, symbol_walk9]{ai_walk(8);};
void() symbol_walk9 =[$symbolidle9, symbol_walk10]{ai_walk(8);};
void() symbol_walk10 =[$symbolidle10, symbol_walk11]{ai_walk(8);};
void() symbol_walk11 =[$symbolidle11, symbol_walk12]{ai_walk(8);};
void() symbol_walk12 =[$symbolidle12, symbol_walk13]{ai_walk(8);};
void() symbol_walk13 =[$symbolidle13, symbol_walk14]{ai_walk(8);};
void() symbol_walk14 =[$symbolidle14, symbol_walk15]{ai_walk(8);};
void() symbol_walk15 =[$symbolidle15, symbol_walk16]{ai_walk(8);};
void() symbol_walk16 =[$symbolidle16, symbol_walk17]{ai_walk(8);};
void() symbol_walk17 =[$symbolidle17, symbol_walk18]{ai_walk(8);};
void() symbol_walk18 =[$symbolidle18, symbol_walk19]{ai_walk(8);};
void() symbol_walk19 =[$symbolidle19, symbol_walk20]{ai_walk(8);};
void() symbol_walk20 =[$symbolidle20, symbol_walk1]{ai_walk(8);};

void() symbol_lside9;
void() symbol_rside9;

void(float f) symbol_check_sidewall = { if ((test_side_wall(f)))
	{
		self.attack_state = AS_MISSILE;
		self.think = symbolshoot;
		self.nextthink = time;
	}
};

void() symbol_rside1 =[$symbolidle1, symbol_rside2]
{
	symbol_idlesound();
	self.glowmod = '0.5 0.5 0.5';
	symbol_check_sidewall(1);
	ai_run(2);
};
void() symbol_rside2 =[$symbolidle3, symbol_rside3]
{
	symbol_check_sidewall(1);
	ai_run(8);
};
void() symbol_rside3 =[$symbolidle5, symbol_rside4]
{
	symbol_check_sidewall(1);
	ai_run(16);
};
void() symbol_rside4 =[$symbolidle7, symbol_rside5]
{
	symbol_check_sidewall(1);
	ai_run(24);
};
void() symbol_rside5 =[$symbolidle9, symbol_rside6]
{
	symbol_check_sidewall(1);
	ai_run(24);
};
void() symbol_rside6 =[$symbolidle11, symbol_rside7]
{
	symbol_check_sidewall(1);
	ai_run(16);
};
void() symbol_rside7 =[$symbolidle13, symbol_rside8]
{
	symbol_check_sidewall(1);
	ai_run(8);
};
void() symbol_rside8 =[$symbolidle15, symbol_rside9]
{
	symbol_check_sidewall(1);
	ai_run(8);
};
void() symbol_rside9 =[$symbolidle17, symbol_rside10]
{
	symbol_check_sidewall(1);
	ai_run(8);
};
void() symbol_rside10 =[$symbolidle19, symbolCheckDistance]
{
	ai_run(4);
};

void() symbol_lside1 =[$symbolidle1, symbol_lside2]
{
	symbol_idlesound();
	self.glowmod = '0.5 0.5 0.5';
	symbol_check_sidewall(0);
	ai_run(2);
};
void() symbol_lside2 =[$symbolidle3, symbol_lside3]
{
	symbol_check_sidewall(0);
	ai_run(8);
};
void() symbol_lside3 =[$symbolidle5, symbol_lside4]
{
	symbol_check_sidewall(0);
	ai_run(16);
};
void() symbol_lside4 =[$symbolidle7, symbol_lside5]
{
	symbol_check_sidewall(0);
	ai_run(24);
};
void() symbol_lside5 =[$symbolidle9, symbol_lside6]
{
	symbol_check_sidewall(0);
	ai_run(24);
};
void() symbol_lside6 =[$symbolidle11, symbol_lside7]
{
	symbol_check_sidewall(0);
	ai_run(16);
};
void() symbol_lside7 =[$symbolidle13, symbol_lside8]
{
	symbol_check_sidewall(0);
	ai_run(8);
};
void() symbol_lside8 =[$symbolidle15, symbol_lside9]
{
	symbol_check_sidewall(0);
	ai_run(8);
};
void() symbol_lside9 =[$symbolidle17, symbol_lside10]
{
	symbol_check_sidewall(0);
	ai_run(8);
};
void() symbol_lside10 =[$symbolidle19, symbolCheckDistance]
{
	ai_run(4);
};

void() symbol_side1 = { local vector source;
	local float r;
	makevectors(self.v_angle);
	source = self.origin;
	traceline(source, source + v_right *128, FALSE, self);
	if (trace_fraction == 1)
		self.righty_dir = 1;
	traceline(source, source + v_right *-128, FALSE, self);
	if (trace_fraction == 1)
		self.lefty_dir = 1;

	//if (self.strafetime > time)
	//	symbol_StartFast();

	if (self.righty_dir == 1)
	{

		if (self.lefty_dir == 1)
		{
			r = rint(random() *1);
			self.lefty = r;
		}
		else
			self.lefty = 0;
	}
	else
	{
		if (self.lefty_dir == 1)
			self.lefty = 1;
		else
		{
			r = random();
			if (r < 0.5)
				self.think = symbol_run1b;
			else
				self.think = symbolshoot;
			self.nextthink = time + 0.025;
			return;
		}
	}

	r = rint(random() *1);
	self.lefty = r;

	if (self.lefty)
		self.think = symbol_lside1;
	else
		self.think = symbol_rside1;

	ai_run(1);
	self.nextthink = time + 0.025;
};
void() symbol_fly1;
void()symbol_run1b;
float()zoom_up_check = 
{
	vector source;
	makevectors2(self.angles);
	source = self.origin;
	return 0;
	tracebox(source,'-48 -32 -32','48 48 32' ,source + v_up * 128, MOVE_WORLDONLY, self);
	if (trace_fraction == 1)
		return 1;
	tracebox(source,'-48 -32 -32','48 48 32' ,source + v_up * 368, MOVE_WORLDONLY, self);
	if (trace_fraction == 1)
		return 2;

};

float(float height)zoom_down_check = 
{
	vector source;
	makevectors2(self.angles);
	source = self.origin;
	tracebox(source,'-48 -32 -32','48 48 32' ,source + v_up * height, MOVE_WORLDONLY, self);
	if (trace_fraction == 1)
		return 0;
	else
		return 1;
};

void() symbol_chase =
{
	ai_face();
	float dist = vlen (self.origin - self.enemy.origin);
	{
		vector vtemp = self.enemy.origin + '0 0 38';
		vector dir = normalize(vtemp - self.origin);
		if(dist > 192)
			self.velocity = dir * 368;
		else
			self.velocity = dir * dist;
	}

	if(zoom_down_check(-192) )
		self.velocity_y = random(10,20);
};



void() symbol_fall1 =[$symbolwalk1, symbol_fall2]
{

	if (self.sight_time < time)
	{
		local float r;
		r = random();
		if (r > 0.5)
			chattersound("enemies/symbol/chatter", 3, 1);
		self.sight_time = time + random(3,7.5);
	}
	else
		chattersound("enemies/symbol/idle", 3, 1);
	self.movetype = MOVETYPE_WALK;
	symbol_chase();
};
void() symbol_fall2 =[$symbolwalk2, symbol_fall3]{symbol_chase();};
void() symbol_fall3 =[$symbolwalk3, symbol_fall4]{symbol_chase();};
void() symbol_fall4 =[$symbolwalk4, symbol_fall5]{symbol_chase();};
void() symbol_fall5 =[$symbolwalk5, symbol_fall6]{symbol_chase();};
void() symbol_fall6 =[$symbolwalk6, symbol_fall7]{symbol_chase();};
void() symbol_fall7 =[$symbolwalk7, symbol_fall8]{symbol_chase();};
void() symbol_fall8 =[$symbolwalk8, symbol_fall9]{symbol_chase();};
void()symbol_shortfly;
void() symbol_fall9 =[$symbolwalk9, symbol_fall10]{symbol_chase();

	float r = random();	
	float roofreachable = zoom_up_check();
	if ((zoom_down_check(-192)&& (roofreachable > 0) && (r > 0.25)))
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}
};
void() symbolshoot10;
void() symbol_fall10 =[$symbolwalk10, symbol_fall11]{symbol_chase();};
void() symbol_fall11 =[$symbolwalk11, symbol_fall12]{symbol_chase();};
void() symbol_fall12 =[$symbolwalk12, symbol_fall13]{symbol_chase();};
void() symbol_fall13 =[$symbolwalk13, symbol_fall14]{symbol_chase();};
void() symbol_fall14 =[$symbolwalk14, symbol_fall15]{symbol_chase();};
void() symbol_fall15 =[$symbolwalk15, symbol_fall16]{symbol_chase();};
void() symbol_fall16 =[$symbolwalk16, symbol_fall17]{symbol_chase();};
void() symbol_fall17 =[$symbolwalk17, symbol_fall18]{symbol_chase();};
void() symbol_fall18 =[$symbolwalk18, symbol_fall19]{symbol_chase();};
void() symbol_fall19 =[$symbolwalk19, symbol_run1]{symbol_chase();
	self.movetype = MOVETYPE_STEP;
	float r = random();	


	float roofreachable = zoom_up_check();


	if(r < 0.5)
	{
		if ((zoom_down_check(-192)&& (roofreachable > 0) && (r > 0.25)))
		{	
			if (roofreachable == 1)
				self.think = symbol_shortfly;
			else	
				self.think = symbol_fly1;
		}
		else
		{
			self.wrath_time = 1;	
			self.think = symbolshoot10;
		}
	}
};

void()symbol_shortfly;

void() symbol_run1b =[$symbolwalk1, symbol_run2]
{	
	self.movetype = MOVETYPE_STEP;
	ai_run(26);
	symbol_idlesound();
	self.glowmod = '0.5 0.5 0.5';
	float roofreachable = zoom_up_check();

	if ((zoom_down_check(-192)&& (roofreachable > 0)))
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}

	if (self.sight_time < time)
	{
		float r = random();
		if (r > 0.5)
			chattersound("enemies/symbol/chatter", 3, 1);
		self.sight_time = time + random(3,7.5);
	}


};
void() symbol_run2 =[$symbolwalk2, symbol_run3]{ai_runwalk(28);};
void() symbol_run3 =[$symbolwalk3, symbol_run4]{ai_runwalk(30);};
void() symbol_run4 =[$symbolwalk4, symbol_run5]{ai_runwalk(24);};
void() symbol_run5 =[$symbolwalk5, symbol_run6]{ai_run(26);

	float r = random();
	if((visible(self.enemy))&& (r > 0.5))
		self.think = symbolshoot1;
};
void() symbol_run6 =[$symbolwalk6, symbol_run7]{ai_runwalk(28);

	float roofreachable = zoom_up_check();

	if ((zoom_down_check(-192)&& (roofreachable > 0)))
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}
};
void() symbol_run7 =[$symbolwalk7, symbol_run8]{ai_runwalk(26);};
void() symbol_run8 =[$symbolwalk8, symbol_run9]{ai_run(22);};
void() symbol_run9 =[$symbolwalk9, symbol_run10]{ai_runwalk(26);

	float r = random();	


	float roofreachable = zoom_up_check();

	if ((zoom_down_check(-192)&& (roofreachable > 0) && (r > 0.35)))
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}

};
void() symbol_run10 =[$symbolwalk10, symbol_run11]{ai_runwalk(26);


	float roofreachable = zoom_up_check();
	float v_dist = self.enemy.origin_z - self.origin_z;

	if ((zoom_down_check(-192)&& (roofreachable > 0)) ||(v_dist > random(-64,64)) )
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}
	else
	{
		float r = random();
		if((visible(self.enemy))&& (r > 0.35))
			self.think = symbolshoot1;
	}

};
void() symbol_run11 =[$symbolwalk11, symbol_run12]{ai_runwalk(26);};
void() symbol_run12 =[$symbolwalk12, symbol_run13]{ai_run(26);

	float roofreachable = zoom_up_check();

	if ((zoom_down_check(-192)&& (roofreachable > 0)))
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}
};
void() symbol_run13 =[$symbolwalk13, symbol_run14]{ai_runwalk(26);};
void() symbol_run14 =[$symbolwalk14, symbol_run15]{ai_runwalk(26);};
void() symbol_run15 =[$symbolwalk15, symbol_run16]{ai_runwalk(26);

	float r = random();
	if((visible(self.enemy))&& (r > 0.5))
		self.think = symbolshoot1;
	else
	{
		float dist = vlen (self.origin - self.enemy.origin);
		float r = random();
		if(((dist > 512) && (self.origin_z > self.enemy.origin_z)) && (r < 0.5))
			self.think = symbol_fall1;
		self.nextthink = time + 0.05;
	}

};
void() symbol_run16 =[$symbolwalk16, symbol_run17]{ai_run(26);};
void() symbol_run17 =[$symbolwalk17, symbol_run18]{ai_runwalk(26);

	float roofreachable = zoom_up_check();

	if ((zoom_down_check(-192)&& (roofreachable > 0)))
	{	
		if (roofreachable == 1)
			self.think = symbol_shortfly;
		else	
			self.think = symbol_fly1;
	}

};
void() symbol_run18 =[$symbolwalk18, symbol_run19]{ai_runwalk(26);};
void() symbol_run19 =[$symbolwalk19, symbol_run1]{ai_runwalk(26);

	float dist = vlen (self.origin - self.enemy.origin);
	float r = random();
	if(((dist > 512) && (self.origin_z > self.enemy.origin_z)) && (r < 0.5))
		self.think = symbol_fall1;
	self.nextthink = time + 0.05;
};


.vector projectile_old_velocity;

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

	if(self.frame < 3)
	self.frame += 0.5;
	float speed = vlen (self.velocity);
	if(speed < symbol_proj_speed * symbol_proj_aceleration)
		self.velocity = self.velocity * 1.1; 

	vector delta = (self.enemy.origin) - rorigin(self);
	float dist = vlen(delta);

	self.angles = vectoangles(self.velocity);
	speed = vlen (self.velocity);

	if (dist < 120)
	{
		vector newangles = normalize(self.enemy.origin - self.origin);
		vector newvelocity = speed * newangles;	
		self.velocity_x = self.velocity_x * 0.7 + newvelocity_x * 0.3;  
		self.velocity_y = self.velocity_y * 0.7 + newvelocity_y * 0.3;
		self.cnt = 1;
	}

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

void(entity e, string tagname, float spread, float enemyorigin) symbol_missileattack = 
{ 
	e.effects = EF_MUZZLEFLASH;

	local entity projectile;
	projectile = spawn();
	projectile.owner = e;
	setmodel(projectile, "models/projectiles/proj_symbol.md3");
	projectile.traileffectnum = particleeffectnum("symbol_proj_trail");
	local vector tagorg;

	tagorg = tag_origin(tagname, e);
	projectile.classname = "symbol_projectile";
	projectile.origin = tagorg + v_forward * 6;
	projectile.wrathflags += FL_PROJECTILE;
	//projectile.effects = EF_ADDITIVE + 128;
	projectile.solid = SOLID_TRIGGER;	
	projectile.enemy = self.enemy;
	projectile.movetype = MOVETYPE_FLYMISSILE;
	projectile.lifetime = time + 15;
	setsize (projectile,'-2 -2 -2','2 2 2');



	if(enemyorigin == 1)
	{
		float playerspeed = (vlen (self.enemy.velocity));
		vector nextpos = (normalize (self.enemy.velocity)) * playerspeed;	
		self.enemy_org= self.enemy.origin + '0 0 12' + (nextpos * 0.3);
	}

	vector pvec = self.enemy_org;

	makevectors (self.angles);
	if (spread)
	{
		vector vec = normalize(pvec - (self.origin + (v_right * 12 * spread)));
		if(enemyorigin == 2)	
		vec = normalize(pvec - (self.origin + (v_up * 12 * spread)));

	}
	else
		vec = normalize(pvec - self.origin);

	projectile.velocity = vec * symbol_proj_speed ;

	projectile.think = symbol_proj_prethink;

	if(spread != 0)
	{
		if(spread < 0)
			spread = spread * -1;
		projectile.ammo_shotgun = spread;
	}
	projectile.nextthink = time + 0.05;
	projectile.angles = vectoangles(projectile.velocity);
	projectile.touch = projectile_symbol_touch;
	e.ammo_revolver = 0; // meh
};
.float symbolrmovementtime; .float symbol_up;

void(float forceit,entity lself) symbolrmovement = 
{

	if(lself.symbolrmovementtime > time)
	return;
	makevectors (lself.angles);
	float r = random();

	if((r <= 0.5) && (forceit < 1))
	{
		float dist = vlen (self.origin - self.enemy.origin);
		float r = random();
		if(((dist > 512) && (self.origin_z > self.enemy.origin_z)) && (r < 0.5))
			self.think = symbol_fall1;
		self.nextthink = time + 0.05;
		return;
	}

	if((r > 0.5) || (forceit == 1))
	{
		lself.movetype = MOVETYPE_FLY;
		float sright, sleft;
		vector source = lself.origin;
		tracebox(source, '-48 -48 -48', '48 48 48', source + v_right *192, FALSE, lself);
		if (trace_fraction == 1) sright = 1;
		tracebox(source, '-48 -48 -48', '48 48 48', source + v_right *-192, FALSE, lself);
		if (trace_fraction == 1) sleft = 1;
		if((sright != 1) && (sleft == 1))
		lself.velocity = v_right * random(-512,-256);
		if((sright == 1) && (sleft != 1))
		lself.velocity = v_right *  random(256,512);
		if((sright == 1) && (sleft == 1))
		{
			float r2 = random();
			if(r2 > 0.5)
			{
				if((sright != 1) && (sleft == 1))
					lself.velocity = v_right * random(-384,-320);
			}
			else
			{
				if((sright == 1) && (sleft != 1))
					lself.velocity = v_right *  random(320,384);
			}

			tracebox(source, '-48 -48 -48', '48 48 48', source + v_up * 192, FALSE, lself);
			if (trace_fraction == 1) float s_up = 1;
			tracebox(source, '-48 -48 -48', '48 48 48', source + v_up * -192, FALSE, lself);
			if (trace_fraction == 1) float s_up2 = -1;


			s_up = s_up + s_up2;

			if(s_up == 0)
			{
				r = random();
				if((lself.symbol_up == 0))
				{

					if (r > 0.5)
						{lself.velocity += v_up * random(-384,-320);lself.symbol_up =- 1;}
					else
						{lself.velocity += v_up * random(320,384);lself.symbol_up = 1; }
				}
				else
				{
				if(lself.symbol_up == -1)
					{lself.velocity += v_up * random(320,384);lself.symbol_up = 1; }
				if(lself.symbol_up == 1)
					{lself.velocity += v_up * random(-384,-320);lself.symbol_up = -1; }

				}


			}
			if(s_up == 1)
				{lself.velocity += v_up * random(320,384);lself.symbol_up = 1; }
			if(s_up == -1)
				{lself.velocity += v_up * random(-256,-128);lself.symbol_up = -1; }

		}
	//makevectors (lself.angles);

		lself.symbolrmovementtime = time + random(0.5,1.5);
	makevectors2 (lself.angles);
	lself.velocity += v_forward * random(320,384);

	}
	if(forceit == 2)
	{
		lself.movetype = MOVETYPE_FLY;
		lself.velocity += v_up * random(320,384);
		//lself.velocity_x = 
		//lself.velocity_x = 
	}




};
void() symbolshoot1 =[$symbolshoot1, symbolshoot2]{ai_face();self.glowmod = '0.6 0.6 0.6';

	float r = random();
	/*if(r < 0.33)
	{
		self.movetype = MOVETYPE_FLY; 
		self.velocity = '0 0 128';
	}
	else if(r < 0.32)
	{	
		self.movetype = MOVETYPE_WALK; 
		makevectors2 (self.angles);
		self.velocity = v_right * 3* 128;
	}
	else*/
		self.movetype = MOVETYPE_STEP; 

	self.wrath_time = 0;	

	self.pflags =129;
	self.light_lev = 3.5;
	self.color ='0.75 0.1 0.1';
};
void() symbolshoot2 =[$symbolshoot2, symbolshoot3]{ai_face();self.glowmod = '0.65 0.65 0.65';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot3 =[$symbolshoot3, symbolshoot4]{ai_face();self.glowmod = '0.7 0.7 0.7';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot4 =[$symbolshoot4, symbolshoot5]{ai_face();self.glowmod = '0.75 0.75 0.75';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot5 =[$symbolshoot5, symbolshoot6]{ai_face();self.glowmod = '0.8 0.8 0.8';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot6 =[$symbolshoot6, symbolshoot7]{ai_face();self.glowmod = '0.85 0.85 0.85';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot7 =[$symbolshoot7, symbolshoot8]{ai_face();self.glowmod = '0.9 0.9 0.9';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot8 =[$symbolshoot8, symbolshoot9]{ai_face();self.glowmod = '1 1 1';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot9 =[$symbolshoot9, symbolshoot10]{ai_face();self.glowmod = '1.05 1.05 1.05';self.light_lev += 3;self.velocity * 0.95;};
void() symbolshoot10 =[$symbolshoot10, symbolshoot11]
{
	self.pain_finished = time + 1;
	ai_face();
	self.glowmod += '0.075 0.075 0.075';
	self.light_lev += 3;
	if(self.glowmod_x <= 1.45)
	{
		self.think = symbolshoot10;
	}
	else
	{
		te_customflash (self.origin, 170,1,'0.75 0.1 0.1');	
	}
	self.nextthink = time + 0.05;
};

void() symbolshoot11 =[$symbolshoot11, symbolshoot12a]
{	
	ai_face();
	attacksound("enemies/symbol/attack");
	self.glowmod = '1.5 1.5 1.5';
	float symbol_angles = 1.5;
	self.movetype = MOVETYPE_STEP; 
	if(self.movetype == MOVETYPE_FLY) 
		self.velocity = '0 0 -256';
	if(self.movetype == MOVETYPE_WALK) 
	{
		makevectors2 (self.angles);
		self.velocity = v_right * 3* -128;
	}


	sound (self, CHAN_WEAPON, "enemies/symbol/fire.ogg", 1, 0.1);
	if(visible(self.enemy))
	{
		float bparticle = particleeffectnum("flask_particle");
		pointparticles(bparticle, self.origin, '0 0 0', 1);
		symbol_missileattack(self,"tag_no",0,1);
	}
	self.nextthink = time + 0.05;
};

void() symbolshoot12a =[$symbolshoot11, symbolshoot12]
{
	ai_face();
	self.ammo_revolver ++;	

	float cnttimer = 3;
	if(self.movetype == MOVETYPE_STEP)
	cnttimer = 2;

	if(self.ammo_revolver < cnttimer)
		self.think = symbolshoot12a;
};
void() symbolshoot12 =[$symbolshoot12, symbolshoot13a]{self.glowmod = '1.05 1.05 1.05';self.nextthink = time + 0.05;
	self.velocity * 0.95;
	if(self.movetype == MOVETYPE_FLY) 
		self.velocity = '0 0 256';
	if(self.movetype == MOVETYPE_WALK) 
	{
		makevectors2 (self.angles);
		self.velocity = v_right * 3* 128;
	}
	ai_face();
	if(visible(self.enemy))
	{

		if(self.wrath_time != 1)
		{
			symbol_missileattack(self,"tag_muzfzle_c",-3* symbol_proj_angle,0);
			symbol_missileattack(self,"tag_muzfzle_d",3* symbol_proj_angle,0);
		}
		else
		{
			symbol_missileattack(self,"tag_muzfzle_c",-3* symbol_proj_angle,2);
			symbol_missileattack(self,"tag_muzfzle_d",3* symbol_proj_angle,2);
			symbol_missileattack(self,"tag_muzfzle_c",-3* symbol_proj_angle,0);
			symbol_missileattack(self,"tag_muzfzle_d",3* symbol_proj_angle,0);
		}

	}
};


void() symbolshoot13a =[$symbolshoot12, symbolshoot13]
{
	ai_face();
	self.ammo_revolver ++;	
	float cnttimer = 3;
	if(self.movetype == MOVETYPE_STEP)
	cnttimer = 2;
	self.velocity * 0.95;
	if(self.ammo_revolver < cnttimer)
		self.think = symbolshoot13a;
};
void() symbolshoot13 =[$symbolshoot13, symbolshoot14]{self.glowmod = '1 1 1';self.nextthink = time + 0.05;

	ai_face();
	if(self.movetype == MOVETYPE_FLY) 
		self.velocity = '0 0 -256';
	if(self.movetype == MOVETYPE_WALK) 
	{
		makevectors2 (self.angles);
		self.velocity = v_right * 3* -128;
	}
	if(visible(self.enemy))
	{

		if(self.wrath_time != 1)
		{
			symbol_missileattack(self,"tag_muzzfle_a",-7 * symbol_proj_angle,0);
			symbol_missileattack(self,"tag_muzzfle_b",7* symbol_proj_angle,0);
			symbol_missileattack(self,"tag_no",0,0);
		}
		else
		{
			symbol_missileattack(self,"tag_muzzfle_a",-7 * symbol_proj_angle,2);
			symbol_missileattack(self,"tag_muzzfle_b",7* symbol_proj_angle,2);
			symbol_missileattack(self,"tag_muzzfle_a",-7 * symbol_proj_angle,0);
			symbol_missileattack(self,"tag_muzzfle_b",7* symbol_proj_angle,0);
			symbol_missileattack(self,"tag_no",0,0);
		}

		self.attack_finished = time + random(0,1);
		self.pflags = 0;
	}
	self.velocity * 0.95;
};


void() symbolshoot14 =[$symbolshoot14, symbolshoot15]
{

	ai_face();
	self.glowmod = '0.9 0.9 0.9';
	self.nextthink = time + 0.05;


	////setsize(self, '-48 -48 -48', '48 48 48');

	symbolrmovement(0,self);



};
void() symbolshoot15 =[$symbolshoot15, symbolshoot16]{ai_face();self.glowmod = '0.85 0.85 0.85';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.95;};
void() symbolshoot16 =[$symbolshoot16, symbolshoot17]{ai_face();self.glowmod = '0.8 0.8 0.8';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.95;};
void() symbolshoot17 =[$symbolshoot17, symbolshoot18]{ai_face();self.glowmod = '0.75 0.75 0.75';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.95;};
void() symbolshoot18 =[$symbolshoot18, symbolshoot19]{ai_face();self.glowmod = '0.7 0.7 0.7';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.92;


	float r = random();
	if(r > 0.5)
	{
		if(visible(self.enemy))
		{
			self.think = symbolshoot1;
		}
	}
};
void() symbolshoot19 =[$symbolshoot19, symbolshoot20]{ai_face();self.glowmod = '0.65 0.65 0.65';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.9;};
void() symbolshoot20 =[$symbolshoot20, symbolshoot21]{ai_face();self.glowmod = '0.6 0.6 0.6';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.9;};
void() symbolshoot21 =[$symbolshoot21, symbolshoot22]{ai_face();self.glowmod = '0.55 0.55 0.55';self.nextthink = time + 0.05;self.velocity = self.velocity * 0.9;};
void() symbolshoot22 =[$symbolshoot22, symbolshoot23]{ai_face();self.glowmod = '0.5 0.5 0.5';self.nextthink = time + 0.05;};
void() symbolshoot23 =[$symbolshoot23, symbolshoot24]{ai_face();self.nextthink = time + 0.05;};
void() symbolshoot24 =[$symbolshoot24, symbolshoot25]{ai_face();self.nextthink = time + 0.05;};
void() symbolshoot25 =[$symbolshoot25, symbolshoot26]{ai_face();self.nextthink = time + 0.05;};
void() symbolshoot26 =[$symbolshoot26, symbolshoot27]{ai_face();self.nextthink = time + 0.05;};
void() symbolshoot27 =[$symbolshoot27, symbolshoot28]{ai_face();self.nextthink = time + 0.05;};
void() symbolshoot28 =[$symbolshoot28, symbolshoot29]
{
	ai_face();	
	if((self.enemy) &&(self.enemy.health < 0))
	{
		self.nextenemy_time = 0;
		next_enemy();
		self.think = symbol_run1;
		return;
	}
	self.nextthink = time + 0.05;
};
void() symbolshoot29 =[$symbolshoot29, symbol_run1]
{
	ai_face();
	SUB_AttackFinished(2);


	if(self.symbol_sliding <= 0)
		self.symbol_sliding = random (45,90);
	else
		self.symbol_sliding = random (-90,-45);

	self.think = symbolAttackFinished;


	float r = random();


	
	float v_dist = self.enemy.origin_z - self.origin_z;

	
	if ((zoom_down_check(-192)) || (v_dist > random(-64,0)))
	{
		if((r < 0.5) || (!visible(self.enemy)))
			self.think = symbol_shortfly;
		else
		{
			if((visible(self.enemy)))
				self.think = symbolshoot1;	
		}
	}
	else
	{
		float r2 = random();
		float roofreachable = zoom_up_check();
		if ((zoom_down_check(-192)&& (roofreachable > 0)) && (r2 < 0.33) )
		{	
			if (roofreachable == 1)
				self.think = symbol_shortfly;
			else	
				self.think = symbol_fly1;
		}

		else
		{
			if((visible(self.enemy)))
				self.think = symbolshoot1;	
		}

	}

	self.nextthink = time + 0.05;
};

void() symbol_fly1 =[$symbolflyup1, symbol_fly2]{
	ai_face();
	self.movetype = MOVETYPE_FLY;
	self.velocity = '0 0 64';
	chattersound("enemies/symbol/idle", 3, 1);
};
void() symbol_fly2 =[$symbolflyup2, symbol_fly3]{ai_face();self.velocity = '0 0 48';};
void() symbol_fly3 =[$symbolflyup3, symbol_fly4]{ai_face();self.velocity = '0 0 32';};
void() symbol_fly4 =[$symbolflyup4, symbol_fly5]{ai_face();self.velocity = self.velocity * 3;};
void() symbol_fly5 =[$symbolflyup5, symbol_fly6]{ai_face();};
void() symbol_fly6 =[$symbolflyup6, symbol_fly7]{ai_face();};
void() symbol_fly7 =[$symbolflyup7, symbol_fly8]{ai_face();};
void() symbol_fly8 =[$symbolflyup8, symbol_fly9]{ai_face();};
void() symbol_fly9 =[$symbolflyup9, symbol_fly10]{ai_face();};
void() symbol_fly10 =[$symbolflyup10, symbol_fly11]{ ai_face();};
void() symbol_fly11 =[$symbolflyup11, symbol_fly12]{ai_face();self.velocity = self.velocity * 2;};
void() symbol_fly12 =[$symbolflyup12, symbol_fly13]{ai_face();self.velocity = self.velocity * 3;};
void() symbol_fly13 =[$symbolflyup13, symbol_fly14]{ai_face();};
void() symbol_fly14 =[$symbolflyup14, symbol_fly15]{ai_face();



};
void() symbol_fly15 =[$symbolflyup15, symbol_fly16]{ai_face();self.nextthink = time + 0.05;};
void() symbol_fly16 =[$symbolflyup16, symbol_fly17]{ai_face();self.nextthink = time + 0.05;};
void() symbol_fly17 =[$symbolflyup17, symbol_fly18]{ai_face();self.nextthink = time + 0.05;};
void() symbol_fly18 =[$symbolflyup18, symbol_fly19]{ai_face();self.nextthink = time + 0.05;};
void() symbol_fly19 =[$symbolflyup19, symbol_fly20]{ai_face();self.nextthink = time + 0.05;
self.nextthink = time + 0.05;
self.glowmod = '0.6 0.6 0.6';
self.pflags =129;
self.light_lev = 3.5;
self.color ='0.75 0.1 0.1';
};
void() symbol_fly20 =[$symbolflyup20, symbol_fly21]{ai_face();self.nextthink = time + 0.05;self.light_lev += 3; self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly21 =[$symbolflyup21, symbol_fly22]{ai_face();self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly22 =[$symbolflyup22, symbol_fly23]{ai_face();self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly23 =[$symbolflyup23, symbol_fly24]{ai_face();self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly24 =[$symbolflyup24, symbol_fly25]{ai_face();self.velocity = self.velocity * 0.7;self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly25 =[$symbolflyup25, symbol_fly26]{ai_face();self.velocity = self.velocity * 0.8;self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly26 =[$symbolflyup26, symbol_fly27]{ai_face();self.velocity = self.velocity * 0.9;self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly27 =[$symbolflyup27, symbol_fly28]{ai_face();self.velocity = self.velocity * 0.9;self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly28 =[$symbolflyup28, symbol_fly29]{ai_face();self.velocity = self.velocity * 0.9;self.nextthink = time + 0.05;self.light_lev += 3;self.glowmod += '0.05 0.05 0.05';};
void() symbol_fly29 =[$symbolflyup29, symbolshoot10]{self.light_lev += 3;
ai_face();self.velocity = self.velocity * 0.9;self.glowmod += '0.05 0.05 0.05';
self.wrath_time = 1;	
};



void()symbolshoot =
{
	ai_face();
	float dist = vlen (self.origin - self.enemy.origin);
	if (dist < 1)
		dist = 1;
	float r = random();
	
	if((zoom_down_check(-192)) && (r > 0.5))
		self.think = symbol_fly1;
	else
		self.think = symbolshoot1;
	self.nextthink = time;
};

void() symbol_forward {

	//if(self.enemy.health > 0)
	ai_face();
	makevectors2 (self.angles);
	self.velocity =v_forward * 382;
};

void() symbol_shortfly =[$symbolwalk10, symbol_shortfly1]{self.movetype = MOVETYPE_WALK;

symbol_forward();self.velocity_z = 192;

//self.colormod = '1 1 0';
};
void() symbol_shortfly1 =[$symbolwalk11, symbol_shortfly2]{symbol_forward();self.velocity_z = 192;};
void() symbol_shortfly2 =[$symbolwalk12, symbol_shortfly3]{symbol_forward();self.velocity_z = 192;};
void() symbol_shortfly3 =[$symbolwalk13, symbol_shortfly4]{symbol_forward();self.velocity_z = 192;};
void() symbol_shortfly4 =[$symbolwalk14, symbol_shortfly5]{symbol_forward();self.velocity_z = 192;};
void() symbol_shortfly5 =[$symbolwalk15, symbol_shortfly6]{symbol_forward();self.velocity_z = 192;};
void() symbol_shortfly6 =[$symbolwalk16, symbol_shortfly7]{ai_face();self.velocity = self.velocity * 0.9;};
void() symbol_shortfly7 =[$symbolwalk17, symbol_shortfly8]{ai_face();self.velocity = self.velocity * 0.9;};
void() symbol_shortfly8 =[$symbolwalk18, symbol_shortfly9]{ai_face();self.velocity = self.velocity * 0.9;};
void() symbol_shortfly9 =[$symbolwalk19, symbol_run1]
{
	self.velocity = self.velocity * 0.9;
	self.movetype = MOVETYPE_STEP;
	self.wrath_time = 1;	
	if((visible(self.enemy)))
		self.think = symbolshoot10;
	
	self.colormod = '1 1 1';
};


void() double_fps =
{
	if(self.think)
		self.nextthink = time + 0.05;
	if(self.movetype != MOVETYPE_STEP)
		self.velocity =self.velocity * 0.9;
};

void() symbol_pain1 =[$symbolpainb1, symbol_pain2]{self.glowmod = '0.4 0.4 0.4';self.pain_finished = time + 2.75; self.velocity =self.velocity * 0.9;};
void() symbol_pain2 =[$symbolpainb2, symbol_pain3]{self.glowmod = '0.3 0.3 0.3';self.velocity =self.velocity * 0.9;};
void() symbol_pain3 =[$symbolpainb3, symbol_pain4]{self.glowmod = '0.2 0.2 0.2';self.velocity =self.velocity * 0.9;};
void() symbol_pain4 =[$symbolpainb4, symbol_pain5] {self.velocity =self.velocity * 0.9;};
void() symbol_pain5 =[$symbolpainb5, symbol_pain6] {self.velocity =self.velocity * 0.9;};
void() symbol_pain6 =[$symbolpainb6, symbol_pain7]{self.glowmod = '0.25 0.25 0.25';self.velocity =self.velocity * 0.9;};
void() symbol_pain7 =[$symbolpainb7, symbol_pain8]{self.glowmod = '0.3 0.3 0.3';self.velocity =self.velocity * 0.9;};
void() symbol_pain8 =[$symbolpainb8, symbol_pain9]{self.glowmod = '0.35 0.35 0.35';self.velocity =self.velocity * 0.9;};
void() symbol_pain9 =[$symbolpainb9, symbol_run1]{self.glowmod = '0.45 0.45 0.45';self.movetype = MOVETYPE_STEP;};

void() symbol_spain1 =[$symbolpain1, symbol_spain2]{self.glowmod = '0.45 0.45 0.45';double_fps();self.pain_finished = time + 4.5;};
void() symbol_spain2 =[$symbolpain2, symbol_spain3]{self.glowmod = '0.425 0.425 0.425';double_fps();};
void() symbol_spain3 =[$symbolpain3, symbol_spain4]{self.glowmod = '0.4 0.4 0.4';double_fps();};
void() symbol_spain4 =[$symbolpain4, symbol_spain5]{self.glowmod = '0.375 0.375 0.375';double_fps();};
void() symbol_spain5 =[$symbolpain5, symbol_spain6]{self.glowmod = '0.35 0.35 0.35';double_fps();};
void() symbol_spain6 =[$symbolpain6, symbol_spain7]{self.glowmod = '0.325 0.325 0.325';double_fps();};
void() symbol_spain7 =[$symbolpain7, symbol_spain8]{self.glowmod = '0.3 0.3 0.3';double_fps();};
void() symbol_spain8 =[$symbolpain8, symbol_spain9]{self.glowmod = '0.275 0.275 0.275';double_fps();};
void() symbol_spain9 =[$symbolpain9, symbol_spain10]{self.glowmod = '0.25 0.25 0.25';double_fps();};
void() symbol_spain10 =[$symbolpain10, symbol_spain11]{self.glowmod = '0.225 0.225 0.225';double_fps();};
void() symbol_spain11 =[$symbolpain11, symbol_spain12]{self.glowmod = '0.2 0.2 0.2';double_fps();};
void() symbol_spain12 =[$symbolpain12, symbol_spain13]{self.glowmod = '0.175 0.175 0.175';double_fps();};
void() symbol_spain13 =[$symbolpain13, symbol_spain14]{self.glowmod = '0.15 0.15 0.15';double_fps();};
void() symbol_spain14 =[$symbolpain14, symbol_spain15]{self.glowmod = '0.125 0.125 0.125';double_fps();};
void() symbol_spain15 =[$symbolpain15, symbol_spain16]{self.glowmod = '0.1 0.1 0.1';double_fps();};
void() symbol_spain16 =[$symbolpain16, symbol_spain17]{double_fps();};
void() symbol_spain17 =[$symbolpain17, symbol_spain18]{double_fps();};
void() symbol_spain18 =[$symbolpain18, symbol_spain19]{double_fps();};
void() symbol_spain19 =[$symbolpain19, symbol_spain20]{double_fps();};
void() symbol_spain20 =[$symbolpain20, symbol_spain21]{double_fps();};
void() symbol_spain21 =[$symbolpain21, symbol_spain22]{double_fps();};
void() symbol_spain22 =[$symbolpain22, symbol_spain23]{double_fps();};
void() symbol_spain23 =[$symbolpain23, symbol_spain24]{double_fps();};
void() symbol_spain24 =[$symbolpain24, symbol_spain25]{double_fps();};
void() symbol_spain25 =[$symbolpain25, symbol_spain26]{double_fps();};
void() symbol_spain26 =[$symbolpain26, symbol_spain27]{double_fps();};
void() symbol_spain27 =[$symbolpain27, symbol_spain28]{double_fps();};
void() symbol_spain28 =[$symbolpain28, symbol_spain29]{double_fps();};
void() symbol_spain29 =[$symbolpain29, symbol_spain30]{double_fps();self.movetype = MOVETYPE_STEP;};
void() symbol_spain30 =[$symbolpain30, symbol_spain31]{double_fps();};
void() symbol_spain31 =[$symbolpain31, symbol_spain32]{double_fps();};
void() symbol_spain32 =[$symbolpain32, symbol_spain33]{self.glowmod = '0.15 0.15 0.15';double_fps();};
void() symbol_spain33 =[$symbolpain33, symbol_spain34]{self.glowmod = '0.2 0.2 0.2';double_fps();};
void() symbol_spain34 =[$symbolpain34, symbol_spain35]{self.glowmod = '0.25 0.25 0.25';double_fps();};
void() symbol_spain35 =[$symbolpain35, symbol_spain36]{self.glowmod = '0.3 0.3 0.3';double_fps();};
void() symbol_spain36 =[$symbolpain36, symbol_spain37]{self.glowmod = '0.35 0.35 0.35';double_fps();};
void() symbol_spain37 =[$symbolpain37, symbol_spain38]{self.glowmod = '0.4 0.4 0.4';double_fps();};
void() symbol_spain38 =[$symbolpain38, symbol_spain39]{self.glowmod = '0.45 0.45 0.45';double_fps();};
void() symbol_spain39 =[$symbolpain39, symbol_run1]{self.glowmod = '0.5 0.5 0.5';double_fps();};

void() symbol_death1 =[1, symbol_death2]
{
	self.solid = SOLID_NOT;
	self.pflags = 0;
	self.takedamage = 0;
	self.nextthink = time + 0.05;
	self.velocity_x = -200 + 400* random();
	self.velocity_y = -200 + 400* random();
	self.velocity_z = 100 + 100* random();
	self.flags = self.flags - (self.flags &FL_ONGROUND);
};


void() symbol_death2 =[2, SUB_Null]
{

	sound7(self, CHAN_VOICE2, "misc/null", 0, 0.2,100,0);
	local vector tagorg;
	local float tagindex;
	local string tagname;
	tagname = ("tag_muzzle");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	local entity bloodgib;
	bloodgib = spawn();
	bloodgib.alpha = 0.7;
	//		bloodgib.skin =  (ceil (random() *4)) *5;
	bloodgib.origin = tagorg;
	setmodel(bloodgib, "particles/explo/explo_blood4.md3");
	bloodgib.think = bloodgib_think;
	bloodgib.nextthink = time + 0.05;
	local float nparticles;
	nparticles = particleeffectnum("symbol_gib");
	pointparticles(nparticles, self.origin, '0 0 0', 1);
	//sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	tagname = ("tag_c_bl");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/c_bl.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-20 -120 190', self), 0, 0);
	tagname = ("tag_c_br");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/c_br.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-50 120 120', self), 0, 0);
	tagname = ("tag_c_tl");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/c_tl.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-70 -150 170', self), 0, 0);
	tagname = ("tag_c_tr");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/c_tr.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-90 150 70', self), 0, 0);
	tagname = ("tag_head");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('160 0 130', self), 1, 0);
	tagname = ("t_bl");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/t_bl.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-150 -120 130', self), 1, 0);
	tagname = ("t_bm");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/t_bm.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-150 0 160', self), 0, 1);
	tagname = ("t_br");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/t_br.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-170 120 120', self), 0, 0);
	tagname = ("t_fl");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/t_fl.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('250 -150 150', self), 1, 0);
	tagname = ("t_fm");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/t_fm.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('270 0 120', self), 0, 1);
	tagname = ("t_fr");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/symbol/gibs/t_fr.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('240 160 180', self), 0, 0);


	tagorg = tag_origin("", self);
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib11, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib12, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib13, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib14, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib15, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib16, self), 0, 3);	// relvel: forward, right, up
	sound(self, CHAN_BODY, "misc/null.wav", 0, 1);
	sound(self, CHAN_ITEM, "misc/null.wav", 0, 1);
	sound(self, CHAN_WEAPON, "misc/null.wav",0, 1);
	sound(self, CHAN_VOICE, "misc/null.wav", 0, 1);
	sound(self, CHAN_ITEM, "misc/null.wav", 0, 1);
	sound(self, CHAN_FOOT, "misc/null.wav", 0, 1);
	sound(self, CHAN_ITEM, "enemies/heretic/end_chase.ogg", 0.1, 0.25);
	explo_blood(3, tagorg);
	explo_blood(7, tagorg);


	pointparticles(particleeffectnum("heretic_bloodshower"), self.origin + '0 0 96', '0 0 0', 1);
	pointparticles(particleeffectnum("heretic_bloodshower"), self.origin + '0 0 12', '0 0 0', 1);
	pointparticles(particleeffectnum("heretic_bloodshower"), self.origin + '0 0 -64', '0 0 0', 1);

	float dropammount = 128;
	while(dropammount > 0)
	{
		vector vparticle;
		vparticle_x = random (-256,256);
		vparticle_y = random (-256,256);
		vparticle_z = random (0,523);
		pointparticles(particleeffectnum("blood_drop"), self.origin + '0 0 12'+  randomvector('-64 -64 -64','64 64 192'), vparticle, 1);
		dropammount --;
	}
	self.think = SUB_Remove;
	self.nextthink = time + 0.25;
	self.alpha = -1;
	self.movetype = 0;
	
};

void() symbol_die = {	// check for gib
	self.solid = SOLID_NOT;
	self.takedamage = 0;
	painsound("enemies/symbol/die");
	symbol_death1();
};

void() random_symbolpain = { local float r;
	r = random() * self.painframe;
	self.sustained_damage = 0;
    if (r > 0.5)
		self.think = symbol_spain1;
	else
		self.think = symbol_pain1;

	self.nextthink = time;
};

void(entity attacker, float damage) symbol_pain = 
{ 

	if (self.pain_finished > time)
		return;

	if ((damage < 20) && (attacker.weapon != IT_CRYSTAL))
		return;	// didn't flinch

	if(damage > 100)
		self.painframe = 1;
	else
		self.painframe = 0;
	self.pflags = 0;
	self.movetype = MOVETYPE_WALK;
	vector dir = normalize (attacker.origin - self.origin);
	self.velocity = dir * damage * -1.5;
	self.velocity_z = self.velocity_z * 0.5;
	self.velocity = normalize(self.velocity) * bound(100, vlen(self.velocity), 400);

	self.glowmod = '0.5 0.5 0.5';

	painsound("enemies/symbol/pain");

	self.think = random_symbolpain;
	self.nextthink = time;
};

void() symbol_Missile = { symbolshoot1();
};

/*
	WRATHED monster_symbol (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() precache_monster_symbol = {
	precache_model("models/enemies/symbol/symbol_tail2.md3");
	precache_model("models/enemies/symbol/symbol_tail1.md3");
	precache_model("models/enemies/symbol/symbol_head.md3");
	precache_model("models/enemies/symbol/symbol_back3.md3");
	precache_model("models/enemies/symbol/symbol_back2.md3");
	precache_model("models/enemies/symbol/symbol_back1.md3");
	precache_model("models/enemies/symbol/symbol_arm4.md3");
	precache_model("models/enemies/symbol/symbol_arm3.md3");
	precache_model("models/enemies/symbol/symbol_arm2.md3");
	precache_model("models/enemies/symbol/symbol_arm1.md3");
	precache_model("models/enemies/symbol/symbol.md3");
	precache_model("models/projectiles/proj_symbol.md3");
	precache_model("models/projectiles/proj_symbol_explo.md3");

	precache_model("models/misc/null.md3");
	precache_model("models/enemies/symbol/gibs/c_bl.md3");
	precache_model("models/enemies/symbol/gibs/c_br.md3");
	precache_model("models/enemies/symbol/gibs/c_tl.md3");
	precache_model("models/enemies/symbol/gibs/c_tr.md3");
	precache_model("models/enemies/symbol/gibs/head.md3");
	precache_model("models/enemies/symbol/gibs/t_bl.md3");
	precache_model("models/enemies/symbol/gibs/t_bm.md3");
	precache_model("models/enemies/symbol/gibs/t_br.md3");
	precache_model("models/enemies/symbol/gibs/t_fl.md3");
	precache_model("models/enemies/symbol/gibs/t_fm.md3");
	precache_model("models/enemies/symbol/gibs/t_fr.md3");
	precache_sound("misc/null");
	precache_sound("enemies/symbol/idle1.ogg");
	precache_sound("enemies/symbol/idle2.ogg");
	precache_sound("enemies/symbol/idle3.ogg");
	precache_sound("enemies/symbol/idle_loop.ogg");
	precache_sound("enemies/symbol/impact.ogg");

	precache_sound("enemies/symbol/attack1.ogg");
	precache_sound("enemies/symbol/attack2.ogg");
	precache_sound("enemies/symbol/attack3.ogg");
	precache_sound("enemies/symbol/chatter1.ogg");
	precache_sound("enemies/symbol/chatter2.ogg");
	precache_sound("enemies/symbol/chatter3.ogg");
	precache_sound("enemies/symbol/chatter4.ogg");
	precache_sound("enemies/symbol/chatter5.ogg");
	precache_sound("enemies/symbol/die1.ogg");
	precache_sound("enemies/symbol/die2.ogg");
	precache_sound("enemies/symbol/die3.ogg");
	precache_sound("enemies/symbol/pain1.ogg");
	precache_sound("enemies/symbol/pain2.ogg");
	precache_sound("enemies/symbol/pain3.ogg");
	precache_sound("enemies/symbol/proj_impact1.ogg");
	precache_sound("enemies/symbol/proj_impact2.ogg");
	precache_sound("enemies/symbol/proj_impact3.ogg");
	precache_sound("enemies/symbol/proj_loop1.ogg");
	precache_sound("enemies/symbol/proj_loop2.ogg");
	precache_sound("enemies/symbol/proj_loop3.ogg");
	precache_sound("enemies/symbol/sight1.ogg");
	precache_sound("enemies/symbol/sight2.ogg");
	precache_sound("enemies/symbol/sight3.ogg");
};


void() monster_symbol = {
	precache_model("models/enemies/symbol/symbol_tail2.md3");
	precache_model("models/enemies/symbol/symbol_tail1.md3");
	precache_model("models/enemies/symbol/symbol_head.md3");
	precache_model("models/enemies/symbol/symbol_back3.md3");
	precache_model("models/enemies/symbol/symbol_back2.md3");
	precache_model("models/enemies/symbol/symbol_back1.md3");
	precache_model("models/enemies/symbol/symbol_arm4.md3");
	precache_model("models/enemies/symbol/symbol_arm3.md3");
	precache_model("models/enemies/symbol/symbol_arm2.md3");
	precache_model("models/enemies/symbol/symbol_arm1.md3");
	precache_model("models/enemies/symbol/symbol.md3");
	precache_model("models/misc/null.md3");

	precache_sound("enemies/symbol/attack1.ogg");
	precache_sound("enemies/symbol/attack2.ogg");
	precache_sound("enemies/symbol/attack3.ogg");
	precache_sound("enemies/symbol/chatter1.ogg");
	precache_sound("enemies/symbol/chatter2.ogg");
	precache_sound("enemies/symbol/chatter3.ogg");
	precache_sound("enemies/symbol/chatter4.ogg");
	precache_sound("enemies/symbol/chatter5.ogg");
	precache_sound("enemies/symbol/die1.ogg");
	precache_sound("enemies/symbol/die2.ogg");
	precache_sound("enemies/symbol/die3.ogg");
	precache_sound("enemies/symbol/pain1.ogg");
	precache_sound("enemies/symbol/pain2.ogg");
	precache_sound("enemies/symbol/pain3.ogg");
	precache_sound("enemies/symbol/proj_impact1.ogg");
	precache_sound("enemies/symbol/proj_impact2.ogg");
	precache_sound("enemies/symbol/proj_impact3.ogg");
	precache_sound("enemies/symbol/proj_loop.ogg");
	precache_sound("enemies/symbol/proj_loop1.ogg");
	precache_sound("enemies/symbol/proj_loop2.ogg");
	precache_sound("enemies/symbol/proj_loop3.ogg");
	precache_sound("enemies/symbol/sight1.ogg");
	precache_sound("enemies/symbol/sight2.ogg");
	precache_sound("enemies/symbol/sight3.ogg");

	self.solid = SOLID_SLIDEBOX;
	self.flyer = 1;
	self.movetype = MOVETYPE_STEP;
	self.classname = "monster_symbol";
	setmodel(self, "models/enemies/symbol/symbol.md3");
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/symbol/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/symbol/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/symbol/sight1.ogg";
	self.gravity = -0.01;

	setsize(self, '-48 -48 -48', '48 48 48');
	self.health = symbol_health;
	self.max_health = symbol_health;
	self.glowmod = '0.5 0.5 0.5';
	self.th_stand = symbol_stand1;
	self.bloody = 1;
	self.scale = 1.5;
	self.th_walk = symbol_walk1;
	self.th_run = symbol_run1;
	self.th_missile = symbol_Missile;
	self.th_pain = symbol_pain;
	self.th_die = symbol_die;

	flymonster_start();
};



