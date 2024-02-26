.float oldrandomattack;
.float pick_bfg;
.float drunktime;
.float wretch_gibbing;
void()wsfullcharge_bfg;
void() v_bfg_idle = 
{ 
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	if (self.pick_bfg == 1)
	{
		//Hud_message(258, other.origin, other);
		//Hud_SendNotification_Control2(self, "HELP_ATTACK"), "+attack", "+button3";
		//centerprint(self, "$HELP_ATTACK");
		self.pick_bfg = 0;
	}


	if(self.totallungetime > time)
	self.totallungetime = 0;

	self.realoding = 0;
	self.vweaponstate = 0;

	if(self.ammo_bfg < 10)
		self.vweaponframe = 0;
	else
		self.vweaponframe = 7;

	if((self.ammo_bfg >= 10) && (!(self.playerflags & FL_MACECHARGED)))
	{
		self.think = wsfullcharge_bfg;
		self.nextthink = time + 0.05;
		return;
	}

	self.think = v_bfg_idle;
	self.nextthink = time + 0.1;
};

void() LightningHit =
{        
	local	vector org; 
	local	float damage=0; 
	local	entity head;

	org = self.origin + '0 0 16'; 
	head = findradius(self.origin, 512); 
	
	te_customflash ( org,32,1,' 0.89 0.3 0.3');
	while (head) 
	{
		if ((head.takedamage)  && (visible(head)))
		{
			if(head != self.owner)
            {
				sound (head, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM); // its sound
				damage = random(1024,2048); 
				head.shockwaved = 1;
				T_Damage (head, self, self.owner, damage);
			}
		}
        head = head.chain;
	}
        remove(self);
};

void()bfg_explosion_think =
{
    self.alpha -= 0.0065;
    self.scale += 0.1;
    if(self.scale >= 10)
        self.think = SUB_Remove;
    else
        self.think = bfg_explosion_think;
    self.nextthink = time + 0.01; 

};
.float max_homing_projectile;
void() bfg_projectile_touch =
{
	local vector org;
	org = self.origin;
	if (other == self.owner)
		return;
	if (other.wrathflags & FL_PROJECTILE)
		return;
	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		//remove(self.pipes);
		remove(self);
		return;
	}
	spawn_shaker(self,15,1,512);	
	makevectors (self.angles);
	setorigin (self, self.origin - (v_forward * 32));
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner,mace_proj_damage);
		T_SplashDamage(self, self.owner,mace_proj_splashdamage, other, mace_proj_splashradius);
	}
	else
		T_SplashDamage(self, self.owner,mace_proj_splashdamage, world, slagsplashradius);

	entity model = spawn();
	model.origin = self.origin;
	setmodel (model,"models/artifacts/effects/orb_shockwave1.md3");
	model.scale = 0.1;
    model.alpha = 0.25;
	model.colormod = '7 0 0';
	model.think = bfg_explosion_think;
	model.nextthink = time;

	entity slag_explo = spawn();
	float skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	slag_explo.origin = self.origin - v_forward * 16;
	slag_explo.skin = skinn * 10;
    slag_explo.alpha = 0.5;
	slag_explo.scale = random(1.5,2); 
    slag_explo.colormod = '5 1 1';
	setmodel(slag_explo, "particles/explo/explo_slag2.md3");
	slag_explo.think = slag2_explode1;
	slag_explo.nextthink = time + 0.1;


	entity gibpusher = spawn();
	setmodel(gibpusher,"");
	gibpusher.origin = slag_explo.origin - '0 0 32';
	gibpusher.cnt = 16;
	gibpusher.count = 256;// radius
	gibpusher.think = gibpusher_think;
	gibpusher.nextthink = time + 0.25;

	vector old_impact = trace_endpos;
	traceline(self.origin, self.origin + v_forward *1024, MOVE_HITMODEL, self);
	if (trace_ent != other)
		trace_endpos = old_impact;
    if(other.bloody == 2)
    {
		makevectors2 (self.angles);
		if ((bossvulnerable == 1))
		{
			if(other == trace_ent)
			{

				float r = random(); 
			    {
					if(other.classname == "boss_guardian2")
						explo_blood_sprite(2, trace_endpos);
					else
						explo_blood_sprite(5, trace_endpos);
			    }
			}
			
		}
	    SpawnBlood(org, '0 0 0', 21, 6,1);
    }
	if (other.bloodimpact)
		explo_blood_sprite(other.bloodimpact, trace_endpos);

	pointparticles(particleeffectnum("mace_projectile_explosion"), org, '0 0 0', 1 + (3.5* (10- self.ammo_bfg) ));
  	//  LightningHit();
	//remove(self.pipes);
    remove(self);
};
//float(entity targ, float dist, float deviance) visibleinfront2 ;


