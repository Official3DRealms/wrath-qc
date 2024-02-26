//============================================================================
float EASEUNDERCURRENT = 16;

.float water_movflag;
void() CheckFuncWaterDeath = {};

.float height_water1;
.float height_water2;
.float height_water3;
.float oldwatertype;
.vector pos3;
.vector pos4;
.vector pos5;
.float height_water;
.float acidtouch;

void() func_water_use = 
{ 

	if(self.height_water1)
	{
		if((self.height_water3)&& (self.height_water == 2))
		{
			SUB_CalcMove(self.pos5, self.speed, SUB_Null);
			self.height_water = 3;
		}
		if((self.height_water2)&& (self.height_water == 1))
		{
			SUB_CalcMove(self.pos4, self.speed, SUB_Null);
			self.height_water = 2;
		}
		if((!self.height_water))
		{
			SUB_CalcMove(self.pos3, self.speed, SUB_Null);
			self.height_water = 1;
		}
	}
	else
	{	
		if (self.water_movflag == 1)
		{
			SUB_CalcMove(self.pos1, self.speed, SUB_Null);
			self.water_movflag = 0;
		}
		else
		{
			SUB_CalcMove(self.pos2, self.speed, SUB_Null);
			self.water_movflag = 1;
		}
	}
};

//============================================================================
.float deep;
.float vcshifttime;

.entity pool;
float burning_gibs;
void() firespawner_think =
{
	if(self.owner.colormod_x > 0.2)
	{
		self.owner.colormod_x -= 0.02;
		self.owner.colormod_y -= 0.02;
		self.owner.colormod_z -= 0.02;
	} 

	if(!(self.originoffset))
		self.originoffset = self.origin;
	self.owner.velocity_x = self.owner.velocity_x * 0.9;
	self.owner.velocity_y = self.owner.velocity_y * 0.9;

	self.owner.avelocity_x = self.owner.avelocity_x * 0.75;
	self.owner.avelocity_y = self.owner.avelocity_y * 0.75;
	self.owner.avelocity_z = self.owner.avelocity_z * 0.75;



	vector offsetorg =  self.owner.origin;


	if(self.owner.origin_z > self.pool.absmax_z) 
		offsetorg_z = self.pool.absmax_z;

	if(self.owner.origin_z < self.pool.absmin_z)
		offsetorg_z = self.pool.absmax_z;
			
	if(self.owner.health <= 0)
		self.angles = '0 0 0';


	self.originoffset = offsetorg + self.angles;

	if (boxesoverlap(self.pool.absmin, self.pool.absmax, self.originoffset, self.originoffset))
		setorigin (self,self.originoffset);



	if((self.owner.burnable == 2) && (random() < 0.1))
		pointparticles(particleeffectnum("lava_splash"), self.origin + randomvector(self.owner.mins,self.owner.maxs), '0 0 0', 1);
	if(self.lifetime < time)
	{	
		sound7 (self, CHAN_VOICE, "misc/null.wav", 0, 0.5,random(110,150),0);
		self.think = SUB_Remove;
		burning_gibs --;
	}
	else
		self.think = firespawner_think;

	self.nextthink = time + 0.1;
};

void() fireentity_think =
{
	//remove(self);

	if(!(self.originoffset))
		self.originoffset = self.origin;
	vector offsetorg =  self.owner.origin;

	if(self.owner.origin_z > self.pool.absmax_z) 
		offsetorg_z = self.pool.absmax_z;

	if(self.owner.origin_z < self.pool.absmin_z)
		offsetorg_z = self.pool.absmax_z;
			
	if(self.owner.health <= 0)
		self.angles = '0 0 0';

	self.originoffset = offsetorg + self.angles;

	if (boxesoverlap(self.pool.absmin, self.pool.absmax, self.originoffset, self.originoffset))
		setorigin (self,self.originoffset);

	if(self.lifetime < time)
	{	
		sound7 (self, CHAN_VOICE, "misc/null.wav", 0, 0.5,100,0);
		self.think = SUB_Remove;
	}
	else
		self.think = fireentity_think;

	self.nextthink = time + 0.1;
};

