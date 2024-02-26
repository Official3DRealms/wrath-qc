.float fcolor;
.float fcolor;

.vector lastplace_spoted;
.float density;
void() lightning_think;
float(entity targ) visibleworld = 
{
	local vector spot1, spot2;
	if(!targ)
		return FALSE;
	spot1 = self.origin;

	if(checkpvs(spot1, targ) != 1)
		return FALSE;

	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 3, world);

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};
void() weather_think = { if (self.using == 1)
	{
		if (self.type == 1)
			te_particlesnow(self.absmin, self.absmax, self.dest, self.count, self.fcolor);
		else
			te_particlerain(self.absmin, self.absmax, self.dest, self.count, self.fcolor);
	}

	self.nextthink = time + self.delay;
};

void() func_weather = { if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0.1;
	if ((self.type == 1) && (!(self.dest)))
		self.dest = '0 0 -100';
	if ((self.type != 1) && (!(self.dest)))
		self.dest = '0 0 -700';
	if (!self.fcolor)
		self.fcolor = 12;
	if (!self.density)
		self.density = 1;
	setmodel(self, self.model);
	if (!self.count)
		self.count = ((self.absmax_x - self.absmin_x) *(self.absmax_y - self.absmin_y) / 32768) *self.density;
	self.model = "";
	self.use = toggle_use;
	self.think = weather_think;
	self.nextthink = time + 0.1;
};

.float randomdelay;
void() pspawner_think = { 


	if ((self.owner.using == 1) && (self.lifetime < time) && (visibleworld(single_player)))
	{

		float dist = vlen(self.origin - single_player.origin);
		if (dist < self.clipdist)
		{
			pointparticles(particleeffectnum(self.particlename), self.origin, '0 0 0', 1);
			self.lifetime = time + (self.owner.delay) + random(0,self.owner.randomdelay) + 0.1;
		}
	}
	self.nextthink = time + 0.05;
	self.think = pspawner_think;
};


void(entity powner) spawn_particle_emitter = { local entity pspawner;
	pspawner = spawn();
	pspawner.classname = "particlespawner"; 
	pspawner.owner = powner;
	pspawner.origin_x = self.absmin_x + (random() *powner.size_x);
	pspawner.origin_y = self.absmin_y + (random() *powner.size_y);
	if (self.spawnflags == 1)
		pspawner.origin_z = self.absmin_z + (powner.size_z);
	else
		pspawner.origin_z = self.absmin_z + (random() *powner.size_z);
	setmodel(pspawner, "");
	setsize (pspawner,'0 0 0','0 0 0');
	pspawner.clipdist = pspawner.owner.clipdist;
	pspawner.particlename = pspawner.owner.particlename;
	pspawner.think = pspawner_think;
	pspawner.nextthink = time + random();
};



void() func_particles_think = 
{ 
	while (self.count > 0)
	{
		spawn_particle_emitter(self);
		self.count -= 1;
	}
	//if(!self.targetname)
	//	remove(self);
};

void() func_particles = { if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0.5;
	if (!self.wait)
		self.wait = 0.5;
	if (!self.particlename)
		self.particlename = "proj_heretic_impact";
	setmodel(self, self.model);
	if (!self.density)
		self.density = 1;
	if(!self.count)
	self.count = ((self.absmax_x - self.absmin_x) *(self.absmax_y - self.absmin_y) / 4096) *self.density;
	self.oldcount = self.count;

	if(self.count < 1)
		self.count = 1;

	self.use = toggle_use;

	if(!self.clipdist)
		self.clipdist = 1024;

		self.model = "";		
		self.think = func_particles_think;
	self.nextthink = time + 0.1;
};
void() pspawner_think2 = { 



	if (self.lifetime < time)
	{
		float dist = vlen(self.origin - single_player.origin);

		if ((self.using == 1) && (dist < self.clipdist))
			pointparticles(particleeffectnum(self.particlename), self.origin, '0 0 0', self.count);

		if ((self.minpitch && self.maxpitch) && (self.noise))
		{
		
			if (self.minpitch && self.maxpitch)
				float spitch = (self.minpitch + self.maxpitch* random()) *100;
			sound7(self, CHAN_VOICE, self.noise, self.volume, self.atten, spitch, 0);
		}

		if(self.cnt >= 1)
		{
			self.cnt --;
			if(self.cnt == 1)
			{
				self.nextthink = time;
				self.think = SUB_Remove;
				return;
			}
			else
			{
				self.lifetime = time + self.wait * random(0.5,1);
				self.think = pspawner_think2;
				self.nextthink = time + 0.05;	
				return;
			}
		}
		
		if(self.wait != -1)
		{
			self.lifetime = time + (self.delay * random()) + self.wait;
			self.think = pspawner_think2;
			self.nextthink = time + 0.05;
		}

	}
	else
	{
		self.think = pspawner_think2;
		self.nextthink = time + 0.05;
	}
};

void() pspawner_use =
{
	self.think = pspawner_think2;
	self.nextthink = time + self.delay;
};

void() info_particles = { if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0;
	if (!self.count)
		self.count = 1;
	if (!self.wait)
		self.wait = 0.5;
	if (!self.particlename)
		self.particlename = "lavapoint";
	setmodel(self, "models/misc/null.md3");
	

	if(!self.clipdist)
		self.clipdist = 2048;

	if(self.noise)
	{
		local float attn;
		if (!self.volume)
			self.volume = 1;
		if (!self.rad_sound)
			self.rad_sound = 512;
		attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
		if (self.rad_sound <= 0)
			attn = 0;
		if (self.spawnflags &1)
			attn = 0;
		if (self.minpitch <= 0)
			self.minpitch = 0.1;
		if(self.maxpitch < self.minpitch) 
			self.maxpitch = self.minpitch * 2;
			
		self.atten = attn;
	}
	

	if(self.cnt >= 1)
	{
		if (self.targetname)
			self.use = pspawner_use;
		else
		{
			self.think = pspawner_think2;
			self.nextthink = time + self.delay;
		}

		return;
	}

	if((self.wait == -1) )
	{
		if (self.targetname)
			self.use = pspawner_use;
		else
		{
			self.think = pspawner_think2;
			self.nextthink = time + self.delay;
		}
	}
	else
	{
		self.use = toggle_use;
		self.think = pspawner_think2;
		self.nextthink = time + self.wait + self.delay;
	}
};