void() bfg_search_enemy =
{
	entity near;
	float low = 999999;	
	float score, maxproj;
	
	if(!self.enemy)
	{
		local entity head;
		head = findradius(self.origin, 2048);


		while (head)
		{

		if(head.health >= 0)
			maxproj = 1;
		if(head.health >= 1500)
			maxproj = 2;
		if(head.health > 3000)
			maxproj = 3;

		if ((head.classname == "boss_guardian1") || (head.classname == "boss_guardian2") || (head.classname == "boss_guardian3"))
			maxproj = 10;

			if ((visibleinfront(head, 2048)) && ((head.flags & FL_MONSTER) || ((head.classname == "boss_guardian1") || (head.classname == "boss_guardian2") || ((head.classname == "boss_guardian3") && !(head.flags & FL_NOTARGET))))&& (head.health > 0)&&(head.max_homing_projectile < maxproj))
			{
				score = vlen(head.origin - self.origin);
				if (score < 192) // if it's TOO close, choose a slightly further target
					score += 384;
				score -= head.health * 2;
				
				if (score < low)
				{
					low = score;
					near = head;
				}
			}

			head = head.chain;
		} 
	}

	if (near)
	{
		self.enemy = near;
		if(self.enemy.classname == "boss_guardian3")
		{
			self.originoffset_x = random(-64,64); 
			self.originoffset_y = random(-64,64); 
			self.originoffset_z = random(-128,128); 
		}
		else
		self.originoffset = '0 0 0';
		self.enemy.max_homing_projectile ++;
	}

};
void() mace_bfg_drunk = 
{ 
	vector oldvel = self.velocity;
	vector nextvel;
	if(!self.enemy)
	{
		self.velocity_x = self.velocity_x * 1.05;
		self.velocity_y = self.velocity_y * 1.05;
		self.velocity_z = self.velocity_z * 1.05;
		if(time > self.drunktime)
		{
			//makevectors (self.angles);
			//self.velocity += v_right * random(-16,16)  + v_up * random (-16, 16);
			self.drunktime = time + random(0.3,1);	// screw up fast
			//pointparticles(particleeffectnum("mace_projectile_trail2"), self.origin + v_forward * -32, self.velocity,1);
			bfg_search_enemy();
		}
	}
	else
	{
		float speed = vlen(self.velocity);

		vector venemyorg = self.enemy.origin + self.originoffset;


		vector vtemp = venemyorg + '0 0 0';
		float dist = vlen(self.origin -venemyorg);	
		if ((self.enemy.health > 0) ) 
		{
			if(dist > 128)
			{
				vector dir = normalize(vtemp - self.origin);
				vector wishvel = dir * speed;
				nextvel = wishvel;
			}
			else
			{
				dir = normalize (venemyorg - self.origin);
				nextvel = dir * speed * 3;
			}
		}
		self.velocity_x = ((oldvel_x) *(1- mace_proj_homingfactor)) + (nextvel_x * mace_proj_homingfactor);
		self.velocity_y = ((oldvel_y) *(1- mace_proj_homingfactor)) + (nextvel_y * mace_proj_homingfactor);
		self.velocity_z = ((oldvel_z) *(1- mace_proj_homingfactor)) + (nextvel_z * mace_proj_homingfactor);
		self.velocity_x = self.velocity_x * 1.15;
		self.velocity_y = self.velocity_y * 1.15;
		self.velocity_z = self.velocity_z * 1.15;

	}
	self.angles = vectoangles(self.velocity);
	if((self.origin ==  self.oldorigin))
	{
		self.think = bfg_projectile_touch;
	}
	else
	{
		if (self.lifetime > time)
			self.think = mace_bfg_drunk;
		else
			self.think = SUB_Remove;
	}
	if(self.scale < 1.5)
		self.scale += 0.15;
	self.oldorigin = self.origin;

	if(self.cnt != 1)
		self.nextthink = time + 0.1;
	else
		self.nextthink = time + 0.025;
};
void() pre_mace_projectiles =
{
	self.oldorigin = self.origin;
	self.angles = vectoangles(self.velocity);
	if(self.scale < 1.5)
		self.scale += 0.15;
	self.solid = SOLID_CORPSE;
	self.effects = 0;
	self.velocity_x = self.velocity_x * 1.05;
	self.velocity_y = self.velocity_y * 1.05;
	self.velocity_z = self.velocity_z * 1.05;
	self.touch = bfg_projectile_touch;
	makevectors2 (self.angles);
	self.velocity = v_forward * mace_proj_speed;
	self.lifetime = time + 12;
	self.think  = mace_bfg_drunk;
	self.nextthink =  time + 0.025 + (self.ammo_bfg * 0.025);
};

void(float spread, float total_to_spawn) shoot_projectiles
{	
	local vector dir, tagorg;
	local float tagindex;
	tagindex = gettagindex(self.vweapon, "tag_mace");
	tagorg = gettaginfo(self.vweapon, tagindex);
	local entity sotgun_projectile;
	sotgun_projectile=  spawn();
	sotgun_projectile.owner =  self;
	sotgun_projectile.modelflags  = MF_TRACER3;	
	dir = aim(self, 1000);
	makevectors (self.v_angle);
	setorigin(sotgun_projectile, tagorg - v_forward * 12);
	setmodel(sotgun_projectile, "models/projectiles/proj_mace.md3");
	sotgun_projectile.solid = SOLID_TRIGGER;
	setsize(sotgun_projectile,  '-5 -5 -5','5 5 5');
	sotgun_projectile.velocity = normalize(cursor_trace_endpos_fixed (self) - tagorg) *192;
	makevectors (self.angles);
	if (spread > 1)
	{
		vector hspread;
		float odd;
		if (spread % 2)
			odd = 1;
		else
			odd = -1;

		hspread = v_right * (odd * random(5,7) * spread);
		sotgun_projectile.velocity += (v_up * random (-3,3) * spread) + hspread; 
	}
	sotgun_projectile.movetype = MOVETYPE_FLY;
	sotgun_projectile.solid = 0;
	sotgun_projectile.dphitcontentsmask = DPCONTENTSMASK_WEAPON;
	sotgun_projectile.touch = bfg_projectile_touch;
	sotgun_projectile.pflags = 128;
	sotgun_projectile.wrathflags += FL_PROJECTILE;	
	sotgun_projectile.effects = EF_NODRAW;
	sotgun_projectile.classname = "maceprojectile";
	sotgun_projectile.scale = 0.25;
	sotgun_projectile.light_lev = 64;
	sotgun_projectile.ammo_bfg = total_to_spawn - spread;
	sotgun_projectile.color = '3 1 1';
	sotgun_projectile.traileffectnum = particleeffectnum("mace_projectile_trail");
	sotgun_projectile.think  = pre_mace_projectiles;
	sotgun_projectile.nextthink =  time + 0.05;
	sotgun_projectile.nextthink += 0.1;
};

