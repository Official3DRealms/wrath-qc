float bossvulnerable;
float pingtimerefresh;
.float switch_finished;
.float fvgeartime;
.float ammo_lance_timing;
.float pickup_spitter;
.float multi_damage;
.float bomb_velocityfactor;
.float bombunreleased;
.float time_pickupweapon;
.float preloadcyst;
.float noammobutton;
.float noammobutton2;
.float nexteffects;
.float noltime;
void Hud_CantUseNotification(entity ownr);
void Hud_CantUseArtifactNotification(entity ownr);
void Hud_CantUseSigilNotification(entity ownr);
void(string name, float random_number)weapon_sound;
void() wsfire_shotgun;
void() wfire_shotgun;
void() wfire_revolver;
void() wsfire_revolver;
void() wfire_cannon;
void() wsfire_cannon;
void() wfire_spitter;
void() wsfire_spitter;
void() wfire_retcher;
void() wsfire_retcher;
void() wfire_lance;
void() wsfire_lance;
void() wfire_crystal;
void() wsfire_crystal;
.float realoding;
void() pick_up_retcher;
void() pick_up_spitter;
void() pick_up_cannon;
void() pick_up_revolver;
void() pick_up_shotgun;
void() pick_up_lance;
void() pick_up_crystal;
void() pick_up_bfg;
void() raise_melee;
void() lower_melee;
void() raise_shotgun;
void() raise_revolver;
void() raise_cannon;
void() raise_spitter;
void() raise_retcher;
void() raise_vmodel;
void() raise_lance;
void() raise_crystal;
void() lower_revolver;
void() lower_cannon;
void() lower_spitter;
void() lower_retcher;
void() lower_vmodel;
void() lower_shotgun;
void() lower_lance;
void() lower_crystal;
void() reload_retcher;
void() w_bfg_attack;
void() wsfire_bfg;
void() raise_bfg;
void() lower_bfg;
//void()reloadrevolver;
void() Use_Func;
.float gameplayfix_stepdown;
.float wsfire_crystal_dmgcnt;
void()write_dummy_file =
{
};
void() check_custom_cvars =
{
	self.extraongroundtime= cvar("cl_extraongroundtime");
	self.alwaysrun = cvar("cl_alwaysrun");
	self.togglerun = cvar("cl_togglerun");
	self.check_centered = 1;
	self.gameplayfix_stepdown = 1;
};
void() refresh_custom_cvars =
{
	stuffcmd (self,strcat(("cl_alwaysrun "), ftos (self.alwaysrun), "\n"));
	stuffcmd (self,strcat(("cl_togglerun "), ftos (self.togglerun), "\n"));
};
void() sgib_touch = 
{ 
	if (other.flags &FL_MONSTER)
		return;
	if (other.classname == "player")
		return;
	if((other.solid == SOLID_BSP) && (self.gibbing < 1))
	{
		self.gibbing = 1;
		if(self.fakewatertype == CONTENT_LAVA)
			pointparticles(particleeffectnum("oppressor_small_gib"), self.origin, '0 0 0', 1);		
		else
			blood_decal(self.origin, 9);
	}
};


void(vector org, vector vel) SpawnGib3 = 
{
 	local entity gib;
	gib = spawn();
	gib.movetype = MOVETYPE_BOUNCE;
	float r= random();

	if(r > 0)
		setmodel(gib, "models/gibs/gib_small.md3");
	if(r > 0.33)
		setmodel(gib, "models/gibs/gib_med.md3");
	if(r > 0.66)
		setmodel(gib, "models/gibs/gib_large.md3");
	gib.traileffectnum = particleeffectnum("bloodtrail");
	setorigin(gib, org);
	gib.solid = SOLID_CORPSE;
	gib.velocity = vel;
	gib.velocity_x += random(vel_x *-1,vel_x);
	gib.velocity_y += random(vel_y *-1,vel_y);
	gib.angles = vectoangles(gib.velocity);
	makevectors (gib.angles);
	float speed = vlen(self.velocity);
	gib.velocity += v_right * random (speed *-1,speed);

	gib.touch = sgib_touch;
	gib.scale = random (0.5,1.25);
	gib.avelocity = vel * (random(-50,50));	
	gib.nextthink = time;
	gib.think = checking_ground;
};

void(vector org, vector vel) SpawnGib = 
{
 	local entity gib;
	gib = spawn();
	gib.movetype = MOVETYPE_BOUNCE;
	setmodel(gib, "models/gibs/gib_small.md3");
	gib.traileffectnum = particleeffectnum("bloodtrail");
	setorigin(gib, org);
	gib.solid = SOLID_CORPSE;
	gib.velocity = vel;
	gib.velocity_x += random(vel_x *-1,vel_x);
	gib.velocity_y += random(vel_y *-1,vel_y);
	gib.angles = vectoangles(gib.velocity);
	makevectors (gib.angles);
	float speed = vlen(self.velocity);
	gib.velocity += v_right * random (speed *-1,speed);

	gib.touch = sgib_touch;
	gib.scale = random (0.5,1.25);
	gib.avelocity = vel * (random(-50,50));	
	gib.nextthink = time;
	gib.think = checking_ground;
};


void() sgib2_touch = 
{ 
	if (other.flags &FL_MONSTER)
		return;
	if (other.classname == "player")
		return;
	self.skin = 0;
	self.gibbing = 1;
	blood_decal(self.origin + '0 0 2', 6);
	self.velocity = '0 0 0';
	self.movetype = 0;
	self.think = blood_explode2;
	self.nextthink = time;
};
void(vector org, vector vel) SpawnGib2 = 
{
 	local entity gib;
	gib = spawn();
	setorigin(gib, org);
	setmodel(gib, "particles/explo/explo_blood4.md3");
	gib.scale = random (0.125,0.25);
	gib.solid = SOLID_CORPSE;
	gib.alpha = 0.75;
	setsize(gib,'-1 -1 -1','1 1 1');
	gib.movetype = MOVETYPE_TOSS;
	gib.velocity = vel;
	gib.skin = floor(random(1,5));
	gib.traileffectnum = particleeffectnum("wraithtrail2");
	gib.avelocity = vel * (random(-50,50));	
	gib.avelocity_z += random(-256,256);
	gib.touch = sgib2_touch;
};



void()oppressor_impact;
void(vector org, vector vel, float damage, float type, float pcount) SpawnBlood = 
{
	local float bparticle;
	//
	switch(type)
	{
		case 1:
			bparticle = particleeffectnum("NORMAL_BLOOD");
		break;
		case 2:
			bparticle = particleeffectnum("GREEN_BLOOD");
		break;
		case 3:
			bparticle = particleeffectnum("NORMAL_BLOOD2");
		break;
		case 4:
			bparticle = particleeffectnum("BLUE_BLOOD");
		break;
		case 5:
			bparticle = particleeffectnum("oppressor_impact");
			local entity impact;
			impact = spawn();
			float r = random() * 5;
			if (r <= 5)
				setmodel(impact, "particles/impact/impact_oppressor1.md3");
			if (r <= 4)
				setmodel(impact, "particles/impact/impact_oppressor2.md3");
			if (r <= 3)
				setmodel(impact, "particles/impact/impact_oppressor3.md3");
			if (r <= 2)
				setmodel(impact, "particles/impact/impact_oppressor4.md3");
			if (r <= 1)
				setmodel(impact, "particles/impact/impact_oppressor5.md3");
			impact.origin = org;
			impact.alpha = 1;
			impact.think = oppressor_impact;
			impact.nextthink = time + 0.1;			
		break;	
		case 6:
			bparticle = particleeffectnum("WHITE_BLOOD");
		break;
		default:
			bparticle = particleeffectnum("NORMAL_BLOOD");
		break;	
	}
	if(pcount < 0)
		pcount = 1;

	pointparticles(bparticle, org, vel *0.1, pcount);
};
float TE_LIGHTNING4NEH = 17;
void(string mdl, entity owner, vector start, vector end) te_custombeam  = {
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LIGHTNING4NEH);
  WriteString(MSG_BROADCAST, mdl);
  WriteEntity(MSG_BROADCAST, owner);
  WriteCoord(MSG_BROADCAST, start_x);
  WriteCoord(MSG_BROADCAST, start_y);
  WriteCoord(MSG_BROADCAST, start_z);
  WriteCoord(MSG_BROADCAST, end_x);
  WriteCoord(MSG_BROADCAST, end_y);
  WriteCoord(MSG_BROADCAST, end_z);
}
.float lance_secondary;
.float particle_time;
void  (entity e,vector org, vector dest) bloodparticles_beam2;
void()explogibs =
{
	entity head = findradius(self.origin, 120);
	while (head)
	{
		if (head.wrathflags & FL_GIB)
		{
		head.movetype = MOVETYPE_BOUNCE;
		head.velocity_z = random(128,256); 	
		head.velocity_x = random(-128,128); 	
		head.velocity_y = random(-128,128); 	
			
		}
		head = head.chain;  // cycle to next head (entity)
	}
	remove(self);
};
.float explosion_gibs;
void(vector org)spawn_explosion_forgibs = 
{
	entity explosion = spawn();
	explosion.origin = org;
	setmodel(explosion, "");
	explosion.traileffectnum = particleeffectnum("crystal_blood_trail");
	explosion.movetype = MOVETYPE_FLY;
	explosion.velocity = '0 0 300';
	te_customflash(explosion.origin,256,2,'3 0 0');
	decal_monster_gib (explosion.origin);
	te_bloodshower (org - ('12 12 12'),org + ('12 12 12'), 512,256);
	explosion.think = explogibs;
	explosion.nextthink = time + 0.1;
}
void(vector org, float sdelay)spawn_explogibs = 
{
	entity explosion = spawn();
	explosion.origin = org;
	setmodel(explosion, "");
	explosion.think = explogibs;
	explosion.nextthink = time + sdelay;
}
.float orb_time;
void() ApplyMultiDamage =
{
	local entity e;
	e = nextent(world);
	while (e)
	{
		if ((e.multi_damage) )
		{
			T_Damage (e, self, self, e.multi_damage);
			e.multi_damage = 0;
		}
		e = nextent(e);
	}
};
void(vector start, vector end) te_tei_g3 = { WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, 76);
	WriteCoord(MSG_BROADCAST, start_x);
	WriteCoord(MSG_BROADCAST, start_y);
	WriteCoord(MSG_BROADCAST, start_z);
	WriteCoord(MSG_BROADCAST, end_x);
	WriteCoord(MSG_BROADCAST, end_y);
	WriteCoord(MSG_BROADCAST, end_z);
	WriteCoord(MSG_BROADCAST, 0);
	WriteCoord(MSG_BROADCAST, 0);
	WriteCoord(MSG_BROADCAST, 0);
};
void(vector org,string locsound, float rnd, float vol, float sspeed) randompointsound7;


/*

float    MAT_GENERIC = 0;
float    MAT_DIRT = 64;// 0x40
float    MAT_GRASS = 32768; // 0x8000
float    MAT_GRAVEL = 32832; // 32768 + 64, 0x8040
float    MAT_GRATE = 131072; // *2, 0x20000
float    MAT_METAL = 131136 ;//131072 + 64, 0x20040
float    MAT_ICE = 163840;//131072 + 32768, 0x28000
float    MAT_MUD = 163904; // 131072 + 32768 + 64, 0x28040
float    MAT_PUDDLE = 262144;// *2, 0x40000
float    MAT_SOFT = 262208; // 262144 + 64, 0x40040
float    MAT_SNOW = 294912; //262144 + 32768, 0x48000
float    MAT_STONE = 294976; // 262144 + 32768 +64, 0x48040
float    MAT_WOOD = 393216; // 262144 + 131072, 0x60000
float    MAT_BFLESH= 425984; // 262144 + 131072+ 32768;, 0x68000
float    MAT_MASK = 426048 ; //  262144 + 131072+ 32768 +64, 0x68040

*/