void() point_particles = { if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0.5;
	if (!self.count)
		self.count = 1;
	if (!self.wait)
		self.wait = 0.5;
	if (!self.particlename)
		self.particlename = "lavapoint";
	setmodel(self, "models/misc/null.md3");
	self.use = toggle_use;
	if(!self.clipdist)
		self.clipdist = 2048;
	if(self.noise)
	{
		local float attn;
		if (!self.volume)
			self.volume = 1;
		if (!self.rad_sound)
			self.rad_sound = 512;
		attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
		if (self.rad_sound <= 0)
			attn = 0;
		if (self.spawnflags &1)
			attn = 0;
		if (self.minpitch <= 0)
			self.minpitch = 0.1;
		if(self.maxpitch < self.minpitch) 
			self.maxpitch = self.minpitch * 2;
			
		self.atten = attn;
	}
	
	if((self.wait == -1) )
	{
		if (self.targetname)
		self.use = pspawner_think2;
	}
	else
	{
		self.think = pspawner_think2;
		self.nextthink = time + self.wait;
	}
};


void() lightninwait = { if (self.style == 12)
		lightstyle(12, "a");
	if (self.style == 13)
		lightstyle(13, "a");
	if (self.style == 14)
		lightstyle(14, "a");
	self.think = lightning_think;
	self.nextthink = time + self.delay + self.wait* random();
};

void() lightning_think = { local float rn, rls;
	local string tnoise;
	rls = random();
	if (rls < 0.33333)
		tnoise = self.noise;
	else if (rls < 0.66666)
		tnoise = self.noise1;
	else
		tnoise = self.noise2;
	rn = random();
	if (self.style == 12)
	{
		if (rn < 0.33333)
			lightstyle(12, "zzzzxxyzxktcxvcxjddbbccaaaaaaaaaaa");
		else if (rn < 0.66666)
			lightstyle(12, "zzxzzxaxxafgfgddxvcxjdkilaaaaaaaaaa");
		else
			lightstyle(12, "zzxxcybvbxbzxcyvnbbbccaaaaaaaaaaa");
		pointsound(self.origin, tnoise, 1, 0.001);
	}

	if (self.style == 13)
	{
		if (rn < 0.33333)
			lightstyle(13, "zkcxzvczxcnmncxvcxjddbbccaaaaaaaaa");
		else if (rn < 0.66666)
			lightstyle(13, "zzxzzxmxcxzkillpbbccaaaaaaaa");
		else
			lightstyle(13, "zzxxcgfasdawcnbbjsdddbbccaaaaa");
		pointsound(self.origin, tnoise, 1, 0.001);
	}

	if (self.style == 13)
	{
		if (rn < 0.33333)
			lightstyle(14, "zktcvxzczccxzvvgncxvcxjddbbccaaaaaaaa");
		else if (rn < 0.66666)
			lightstyle(14, "zzxzxxzzmxcxzfgfgddddbbckillpizxelcaaaaaaaaa");
		else
			lightstyle(14, "zzxxcybvbxbzxcyvnbbjsdddbbccaaaaaaaaaa");
		pointsound(self.origin, tnoise, 1, 0.001);
	}

	self.nextthink = time + 2.5;
	self.think = lightninwait;
};

void() misc_lightning = { if (!self.style)
		self.style = 12;
	if (self.style < 12)
		self.style = 12;
	if (self.style > 14)
		self.style = 14;
	if (!self.delay)
		self.delay = 10;
	if (!self.wait)
		self.wait = 10;
	if (!self.noise)
		self.noise = "env/thunder_clap1.ogg";
	if (!self.noise1)
		self.noise1 = "env/thunder_clap2.ogg";
	if (!self.noise2)
		self.noise2 = "env/thunder_clap3.ogg";
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	if (!(self.targetname))
	{
		self.think = lightning_think;
		self.nextthink = time + self.delay;
	}
	else
		self.use = lightning_think;
};


void() lightningt_think =
{

	if(self.cnt)
	{
		if(self.cnt == 1)
		{
			lightstyle(0, "prsmzoprsmnspwrsprqnsnqn");
			self.nextthink = time + 1;
		}
		else
		{
			lightstyle(0, "zxyzrstzxzywtuvzuvyxzzmnzznzmzznnxz");
			self.nextthink = time +random(1.5,2.5);
		}
		self.cnt --;
		self.think = lightningt_think;
	}
	else
	{
		lightstyle(0, "m");
		self.think = SUB_Null;
		self.nextthink = time;
	}

};
.float lightning_time;
void() trigger_lightning_touch =
{	
	if (other.classname != "player")
	return;
	if(self.using == 0)
	return;
	if ((self.lightning_time < time) && (other.lightning_time < time))
	{	
		if(self.wait != -1)
		self.lightning_time = time + self.wait + (self.delay * random());
		else
		self.using = 0;

		other.lightning_time =  self.lightning_time;
		float rls = rint (random(1,3));
		if (rls == 1)
			string tnoise = self.noise;
		if (rls == 2)
			tnoise = self.noise1;
		if (rls == 3)
			tnoise = self.noise2;
		sound7(self, CHAN_AUTO,tnoise, random(0.75,1), 0.001, random(80,120),0);

		self.cnt = 2;
		self.think = lightningt_think;
		self.nextthink = time;
	}

};
void() trigger_lightning =
{
	if (!self.noise)
		self.noise = "env/amb/thunder1.ogg";
	if (!self.noise1)
		self.noise1 = "env/amb/thunder2.ogg";
	if (!self.noise2)
		self.noise2 = "env/amb/thunder3.ogg";

	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);

	if(!self.delay)
	self.delay = 10;
	if(!self.wait)
	self.wait = 10;

	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
	self.touch = trigger_lightning_touch;
	if(!self.using)
	self.using = 1;
	self.use = toggle_use;
};