void() wsfire_bfg4 = 
{ 
	
	self.think = v_bfg_idle; 
	self.nextthink = time + 1;
};

void() wsfire_bfg3 = 
{ 	
	string snd = strcat("weapons/spitter/fire2_", ftos(floor(random() *spitter_svsf) + 1), ".wav");
	float snd_pitch;
	snd_pitch = 107 - (self.ammo_bfg * 7);
	float wvol = cvar ("weapons_fire_volume");
	sound7(self, CHAN_AUTO, snd, wvol, ATTN_NORM,snd_pitch ,0);
	self.think = wsfire_bfg4; 
	self.nextthink = time;
};

void() wsfire_bfg2 = 
{ 
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
		self.punchangle_x = -5 -(self.ammo_bfg * 0.3);


	if(deathmatch == 1) 
		vector dir = v_forward * ((self.ammo_bfg + 7) * -45);
	else
		dir = v_forward * ((self.ammo_bfg + 7) * -45);

	if(self.flags & FL_ONGROUND)
	self.flags -= FL_ONGROUND;
	dir_z =  dir_z * 0.75; 
	self.velocity += '0 0 24'; 
	self.velocity += dir;
	local vector tagorg;
	local float tagindex;
	tagindex = gettagindex(self.vweapon, "tag_mace");
	tagorg = gettaginfo(self.vweapon, tagindex);

	te_customflash(tagorg,64,1,'3 0.05 0.05');

	spawn_shaker(self,self.ammo_bfg * 3,1,512);	
	Controller_Rumble(self, 0.2 + min(1, (self.ammo_bfg / 10) * 0.7), 0.23 + (self.ammo_bfg / 100), 340 + (self.ammo_bfg * 4));

	entity enemyhead = findradius(self.origin, 99999);	
	while (enemyhead)
	{
		if((enemyhead.flags & FL_MONSTER) || ((enemyhead.classname == "boss_guardian1") || (enemyhead.classname == "boss_guardian2") ||(enemyhead.classname == "boss_guardian3")))
		{
			enemyhead.max_homing_projectile  = 0;				
		}
		enemyhead = enemyhead.chain; 
	} 

	
	float start_ammo = self.ammo_bfg;
	while(self.ammo_bfg > 0)
	{
		shoot_projectiles(self.ammo_bfg, start_ammo);
		self.ammo_bfg --;
	}



	if(self.playerflags & FL_MACECHARGED)
		self.playerflags -= FL_MACECHARGED;
	self.vweaponframe = 6;
	self.think = wsfire_bfg3; 
	self.nextthink = time;
};

void() wsfire_bfg = 
{ 
	self.vweaponframe = 5;
	self.think = wsfire_bfg2;
	playerwsound("weapons/mace/mace_altfire", 3, CHAN_AUTO);
	
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
		self.punchangle_x = 2;
	Controller_Rumble(self, 0.1, 0.22, 800);

	te_customflash(self.origin,32 + single_player.ammo_bfg * 2.5,5,'3 0.15 0.15');
	self.nextthink = time + 1;
	self.attack_finished = time + 2;
};

void() wsfullcharge_bfg = 
{ 
	sound(single_player, CHAN_AUTO,"weapons/mace/mace_unfold1.ogg", 1, ATTN_NORM);
	self.vweaponframe = 8;
	self.playerflags += FL_MACECHARGED;
	self.think = v_bfg_idle;
	self.nextthink = time + 1;
	self.attack_finished = time + 0.05;
};

void(float x_ang, float y_ang) bfg_angles = 
{ 
	x_ang = x_ang *0.25;
	y_ang = y_ang *0.25;

	msg_entity = self;
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, self.v_angle_x + x_ang);
	WriteAngle(MSG_ONE, self.v_angle_y + y_ang);
	WriteAngle(MSG_ONE, self.v_angle_z);
};

void() bfg_angles_center = 
{ 
	msg_entity = self;
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, 0);
	WriteAngle(MSG_ONE, self.v_angle_y);
	WriteAngle(MSG_ONE, self.v_angle_z);
};