void() watersplash_spawn =
{
	if(self.count != 1)
		self.alpha += 0.1; 		
	else
		self.alpha -= 0.05; 		

	self.scale += 0.35; 
	if(self.alpha >= 1.25)
		self.count = 1;

	if(self.alpha <= 0)
	{
		self.alpha = -1;
		self.think = SUB_Remove;
	}
	else
		self.think = watersplash_spawn;
	self.nextthink = time + 0.05;	
};


void() liquid_touch = { local float test;
	local float c;

	if((other.classname == "dripper")&&(other.deep != 1))
	{
		other.velocity = '0 0 0';
		vector vorg = other.origin;
		vorg_z = self.absmax_z + 2;


		float fdist = vlen(vorg - other.origin);

		//if(fdist < 12)
		if ((self.fakewatertype == CONTENT_WATER)||(self.fakewatertype == CONTENT_SLIME))
		pointparticles(particleeffectnum("water_splash2"), vorg, '0 0 0', 1);
		if ((self.fakewatertype == CONTENT_BLOOD))
		pointparticles(particleeffectnum("NORMAL_BLOOD"),vorg, '0 0 0', 3);
		if ((self.fakewatertype == CONTENT_LAVA) &&(fdist < 8))
			pointparticles(particleeffectnum("lava_splash_small"), vorg, '0 0 0', 1);
		other.classname = "dripper_used";
		other.think = SUB_Remove;
		other.nextthink = time + 0.05;
        return;
	}

	if((other.wrathflags & FL_PROJECTILE) && (other.origin_z < other.owner.origin_z) && (other.owner.waterlevel < 1.5))
	{


		if((other.deep != 1) && (other.origin_z <= self.absmax_z))
		{
			vorg = other.origin;
			vorg_z = self.absmax_z - 2;
			if((self.fakewatertype == CONTENT_WATER)||(self.fakewatertype == CONTENT_SLIME))
				pointparticles(particleeffectnum("water_splash2"), vorg, '0 0 0', 1);
			float fdist = vlen(vorg - other.origin);

			if ((self.fakewatertype == CONTENT_BLOOD))
				pointparticles(particleeffectnum("NORMAL_BLOOD"),vorg, '0 0 0', 1);
			if ((self.fakewatertype == CONTENT_LAVA) &&(fdist < 8))
				pointparticles(particleeffectnum("lava_splash_small"), vorg, '0 0 0', 1);



			other.deep = 1;
			vector dir = normalize (other.velocity);
			if((other.classname == "ore") || (other.classname == "ore2"))
			{
				float partcount;
				if(other.classname == "ore")
					partcount = 1;
				else
					partcount = 2;

				if((self.fakewatertype == CONTENT_WATER)||(self.fakewatertype == CONTENT_SLIME))
				{
					pointparticles(particleeffectnum("water_splash3"), vorg, '0 0 0', partcount);
					pointparticles(particleeffectnum("water_steam"), vorg + (dir * 32), '0 0 0', partcount);
				}
		float fdist = vlen(vorg - other.origin);

				if ((self.fakewatertype == CONTENT_BLOOD))
				pointparticles(particleeffectnum("NORMAL_BLOOD"),vorg, '0 0 0', 3);
				if ((self.fakewatertype == CONTENT_LAVA) &&(fdist < 8))
					pointparticles(particleeffectnum("lava_splash_small"), vorg, '0 0 0', 2);


				if(partcount == 2)
					sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", 1, 0.25,100,0);
				else				
					sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", 0.75, 0.25,125,0);
			}

		}
	}

	if((other.flags & FL_MONSTER) && (other.wrathflags & FL_SWIMMER))
	{
		if(other.pool != self)
			other.pool = self;
	}
	if((other.burnable == 1) && (self.fakewatertype == CONTENT_LAVA))
	{
		other.modelflags = 0;
		other.traileffectnum = particleeffectnum("null");
		vector rcap;
		rcap_z =random(other.mins_z, 0); 
		entity firespawner = spawn();
		firespawner.classname = "firespawnera";
		setmodel(firespawner,"");
		setorigin (firespawner,other.origin + rcap);
		firespawner.angles = rcap;
		firespawner.effects = EF_FLAME;
		firespawner.lifetime = time + random(3,7.5);
		firespawner.owner = other;
		firespawner.pool = self;
		firespawner.oldtargetname = other.classname;
		other.colormod = '1 1 1';
		other.nextthink = firespawner.lifetime;
		if(other.lavatime < time)
			firespawner.nextthink = time;
		else
			firespawner.nextthink = time + random();
		other.burnable = 2;
		other.alpha = 0;
		other.think = alphafade2;
		firespawner.think = firespawner_think;
		return;
	}
if ((other.flags & FL_MONSTER) && (other.health > 0) && (self.fakewatertype == CONTENT_SLIME) &&(other.acidtouch < time)&& (other.classname !=  "monster_afflicted")&& (other.classname !=  "monster_stricken"))
	{
		other.fakewatertype = self.fakewatertype;
		other.fwatershifttime = time + 0.1;
		other.forcepain = time + 0.25;

		if(other.classname == "monster_symbol")
		{
			symbolrmovement(2,other);
		}
		else
			T_Damage(other, world, world, 100);
		float r = random();
		if(r < 0.7)
			pointparticles(particleeffectnum("acid_splash2"), other.origin - '0 0 12', '0 0 0', 1);
		sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", random(0.25,0.35), 1,random(120,120),0);
		pointparticles(particleeffectnum("acid_splash"), other.origin + randomvector('-16 -16 -16','16 16 16'), '0 0 0', 1);
		other.acidtouch = time + random(0.5,0.75);
	}
	if ((other.flags & FL_MONSTER) && (other.health > 0) && (self.fakewatertype == CONTENT_LAVA) && (other.classname !=  "monster_oppressor"))
	{

		other.fakewatertype = self.fakewatertype;
		other.fwatershifttime = time + 0.1;

		//		

		other.forcepain = time + 0.25;
		if(other.classname == "monster_symbol")
		{
			symbolrmovement(2,other);	
		}
		else
			T_Damage(other, world, world, 750);

		pointparticles(particleeffectnum("lava_splash"), other.origin + randomvector('-16 -16 -16','16 16 16'), '0 0 0', 1);

		float r = random();
		rcap_z =12 + random(other.maxs_z * 0.7, other.maxs_z); 
		if((r < 0.7) && (other.liquidtouch_timing < time))
		{
			entity firespawner = spawn();
			firespawner.classname = "firespawnerb";
			setmodel(firespawner,"");
			firespawner.angles = rcap;
			setorigin (firespawner,other.origin + randomvector('-12 -12 -12','12 12 12') + rcap);
			if(other.lavatime < time)
				firespawner.effects = EF_FLAME;
			else	
				firespawner.effects = EF_STARDUST;

			firespawner.lifetime = time + random(10,15);
			firespawner.owner = other;
			firespawner.pool = self;
			firespawner.oldtargetname = other.classname;

			if(other.lavatime < time)
				firespawner.nextthink = time;
			else
				firespawner.nextthink = time + random();
			//other.velocity 
			firespawner.think = firespawner_think;
			sound7 (firespawner, CHAN_VOICE, "fx/fire1.ogg", 0.75, 0.5,random(100,125),0);
			sound7 (firespawner, CHAN_AUTO, "env/liquids/lava_splash.ogg", 0.35, 0.5,random(50,100),0);
			other.lavatime = time + 0.1;
		}

		other.liquidtouch_timing = time + random(0.1,0.3);
		if(time > other.firetime)
		{
			
			entity firespawner = spawn();
			firespawner.classname = "fireentity";
			setmodel(firespawner,"");
			setorigin (firespawner,other.origin + rcap);
			firespawner.angles = rcap;
			firespawner.effects = EF_FLAME + EF_NODEPTHTEST;
			firespawner.lifetime = time + random(7,10) ;
			other.firetime = firespawner.lifetime;
			firespawner.owner = other;
			firespawner.pool = self;

			firespawner.nextthink = time;
			firespawner.think = fireentity_think;
			firespawner.owner = other;
			sound7 (firespawner, CHAN_VOICE, "fx/fire1.ogg", 0.75, 0.5,random(100,125),0);
		}

	}
	if((other.flags & FL_MONSTER)|| (self.classentity == "waterchecker") || (self.classentity == "corpse"))
	{
		test = other.origin_z - other.maxs_z;
		if(test <= self.absmax_z)
		other.funcwaterlevel = 1;

		test = other.origin_z + other.maxs_z;
		if(test <= self.absmax_z)
		other.funcwaterlevel = 2;

		test = other.origin_z + other.maxs_z + 8;	
		if(test <= self.absmax_z)
		other.funcwaterlevel = 3;

		other.liquidtouch_timing = time + 0.5;
		return;
	}
	if((other.classname != "player"))
	{
		if(((other.wrathflags & FL_GIB) || (other.wrathflags & FL_SPLASH)) )
		{

			if(other.classname == "func_door")
			//if(!(other.gibsize))
			{
				vector realsize;
				realsize_x = other.absmax_x - other.absmin_x; 
				realsize_y = other.absmax_y - other.absmin_y;
				realsize_z = other.absmax_z - other.absmin_z;
				other.gibsize = floor((realsize_x * realsize_y * realsize_z)/100);
				//remove(other);
			}

		    other.time_toalpha = 0;
		    if((other.velocity_z != -5)&&(other.classname != "watergib") && (self.fakewatertype != CONTENT_LAVA)) 
		    {
		        other.velocity_y = other.velocity_y * 0.25;
		        other.velocity_x = other.velocity_x * 0.25;
				if(other.nofloating >= 1)
				    other.velocity_z = other.velocity_z * random(0.95,0.99);
				else
				    other.velocity_z = 0;
		    }



		    other.liquidtouch_timing = time + 0.1;
		    other.glowmod = '0 0 0';
			if((other.deep != 1))
			{
				float r = random();
				vorg = other.origin;
				if(other.classname == "func_door")
				vorg = (self.absmin + self.absmax) / 2;
				vorg_z = self.absmax_z + 2;
				float size_splash;
				if(other.gibsize >= 512)
					size_splash = 4;
				if(other.gibsize < 512)
					size_splash = 3;
				if(other.gibsize < 256)
					size_splash = 2;
				if(other.gibsize < 128)
					size_splash = 1;
				if((self.fakewatertype == CONTENT_SLIME) && (other.acidtouch < time))
				{
					if(!(other.wrathflags & FL_ACIDSPLASH))
					{
						other.wrathflags += FL_ACIDSPLASH;
						other.think = alphafade;
						other.nextthink = random(1,2);
						//sound7 (other, CHAN_AUTO, "env/liquids/bubble_loop3.ogg", random(0.85,1), 1,random(150,200),0);
						pointparticles(particleeffectnum("acid_splash"), vorg, '0 0 0', 1);					
						pointparticles(particleeffectnum("retcheraoebig2"), other.origin - '0 0 12', '0 0 0', 1);
					} 
					pointparticles(particleeffectnum("acid_boil"), vorg, '0 0 0', 1);					
					other.acidtouch = time + random(0.5,0.75);
					sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", random(0.85,1), 1,random(90,120),0);
				}
                if((self.fakewatertype == CONTENT_SLIME)|| (self.fakewatertype == CONTENT_WATER)  )
				{
					if (self.gibpush < time)
					{
						if(size_splash == 1)
							pointparticles(particleeffectnum("water_splash2"), vorg, '0 0 0', 1);
						if(size_splash == 2)
							pointparticles(particleeffectnum("water_splash4"), vorg, '0 0 0', 1);
						if(size_splash == 3)
							pointparticles(particleeffectnum("water_splash5"), vorg, '0 0 0', 1);
						if(size_splash == 4)
						{
							pointparticles(particleeffectnum("water_splash6"), vorg, '0 0 0', 1);
							entity watersplash = spawn();
							watersplash.origin = vorg + '0 0 2';
							setmodel(watersplash,"models/meshes/liquids/waterfall_base.md3");
							watersplash.think = watersplash_spawn;
							watersplash.scale = 0.5;
							watersplash.alpha = 0.1;
							watersplash.nextthink = time;
						}
						entity traileffectspawner = spawn();
						setmodel(traileffectspawner,"models/misc/null.md3");
						traileffectspawner.origin = other.origin;
						traileffectspawner.movetype = MOVETYPE_FOLLOW;
						traileffectspawner.solid = SOLID_NOT;
						
						traileffectspawner.traileffectnum = particleeffectnum("bubbletrail");
						if(size_splash >= 3)
							traileffectspawner.traileffectnum = particleeffectnum("bubbletrail2");
						traileffectspawner.effects = EF_FULLBRIGHT;
						traileffectspawner.aiment = other; 
						traileffectspawner.think = SUB_Remove;
						traileffectspawner.nextthink = time + random(2,5);

						float spitch;
						if(size_splash == 1)
		                {
							spitch = random (1.05,1.25) * 100;
							sound7 (other, CHAN_AUTO, "env/liquids/water_splash1.ogg", 0.4,0.75,spitch,0);
							sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", 0.3, 0.75,spitch + 20,0);
		                }

						if(size_splash == 2)
		                {
							spitch = random (0.95,1.05) * 100;
							sound7 (other, CHAN_AUTO, "env/liquids/water_splash2.ogg", 0.5, 0.5,spitch,0);
							sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", 0.4, 0.5,spitch,0);
		                }
						if(size_splash == 3)
		                {
							spitch = random (0.85,0.95) * 100;
							sound7 (other, CHAN_AUTO, "env/liquids/water_splash3.ogg",0.7, 0.35,spitch,0);
							sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", 0.6,0.35,spitch - 10,0);
		                }
						if(size_splash >= 4)
		                {
							spitch = random (0.75,0.85) * 100;
							sound7 (other, CHAN_AUTO, "env/liquids/water_splash3.ogg", 0.75, 0.25,spitch,0);
							sound7 (other, CHAN_AUTO, "weapons/cannon/splash.ogg", 0.7, 0.25,spitch - 20,0);
							self.gibpush = time + 0.7;
		                }
					}
					else
						pointparticles(particleeffectnum("water_splash2"), vorg, '0 0 0', 1);
				}
                if((self.fakewatertype == CONTENT_LAVA) )
                {
					if(burning_gibs < 32)
					{
						other.touch = SUB_Null;

						if(other.lavatime < time)
						{
				            other.velocity_z = random(-7,-3);
				            other.velocity_y = other.velocity_y * 0.125;
				            other.velocity_x = other.velocity_x * 0.125;
							other.movetype = MOVETYPE_FLY;
						}
						else
						{
							other.velocity_z = other.velocity_z * 0.25;
				            other.velocity_y = other.velocity_y * 0.75;
				            other.velocity_x = other.velocity_x * 0.75;
							other.movetype = MOVETYPE_WALK;
							other.gravity = 0.35;
						}

						if(r < 0.7)
							pointparticles(particleeffectnum("lava_splash"), vorg, '0 0 0', 1);
						firespawner = spawn();
						other.modelflags = 0;
						other.traileffectnum = particleeffectnum("null");

						vector offsetorg = other.origin;
						if(other.origin_z + 8 > self.absmax_z)
						offsetorg_z = self.absmax_z;
			
						firespawner.classname = "firespawnerc";
						setmodel(firespawner,"");
						setorigin (firespawner,offsetorg);
						if(other.lavatime < time)
							firespawner.effects = EF_FLAME;
						else	
							firespawner.effects = EF_STARDUST;

						firespawner.lifetime = time + random(10,15);
						firespawner.owner = other;
						other.colormod = '1 1 1';
						other.nextthink = firespawner.lifetime;
						firespawner.pool = self;
						firespawner.oldtargetname = other.classname;
						other.think = alphafade;
						firespawner.think = firespawner_think;
						if(other.lavatime < time)
							firespawner.nextthink = time;
						else
							firespawner.nextthink = time + random();

						if(r < 0.5)
						{
							sound7 (firespawner, CHAN_VOICE, "fx/fire1.ogg", 0.75, 0.5,random(100,125),0);
							sound7 (firespawner, CHAN_AUTO, "env/liquids/lava_splash.ogg", 0.35, 0.5,random(50,100),0);
						}
						burning_gibs ++;
					}
                }
				other.deep = 1;
			}

		    return;
		}



		if(time < other.liquidtouch_timing )	
			return;
			
		if (other.classname == "decal")
			remove(other);

		if (other.health <= 0)
			return;



		if (!(other.flags &FL_CLIENT))
			return;
	}	
	if((other.classname == "player"))
	{
		other.extradmg = self.extradmg;
		other.watertype_time = time + 0.05;
		test = other.origin_z + other.mins_z + 1;
		if ((test <= self.absmax_z && test >= self.absmin_z) || (other.zerogtime > time))
		{
			other.fakewatertype = self.fakewatertype;
			other.waterlevel = 1;
			other.oldwatertype = self.fakewatertype;

			test = other.origin_z + (other.mins_z + other.maxs_z) *0.5;
			if (test <= self.absmax_z)
			{
				other.waterlevel = 2;
				other.zerogtime = time + 0.05;	// remove gravity in PreThink
			}

			test = other.origin_z + other.view_ofs_z;
			if ((test <= self.absmax_z) || (self.deep == 1))
			{
				other.waterlevel = 3;


				if ((time > other.vcshifttime)) // && (time > other.flaskrage_time)&& (time > other.wrath_time))
				{
				stuffcmd(other, "v_cshift ");
				stuffcmd(other, self.cshift);
				stuffcmd(other, "\n");
				}	

				other.fwatershifttime = time + frametime;
				other.fwatershift = TRUE;
			}

			// Add drag and/or current
			if (self.spawnflags & EASEUNDERCURRENT) 
				c = 4 - other.waterlevel;
			else 
				c = other.waterlevel;
			if (self.drag) 
				other.velocity = other.velocity + self.velocity *(self.drag *frametime) *c;
			if (self.mangle != '0 0 0') 
				other.velocity = other.velocity + self.mangle *frametime *(c / 3);
		}
	}
	
};