.float time_fog;
.float falpha;
.float fade_control;
void() fogmodel_think =
{
	
	if (!self.cnt)
	{
	self.falpha += 0.005 / self.owner.fade_control;
	if(self.falpha >= 1)
	self.cnt = 1;
	}
	else
	{
	self.falpha -= 0.005 / self.owner.fade_control;
	if(self.falpha <= 0)
	remove(self);
	}

if(self.frame == 31)
	self.frame =0;
self.frame ++;

self.alpha = self.falpha * 0.25; 
/*	vector glight;
	glight = getlight (self.origin);
	self.colormod_x = glight_x - 0.05;
	self.colormod_y = glight_y - 0.05;
	self.colormod_z = glight_z - 0.05;
*/	
self.think = fogmodel_think;
self.nextthink = time + 0.025;
/*
if(self.origin_x > self.owner.absmax_x)
{remove(self);}

if(self.origin_x < self.owner.absmin_x)
{remove(self);}

if(self.origin_y > self.owner.absmax_y)
{remove(self);}

if(self.origin_y < self.owner.absmin_y)
{remove(self);}
*/
};
.float minv_z;
.float maxv_z;
void(entity powner) spawnfogemitter =
{
	local entity fogmodel;
	fogmodel = spawn ();
	fogmodel.owner = powner;
	fogmodel.origin_x = self.absmin_x + (random() *powner.size_x);
	fogmodel.origin_y = self.absmin_y + (random() *powner.size_y);
	fogmodel.origin_z = self.absmin_z;
	
	float r = random() * 8;
	
	if (r >= 7)
	setmodel (fogmodel, "particles/smoke_1.md3");
	if (r < 7)
	setmodel (fogmodel, "particles/smoke_2.md3");
	if (r < 6)
	setmodel (fogmodel, "particles/smoke_3.md3");
	if (r < 5)
	setmodel (fogmodel, "particles/smoke_4.md3");
	if (r < 4)
	setmodel (fogmodel, "particles/smoke_5.md3");
	if (r < 3)
	setmodel (fogmodel, "particles/smoke_6.md3");
	if (r < 2)
	setmodel (fogmodel, "particles/smoke_7.md3");
	if (r <= 1)
	setmodel (fogmodel, "particles/smoke_8.md3");
	fogmodel.movetype = MOVETYPE_NOCLIP;
	//fogmodel.effects = EF_ADDITIVE;// + EF_NODEPTHTEST;
	fogmodel.velocity_z = powner.minv_z + random() *(powner.maxv_z - powner.minv_z);
	fogmodel.scale = 0.75 + random() *0.5;
	fogmodel.falpha = random() * 0.1;
	fogmodel.alpha = fogmodel.falpha * 0.25;	
//	fogmodel.time_fog = random() *0.025;
	fogmodel.think = fogmodel_think;
	fogmodel.nextthink = time + 0.1; 
};
void()  func_fog_think;
.float oldcount;
.float spawnrate;

void()  func_fog_reset =
{
self.density = self.oldcount;
self.think = func_fog_think;
self.nextthink = time + (0.35 / self.count);
}

void()  func_fog_think =
{
//while (self.density > -1) 
//{
spawnfogemitter(self);
//self.density -= 1;
//}

self.think = func_fog_think; 
self.nextthink = time + ((random() *0.25) / self.count);
};

void()func_fog =
{
	setmodel(self, self.model);
//	if (!self.density)
//	self.density = 1;
	if(!self.minv_z)
	self.minv_z = 15;
	if(!self.maxv_z)
	self.maxv_z = 30;

	if(!self.fade_control)
	self.fade_control = 1;
	if(!self.count)
	self.count = 1; //((self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/8192) *self.density *0.5;
	self.oldcount = self.density;
	self.solid = SOLID_TRIGGER;
	//self.model = "";		
	self.think = func_fog_think;
	self.nextthink =time + 0.1;
};


//.float count 
//.float gravity



float (float value) fix_alpha =
{
	if(value == 0)
		return = -1;
	else
		return value;
}

void() spawned_model_alphafade =
{
	move_gibs();

	if(self.startnonsolid == 1)
	{
		self.movetype = MOVETYPE_BOUNCE;
		self.startnonsolid = 0;
	}
	if(self.lifetime < time )
	{
		/*
		if (self.falpha < self.owner.valpha_x)
			self.think = SUB_Remove;
		else
			self.think = spawned_model_alphafade;

		self.falpha -= (1 / self.owner.valpha_z) / 20;
		float localalpha = fix_alpha(self.falpha);

		self.alpha = localalpha;
		*/

	//self.alpha = self.owner.valpha_y;
	self.think =alphafade;
	}
	else
	{
		/*self.falpha -= (1 / self.owner.valpha_z) / 20;
		self.velocity_z = self.originalvelocity_z * self.falpha;
		self.velocity_x = self.originalvelocity_y * (1 - self.falpha);
		self.velocity_y = self.originalvelocity_x * (1- self.falpha);*/
		/*self.velocity_x += self.velocitymodifier_x;
		self.velocity_z += self.velocitymodifier_y;
		self.velocity_y += self.velocitymodifier_z;*/
		self.think = spawned_model_alphafade;
	}

	self.nextthink = time + 0.05;

};
void()spawned_model_alphafadein =
{


		self.falpha += (1 / self.owner.valphain_z) / 20;
		float localalpha = fix_alpha(self.falpha);
		self.alpha = localalpha;	
		if (self.falpha < self.owner.valphain_y)
		{
			self.think = spawned_model_alphafadein;
			self.nextthink = time + 0.05;
		}
		else
		{
			self.think = spawned_model_alphafade;
			self.nextthink = time + self.lifetime;
		}

};
.string particlename2;