.float bfg_dmg_ammount;
void(vector org,string locsound, float rnd, float vol, float sspeed) randompointsound7;
void(vector org, string locsound, float rnd, float vol) randompointsound;
void(entity e)flash_screen_item;
void() soulintag =
{

	setorigin (self,single_player.maceorigin);
	self.scale = self.scale * 0.9;
	if (self.scale < 0.3)
	{
		self.think = SUB_Remove;	
		if (single_player.ammo_bfg < 10)
			single_player.ammo_bfg += 1;
		pointparticles(particleeffectnum("soul_mace"), single_player.maceorigin, '0 0 0', single_player.ammo_bfg);
		te_customflash(self.origin,single_player.ammo_bfg * 3.5,7,'3 0 0');

		string snd = strcat ("weapons/mace/mace_absorb",ftos(single_player.ammo_bfg ),".ogg");
		sound(single_player, CHAN_AUTO, snd, 0.7, ATTN_NORM);

		stuffcmd (single_player,"pulseammo\n");
		flash_screen_item(single_player);
		//Hud_message(127, single_player.origin, single_player);
		Hud_SendNotification(single_player, "soul", "$NOTIFY_AMMO_SOUL", HUDMSGFLAG::AGGREGATE);
		Steam_StatIncrement(single_player, ST_STATS::souls_harvested, 1);
	}
	else
		self.think = soulintag;	
	self.nextthink = time + 0.01;
};
void() soulhome =
{
	local vector	dir, vtemp;
	vtemp = single_player.maceorigin;

	if(self.alpha < 1)
	{
		self.alpha += 0.00425;
		self.scale = self.alpha * 2.5;
	}

	if((self.alpha >= 0.25) && (self.alpha < 0.5)	&& (self.count != 2))
	{
		{
			randompointsound(self.origin,"weapons/mace/mace_soul_release", 8, random(0.9,1));
			self.count = 2;
		}	
	}


	float dist = vlen (self.origin - vtemp);

	if(self.alpha >= 0.5)
	{		
		self.alpha = 1;

		float playerisvisible = 0;
		
		if(self.type != 1)
		{
			if(self.attack_finished < time) 
			{
				playerisvisible = visibleb(self.origin,single_player.origin,world);
				self.attack_finished = time + 0.5;
				if((playerisvisible == 1) && (single_player.ammo_bfg < 10) &&((single_player.weapon == IT_MACE)))
					self.type = 1;
				else
					self.type = 0;
			}
		}
		if ((single_player.health < 1)||(self.type != 1)|| (single_player.weapon != IT_MACE) || (single_player.ammo_bfg >= 10))
		{
			if(self.cnt != 1)
				self.velocity = '0 0 0';

			if(self.cnt == 1)
			{
				float tspeed = vlen (self.velocity);
				float tdist = vlen (self.origin - self.ldorigin);
				if((tdist < self.roaming) && (tspeed > 5))
				{
					self.velocity_x = self.velocity_x * 0.99;
					self.velocity_y = self.velocity_y * 0.99;
					self.velocity_z = self.velocity_z * 0.99;
				}
				else
				{
					dir = normalize(self.ldorigin - self.origin);
					self.velocity = dir * random(5,24);
				}

			    self.nextthink = time + 0.05;
			    self.think = soulhome;	
				return;
			}
			self.movetype = 0;
			self.pflags = 0;
			self.type = 0;
	        self.nextthink = time + 0.01;
	        self.think = soulhome;	
			//remove(self);
			return;
		}
		if (self.type == 1)
		{
			if(self.cnt != 1)
				self.movetype = MOVETYPE_NOCLIP;

			self.cnt = 0;
			single_player.macesoultime =  time + 0.1;
			dir = normalize(vtemp - self.origin);

			self.velocity = dir * 768;
			if((dist < 64) && (self.scale > 0.3))
				self.scale = self.scale * 0.95;
			if(dist < 12)
			{
				//stuffcmd (single_player, "bf 1 0.5 0.5 0.5 1 \n");
				self.velocity = dir * 64;
				self.nextthink = time + 0.01;
				self.think = soulintag;	
				return;
			}
			if(self.count != 1)
			{

				pointparticles(particleeffectnum("soul_mace_ready"), self.oldorigin, '0 0 0', 1);
				self.nextthink = time + 0.05;
				te_customflash(self.oldorigin,64,2,'3 0 0');
				self.pflags = 129;
				self.light_lev = 64;
				self.color = '3 1 1';
				self.colormod = '3 1 1';
				self.velocity = '0 0 0';
				self.count = 1;
			}
		}
	}
	else
		self.oldorigin = self.origin;
	self.nextthink = time + 0.01;
	self.think = soulhome;	
};

void() soulcolormod_controller = 
{
	if(!self.cnt)
	{
		if(!(self.chain.effects & 512))
			self.chain.effects += 512;
		self.colormod = getlight(self.chain.origin);
		self.colormod += '3 0.5 0.5';
		entity gibspawned = findradius(self.chain.origin, 1024);
		while (gibspawned)
		{
			if (gibspawned.gibowner == self.chain) 
			{
				entity colormod_controller = spawn();
				colormod_controller.pipes = self.pipes;	
				colormod_controller.oldorigin = self.chain.origin;
				colormod_controller.chain = gibspawned;
				if(!(colormod_controller.effects & 512))
					colormod_controller.chain.effects += 512;
				colormod_controller.colormod = getlight(colormod_controller.chain.origin);
				colormod_controller.colormod += '3 0.5 0.5';
				colormod_controller.cnt = 2;
				colormod_controller.think = soulcolormod_controller;
				colormod_controller.nextthink = time;
			}
			gibspawned = gibspawned.chain; // go to next enemy
		}
		self.cnt = 1;
	}		
	if((self.cnt == 2) && (self.attack_finished < time))
	{
		float dist = vlen (self.chain.origin - (self.pipes.origin + '0 0 24'));
		float speed = dist;
		vector dir = normalize((self.pipes.origin + '0 0 24') - self.chain.origin) * speed;
		pointparticles(particleeffectnum("secondary_soul_mace"), self.chain.origin,dir, 1);
		self.attack_finished = time + random(0.05, 0.1);
	}
	if((self.cnt == 1) && (self.attack_finished < time))
	{
		vector chainorigin;
		chainorigin_x = self.chain.origin_x + random(-32,32);
		chainorigin_y = self.chain.origin_y + random(-32,32);
		chainorigin_z = self.chain.origin_z + (self.chain.absmin_z * 0.75);

		dist = vlen (chainorigin - (self.pipes.origin + '0 0 32'));
		speed = dist;
		dir = normalize((self.pipes.origin + '0 0 24') - chainorigin) * speed;
		pointparticles(particleeffectnum("secondary_soul_mace"), chainorigin,dir, 1);
		self.attack_finished = time + random(0.0125, 0.05);
	}
	self.ldorigin = getlight(self.chain.origin);
	self.colormod_x -= 0.15;	
	self.colormod_y -= 0.025;	
	self.colormod_z -= 0.025;	
	if(self.colormod_x <= self.ldorigin_x)
	{
		if(self.chain.effects & 512)
			self.chain.effects -= 512;
		self.colormod = '0 0 0';
		remove(self);
		return;
	}
	self.chain.colormod = self.colormod;
	self.think = soulcolormod_controller;
	self.nextthink = time + 0.025;
};

