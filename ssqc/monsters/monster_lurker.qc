$frame lurker_swim1

$frame lurker_preattack1

$frame lurker_charge1

$frame lurker_attack1 lurker_attack2 lurker_attack3 lurker_attack4 lurker_attack5 lurker_attack6 
$frame lurker_attack7 lurker_attack8 lurker_attack9 lurker_attack10 

$frame lurker_pain1 

$frame lurker_death1 

$frame lurker_painb1 lurker_painb2 lurker_painb3 lurker_painb4 lurker_painb5 lurker_painb6 lurker_painb7 lurker_painb8 lurker_painb9 

$frame lurker_back1 


void() swimmonster_start;
.float spinning_time;
.float infront_time;
.float lurker_attacked;
.float dot_y;
.float framecount;
void() lurker_attack1;
.float upfloat;
.float time_float;
void(float vel, float facing) ai_swim_charge =
{


	local vector vec;
	local vector yaw;
	if((time < self.time_float) && (self.velocity_z == 0))
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}

	if(facing == 1)
	{
	    vec = self.enemy.origin - self.origin;
	    yaw = vectoyaw(vec);
	    self.angles_y = yaw_y; 
	}

	self.avelocity = '0 0 0';
	self.lastplace_spoted = self.enemy.origin - rorigin(self);
	self.velocity = normalize (self.lastplace_spoted) * vel * 12;

	if(self.funcwaterlevel < 3)
    	self.velocity_z = 0;


	{
		vector idealangles = vectoangles(self.velocity);
		self.angles_y = idealangles_y;
	}
	self.oldorigin = self.origin;

};
.float search_time;
.float lurker_roam_time;
.float lurker_jump_time;
.float lurker_jump_moment;

void()lurker_preattack;

void(vector dest) rotate_lurker =
{
	makevectors2 (self.angles);

	if(self.angles_y < 0)
	self.angles_y = 0;

	if(self.angles_y < 360)
	float normalized_angles = floor (self.angles_y);
	else
	normalized_angles  = floor (self.angles_y % 360);


	float view_angles_atenemy = vectoyaw (dest - rorigin(self));
		
	float rotate_y = max(normalized_angles,view_angles_atenemy) - min(normalized_angles,view_angles_atenemy);
	//if(facing == 1)
	rotate_y = 180;
	self.avelocity = '0 0 0';

	if(view_angles_atenemy > normalized_angles)
	{
		if((view_angles_atenemy >= 270) && (normalized_angles < 90))
			self.avelocity_y = rotate_y * -1;
		else		
			self.avelocity_y = rotate_y * 1;
	}
	else
	{
		if((view_angles_atenemy <= 90) && (normalized_angles > 270))
			self.avelocity_y = rotate_y * 1;
		else		
			self.avelocity_y = rotate_y * -1;
	}
	{
		vector idealangles = vectoangles(self.velocity);
		self.angles_y = idealangles_y;
	}
};
.vector lurker_dest;
.float alert_time;

.float no_hunting_time;
void() lurker_stand1;
void() lurker_roaming1;

void() lurker_hide = [$lurker_swim1, lurker_hide] 
{
	vector dir = normalize(self.origin - self.enemy.origin);
	self.velocity = dir * 512;
	self.velocity_z -= 92;

	if(self.lurker_roam_time < time)
		self.think = lurker_roaming1;

	self.nextthink = time + 0.05;
};

.float waiting_time;
void() lurker_wait1 =[$lurker_swim1, lurker_wait1] 
{
	float enemy_is_visible = visible(self.enemy);
	if((enemy_is_visible == 1))
	self.think = lurker_preattack;
	self.waiting_time = time + 3;

	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	ChangeYaw();
	self.nextthink = time + 0.05;
};