void(entity powner) spawn_model_emitter =
{
	local entity spawned_model;
	spawned_model = spawn ();
	spawned_model.classname = "spawned_model";
	spawned_model.owner = powner;
	spawned_model.origin_x = spawned_model.owner.origin_x + (crandom() *spawned_model.owner.originjitter_x);
	spawned_model.origin_y = spawned_model.owner.origin_y +  (crandom() *spawned_model.owner.originjitter_y);
	spawned_model.origin_z = spawned_model.owner.origin_z +  (crandom() *spawned_model.owner.originjitter_z);
	
	spawned_model.origin += spawned_model.owner.originoffset;
	
	if(spawned_model.owner.model_ammount > 1)
	{
		float r = random() * spawned_model.owner.model_ammount;
		if (r >= 7)
			setmodel (spawned_model, spawned_model.owner.model8);
		if (r < 7)
			setmodel (spawned_model, spawned_model.owner.model7);
		if (r < 6)
			setmodel (spawned_model, spawned_model.owner.model6);
		if (r < 5)
			setmodel (spawned_model, spawned_model.owner.model5);
		if (r < 4)
			setmodel (spawned_model, spawned_model.owner.model4);
		if (r < 3)
			setmodel (spawned_model, spawned_model.owner.model3);
		if (r < 2)
			setmodel (spawned_model, spawned_model.owner.model2);
		if (r <= 1)
			setmodel (spawned_model, spawned_model.owner.model1);
	}
	else
		setmodel (spawned_model, spawned_model.owner.model1);
	
	if(spawned_model.owner.ammo_shotgun == 40)
		setmodel (spawned_model,"");
	spawned_model.movetype = powner.particle_movetype;
	if(spawned_model.owner.startnonsolid == 1)
		spawned_model.movetype = MOVETYPE_NOCLIP;

	spawned_model.modelflags = spawned_model.owner.particle_modelflags;
	if((spawned_model.owner.particlename) &&(spawned_model.owner.ammo_shotgun != 40))
		spawned_model.traileffectnum = particleeffectnum (spawned_model.owner.particlename);	
	spawned_model.gravity = spawned_model.owner.gravity;
	spawned_model.colormod = spawned_model.owner.colormod;

	spawned_model.velocity += spawned_model.owner.velocityoffset;
	spawned_model.velocity_x += spawned_model.owner.velocityjitter_x * crandom();
	spawned_model.velocity_y += spawned_model.owner.velocityjitter_y * crandom();
	spawned_model.velocity_z += spawned_model.owner.velocityjitter_z * crandom();
	spawned_model.velocity += spawned_model.owner.oldvelocity;

	spawned_model.avelocity += spawned_model.owner.avelocityoffset;
	spawned_model.avelocity_x += spawned_model.owner.avelocityjitter_x * crandom();
	spawned_model.avelocity_y += spawned_model.owner.avelocityjitter_y * crandom();
	spawned_model.avelocity_z += spawned_model.owner.avelocityjitter_z * crandom();
	spawned_model.originalvelocity = spawned_model.velocity;

	if(spawned_model.owner.max_size)
		spawned_model.scale = random(spawned_model.owner.min_size, spawned_model.owner.max_size);
	else
		spawned_model.scale = spawned_model.owner.min_size;

	if(spawned_model.owner.max_time)
		spawned_model.lifetime = random(spawned_model.owner.min_time, spawned_model.owner.max_time);
	else
		spawned_model.lifetime = spawned_model.owner.min_time;
	
	spawned_model.falpha = spawned_model.owner.valpha_y;
	spawned_model.bouncefactor = spawned_model.owner.bouncefactor;
	//spawned_model.bouncestop = 1;
	float localalpha = fix_alpha(spawned_model.falpha);
	spawned_model.alpha = localalpha;
	if(spawned_model.owner.valphain_x)
	{
		spawned_model.falpha = spawned_model.owner.valphain_x;
		localalpha = fix_alpha(spawned_model.falpha);
		spawned_model.alpha = localalpha;
		spawned_model.think = spawned_model_alphafadein;
		spawned_model.nextthink = time  + 0.05; 
	}
	else
	{
		spawned_model.lifetime += time;
		spawned_model.think = spawned_model_alphafade;
		if(spawned_model.owner.startnonsolid == 1)
		{
			float extratime = 0.3;
			spawned_model.startnonsolid = spawned_model.owner.startnonsolid;
			spawned_model.movetype = MOVETYPE_NOCLIP;
			spawned_model.velocity_x = spawned_model.velocity_x * 1.2;
			spawned_model.velocity_y = spawned_model.velocity_y * 1.2;
			spawned_model.velocity_z += spawned_model.gravity * -300;
		}
		spawned_model.nextthink = time + extratime; 
	}


	if((spawned_model.owner.particlename)&&(spawned_model.owner.ammo_shotgun == 40 ))
	{
		spawned_model.effects = EF_NODRAW;
		pointparticles(particleeffectnum(spawned_model.owner.particlename),spawned_model.origin, spawned_model.velocity, 1);
		remove(spawned_model);
	}
	spawned_model.solid = SOLID_NOT;

};

void()model_emitter_think =
{
	float localcount = self.count;

	if((self.model1 == "particles/oppressor/oppressor_fire1_1.md3") && (self.speed >= 64))
	{
		self.count = 1;
		self.ammo_shotgun = 40;
		self.particlename = "e3m3steam";
	}
	vector org = self.origin;

	makevectors (self.angles);

	float dist = vlen(self.origin - single_player.origin);


	self.oldvelocity = v_forward * self.speed;

	if ((self.using == 1) && (dist < self.clipdist)&& checkpvs(single_player.origin + single_player.view_ofs, self))
	{
		while (localcount) 
		{
			//self.effects = EF_MUZZLEFLASH;

			spawn_model_emitter(self);

			localcount --;
		}
	}
	self.nextthink = time + self.delay;

	if(self.loop > 0)
		self.think = model_emitter_think;
	else
		self.think = SUB_Remove;
};

.float rcount;
void() model_emitter_use = 
{ 
	if (self.using == 1)
	{
		self.using = 0;
		//sound(self, CHAN_AUTO, "misc/null.wav", 1, 0.25);
	}
	else
	{
		if(self.rcount >= 1)
		{
			float r = ceil(random(0,self.rcount));
			string snoise;
			if(r == self.jmpsound)
				r ++;
			if(r >self.count)
				r = 1;

			if( r == 1)
				snoise = self.noise1;
			if( r == 2)
				snoise = self.noise2;
			if( r == 3)
				snoise = self.noise3;

			self.jmpsound = r;
			sound(self, CHAN_AUTO, snoise, 1, 0.25);
		}

		self.using = 1;
	}

	self.think = model_emitter_think;
	self.nextthink = time;	
};

