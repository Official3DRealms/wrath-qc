void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float(entity targ, entity inflictor) CanDamage;
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;
.float warped;
.float isexplosion;
.float gibbable;
.float tdsouls;
.float tdsouls_time;
.float turret;
.float oldturret;
.float warpedtime;
void() stricken_preattack1;
void()stricken_run1;
void() delete_shrine;
void() PlayerDeathThink;
.float playerdeadtime;
.float deadwaiting;
.float alreadykilled;
.entity attached_cloud;
.float forcepain;
void(string sound, float r) playersound;
void(float mtype, vector org, entity ownr) Hud_message;
void() next_enemy;
#if 0
void()guardian2_painb;
#endif
void(entity a,float b)keeper_pain;
void()keeper_fast;
void()keeper_generate;
#if 0
void() boss3_mutilationa;
void() boss3_mutilationb;
void() boss3_mutilationc;
#endif
void() FoundTarget;
.float exec_push;
.float paintake;
.float randomattacked;
.float randomattack;
.float dmgscreenf;
.float dmgscreenb;
.float dmgscreenr;
.float dmgscreenl;
.float dmgbscreenf;
.float dmgbscreenb;
.float dmgbscreenr;
.float dmgbscreenl;
.float flyer;
.float oldturret;
.float onlymelee;
.float  sustained_damage;
.float jason;
void()oppressor_painb;
void()brute_painb1;
void()brute_painc1;
.float backedtonormal;
.float oldmovetype;
.float timepushing;
.entity backtonormal_phys;
void()oppressor_painb;
void() backtonormal;
void() jason_mode = 
{
	self.jason = cvar ("jason_mode");        
}; 
float(entity targ, entity inflictor) CanDamage = 
{	
	// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 *(targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

void() siphon_effect_think = 
{ 
	self.frame++;
	self.alpha -= 0.2;
	if (self.alpha == 0)
		self.alpha = -1;
	if (self.frame <= 9)
		self.think = siphon_effect_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void(vector org, entity e) life_siphon_effect = 
{ 
	float r = random();

	entity siphon_effect = spawn();
	siphon_effect.alpha = 2;
	siphon_effect.origin = org;
	setmodel(siphon_effect, "models/artifacts/effects/life_siphon_humanoid.md3");
	if (r > 0.5)
		siphon_effect.skin = 1;
	if (e.classname == "monster_invader")
		siphon_effect.skin = 2;
	if (e.classname == "monster_wretch")
	{
		siphon_effect.scale = 1.5;
		siphon_effect.skin = 3;
	}
	if (e.classname == "monster_widow")
		siphon_effect.skin = 4;

	if (e.classname == "monster_lurker")
	{
		siphon_effect.skin = 0;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_lurker.md3");
	}
	if (e.classname == "monster_heretic")
	{
		siphon_effect.skin = 0;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");
	}
	if (e.classname == "monster_wraith")
	{
		siphon_effect.skin = 0;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_wraith.md3");
	}
	if (e.classname == "executioner")
	{
		siphon_effect.skin = 1;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");
	}
	if (e.classname == "monster_stricken")
	{
		siphon_effect.skin = 0;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_stricken.md3");
	}
	if (e.classname == "monster_oppressor")
	{
		siphon_effect.skin = 2;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");
	}
	if (e.classname == "monster_symbol")
	{
		siphon_effect.scale = 2;
		siphon_effect.skin = 3;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");
	}
	if (e.classname == "monster_brute")
	{
		siphon_effect.scale = 2;
		siphon_effect.skin = 4;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");

	}
	if (e.classname == "monster_incisor")
	{
		siphon_effect.scale = 1.5;
		siphon_effect.skin = 5;
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");

	}
	if(e.classname== "object_fakecoffer")
	{
		siphon_effect.alpha = 4.5;
		self.scale = random(1.2,1.5);	
	}
	siphon_effect.think = siphon_effect_think;
	siphon_effect.nextthink = time;
};
void()null;

void(entity attacker, entity attacked)life_siphon_gain = 
{
	attacker.healthpulsetime = time + 0.25;
	if (floor(attacker.health) <= 999)
	{
		stuffcmd (attacker,"pulsehealth\n");
	}

	if (floor(attacker.health) <= 999)
		soundwrath(attacker, CHAN_AUTO, "player/gain_health.ogg", 1, 1, 100, 0,0.5);
	float health_gain = 5;
	if (attacked.classname == "monster_fallen")
		health_gain = 5;
	if (attacked.classname == "monster_wraith")
		health_gain = 5;
	if (attacked.classname == "monster_afflicted")
		health_gain = 10;
	if (attacked.classname == "monster_widow")
		health_gain = 10;
	if (attacked.classname == "monster_invader")
		health_gain = 10;
	if (attacked.classname == "monster_heretic")
		health_gain = 20;
	if (attacked.classname == "executioner")
		health_gain = 30;
	if (attacked.classname == "monster_stricken")
		health_gain = 30;
	if (attacked.classname == "monster_wretch")
		health_gain = 15;
	if (attacked.classname == "monster_keeper")
		health_gain = 20;
	if (attacked.classname == "monster_oppressor")
		health_gain = 20;
	if (attacked.classname == "monster_lurker")
		health_gain = 10;
	if (attacked.classname == "monster_incisor")
		health_gain = 25;
	if (attacked.classname == "monster_symbol")
		health_gain = 30;
	if (attacked.classname == "monster_brute")
		health_gain = 40;
	attacker.health += health_gain; 
	stuffcmd (attacker, "bf 1 0.3 0.3 0.125 1\n");
	if(attacker.health > 999)
	attacker.health = 999;			
	life_siphon_effect(attacked.origin, attacked);
	attacked.th_stand = null;
	attacked.th_walk = null;
	attacked.th_run = null;
	attacked.th_missile = null;
	attacked.th_melee = null;
	attacked.th_pain = nullpain; // th_pain has two arguments 
	attacked.flags = 0;

	// Reki (July 17 2023): achievement logic
	Steam_StatIncrement(self, ST_STATS::siphon_health, health_gain);
};


.entity buffer;
.float killedbyblade;
.float wrath_inv;
.float voided;
.entity killer;
void();
void()bersek_push;
void(entity e) pop_entitycleanup;
void(entity targ, entity attacker, float gibable) Killed = 
{ 
	float health_gain;
	
	//targ.colormod = '1 0 0'; // crystallised test

	if ((targ.flags &FL_MONSTER) && (targ.alreadykilled >= 1))
		return;
	if ((self.classentity == "corpse") &&((self.flags &FL_MONSTER))&& (!self.wrathflags & FL_CRYSTAL) )
		return;
	if(self.buffer !=  world)
		self.buffer.goalentity = world;	
	

	// Reki (July 12 2023): population control
	pop_entitycleanup(targ);
	//


	if((targ.flags & FL_MONSTER) && (attacker.classname == "trigger_hurt"))
	{
		entity affectedmonsters;
		affectedmonsters = findradius(targ.origin, targ.maxs_z * 5);
		while (affectedmonsters)
		{
			if((affectedmonsters.flags & FL_MONSTER) &&(affectedmonsters.origin_z >= targ.origin_z )&& (affectedmonsters != targ) )
			{
				if (!affectedmonsters.oldmovetype)
					affectedmonsters.oldmovetype = affectedmonsters.movetype;
				affectedmonsters.movetype = MOVETYPE_BOUNCE;
				affectedmonsters.timepushing = affectedmonsters.nextthink + 1;
				affectedmonsters.gravity = 0.15;
				if (affectedmonsters.flags &FL_ONGROUND)
					affectedmonsters.flags -= FL_ONGROUND;
				affectedmonsters.backedtonormal = 0; 
				affectedmonsters.oldthink = affectedmonsters.think;
				affectedmonsters.think = backtonormal;
				affectedmonsters.nextthink = time + 0.1;
				affectedmonsters.velocity += randomvector ('-32 -32 32', '32 32 64');
			}
					affectedmonsters = affectedmonsters.chain;
		}
	}


	if((attacker.flags &FL_MONSTER) && (attacker.enemy ==  targ))
	{
		attacker.enemy = world;
		entity oself = self;
		self = attacker;
		next_enemy();
		self = oself;	
	}	
	if (targ.classname == "monster_fallen")
		targ.journal_jmessagesm = JB_A;
	if (targ.classname == "monster_wraith")
		targ.journal_jmessagesm = JB_B;
	if (targ.classname == "monster_afflicted")
		targ.journal_jmessagesm = JB_C;
	if (targ.classname == "monster_widow")
		targ.journal_jmessagesm = JB_D;
	if (targ.classname == "monster_invader")
		targ.journal_jmessagesm = JB_E;
	if (targ.classname == "monster_heretic")
		targ.journal_jmessagesm = JB_F;
	if (targ.classname == "executioner")
		targ.journal_jmessagesm = JB_G;
	if (targ.classname == "monster_stricken")
		targ.journal_jmessagesm = JB_H;
	if (targ.classname == "monster_wretch")
		targ.journal_jmessagesm = JB_I;
	if (targ.classname == "monster_oppressor")
		targ.journal_jmessagesm = JB_J;
	if (targ.classname == "monster_lurker")
		targ.journal_jmessagesm = JB_K;
	if (targ.classname == "monster_symbol")
		targ.journal_jmessagesm = JB_L;
	if (targ.classname == "monster_brute")
		targ.journal_jmessagesm = JB_M;
	if (targ.classname == "monster_incisor")
		targ.journal_jmessagesm = JB_N;
	if (targ.classname == "monster_keeper")
		targ.journal_jmessagesm = JB_O;
	entity pl = find(world, classname, "player");
	if (!(pl.journal_jmessagesm &targ.journal_jmessagesm) && (targ.flags &FL_MONSTER))
	{
		pl.journal_jmessagesm += targ.journal_jmessagesm;
		//Hud_message(35, pl.origin, pl);
		Hud_JournalNotification(pl);
	}
		/*
	1 = fallen
	2 = wraith
	3 = afflicted
	4 = widow
	5 = invader
	6 = heretic
	7 = executioner
	8 = stricken
	9 = opressor
	10 = lurker

	float	JB_A					= 1;
	float	JB_B					= 2;
	float	JB_C					= 4;
	float	JB_D					= 8;
	float	JB_E					= 16;
	float	JB_F					= 32;
	float	JB_G					= 64;
	float	JB_H					= 128;
	float	JB_J					= 256;
	float	JB_k					= 512;
	*/
	oself = self;
	self = targ;
	self.classentity = "corpse";
	if (!(self.flags &FL_MONSTER))
	self.takedamage = DAMAGE_NO;
	//	if (self.health < -99)
	//		self.health = -99;		// don't let sbar look bad if a player
	self.attack_finished = time + 5;
	self.LifeSiphon_time = 0;
	self.solid = SOLID_CORPSE;
	if (self.health >= 0)
		self.health = -1;
	if ((self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE) && (!(self.flags &FL_MONSTER)))
	{
		self.enemy = attacker;
		self.th_die();
		self = oself;
		return;
	}


	if (self.classname == "player")
	{


		self.playerdeadtime = time + 100000000;
		delete_shrine();
		if (self.health >= 0)
			self.health = -100;
		self.use = SUB_Null;
		self.solid = SOLID_CORPSE;
		self.takedamage = 0;
		self.think = PlayerDeathThink;
		self.nextthink = time;
		self.deadflag = DEAD_DEAD;
		self.deadwaiting = time + 0.2;
		self.r_healthhaze = 0.4;

		remove(self.vweapon);
		if (self.waterlevel >= 3)
			playersound("player/die_underwater", 2);
		else
			playersound("player/die", 5);
		return;
	}

	if(self.wrathflags & FL_CRYSTAL)
	{
		float exmonster = 1;
		if(self.health > 0)
		self.health = -1;
		if(self.health < -1000)
		self.health = -1000;
	}


	if (self.flags &FL_MONSTER)
	{

		if(self.voided != 1)
		{
			if (attacker.isexplosion) 
				decal_monster_pain(rorigin(targ), attacker.angles);
			else
				decal_monster_pain(rorigin(targ), targ.enemy.angles);
		}

		if (self.attached_cloud) 
			remove(self.attached_cloud); 
		if(self.alreadykilled != 1)
		{
			self.alreadykilled = 1; // prevent double kill counter
			local float dev = cvar ("developer");
			if(dev == 1)
			{
				float writeparms = fopen (strcat ("reportmonsters/",mapname, "_killed_monsters",".txt"), FILE_APPEND);    //open what file to use in write mode
				string string1 = strcat (ftos(num_for_edict(self)),",  ",self.classname,", origin:");
				string string2	= strcat(vtos(self.origin),", killer: ",attacker.classname,", ");
				string shour = strcat("time ",strftime(TRUE, "%H:%M:%S"),"\n");
			
				string string3 = strcat (string1,string2,shour);
				fputs (writeparms,(string3));
				fclose (writeparms);
			}
			killed_monsters ++;
			WriteByte(MSG_ALL, SVC_KILLEDMONSTER);

			// Reki (May 9 2023): Achievement logic
			if (attacker.flags & FL_CLIENT)
			{
				Steam_StatIncrement(attacker, ST_STATS::monsters_killed, 1);

				// blade kills
				if (time < attacker.lungetime && attacker.weapon == IT_MELEE)
				{
					Steam_StatIncrement(attacker, ST_STATS::blade_lunge_kills, 1);
				}

				// 1hp kill
				if (attacker.health == 1)
				{
					if (time > attacker.Aegis_time + 5)
					{
						Steam_AchievementUnlock(attacker, ST_ACHIEVEMENTS::SP_FEAT_1HP);
					}
				}
			}
			else if (attacker.flags & FL_MONSTER)
			{
				if (attacker.friendly_monster == 1)
				{
					Steam_StatIncrement(world, ST_STATS::confounding_kills, 1);
				}
			}

			if (attacker.friendly_monster == 2) // vicious animus
			{
				if (targ.flags & FL_MONSTER)
				{
					Steam_StatIncrement(world, ST_STATS::animus_kills, 1);
				}
			}
			//
		}



		if((self.fakewatertype == CONTENT_LAVA) || (self.fakewatertype == CONTENT_SLIME))
			self.solid = SOLID_TRIGGER;
		else
			self.solid = SOLID_NOT;

		self.th_stand = null;
		self.th_walk = null;
		self.th_run = null;
		self.th_missile = null;
		self.th_melee = null;
		self.th_pain = nullpain;

		if (gibable == 1)
			self.gibbable = 1;
		if (attacker.LifeSiphon_time > time)
		{
			life_siphon_gain(attacker,self);

			/*attacker.healthpulsetime = time + 0.25;
			if (floor(attacker.health) <= 999)
			{
				stuffcmd (attacker,"pulsehealth");
			}

			if (floor(attacker.health) <= 999)
				sound7(attacker, CHAN_AUTO, "player/gain_health.ogg", 1, ATTN_NORM, 100, 0);
				health_gain = 5;
			if (self.classname == "monster_fallen")
				health_gain = 5;
			if (self.classname == "monster_wraith")
				health_gain = 5;
			if (self.classname == "monster_afflicted")
				health_gain = 10;
			if (self.classname == "monster_widow")
				health_gain = 10;
			if (self.classname == "monster_invader")
				health_gain = 10;
			if (self.classname == "monster_heretic")
				health_gain = 20;
			if (self.classname == "executioner")
				health_gain = 30;
			if (self.classname == "monster_stricken")
				health_gain = 30;
			if (self.classname == "monster_wretch")
				health_gain = 15;
			if (self.classname == "monster_keeper")
				health_gain = 20;
			if (self.classname == "monster_oppressor")
				health_gain = 20;
			if (self.classname == "monster_lurker")
				health_gain = 10;
			if (self.classname == "monster_symbol")
				health_gain = 30;
			if (self.classname == "monster_brute")
				health_gain = 40;
			attacker.health += health_gain; 
			if(attacker.health > 999)
			attacker.health = 999;			
			life_siphon_effect(self.origin, self);
			self.th_stand = null;
			self.th_walk = null;
			self.th_run = null;
			self.th_missile = null;
			self.th_melee = null;
			self.th_pain = nullpain; // th_pain has two arguments 
			self.flags = 0;
			*/
		}
		if((attacker.wrath_active) &&((attacker.wrath_time > time)) )
		{
			te_customflash (attacker.origin,64,1,'0.7 0.2 0.2');
			stuffcmd (attacker, "bf 1 0.3 0.3 0.125 1\n");
			float bparticle = particleeffectnum("wrath_particle");
			vector partvel;
			partvel_z = attacker.wrath_kills * 4;
			if(partvel_z > 128)
				partvel_z =  128;
			float partammount = attacker.wrath_kills * 0.25;
			if (partammount > 8)			
				partammount = 8;

			
			stuffcmd (attacker, strcat(("r_glsl_postprocess_uservec3 "),("\""),ftos(0.0025 * attacker.wrath_kills+ 0.01),(" 3.5 1.25 0\"\n")));

			pointparticles(bparticle, self.origin, partvel, 1 + partammount);
			if (attacker.wrath_kills <= 64)
			attacker.wrath_kills += 1;
			attacker.wrath_inv = time + 1;
			self.killer = attacker;
			entity pusher = spawn();			
			pusher.origin = self.origin;
			pusher.think = bersek_push;
			pusher.owner = attacker;
			pusher.nextthink = time + 0.1;
			if(self.classname == "monster_wretch")
				self.health = -499;
			else
				self.health = -99999;
		}


		if((attacker.flaskrage_active >= 1) &&(attacker.flaskrage_time > time))
		{
			//te_customflash (self.origin,32,1,FLASKRAGECOLOR);

			/*string bfcommand = strcat("bf ",ftos(FLASKRAGECOLOR_x)," ",ftos(FLASKRAGECOLOR_y)," ",ftos(FLASKRAGECOLOR_z)," "," 0.20 1.5\n");
			stuffcmd (attacker, bfcommand);*/
			stuffcmd (attacker,"\n");
			bparticle = particleeffectnum("flaskrage_particle");
			pointparticles(bparticle, self.origin, '0 0 0', 1);
			pusher = spawn();			
			pusher.origin = self.origin;
			pusher.think = bersek_push;
			pusher.owner = attacker;
			pusher.nextthink = time + 0.1;
			if(self.classname == "monster_wretch")
				self.health = -499;
			else
				self.health = -99999;
		}
		exmonster = 1;
	}



	if (self.watertype == CONTENT_LAVA)	// do lava damage
	{
		self.effects = 0;
		self.health = -9999;
	}

	if((exmonster == 1) &&(!(self.wrathflags & FL_CRYSTAL)))
		monster_death_use();
	self.think = self.th_die;
	self.nextthink = time;
	self.touch = SUB_Null;
	self = oself;
};
.float forced_idle_time;
.float evading;
.entity temp_buffer;
.float shieldtime;
.float shieldspawned_time;
.float darkarmor_effect_time;
void()lance_muzzle_think;
.float chasing;
.float fshockwave_time; .float boss3_model;
void(entity targ, entity damage) direct_damage =
{
	if (!targ.takedamage)
		return;
	if (!(targ.health))
		return;

};
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = 
{	 
	vector dir;
	entity oldself;
	float save;
	float take;
	float floatdmg;
	float waterdamagearmor;
	float rest_damage;
	float jdir;
	vector vec;
	float dot, dotb, doup, dmgup, dmgside;
	vector vec2, inflictorangles;
	float targoldhealth = targ.health;

	//if((targ.wrath_active == 2) && (inflictor.classname != "player"))
	//	return;

	//if((targ.wrath_active >= 1) && (inflictor.classname != "player"))
	//	return;

	if(attacker.forced_idle_time > time)
	{
		//attacker.enemy =  world;
		//	return;
		damage = damage * 0.25;
	}
	if(targ.fshockwave_time > time)
		return;

	/*
	if((targ.classname == "boss_guardian3")&&(targ.boss3_model <= 2))
	{
		if((targ.shieldtime < time) )
		{
			targ.skin = 1;
			targ.shieldtime = time + 0.75;
			targ.shieldspawned_time = 1;	
		}
		return;
	}
	*/
	if ((!targ.takedamage) && (targ.health > 0) && (targ.classname == "player"))
	{
		float bparticle = particleeffectnum("flask_particle2");
		pointparticles(bparticle, targ.origin, '0 0 0', 1);
		return;
	}
	if (!targ.takedamage)
		return;

    if(targ.wrath_inv > time)
       return;
	if (!(targ.health))
		return;

	if (((inflictor.classname == "player") || (attacker.classname == "player")) && (targ.classname != "player") && (attacker.flaskrage_time > time )) 
	{
		float flaskdamage = cvar ("flaskrage_damage");
		damage = damage * flaskdamage;
	}

	// Reki (May 2 2023): Apply flat 3x damage multiplier for sigil of wrath
	if (time < attacker.wrath_time)
		damage *= 3;

	if (targ.classname == "player")
	{

		if (targ.wrath_active >= 1)
		damage = damage *0.333;

		if (skill == 0)
		floatdmg = damage *0.25;
		if (skill == 1)
		floatdmg = damage *0.5;
		if (skill == 2)
		floatdmg = damage *0.75;
		if (skill == 3)
		floatdmg = damage *1;

		if((floatdmg > 0) && (floatdmg <1)) 
		floatdmg = 1;
		damage = floatdmg;
	}
	if(attacker.friendly_monster != 2)
		damage = floor(damage);

	if ((damage <= 0) && (attacker.friendly_monster != 2))
		return; // used by buttons and triggers to set activator for target firing

	if((attacker.friendly_monster == 1) && (targ.classname != "player"))
		damage = floor(damage) * 3;


	damage_attacker = attacker;
	// check for quad damage powerup on the attacker
	if ((targ.only_damage_monster == 1) && (attacker.classname == "player"))
		return;
	if (attacker.super_damage_finished > time)
		damage = damage * 4;
	// save damage based on the target's armor level
	if (attacker.classname == "badwater")
		waterdamagearmor = 1;
	else
	waterdamagearmor = 0;
	if ((waterdamagearmor == 0) && (targ.Aegis_time < time))
	{
		if (targ.darmorvalue > 0)
		{

			float olddarmorvalue = targ.darmorvalue;

			if (targ.darmorvalue > (damage))
			{
				targ.darmorvalue -= (damage);
				damage = 0;
				save = 0;
			}
			else
			{
				rest_damage = (targ.darmorvalue - (damage)) *-1;
				targ.darmorvalue = 0;
				damage = rest_damage;
				save = rest_damage;
			}
			
			if(olddarmorvalue > targ.darmorvalue)
			{
				stuffcmd (targ,"pulsedarmor \n");
				if(targ.darkarmor_effect_time < time)
				{
					sound7 (targ, CHAN_AUTO, "items/armor_dark_impact.ogg", 0.3, 1,random(120,150),0);
					bparticle = particleeffectnum("darkarmorfragment");
					stuffcmd (targ, "bf 0.5 0.5 1.5 0.25 1\n");
					pointparticles(bparticle, targ.origin + targ.view_ofs, '0 0 0', 1);
					targ.darkarmor_effect_time = time + 0.35;
				}
			}

		}
		else
			save = damage;

		if ((targ.rarmorvalue > 0) && (save > 0))
		{
			if (targ.rarmorvalue > damage)
			{
				targ.rarmorvalue -= damage *0.5;
				damage = damage *0.5;
				save = damage;
			}
			else
			{
				rest_damage = (targ.rarmorvalue - damage) *-1;
				targ.rarmorvalue = 0;
				damage = damage *0.5;
				save = rest_damage + damage;
			}

			stuffcmd (targ,"pulsearmor\n");
		}
		else
			save = damage;
	}
	else
		save = damage;

	take = floor(save);
	if (targ.flags &FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;

		// Reki (December 3 2023): Track this for rumble
		targ.dmg_shake_taken += take;
		targ.dmg_shake_saved += save;
	}


	if ((inflictor != world) && (targ.movetype == MOVETYPE_WALK) && (targ.gravity == 1))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) *0.5;
		dir = normalize(dir);

		if (attacker.exec_push)
			jdir = attacker.exec_push;
		else
			jdir = 0;

		if (jdir > 0)
			targ.velocity = targ.velocity + dir *damage * jdir;
	}

	if ((targ.classname == "player") && ((attacker.flags &FL_MONSTER) || (attacker.classname == "aoe")) && (targ.darmorvalue <= 0))
	{
		makevectors2(targ.angles);
		vec = normalize(rorigin(attacker) - rorigin(targ));
		dot = vec * v_forward;
		dotb = vec * v_right;
		doup = vec * v_up;

		if (attacker.classname != "aoe")
		{
			if (doup >= 0.5)
			{
				targ.dmgscreenf = time + 2.5;
				if (targ.dmgscreenf > time)
				{
					targ.dmgbscreenf = time + 0.05;
					if (!(targ.damagescreen &2))
						targ.damagescreen += 2;
				}

				dmgup = 1;
			}

			if (dot < -0.5)
			{
				targ.dmgscreenb = time + 2.5;
				if (targ.dmgscreenb > time)
				{
					targ.dmgbscreenb = time + 0.05;
					if (!(targ.damagescreen &8))
						targ.damagescreen += 8;
				}
			}

			if (dmgup == 1)
			{
				if ((dot >= -0.4) && (dot < 0.6))
					dmgside = 1;
			}
			else
			{
				if ((dot >= -0.5) && (dot < 0.5))
					dmgside = 1;
			}

			if (dmgside == 1)
			{
				if (dotb < -0.5)
				{
					targ.dmgscreenl = time + 2.5;
					if (targ.dmgscreenl > time)
					{
						targ.dmgbscreenl = time + 0.05;
						if (!(targ.damagescreen &32))
							targ.damagescreen += 32;
					}
				}

				if (dotb > 0.5)
				{
					targ.dmgscreenr = time + 2.5;
					if (targ.dmgscreenr > time)
					{
						targ.dmgbscreenr = time + 0.05;
						if (!(targ.damagescreen &128))
							targ.damagescreen += 128;
					}
				}
			}
		}
		else
		{
			targ.dmgscreenb = time + 2.5;
			if (targ.dmgscreenb > time)
			{
				targ.dmgbscreenb = time + 0.05;
				if (!(targ.damagescreen &8))
					targ.damagescreen += 8;
			}
		}
	}

	vec2 = inflictor.origin - targ.origin;
	inflictorangles = vectoangles(vec);

	if ((!(targ.flags &FL_GODMODE)) && ((targ.Aegis_time < time)))
	{

		if ((teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team))
			return;

		if (attacker.flaskrage_time > time)
		{
			//bprint(ftos(attacker.flaskrage_damagedelt), "\n");
			attacker.flaskrage_damagedelt += take;//min(targ.health, take);
			if (attacker.flaskrage_damagedelt > 40000)
				Steam_AchievementUnlock(attacker, ST_ACHIEVEMENTS::SP_GRIND_FLASK);
		}
		targ.health = targ.health - take;


		if((targ.jason == 1))
		{		
			if (targ.health <= 0)
			targ.health = 1;
			return;
		}

		if (targ.health <= 0)
		{
			targ.enemy = attacker;

			if (attacker.flags & FL_CLIENT)
				targ.wrath_kills |= 1;
			
			if ((attacker.weapon == IT_REVOLVER) | (attacker.weapon == IT_SPITTER))
				Killed(targ, attacker, 0);
			else
				Killed(targ, attacker, 1);
			return;
		}

	}

	//react to the damage
	oldself = self;
	self = targ;


	if(self.classname == "func_nodestruct")
	self.cnt ++;

	if((self.classname == "monster_stricken") && (attacker.flags & FL_MONSTER)&& (attacker.friendly_monster >= 1))
	{
		if((!self.turret) && (!self.oldturret))
		{
			self.turret = 1;
			self.oldturret = 2;
			self.th_run = stricken_preattack1;
		}	
	}

	if ((self.flags &FL_MONSTER) && (attacker.friendly_monster == 2) &&(self.enemy != attacker))
	{
		self.enemy = attacker;
		FoundTarget();
	}
	if ((self.flags &FL_MONSTER) && (attacker != world) && (!self.warped)) 
	{
		//get mad unless of the same class (except for soldiers)
		if ((self != attacker) && (attacker != self.enemy) && (attacker.classname == "player"))
		{
			if ((self.onlymelee == 1) && (attacker.flyer == 1))	
				return;
			self.enemy = attacker;
			FoundTarget();
		}
	}


	if ((self.flags &FL_MONSTER) && (attacker.friendly_monster == 1)&&(attacker.flags &FL_MONSTER))
	{
		if ((self.onlymelee == 1) && (attacker.flyer == 1))	
			return;
		self.enemy = attacker;
		FoundTarget();
	}
	if ((self.flags &FL_MONSTER) && (self.think))
	{
	if(self.nextthink < time)
		self.nextthink = time;
	}

	if(take < 1 )
	{
		self = oldself;
		return;
	}

	if((self.forcepain > time) &&(self.health > 0)&& (self.th_pain) &&((self.pain_finished < time)))
	{
		self.th_pain(attacker, take);
		self.paintake = 10000;
		self.sustained_damage = 0;
		//self.pain_finished = time + random (1,2);
		self = oldself;
		return;
	}

	if((self.monster_long_pain == 1)&& (self.pain_finished < time)&& (!self.warped) &&(targoldhealth < self.max_health ))
	{
		
		if(self.classname == "monster_oppressor")
		{
			self.pain_finished = time + 2.2;
			self.think = oppressor_painb;
			self.nextthink = time + 0.05;
		}
		if(self.classname == "monster_brute")
		{
			if((targoldhealth< self.max_health * 0.75)&&(self.skin != 1))
			{
				self.think = brute_painc1;
			}
			else
			{
				self.think = brute_painb1;
			}
			self.nextthink = time + 0.05;
		}

		self.monster_long_pain = 0;
		self = oldself;
		return;
	}

	#if 0
	if (self.classname == "boss_guardian3")
	{
		if((self.boss3_model == 3) && (self.health < boss3_mutilationahealth))
		{
			self.think = boss3_mutilationa;
			self.nextthink = time;
			self = oldself;
			return;	
		}
		if((self.boss3_model == 4)  && (self.health < boss3_mutilationbhealth))
		{
			self.think = boss3_mutilationb;
			self.nextthink = time;
			self = oldself;
			return;	
		}

		if((self.boss3_model == 5)  && (self.health < boss3_mutilationchealth))
		{
			self.think = boss3_mutilationc;
			self.nextthink = time;
			self = oldself;
			return;	
		}
	}
	#endif
	

	#if 0 // Reki (September 20 2023): Removed references to legacy code
	if (self.classname == "boss_guardian2")
	{
		if((self.pain_finished > time) || ((self.bosscnt >= 3)))
		{
			self = oldself;
			return;	
		}
		else
		{
			self.think = guardian2_painb;
			self.nextthink = time + 0.05;
			self = oldself;
			return;	
		}

	}
	#endif
	

	if (self.classname == "monster_keeper")
	{
		self.execution_enemy = inflictor;

		if(self.pain_finished > time)
		{
			self = oldself;
			return;	
		}
		else
		{
			self.think = th_painfixed;
			self.nextthink = time + 0.05;
			self = oldself;
			return;	
		}

	}

	if((self.pain_finished > time) && (self.classname == "monster_brute")&& (self.classname == "monster_oppressor"))
	{
		self = oldself;
		return;	
	}

	if(self.classname == "monster_brute")
	{
		float r = random();
		if (r < 0.25)
		{
			self = oldself;
			return;	
		}
	}

	if ((self.th_pain) && (!self.warped))
	{

		

		self.paintake = take;
		self.randomattacked = attacker.randomattack;

		if(take > self.damagetopain)
		{
			self.th_pain(attacker, take);
			self.sustained_damage = 0;
		
		}
		else
			self.sustained_damage += take;

		if(self.classname == "monster_symbol")
		{
			if((self.sustained_damage > self.damagetopain) && (self.pain_finished < time))
				self.th_pain(attacker, take);		
		}

		else
		{
			if(self.sustained_damage > self.damagetopain)
				self.th_pain(attacker, take);		
		}

		if((self.classname == "monster_heretic") && (self.chasing == 1))
		{
			self.sustained_damage = 0;
			if((take >= 100) && (self.pain_finished < time))
			{			
				self.th_pain(attacker, take);
				self.pain_finished = time + 2;
			}
		}

		if(inflictor.effects ==  1024)
			self.th_pain(attacker, take);		


		// nightmare mode monsters don't go into pain frames often
		if (attacker.classname == "player")
		{
			if ((self.flags &FL_MONSTER) && (self.bloody == TRUE))
			{
				if (attacker.isexplosion)
					decal_monster_pain(rorigin(self), inflictorangles);
				else
					decal_monster_pain(rorigin(self), self.enemy.angles);
			}
		}

		if (((skill == 3) || (attacker.flags & FL_MONSTER)) && (self.flags & FL_MONSTER))
			self.pain_finished = time + 5;

	}
	self = oldself;

};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = 
{ 
	float points;
	entity head;
	vector org;
	inflictor.isexplosion = 1;
	head = findradius(inflictor.origin, damage + 40);
	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				org = head.origin + (head.mins + head.maxs) *0.5;
				points = 0.5* vlen(inflictor.origin - org);

				if (points < 0)
					points = 0;

				points = damage - points;

				if (head == attacker)
					points = points *0.5;

				if(head.classname == "cystfield")
					head.ammo_shotgun = 1;

				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						// shambler takes half damage from all explosions

						if ((head.classname == "player") && (inflictor.classname == "executioner"))
							points = 0;
						if ((head.classname == "executioner") && (inflictor.classname == "executioner"))
							points = 0;
						if ((head.solid != SOLID_BSP) && (inflictor.classname == "executioner"))
							points = 0;
						if ((head.classname != "monster_afflicted") && (attacker.classname != "monster_afflicted"))
							T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}

		head = head.chain;
	}
};
.vector fake_origin;
float(vector spot1, vector spot2, entity e) visibleb;