void() lurker_roaming1  =[$lurker_swim1, lurker_roaming1] 
{

	float speed = vlen(self.velocity);

	self.yaw_speed = 25;

	if((speed <10) || (self.oldorigin == self.origin))
		self.lurker_roam_time = 0;

	self.movetype = MOVETYPE_FLY;

	float enemy_is_visible = visible(self.enemy);
	float disttoplayer = vlen(self.enemy.origin - self.origin);

	if((enemy_is_visible == 1)&& (disttoplayer < 128)) 
	{
		self.think = lurker_preattack;

		self.nextthink = time;
		return;
	}

	if((enemy_is_visible == 1) && (self.no_hunting_time < time))
	{
		float r = random();
		if((self.enemy.origin_z > self.pool.absmax_z + 32) && ((self.lurker_jump_time > time)&& (disttoplayer < 468) || (r < 0.1))) 
		{
			vector dir = normalize(self.origin - self.enemy.origin);
			self.velocity = dir * 512;
			self.velocity_z -= 92;
			self.lurker_dest = dir * 2048;
			self.lurker_roam_time = time + (1.5,3);
			self.avelocity = '0 0 0';
			self.think = lurker_hide;
			self.nextthink = time + 0.05;
			return;
		}


		self.think = lurker_preattack;

		self.nextthink = time;
	}
	else
	{	
		if(self.alert_time < time)
		{
			self.think = lurker_wait1;
			self.avelocity = '0 0 0';
			self.velocity = '0 0 0';
			self.nextthink = time;
			return;
		}


		if(self.lurker_roam_time < time)
		{
			makevectors(self.angles);
			tracebox(self.origin, '-7 -7 -7', '7 7 7', self.origin - '0 0 128', FALSE, self);
			if (trace_fraction == 1.0)
				self.velocity_z = random(-64,-128);
			else
				self.velocity_z = random(16,32);

			tracebox(self.origin, '-7 -7 -7', '7 7 7', self.origin + v_forward * 128, FALSE, self);
			if (trace_fraction == 1.0)
				self.velocity += v_forward * 128;	
			else
				self.velocity -= v_forward * 128;	


			float r = random();
			if(r < 0.5)
			{
				tracebox(self.origin, '-7 -7 -7', '7 7 7', self.origin + v_right * 128, FALSE, self);
				if (trace_fraction == 1.0)
					self.velocity += v_right * random(32,96);	
				else
				if (trace_fraction == 1.0)
					self.velocity += v_right *random(-96,-32);	
			}
			else
			{
				tracebox(self.origin, '-7 -7 -7', '7 7 7', self.origin + v_right * -128, FALSE, self);
				if (trace_fraction == 1.0)
					self.velocity += v_right * random(-96,-32);	
				else
				if (trace_fraction == 1.0)
					self.velocity += v_right * random(32,96);	
			}

			self.lurker_roam_time = time + random (3,7);

			vector dir = normalize ((self.origin + self.velocity) - self.origin);
			self.lurker_dest =dir * 2048;

		}
		//rotate_lurker(self.lurker_dest);
	}

	if((self.origin_z >= (self.pool.absmax_z - 64)))
	self.velocity_z = -32;


	if((self.funcwaterlevel < 3)&& (self.funcwaterlevel > 1)&& (self.liquidtouch_timing > time))
	{
		if((self.funcwaterlevel == 2))
			self.velocity_z = -64;
		else
			self.velocity_z = -380;

		if(self.surfacing_sound_time < time)
		{
		vector wsorg = self.origin;
		wsorg_z =self.pool.absmax_z;

		pointparticles(particleeffectnum("water_splash"), wsorg, 0, 1);

		monstersound3("player/water_surfacing", 3, CHAN_AUTO);	
		self.surfacing_sound_time = time + random(0.5,3);
		}
	}

	if((self.liquidtouch_timing < time) && (self.velocity != '0 0 0'))
	{
		self.velocity = '0 0 -92';
		self.movetype = MOVETYPE_TOSS;
	}

	self.oldorigin = self.origin;


	self.angles_x = 0;
	vector dest = self.origin + self.velocity;
	self.ideal_yaw = vectoyaw(dest - self.origin);
	ChangeYaw();


	//vector yangles = vectoangles(self.velocity);
	//self.angles_y = yangles_y;

};


void()lurker_stand1;
void() lurker_melee;


void() lurker_falling =
{
	vector wsorg = self.origin;
	wsorg_z =self.pool.absmax_z;
	
	if(self.oldorigin != self.origin)
		self.angles = vectoangles(self.velocity);

	if((self.liquidtouch_timing > time) &&(self.funcwaterlevel >= 1) && ( self.velocity_z < 0))
	{
		self.gravity = 0.5;
		pointparticles(particleeffectnum("water_splash"), wsorg, '0 0 0', 2);
		pointparticles(particleeffectnum("water_splash2"), wsorg, '0 0 0', 2);
	}
	if(self.funcwaterlevel >= 1)
	{
		pointparticles(particleeffectnum("water_splash"), wsorg, 0, 4);
		pointparticles(particleeffectnum("water_splash2"), wsorg, '0 0 0', 2);
		monstersound3("player/water_surfacing", 3, CHAN_AUTO);
		self.movetype = MOVETYPE_FLY;
		self.think = lurker_preattack;
		self.nextthink = time + 3;
		return;
	}
	if(self.oldorigin == self.origin)
	{
		self.movetype = MOVETYPE_FLY;
		self.think = lurker_preattack;
		self.nextthink = time + 0.05;
		return;
	}
	self.oldorigin = self.origin;
	self.think = lurker_falling;
	self.nextthink = time + 0.05;
};