void() model_emitter =
{

	if (self.noise1)
		{precache_sound(self.noise1); self.rcount = 1;}
	if (self.noise2)
		{precache_sound(self.noise2); if(self.rcount == 1) self.rcount = 2;}
	if (self.noise3)
		{precache_sound(self.noise3); if(self.rcount == 2) self.rcount = 3;}


	setmodel(self,"models/misc/null.md3");
	if(!self.valpha)
		self.valpha = '0 1 1';
	if(!self.gravity)
		self.gravity = -0.1;
	if(!self.count)
		self.count = 1;	
	if(!self.min_time)
		self.min_time = 0.1;
	if(!self.max_time)
		self.max_time = self.min_time;
	if(!self.min_size)
		self.min_size = 1;
	if(!self.loop)
		self.loop = 1;
	if(!self.clipdist)
		self.clipdist =  512;
	if(!self.max_size)
		self.max_size = self.min_size ;
	if(!self.delay)
		self.delay = 0.5;
	if(!self.bouncefactor)
		self.bouncefactor = 0.3;
	if(!self.model1)
		self.model1 = "models/misc/null.md3";
	self.movetype = 0;	
	if(!self.particle_movetype)
		self.particle_movetype =MOVETYPE_NOCLIP;
	if(self.model1)
		self.model_ammount = 1;
	self.alpha = 0.25;	
	//self.origin += ' 0 0 0';
	precache_model(self.model1);	
	if((self.model2) && (self.model_ammount == 1))
		{self.model_ammount = 2; precache_model(self.model2);}	
	if((self.model3) && (self.model_ammount == 2))
		{self.model_ammount = 3; precache_model(self.model3);}
	if((self.model4) && (self.model_ammount == 3))
		{self.model_ammount = 4; precache_model(self.model4);}
	if((self.model5) && (self.model_ammount == 4))
		{self.model_ammount = 5; precache_model(self.model5);}
	if((self.model6) && (self.model_ammount == 5))
		{self.model_ammount = 6; precache_model(self.model6);}
	if((self.model7) && (self.model_ammount == 6))
		{self.model_ammount = 7; precache_model(self.model7);}
	if((self.model8) && (self.model_ammount == 7))
		{self.model_ammount = 8; precache_model(self.model8);}
	if(!self.using)
		self.using = 1;
	if(!self.speed)
		self.speed = 16;
	if(!self.targetname)
	{	
		self.use = toggle_use;
		self.think = model_emitter_think;
		self.nextthink = time;	
	}
	else
	{	
		self.use = model_emitter_use;
	}
	if((self.spawnflags & 1) || (self.using == 1))
	{
		self.think = model_emitter_think;
		self.nextthink = time;	
	}

};


/*
#define VF_FOG_DENSITY        202 //(float)
#define VF_FOG_COLOR        203 //(vector)
#define VF_FOG_COLOR_R        204 //(float)
#define VF_FOG_COLOR_G        205 //(float)
#define VF_FOG_COLOR_B        206 //(float)
#define VF_FOG_ALPHA        207 //(float)
#define VF_FOG_START        208 //(float)
#define VF_FOG_END           209 //(float)
#define VF_FOG_HEIGHT        210 //(float)
#define VF_FOG_FADEDEPTH    211 //(float)
*/

float timing_fog;


float(float a, float b) always_pos_substract =
{
local float result;
result = max(a, b) - min (a, b);
return result;
};

void()trigger_fog_use;
float SPAWNFLAG_FORCESTART = 2;

void() trigger_fog_think =
{
	self.count ++;
	stuffcmd (single_player,"get_fog\n");
	if(self.count >= self.cnt)
	{
		self.wait = self.oldwait;
		self.nextthink = time + 0.025;
		self.touch = self.oldtouch;
		self.think = SUB_Null;	
		if(self.classname == "fog_restorer")
			remove(self);		
		return;
	} 
	else
	{
		timing_fog = time + 0.1; 
		self.tmp_fog_d += self.r_fog_d;
		self.tmp_fog_r += self.r_fog_r;
		self.tmp_fog_g += self.r_fog_g;
		self.tmp_fog_b += self.r_fog_b;
		self.tmp_fog_a += self.r_fog_a;
		self.tmp_fog_s += self.r_fog_s;
		self.tmp_fog_e += self.r_fog_e;
		self.tmp_fog_h += self.r_fog_h;
		self.tmp_fog_f += self.r_fog_f;
		string strfog_a = strcat ("fog ",ftos(self.tmp_fog_d)," ",ftos(self.tmp_fog_r)," ", ftos(self.tmp_fog_g)," ",ftos(self.tmp_fog_b));
		string strfog_b = strcat (" ",ftos(self.tmp_fog_a)," ",ftos(self.tmp_fog_s)," ", ftos(self.tmp_fog_e)," ", ftos(self.tmp_fog_h));
		string strfog_c = strcat (" ",ftos(self.tmp_fog_f), "\n");

		string strfog = strcat (strfog_a,strfog_b, strfog_c);
		fog_value =strfog;
		stuffcmd (single_player, strfog);
		
		self.think = trigger_fog_think;

	//local string lmessage;
	//lmessage =strcat ((strfog),("\n")) ;
	//bprint (lmessage);
	}

	vector fog_color = stov (cvar_string("_fog_color"));


	if ((self.spawnflags &SPAWNFLAG_FORCESTART))
		self.nextthink = time + 0.0;
	else
		self.nextthink = time + 0.025;
};