void (float dir, float dirv, float damg) w_bfg_slash = 
{
	local vector source, org, orn, ornv;

	if (dir == 1)
		orn = v_right *-48;
	if (dir == 2)
		orn = v_right * 0;
	if (dir == 3)
		orn = v_right * 48;

	if (dirv == 1)
		ornv = v_up * 24;
	if (dirv == 2)
		ornv = v_up * 0;
	if (dirv == 3)
		ornv = v_up *-24;

	makevectors(self.v_angle);
	source = self.origin + '0 0 16' - v_forward * 12;
	float o_dphitcontents = self.dphitcontentsmask;
	self.dphitcontentsmask = DPCONTENTSMASK_WEAPON;
	tracebox(source, '-12 -12 -3', '12 12 3', source + v_forward *96 + orn + ornv, FALSE, self);
	self.dphitcontentsmask = o_dphitcontents;
	if (trace_fraction == 1.0 || GetSkyMaterial())
		return;

	org = trace_endpos - v_forward * 4;



	float dmg = damg + (self.ammo_bfg  * damg);
	if(self.ammo_bfg >= 12)
		dmg = damg + (12  * mace_additional_damage);



	if (trace_ent.takedamage)
	{
		if(damg ==100)
		spawn_shaker(self,3 + self.ammo_bfg * 1.75,0.75,512);	
		if (trace_ent.bloody == 1)
			SpawnBlood(org, '0 0 0', 20, 3, floor(1 + (self.ammo_bfg / 2)));
		if (trace_ent.flags & FL_MONSTER)
		{

			randompointsound7(trace_endpos,"impact/projectiles/bullet", 10, 1, random (60,75));
			randompointsound7(trace_endpos,"impact/projectiles/bullet", 10, 1, random (100,120));

			//playersound("weapons/mace/mace_hit", 5);
			trace_ent.death_time_sound = time + 1;
			if(!self.macemeleeskin)
				self.macemeleeskin = 1;

		}
		string sasd = strcat ((ftos (trace_ent.health)), (" monsterhealth"),ftos(dmg),(" damage"),"\n");
		bprint (sasd);
		if((dmg >= trace_ent.health) &&(trace_ent.flags & FL_MONSTER) && (self.ammo_bfg < 10))
		{
			trace_ent.wretch_gibbing = -1;
			trace_ent.killedbyblade = 1;
			entity 	soul = spawn();
			soul.origin = trace_ent.origin;
			soul.origin_z += trace_ent.mins_z * 0.75;
			soul.colormod = '1 0.5 0.5';
			setmodel(soul,"models/weapons/mace/soul.md3");
			float r = floor (random(10));
			string snd = strcat ("weapons/mace/mace_absorb",ftos(r),".ogg");
			randompointsound(trace_endpos,"weapons/mace/mace_impact", 5, random(0.9,1));

			soul.think = soulhome;
			soul.solid = SOLID_NOT;
			soul.movetype = MOVETYPE_FLY;			
			soul.traileffectnum = particleeffectnum("soul_mace_trail");
			soul.velocity_z = 32;
			soul.lifetime = time + 0.95; 
			soul.alpha = 0.025;
			soul.nextthink = time;
			entity colormod_controller = spawn();
			colormod_controller.chain = trace_ent;
			colormod_controller.pipes = soul;
			colormod_controller.origin = self.origin;
			colormod_controller.think = soulcolormod_controller;
			colormod_controller.nextthink = time + 0.15;
			sound7(colormod_controller,CHAN_AUTO,snd,0.25,0.25,random(20,30),0);
		}

		T_Damage(trace_ent, self, self, dmg);

		entity old_ent = trace_ent;
		vector old_impact = trace_endpos;
		traceline(source, source + v_forward*1024, MOVE_HITMODEL, self);
		if (trace_ent != old_ent)
			trace_endpos = old_impact;

        if(old_ent.bloody == 2)
        {
		    SpawnBlood(org, '0 0 0', 20, 6, 0);
			if ((bossvulnerable == 1))
			{
				if(old_ent == trace_ent)
				{
					if(old_ent.classname == "boss_guardian2")
						explo_blood_sprite(7, trace_endpos);
					else
						explo_blood_sprite(5, trace_endpos);
				}
				
			}
        }
		if (old_ent.bloodimpact)
			explo_blood_sprite(old_ent.bloodimpact, trace_endpos);
		
		self.bfg_dmg_ammount -= 10;
	}
	else
	{
		if (!trace_inwater)
		{
			float material = GetTraceMaterial();
	        vector partvel =normalize(trace_plane_normal) * 92;
			if (material == MAT_SNOW)
			{	
				randompointsound7(trace_endpos,"impact/projectiles/bullet", 10, 1, random (60,75));
				randompointsound7(trace_endpos,"impact/projectiles/bullet", 10, 1, random (100,120));
				pointparticles(particleeffectnum("snowparticles"),org, partvel * random (1,1.5), 1);
				return;
			}
			if (material == MAT_BFLESH)
			{
				randompointsound7(trace_endpos,"impact/projectiles/bullet", 10, 1, random (60,75));
				randompointsound7(trace_endpos,"impact/projectiles/bullet", 10, 1, random (100,120));
				pointparticles(particleeffectnum("NORMAL_BLOOD"),org, partvel * 0.5, 1);
				pointparticles(particleeffectnum("NORMAL_BLOOD2"),org, partvel, 1);
				randompointsound(org,"impact/gibs/gib_hit", 6, random(0.5,1));
				float rgib= random();
				if (rgib < 0.3)
				SpawnGib(org,partvel * 4);
				return;
			}

			randompointsound(trace_endpos,"weapons/mace/mace_hit_stone", 4, 1);
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, org_x);
			WriteCoord(MSG_BROADCAST, org_y);
			WriteCoord(MSG_BROADCAST, org_z);
		}
	}
};