void()lurker_vcharge =
{

	if(!(visible(self.enemy)))
		return;
	vector delta = self.enemy.origin - self.origin;
	vector dir;
	{
		self.movetype = MOVETYPE_BOUNCE;
		dir = normalize ( self.pos1 - self.origin);			
		self.velocity = dir * 512;
		self.lurker_dest = dir * 2048;
		rotate_lurker(self.lurker_dest);
		return;
	}
};



void() lurker_charge1        =[      $lurker_attack1,       lurker_charge2 ] {
self.lurker_attacked = 0;
self.nextthink = time + 0.1;
};
void() lurker_charge2        =[      $lurker_attack2,       lurker_charge3 ] {self.nextthink = time + 0.1;};
void() lurker_charge3        =[      $lurker_attack3,       lurker_charge4 ] {self.nextthink = time + 0.1;};
void() lurker_charge4        =[      $lurker_attack4,       lurker_charge5 ] {;self.nextthink = time + 0.05;lurker_melee();ai_swim_charge(10,1);};
void() lurker_charge5        =[      $lurker_attack5,       lurker_charge6 ] {self.nextthink = time + 0.05;lurker_melee();ai_swim_charge(10,1);};
void() lurker_charge6        =[      $lurker_attack6,       lurker_charge7 ] {self.nextthink = time + 0.05;lurker_melee();ai_swim_charge(10,1);};
void() lurker_charge7        =[      $lurker_attack7,       lurker_charge8 ] {self.nextthink = time + 0.05;};
void() lurker_charge8        =[      $lurker_attack8,       lurker_charge9 ] {lurker_vcharge();self.nextthink = time + 0.05;};
void() lurker_charge9        =[      $lurker_attack9,       lurker_charge10 ] {self.nextthink = time + 0.05;
self.movetype = MOVETYPE_BOUNCE;
};
void() lurker_charge10        =[      $lurker_attack10,       lurker_falling ] {lurker_falling();self.nextthink = time + 0.05;
self.velocity = '0 0 -260';
};
void()lurker_postcharge =
{

	if((self.funcwaterlevel == 2))
		self.velocity_z = 0;
	else
		self.velocity_z = -120;
	self.think = lurker_charge1;
	self.nextthink = time;
};
void()lurker_precharge1 = 
{
	self.movetype = MOVETYPE_BOUNCE;
	if(self.velocity_z <= 1)
	{
			self.effects = 0;
		vector lurkervel, dir;
		vector dir = normalize (self.enemy.origin - self.origin);
		self.movetype = MOVETYPE_WALK;
		self.velocity = dir * 1200;
		self.avelocity = '0 0 0';
		self.lurker_attacked = 0;
		self.angles = vectoangles(self.velocity);
		self.think = lurker_postcharge;
		self.nextthink = time + 0.25;
		return;
	}
	self.think = lurker_precharge1;
	self.nextthink = time + 0.1;
}; 

void(float vel, float facing, float walking) ai_swim = 
{

	if(self.oldorigin == self.origin)
	{
		check_angles_heretic(64);
		float sor = 1;
	}
	self.gravity = 1;

	if((time < self.time_float) && (self.velocity_z == 0))
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}


	float enemy_is_visible = visible(self.enemy);
	if ((!enemy_is_visible) && (self.search_time < time))
	{
		//self.enemy = 0;
		self.think = lurker_roaming1;
		self.nextthink = time + 0.1;
		return;
	}


	if(sor != 1)
	{

		float disttoplayer  =  vlen (self.enemy.origin - self.origin);
		if((enemy_is_visible ) )
		{
			self.lastplace_spoted = self.enemy.origin - rorigin(self);
			self.search_time =  time + random (3,7);
		}

		if(walking ==  1)
			self.lastplace_spoted = self.goalentity.origin- rorigin(self);
	}

	makevectors2 (self.angles);

	if(self.angles_y < 0)
	self.angles_y = 0;

	if(self.angles_y < 360)
	float normalized_angles = floor (self.angles_y);
	else
	normalized_angles  = floor (self.angles_y % 360);


	float view_angles_atenemy = (vectoyaw (self.enemy.origin - rorigin(self)));
	if(walking ==  1)
	view_angles_atenemy = (vectoyaw (self.goalentity.origin - rorigin(self)));
		
	float rotate_y = max(normalized_angles,view_angles_atenemy) - min(normalized_angles,view_angles_atenemy);
	if(facing == 1)
	rotate_y = 180;
	self.avelocity = '0 0 0';



	if(view_angles_atenemy > normalized_angles)
	{
		if((view_angles_atenemy >= 270) && (normalized_angles < 90))
			self.avelocity_y = rotate_y * -1;
		else		
			self.avelocity_y = rotate_y * 1;
	}
	else
	{
		if((view_angles_atenemy <= 90) && (normalized_angles > 270))
			self.avelocity_y = rotate_y * 1;
		else		
			self.avelocity_y = rotate_y * -1;
	}
	