void(vector org, string noise, float vol, float attn) ambientsound2 =
{

/*local entity sor;
sor = spawn();
setmodel (sor, "erwr");
sor. origin = org;*/
ambientsound(org, noise, vol, attn);

};

void(entity e) spawn_lava_sounds = 
{
	self.noise = "env/liquids/lava_loop.ogg";
	self.volume = 1;
	precache_sound (self.noise);

	float x_res = self.absmax_x - self.absmin_x;
	float y_res = self.absmax_y - self.absmin_y;

	vector center = (self.absmax + self.absmin) / 2;  
	float attn = 256 / ((y_res + x_res) / 3);
	ambientsound2(center, self.noise, self.volume, attn);

	vector center_xa = center; center_xa_x +=  (x_res) / 3;
	attn = 256 / ((x_res) / 4);
	ambientsound2(center_xa, self.noise, self.volume, attn);

	vector center_xb = center; center_xb_x -=  (x_res) / 3;
	attn = 256 / ((x_res) / 4);
	ambientsound2(center_xb, self.noise, self.volume, attn);

	vector center_ya = center; center_ya_y +=  (y_res) / 3;
	attn = 256 / ((y_res) / 4);
	ambientsound2(center_ya, self.noise, self.volume, attn);

	vector center_yb = center; center_yb_y -=  (y_res) / 3;
	attn = 256 / ((y_res) / 4);
	ambientsound2(center_yb, self.noise, self.volume, attn);

};