void() trigger_fog_prethink =
{
	self.tmp_fog_d = stof(cvar_string ("_fog_d"));
	vector fog_color = stov (cvar_string("_fog_color"));
	self.tmp_fog_r = fog_color_x;
	self.tmp_fog_g = fog_color_y;
	self.tmp_fog_b = fog_color_z;
	self.tmp_fog_a = stof(cvar_string ("_fog_a"));
	self.tmp_fog_s = stof(cvar_string ("_fog_s"));
	self.tmp_fog_e = stof(cvar_string ("_fog_e"));
	self.tmp_fog_h = stof(cvar_string ("_fog_h"));
	self.tmp_fog_f = stof(cvar_string ("_fog_f"));


	local string lmessage;
	lmessage =strcat ((ftos(self.tmp_fog_g)),("\n")) ;
	bprint (lmessage);

	self.cnt = self.wait / 0.025; 

	if(self.ammo_shells == 1)
	{
		self.cnt = 20; 
		self.ammo_shells = 10; 
	}
 	self.count = -1;
	self.r_fog_d = (self.nfogd - self.tmp_fog_d) / (self.cnt);
	self.r_fog_r = (self.nfogr - self.tmp_fog_r) / (self.cnt);
	self.r_fog_g = (self.nfogg - self.tmp_fog_g) / (self.cnt);
	self.r_fog_b = (self.nfogb - self.tmp_fog_b) / (self.cnt);
	self.r_fog_a = (self.nfoga - self.tmp_fog_a) / (self.cnt);
	self.r_fog_s = (self.nfogs - self.tmp_fog_s) / (self.cnt);
	self.r_fog_e = (self.nfoge - self.tmp_fog_e) / (self.cnt);
	self.r_fog_h = (self.nfogh - self.tmp_fog_h) / (self.cnt);
	self.r_fog_f = (self.nfogf - self.tmp_fog_f) / (self.cnt);

	lmessage =strcat ((ftos(self.r_fog_g)),("\n")) ;
	bprint (lmessage);

	self.think = trigger_fog_think;


	if ((self.spawnflags &SPAWNFLAG_FORCESTART))
		self.nextthink = time + 0.0;
	else
		self.nextthink = time +0.025;

	lmessage =strcat (("secomd step"),("\n")) ;
	bprint (lmessage);

};
	

void() trigger_fog_touch =
{
	if (other.classname != "player")
		return;
	if(other.fogtrigger == self)
		return;
	if(timing_fog > time)
		return;
	other.fogtrigger = self;	
	self.enemy = other;
	stuffcmd (single_player,"get_fog\n");
	//stuffcmd (self.enemy,"impulse 99\n");
	self.touch = SUB_Null;

	local string lmessage;
	lmessage =strcat (("first step"),("\n")) ;
	bprint (lmessage);

	self.think = trigger_fog_prethink;
	self.nextthink = time + 0.05;
};	
.float fogwait;

void() trigger_fog_start_prethink =
{

		string strfog_a = strcat ("fog ",ftos(self.nfogd)," ",ftos(self.nfogr)," ", ftos(self.nfogg)," ",ftos(self.nfogb));
		string strfog_b = strcat (" ",ftos(self.nfoga)," ",ftos(self.nfogs)," ", ftos(self.nfoge)," ", ftos(self.nfogh));
		string strfog_c = strcat (" ",ftos(self.nfogf), "\n");

		string strfog = strcat (strfog_a,strfog_b, strfog_c);
		fog_value =strfog;
		stuffcmd (single_player, strfog);
		self.think = trigger_fog_prethink;
		if ((self.spawnflags &SPAWNFLAG_FORCESTART))
			self.nextthink = time + 0.0;
		else
			self.nextthink = time + 0.05;
};
void() trigger_autofog_use =
{

		string strfog_a = strcat ("fog ",ftos(self.nfogd)," ",ftos(self.nfogr)," ", ftos(self.nfogg)," ",ftos(self.nfogb));
		string strfog_b = strcat (" ",ftos(self.nfoga)," ",ftos(self.nfogs)," ", ftos(self.nfoge)," ", ftos(self.nfogh));
		string strfog_c = strcat (" ",ftos(self.nfogf), "\n");

		string strfog = strcat (strfog_a,strfog_b, strfog_c);
		fog_value =strfog;
		stuffcmd (single_player, strfog);
};	

void() trigger_fog_use =
{
	if((single_player.fogtrigger != self))
	{	

		if (self.classname != "fog_restorer")
		single_player.fogtrigger = self;	
		self.enemy = single_player;
		stuffcmd (single_player,"get_fog\n");
		self.touch = SUB_Null;
			self.think = trigger_fog_prethink;
		if ((self.spawnflags &SPAWNFLAG_FORCESTART))
			self.nextthink = time + 0.0;
		else
		self.nextthink = time + 0.05;
	}
};	


void() trigger_fog_use2 =
{
	single_player.fogtrigger = self;	
	self.enemy = single_player;
	stuffcmd (single_player,"get_fog\n");
	self.touch = SUB_Null;
	self.think = trigger_fog_prethink;
	self.nextthink = time + 0.05;
};



void() trigger_fog =
{	
	setmodel(self, self.model);
	self.solid = SOLID_TRIGGER;
	if(!self.wait)
		self.wait = 1;
	if(!self.nfoga)
		self.nfoga = 1;
	if(!self.nfoge)
		self.nfoge = 16384;
	if(!self.nfogh)
		self.nfogh = 1073741824;
	if(!self.nfogf)
		self.nfogf = 128;






	self.modelindex = 0;
	self.model = string_null;
	self.oldwait = self.wait;

	if ((self.spawnflags &SPAWNFLAG_FORCESTART))
	{
		self.fogwait = 2;

	}
	{
		if (!(self.spawnflags &SPAWNFLAG_NOTOUCH))
			self.touch = trigger_fog_touch;

		self.use = trigger_fog_use;
		self.oldtouch = self.touch;
	}
};

void() restart_particle;

void() relocate_particle =
{
	vector new_origin;
	self.effects = EF_LOWPRECISION;


	if(self.owner.model_ammount > 1)
	{
		float r = random() * self.owner.model_ammount;
		if (r >= 7)
			setmodel (self, self.owner.model8);
		if (r < 7)
			setmodel (self, self.owner.model7);
		if (r < 6)
			setmodel (self, self.owner.model6);
		if (r < 5)
			setmodel (self, self.owner.model5);
		if (r < 4)
			setmodel (self, self.owner.model4);
		if (r < 3)
			setmodel (self, self.owner.model3);
		if (r < 2)
			setmodel (self, self.owner.model2);
		if (r <= 1)
			setmodel (self, self.owner.model1);
	}
	else
		setmodel (self, self.owner.model1);
	

	new_origin_x = self.owner.origin_x + (crandom() *self.owner.originjitter_x);
	new_origin_y = self.owner.origin_y +  (crandom() *self.owner.originjitter_y);
	new_origin_z = self.owner.origin_z +  (crandom() *self.owner.originjitter_z);
	setorigin (self, new_origin);
	self.origin += self.owner.originoffset;
	
	
	self.modelflags = self.owner.particle_modelflags;
	self.gravity = self.owner.gravity;
	
	self.velocity = self.owner.velocityoffset;
	self.velocity_x += self.owner.velocityjitter_x * crandom();
	self.velocity_y += self.owner.velocityjitter_y * crandom();
	self.velocity_z += self.owner.velocityjitter_z * crandom();
	
	if(self.owner.max_size)
		self.scale = random(self.owner.min_size, self.owner.max_size);
	else
		self.scale = self.owner.min_size;

	self.think = restart_particle;
	self.nextthink = time + self.lifetime;

};
.float min_delay;
void() restart_particle = 
{
	setmodel(self,"");
	self.effects = EF_NODRAW +EF_LOWPRECISION ;
	self.think = relocate_particle;
	self.nextthink = time + random(self.owner.min_delay, self.owner.delay);
}