.float fakeframe;
.float punchangletime;




void() mace_push_gibs =
{
	makevectors (self.v_angle);
	vector org;
	if (self.randomattack == 1)
		org = self.origin + '0 0 48'+ v_forward * 12;
	if (self.randomattack == 2)
		org = self.origin + '0 0 8'+ v_forward * 12 + v_right * -32;
	if (self.randomattack == 3)
		org = self.origin + '0 0 8'+ v_forward * 12 + v_right * 32;
	if (self.randomattack == 4)
		org = self.origin + '0 0 48'+ v_forward * 12;
	entity gibpusher = spawn();
	setmodel(gibpusher,"");
	gibpusher.origin = org;
	gibpusher.cnt = self.ammo_bfg;
	gibpusher.count = 64;// radius
	gibpusher.think = gibpusher_think;
	gibpusher.nextthink = time + 0.25;
}

void() w_bfg_slash2 = 
{ 
	self.fakeframe += 1;
	if (self.fakeframe == 4)
		playerwsound("weapons/mace/mace_attack", 4, CHAN_AUTO);
	if((self.punchangletime < time) &&(self.punchangletime != -1))
	{
		makevectors (self.v_angle);
		if (self.randomattack == 1)
			self.punchangle_x = 0.375 * self.ammo_bfg;
		if (self.randomattack == 2)
			self.punchangle_y = -0.375 * self.ammo_bfg;
		if (self.randomattack == 3)
			self.punchangle_y = 0.375 * self.ammo_bfg;
		if (self.randomattack == 4)
			self.punchangle_x = 0.375 * self.ammo_bfg;
		self.punchangletime = -1;	
		mace_push_gibs();
	}
	if (self.randomattack == 1)
	{
		if (self.fakeframe == 4)
			w_bfg_slash(1, 2,mace_damage * 0.5);

		if (self.fakeframe == 5)
			w_bfg_slash(2, 2,mace_damage);
		if (self.fakeframe == 6)
			w_bfg_slash(3, 2,mace_damage * 0.5);
	}

	if (self.randomattack == 2)
	{
		if (self.fakeframe == 4)
			w_bfg_slash(1, 1,mace_damage * 0.5);
		if (self.fakeframe == 5)
			w_bfg_slash(2, 2,mace_damage);
		if (self.fakeframe == 6)
			w_bfg_slash(3, 3,mace_damage * 0.5);
	}

	if (self.randomattack == 3)
	{
		if (self.fakeframe == 4)
			w_bfg_slash(3, 1,mace_damage* 0.5);
		if (self.fakeframe == 5)
			w_bfg_slash(2, 2,mace_damage);
		if (self.fakeframe == 6)
			w_bfg_slash(1, 3,mace_damage* 0.5);
	}

	if (self.randomattack == 4)
	{
		if (self.fakeframe == 4)
			w_bfg_slash(1, 3,mace_damage* 0.5);
		if (self.fakeframe == 5)
			w_bfg_slash(2, 2,mace_damage);
		if (self.fakeframe == 6)
			w_bfg_slash(3, 1,mace_damage* 0.5);
	}


	if((self.ammo_bfg >= 10) && (!(self.playerflags & FL_MACECHARGED)) &&(self.fakeframe >= 20))
	{
		self.think = wsfullcharge_bfg;
		self.nextthink = time + 0.05;
		return;
	}

	if (self.fakeframe >= 20)
		self.think = v_bfg_idle;
	else
		self.think = w_bfg_slash2;

	self.nextthink = time + 0.05;
};

void() w_bfg_slash1 = { self.oldrandomattack = self.randomattack;

	 self.punchangletime = time + 0.39;
	if (self.randomattack == 1)
		{self.vweaponframe = 1; self.punchangle_x = -0.25 * self.ammo_bfg;}
	if (self.randomattack == 2)
		{self.vweaponframe = 2; self.punchangle_y = 0.25 * self.ammo_bfg;}
	if (self.randomattack == 3)
		{self.vweaponframe = 3; self.punchangle_y = -0.25 * self.ammo_bfg;}
	if (self.randomattack == 4)
		{self.vweaponframe = 4; self.punchangle_x = -0.25 * self.ammo_bfg;}

	Controller_Rumble(self, 0.2, 0.02, 240);

	self.bfg_dmg_ammount = 25;

	self.fakeframe = 0;
	self.think = w_bfg_slash2;
	self.nextthink = time;

};