//	string viewxanglesfactor = strcat ( ftos(self.funcwaterlevel),  (" waterlevel\n"));
//	bprint (viewxanglesfactor);

	self.velocity = normalize (self.lastplace_spoted) * vel * 12;


	float r = random ();

	if((self.origin_z >= (self.pool.absmax_z - 32)))
	self.velocity_z = -32;


	float disttoplayer = vlen(self.enemy.origin - self.origin);

	if((self.funcwaterlevel < 3)&& (self.funcwaterlevel > 1)&& (self.liquidtouch_timing > time))
	{
		if((self.funcwaterlevel == 2))
			self.velocity_z = -64;
		else
			self.velocity_z = -380;

		if(self.surfacing_sound_time < time)
		{
		vector wsorg = self.origin;
		wsorg_z =self.pool.absmax_z;

		pointparticles(particleeffectnum("water_splash"), wsorg, 0, 1);

		monstersound3("player/water_surfacing", 3, CHAN_AUTO);	
		self.surfacing_sound_time = time + random(0.5,3);
		}


		if ((r <= 0.75) && (self.lurker_jump_time < time) && (disttoplayer < 128))
		{
			self.lurker_jump_time = time +  random(7,12);
			self.movetype = MOVETYPE_FLYMISSILE;
			pointparticles(particleeffectnum("water_splash"), wsorg, 0, 3);
    		pointparticles(particleeffectnum("water_splash2"), wsorg, '0 0 0', 2);
			vector dir = normalize ( (self.enemy.origin + '0 0 16')- self.origin);
			self.lurker_jump_moment = time + 1;
			vector lurkervel;
			lurkervel = dir * 512;
			lurkervel += 192;
			self.velocity_z += lurkervel_z;
			self.velocity = dir * -128;
			self.effects = 512;
			self.avelocity = '0 0 0';
			self.pos1 = self.origin - '0 0 64';
			self.lurker_attacked = 0;
			sound (self, CHAN_VOICE, "enemies/lurker/sight1.ogg", 1, ATTN_NORM);
			self.angles = vectoangles(self.velocity);
			self.think = lurker_precharge1;
			self.nextthink = time + 0.75;
		}
	}
	self.angles_x = 0;	
	self.oldorigin = self.origin;
	if((self.liquidtouch_timing < time) && (self.velocity != '0 0 0'))
	{
		self.velocity = '0 0 -92';
		self.movetype = MOVETYPE_TOSS;
	}

};

void(float dist) ai_swim_walk = 
{
	
	if((self.liquidtouch_timing < time) && (self.velocity != '0 0 0'))
	{
		self.velocity = '0 0 -92';
		self.movetype = MOVETYPE_TOSS;
	}

	if (self.pathed != 1)
	{
		if (FindTarget())
			return;
	}
	else
	{
		if (self.pathtime < time)
		{
			if (FindTarget())
				return;
		}
	}

	if (self.friendly_monster == 1 && vlen(self.origin - self.goalentity.origin) < 80)
	{
		self.pausetime = time + 1.5;
		self.th_stand();
	}
	if(self.enemy != world)
	self.th_run();
	ai_swim(dist,0,1);
};





void()lurker_preattack1;
void()lurker_attack1;

void() lurker_stand1  =[$lurker_swim1, lurker_stand1] 
{
	if(time < self.time_float)
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}

	touchtriggers(self);
	ai_stand();

	self.waiting_time = time + 1;
	float r = random();


	entity nextenemy = single_player;

	if (random() < 0.2)
		self.ideal_yaw = vectoyaw(rorigin(nextenemy) - rorigin(self));
	ChangeYaw();

	if(r < 0.03)
	{	
		if ((self.idle_time < time) && !(self.spawnflags &1))
		{
			chattersound("enemies/lurker/idle", 3, 0.5);
			self.idle_time = time + random(5,10);
		}
	}
};


void() lurker_walk1  =[$lurker_swim1, lurker_walk1] {ai_swim_walk(8);};



void() lurker_charge = [$lurker_charge1, lurker_charge] 
{
	float r = random();
	if (r < 0.25)	
		ai_swim (25,1,0);
	else
		ai_swim (25,0,0);
	if(self.oldorigin == self.origin)
	{
		self.think = lurker_roaming1;
		self.nextthink = time + 0.1;
		self.no_hunting_time = time + random(1.5,3);
		return;
	}	

	if(self.framecount == 0)
	{
		if(self.zigzaging == 1)
			self.zigzaging  = 0;
		else
			self.zigzaging  = 1;
	}

	self.framecount ++;

	if(self.framecount >= 8)
	{
		float disttoplayer  =  vlen (self.enemy.origin - self.origin);
		self.framecount = 0;	
		if((disttoplayer < 92) &&  visible(self.enemy))
			self.think = lurker_attack1;
		else
			self.think = lurker_charge;
	}
	self.oldorigin = self.origin;
};