void(entity powner) spawn_model_emitter2 =
{
	local entity spawned_model;
	spawned_model = spawn ();
	spawned_model.owner = powner;
	spawned_model.origin_x = spawned_model.owner.origin_x + (crandom() *spawned_model.owner.originjitter_x);
	spawned_model.origin_y = spawned_model.owner.origin_y +  (crandom() *spawned_model.owner.originjitter_y);
	spawned_model.origin_z = spawned_model.owner.origin_z +  (crandom() *spawned_model.owner.originjitter_z);
	
	spawned_model.origin += spawned_model.owner.originoffset;
	//spawned_model.drawonlytoclient = single_player;
	if(spawned_model.owner.model_ammount > 1)
	{
		float r = random() * spawned_model.owner.model_ammount;
		if (r >= 7)
			setmodel (spawned_model, spawned_model.owner.model8);
		if (r < 7)
			setmodel (spawned_model, spawned_model.owner.model7);
		if (r < 6)
			setmodel (spawned_model, spawned_model.owner.model6);
		if (r < 5)
			setmodel (spawned_model, spawned_model.owner.model5);
		if (r < 4)
			setmodel (spawned_model, spawned_model.owner.model4);
		if (r < 3)
			setmodel (spawned_model, spawned_model.owner.model3);
		if (r < 2)
			setmodel (spawned_model, spawned_model.owner.model2);
		if (r <= 1)
			setmodel (spawned_model, spawned_model.owner.model1);
	}
	else
		setmodel (spawned_model, spawned_model.owner.model1);
	
	setsize (spawned_model, '-8 -8 -8', '8 8 8');  
	spawned_model.solid = SOLID_TRIGGER;
	spawned_model.clipgroup = 4;
	spawned_model.movetype = powner.particle_movetype;
	//spawned_model.effects = EF_LOWPRECISION;	
	spawned_model.modelflags = spawned_model.owner.particle_modelflags;
	if(spawned_model.owner.particlename)
	spawned_model.traileffectnum = particleeffectnum (spawned_model.owner.particlename);	
	spawned_model.gravity = spawned_model.owner.gravity;
	
	spawned_model.velocity += spawned_model.owner.velocityoffset;
	spawned_model.velocity_x += spawned_model.owner.velocityjitter_x * crandom();
	spawned_model.velocity_y += spawned_model.owner.velocityjitter_y * crandom();
	spawned_model.velocity_z += spawned_model.owner.velocityjitter_z * crandom();
	
	if(spawned_model.owner.max_size)
		spawned_model.scale = random(spawned_model.owner.min_size, spawned_model.owner.max_size);
	else
		spawned_model.scale = spawned_model.owner.min_size;

	spawned_model.lifetime = spawned_model.owner.lifetime;	

	spawned_model.think = restart_particle;
	spawned_model.nextthink = time + spawned_model.lifetime;

};

void()model_emitter_think2 =
{
	float localcount = self.count;
	if ((self.using == 1) && (self.cnt > 0))
	{
		while (localcount) 
		{
			//self.effects = EF_MUZZLEFLASH;
			spawn_model_emitter2(self);
			localcount --;
		}
	}
		
	if((self.target) && (self.movetype != MOVETYPE_FOLLOW))
	{
		self.owner = find(world,targetname, self.target);	
		self.origin = self.owner.origin;
		self.aiment = self.owner;
		self.view_ofs = self.origin - self.owner.origin; // relative origin
		self.movetype = MOVETYPE_FOLLOW;
	}


	if(self.cnt > 0)
	{
		if (self.using == 1)
			self.cnt --;
		self.think = model_emitter_think2;
		self.nextthink = time + self.delay;
	}	
	else
	{	
		if(self.movetype == MOVETYPE_FOLLOW)
		{
			self.think = model_emitter_think2;
		}
		else
			self.think = SUB_Null;
		self.nextthink = time + 0.025;
	}

};

void() model_emitter2 =
{
	setmodel(self,"models/misc/null.md3");
	if(!self.gravity)
		self.gravity = -0.1;
	if(!self.count)
		self.count = 1;	
	if(!self.lifetime)
		self.lifetime = 0.1;
	if(!self.delay)
		self.delay = 0.5;
	if(!self.model1)
		self.model1 = "models/misc/null.md3";
	self.movetype = 0;	
	if(!self.particle_movetype)
		self.particle_movetype =MOVETYPE_NOCLIP;
	if(self.model1)
		self.model_ammount = 1;
	self.alpha = 0.25;	
	precache_model(self.model1);	
	if((self.model2) && (self.model_ammount == 1))
		{self.model_ammount = 2; precache_model(self.model2);}	
	if((self.model3) && (self.model_ammount == 2))
		{self.model_ammount = 3; precache_model(self.model3);}
	if((self.model4) && (self.model_ammount == 3))
		{self.model_ammount = 4; precache_model(self.model4);}
	if((self.model5) && (self.model_ammount == 4))
		{self.model_ammount = 5; precache_model(self.model5);}
	if((self.model6) && (self.model_ammount == 5))
		{self.model_ammount = 6; precache_model(self.model6);}
	if((self.model7) && (self.model_ammount == 6))
		{self.model_ammount = 7; precache_model(self.model7);}
	if((self.model8) && (self.model_ammount == 7))
		{self.model_ammount = 8; precache_model(self.model8);}
	if(!self.using)
		self.using = 1;

	if(self.min_delay > self.delay)
	self.min_delay = self.delay;

	self.cnt = (self.lifetime / self.delay);

	self.use = toggle_use;
	self.think = model_emitter_think2;
	self.nextthink = time;	

};