void() w_bfg_attack = { local float r;

	r = random();

	if (r > 0.75)
		self.randomattack = 1;
	else if (r > 0.5)
		self.randomattack = 2;
	else if (r > 0.25)
		self.randomattack = 3;
	else
		self.randomattack = 4;


	if (self.oldrandomattack == self.randomattack)
		self.randomattack += 1;

	if (self.randomattack > 4)
		self.randomattack = 1;

	if(self.ammo_bfg < 10)
		self.vweaponframe = 0;
	else
		self.vweaponframe = 7;

	self.think = w_bfg_slash1;
	self.nextthink = time;
};

.entity vbfg;
.entity vblood;
.entity vbfg1;
.entity vbfg2;
.entity vbfg3;

void() lower_bfg2 = 
{ 
	self.vweaponframe += 1;
	if (self.vweaponframe == 17)
	{
		if((!(wasfreed(self.vbfg)) && (self.vbfg.wrathflags & FL_SUBWEAPONMODEL)))
			remove(self.vbfg);

		if((!(wasfreed(self.vblood)) && (self.vblood.wrathflags & FL_SUBWEAPONMODEL)))
			remove(self.vblood);
	}

	if (self.vweaponframe >= 18)
		self.think = raise_weapon;
	else
		self.think = lower_bfg2;
	self.nextthink = time + 0.025;
};

void() lower_bfg = 
{ 
	self.vweaponframe = 14;
	self.attack_finished = time + 0.25;
	self.think = lower_bfg2;
	self.vweaponstate = 2;
	self.macemeleeskin_time = time + 30;
	self.nextthink = time + 0.025;
};
void() v_bfg_blood_think;
void() v_bfg_blood_think_fading = 
{ 
	self.glowmod = self.owner.vweaponglowmod;
	self.alpha -= 0.0125;
	self.owner.macemeleeskin = 0;
	if (self.alpha <= 0)
		self.effects = EF_NODRAW;
	else
		self.effects = 0;
	if (self.alpha > 0)
		self.think = v_bfg_blood_think_fading;
	else
	{
		self.effects = EF_NODRAW;
		self.alpha = -1;
		self.owner.macemeleeskin = 0;
		self.think = v_bfg_blood_think;
	}

	self.nextthink = time + 0.025;
}

void() v_bfg_blood_think = 
{ 

	self.ammo_bfg = self.owner.ammo_bfg / 2;
	if(self.owner.ammo_bfg >= 10)
	{
		if(self.count < 2)
		{
			self.count ++;
			self.frame = 1;
		}
		else
			self.frame = 2;
	}
	else
	{
		if(self.frame != 0)
		{
			self.count = 0;
			self.frame = 0;
		}
	}
	if ((self.owner.macemeleeskin == 1) && (self.alpha == -1))
	{
		self.alpha = 1;
		self.effects = 0;
	}
	if ((self.owner.macemeleeskin != 1) || (self.alpha <= 0))
	{
		self.alpha = -1;
		self.effects = EF_NODRAW;
	}
	if (self.owner.waterlevel >= 3)
		self.think = v_bfg_blood_think_fading;
	else
		self.think = v_bfg_blood_think;

	if(self.owner.weapon != IT_MACE)
		self.think = SUB_Remove;
	self.glowmod = self.owner.vweaponglowmod;
	self.nextthink = time + 0.025;
};

void() v_bfg_mace_think = 
{ 
	self.skin = self.owner.macemeleeskin;
	self.glowmod = self.owner.vweaponglowmod;
	self.alpha = 1;
	if(self.owner.weapon != IT_MACE)
		self.think = SUB_Remove;
	else
		self.think = v_bfg_mace_think;

	if(self.owner.ammo_bfg == 1)
		self.skin = 1;
	else
		self.skin = self.owner.ammo_bfg / 2;


	if(self.skin >= 5)
	{
		self.skin = 5;
		if(self.count < 2)
		{
			self.count ++;
			self.frame = 1;
		}
		else
			self.frame = 2;
	}
	else
	{
		if(self.frame != 0)
		{
			self.count = 0;
			self.frame = 0;
		}
	}
	self.owner.phantommodelframe = self.frame;
	self.nextthink = time + 0.05;
};

void() v_bfg_mace_think2 = 
{ 	
	self.cnt += 1;
	if (self.cnt < 60)
	{
		if (self.alpha < 1)
			self.alpha += 0.05;
		else
			self.alpha = 1;
	}
	else
	{
		self.alpha -= 0.05;
	}

	if(self.owner.weapon != IT_MACE)
		self.effects = EF_NODRAW;
	else
	{
		if (self.alpha <= 0)
			self.effects = EF_NODRAW;
		else
			self.effects = 0;
	}
	if ((self.cnt > 81) && (self.alpha <= 0.05))	//|| (self.owner.weapon != IT_MACE))
		self.think = SUB_Remove;
	else
		self.think = v_bfg_mace_think2;
	self.nextthink = time + 0.05;

};
void() v_bfg_mace_think3 = 
{ 
	self.skin = self.owner.macemeleeskin;
	self.glowmod = self.owner.vweaponglowmod;
	self.cnt += 1;

	if(self.owner.weapon != IT_MACE)
		self.effects = EF_NODRAW;

	if (self.cnt >= 60)
		self.alpha = 0;
	if (self.cnt > 81)
		self.think = v_bfg_mace_think;
	else
		self.think = v_bfg_mace_think3;
	self.nextthink = time + 0.05;

};