void(entity inflictor, entity attacker, float damage, entity ignore, float radius) T_SplashDamage = 
{ 	
	float points;
	entity head;
	vector org;
	inflictor.isexplosion = 1;
	
	
	head = findradius(inflictor.origin, radius);



	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				
				org = head.origin + (head.mins + head.maxs) *0.5;
				if(head.solid == SOLID_BSP)
					radius += vlen (head.absmax - head.absmin) * 0.5;
				if((head == attacker) && (inflictor.classname == "explosion_ore"))
					damage = damage * 0.25;
				if((head == attacker) && (inflictor.classname == "explosion_oreb"))
					damage = damage * 0.25;
				if((head == attacker) && (inflictor.classname == "explosion_retcher"))
					damage = damage * 0.25;
				if((head == attacker) && (inflictor.classname == "aoe"))
					damage = damage * 0.1;


				points = damage / radius *(radius - (vlen(inflictor.origin - org)));
				if (head == attacker)
					points = points *0.5;
				if(head.classname == "cystfield")
					head.ammo_shotgun = 1;
				if (points > 0)
				{
					if(head.solid == SOLID_BSP)
					{
						if (visibleb(head.absmin, inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
						else if (visibleb(((head.absmin + head.absmax) *0.5), inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
						else if (visibleb(head.absmax, inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
					}
					else
					{
						if (visibleb(head.origin, inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);

						// Achievement tracking stuff
						if ((head.flags & FL_MONSTER) && (head.health <= 0)) // we got a kill
						{
							if (inflictor.classname == "explosion_retcher" && inflictor.cnt == 1)
							{
								if (inflictor.pain_finished && (time - inflictor.pain_finished) > 1) // gotta be planted for at least 1 second
									Steam_AchievementUnlock(world, ST_ACHIEVEMENTS::SP_FEAT_CYST_PLANT);
							}
						}
						//
					}
				}
			}
		}

		head = head.chain;
	}
};


void() backtonormal = { self.movetype = self.oldmovetype;
	self.gravity = 1;
	self.backedtonormal = 1;
	if(self.oldthink)
	self.think = self.oldthink;
	else
	self.think = alphafade;
	self.nextthink = time + 0.1;
	if(self.wrathflags & FL_GIB)
	self.nextthink = time + random (5,20);

};
void()backtonormal_physics_think
{
	self.owner.gravity = 1;
	self.owner.movetype = self.oldmovetype;
	//self.backedtonormal = 1;
	self.think =SUB_Remove;
	self.nextthink = time;
};


void(entity inflictor, entity targ, float damage, float pushfactor) explo_physics = 
{ 
	if(targ.movetype == 4)
		return;
	if(targ.classname == "func_door")
		return;
	vector dir, z_vel;
	if ((inflictor != world) && (targ.movetype == MOVETYPE_STEP) && (targ.timepushing < time)&& (targ.health > 0))
	{
		dir = targ.origin - inflictor.origin;
		dir = normalize(dir);
		if (!targ.oldmovetype)
			targ.oldmovetype = targ.movetype;
		targ.movetype = MOVETYPE_BOUNCE;
		targ.timepushing = targ.nextthink + 1;
		targ.gravity = 0.15;
		if (targ.flags &FL_ONGROUND)
			targ.flags -= FL_ONGROUND;
		targ.backedtonormal = 0; 
		targ.oldthink = targ.think;
		targ.think = backtonormal;
		targ.nextthink = time + 0.1;
		//if(targ.wrathflags & FL_GIB)

		z_vel_z =pushfactor * 12 ;
		targ.velocity = targ.velocity + dir *damage * pushfactor +z_vel;
	}
};


void(entity inflictor, entity targ, float damage, float pushfactor) explo_physics_gibs = 
{ 


	if(targ.movetype == 4)
		return;
	if(targ.classname == "func_door")
		return;
	vector dir, z_vel;
	if ((inflictor != world) && (targ.timepushing < time))
	{
		dir = targ.origin - inflictor.origin;
		dir = normalize(dir);
		if (!targ.oldmovetype)
			targ.oldmovetype = targ.movetype;
		targ.movetype = MOVETYPE_BOUNCE;
		targ.timepushing = time + 0.25;
		targ.gravity = 0.15;
		if (targ.flags &FL_ONGROUND)
			targ.flags -= FL_ONGROUND;
		targ.backedtonormal = 0;
		targ.oldthink = targ.think;
		float pushintensity = 512 - vlen(targ.origin - inflictor.origin); 
		if(pushintensity <= 0)
		pushintensity = 0;
		else
		pushintensity = pushintensity / 7;

		damage += pushintensity;

		targ.think = backtonormal;
		targ.nextthink = time + 0.1;
		z_vel_z =pushfactor * 5 + pushintensity / 5;
		targ.velocity = targ.velocity + dir *damage * pushfactor +z_vel;
	}
};


void(entity inflictor, float damage, float damagetoplayer, entity ignore, float radius, float pushfactor) T_SplashDamageMonster = 
{ 
	float points;
	entity head;
	vector org;
	inflictor.isexplosion = 1;
	head = findradius(inflictor.origin, radius);

	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				org = head.origin + (head.mins + head.maxs) *0.5;




				if (head.classname == "player")
					points = damagetoplayer / radius *(radius - (vlen(inflictor.origin - org)));
				else
					points = damage / radius *(radius - (vlen(inflictor.origin - org)));

				if (head.flaskrage_active >= 1)
				points = points *0.125;


				if (((!(head.flags &FL_MONSTER)) && (head.classname != "player")) && (self.classname != "spining_head_explosion"))
					points = 0;

				if ((head.classname == "monster_heretic") || (head.classname == "monster_wraith"))
					points = 0;
				if ((head.solid == SOLID_BSP) || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small"))
					points = 1000;
				
				
				if (head == inflictor)
					points = points *0.5;
				if ((points > 0) && (pushfactor >= 0))
				{
					entity oldself = self;
					self = inflictor;
					if (visibleb(head.origin, inflictor.origin, self))
					{
						T_Damage(head, inflictor, self, points);
						if ((head.classname != "player") && (!head.heavymonster))
							explo_physics(inflictor, head, points,pushfactor);
					}

					if (inflictor.classname == "monster_wretch" && inflictor.wrath_kills && head.classname == "monster_wretch" && head.health <= 0) // wretch killed another with the explosion
					{
						Steam_AchievementUnlock(world, ST_ACHIEVEMENTS::SP_JOKE_WRETCH);
					}

					self = oldself;
				}
			}
		}

		head = head.chain;
	}
};

void(entity attacker, float damage) T_BeamDamage = 
{	
	float points;
	entity head;
	head = findradius(attacker.origin, damage + 40);
	while (head)
	{
		if ((head.takedamage) && (head.health))
		{
			points = 0.5* vlen(attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points *0.5;
			if (points > 0)
			{
				if (CanDamage(head, attacker))
				{
					if (head.classname == "monster_shambler")
						T_Damage(head, attacker, attacker, points *0.5);

					else
						T_Damage(head, attacker, attacker, points);
				}
			}
		}

		head = head.chain;
	}
};

///////////////////////////////////end of qc file 
///////////////////////////////////end of qc file 