void()func_wave_think = 
{
    if(self.cnt == 1)
    {
        self.alpha += 0.0125;
        if(self.alpha > 1.25)
            self.cnt = 0;        
    }
    else
    {
        self.alpha -= 0.025;

        if(self.alpha <= 0.25)
            self.cnt = 1;
    }
    self.think = func_wave_think;
    self.nextthink = time + 0.05;
};

void() func_wave =
{
    setmodel(self,self.model);
    if(!self.alpha)
    self.alpha = 1;
    self.cnt = 1;
    self.think = func_wave_think;
    self.nextthink = time;
};

void() bee_fly =
{
	float extratime;
	if (self.owner.using == 0)
	{

		setmodel(self,"");
		self.effects = EF_NODRAW;
		self.movetype = 0;
		self.velocity = '0 0 0';
		self.think = bee_fly;
		self.nextthink = time + random(0.5,1);
		return;
	}
	else
	{
		if(self.effects == EF_NODRAW)
		{
			setmodel(self,"models/objects/decor/wrathbee.md3");
			self.effects = 0;
			self.movetype = MOVETYPE_WALK;
		}
		if((self.attack_finished < time ) || (self.touchtime < time))
			float speed = random(32,92);

		if((self.attack_finished < time ) && (self.icetime > time) )
		{
			self.yaw_speed = 10;
			makevectors2 (self.angles);
			self.lastplace_spoted = self.origin + v_forward * speed * 3 + v_right * random(-speed,speed)  * 3;
			vector vel = v_forward * speed;
			self.velocity_x = vel_x;
			self.velocity_y = vel_y;
			self.attack_finished =  time + random(1,3);
		}
		if(self.landsoundtime < time)
		{
			float vvalue = self.sradius;
			if(self.sradius > 32)
			vvalue = 32;
			if(self.origin_z > self.lastplace_spoted_z)
				{self.velocity_z = random(vvalue) *-1; self.gravity = 0.0125;}
			else
				{self.velocity_z = random(vvalue); self.gravity = -0.0125;}
			self.landsoundtime =  time + random(0.5,2.5);
		}


		if(self.icetime < time) 
		{
			self.yaw_speed = 40;
			vector rorg;
			rorg_x = random(-self.sradius,self.sradius) * 0.5;
			rorg_y = random(-self.sradius,self.sradius) * 0.5;
			rorg_z = random(-self.sradius,self.sradius) * 0.25;
			self.lastplace_spoted = self.finaldest + rorg;
			float speed2 = random(64,92);
			vel = normalize(self.lastplace_spoted - self.origin) * speed2;
			self.velocity = vel;
			extratime = vlen(self.origin - self.lastplace_spoted) /  speed2 ;
			//self.icetime += time + (extratime * random(1,1.5));
			self.attack_finished =  time + extratime - 0.1;
		}


		self.ideal_yaw = vectoyaw(self.lastplace_spoted - rorigin(self));
		ChangeYaw();
	}
	self.think = bee_fly;
	self.nextthink = time + 0.1;
};

void()misc_hive_check =
{	
	float dist = vlen(self.origin - single_player.origin);
	if (dist > self.clipdist)
		self.using = 0;
	else
		self.using = 1;
	self.nextthink = time + 0.1;
	self.think = misc_hive_check;

};

void() misc_hive_touch =
{
	
	if(other.owner == self)
		other.icetime =  time + 0.1;
	else
		return;
};


void()info_hive =
{
	precache_model("models/objects/decor/wrathbee.md3");
    setmodel(self,"");
	
	self.targetname = "t";

	if(!self.sradius)
		self.sradius = 64;
	if(!self.count)
		self.count = 16;
	if(!self.clipdist)
		self.clipdist = 1024;

	float bcounter = self.count;
	self.solid = SOLID_TRIGGER;
	vector radiussize;
	radiussize_x = self.sradius;
	radiussize_y = self.sradius;

	float vsize = self.sradius;
	if(self.sradius > 128)
	vsize = 128;

	radiussize_z = vsize;
	setsize (self,-radiussize,radiussize);

	self.touch = misc_hive_touch;
	while (bcounter > 0)
	{
		entity bee = spawn();
		vector org;
		org_x = random(-self.sradius * 0.5,self.sradius * 0.5);
		org_y = random(-self.sradius * 0.5,self.sradius * 0.5);
		org_z = random(self.sradius  * 0.5);
		bee.angles_y = random () * 360;
		bee.origin = self.origin + org  + '0 0 16';
		bee.owner = self;
		bee.finaldest = self.origin;
		bee.classname = "bee";
		bee.sradius = self.sradius;
		setmodel(bee,"models/objects/decor/wrathbee.md3");
		bee.movetype = MOVETYPE_WALK;
		bee.gravity = -0.05;
		bee.yaw_speed = 10;
		bee.solid = SOLID_CORPSE;
		bee.scale = random (0.5,1);
		bee.think = bee_fly;
		bee.nextthink = time + random();
		bcounter --;

	}
	self.nextthink = time + 0.2;
	self.think = misc_hive_check;
};


void() gib_spawner_use =
{
	if(self.type == 1)
		ThrowGib2("models/gibs/gib_small.md3", 0, 0.75, 1, 1, self.origin, '0 0 0', 0, 1);
	if(self.type == 2)
		ThrowGib2("models/enemies/fallen/gibs/gib_torso_a.md3", 0, 0.75, 1, 1, self.origin, '0 0 0', 0, 1);
	if(self.type == 3)
		ThrowGib2("models/enemies/brute/howitzer/gib_howitser.md3", 0, 0.75, 1, 1, self.origin, '0 0 0', 0, 1);

};

void() gib_spawner =
{
	if(!self.type)
		self.type = 1;
	self.use = gib_spawner_use;
};

//////////////////////end of qc file