void() lurker_preattack =
{

	if (random() < 0.05)
	sound (self, CHAN_VOICE, "enemies/lurker/sight1.ogg", 1, ATTN_NORM);
	self.frame = $lurker_preattack1;
	self.framecount = 0;
	self.think = lurker_preattack1;
	self.nextthink = time;
};
void() lurker_preattack1  =[       $lurker_preattack1, lurker_preattack1] 
{
	float disttoplayer  =  vlen (self.enemy.origin - self.origin);
	ai_swim (12,1,0);
	self.framecount ++;
	if(self.framecount >= 10)
	{
	self.framecount = 0;	
	if((disttoplayer < 92) &&  visible(self.enemy))
		self.think = lurker_attack1;
	else
		self.think = lurker_charge;
	}
};


void() lurker_melee =
{
	local vector	delta;
	local float 	ldmg;
	if (!self.enemy)
		return;		// removed before stroke

	if(!(visible(self.enemy)))
		return;
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 92)
		return;
	ldmg = 20 + random(15,22);
	self.lurker_attacked = 1;
	makevectors (self.enemy.v_angle);
	T_Damage (self.enemy, self, self, ldmg);
	vector org = (self.origin * 0.75) + ((self.enemy.origin + self.enemy.view_ofs + v_forward * 8) * 0.25);
	pointparticles(particleeffectnum("NORMAL_BLOOD"),org, '0 0 0', 1);
	pointparticles(particleeffectnum("NORMAL_BLOOD2"),org, '0 0 0', 1);

	self.enemy.punchangle_x = random(-3,3);

	float totalgibs =  random(0,5);
	while(totalgibs > 1)
	{
		vector rvel;
		rvel_x = random (-64,64);
		rvel_y = random (-64,64);
		rvel_z = random (64,128);	
		SpawnGib(org,rvel);
		totalgibs --;
	}
};

void() lurker_attack1        =[      $lurker_attack1,       lurker_attack2 ] {ai_swim_charge(10,0);monstersound3("enemies/lurker/attack", 3, CHAN_AUTO);};
void() lurker_attack2        =[      $lurker_attack2,       lurker_attack3 ] {ai_swim_charge(10,1);};
void() lurker_attack3        =[      $lurker_attack3,       lurker_attack4 ] {lurker_melee();ai_swim_charge(10,1);};
void() lurker_attack4        =[      $lurker_attack4,       lurker_attack5 ] {ai_swim_charge(10,1);};
void() lurker_attack5        =[      $lurker_attack5,       lurker_attack6 ] {lurker_melee();ai_swim_charge(10,1);};
void() lurker_attack6        =[      $lurker_attack6,       lurker_attack7 ] {ai_swim_charge(10,1);};
void() lurker_attack7        =[      $lurker_attack7,       lurker_attack8 ] {lurker_melee();};
void() lurker_attack8        =[      $lurker_attack8,       lurker_attack9 ] {ai_swim_charge(10,1);

	vector delta = self.enemy.origin - self.origin;
	if ((vlen(delta) < 92) && (random()  < 0.5))
		self.think = lurker_attack3;

};
void() lurker_attack9        =[      $lurker_attack9,       lurker_attack10 ] {ai_swim_charge(10,1);};
void() lurker_attack10        =[      $lurker_attack10,       lurker_preattack ] {

	vector delta = self.enemy.origin - self.origin;
	if (vlen(delta) < 92)
		self.think = lurker_attack1;
};


void() lurker_death_gib  =
{
	self.alpha = -1;
	decal_monster_gib(self.origin + '0 0 12');
	local vector tagorg;
	tagorg = tag_origin("tag_arm_a_r", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_a_r.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 120 100', self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_b_r", self);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_b_r.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 120 80', self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_a_l", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_a_l.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -120 10', self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_b_l", self);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_b_l.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -120 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_head_a", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_head_a.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -100 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_head_b", self);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_head_b.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -0 -90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_head_c", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_head_c.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 40 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_tail_a", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_tail_a.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 40 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_tail_b", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_tail_b.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -40 -90', self), 0, 3);	// relvel: forward, right, up	remove(self);
};

void() lurker_death1 =[      $lurker_death1,        lurker_death2        ] 
{
    self.avelocity = '0 0 0';
	self.velocity = '0 0 12';


	monstersound3("enemies/lurker/die", 3, CHAN_AUTO);	
};