void() func_water = 
{ 
	if (self.noise != string_null)
		precache_sound(self.noise);
	if (self.noise1 != string_null)
		precache_sound(self.noise1);
	if (self.noise2 != string_null)
		precache_sound(self.noise2);
		
	precache_sound("env/liquids/water_splash1.ogg");
	precache_sound("env/liquids/water_splash2.ogg");
	precache_sound("env/liquids/water_splash3.ogg");

	if(!self.watertype)	
		self.watertype = -3;
	
	self.clipgroup = 2;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.rel_origin = self.origin;
	self.touch = liquid_touch;

	if ((self.watertype < CONTENT_LAVA || self.watertype > CONTENT_WATER) && self.watertype != CONTENT_BLOOD)
		self.watertype = CONTENT_WATER;


	self.fakewatertype = self.watertype;
	if (self.fakewatertype == CONTENT_WATER)
		self.dphitcontentsmask = DPCONTENTS_WATER;
	if (self.fakewatertype == CONTENT_SLIME)
		self.dphitcontentsmask = DPCONTENTS_SLIME;
	if (self.fakewatertype == CONTENT_LAVA)
		self.dphitcontentsmask = DPCONTENTS_LAVA; 
	if (self.cshift == string_null)
	{
		if (self.fakewatertype == CONTENT_WATER)
		{
			self.cshift = "130 80 50 128";
		}
		else if (self.fakewatertype == CONTENT_SLIME)
			self.cshift = "0 25 5 150";
		else if (self.fakewatertype == CONTENT_LAVA)
			self.cshift = "255 85 0 150";
	}


	if(self.fakewatertype == CONTENT_WATER)
	{
		if(self.cshift == "64 0 0 128") 
		 self.fakewatertype = CONTENT_BLOOD;
		if(self.cshift == "40 8 0 200") 
		 self.fakewatertype = CONTENT_BLOOD;
		if(self.cshift == "40 0 0 200") 
		 self.fakewatertype = CONTENT_BLOOD;
		//if(self.cshift == "130 80 50 128") 
		 ///self.fakewatertype = CONTENT_BLOOD;
		if(self.cshift == "255 80 0 150") 
		self.fakewatertype = CONTENT_BLOOD;
	}
	if (self.targetname)
		self.movetype = MOVETYPE_PUSH;

	SetMovedir();
	if (!self.lip)
		self.lip = 8;
	if (!self.speed)
		self.speed = 100;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);

	if (self.spawnflags &1)
	{
		// start moved
		setorigin(self, self.pos2);
		self.water_movflag = 1;
	}

	if(self.height_water1)
		self.pos3 = self.pos1 + self.movedir *(self.height_water1);
	if(self.height_water2)
		self.pos4 = self.pos1 + self.movedir *(self.height_water2);
	if(self.height_water3)
		self.pos5 = self.pos1 + self.movedir *(self.height_water3);
	self.use = func_water_use;

	// Cap drag force
	if (self.drag > 100) self.drag = 100;
	if (self.drag < 0) self.drag = 0;

	if (self.mangle != '0 0 0')
		self.mangle = self.mangle * 50;


	if ((self.fakewatertype == CONTENT_SLIME) || (self.fakewatertype == CONTENT_LAVA))
	{
		entity touchtrigger = spawn();
		touchtrigger.owner = self;
		touchtrigger.nextthink = time + random();
		touchtrigger.think = touchtriggers_think;
	}

};
///////////////////////////
