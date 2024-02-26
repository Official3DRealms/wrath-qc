/*

==============================================================================

incisor

==============================================================================
*/

$frame inc_pose0
//0
$frame inc_idle1 inc_idle2 inc_idle3 inc_idle4 inc_idle5 inc_idle6 inc_idle7 inc_idle8 inc_idle9 
//1-9
$frame inc_walk1 inc_walk2 inc_walk3 inc_walk4 inc_walk5 inc_walk6 inc_walk7 inc_walk8 inc_walk9 
//10-18
$frame inc_run1 inc_run2 inc_run3 inc_run4 inc_run5 inc_run6 
//19-24
$frame inc_attacka1 inc_attacka2 inc_attacka3 inc_attacka4 inc_attacka5 inc_attacka6 inc_attacka7 inc_attacka8 inc_attacka9 inc_attacka10
//25-34
$frame inc_attackb1 inc_attackb2 inc_attackb3
//35-37
$frame inc_slash1 inc_slash2 inc_slash3 inc_slash4 inc_slash5 inc_slash6 inc_slash7 inc_slash8 inc_slash9 inc_slash10
//38-47
$frame inc_paina1 inc_paina2 inc_paina3 inc_paina4 inc_paina5 inc_paina6
//48-53
$frame inc_painb1 inc_painb2 inc_painb3 inc_painb4 inc_painb5 inc_painb6
//54-59
$frame inc_painc1 inc_painc2 inc_painc3 inc_painc4 inc_painc5 inc_painc6
//60-65
$frame inc_paind1 inc_paind2 inc_paind3 inc_paind4 inc_paind5
//66-71
$frame inc_deatha1 inc_deatha2 inc_deatha3 inc_deatha4 inc_deatha5 inc_deatha6 inc_deatha7 inc_deatha8 inc_deatha9 inc_deatha10 inc_deatha11
//72-82
$frame inc_deathb1 inc_deathb2 inc_deathb3 inc_deathb4 inc_deathb5 inc_deathb6 inc_deathb7 inc_deathb8 inc_deathb9 inc_deathb10 inc_deathb11
$frame inc_deathb12 inc_deathb13 inc_deathb14 inc_deathb15 inc_deathb16 inc_deathb17
//83-99

/////////////////////////////////////////////////////////////////////////////////////////////
void() loop_incisor_soundoff;
.float resting;
void()incisor_touch =
{
	if((other.classname == "player") && (self.resting == 1))
	{
		self.angles_y = vectoyaw((self.enemy.origin) - rorigin(self));
		self.ideal_yaw = self.angles_y;
		ChangeYaw();
		self.nextthink = time + 0.05;
	}
};

.entity alpha_control;
.float alpha_fade;
.float walktime2;
void() alpha_modifier =
{
	if(self.owner.walktime2 > time)
	self.owner.alpha_fade  = -1;

	if((self.alpha_fade != self.owner.alpha_fade) && (self.owner.classname ==  "monster_incisor"))
	{
		if(self.owner.alpha_fade == 1)
			sound(self, CHAN_AUTO, "enemies/prowler/cloak.ogg", 1, 0.25);
		if(self.owner.alpha_fade == -1) 
			sound(self, CHAN_AUTO, "enemies/prowler/decloak.ogg", 1, 0.25);
	}
	if((self.owner.health <= 0) && (self.cnt != 1))
	{
		self.cnt = 1;
		self.owner.alpha_fade = -1;
		self.lifetime =  time + 1;
	}
	if (self.owner.classname ==  "monster_incisor")
	{
		if((self.owner.alpha_fade == 1) ) 
		{

			if(self.owner.alpha <= 0)
				self.owner.alpha = -1;
			if (self.owner.alpha != -1)
				self.owner.alpha -= 0.05;

		}
		if(self.owner.alpha_fade == -1)
		{
			if(self.owner.alpha == -1)
				self.owner.alpha = 0.01;

			if(self.owner.alpha >= 1)
				self.owner.alpha = 1;

			if(self.owner.alpha != 1)
				self.owner.alpha += 0.05;

		}
		if(single_player.displacement_time > time)
		{
			self.owner.alpha = 1;
		}	
	}
	self.alpha_fade = self.owner.alpha_fade;

	if(((self.owner.health <= 0) ||(self.owner.classname !=  "monster_incisor")||(!self.owner.health) ) && (self.lifetime < time))
	{	
		if(self.owner.classname == "crystallised");
			self.owner.alpha = 1;
		self.think = SUB_Remove;
	}
	else
		self.think = alpha_modifier;
	self.nextthink = time + 0.05;
};