void() lurker_death2 =[      $lurker_death1,        lurker_death2        ] 
{
	self.solid = SOLID_TRIGGER;
	//self.movetype = MOVETYPE_TOSS;
	if((self.funcwaterlevel < 3) && (self.liquidtouch_timing > time))
	{
		if((self.funcwaterlevel == 2))
			self.velocity_z = 0;
		else
			self.velocity_z = -120;
	}

};	// gb, become nonsolid faster

void()lurker_death = 
{
	
    self.velocity = '0 0 0';
	if (self.health < -50)
		self.think = lurker_death_gib;
	else
		self.think = lurker_death1;
	self.nextthink = time;
};

void() lurker_pain1  =[$lurker_pain1, lurker_pain2 ] 
{ 
	if(self.liquidtouch_timing > time)
	{
		ai_pain(7);
		self.velocity = ' 0 0 0'; 
	}

	if(time < self.time_float)
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}

		self.avelocity = ' 0 0 0';
	monstersound3("enemies/lurker/pain", 3, CHAN_AUTO);
};
void() lurker_pain2  =[      $lurker_pain1, lurker_pain3 ] {

if(self.liquidtouch_timing > time)
	ai_pain(7);

};
void() lurker_pain3  =[      $lurker_pain1, lurker_pain4 ] {};
void() lurker_pain4  =[      $lurker_pain1, lurker_pain5 ] {};
void() lurker_pain5  =[      $lurker_pain1, lurker_pain6 ] {};
void() lurker_pain6  =[      $lurker_pain1, lurker_pain7 ] {};
void() lurker_pain7  =[      $lurker_pain1, lurker_pain8 ] {};
void() lurker_pain8  =[      $lurker_pain1, lurker_pain9 ] {};
void() lurker_pain9  =[      $lurker_pain1, lurker_pain10 ] {
if(self.movetype == MOVETYPE_FLY)
	setsize(self, heretic_bbox *-0.35, heretic_bbox *0.35);
};
void() lurker_pain10  =[      $lurker_pain1, lurker_preattack ] {};


void() pain_angles =
{

	if(self.ammo_lance == 2) 
	self.angles_z = 90;
	else
	self.angles_z = -90;

	vector  pool_rorigin = (self.pool.absmin + self.pool.absmax) *0.5; 
	self.ideal_yaw = vectoyaw(pool_rorigin - self.origin);
	self.angles_x = 0;
	ChangeYaw();
};

void() lurker_painb1  =[$lurker_painb1, lurker_painb2 ] 
{ 


	if(self.liquidtouch_timing > time)
	{
		ai_pain(7);
		self.velocity = ' 0 0 0'; 
	}
	if(time < self.time_float)
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}

		self.avelocity = ' 0 0 0';
	monstersound3("enemies/lurker/pain", 3, CHAN_AUTO);
};
void() lurker_painb2  =[      $lurker_painb2, lurker_painb3 ] {
	pain_angles();

if(self.liquidtouch_timing > time)
	ai_pain(7);

};
void() lurker_painb3  =[      $lurker_painb3, lurker_painb4 ] {pain_angles();};
void() lurker_painb4  =[      $lurker_painb4, lurker_painb5 ] {pain_angles();};
void() lurker_painb5  =[      $lurker_painb5, lurker_painb6 ] {pain_angles();};
void() lurker_painb6  =[      $lurker_painb6, lurker_painb7 ] {pain_angles();};
void() lurker_painb7  =[      $lurker_painb7, lurker_painb8 ] {pain_angles();};
void() lurker_painb8  =[      $lurker_painb8, lurker_painb9 ] {pain_angles();};
void() lurker_painb9  =[      $lurker_painb9, lurker_painb10 ] {
if(self.movetype == MOVETYPE_FLY)
	setsize(self, heretic_bbox *-0.35, heretic_bbox *0.35);
pain_angles();
};
void() lurker_painb10  =[      $lurker_painb8, lurker_roaming1 ] {

	if(self.liquidtouch_timing > time)
	{
		self.think = lurker_roaming1;
		self.pain_finished = 0;
	}
	else
	{
		self.movetype = MOVETYPE_BOUNCE;

		if(self.flags & FL_ONGROUND)
			self.flags -= FL_ONGROUND;
		vector  pool_rorigin = (self.pool.absmin + self.pool.absmax) *0.5; 
		if(self.pos1)
			pool_rorigin = self.pos1;
		vector dir = normalize (pool_rorigin - self.origin );
		self.velocity = dir * random(96,128) * 3; 
		self.velocity_z = random (64,96); 

		self.pain_finished = time + 1 + random();

		self.frame = 0;
		lurker_painb1 ();
	}
};