void(entity e, entity vweapn) spawn_v_bfg_mace2 = 
{ 
	e.vbfg = spawn();
	e.vbfg.wrathflags += FL_GARBAGE;
	e.vbfg.owner = e;
	setmodel(e.vbfg, "models/weapons/mace/v_mace.md3");
	setattachment(e.vbfg, vweapn, "tag_mace");
	e.vbfg.classname ="mace_submodel";
	e.vbfg.think = v_bfg_mace_think3;
	e.vbfg.glowmod = '0.1 0.1 0.1';
	e.vbfg.nextthink = time;
	e.vbfg1 = spawn();
	e.vbfg1.wrathflags += FL_GARBAGE;
	e.vbfg1.owner = e;
	e.vbfg1.glowmod = '0.1 0.1 0.1';
	setmodel(e.vbfg1, "models/weapons/mace/v_mace_runes.md3");
	setattachment(e.vbfg1, vweapn, "tag_mace");
	e.vbfg1.think = v_bfg_mace_think2;
	e.vbfg1.nextthink = time;
	/*
	e.vbfg2 = spawn();
	e.vbfg2.wrathflags += FL_GARBAGE;
	e.vbfg2.owner = e;
	setmodel(e.vbfg2, "models/weapons/mace/v_mace_energy.md3");
	setattachment(e.vbfg2, vweapn, "tag_mace");
	e.vbfg2.glowmod = '0.1 0.1 0.1';
	e.vbfg2.think = v_bfg_mace_think2;
	e.vbfg2.nextthink = time;
	*/
	e.vbfg3 = spawn();
	e.vbfg3.wrathflags += FL_GARBAGE;
	e.vbfg3.owner = e;
	e.vbfg3.glowmod = '0.1 0.1 0.1';
	e.vbfg3.count = 1;
	setmodel(e.vbfg3, "models/weapons/mace/v_mace_hot.md3");
	setattachment(e.vbfg3, vweapn, "tag_mace");
	e.vbfg3.think = v_bfg_mace_think2;
	e.vbfg3.nextthink = time;
	e.vbfg.alpha = 1;
	e.vbfg1.alpha = -1;
	//e.vbfg2.alpha = -1.5;
	e.vbfg3.alpha = -2;

};

void(entity e, entity vweapn) spawn_v_bfg_mace = 
{ 
	e.vbfg = spawn();
	e.vbfg.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
	e.vbfg.owner = e;
	e.vbfg.scale = 1;
	e.vbfg.classname = "mace_submodel";
	//e.vbfg.colormod = '0.89 0.54 0.89'; 
	setmodel(e.vbfg, "models/weapons/mace/v_mace.md3");
	setattachment(e.vbfg, vweapn, "tag_mace");
	e.vbfg.glowmod = '0.1 0.1 0.1';
	e.vbfg.think = v_bfg_mace_think;
	e.vbfg.nextthink = time;
};

void(entity e, entity vweapn) spawn_v_bfg_blood = 
{ 
	e.vblood = spawn();
	e.vblood.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
	e.vblood.owner = e;
	setmodel(e.vblood, "models/weapons/mace/v_mace_blood.md3");
	setattachment(e.vblood, vweapn, "tag_mace");
	e.vblood.think = v_bfg_blood_think;
	e.vblood.nextthink = time;
};

void() raise_bfg2 = 
{ 
	if (self.vweaponframe == 47)
		W_SetWeapon();
	self.vweaponframe += 1;
	if (self.vweaponframe >= 13)
	{
		self.vweapon.scale = self.macevweapon_scale;
		self.vweapon.origin_x = self.macevweapon_x;
		self.vweapon.origin_y = self.macevweapon_y;
		self.vweapon.origin_z = self.macevweapon_z;
		self.vweapon.angles = '0 0 0';
		self.think = v_bfg_idle;
		self.execution = 1;
	}
	else
		self.think = raise_bfg2;
	self.nextthink = time + 0.025;
};

void() raise_bfg = 
{ 
	self.weapon = IT_MACE;
	W_SetWeapon();
	self.vweaponskin = 0;
	self.vweaponglowmod = '0.01 0.01 0.01';
	playersound7("weapons/melee/select", 2,70);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponstate = 1;
	self.vweaponframe = 9;
	self.attack_finished = time +  0.0125; //0.25;
	spawn_v_bfg_mace(self, self.vweapon);
	spawn_v_bfg_blood(self, self.vweapon);
	self.think = raise_bfg2;
	self.nextthink = time + 0.025;
};

void() pick_up_bfg = 
{ 
	self.weapon = IT_MACE;
	W_SetWeapon();
	self.vweaponskin = 0;
	self.vweaponglowmod = '0.01 0.01 0.01';
	sound(self, CHAN_WEAPON, "weapons/mace/inspect.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponframe = 19;
	self.attack_finished = time + 0.05;
	if (self.noltime < time)
		self.lspeedtime = time + 3.95;
	spawn_v_bfg_mace2(self, self.vweapon);
	spawn_v_bfg_blood(self, self.vweapon);
	self.think = v_bfg_idle;
	self.pick_bfg = 1;
	self.nextthink = time + 3.95;
};

void() Tbfg_touch = 
{ 
	if (other.classname != "player")
		return;
	if (other.items &IT_MACE)
		return;
	other.time_pickupweapon = time + 0.75;

	stuffcmd(other, "impulse 101\n");
	remove(self);
};

void() trigger_bfg = 
{ 
	self.solid = SOLID_TRIGGER;
	self.alpha = -1;
	setmodel(self, self.model);
	self.touch = Tbfg_touch;

};

///////////////////////////////////end of qc file