void() incisor_stand1 =[$inc_idle1, incisor_stand2]
{
	ai_stand();
	loop_incisor_soundoff();
	if(!(self.flags & FL_MONSTER))
		self.flags += FL_MONSTER;


	if ((self.sight_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/incisor/chatter", 5, 1);
		self.sight_time = time + random(5,10);
	}


	//chattersound ("enemies/prowler/inc_idle", 1, 0.5);
};
void() incisor_stand2 =[$inc_idle2, incisor_stand3]{ai_stand();};
void() incisor_stand3 =[$inc_idle3, incisor_stand4]{ai_stand();};
void() incisor_stand4 =[$inc_idle4, incisor_stand5]{ai_stand();};
void() incisor_stand5 =[$inc_idle5, incisor_stand6]{ai_stand();};
void() incisor_stand6 =[$inc_idle6, incisor_stand7]{ai_stand();};
void() incisor_stand7 =[$inc_idle7, incisor_stand8]{ai_stand();};
void() incisor_stand8 =[$inc_idle8, incisor_stand9]{ai_stand();};
void() incisor_stand9 =[$inc_idle9, incisor_stand1]{ai_stand();};

/////////////////////////////////////////////////////////////////////////////////////////////

void() incisor_walk1 =[$inc_walk1, incisor_walk2]{ai_walk(24);
	self.movetype = MOVETYPE_STEP;

	if ((self.sight_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/incisor/chatter", 5, 1);
		self.sight_time = time + random(3,7);
	}

};
void() incisor_walk2 =[$inc_walk2, incisor_walk3]{ai_walk(24);};
void() incisor_walk3 =[$inc_walk3, incisor_walk4]{ai_walk(24);};
void() incisor_walk4 =[$inc_walk4, incisor_walk5]{ai_walk(24);walksound("enemies/prowler/step", 3);};
void() incisor_walk5 =[$inc_walk5, incisor_walk6]{ai_walk(24);};
void() incisor_walk6 =[$inc_walk6, incisor_walk7]{ai_walk(24);};
void() incisor_walk7 =[$inc_walk7, incisor_walk8]{ai_walk(24);walksound("enemies/prowler/step", 3);};
void() incisor_walk8 =[$inc_walk8, incisor_walk9]{ai_walk(24);};
void() incisor_walk9 =[$inc_walk9, incisor_walk1]{ai_walk(24);};

/////////////////////////////////////////////////////////////////////////////////////////////
void() incisor_atka1;
void() incisor_atkb1;
void() incisor_run3;
void() incisor_run5;

void() incisor_jump = { if ((vlen(self.velocity) < 30) && (self.flags &FL_ONGROUND) && (self.enemy.health > 0))
	{
		self.effects = 128;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward *250 + '0 0 150';
		if (self.flags &FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	}
};

.float runincisortime;
.float incisorscreamingtime;
void() incisor_atk = { local float r;

	if(self.alpha < 0.5)	
	self.alpha = 0.5;
	self.alpha_fade  = -1;


	if(single_player.displacement_time > time)
	self.alpha = 1;
	
	r = (random() *5);
	if (r < 5)
		string screamnoise = "enemies/prowler/attack5.ogg";	
	if (r < 4)
		screamnoise = "enemies/prowler/attack4.ogg";	
	if (r < 3)
		screamnoise = "enemies/prowler/attack3.ogg";	
	if (r < 2)
		screamnoise = "enemies/prowler/attack2.ogg";	
	if (r < 1)
		screamnoise = "enemies/prowler/attack1.ogg";

	msound(self, CHAN_VOICE, screamnoise, 0.5, 0.25);
	self.incisorscreamingtime = soundlength (screamnoise);

	r = random();
	if (r < 0.5)
		self.think = incisor_atka1;
	else
		self.think = incisor_atkb1;
	self.movetype = MOVETYPE_STEP;
	self.nextthink = time;
};

.float incisorscreaming;
void() loop_incisor_sound = { 
	/*if ((self.incisorscreaming != 1) && (self.incisorscreamingtime < time))
	{
		msound(self, CHAN_VOICE, "enemies/prowler/run.ogg", 0.5, 0.25);
		self.incisorscreaming = 1;
	}*/
};

void() loop_incisor_soundoff = { msound(self, CHAN_VOICE, "enemies/prowler/run.ogg", 0, 0);
	self.incisorscreaming = 0;
};


void(float min_angy,float max_angy) redirect_newangles =
{
	self.angles_y = self.angles_y + random(min_angy, max_angy) ;
	self.ideal_yaw = self.angles_y;
	ChangeYaw();
};

.float evading;
void() incisor_run1 =[$inc_run1, incisor_run2]
{
	self.movetype = MOVETYPE_STEP;
	self.randomattack = 0;
	self.resting = 0;
	if(self.evading != 0)
		redirect_newangles(-30,30);
	self.alpha_fade  = 1;
	ai_test_monster_run(24);

	self.nextthink = time + 0.05;
	

	if ((self.sight_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/incisor/chatter", 5, 1);
		self.sight_time = time + random(3,7);
	}


};
void() incisor_run2 =[$inc_run2, incisor_run3]{ai_test_monster_run(24);self.nextthink = time + 0.05;};
void() incisor_run3 =[$inc_run3, incisor_run4]
{
	ai_test_monster_run(24);
	walksound("enemies/prowler/step", 3);
	if ((visible2(self.enemy, 64, 0.3)) &&(self.walktime2 < time)&& (self.enemy.classname != "path_waypoint") && (self.enemy.noattack != 1) && (self.evading_time < time))
	{
		ai_face();
		self.think = incisor_atk;
	}
	self.nextthink = time + 0.05;
	walksound("enemies/prowler/step", 3);
	if(self.evading != 0)
		redirect_newangles(-70,70);
};
void() incisor_run4 =[$inc_run4, incisor_run5]{ai_test_monster_run(24);self.nextthink = time + 0.05;};
void() incisor_run5 =[$inc_run5, incisor_run6]
{
	ai_test_monster_run(24);
	if(self.evading != 0)
		redirect_newangles(-20,20);
	self.nextthink = time + 0.05;
};
void() incisor_run6 =[$inc_run6, incisor_run1]
{
	ai_test_monster_run(24);
	walksound("enemies/prowler/step", 3);
	visible2(self.enemy, FL_GODMODE, 0.3);
	if ((((visible2(self.enemy, FL_GODMODE, 0.3) &&(self.walktime2 < time)&& (self.enemy.classname != "path_waypoint")) && (self.enemy.noattack != 1)) && (self.evading_time < time)))
	{
		ai_face();
		self.resting = 0;
		self.think = incisor_atk;
		self.nextthink = time + 0.05;
		return;
	}
	if ((self.evading == 2) &&(single_player.displacement_time <= time))
	{
		self.evading = 0;
		self.resting = 1;
		self.nextthink = time + ((random() * 3) + 2);
	}
	else
	{
		self.nextthink = time + 0.05;
	}
};


void() incisor_attack =
{
	local vector delta;
	local float dist;
	local float wdmg;

	if (!self.enemy)
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	loop_incisor_soundoff();
	if ((dist > 120))
	{
		chattersound("enemies/prowler/miss", 3, TRUE);
		return;
	}
	else
	{
		wdmg = incisordamage * 0.35;
		chattersound("enemies/prowler/hit", 3, TRUE);
		T_Damage(self.enemy, self, self, wdmg);
	}
};
void() incisor_slash1 = [ $inc_slash1, incisor_slash2 ]{ai_face();ai_charge(2);};
void() incisor_slash2 = [$inc_slash2, incisor_slash3 ]{ai_face();ai_charge(2);incisor_attack();};
void() incisor_slash3 = [ $inc_slash3, incisor_slash4 ]{ai_face();ai_charge(2);incisor_attack();};
void() incisor_slash4 = [ $inc_slash4, incisor_slash5 ]{ai_face();ai_charge(2);incisor_attack();};
void() incisor_slash5 = [ $inc_slash5, incisor_slash6 ]
{
	ai_face();
	if (visible2(self.enemy, FL_GODMODE, 0.3))
	{
		if ((self.randomattack == TRUE))
		{
			self.think = incisor_atkb1;
		}
		else
		{
			self.think = incisor_atka1;
		}
	}
};
void() incisor_slash6 = [ $inc_slash6, incisor_slash7 ]{};
void() incisor_slash7 = [ $inc_slash7, incisor_slash8 ]{};
void() incisor_slash8 = [ $inc_slash8, incisor_slash9 ]{};
void() incisor_slash9 = [ $inc_slash9, incisor_slash10 ]{};
void() incisor_slash10 =
{
	self.evading = TRUE;
	redirect_newangles(150, 200);
	self.evading_time = (time + ((random() * 3) + 2));
	self.think = incisor_run1;
	self.frame = $inc_slash10;
	self.nextthink = (time + 0.1);
};

void() incisor_atkb1 = [ $inc_attackb1, incisor_atkb2 ]
{
	self.randomattack = 2;
	ai_face();
	ai_charge(MOVETYPE_PUSH);
	if ((self.incisorscreamingtime < time))
	{
		monstersound1("enemies/prowler/attack", 3, TRUE);
	}
};
void() incisor_atkb2 = [ $inc_attackb2, incisor_atkb3 ]{ai_face();ai_charge(3);};
void() incisor_atkb3 = [ $inc_attackb3, incisor_slash1 ]{ai_face();ai_charge(5);};

void() incisor_atka1 = [ $inc_attacka1, incisor_atka2 ]
{
	self.randomattack = TRUE;
	ai_face();
	ai_charge(10);
	if ((self.incisorscreamingtime < time))
	{
		monstersound1("enemies/prowler/attack", 3, TRUE);
	}
	self.nextthink = time + 0.05;
};
void() incisor_atka2 = [ $inc_attacka2, incisor_atka3 ]{ai_face();self.nextthink = time + 0.05;};
void() incisor_atka3 = [ $inc_attacka3, incisor_atka4 ]{ai_face();self.nextthink = time + 0.05;};
void() incisor_atka4 = [ $inc_attacka4, incisor_atka5 ]{ai_face();self.nextthink = time + 0.05;};
void() incisor_atka5 = [ $inc_attacka5, incisor_atka6 ]{ai_face();ai_charge(2);self.nextthink = time + 0.05;};
void() incisor_atka6 = [ $inc_attacka6, incisor_atka7 ]{ai_face();ai_charge(3);self.nextthink = time + 0.05;};
void() incisor_atka7 = [ $inc_attacka7, incisor_atka8 ]{ai_face();ai_charge(2);self.nextthink = time + 0.05;};
void() incisor_atka8 = [ $inc_attacka8, incisor_atka9 ]{ai_face();ai_charge(5);self.nextthink = time + 0.05;};
void() incisor_atka9 = [ $inc_attacka9, incisor_atka10 ]{ai_face();ai_charge(9);self.nextthink = time + 0.05;};
void() incisor_atka10 = [ $inc_attacka10, incisor_slash1 ]{ai_face();ai_charge(9);self.nextthink = time + 0.05;};

void() incisor_paina1 = [ $inc_paina1, incisor_paina2 ]{self.pain_finished = (time + 1.2);};
void() incisor_paina2 = [ $inc_paina2, incisor_paina3 ]{};
void() incisor_paina3 = [ $inc_paina3, incisor_paina4 ]{};
void() incisor_paina4 = [ $inc_paina4, incisor_paina5 ]{};
void() incisor_paina5 = [ $inc_paina6, incisor_paina6 ]{};
void() incisor_paina6 = [ $inc_paina6, incisor_run1 ]{};

void() incisor_painb1 = [ $inc_painb1, incisor_painb2 ]{self.pain_finished = (time + 1.2);};
void() incisor_painb2 = [ $inc_painb2, incisor_painb3 ]{};
void() incisor_painb3 = [ $inc_painb3, incisor_painb4 ]{};
void() incisor_painb4 = [ $inc_painb4, incisor_painb5 ]{};
void() incisor_painb5 = [ $inc_painb4, incisor_painb6 ]{};
void() incisor_painb6 = [ $inc_painb5, incisor_run1 ]{};

void() incisor_painc1 = [ $inc_painc1, incisor_painc2 ]{self.pain_finished = (time + 1.2);};
void() incisor_painc2 = [ $inc_painc2, incisor_painc3 ]{};
void() incisor_painc3 = [ $inc_painc3, incisor_painc4 ]{};
void() incisor_painc4 = [ $inc_painc4, incisor_painc5 ]{};
void() incisor_painc5 = [ $inc_painc4, incisor_painc6 ]{};
void() incisor_painc6 = [ $inc_painc5, incisor_run1 ]{};

void() incisor_paind1 = [ $inc_paind1, incisor_paind2 ]{self.pain_finished = time + 1.2;};
void() incisor_paind2 = [ $inc_paind2, incisor_paind3 ]{};
void() incisor_paind3 = [ $inc_paind3, incisor_paind4 ]{};
void() incisor_paind4 = [ $inc_paind4, incisor_paind5 ]{};
void() incisor_paind5 = [ $inc_paind5, incisor_run1 ]{};

void() incisor_painr =
{
	loop_incisor_soundoff();
	float r = random();
	chattersound("enemies/prowler/pain", 3, TRUE);
	if ((self.randomattack <= FALSE))
	{
		if ((r < 0.5))
			self.think = incisor_painc1;
		else
			self.think = incisor_paind1;
	}
	else
	{
		if (r < 0.5)
			self.think = incisor_paina1;
		else
			self.think = incisor_painb1;
	}
	self.nextthink = time;
};

void(entity attacker, float damage) incisor_pain =
{
	self.alpha_fade = -1;
	self.evading_time = 0;
	self.alpha = 1;
	self.evading = 0;
	self.resting = 0;
	self.nextthink = time + 0.05;
	if ((self.pain_finished > time))
	{
		return;
	}
	//msound(self, 2, "enemies/prowler/run.ogg", FALSE, FALSE);
	self.sustained_damage = 0;
	self.movetype = 0;
	self.think = incisor_painr;
	self.nextthink = time;
};

void() incisor_diea1 = [ $inc_deatha1, incisor_diea2 ]{self.glowmod = '0.9 0.9 0.9';
    self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
};
void() incisor_diea2 = [ $inc_deatha2, incisor_diea3 ]{self.glowmod = '0.8 0.8 0.8';};
void() incisor_diea3 = [ $inc_deatha3, incisor_diea4 ]{self.glowmod = '0.7 0.7 0.7';};
void() incisor_diea4 = [ $inc_deatha4, incisor_diea5 ]{self.glowmod = '0.6 0.6 0.6';};
void() incisor_diea5 = [ $inc_deatha5, incisor_diea6 ]{self.glowmod = '0.5 0.5 0.5';};
void() incisor_diea6 = [ $inc_deatha6, incisor_diea7 ]{self.glowmod = '0.4 0.4 0.4';};
void() incisor_diea7 = [ $inc_deatha7, incisor_diea8 ]{self.glowmod = '0.3 0.3 0.3';};
void() incisor_diea8 = [ $inc_deatha8, incisor_diea9 ]{self.glowmod = '0.2 0.2 0.2';};
void() incisor_diea9 = [ $inc_deatha9, incisor_diea10 ]{self.glowmod = '0.1 0.1 0.1';};
void() incisor_diea10 = [ $inc_deatha10, incisor_diea11 ]{self.glowmod = '-1 -1 -1';
    self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;

	self.velocity = '0 0 0';

};
void() incisor_diea11 = [ $inc_deatha11, incisor_diea11 ]{checkburnable(self);};


void() incisor_dieb1 = [ $inc_deathb1, incisor_dieb2 ]{self.glowmod = '0.9 0.9 0.9';
    self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';

}
void() incisor_dieb2 = [ $inc_deathb2, incisor_dieb3 ]{self.glowmod = '0.8 0.8 0.8';};
void() incisor_dieb3 = [ $inc_deathb3, incisor_dieb4 ]{self.glowmod = '0.7 0.7 0.7';};
void() incisor_dieb4 = [ $inc_deathb4, incisor_dieb5 ]{self.glowmod = '0.6 0.6 0.6';};
void() incisor_dieb5 = [ $inc_deathb5, incisor_dieb6 ]{self.glowmod = '0.5 0.5 0.5';};
void() incisor_dieb6 = [ $inc_deathb6, incisor_dieb7 ]{self.glowmod = '0.4 0.4 0.4';};
void() incisor_dieb7 = [ $inc_deathb7, incisor_dieb8 ]{self.glowmod = '0.3 0.3 0.3';};
void() incisor_dieb8 = [ $inc_deathb8, incisor_dieb9 ]{self.glowmod = '0.2 0.2 0.2';};
void() incisor_dieb9 = [ $inc_deathb9, incisor_dieb10 ]{self.glowmod = '0.1 0.1 0.1';};
void() incisor_dieb10 = [ $inc_deathb10, incisor_dieb11 ]{self.glowmod = '-1 -1 -1';};
void() incisor_dieb11 = [ $inc_deathb11, incisor_dieb12 ]{};
void() incisor_dieb12 = [ $inc_deathb12, incisor_dieb13 ]{};
void() incisor_dieb13 = [ $inc_deathb13, incisor_dieb14 ]{};
void() incisor_dieb14 = [ $inc_deathb14, incisor_dieb15 ]{};
void() incisor_dieb15 = [ $inc_deathb15, incisor_dieb16 ]{};
void() incisor_dieb16 = [ $inc_deathb16, incisor_dieb17 ]{

    self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	self.velocity = '0 0 0';
};
void() incisor_dieb17 = [ $inc_deathb17, incisor_dieb17 ]{checkburnable(self);};

void() incisor_die =
{
	local vector tagorg;
	local float tagindex;
	local string tagname;
	local float r;
	//self.colormod = '1 1 1';
	self.effects = 0;	
	loop_incisor_soundoff();
	//msound(self, MOVETYPE_WALK, "enemies/prowler/run.ogg", 0, 0);
	//drop_item((self.origin - '0 0 12'), "ammo_spitter", MOVETYPE_BOUNCE, self);
	self.solid = FALSE;
	if (((self.health < widod) || self.gibbable))
	{
		tagname = "tag_arm_r_a";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('-10 100 130', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_arm_r_a.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('-10 100 130', self), 0,1);
		tagname = "tag_arm_r_b";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('10 100 120', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_arm_r_b.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('10 100 120', self), 0,1);
		tagname = "tag_arm_l_a";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('10 -120 100', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_arm_l_a.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('10 -120 100', self), 0,1);
		tagname = "tag_arm_l_b";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('-10 -60 90', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_arm_l_b.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('-10 -60 90', self), 0,1);
		tagname = "tag_head";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('100 0 60', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_head.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('100 0 60', self), 0,1);
		tagname = "tag_leg_r_a";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('10 120 120', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_leg_r_a.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('10 120 120', self), 0,1);
		tagname = "tag_leg_r_b";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('-10 60 110', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_leg_r_b.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('-10 60 110', self), 0,1);
		tagname = "tag_leg_l_a";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('-10 -120 110', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_leg_l_a.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('-10 -120 110', self), FALSE,1);
		tagname = "tag_leg_l_b";
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		relvel('20 -60 90', self);
		ThrowGib2("models/enemies/prowler/gibs/gib_leg_l_b.md3", (self.health * 0.25), 0.75, TRUE, TRUE, tagorg, relvel('20 -60 90', self), 0,1);
		chattersound("impact/gibs/gib_explo", 3, 1);
		explo_blood(1, (self.origin + VEC_ORIGIN));
        setmodel(self,"");
		self.solid = 0;
		self.velocity = VEC_ORIGIN;
		self.takedamage = 0;
		self.flags = 0;
		self.movetype = 0;
		self.effects = FL_INWATER;
		self.th_stand = null;
		self.th_walk = null;
		self.th_run = null;
		self.th_missile = null;
		self.th_melee = null;
		self.th_pain = nullpain;
		self.th_die = null;
		self.think = SUB_Remove;
		self.nextthink = (time + 1.5);
		return;
	}
	self.solid = FALSE;
    self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.takedamage = FALSE;
	self.flags = FALSE;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	self.th_die = null;
	r = random();
	chattersound("enemies/prowler/die", 3, 1);
	if ((r < 0.3))
	{
		self.think = incisor_dieb1;
	}
	else
	{
		self.think = incisor_diea1;
	}
	self.glowmod = '1 1 1';
	self.nextthink = (time + 0.1);
};

void() clipgroup_controller_think =
{
	if ((self.owner.health <= 0))
	{
		remove(self);
	}
	if ((self.owner.alpha == CONTENT_EMPTY))
	{
		self.owner.clipgroup = FL_INWATER;
	}
	else
	{
		self.owner.clipgroup = 0;
	}
	self.think = clipgroup_controller_think;
	self.nextthink = time + 0.05;
};

void() precache_monster_prowler =
{
	precache_sound("enemies/prowler/attack1.ogg");
	precache_sound("enemies/prowler/attack2.ogg");
	precache_sound("enemies/prowler/attack3.ogg");
	precache_sound("enemies/prowler/die1.ogg");
	precache_sound("enemies/prowler/die2.ogg");
	precache_sound("enemies/prowler/die3.ogg");
	precache_sound("enemies/prowler/hit1.ogg");
	precache_sound("enemies/prowler/hit2.ogg");
	precache_sound("enemies/prowler/hit3.ogg");
	precache_sound("enemies/prowler/attack1.ogg");
	precache_sound("enemies/prowler/attack2.ogg");
	precache_sound("enemies/prowler/attack3.ogg");
	precache_sound("enemies/prowler/attack4.ogg");
	precache_sound("enemies/prowler/attack5.ogg");

	precache_sound("enemies/prowler/cloak.ogg");
	precache_sound("enemies/prowler/decloak.ogg");

	precache_sound("enemies/prowler/idle1.ogg");
	precache_sound("enemies/prowler/idle2.ogg");
	precache_sound("enemies/prowler/idle3.ogg");
	precache_sound("enemies/prowler/idle4.ogg");
	precache_sound("enemies/prowler/idle5.ogg");
	precache_sound("enemies/prowler/chatter1.ogg");
	precache_sound("enemies/prowler/chatter2.ogg");
	precache_sound("enemies/prowler/chatter3.ogg");
	precache_sound("enemies/prowler/chatter4.ogg");
	precache_sound("enemies/prowler/chatter5.ogg");
	precache_sound("enemies/prowler/miss1.ogg");
	precache_sound("enemies/prowler/miss2.ogg");
	precache_sound("enemies/prowler/miss3.ogg");
	precache_sound("enemies/prowler/pain1.ogg");
	precache_sound("enemies/prowler/pain2.ogg");
	precache_sound("enemies/prowler/pain3.ogg");
	precache_sound("enemies/prowler/run.ogg");
	precache_sound("enemies/prowler/sight1.ogg");
	precache_sound("enemies/prowler/sight2.ogg");
	precache_sound("enemies/prowler/sight3.ogg");
	precache_sound("enemies/prowler/step1.ogg");
	precache_sound("enemies/prowler/step2.ogg");
	precache_sound("enemies/prowler/step3.ogg");
	precache_model("models/enemies/prowler/prowler.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/prowler/gibs/gib_head.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_l_b.md3");
};
void()xangle_controller_think;
void() monster_prowler =
{
	local entity alphamodifier;
	local float r;
	local entity clipgroup_controller;

	precache_sound("enemies/prowler/attack1.ogg");
	precache_sound("enemies/prowler/attack2.ogg");
	precache_sound("enemies/prowler/attack3.ogg");
	precache_sound("enemies/prowler/die1.ogg");
	precache_sound("enemies/prowler/die2.ogg");
	precache_sound("enemies/prowler/die3.ogg");
	precache_sound("enemies/prowler/hit1.ogg");
	precache_sound("enemies/prowler/hit2.ogg");
	precache_sound("enemies/prowler/hit3.ogg");
	precache_sound("enemies/prowler/attack1.ogg");
	precache_sound("enemies/prowler/attack2.ogg");
	precache_sound("enemies/prowler/attack3.ogg");
	precache_sound("enemies/prowler/attack4.ogg");
	precache_sound("enemies/prowler/attack5.ogg");

	precache_sound("enemies/prowler/cloak.ogg");
	precache_sound("enemies/prowler/decloak.ogg");

	precache_sound("enemies/prowler/idle1.ogg");
	precache_sound("enemies/prowler/idle2.ogg");
	precache_sound("enemies/prowler/idle3.ogg");
	precache_sound("enemies/prowler/idle4.ogg");
	precache_sound("enemies/prowler/idle5.ogg");
	precache_sound("enemies/prowler/chatter1.ogg");
	precache_sound("enemies/prowler/chatter2.ogg");
	precache_sound("enemies/prowler/chatter3.ogg");
	precache_sound("enemies/prowler/chatter4.ogg");
	precache_sound("enemies/prowler/chatter5.ogg");
	precache_sound("enemies/prowler/miss1.ogg");
	precache_sound("enemies/prowler/miss2.ogg");
	precache_sound("enemies/prowler/miss3.ogg");
	precache_sound("enemies/prowler/pain1.ogg");
	precache_sound("enemies/prowler/pain2.ogg");
	precache_sound("enemies/prowler/pain3.ogg");
	precache_sound("enemies/prowler/run.ogg");
	precache_sound("enemies/prowler/sight1.ogg");
	precache_sound("enemies/prowler/sight2.ogg");
	precache_sound("enemies/prowler/sight3.ogg");
	precache_sound("enemies/prowler/step1.ogg");
	precache_sound("enemies/prowler/step2.ogg");
	precache_sound("enemies/prowler/step3.ogg");
	precache_model("models/enemies/prowler/prowler.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/prowler/gibs/gib_head.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/prowler/gibs/gib_leg_l_b.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.onlymelee = TRUE;
	alphamodifier = spawn();
	alphamodifier.owner = self;
	alphamodifier.think = alpha_modifier;
	alphamodifier.nextthink = time;
	self.solid = 3;
	self.damagetopain = 25;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/prowler/prowler.md3");
	self.bbvv = incisorbbox;
	setsize(self, '-30 -30 -24', '30 30 24');
	self.exec_push = FL_CLIENT;
	r = random() * 3;
	if (r < 3)
		self.noise = "enemies/prowler/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/prowler/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/prowler/sight1.ogg";
	self.health = incisorhealth;
	self.touch = incisor_touch;
	self.scale = 1;
	self.alpha = 1;
	self.classname = "monster_incisor";
	self.oldclassname = "monster_incisor";
	self.max_health = incisorhealth;
	self.view_ofs_z = STAT_RD_ST;
	self.stepheight_delta = FL_CLIENT;


	self.th_stand = incisor_stand1;
	self.th_walk = incisor_walk1;
	self.th_run = incisor_run1;
	self.th_melee = incisor_atk;
	self.th_pain = incisor_pain;
	self.th_die = incisor_die;
	clipgroup_controller = spawn();
	clipgroup_controller.owner = self;
	clipgroup_controller.think = clipgroup_controller_think;
	clipgroup_controller.nextthink = time;
	if(single_player.displacement_time > time)
	{
		self.color = '0.225 0.237 1.3';
		self.light_lev = 92;
		self.pflags = 129;
		self.colormod = '4 1 4';
		self.effects = 512;
	}
	walkmonster_start();

};
.float walktime2;
.float xangle_controller_cnt;
void()xangle_controller_think =
{

	if(self.owner.walktime2 > time)
	{
		setorigin (self, self.owner.origin);
		makevectors2(self.owner.angles);
		vector source = self.owner.origin;
		traceline(source, source + v_forward *64, TRUE, self);
		if (trace_fraction != 1.0)
		{
			self.angles = vectoangles (normalize(trace_endpos + ' 0 0 12' - trace_endpos));
			self.owner.angles_x = self.angles_x;
			self.owner.wallwalktime = time + 0.25;
		}
		else
		{
			traceline(source, source + v_forward *32 + v_up * -64, TRUE, self);
			vector pos1 = trace_endpos;	
				float forwardarstep = trace_fraction;	
			if (trace_fraction != 1.0)
			{
				self.angles = vectoangles (normalize(trace_endpos + ' 0 0 12' - trace_endpos));
				self.owner.angles_x = self.angles_x;
				self.owner.wallwalktime = time + 0.25;
			}
			else
			{
				self.owner.angles_x = 0;
				self.owner.wallwalktime = time + 0.25;
			}


		}	

	}

	else
	{
		if(self.owner.angles_x != 0)
			self.owner.angles_x = 0;
		if(self.owner.gravity != 1)
			self.owner.gravity = 1;
	}


	self.think = xangle_controller_think;
	self.nextthink = time + 0.05;
};


void()monster_incisor =
{
	monster_prowler();
};


void()trigger_wallwalktouch =
{
	if(other.classname != "monster_incisor")
		return;
	other.walktime2 = time + 0.25;
	

	if(other.xangle_controller_cnt != 1)
	{
		entity xangle_controller = spawn();
		setmodel(xangle_controller,"");
		xangle_controller.owner = other;
		xangle_controller.think = xangle_controller_think;
		xangle_controller.nextthink = time; 
		other.xangle_controller_cnt = 1;
	}
};

void()trigger_wallwalk =
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = string_null;
	self.touch = trigger_wallwalktouch;

};