void(entity lurker_attacker, float damage)	lurker_pain =
{
	// lurker allways do pain frames

	if(self.pain_finished > time)
	return;
	if(self.liquidtouch_timing < time)
	{
		self.movetype = MOVETYPE_BOUNCE;

		if(self.flags & FL_ONGROUND)
			self.flags -= FL_ONGROUND;
		vector  pool_rorigin = (self.pool.absmin + self.pool.absmax) *0.5; 
		if(self.pos1)
			pool_rorigin = self.pos1;
		vector dir = normalize (pool_rorigin - self.origin );
		self.velocity = dir * random(96,128) * 3; 
		self.velocity_z = random (92,128); 
		self.pain_finished = time + 1 + random();
		self.frame = 0;
		lurker_painb1 ();
	}
	else
	{
		self.pain_finished = time + 1 + random();
		lurker_pain1 ();
	}
};

void()precache_monster_lurker =
{
	precache_sound ("enemies/lurker/attack1.ogg");
	precache_sound ("enemies/lurker/attack2.ogg");
	precache_sound ("enemies/lurker/attack3.ogg");
	precache_sound ("enemies/lurker/die1.ogg");
	precache_sound ("enemies/lurker/die2.ogg");
	precache_sound ("enemies/lurker/die3.ogg");
	precache_sound ("enemies/lurker/idle1.ogg");
	precache_sound ("enemies/lurker/idle2.ogg");
	precache_sound ("enemies/lurker/idle3.ogg");
	precache_sound ("enemies/lurker/pain1.ogg");
	precache_sound ("enemies/lurker/pain2.ogg");
	precache_sound ("enemies/lurker/pain3.ogg");
	precache_sound ("enemies/lurker/sight1.ogg");
	precache_sound ("enemies/lurker/sight2.ogg");
	precache_sound ("enemies/lurker/sight3.ogg");
	precache_model ("models/enemies/lurker.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_a_l.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_a_r.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_b_l.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_b_r.md3");
	precache_model ("models/enemies/lurker/gibs/gib_head_a.md3");
	precache_model ("models/enemies/lurker/gibs/gib_head_b.md3");
	precache_model ("models/enemies/lurker/gibs/gib_head_c.md3");
	precache_model ("models/enemies/lurker/gibs/gib_tail_a.md3");
	precache_model ("models/enemies/lurker/gibs/gib_tail_b.md3");
	precache_model ("models/artifacts/effects/life_siphon_lurker.md3");
};