void(float material, vector org,vector partvel,float pammount, float miscf) material_impacts =
{
	float r= random();

	if (material == MAT_GENERIC)
	{
		pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("TE_GUNSHOT3"),org, '0 0 0', 1);
	}
	else if (material == MAT_DIRT)
	{
		pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("dirtparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"impact/projectiles/bullet", 5, random(0.5,0.7),random(65,80));
	}
	else if (material == MAT_GRASS)
	{
		pointparticles(particleeffectnum("grassparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"impact/projectiles/bullet", 5, random(0.5,0.7),random(65,80));
	}
	else if (material == MAT_GRAVEL)
	{
		pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("TE_GUNSHOT2"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("gravelparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.5)
			randompointsound7(org,"impact/projectiles/rico", 15, random(0.5,0.7),random(90,105));
	}
	else if (material == MAT_GRATE)
	{	
		pointparticles(particleeffectnum("TE_GUNSHOT3"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("metalfragment"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound(org,"impact/projectiles/rico", 15, random(0.5,0.7));
	}
	else if (material == MAT_METAL)
	{	
		pointparticles(particleeffectnum("TE_GUNSHOT3"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("metalfragment2"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"impact/projectiles/rico", 15, random(0.5,0.7),random(75,90));
	}

	else if (material == MAT_ICE)
		pointparticles(particleeffectnum("snowparticles2"),org, partvel * random (1,1.5), pammount);
	else if (material == MAT_MUD)
	{

		pointparticles(particleeffectnum("mudparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"player/footsteps/mud", 5, random(0.5,0.7),random(110,130));
	}
	else if (material == MAT_PUDDLE)
	{
		pointparticles(particleeffectnum("puddleparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"player/footsteps/puddle", 5, random(0.5,0.7),random(110,130));
	}
	else if (material == MAT_SOFT)
		pointparticles(particleeffectnum("sandparticles"),org, partvel * random (1,1.5), pammount);
	else if (material == MAT_SNOW)
		pointparticles(particleeffectnum("snowparticles"),org, partvel * random (1,1.5), pammount);
	else if (material == MAT_STONE)
	{
		pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
		pointparticles(particleeffectnum("woodparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"impact/projectiles/rico", 15, random(0.5,0.7),random(90,105));
	}
	else if (material == MAT_WOOD)
	{
		pointparticles(particleeffectnum("woodparticles"),org, partvel * random (1,1.5), pammount);
		if(r < 0.3)
			randompointsound7(org,"impact/projectiles/bullet", 5, random(0.5,0.7),random(75,90));
	}
	else if (material == MAT_BFLESH)
	{
		pointparticles(particleeffectnum("NORMAL_BLOOD"),org, partvel * 0.5, pammount);
		pointparticles(particleeffectnum("NORMAL_BLOOD2"),org, partvel, pammount);
		float rgib= random();

		randompointsound(org,"impact/gibs/gib_hit", 6, random(0.5,1));
		if (rgib < 0.07)
		SpawnGib(org,partvel * 4);
		
	}


};

.float gibpush;
void(float damage, vector dir) TraceAttack = {
	
	if ((self.weapon == IT_CRYSTAL) && (self.particle_time > time))
		return;
	local vector vel, org;
	vel = normalize(dir + v_up* crandom() + v_right* crandom());
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos;	// - dir*4;
	local float rlooplimit, dam;
	local vector dorg, orgen;
	local entity tempen;
	rlooplimit = 3;	// only allow 3 hits
	if (self.weapon == IT_CRYSTAL)
		rlooplimit = 1;	// only allow 1 hit
	if (self.weapon == IT_LANCE)
	{
		if(self.lance_secondary == 1)
			rlooplimit = 1;	// only allow 1 hit
		else
			rlooplimit = 21;	// only allow 21 hits
	}
	dorg = org - dir * 4;



	if ((trace_ent.takedamage) && ((trace_ent.orb_time < time) || (self.orb_time > time)) ) 
	{
		if (trace_ent.solid ==  SOLID_BSP)
		{
			if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_REVOLVER))
			{
				pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
				pointparticles(particleeffectnum("TE_GUNSHOT2"),org, '0 0 0', 1);
			}

			if (self.weapon == IT_CRYSTAL)
			{
					pointparticles(particleeffectnum("NORMAL_BLOOD2"),org, '0 0 0', 1);
			}
		}


		while (rlooplimit > 0)
		{
			if (trace_ent.takedamage && trace_ent != world)
			{
				orgen = org + dir * 4;
				dorg = org - dir * 4;
				dam = 1;
				local vector tracentorg;
				tracentorg = rorigin(trace_ent);
				if((trace_ent.classname == "player") && (self.classname == "player"))
				{	
					if (self.weapon == IT_SHOTGUN)
						damage = self.shotgun_damage1_mp;
					if (self.weapon == IT_REVOLVER)
						damage = self.revolver_damage1_mp;
					if (self.weapon == IT_LANCE)
					{
						if(self.lance_secondary == 1)
							damage = self.lance_damage_mp;
						else
							damage = self.lance_damage2_mp;
					}
				}
				
				if ((trace_ent.flags &FL_MONSTER)||(trace_ent.classname == "monster_keeper"))
				{
					if (trace_endpos_z > (tracentorg_z + 24))
						trace_ent.dmg_h += 1;
					else
						trace_ent.dmg_t += 1;
					if (self.weapon == IT_CRYSTAL)	
						te_bloodshower (trace_ent.absmin, trace_ent.absmax, 512,64);
					if (trace_ent.classname == "monster_afflicted")
						SpawnBlood(dorg, vel *0.2, damage, 2, 0);
					else if (trace_ent.classname == "monster_wraith")
						SpawnBlood(dorg, vel *0.2, damage, 4, 0);
					else if (trace_ent.classname == "monster_oppressor")
						SpawnBlood(dorg, vel *0.2, damage, 5, 0);
					else
						SpawnBlood(dorg, vel *0.2, damage, 1, 0);
					local float r;
					if (self.weapon == IT_SHOTGUN)
					{						
						r = random();
						if (r < 1)
						{
							if (trace_ent.classname == "monster_afflicted")
								explo_blood_sprite(3, org);
							else if (trace_ent.classname == "monster_wraith")
								explo_blood_sprite(4, org);
							else
							{
								if (trace_ent.bloody)
								{
									if (r < 0.5)
										explo_blood_sprite(1, org);
									else
										explo_blood_sprite(2, org);
								}
							}
						}
					}
					else
					{
						r = random();
						if (r < 1)
						{
							if (trace_ent.classname == "monster_afflicted")
								explo_blood_sprite(3, org);
							else if ((trace_ent.classname == "monster_wraith"))
							{
								if (trace_ent.health > 10)
									explo_blood_sprite(0, org);
							}
							else
							{
								if (trace_ent.bloody)
								{
									if (r < 0.5)
										explo_blood_sprite(1, org);
									else
										explo_blood_sprite(2, org);
								}	
							}
						}
					}
				}

				if (((self.weapon == IT_SHOTGUN) ||(self.weapon == IT_LANCE)|| (self.weapon == IT_REVOLVER)) && ((trace_ent.flags &FL_MONSTER) && (trace_ent.gibpush < time)))
				{
					vector exporg = org - dir * 16 - '0 0 2';
					entity gibpusher = spawn();
					setmodel(gibpusher,"");
					gibpusher.origin = exporg;
					if(self.weapon == IT_REVOLVER)
						gibpusher.cnt = 256;
					if(self.weapon == IT_SHOTGUN)
						gibpusher.cnt = 768;
					if(self.weapon == IT_LANCE)
						gibpusher.cnt = 1024;

					float playerdist = vlen((self.origin + self.view_ofs) - trace_endpos);
					float pushfactor = (1024 - playerdist) / 1024 ;
					if(playerdist >= 1024)
						pushfactor = 0;
					trace_ent.gibpush = time + 0.5;
					gibpusher.cnt = gibpusher.cnt * pushfactor;
					gibpusher.lorigin = trace_endpos;
					gibpusher.count = 92;// radius
					gibpusher.think = gibpusher_think2;
					gibpusher.nextthink = time + 0.1;

				}	

				if (trace_ent.bloody ==  2)
				SpawnBlood(dorg, vel *0.2, damage, 6, 0);

				trace_ent.multi_damage = trace_ent.multi_damage + damage * dam;
				if (trace_ent.solid == SOLID_BSP)
					rlooplimit = 0;
			}
			else
			{
				dorg = org - dir * 4;
				rlooplimit = 0;
			}
			tempen = self;
			self = trace_ent;
			traceline(orgen, orgen + dir *1048, FALSE, self);
			self = tempen;
			rlooplimit = rlooplimit - 1;
		}
	}
	else
	{

		if((trace_ent.orb_time > time) && (self.orb_time < time))
		{
			pointparticles(particleeffectnum("forcefieldsmall"),org, '0 0 0', 1);
			randompointsound(other.origin, "impact/projectiles/trinket_small", 3, 1);
			return;
		}


		if (self.weapon == IT_CRYSTAL)
		{
				pointparticles(particleeffectnum("NORMAL_BLOOD2"),org, '0 0 0', 1);
		}
        vector partvel =normalize(trace_plane_normal) * 92;
		float material = GetTraceMaterial();


		if(material != MAT_GENERIC)
			material_impacts(material,org,partvel,1,0);
		else
		{
			if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_REVOLVER))
			{
				pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
				pointparticles(particleeffectnum("TE_GUNSHOT2"),org, '0 0 0', 1);
			}
		}

	}
	if (self.weapon == IT_CRYSTAL)
	self.particle_time = time + 0.1;
};
.float oldclipgroup;
void()proj_wretch_explo;
void() dripper_touch =
{
	if(other.classname == "bossprojectile")
	{
		other.lifetime = 0;
		other.think = proj_wretch_explo;
		other.nextthink = time;
	}	
	if(other ==  self.owner)
		return;
	if(other.classname ==  "dripper")
		return;
	remove(self);	
};
void(vector org, vector dest, entity ownr) shot_water_dripper =
{

	if(ownr.waterlevel >= 1.5)
		return;
	entity dripper = spawn();
	dripper.origin = org;
	dripper.movetype = MOVETYPE_WALK;
	dripper.solid = SOLID_TRIGGER;
	setsize(dripper,'-1 -1 -1','1 1 1');
	dripper.classname = "dripper";
	dripper.owner = ownr;
	setmodel(dripper,"");
	dripper.velocity = normalize (dest - org) * 3450;
	dripper.touch = dripper_touch;
	dripper.think = SUB_Remove;
	dripper.nextthink = time + 5;
};

void(float shotcount, vector dir, vector spread, float dmge, float spreadm) FireBullets = { local vector direction;
	local vector src;
	local float sv;
	
	if(self.clipgroup != 0)
	{
		self.oldclipgroup = self.clipgroup;
		self.clipgroup = 0;
	}
	makevectors(self.v_angle);
	spread_x = spread_x *self.charge_shotgun;
	spread_y = spread_y *self.charge_shotgun;
	spreadm = spreadm *self.charge_shotgun;
	src = self.origin + v_forward * 10;
	src_z = self.absmin_z + self.size_z *0.7 + 8;
	float s = self.solid;
	self.solid = SOLID_BBOX;
	float o_dphitcontents = self.dphitcontentsmask;
	self.dphitcontentsmask = DPCONTENTSMASK_WEAPON;
	while (shotcount > 0)
	{
		sv += 0.0075 * spreadm;
		if (self.weapon == IT_SHOTGUN)
		{
			sv += 0.0005 * spreadm;
			spread_x = spread_x *(spreadm);
			spread_y = spread_y *(spreadm);
		}
		direction = dir + crandom() *(spread_x + sv + sv) *v_right + crandom() *(spread_y + sv) *v_up;
		local vector maxbbox, minbbox;
		maxbbox = coachbbox;
		minbbox_x = maxbbox_x *-1;
		minbbox_y = maxbbox_y *-1;
		minbbox_z = maxbbox_z *-1;
		tracebox(src, minbbox, maxbbox, src + direction *2048, FALSE, self);
		entity attacked = trace_ent;
		shot_water_dripper(src -'0 0 4', trace_endpos, self);
				
		if (trace_fraction != 1.0 && !GetSkyMaterial())
			TraceAttack(dmge, direction);

		// Reki (July 19 2023): fgsfds, blood impact decals but this system really sucks.
		if (self.weapon != IT_SHOTGUN || (random() < 0.5))
		{
			vector old_impact = trace_endpos;
			tracebox(src, minbbox, maxbbox, src + direction *2048, MOVE_HITMODEL, self);
			if (trace_ent != attacked)
				trace_endpos = old_impact;

			if (bossvulnerable == 1) // boss 1 legacy fallback
			{
				if((attacked == trace_ent) && (trace_ent.bloody == 2))
				{
					explo_blood_sprite(5, trace_endpos);

					if (random() < 0.1)						
						SpawnGib2(trace_endpos, randomvector('-32 -32 0','32 32 128'));
				}
				
			}
			if (attacked.bloodimpact) // new cleaner stuff
				explo_blood_sprite(attacked.bloodimpact, trace_endpos);
		}
		//

		//te_tei_g3 (self.origin, trace_endpos);	
		shotcount = shotcount - 1;
	}
	self.dphitcontentsmask = o_dphitcontents;
	self.solid = s;
	ApplyMultiDamage();
	self.clipgroup = self.oldclipgroup;
};
void() s_explode1 =[0, s_explode2]
{
	self.effects = EF_ADDITIVE;
	self.nextthink = time + 0.05;
};
void() s_explode2 =[1, s_explode3]
{
	if (self.nexteffects)
		self.effects = self.nexteffects;
	self.nextthink = time + 0.05;
};
void() w_melee_slash;
void() s_explode3 =[2, s_explode4]
{
	self.nextthink = time + 0.05;
};
void() s_explode4 =[3, s_explode5]
{
	self.nextthink = time + 0.05;
};
void() s_explode5 =[4, s_explode6]
{
	self.nextthink = time + 0.05;
};
void() s_explode6 =[5, s_explode7]
{
	self.nextthink = time + 0.05;
};
void() s_explode7 =[6, s_explode8]
{
	self.nextthink = time + 0.05;
};
void() s_explode8 =[7, s_explode9]
{
	self.nextthink = time + 0.05;
};
void() s_explode9 =[8, s_explode10]
{
	self.nextthink = time + 0.05;
};
void() s_explode10 =[9, s_explode11]
{
	self.nextthink = time + 0.05;
};
void() s_explode11 =[10, SUB_Remove]
{
	self.nextthink = time + 0.05;
};
void() w_vmodel_slash;
.float lastweapontime;
void() nextweapon;
//.float semi;
//.float ssemi;
.entity torso_model;
.float torso_time;
.float flaskeffecttime;
void(float intensity) flask_v_fx =
{
	return;
};
.float reloaded;

void() Weapon_Fire = { 
 	float checked7;
 	checked7 = cvar("saved4");



	switch (self.weapon)
	{
		case IT_MELEE:
			w_melee_slash();
			flask_v_fx(1);
			self.attack_finished = time + 0.5;
			self.torso_time = time + 0.5;
		break;
		case IT_VIEWMODEL:
			w_vmodel_slash();
			flask_v_fx(1);
			self.attack_finished = time + 0.5;
		break;
		case IT_REVOLVER:
			if (self.ammo_revolver <= 0)
			{
				sound(self, CHAN_AUTO, "weapons/revolver/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				//			self.attack_finished = time +  0.2;
				self.noammobutton = 1;
				return;
			}

			if(self.time_fire_revolver < time)
			{
				wfire_revolver();
				flask_v_fx(1);
				self.attack_finished = time + 0.35;
				self.torso_time = time + 0.5;
				achievement_onlybladeandmace = FALSE;
			}
		break;
		case IT_SHOTGUN:
			if (self.ammo_shotgun < 2)
			{
				sound(self, CHAN_AUTO, "weapons/revolver/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			if(self.time_fire_shotgun < time)
			{
				self.torso_time = time + 0.5;
				wfire_shotgun();
				flask_v_fx(1);
				achievement_onlybladeandmace = FALSE;
			}
		break;
	
		case IT_CANNON:
			if (self.ammo_cannon <= 0)
			{
				//sound(self, CHAN_AUTO, "weapons/cannon/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			if(self.time_fire_cannon < time)
			{
				wfire_cannon();
				achievement_onlybladeandmace = FALSE;
			}
		break;
		case IT_LANCE:
			if (self.ammo_lance <= 0)
			{
				//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			if((self.time_fire_lance < time) && (self.reloaded == 1))
			{
				self.torso_model.frame = 16;
				self.vweaponframe = 0;
				wfire_lance();
				flask_v_fx(1);
				achievement_onlybladeandmace = FALSE;
			}
		break;
		case IT_CRYSTAL:
			if (self.ammo_crystal < 1)
			{
				//sound(self, CHAN_AUTO, "weapons/crystal/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			else
			{
				wfire_crystal();
				flask_v_fx(1);			
				self.torso_model.frame = 16;
				self.attack_finished = time + 0.1;
				achievement_onlybladeandmace = FALSE;
			}
		break;
		case IT_RETCHER:
		
			if (self.ammo_retcher <= 0)
			{
				sound(self, CHAN_AUTO, "weapons/retcher/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			if(self.time_fire_retcher < time)
			{
				self.torso_time = time + 0.5;
				wfire_retcher();
				flask_v_fx(1);
				achievement_onlybladeandmace = FALSE;
			}
		break;
		case IT_SPITTER:
			self.vgearrelease = 1;
			if (self.ammo_spitter <= 0)
			{
				sound(self, CHAN_AUTO, "weapons/spitter/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			else
			{
				self.fvgeartime = 0;
				self.torso_time = time + 0.5;
				wfire_spitter();
				achievement_onlybladeandmace = FALSE;
			}
		break;
		case IT_MACE:
			w_bfg_attack();
			flask_v_fx(1);
			self.attack_finished = time + 0.5;
			self.torso_time = time + 0.5;
		break;
	}
	if (time > 2)
		self.show_hostile = time + 1;
};
void() w_melee_charge;
.float shotgun_fire1;
//void()wsfire_crystal2;
void() Weapon_Sfire = 
{ 
	float checked7;
	checked7 = cvar("saved4");


	if (self.weapon == IT_MELEE)
	{
		w_melee_charge();
		self.torso_time = time + 0.5;
		self.attack_finished = time + 0.05;
	}
	else if (self.weapon == IT_REVOLVER)
	{
		//if(!self.ssemi)
		//{
		//self.ssemi = 1;		
		if (self.ammo_revolver <= 0)
		{
			sound(self, CHAN_AUTO, "weapons/revolver/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.1;	//0.25
			self.noammobutton2 = 1;
			return;
		}

		if (self.time_fire_revolver > time)
			return;

		achievement_onlybladeandmace = FALSE;
		if (self.ammo_revolver == 1)
		{
			wfire_revolver();
			self.torso_time = time + 0.5;
			//self.attack_finished = time +  0.35;
			self.attack_finished = time + 0.1;	// 0.25
			flask_v_fx(1);
		}
		else
		{
			wsfire_revolver();
			flask_v_fx(1);
		}
	}
	else if (self.weapon == IT_RETCHER)
	{
		if (self.ammo_retcher <= 0)
		{
			sound(self, CHAN_AUTO, "weapons/retcher/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}
		if(self.time_fire_retcher < time)
		{
			self.torso_time = time + 0.5;
			wsfire_retcher();
			flask_v_fx(1);
			achievement_onlybladeandmace = FALSE;
		}
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		if (self.shotgun_fire1 == 1)
			return;
		if ((self.ammo_shotgun < 2) && (self.time_fire_shotgun < time))
		{
			sound(self, CHAN_AUTO, "weapons/revolver/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		if(self.time_fire_shotgun < time)
		{
			self.torso_time = time + 0.5;
			wsfire_shotgun();
			flask_v_fx(1);
			self.attack_finished = time + self.shotgun_time1;
			achievement_onlybladeandmace = FALSE;
		}
	}
	else if ((self.weapon == IT_CANNON)&& (self.time_fire_shotgun < time))
	{
		if (self.ammo_cannon < 5)
		{
			//sound(self, CHAN_AUTO, "weapons/cannon/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}
		if(self.time_fire_cannon < time)
		{
			self.torso_time = time + 0.5;
			wsfire_cannon();
			self.attack_finished = time + self.slagcannon_time2;
			achievement_onlybladeandmace = FALSE;
		}
	}
	else if (self.weapon == IT_LANCE)
	{
		if (self.ammo_lance <= 0)
		{
			//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		self.torso_time = time + 0.5;
		wsfire_lance();		
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_MACE)
	{
		if (self.ammo_bfg <= 0)
		{
			//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		self.torso_time = time + 0.5;
		wsfire_bfg();	
		flask_v_fx(1);	
		//self.attack_finished = time + self.lance_time2;
		self.attack_finished = time + 1.05;
	}
	else if (self.weapon == IT_CRYSTAL)
	{
		if (self.ammo_crystal < 1)
		{
			//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
			if((checked7) && (self.wsfire_crystal_dmgcnt <= 0))
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}
		else
		{
			if(self.time_fire_crystal < time)
			{
				float secondary_crystal = cvar("crystal_sfire");
				wsfire_crystal();		
				self.torso_time = time + 0.05;
				self.attack_finished = time + 0.05;
				achievement_onlybladeandmace = FALSE;
			}
		}	

	}
	else if (self.weapon == IT_SPITTER)
	{
		self.vgearrelease = 1;
		if (self.ammo_spitter <= 0)
		{
			sound(self, CHAN_AUTO, "weapons/spitter/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}
		self.fvgeartime = 0;
		self.torso_time = time + 0.5;
		wsfire_spitter();
		achievement_onlybladeandmace = FALSE;
	}
	self.show_hostile = time + 1;
};
void()W_SetWeapon;
void() Think_Vweapon = { 
	if(self.owner.vhud == 3)
		self.effects = EF_NODRAW;
	else
		self.effects = 0;
	self.frame = self.owner.vweaponframe;
	self.skin = self.owner.vweaponskin;
	self.glowmod = self.owner.vweaponglowmod;
	self.think = Think_Vweapon;
	self.nextthink = time;
};
.float rweapon;
.float centered;
void() W_SetWeapon = { local string fwmodel;
	if (self.weapon == IT_MELEE)
		fwmodel = "models/weapons/melee/v_gauntlet.md3";
	else if (self.weapon == IT_REVOLVER)
		fwmodel = "models/weapons/revolver/v_revolver.md3";
	else if (self.weapon == IT_SHOTGUN)
		fwmodel = "models/weapons/shotgun/v_shotgun.md3";
	else if (self.weapon == IT_RETCHER)
		fwmodel = "models/weapons/retcher/v_retcher.md3";
	else if (self.weapon == IT_SPITTER)
		fwmodel = "models/weapons/spitter/v_spitter.md3";
	else if (self.weapon == IT_CANNON)
		fwmodel = "models/weapons/cannon/v_cannon.md3";
	else if (self.weapon == IT_LANCE)
		fwmodel = "models/weapons/lance/v_lance.md3";
	else if (self.weapon == IT_CRYSTAL)
		fwmodel = "models/weapons/crystal/v_crystal.md3";
	else if (self.weapon == IT_VIEWMODEL)
		fwmodel = self.vvweapon_model;
	else if (self.weapon == IT_MACE)
		fwmodel = "models/weapons/mace/v_gauntlet.md3";
	self.weaponmodel = "models/weapons/revolver/v_revolver.md3";
	self.vweapon.model = fwmodel;	
	if (self.weapon == IT_VIEWMODEL)
	{
		self.vweapon.scale = self.vvweapon_scale;
		self.vweapon.origin_x = self.vvweapon_x;
		self.vweapon.origin_y = self.vvweapon_y;
		self.vweapon.origin_z = self.vvweapon_z;
		self.vweapon.angles = self.vvweaponangles;
	}
	if (self.weapon == IT_MACE)
	{
		self.vweapon.scale = self.macevweapon_scale;
		self.vweapon.origin_x = self.macevweapon_x;
		self.vweapon.origin_y = self.macevweapon_y;
		self.vweapon.origin_z = self.macevweapon_z;
	}
	if (self.weapon == IT_MELEE)
	{
		self.vweapon.scale = self.dvweapon_scale;
		self.vweapon.origin_x = self.dvweapon_x;
		self.vweapon.origin_y = self.dvweapon_y;
		self.vweapon.origin_z = self.dvweapon_z;
		self.vweapon.angles = self.vweaponangles;
	}
	if (self.weapon == IT_REVOLVER)
	{
		self.vweapon.scale = self.cgvweapon_scale;
		self.vweapon.origin_x = self.cgvweapon_x;
		self.vweapon.origin_y = self.cgvweapon_y;
		self.vweapon.origin_z = self.cgvweapon_z;
		self.vweapon.angles = self.cgweaponangles;
	}
	if (self.weapon == IT_SHOTGUN)
	{
		self.vweapon.scale = self.svweapon_scale;
		self.vweapon.origin_x = self.svweapon_x;
		self.vweapon.origin_y = self.svweapon_y;
		self.vweapon.origin_z = self.svweapon_z;
		self.vweapon.angles = self.sweaponangles;
		if(!(self.vweapon.effects & EF_DOUBLESIDED))
		self.vweapon.effects += EF_DOUBLESIDED;
	}
	if (self.weapon == IT_SPITTER)
	{
		self.vweapon.scale = self.pvweapon_scale;
		self.vweapon.origin_x = self.pvweapon_x;
		self.vweapon.origin_y = self.pvweapon_y;
		self.vweapon.origin_z = self.pvweapon_z;
		self.vweapon.angles = self.pweaponangles;
	}
	if (self.weapon == IT_RETCHER)
	{
		self.vweapon.scale = self.rvweapon_scale;
		self.vweapon.origin_x = self.rvweapon_x;
		self.vweapon.origin_y = self.rvweapon_y;
		self.vweapon.origin_z = self.rvweapon_z;
		self.vweapon.angles = self.rweaponangles;
	}
	if (self.weapon == IT_CANNON)
	{
		self.vweapon.scale = self.cvweapon_scale;
		self.vweapon.origin_x = self.cvweapon_x;
		self.vweapon.origin_y = self.cvweapon_y;
		self.vweapon.origin_z = self.cvweapon_z;
		self.vweapon.angles = self.cweaponangles;
	}
	if (self.weapon == IT_LANCE)
	{
		self.vweapon.scale = self.lvweapon_scale;
		self.vweapon.origin_x = self.lvweapon_x;
		self.vweapon.origin_y = self.lvweapon_y;
		self.vweapon.origin_z = self.lvweapon_z;
		self.vweapon.angles = self.lweaponangles;
	}
	if (self.weapon == IT_CRYSTAL)
	{
		self.vweapon.scale = 1;
		self.vweapon.origin_x = self.chvweapon_x;
		self.vweapon.origin_y = self.chvweapon_y;
		self.vweapon.origin_z = self.chvweapon_z;
		self.vweapon.angles = self.chvweaponangles;
	}
	float checked6;
 	checked6 = cvar("saved3");
 	if ((checked6 == 1) && (self.weapon != IT_MELEE))
	{
		if (self.weapon == IT_VIEWMODEL)
		{
			self.vweapon.scale = self.vvweapon_scale;
			self.vweapon.origin_x = self.vvweapon_x;
			self.vweapon.origin_y = self.vvweapon_y;
			self.vweapon.origin_z = self.vvweapon_z;
			self.vweapon.angles = self.vvweaponangles;
		}
		if (self.weapon == IT_MACE)
		{
			self.vweapon.scale = self.dvweapon_scale;
			self.vweapon.origin_x = self.dvweapon_x;
			self.vweapon.origin_y = self.dvweapon_y;
			self.vweapon.origin_z = self.dvweapon_z;
			self.vweapon.angles = self.vweaponangles;
		}
		if (self.weapon == IT_MELEE)
		{
			self.vweapon.scale = self.dvweapon_scale;
			self.vweapon.origin_x = self.dvweapon_x;
			self.vweapon.origin_y = self.dvweapon_y;
			self.vweapon.origin_z = self.dvweapon_z;
			self.vweapon.angles = self.vweaponangles;
		}
		if (self.weapon == IT_REVOLVER)
		{
			self.vweapon.scale = self.cgvweapon_scale;
			self.vweapon.origin_x = self.centered_cgvweapon_x;
			self.vweapon.origin_y = self.centered_cgvweapon_y;
			self.vweapon.origin_z = self.centered_cgvweapon_z;
			self.vweapon.angles = self.centered_cgweaponangles;
		}
		if (self.weapon == IT_SHOTGUN)
		{
			self.vweapon.scale = self.svweapon_scale;
			self.vweapon.origin_x = self.centered_svweapon_x;
			self.vweapon.origin_y = self.centered_svweapon_y;
			self.vweapon.origin_z = self.centered_svweapon_z;
			self.vweapon.angles = self.centered_sweaponangles;
		}
		if (self.weapon == IT_SPITTER)
		{
			self.vweapon.scale = self.pvweapon_scale;
			self.vweapon.origin_x = self.centered_pvweapon_x;
			self.vweapon.origin_y = self.centered_pvweapon_y;
			self.vweapon.origin_z = self.centered_pvweapon_z;
			self.vweapon.angles = self.centered_pweaponangles;
		}
		if (self.weapon == IT_RETCHER)
		{
			self.vweapon.scale = self.rvweapon_scale;
			self.vweapon.origin_x = self.centered_rvweapon_x;
			self.vweapon.origin_y = self.centered_rvweapon_y;
			self.vweapon.origin_z = self.centered_rvweapon_z;
			self.vweapon.angles = self.centered_rweaponangles;
		}
		if (self.weapon == IT_CANNON)
		{
			self.vweapon.scale = self.cvweapon_scale;
			self.vweapon.origin_x = self.centered_cvweapon_x;
			self.vweapon.origin_y = self.centered_cvweapon_y;
			self.vweapon.origin_z = self.centered_cvweapon_z;
			self.vweapon.angles = self.centered_cweaponangles;
		}
		if (self.weapon == IT_LANCE)
		{
			self.vweapon.scale = self.lvweapon_scale;
			self.vweapon.origin_x = self.centered_lvweapon_x;
			self.vweapon.origin_y = self.centered_lvweapon_y;
			self.vweapon.origin_z = self.centered_lvweapon_z;
			self.vweapon.angles = self.centered_lweaponangles;
		}
		if (self.weapon == IT_CRYSTAL)
		{
			self.vweapon.scale = 1;
			self.vweapon.origin_x = self.centered_chvweapon_x;
			self.vweapon.origin_y = self.centered_chvweapon_y;
			self.vweapon.origin_z = self.centered_chvweapon_z;
			self.vweapon.angles = self.centered_chvweaponangles;
		}
		self.centered = 1;
	}
	else
	self.centered = 0;
	
	//self.colormod = '1 1 1';
	setmodel(self.vweapon, fwmodel);
};
.float rlastweapon;
void() raise_weapon = 
{
	W_SetWeapon();
	self.attack_finished = time + 0.0125;
	self.lastweapon = self.weapon;
	if (self.weapon != IT_REVOLVER)
		self.vweaponglowmod = '0 0 0';
	if (self.weapon == IT_MELEE)
	{
		raise_melee();
	}
	if (self.weapon == IT_SHOTGUN)
	{
		//		self.vweaponskin = self.revolverclip;
		//		self.vweaponglowmod = '-0.1 -0.1 -0.1';
		if (self.time_pickupweapon > time)
			pick_up_shotgun();
		else
			raise_shotgun();
	}
	if (self.weapon == IT_REVOLVER)
	{
		self.vweaponskin = self.revolverclip;
		self.vweaponglowmod = '-0.1 -0.1 -0.1';
		if (self.time_pickupweapon > time)
			pick_up_revolver();
		else
			raise_revolver();
	}
	if (self.weapon == IT_CANNON)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_cannon();
		else
			raise_cannon();
	}
	if (self.weapon == IT_LANCE)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_lance();
		else
			raise_lance();
	}
	if (self.weapon == IT_CRYSTAL)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_crystal();
		else
			raise_crystal();
	}
	if (self.weapon == IT_RETCHER)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_retcher();
		else
			raise_retcher();
	}
	if (self.weapon == IT_SPITTER)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_spitter();
		else
			raise_spitter();
	}
	if (self.weapon == IT_MACE)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_bfg();
		else
			raise_bfg();
	}
	if (self.weapon == IT_VIEWMODEL)
	{
		self.vweaponskin = 0;
		raise_vmodel();
	}
};
void() pick_up_melee;
.float hasmelee;

void()get_texture_name;

void() W_ChangeWeapon = 
{ 
		
	Check_FrikFile();
	self.realoding = 0;
	if(self.wrath_time > time)
	{
		if ((self.impulse > 1) && (self.impulse < 9))
			return;
	}
	self.randomattack = 0;
	if (self.draw_w != 0)
		return;
	self.hasmelee = 0;
	local float fl, oldweapon;
	if ((time < self.timesound))
	{
		sound(self, CHAN_WEAPON2, "weapons/spitter/fire1_release.wav", 1, ATTN_NORM);
		self.timesound = 0;
		//return;
	}
	if (self.impulse == 1)
	{
		fl = IT_MELEE;
	}
	else if (self.impulse == 2)
		fl = IT_REVOLVER;
	else if (self.impulse == 3)
		fl = IT_SHOTGUN;
	else if (self.impulse == 4)
		fl = IT_SPITTER;
	else if (self.impulse == 5)
		fl = IT_RETCHER;
	else if (self.impulse == 6)
		fl = IT_CANNON;
	else if (self.impulse == 7)
		fl = IT_LANCE;
	else if (self.impulse == 8)
		fl = IT_CRYSTAL;
	else if (self.impulse == 9)
		fl = IT_MACE;
	self.impulse = 0;
	self.noammobutton = 0;
	self.noammobutton2 = 0;
	if (!(self.items &fl))
	{
		// don't have the weapon or the ammo
		sprint(self, "no weapon.\n");
		return;
	}
	oldweapon = self.weapon;
	if (self.weapon == fl)
		return;
	//		if(self.lspeedtime > time)// nice option to speedruns
	//	self.lspeedtime = time + 0.05;
	self.weapon = fl;
	self.lastweapon = oldweapon;
	self.rlastweapon = oldweapon;
	if (oldweapon == IT_MELEE)
		lower_melee();
	if (oldweapon == IT_SHOTGUN)
		lower_shotgun();
	if (oldweapon == IT_REVOLVER)
		lower_revolver();
	if (oldweapon == IT_RETCHER)
		lower_retcher();
	if (oldweapon == IT_CANNON)
		lower_cannon();
	if (oldweapon == IT_LANCE)
		lower_lance();
	if (oldweapon == IT_CRYSTAL)
		lower_crystal();
	if (oldweapon == IT_SPITTER)
		lower_spitter();
	if (oldweapon == IT_MACE)
		lower_bfg();
	if (oldweapon == IT_VIEWMODEL)
		lower_vmodel();
	self.switch_finished = time + 0.175;
	self.lastweapontime = time + 0.05;
};
void() select_lastweapon =
{
	local float timpulse;
	if (self.rlastweapon == IT_MELEE)
		timpulse = 1;
	if (self.rlastweapon == IT_REVOLVER)
		timpulse = 2;
	if (self.rlastweapon == IT_SHOTGUN)
		timpulse = 3;
	if (self.rlastweapon == IT_SPITTER)
		timpulse = 4;
	if (self.rlastweapon == IT_RETCHER)
		timpulse = 5;
	if (self.rlastweapon == IT_CANNON)
		timpulse = 6;
	if (self.rlastweapon == IT_LANCE)
		timpulse = 7;
	if (self.rlastweapon == IT_CRYSTAL)
		timpulse = 8;
	if (self.rlastweapon == IT_MACE)
		timpulse = 9;
	self.impulse = timpulse;

	self.switch_finished = time + 0.175;
	W_ChangeWeapon();
}
void() prevweapon = { local float timpulse;
	if (self.weapon == IT_MELEE)
	{
		if(self.wrath_time > time)
		{
			if (self.items &IT_MACE)
				timpulse = 9;
			self.impulse = timpulse;
			W_ChangeWeapon();
				return;
		}
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
	}
	if (self.weapon == IT_REVOLVER)
	{
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
	}
	if (self.weapon == IT_SHOTGUN)
	{
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
	}
	if (self.weapon == IT_SPITTER)
	{
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
	}
	if (self.weapon == IT_RETCHER)
	{
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
	}
	if (self.weapon == IT_CANNON)	//retcher
	{
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
	}
	if (self.weapon == IT_LANCE)	//lance
	{
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
	}
	if (self.weapon == IT_CRYSTAL)	//lance
	{
		if ((self.items &IT_MACE))
			timpulse = 9;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
	}
	if (self.weapon == IT_MACE)	//lance
	{
		if(self.wrath_time > time)
		{
			if (self.items &IT_MELEE)
				timpulse = 1;
			self.impulse = timpulse;
			W_ChangeWeapon();
				return;
		}
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
	}
	self.impulse = timpulse;
	self.switch_finished = time + 0.175;
	W_ChangeWeapon();
	//self.attack_finished = time;
};
void() nextweapon = { 


	local float timpulse;
	if (self.weapon == IT_MELEE)
	{


		if(self.wrath_time > time)
		{
			if (self.items &IT_MACE)
				timpulse = 9;
			self.impulse = timpulse;
			W_ChangeWeapon();
				return;
		}
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
	}
	if (self.weapon == IT_REVOLVER)
	{
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
	}
	if (self.weapon == IT_SHOTGUN)
	{
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
	}
	if (self.weapon == IT_SPITTER)
	{
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
	}
	if (self.weapon == IT_RETCHER)
	{
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
	}
	if (self.weapon == IT_CANNON)	//retcher
	{
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
	}
	if (self.weapon == IT_LANCE)	//lance
	{
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
		if ((self.items &IT_CRYSTAL) && (self.ammo_crystal))
			timpulse = 8;
	}
	if (self.weapon == IT_CRYSTAL)	//lance
	{
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if (self.items &IT_MACE)
			timpulse = 9;
	}
	if (self.weapon == IT_MACE)	//lance
	{
		if(self.wrath_time > time)
		{
			if (self.items &IT_MELEE)
				timpulse = 1;
			self.impulse = timpulse;
			W_ChangeWeapon();
				return;
		}
		if (self.items &IT_CRYSTAL)
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_REVOLVER) && (self.ammo_revolver))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
	}

	self.impulse = timpulse;
	self.switch_finished = time + 0.175;
	W_ChangeWeapon();
};
void() Rinventory = { if (self.radial_time > time)
	{
		sprint(self, "time to artifact\n");
		self.rmenu = 0;
		self.attack_finished = time + 0.11;
		return;
	}
	if (self.rmenu == 0)
		self.rmenu = 1;
	else
		self.rmenu = 0;
};
void() flash_update = { setorigin(self, self.owner.cursor_trace_endpos);
	self.nextthink = time + 0.001;
};
void() flash_on = { local entity myflash;
	myflash = spawn();
	myflash.movetype = MOVETYPE_NONE;
	myflash.solid = SOLID_NOT;
	setmodel(myflash, "models/dev/gizmo.md3");
	setsize(myflash, '0 0 0', '0 0 0');
	myflash.owner = self;
	myflash.alpha = 1;
	self.flash = myflash;
	myflash.classname = "flash";
	setorigin(myflash, self.cursor_trace_endpos);
	myflash.think = flash_update;
	myflash.nextthink = time + 0.01;
};
void() flash_toggle = { if (self.flash_flag == FALSE)
	{
		self.flash_flag = TRUE;
		devscreen = TRUE;
		flash_on();
	}
	else
	{
		self.flash_flag = FALSE;
		devscreen = FALSE;
		self.flash.think = SUB_Remove;
		self.flash.nextthink = time + 0.01;
	}
};
void() fmck_maker_touchs = { 
		if(other.warped_time > time)
		return;
	if ((other.flags &FL_MONSTER) && (other.friendly_monster != 1))
	{
		other.friendly_monster = 1;
		
		
		
		if(other.enemy)
		other.exenemy = other.enemy; 
		other.enemy = world;
		
		if(other.classname == "monster_stricken")
		{
		other.turret = 1;
		other.th_run = stricken_preattack1;
		}
		if(other.health > 0)
		{
		if(other.classname == "monster_heretic")
		{
		if(other.movetype != MOVETYPE_STEP)
			other.movetype = MOVETYPE_STEP;
		}
		other.think = other.th_run;
		other.show_hostile = time + 1;
		other.nextthink = time + 0.1;
		}
		spawn_attar_enemy(other);
	}
	
	
		
//	remove(self);
};
void() fmck_maker_touch = { 
if ((other.flags &FL_MONSTER) && (other.friendly_monster != 1))
	{
		other.friendly_monster = 1;
		if(other.enemy)
		other.exenemy = other.enemy; 
		other.enemy = 0;
		other.attar_timem = time  + 1;
		if(other.health > 0)
		{
		if(other.classname == "monster_heretic")
			{
			if(other.movetype != MOVETYPE_STEP)
				other.movetype = MOVETYPE_STEP;
			}
			if(other.classname == "monster_stricken")
			{
			other.turret = 1;
			other.th_run = stricken_preattack1;
			}
		}
		other.think = find_next_enemy;
		other.nextthink = time;
		spawn_attar_enemy(other);
		local entity oself;
		oself = self;
		self = other;
		if(self.classname != "monster_stricken")
		deactivate_turret();
		ai_face();
		self = oself;
	}		
//	remove(self);
};

void() W_FireFmonster = { local vector dir, rorg;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "friendlymaker";
	dir = aim(self, 1000);
	rorg = self.view_ofs - '0 0 19';
	setorigin(newmis, self.origin + '0 0 32');
	setmodel(newmis, "models/projectiles/proj_slag1.md3");
	setsizeitem(newmis, '0 0 0');
	newmis.velocity = normalize(self.cursor_trace_endpos - newmis.origin) *1024;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = fmck_maker_touch;
	newmis.effects = EF_NOSHADOW;
	
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
	self.punchangle_x = -2;
	self.vweaponframe = 3;
};
void() Exit_Game = { localcmd("wmenu\n");
	localcmd("menu_cmd backtomainmenu\n");
};
void() Toggle_Journal = 
{ 
	if (self.vhud >= 2)
		return;
	if (self.button3)
	{
		sound7(self,CHAN_AUTO,"weapons/lance/shield_fire1.ogg",0.12,0.25,305,0);
		sound7(self, CHAN_AUTO, "ui/journal/journal_close.ogg", 0.5,0.25,125,0);
		return;
	}
	if (self.button0)
	{
		sound7(self,CHAN_AUTO,"weapons/lance/shield_fire1.ogg",0.12,0.25,305,0);
		sound7(self, CHAN_AUTO, "ui/journal/journal_close.ogg", 0.5,0.25,125,0);
		return;
	}
	if (self.journal == 1)
		self.journal = 0;
	else
		self.journal = 1;
	if (self.journal == 1)
	{
		centerprint(self, "");
		sound(self, CHAN_AUTO, "ui/journal/journal_open.ogg", 1, 0);
		stuffcmd(self, "scratch3 1\n");
	}
	if (self.journal == 0)
	{
		sound(self, CHAN_AUTO, "ui/journal/journal_close.ogg", 1, 0);
		stuffcmd(self, "scratch3 0\n");
	}
};
void CMD_journal_close()
{
	if (self.journal == 1)
		Toggle_Journal();
}
void CMD_dmenu_close()
{
	if (self.deadmenuflag == 1)
		self.deadmenuflag = 0;
}
void() empty_reload_shotgun;
void() Toggle_HUD = { if (self.vhud == 1)
		self.vhud = 0;
	else
		self.vhud = 1;
};
//transformation;
.float spitterloop;
.entity pipes;
.float killemalltime;
void() killemall = 
{ 
	if(self.killemalltime > time)
		return;


	local entity monster;
	monster = nextent(world);
	while (monster)
	{
		entity holder = nextent(monster);
		if (monster.flags &FL_MONSTER)
		{
				T_Damage(monster, self, self, 100000);
		}
		if(monster.classname == "monster_keeper")
		{
				T_Damage(monster, self, self, 100000);
		}
		if(monster.classname == "boss_guardian1")
		{			

			if(monster.bosspain_finished < time)
			{
				if(monster.bosscnt == 3) 
					monster.health = 19999;
				if(monster.bosscnt == 2) 
					monster.health = 9999;
				if(monster.bosscnt == 1) 
					monster.health = 4999;
			}
			else
			{
				T_Damage (monster.pipes, self, self, 125);

			}
		}
		monster = holder;
	}
	self.killemalltime = time + 0.25;	
};

void() removefuncs = 
{ 


	string funcname;
	local entity wrathitems;
	wrathitems = nextent(world);
	while (wrathitems)
	{
		entity holder = nextent(wrathitems);
		funcname = substring(wrathitems.classname, -99, 5); 
		if (funcname == "func_")
		{
				remove(wrathitems);
		}
		wrathitems = holder;
	}

};

void() removetriggers = 
{ 


	string funcname;
	local entity wrathitems;
	wrathitems = nextent(world);
	while (wrathitems)
	{
		entity holder = nextent(wrathitems);
		funcname = substring(wrathitems.classname, -99, 12); 
		if (funcname == "trigger_")
		{
				remove(wrathitems);
		}
		wrathitems = holder;
	}

};
void() removeitems = 
{ 


	local entity wrathitems;
	wrathitems = nextent(world);
	while (wrathitems)
	{
		entity holder = nextent(wrathitems);
		if (wrathitems.wrathflags & FL_ITEMS)
		{
				remove(wrathitems);
		}
		wrathitems = holder;
	}

};

void() killemall2 = 
{ 
	if(self.killemalltime > time)
		return;


	local entity monster;
	monster = nextent(world);
	while (monster)
	{
		entity holder = nextent(monster);
		if (monster.flags &FL_MONSTER)
		{
				remove(monster);
		}
		if((monster.classname == "boss_guardian1") || (monster.classname == "monster_keeper")|| (monster.classname == "enemy_spawner_warp"))
		{			
			remove(monster);
		}

		if (monster.classname == "enemy_spawner")
		{			
			remove(monster);
		}
		monster = holder;
	}
	self.killemalltime = time + 0.25;	
};
void() nodegraph_debug_think;
void() node_debug_think = { local entity nodes;
	nodes = find(world,classname, "nodegraph_debug");
	while (nodes)	//Loops through everything put in the missile entity
	{
		{
			if(test_ia == 1)
			{	
				nodes.think = nodegraph_debug_think;
				nodes.nextthink = time + 0.1;
			}
			else
			{
				nodes.think= SUB_Null;
				nodes.nextthink = time + 1;
			}
		}
		nodes =  find(world,classname, "nodegraph_debug");
	}
};
void() node_debug = { local entity nodes;
	nodes = find(world,classname, "info_node");
	while (nodes)	//Loops through everything put in the missile entity
	{
		{
			if(test_ia == 1)
				nodes.effects = 0;
			else
				nodes.effects = EF_NODRAW;
		}
		nodes =  find(world,classname, "info_node");
	}
};
void(entity e)	spawn_bbox_collider;
void() delebboxesandrespawnthem =
{
	local entity garbage;
	garbage = nextent(world);
	while (garbage)
	{
		entity hold = nextent(garbage); // Reki (October 6 2023): accessing an entity's fields after a remove is undefined behavior, so let's not do that
		if (garbage.classname == "bbox_touch")
		{
			remove(garbage);
		}
		garbage = hold;	//links every garbagegram found so they all go BOOM!
	}

};
void(float a) recount_spawner_monsters;
void() recount_spawner_items;
.float noattack;
void() trinket_spawn;	

void() giveme_oldrelics = 
{
	if(self.oldrelics <= 4)
	self.oldrelics ++;
	centerprint(single_player, strcat("encounter number: ",ftos(self.oldrelics + 1),"\n"));
};

void() giveme_relics = 
{
	//self.slot_relics = 12345;
	relic_addtoslot(self, RL_INTR);
	relic_addtoslot(self, RL_E1M1);
	relic_addtoslot(self, RL_E1M2);
	relic_addtoslot(self, RL_E1M3);
	relic_addtoslot(self, RL_E1M4);
	relic_addtoslot(self, RL_E1M5);
	relic_addtoslot(self, RL_E2M1);
	relic_addtoslot(self, RL_E2M2);
	relic_addtoslot(self, RL_E2M3);
	relic_addtoslot(self, RL_E2M4);
	relic_addtoslot(self, RL_E2M5);
};
void()ViciousIdol_selected;
void()debugger_particles_think
{
	pointparticles(self.cnt,self.origin,'0 0 0',32);
	//single_player.SoulTether = self.cnt;
	self.cnt ++;
	//(float effectnum, vector org, vector vel, float howmany) pointparticles
	if(self.cnt > 210)
		remove(self);
	else
	{
		local string viewxanglesfactor;
		viewxanglesfactor = strcat ((ftos (self.cnt)), (" particlecount\n"));
		bprint (viewxanglesfactor);
		self.think = debugger_particles_think;
		self.nextthink = time + 0.1;
	}
};
void()recount_alive_monsters;
void()generate_map_chain;
void()debug_particles =
{
	entity debugger_particles = spawn();
	debugger_particles.origin = self.origin;
	debugger_particles.think = debugger_particles_think;
	debugger_particles.nextthink = time;
};

void()debug_particle =
{
	float particlenumber = cvar("particlenumber");
	makevectors (self.angles);

	pointparticles(particlenumber,self.origin + v_forward * 48 ,'0 0 0',32);
		local string viewxanglesfactor;
		viewxanglesfactor = strcat ((ftos (particlenumber)), (" particlecount\n"));
		bprint (viewxanglesfactor);
};

void()debug_particle_increase =
{
	float particlenumber = cvar("particlenumber");
	particlenumber ++;
	stuffcmd(self,strcat("set particlenumber ",ftos(particlenumber),"\n"));
	makevectors (self.angles);

	pointparticles(particlenumber,self.origin + v_forward * 48 ,'0 0 0',32);
		local string viewxanglesfactor;
		viewxanglesfactor = strcat ((ftos (particlenumber)), (" particlecount\n"));
		bprint (viewxanglesfactor);
};

void() mark_monsters =
{
	 entity alivemonster;
	alivemonster = nextent(world);
	float monster_counter_alive;
	float spawner_counter_alive;

	while (alivemonster)	//Loops through everything put in the missile entit
	{
		entity holder = nextent(alivemonster);
		if (((alivemonster.flags &FL_MONSTER) && (alivemonster.health > 0)) || ((alivemonster.wrathflags &FL_SPAWNER)))
		{
			local entity tether_mark;
			tether_mark = spawn();
			if(alivemonster.wrathflags &FL_SPAWNER)
			{
				if(alivemonster.local_classmonster <= 0)
					tether_mark.color = '0 0 1';

				spawner_counter_alive ++;
			}
			else
			{
				{
					if(alivemonster.enemy != world)
						tether_mark.color = '1 0 0';
					else
						tether_mark.color = '1 0.5 0 ';
				}
				monster_counter_alive ++;
			}
			tether_mark.colormod = tether_mark.color;
			tether_mark.light_lev = 75;
			tether_mark.pflags = 129;
			tether_mark.style = 6;
			tether_mark.classname = "monstermark";
			tether_mark.scale = 20;
			tether_mark.effects = EF_ADDITIVE + EF_NODEPTHTEST + EF_DOUBLESIDED;
			setmodel(tether_mark, "models/artifacts/effects/revelation_particle.md3");
			setorigin(tether_mark, alivemonster.origin);
			tether_mark.movetype = MOVETYPE_FOLLOW; // make the hole follow
			tether_mark.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
			tether_mark.aiment = alivemonster; // make the hole follow bmodel
			tether_mark.punchangle = alivemonster.angles; // the original angles of bmodel
			tether_mark.view_ofs = tether_mark.origin - alivemonster.origin; // relative origin
			tether_mark.v_angle = tether_mark.angles - alivemonster.angles; // relative angles
			tether_mark.think = SUB_Remove;
			tether_mark.nextthink = time + 10;

		}
		alivemonster = holder;
	}
	
	/*entity alivemonster = nextent(world);
	while (alivemonster)	
	{
		entity holder = nextent(alivemonster);
		if ((alivemonster.classname == "monster_symbol") && (alivemonster.health > 0))
		{
			entity looper_sound = spawn();
			looper_sound.owner = alivemonster;
			looper_sound.think = alivemonster_think;
			looper_sound.nextthink = time + 0.25;
		}

		alivemonster = holder;	
	}*/
	centerprint(self,strcat(ftos(monster_counter_alive),": alive monsters.\n",ftos(spawner_counter_alive),": active spawners."));
};
void()item_donor_mapforcethink;

void() fixitems = 
{ 
	local entity wrathitems;
	wrathitems = nextent(world);
	while (wrathitems)
	{
		entity holder = nextent(wrathitems);
		if ((wrathitems.wrathflags & FL_PICKUPABLE) && ((wrathitems.oldenemy.classname != "bbox_touch") || (wasfreed(wrathitems.oldenemy))))
		{
			setorigin(wrathitems,wrathitems.origin + '0 0 1');
			wrathitems.solid = SOLID_TRIGGER;	
			setsize2(wrathitems, helm_nsize, helm_size);
			wrathitems.touch = wrathitems.th_melee;
		}
		wrathitems = holder;
	}
};

void() ImpulseCommands = 
{ 
	if (self.lspeedtime > time)
		return;
	if (self.impulse == 10)
		raise_vmodel();
	if (self.impulse == 16)
		prevtartifact();
	if (self.impulse == 17)
		nextartifact();
	if (self.impulse == 85)
	get_texture_name();
	if (self.impulse == 155)
	{
		rmtree("profiles");
		//copy_save_maps (0);
	}
	if (self.impulse == 160)
		jason_mode();
	if (self.impulse == 161)
		fixitems();
	if (self.impulse == 191)
		mark_revelation();
	if (self.impulse == 192)
		BlackGrenade_selected();
	if (self.impulse == 193)
		ViciousIdol_selected();
	if (self.impulse == 176)
	debug_particle_increase();
	if (self.impulse == 177)
	recount_monsters();
	if (self.impulse == 178)
	debug_particle();
	if (self.impulse == 179)
	debug_particles();
	if (self.impulse == 181)
	{
		ShockWave_selected();
		//self.flame_time = time +3;
	}
	if (self.impulse == 182)
	{
		self.displacement_time = time + 10;
		self.displacement_active = 2;
	}
	if (self.impulse == 183)
	{
		self.wrath_time = time + 30;
		self.wrath_active = 1;
		local entity destructwrath;
		destructwrath = nextent(world);
		while (destructwrath)	
		{
			entity holder = nextent(destructwrath);
			if((destructwrath.classname == "func_destruct") && (destructwrath.wrath_active == 1))
			{
				destructwrath.takedamage = DAMAGE_YES;
				destructwrath.glowmod = '1 1 1';
				destructwrath.wrath_active = 2;
			}
			destructwrath = holder;	
		}


	}

	if (self.impulse == 185)
	{

		if(self.radial_time > time)
		{
		self.Aegis_time = 0;  self.LifeSiphon_time = 0;  self.DrownerApp_time = 0;  self.Tether_time = 0;
		self.radial_time = 0;
		}

		self.displacement_time = time + 20;
		self.displacement_active = 2;
	}
	if(self.impulse == 186)
		mark_monsters();

	if(self.impulse == 194)
		write_dummy_file();
	if(self.impulse == 195)
	{
		if (self.noattack == 1)
		{
			self.noattack = 0;
			bprint ("no attack OFF\n");
		}
		else
		{
			bprint ("no attack ON\n");
			self.noattack = 1;
		}
	}
	if(self.impulse == 196)
	{
		recount_spawner_monsters(0);
		recount_spawner_monsters(1);
		recount_spawner_monsters(2);
		recount_spawner_monsters(3);
		recount_spawner_monsters(4);
		recount_spawner_items();
		recount_alive_monsters();

	}
	if(self.impulse == 197)
		delebboxesandrespawnthem();
	if(self.impulse == 198)
	{
		float deletedqng = nodegraph_graphset_remove();
		if (deletedqng == 1)
			bprint ("deleted qng file\n");
		else
			bprint ("qng file not found\n");
	}
	if (self.impulse == 199)		
	{
		killemall();
		self.impulse = 0;
	}

	if ((time < self.attack_finished) | (self.button3) | (self.button0))
	{
		if (self.modeeditor != 1)
		{
			self.impulse = 0;
			return;
		}
	}
	//	if (self.impulse >= 1 && self.impulse <= 9)
	//		W_ChangeWeapon (0);
	/*	if (self.impulse == 10)
		{
			if (globalfake_illumination == 1)
				{globalfake_illumination = 0; sprint (self, "fake illumination OFF.\n");}
			else
				{globalfake_illumination = 1; sprint (self, "fake illumination ON.\n");}
			self.impulse = 0;
		}*/
	if(self.impulse == 97)
		giveme_oldrelics();
	if(self.impulse == 70)
		item_donor_mapforcethink();
	if(self.impulse == 98)
		giveme_relics();
	if (self.impulse == 99)
	{
		//self.darmorvalue = 100;
		self.rarmorvalue = 100;
		if (!(self.items &IT_REVOLVER))
			self.items += IT_REVOLVER;
		if (!(self.items &IT_SPITTER))
			self.items += IT_SPITTER;
		if (!(self.items &IT_RETCHER))
			self.items += IT_RETCHER;
		if (!(self.items &IT_SHOTGUN))
			self.items += IT_SHOTGUN;
		if (!(self.items &IT_MELEE))
			self.items += IT_MELEE;
		if (!(self.items &IT_CANNON))
			self.items += IT_CANNON;
		if (!(self.items &IT_LANCE))
			self.items += IT_LANCE;
		if (!(self.items &IT_CRYSTAL))
			self.items += IT_CRYSTAL;
		if (!(self.items &IT_MACE))
			self.items += IT_MACE;
		self.ammo_revolver = max_ammo_revolver;
		self.ammo_shotgun = max_ammo_shotgun;
		//self.ammo_bombs = 250;
		self.ammo_spitter = max_ammo_spitter;
		self.ammo_cannon = max_ammo_cannon;
		self.ammo_retcher = max_ammo_retcher;
		self.ammo_lance = max_ammo_lance;
		self.ammo_crystal = max_ammo_crystal;
		self.ammo_bfg = 10;
		self.SoulTether += 1;
		self.LifeSiphon += 1;
		self.TrinketofRespite += 1;
		self.Attar += 1;
		self.Aegis += 1;
		self.flaskrage += 1;
		self.DrownerApp += 1;
		self.MarkRevelation +=1;
		self.BlackGrenade +=1;
		self.ViciousIdol +=1;
		self.ShockWave +=1;
		self.revolverclip = 3;
		//self.tdsouls = 7;
		//check_transformation();
		//self.bfg = 1;
	}
	if (self.impulse == 11)
	{
		flash_toggle();
			//node_debug();
			//node_debug_think();
		if (!self.wrath_debug_screen)
			{
			self.wrath_debug_screen = 1;
			test_ia = 1;
			}
		else
			{
			self.wrath_debug_screen = 0;
			test_ia = 0;
			}
	}
	if (self.wrath_debug_screen == 1)
	{
		if (self.impulse == 12)
			W_FireFmonster();
	}
	if (self.impulse == 52)
		Toggle_HUD();
	if (self.impulse == 34)
		reload_retcher();
	if (self.impulse == 80)
	{
		if (self.spitterloop == 1)
			self.spitterloop = 0;
		else
			self.spitterloop = 1;
	}
	//if(self.impulse == 83)
	//FireAttar();
	if (self.impulse == 89)
	{
	if(!self.deadmenuflag)
	self.deadmenuflag = 1;
	else
	self.deadmenuflag = 0;
	
	}
	if (self.impulse == 90)
	{
	if(self.deadmenuflag == 1)
	self.deadmenuflag = 0;	
	}
	if (self.impulse == 36)
		empty_reload_shotgun();
	float developer = cvar("developer");
	if ((self.impulse == 235))		
	{
		removetriggers();
		self.impulse = 0;
	}
	if ((self.impulse == 208) && (developer == 1))
		Toggle_Mode();

	if ((self.impulse == 236)&& (developer == 1))		
	{
		killemall2();
		self.impulse = 0;
	}
	if ((self.impulse == 237))		
	{
		generate_map_chain();
		self.impulse = 0;
	}
	if ((self.impulse == 238))		
	{
		removeitems();
		self.impulse = 0;
	}
	if ((self.impulse == 239))		
	{
		removefuncs();
		self.impulse = 0;
	}
	if (self.modeeditor == 1)
	{
		if (self.impulse == 27)
			Check_Editor_Commands(1);
		if (self.impulse == 26)
			Check_Editor_Commands(-1);
		if (self.impulse == 209)
			Toggle_Angles();
		if (self.impulse == 210)
			Toggle_ShadowLights();
		if (self.impulse == 211)
			Toggle_NormalLights();
	}

	/*
		if(self.impulse == 60)
		{
		local string sorete;
		local float fsorete;
		fsorete = fcopy("data.sav","datacopy.sav");
		sorete = ftos (fsorete);
		sprint (self,sorete);
		bprint (sorete);
		}
		if(self.impulse == 58)
		frename("data.sav","datacopyname.sav");
		if(self.impulse == 59)
		fremove("data2.sav");
	*/
	self.impulse = 0;
};
.float itemtime;
void() WeaponSounds = 
{ 
    if (self.weapon == IT_SPITTER)
	{
		if (self.spitterloop == 1)
			return;
		if (self.pickup_spitter)
			return;
		if ((self.button0) && (self.ammo_spitter > 0))
		{
			if (self.timesound < time)
			{
				sound(self, CHAN_WEAPON2, "weapons/spitter/fire1_loop.wav", 1, ATTN_NORM);
				self.timesound = time + (soundlength("weapons/spitter/fire1_loop.wav"));
			}
		}
		else
		{
			if ((time < self.timesound))	//&& (self.attack_finished < time))
			{
				//sound (self, CHAN_WEAPON, "weapons/spitter/fire1_loop.wav", 0,ATTN_NORM);
				sound(self, CHAN_WEAPON2, "weapons/spitter/fire1_release.wav", 1, ATTN_NORM);
				self.timesound = 0;
				return;
			}
		}
	}
};
.float fieldcreated;
.float melee_ammount;
void() w_melee_prerelease;
void() vgearframes = { if (self.vgearframetime > time)
		return;
	if (self.vgearframe >= 15)
		self.vgearframe = 0;
	else
		self.vgearframe += 1;
	self.fvgeartime += 0.05;
	self.vgearframetime = time + self.fvgeartime;
};
void()ws_release_fire;
.float flightimesnd;
.float flightflag;
void() flight_sound = 
{ 
	if (self.timefly > time)
	{
		if (self.flightimesnd < time)
		{
			sound (self, CHAN_ITEM, "items/sigils/sigil_flight_active.ogg", 1, ATTN_NORM);
			self.flightimesnd = time + (soundlength ("items/sigils/sigil_flight_active.ogg"));
		}
	}
	else
	{
		sound (self, CHAN_ITEM, "items/sigils/sigil_flight_end.ogg", 1, ATTN_NORM);
		self.flightflag = 0;
		self.flightimesnd  = 0; 
	}
};
.float melee_lunge;
.float impulsetime;
//void() check_stunned_monsters;
void() glow_melee = { local float gd;
	if (!(self.melee_kills))
	{
		self.vweaponglowmod = '-1 -1 -1';
		return;
	}
	if (self.melee_kills == 1)
		gd = 0.002;
	if (self.melee_kills == 2)
		gd = 0.004;
	if (self.melee_kills == 3)
		gd = 0.008;
	if (self.melee_kills == 4)
		gd = 0.016;
	self.vweaponglowmod_x -= gd;
	self.vweaponglowmod_y -= gd;
	self.vweaponglowmod_z -= gd;
	self.tdsouls_time = time + 0.05;
};
void() glow_melee_uber = { local float gd;
	gd = 0.007142857;
	self.vweaponglowmod_x -= gd;
	self.vweaponglowmod_y -= gd;
	self.vweaponglowmod_z -= gd;
	self.tdsouls_time = time + 0.05;
};
.float timezoom;
.float macemeleeskin_time;
.float macemeleeskin;
.float meleeskin;
.float meleeskin_time;
.float timezoomframe;
.float timezoomframesec;
.float reloadimpulse;
.float oldimpulse;
void(float mtype, vector org, entity ownr) Hud_message_delay;
void() zoom_shotgun;
void() Fix_weapons =
{
	float hasbug; 
	self.lastweapon = self.weapon;
	if ((self.weapon == IT_MELEE)&& (self.vweapon.model != "models/weapons/melee/v_gauntlet.md3"))
	hasbug = 1;
	if ((self.weapon == IT_REVOLVER) && (self.vweapon.model != "models/weapons/revolver/v_revolver.md3"))
	hasbug = 1;
	if ((self.weapon == IT_SHOTGUN) && (self.vweapon.model != "models/weapons/shotgun/v_shotgun.md3"))
	hasbug = 1;
	if ((self.weapon == IT_RETCHER) && (self.vweapon.model != "models/weapons/retcher/v_retcher.md3"))
	hasbug = 1;
	if ((self.weapon == IT_SPITTER) && (self.vweapon.model != "models/weapons/spitter/v_spitter.md3"))
	hasbug = 1;
	if ((self.weapon == IT_CANNON) && (self.vweapon.model != "models/weapons/cannon/v_cannon.md3"))
	hasbug = 1;
	if ((self.weapon == IT_LANCE) && (self.vweapon.model != "models/weapons/lance/v_lance.md3"))
	hasbug = 1;
	if ((self.weapon == IT_CRYSTAL) && (self.vweapon.model != "models/weapons/lance/v_lance.md3"))
	hasbug = 1;
	if ((self.weapon == IT_MACE)&& (self.vweapon.model != "models/weapons/melee/v_gauntlet.md3"))
	hasbug = 1;
	if(hasbug)
	{
		W_SetWeapon();
	}
};
void() get_texture_name =
{
	makevectors(self.v_angle);
	vector source = self.origin + '0 0 24' - v_forward * 8;
	traceline(source, source + v_forward *1024, FALSE, self);
	if (trace_fraction == 1.0)
	{
		return;
	}
	vector org = trace_endpos - v_forward * 4;
	float bparticle = particleeffectnum("darkarmorfragment");
	pointparticles(bparticle, org, '0 0 0', 1);
	centerprint(self,trace_dphittexturename);
};
void()trigger_artifact_checker_think;
void(float ty) trigger_all_artifact_checkers =
{
	local entity e;
	e = nextent(world);
	while (e)
	{
		if ((e.classname == "trigger_artifact_checker")&& (e.type == ty) )
		{
			
			{
			e.think = trigger_artifact_checker_think;
			e.nextthink = time;
			}
		}
		e = nextent(e);
	}
};
void()trigger_soultether_checker_think;
void(entity who) trigger_all_soultether_checkers =
{
	for(entity e = nextent(world); e; e = nextent(e))
	{
		if (e.classname != "trigger_soultether_checker")
			continue;
		
		e.owner = who;
		e.think = trigger_soultether_checker_think;
		e.nextthink = time;
	}
};
void()Test_Sound;
.float testsoundflag;

void() WeaponFrames = 
{ 
	if(self.impulse == 100)
	{
		self.SoulTether ++;
		self.impulse = 0;
	}
	if(self.impulse == 187)
	{
		dprint("^3-- BEGIN ENTITY LIST --\n");
		entity lst = world;
		while(lst = nextent(lst))
		{
			dprint(sprintf(" %s %.0f\n", lst.classname, num_for_edict(lst)));
		}
		dprint("^3--  END ENTITY LIST  --\n");
		self.impulse = 0;
	}
	if(self.impulse == 188)
	{
		sound7(self, CHAN_AUTO, "items/artifacts/artifactA_pickup.ogg", 0.2, 0.25,200,0);
		self.impulse = 0;
	}

	if((time > pingtimerefresh) && (self.journal == 1) && (deathmatch == 1))
	{
		localcmd("pings\n");
		pingtimerefresh= time + 1.25;
	}
	if(self.impulse == 101)
	{
		if(!(self.items &IT_MELEE))
		{
			self.items += IT_MELEE;
			self.weapon = IT_MELEE;
			W_SetWeapon();
			pick_up_melee();
			return;
		}
		self.impulse = 0;
	}
	local struct data;
	if(self.node_editor == 1)
		placing_nodes();
	WeaponSounds();
	

	if(self.impulse == 82)
	{	
		self.check_centered = 1;
	}
	if(self.check_centered == 1)
	{
		Check_FrikFile();
		W_SetWeapon ();
		self.impulse = 0;
		self.check_centered = 0;
	}
	if(self.impulse == 84)
		check_infinite_saves();
	if(self.impulse == 83)
		check_custom_cvars();
	if (self.impulse == 190)
		Exit_Game();
	if((self.impulse == 81) && (time > self.totallungetime))
	{	
		float localsoultether = self.SoulTether;
		float infinitesaves = cvar("infinite_saves");
		if(infinitesaves == 1)
			localsoultether = 1;
		if(( localsoultether >= 1) && (self.tether_global < time))
		{
			tether_org = self.origin;
			write_tether();
			message_garbage_collector ();

			if (infinitesaves != 1) // Reki (July 17 2023): achievement logic, but only if we're not using infinite saves
				Steam_StatIncrement(self, ST_STATS::saved_tethers, 1);
		
			if (!(self.centerprint_messages &8)) 
			{
				self.centerprint_messages += 8;
				//Hud_message(261, self.origin, self);
				//Hud_SendNotification_Control(self, "HELP_LOADGAME"), "impulse 89";
				centerprint(self, "$HELP_LOADGAME");
			}
			//else
			Hud_message_delay(24, self.origin, self);
		}
		self.impulse = 0;
	}
		
	if ((!self.button6) && (self.rmenu == 1))
		self.rmenu = 0;
	if ((self.lspeedtime > time + 0.15) && ((self.button0) || (self.button5)|| (self.button3)|| (self.impulse >= 1 && self.impulse <= 9)))
	{
		quickmovement();
		if (self.weapon == IT_SHOTGUN)
			sound(self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);
		self.lspeedtime = time + 0.14;
		if((self.impulse >= 1 && self.impulse <= 9) || (self.button5))
			self.lspeedtime = 0;
	}
	if (self.impulse == 200)
	{
		self.impulse = 0;
	}
	if (self.impulse == 201)
	{
		if (self.node_editor ==  1)
			self.node_editor = 0;
		else
			self.node_editor = 1;
		self.impulse = 0;
	}
	if (self.impulse == 202)
		place_node();
	if (self.impulse == 203)
		delete_nearest_node();
	if (self.impulse == 204)
	{	
		write_node_map();
		writed_map = 1;
	}
	if (self.impulse == 205)
	{	
		write_node_map();
		writed_map = 0;
	}
	if (self.impulse == 206)
		check_enemies_frik();
	if (self.lspeedtime > time)
	{
		if(self.sigil_time > time)
		{
			if (self.timefly > time)
				self.artifacttime = 142 - (floor(((self.timefly) - time) * (142 / self.takenflytime)));
			if (self.displacement_time > time)
				self.artifacttime = 142 - (floor(((self.displacement_time) - time) * (142 / self.takendisplacement_time)));
			if (self.wrath_time > time)
				self.artifacttime = 142 - (floor(((self.wrath_time) - time) * (142 / self.takenwrath_time)));
		}
		if (self.radial_time > time)
		{
				self.artifacttime = 142 - (floor(((self.radial_time) - time) *6.8));
			//if (self.Aegis_time > time)
			//	self.artifacttime = 142 - (floor(((self.radial_time) - time) *9.466)); // 15 seconds
			if (self.flaskrage_time > time)
				self.artifacttime = 142 - (floor(((self.radial_time) - time) *6.8));
		}
			return;
	}
	if ((self.itemtime > time))
	{
		if (self.oldimpulse == 0)
			return;
		if (self.impulse)
			self.impulse = 0;
		self.maxspeed = 1;
		if (self.gravity < 0)
			self.gravity = 1;
		if (self.melee_ammount > 0)
			self.melee_ammount = 0;
		self.melee_lunge = 0;
		if (self.noshake == 1)
			self.noshake = 2;
		if (self.oldimpulse == 2)
			self.impulse = 2;
		if (self.oldimpulse == 3)
			self.impulse = 3;
		if (self.oldimpulse == 4)
			self.impulse = 4;
		if (self.oldimpulse == 5)
			self.impulse = 5;
		if (self.oldimpulse == 6)
			self.impulse = 6;
		if (self.oldimpulse == 7)
			self.impulse = 7;
		if (self.oldimpulse == 8)
			self.impulse = 8;
		if (self.oldimpulse == 9)
			self.impulse = 9;
		self.oldimpulse = 0;
		W_ChangeWeapon();
		return;
	}
	if (self.itemtime > time)
		return;
	if ((self.rmenu != 1) && (!self.journal)  && (time > (self.switch_finished))) 
	{

		if (self.impulse == 55)
			nextweapon();
		if (self.impulse == 56)
			prevweapon();
	}

	if ((self.impulse == 57) && (time > (self.switch_finished)))
	{
		self.melee_lunge = 0;
		if ((self.rmenu != 1) && (!self.journal))
			select_lastweapon();
	}
	//	if(self.radial_time <= 0.1)
	//	self.radialactive = 0;
	if (self.tether_global > time)
	{
		self.tethertime = 142 - (floor(((self.tether_global) - time) *6.8));
	}
	else
	{
		if (self.tethertime != 0)
		{
			self.tethertime = 0;
		}
	}	
	

	if(self.sigil_time > time)
	{
		if (self.timefly > time)
			self.artifacttime = 142 - (floor(((self.timefly) - time) * (142 / self.takenflytime)));
		if (self.displacement_time > time)
			self.artifacttime = 142 - (floor(((self.displacement_time) - time) * (142 / self.takendisplacement_time)));
		if (self.wrath_time > time)
			self.artifacttime = 142 - (floor(((self.wrath_time) - time) * (142 / self.takenwrath_time)));
	}
	else	
	{
		if (self.radial_time > time)
		{
				self.artifacttime = 142 - (floor(((self.radial_time) - time) *6.8));
			//if (self.Aegis_time > time)
			//	self.artifacttime = 142 - (floor(((self.radial_time) - time) *9.466)); // 15 seconds
			if (self.flaskrage_time > time)
				self.artifacttime = 142 - (floor(((self.radial_time) - time) *6.8));
		}
		else
		{
			if (self.artifacttime != 0)
			{
				float autoswitch = cvar("scratch2");	
				if (self.radialactive == 1)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactA_end.ogg", 1, 0.25);
					if(!self.MarkRevelation)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}
				if (self.radialactive == 2)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactB_end.ogg", 1, 0.25); 
					if(!self.DrownerApp)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}
				if (self.radialactive == 3)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactC_end.ogg", 1, 0.25); 
					if(!self.flaskrage)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}

				}
				if (self.radialactive == 4)
				{
					if(!self.Attar)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}
				if (self.radialactive == 5)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactE_end.ogg", 1, 0.25);
					if(!self.BlackGrenade)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}
				if (self.radialactive == 6)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactF_end.ogg", 1, 0.25);
					if(!self.LifeSiphon)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}
				if (self.radialactive == 7)
				{
					if(!self.TrinketofRespite)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}
				if (self.radialactive == 8)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactH_end.ogg", 1, 0.25);
					if(!self.Aegis)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}			
				if (self.radialactive == 9)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactH_end.ogg", 1, 0.25);
					if(!self.ViciousIdol)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}			
				if (self.radialactive == 10)
				{
					sound(self, CHAN_AUTO, "items/artifacts/artifactH_end.ogg", 1, 0.25);
					if(self.ShockWave <= 0)
					{
						if(autoswitch == 1)
							nextartifact();			
						else
							self.radialactive = 0;
					}
				}			
				self.artifacttime = 0;
			}
		}
	}
	if (self.weapon == IT_SHOTGUN)
	{
		if ((time > self.timezoomframe) && (self.shotgun_fire1 != 1) && (self.ammo_shotgun >= 1))
		{
			if ((self.button3) && (time > self.timezoom))
			{
				if (self.charge_shotgun > self.charge_shotgun_count)
					self.charge_shotgun -= 0.004;
				if (self.charge_shotgun < self.charge_shotgun_count)
					self.charge_shotgun = self.charge_shotgun_count;
				if (self.vweaponglowmod_x <= 0)
				{
					self.vweaponglowmod_x = 0.02;
					self.vweaponglowmod_y = 0.02;
					self.vweaponglowmod_z = 0.02;
				}
				if ((self.vweaponglowmod_x <= 1) && (self.vweaponglowmod_x >= 0))
				{
					self.vweaponglowmod_x += 0.01;
					self.vweaponglowmod_y += 0.01;
					self.vweaponglowmod_z += 0.01;
				}
			}
			else
			{
				if (self.charge_shotgun < 1)
					self.charge_shotgun += 0.05;
				if (self.charge_shotgun > 1)
					self.charge_shotgun = 1;
				if (self.vweaponglowmod_x >= 0.01)
				{
					self.vweaponglowmod_x -= 0.025;
					self.vweaponglowmod_y -= 0.025;
					self.vweaponglowmod_z -= 0.025;
				}
				else
				{
					self.vweaponglowmod_x = -0.1;
					self.vweaponglowmod_y = -0.1;
					self.vweaponglowmod_z = -0.1;
				}
			}
			self.timezoomframe = time + 0.01;
		}
	}
	if ((self.weapon != IT_SHOTGUN) && (self.timezoom != 1))
		self.timezoom = 1;
	if (self.weapon != IT_MELEE)
	{
		if ((time > self.meleeskin_time) && (self.meleeskin))
			self.meleeskin = 0;
	}
	if (self.weapon != IT_MACE)
	{
		if ((time > self.macemeleeskin_time) && (self.macemeleeskin))
			self.macemeleeskin = 0;
	}
	if(self.hasmelee == 1)
	{
		if ((time > self.tdsouls_time) && (self.weapon == IT_MELEE) && (!self.melee_charging) && (!self.melee_kill_uber))
			glow_melee();
		if ((self.melee_kill_uber) && (time > self.tdsouls_time) && (self.weapon == IT_MELEE))
			glow_melee_uber();
	}
	if (self.weapon == IT_MELEE)
	{
		if ((self.melee_kills) && (self.melee_kill_time < time))
		{
			self.melee_kills = 0;
			self.melee_kill_uber = 0;
			self.vweaponskin = 0;
		}
	}
	if (self.modeeditor == 1)
		ImpulseCommands();
	if (self.fall_state == TRUE)
		return;
	if((self.reloadimpulse) && (!self.realoding))
		{
			self.impulse = self.reloadimpulse;
			self.reloadimpulse = 0;
			W_ChangeWeapon();
		return;
		}
	if ((self.impulse >= 1 && self.impulse <= 9)&& (time > (self.switch_finished)))
	{
		self.maxspeed = 1;
		if (self.gravity < 0)
			self.gravity = 1;
		if((self.realoding))
		{	
			self.reloadimpulse = self.impulse;
			local string viewxanglesfactor;
			viewxanglesfactor = strcat ((ftos (self.reloadimpulse)), (" oldimpulse\n"));
			bprint (viewxanglesfactor);
		}	
		if (time < self.lastweapontime)
		{
			self.impulse = 0;
			return;
		}
		if (time < self.impulsetime) 
		{
			self.impulse = 0;
			return;
		}
		if (self.melee_ammount > 0)
			self.melee_ammount = 0;
		self.melee_lunge = 0;
		
		W_ChangeWeapon();
		self.impulsetime = time + 0.25;
		if (self.noshake == 1)
			self.noshake = 2;
	}
	if (self.flightflag > 0)
		flight_sound();
	if (self.vgeartime > time)
		vgearframes();

	if (time > self.use_finished)
	{
		if (self.button5)
		{
			if (self.luse)
				return;
			Use_Func();
			self.luse = 1;
		}
		else
		{
			if (self.luse)
				self.luse = 0;
		}
	}
	if((self.button6) && (time < self.sigil_time)) 
		Hud_CantUseArtifactNotification(self);		

	if((self.impulse == 15) && (time < self.sigil_time)) 
	{
		Hud_CantUseArtifactNotification(self);		
		self.impulse = 0;
	}
	if (self.impulse == 35)
		Toggle_Journal();
	if ((self.realoding == 1) || (time > self.attack_finished)) 
	{
		if ((time > self.radial_time)&& (time > self.sigil_time) && (time > self.timefly))
		{
			if (self.modeeditor != 1)
			{
				if ((self.button6) && (self.rmenu != 1) && (self.journal == 0) && (!self.button3))
					Rinventory();
			}
			if (self.impulse == 15 && self.rmenu == 0)
			{
				if (self.artifact_model_client <= 0)
				{
					if (self.radialactive == 1)
						{mark_revelation();trigger_all_artifact_checkers(1);}
					if (self.radialactive == 2)
						{Drowner_selected();trigger_all_artifact_checkers(2);}
					if (self.radialactive == 3)
						{flaskrage_selected();trigger_all_artifact_checkers(3);}
					if (self.radialactive == 4)
						{Attar_selected();trigger_all_artifact_checkers(4);}
					if (self.radialactive == 5)
						{BlackGrenade_selected();trigger_all_artifact_checkers(5);}
					if (self.radialactive == 6)
						{LifeSiphon_selected();trigger_all_artifact_checkers(6);}
					if (self.radialactive == 7)
						{TrinketofRespite_selected();trigger_all_artifact_checkers(7);}
					if (self.radialactive == 8)
						{Aegis_selected();trigger_all_artifact_checkers(8);}
					if (self.radialactive == 9)
						{ViciousIdol_selected();trigger_all_artifact_checkers(9);}
					if (self.radialactive == 10)
					{
						ShockWave_selected();
						trigger_all_artifact_checkers(10);
					}
				}
			}
			if ((self.rmenu == 0) && (self.radial_time < time))
			{
				float old_radial = self.radialactive;
				if ((self.impulse >= 21) && (self.impulse <= 30))
					self.radialactive = 0;
				if (self.impulse == 21 && self.MarkRevelation > 0)
					self.radialactive = 1;
				if (self.impulse == 22 && self.DrownerApp > 0)
					self.radialactive = 2;
				if (self.impulse == 23 && self.flaskrage > 0)
					self.radialactive = 3;
				if (self.impulse == 24 && self.Attar > 0)
					self.radialactive = 4;
				if (self.impulse == 25 && self.BlackGrenade > 0)
					self.radialactive = 5;
				if (self.impulse == 26 && self.LifeSiphon > 0)
					self.radialactive = 6;
				if (self.impulse == 27 && self.TrinketofRespite > 0)
					self.radialactive = 7;
				if (self.impulse == 28 && self.Aegis > 0)
					self.radialactive = 8;
				if (self.impulse == 29 && self.ViciousIdol > 0)
					self.radialactive = 9;
				if (self.impulse == 30 && self.ShockWave > 0)
					self.radialactive = 10;
				if (self.radialactive && self.radialactive != old_radial)
					stuffcmd(self, "pulseartifact\n");
				if ((!(self.centerprint_messages & 2)) && (self.radialactive > 0))
				{
					//Hud_message(257, self.origin, self);
					//Hud_SendNotification_Control(self, "HELP_ARTIFACT"), "impulse 15";
					centerprint(self, "$HELP_ARTIFACT");
					self.centerprint_messages += 2;
				}
			}
		}
	}
	if ((self.button3)&& (self.weapon == IT_LANCE) && (self.fieldcreated != 1))
	{
		Fix_weapons();
		Weapon_Sfire();
	}
	if ((!self.button3) && (self.weapon == IT_LANCE) && (self.fieldcreated == 1))
	{
		self.fieldcreated = 0;
	}	
	if ((time < self.attack_finished) || (self.button6))
	{		
		if (self.impulse)
			self.impulse = 0;
		return;
	}
	if (self.deadflag)
		return;
	if (self.rmenu == 1)
		return;
	if (self.modeeditor == 1)
		return;
	if (self.button3)
	{
		//if ((self.button0)&& (self.weapon != IT_LANCE))
		//	return;
		if(self.journal == 1)
			return;
		if (self.noammobutton2 == 1)
			return;
		if(self.deadmenuflag == 1)
			return;



		Fix_weapons();
		Weapon_Sfire();
	}
	else
	{
		//if(self.lance_viewzoom_time > time)
		//self.lance_viewzoom_time = 0;
		if (self.noammobutton2 == 1)
			self.noammobutton2 = 0;
		self.wlightning = 0;
		if ((self.weapon == IT_MELEE) && (self.melee_lunge > 0))
		{
			self.melee_jump_time = time + 0.25;
			self.maxspeed = 1;
			self.attack_finished = time + 0.5;
			w_melee_prerelease();
			return;
		}
		//self.ssemi = 0;			
	}
	if(self.weapon == IT_MACE)
	{
		if (self.ammo_bfg < 1)
			self.vweaponglowmod = '-1 -1 -1';
		if (self.ammo_bfg == 1)
			self.vweaponglowmod = '0.2 0.2 0.2';
		if (self.ammo_bfg == 2)
			self.vweaponglowmod = '0.4 0.4 0.4';
		if (self.ammo_bfg == 3)
			self.vweaponglowmod = '0.6 0.6 0.6';
		if (self.ammo_bfg == 4)
			self.vweaponglowmod = '0.8 0.8 0.8';
		if (self.ammo_bfg >= 5)
		{
			self.vweaponglowmod = '1 1 1';
		}
	}
	if (self.button0)
	{
		if (time < self.attack_finished)
			return;
		if ((self.button3) && (self.weapon != IT_LANCE))
			return;
		if (self.draw_w != 0)
			return;
		if (self.noammobutton == 1)
			return;
		if(self.deadmenuflag == 1)
			return;
		Fix_weapons();


	if(world.model != "maps/testsound.bsp")
		Weapon_Fire();
	else
		Test_Sound();

	}
	else
	{
		if (self.noammobutton == 1)
			self.noammobutton = 0;
		if ((self.vgearrelease == 1))
		{
			self.vgeartime = time + 0.35;
			self.vgearrelease = 0;
		}
		//if (time > self.attack_finished)
		//self.semi = 0;	
		if(self.testsoundflag == 1)
			self.testsoundflag = 0;
	}
	if ((self.impulse) && (!self.button3) && (!self.button0) && (!self.bomb_velocityfactor))
	{
		if (self.modeeditor != 1)
		{
			if (!self.button3)
				ImpulseCommands();
		}
		else
			ImpulseCommands();
	}
};
///////////////////////////////////end of qc file