void() water_checker_touch = 
{

	if(other.classname == "func_water")
		self.liquidtouch_timing = time + 0.5;
	else
		return;
};
.float lurkerpainb;
.vector lurkeroldorg;
void() water_checker_think =
{


	if((self.liquidtouch_timing > time) && ((self.owner.pain_finished < time)))
	{

		self.owner.angles_z = self.owner.angles_z * 0.7;


		if((self.owner.angles_z <= 2) &&(self.owner.angles_z > 0))
			self.owner.angles_z = 0;
		if((self.owner.angles_z >= -2) &&(self.owner.angles_z < 0))
			self.owner.angles_z = 0;

	}
	float envisible = visible (self.owner.enemy);

	if(self.owner.lurker_jump_moment > time)
	{
		self.think = water_checker_think;
		self.nextthink = time + 0.05;
		return;
	}


	if(envisible >= 1)
		self.owner.alert_time =  time + 12;
	vector  pool_rorigin = (self.owner.pool.absmin + self.owner.pool.absmax) *0.5; 
	if(!self.owner.lurkeroldorg)
		self.owner.lurkeroldorg = pool_rorigin+ randomvector ('-64 -64 -16','64 64 16');
	if((self.liquidtouch_timing > time) && (self.owner.movetype == MOVETYPE_FLY) &&(self.owner.waiting_time < time) )
	{
		if((self.oldvelocity == self.owner.origin)&& (self.owner.frame == $lurker_swim1))
		{
			self.owner.sigil_time = time + random(0.5,0.75);
			self.owner.movetype = MOVETYPE_WALK;
			makevectors2 (self.owner.angles);
			
			traceline(self.origin,self.origin + v_right * 64, FALSE, self);
			if(trace_fraction != 1)
				vector dir = v_right * -12;
			traceline(self.origin,self.origin + v_right * -64, FALSE, self);
			if(trace_fraction != 1)
				dir += v_right * 12;

			traceline(self.origin,self.origin + v_forward * 64, FALSE, self);
			if(trace_fraction != 1)
				dir += v_forward * -12;
			traceline(self.origin,self.origin + v_forward * -64, FALSE, self);
			if(trace_fraction != 1)
				dir += v_forward * 12;

			traceline(self.origin,self.origin + v_up * 64, FALSE, self);
			if(trace_fraction != 1)
				dir += v_forward * -12;
			traceline(self.origin,self.origin + v_up * -64, FALSE, self);
			if(trace_fraction != 1)
				dir += v_forward * 12;
			
			self.colormod = '1 0 0';	
			dir = normalize (dir);
			self.owner.velocity = dir * 128;
			if((!visible(single_player)) && (self.owner.alert_time < time))
			{
				setorigin(self.owner,self.owner.lurkeroldorg);
			}
		}
	}
	self.velocity = '0 0 12';
	if((self.owner.movetype == MOVETYPE_WALK) && (self.owner.sigil_time < time))
		self.owner.movetype = MOVETYPE_FLY;
	if((self.owner.movetype == MOVETYPE_BOUNCE) && (self.owner.velocity_z > 0) && (self.owner.think != lurker_falling))
		self.liquidtouch_timing = time + 0.75;
	if ((((self.origin_x > self.owner.pool.absmin_x) && (self.origin_x < self.owner.pool.absmax_x))&&
	((self.origin_y > self.owner.pool.absmin_y) && (self.origin_y < self.owner.pool.absmax_y))&&
	((self.origin_z > self.owner.pool.absmin_z) && (self.origin_z < self.owner.pool.absmax_z))) && (self.owner.pool.classname == "func_water"))
	self.liquidtouch_timing = time + 0.5;

	if((self.owner.liquidtouch_timing < time) && (self.liquidtouch_timing > time))
		self.owner.liquidtouch_timing = self.liquidtouch_timing;

	if((self.liquidtouch_timing < time) && (self.owner.movetype != MOVETYPE_TOSS))
	{

		self.owner.movetype = MOVETYPE_TOSS;

		vector  pool_rorigin = (self.owner.pool.absmin + self.owner.pool.absmax) *0.5; 
		if(self.owner.pos1)
			pool_rorigin = self.owner.pos1;
		vector dir = normalize (pool_rorigin - self.owner.origin );
		self.owner.velocity = dir * random(96,128) * 3; 
		self.owner.velocity_z = random (64,96); 
		self.owner.pain_finished = time + 1 + random();
		if(self.owner.flags & FL_ONGROUND)
			self.owner.flags -= FL_ONGROUND;

		self.owner.lurkerpainb = 1;	
		self.owner.think = lurker_painb1;
		self.owner.nextthink = time;
		T_Damage (self.owner, world, world, 1);	
		setsize(self.owner, heretic_bbox *-0.25, heretic_bbox *0.25);
	}
	if((self.liquidtouch_timing > time) && (self.owner.movetype == MOVETYPE_TOSS))
	{
		if(self.owner.lurkerpainb == 1)
		{
			self.owner.velocity = '0 0 0';
			self.owner.movetype = MOVETYPE_FLY;
			self.owner.lurkerpainb = 0;	
			self.owner.think = lurker_preattack;
			self.owner.nextthink = time;

		}
	}
	//if(self.owner.movetype == MOVETYPE_TOSS)
	//	T_Damage (self.owner, world, world, 1);	
	setorigin (self, self.owner.origin);
	if(self.owner.health <= 0)
		self.think = SUB_Remove;
	else
		self.think = water_checker_think;
	self.oldvelocity = self.owner.origin;
	self.nextthink = time + 0.05;
};
/*QUAKED monster_lurker (1 0 0) (-16 -16 -24) (16 16 24) Ambush*/
void() monster_lurker =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	self.wrathflags += FL_SWIMMER;
	self.classname = "monster_lurker";
	setmodel(self, "models/enemies/lurker/lurker.md3");
	setsize(self, heretic_bbox *-0.35, heretic_bbox *0.35);

	//gnounc
	self.noise = "lurker/idle.wav";
	self.zigzagdeviance = 128;
	self.health = 250;
	local float r;
	r = (random() *3);
	if (r <= 3)
		self.noise = "enemies/lurker/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/lurker/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/lurker/sight1.ogg";

	if(r > 1.5)
	self.ammo_lance = 2;

	self.th_stand = lurker_stand1;
	self.th_walk = lurker_walk1;
	self.th_run = lurker_preattack;
	self.th_die = lurker_death;
	self.th_pain = lurker_pain;
	self.th_melee = lurker_attack1;
	entity water_checker = spawn();
	water_checker.owner = self;
	water_checker.solid = SOLID_TRIGGER;
	setsize(water_checker,'0 0 0','1 1 1');
	water_checker.classname = "waterchecker";
	water_checker.touch = water_checker_touch;
	water_checker.origin = self.origin;
	water_checker.movetype = MOVETYPE_FLY;
	water_checker.think = water_checker_think;
	water_checker.nextthink = time;
	swimmonster_start ();
	self.lurkeroldorg = self.origin;
};

