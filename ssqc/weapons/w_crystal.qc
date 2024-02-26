
.float randomattack;
.float oldrandomattack;
.float wsfire_crystal_time_charging;
.float wsfire_crystal_time;
.entity beam_muzzle;
.float crystal_frame_time;
.float crystal_frame;
.float spawnedcrystal;
.float gibcount;
.float base_scale;

void() idle_crystal = 
{ 
	self.pipes.vweaponstate = 1;
	self.crystal_frame = 0;
	self.spawnedcrystal = 0;	
	self.crystal_frame_time = 0;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.vweaponstate = 0;
	self.vweaponframe = 0;
};

.float beam_lenght;
.entity lastbeam;
.float beam_counter;
.entity lastbeam_view;
.float beam_counter_view;

void(entity e)sub_beam2;

void(entity e)sub_beam2 =
{

};
.float crystallized_time;
.float crystallized;
.float oldtakedamage;
.void()oldth_stand;
.void()oldth_walk;
.void()oldth_run;
.void()oldth_missile;
.void()oldth_melee;
.void(entity a, float b)oldth_pain;
.float oldflags;
.float old2movetype;
.string oldclassname;
.string oldclassentity;
.float oldbeamangles_random;
.float beamangles_random;
.float beamangles_random_time;

void() crystalbeam_update_view =
{

	if(self == self.owner.lastbeam_view)
	{
		if(self.owner.beam_counter_view > ((self.owner.beam_lenght / 2) + 1))
		{
			self.owner.beam_counter_view --;
			self.owner.lastbeam_view = self.lastbeam_view;
			remove(self);
			return;
		}
		if(self.owner.beam_counter_view < (self.owner.beam_lenght / 2))
		{
			self.owner.beam_counter_view ++;
			local entity beam;
			beam = spawn();
			beam.beam_counter  = self.owner.beam_counter_view;
			beam.classname = "crystalbeam_view";
			beam.owner = self.owner;
			if(self.cnt >= 5)
				beam.cnt = 1;
			else
			beam.cnt = self.cnt + 1;
			if(beam.cnt == 1)	
				setmodel (beam,"models/projectiles/beam_crystala.md3");
			if(beam.cnt == 2)	
				setmodel (beam,"models/projectiles/beam_crystalb.md3");
			if(beam.cnt == 3)	
				setmodel (beam,"models/projectiles/beam_crystalc.md3");
			if(beam.cnt == 4)	
				setmodel (beam,"models/projectiles/beam_crystald.md3");
			if(beam.cnt == 5)	
				setmodel (beam,"models/projectiles/beam_crystale.md3");
			beam.lastbeam_view = self.owner.lastbeam_view;
			self.owner.lastbeam_view = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.movetype = MOVETYPE_NOCLIP;
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = crystalbeam_update_view;
		}
		
	}		

	if(!self.owner.spawnedcrystal)
		self.think = alphafade3;
	else
		self.think = crystalbeam_update_view;	
	self.nextthink = time + 0.0125; 
};


void() boss2crystalbeam_update_view =
{

	if(self == self.owner.lastbeam_view)
	{
		if(self.owner.beam_counter_view > ((self.owner.beam_lenght / 2) + 1))
		{
			self.owner.beam_counter_view --;
			self.owner.lastbeam_view = self.lastbeam_view;
			remove(self);
			return;
		}
		if(self.owner.beam_counter_view < (self.owner.beam_lenght / 2))
		{
			self.owner.beam_counter_view ++;
			local entity beam;
			beam = spawn();
			beam.beam_counter  = self.owner.beam_counter_view;
			beam.classname = "crystalbeam_view";
			beam.owner = self.owner;
			if(self.cnt >= 5)
				beam.cnt = 1;
			else
			beam.cnt = self.cnt + 1;
			if(beam.cnt == 1)	
				setmodel (beam,"models/projectiles/beam_crystala.md3");
			if(beam.cnt == 2)	
				setmodel (beam,"models/projectiles/beam_crystalb.md3");
			if(beam.cnt == 3)	
				setmodel (beam,"models/projectiles/beam_crystalc.md3");
			if(beam.cnt == 4)	
				setmodel (beam,"models/projectiles/beam_crystald.md3");
			if(beam.cnt == 5)	
				setmodel (beam,"models/projectiles/beam_crystale.md3");
			beam.lastbeam_view = self.owner.lastbeam_view;
			self.owner.lastbeam_view = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.movetype = MOVETYPE_NOCLIP;
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = boss2crystalbeam_update_view;
		}
		
	}		

	if(!self.owner.spawnedcrystal)
		self.think = alphafade3;
	else
		self.think = boss2crystalbeam_update_view;	
	self.nextthink = time; 
};
void() muzzle_crystal_update =
{
	if(!self.owner.spawnedcrystal)
		self.think = alphafade3;
	else
		self.think = muzzle_crystal_update;
	self.nextthink = time + 0.0125; 
};

void(entity e) te_crystal =
{
	entity beam = spawn();
	beam.owner = e;
	beam.classname = "crystalbeam_view";
	e.lastbeam_view = beam;

	if(e.classname == "boss_guardian2")
		beam.scale = 2;
	else
		beam.scale = 0.5;

	if(e.classname != "boss_guardian2")
	{
		if(e.centered == 1)
			beam.angles += '0.75 0 0';
		else
			beam.angles += '0.75 1 0';
	}
	setmodel (beam,"models/projectiles/beam_crystal.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.nextthink = time;
	beam.cnt = 1;
	beam.effects = EF_NODEPTHTEST;
	beam.movetype = MOVETYPE_NOCLIP;
	beam.avelocity = '0 0 120';
	beam.think = crystalbeam_update_view;
	if(beam.scale == 2)
		beam.think = boss2crystalbeam_update_view;

	entity muzzle = spawn();
	muzzle.owner = e;
	setmodel (muzzle,"models/projectiles/proj_wretch.md3");
	setattachment (muzzle,e.vweapon,"tag_muzzle");
	muzzle.scale = 0.75;
	muzzle.colormod = '0.9 0 0.75';
	muzzle.think = muzzle_crystal_update;
	muzzle.nextthink = time;
};

void() crystal_muzzle_think =
{
	self.frame ++;
	self.alpha -= 0.1;
	if(self.alpha == 0)
		self.alpha = -1;
	if(self.alpha > 0) 
		self.think = crystal_muzzle_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.033333;
};
//te_crystal2(dorg, visible_part_of_enemy,12,0.1,random(0.1, 0.25),1,world,alt_visible_part_of_enemy);
void(vector org, vector dest, float beamsize, float lifetime, float alpha_time, float modelscale, entity eangles, vector alternativedest)te_crystal2 = 
{
	string muzzlemodel = "";
	entity muzzle = spawn();
	muzzle.scale = random (1.5,2);

	float beam_count = (vlen (org - dest) / beamsize) - 2;
	if(beam_count <= 2)
	{
		dest = alternativedest;
		beam_count = (vlen (org - dest) / beamsize) - 2;
	muzzle.scale = random (2,3);
	}

	if(beam_count >= 255)
	beam_count = 255;

	setmodel(muzzle, "models/projectiles/proj_crystal.md3");
	muzzle.origin =  dest;
	muzzle.alpha = random(0.5,1);
	muzzle.colormod = '2.25 0.5 1.5';
	muzzle.think = crystal_muzzle_think;
	muzzle.nextthink = time + lifetime +0.1;

#if 0
	vector angs = vectoangles((dest + [crandom() * 64, crandom() * 64, crandom() * 64]) - org);
	angs_x *= -1;
	WriteByte(MSG_ALL, SVC_TEMPENTITY);
	WriteByte(MSG_ALL, TEMPENT::CRYSTALLIZER_BEZIER);
	WriteVectorL(MSG_ALL, org);
	WriteVectorL(MSG_ALL, dest);
	WriteVectorA(MSG_ALL, angs);
	WriteShort(MSG_ALL, 0);
	WriteByte(MSG_ALL, 2);
#else
	vector beam_angles = normalize  (dest - org);
	entity pbeam = spawn();
	pbeam.scale = 0.5;
	pbeam.origin = org;
	pbeam.angles = vectoangles (beam_angles);
	if(eangles != world)
	{
		vector beamangles;
		beamangles_x = eangles.v_angle_x * -1;
		beamangles_y = eangles.v_angle_y;
		beamangles_z = eangles.v_angle_z;
	 	
		pbeam.angles = beamangles;
	}
	//pbeam.angles_y += 180;
	setmodel (pbeam,"models/projectiles/beam_crystal.md3"); //models/weapons/crystal/v_beam
	pbeam.movetype = MOVETYPE_NOCLIP;
	pbeam.think = alphafade;

	pbeam.nextthink = time + lifetime;
	pbeam.alphatime  = alpha_time;
	pbeam.scale = modelscale * 0.5;
	pbeam.alpha = random (1, 2.5);
	pbeam.avelocity_z = random (256,512) * crandom() ;
	pbeam.colormod = '0.9 0.75 0.75';

	entity lastbeam =  pbeam;
	float beamcnt = 1;
	while (beam_count > 0)
	{
		if(beamcnt > 5)
			beamcnt = 1;
		entity beam = spawn();
		//beam.colormod = '2 0 1';
		if(beamcnt == 1)	
			setmodel (beam,"models/projectiles/beam_crystala.md3");
		if(beamcnt == 2)	
			setmodel (beam,"models/projectiles/beam_crystalb.md3");
		if(beamcnt == 3)	
			setmodel (beam,"models/projectiles/beam_crystalc.md3");
		if(beamcnt == 4)	
			setmodel (beam,"models/projectiles/beam_crystald.md3");
		if(beamcnt == 5)	
			setmodel (beam,"models/projectiles/beam_crystale.md3");
		beam.movetype = MOVETYPE_NOCLIP;
		setattachment (beam,lastbeam,"tag_nextbeam");
		beam.nextthink = time + lifetime;
		beam.alpha = pbeam.alpha;
		beam.alphatime  = pbeam.alphatime;
		beam.think = alphafade;
		lastbeam =  beam;
		beamcnt ++;
		beam_count --;
	}
#endif
};

.float beamtime;
.float crystal_secondary;

void()trail_remove2;
void()check_owner_button =
{
	if(!(self.owner.button0))
	remove(self);
	if(self.oldorigin != self.owner.origin)
	remove(self);
	if(self.owner.v_angle != self.angles)
	remove(self);
	if(self.lifetime < time)
	self.think = SUB_Remove;
	else	
	self.think = check_owner_button;
	self.nextthink = time + 0.05;
};

void  (entity e,vector tagorg) bloodparticles_beam =
{
	makevectors(e.v_angle);
	vector t_dest = tagorg + v_forward *4096;
	traceline(tagorg, t_dest, MOVE_WORLDONLY, self);
	vector dir = normalize(trace_endpos - tagorg);
	vector teangles = vectoangles(dir);	
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, tagorg);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *2500;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("crystal_blood_trail");
	trail.owner = e;
	trail.angles = e.v_angle;
	trail.oldorigin = e.origin;
	trail.touch = trail_remove2;
	trail.think = check_owner_button;
	trail.nextthink = time + 0.05;
	trail.lifetime = time + 1;
};

void  (entity e,vector org, vector dest) bloodparticles_beam2 =
{
	vector dir = normalize(dest - org);
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, org);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *2500;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("crystal_blood_trail");
	trail.owner = e;
	trail.angles = e.v_angle;
	trail.oldorigin = e.origin;
	trail.touch = trail_remove2;
	trail.think = SUB_Remove;
	trail.lifetime = time + 1;
};

.float crystal_ammo_timing;
.float particle_crystal_time;
.float beamtime2;
.entity lastcrystalimpacted;


void() wfire_crystal_releaseloop =
{
	string string_sound = "weapons/crystal/crystallizer_release1.ogg";
	float r = random();
	if (r < 0.8)
		string_sound = "weapons/crystal/crystallizer_release2.ogg";
	if (r < 0.6)
		string_sound = "weapons/crystal/crystallizer_release3.ogg";
	if (r < 0.4)
		string_sound = "weapons/crystal/crystallizer_release4.ogg";
	if (r < 0.2)
		string_sound = "weapons/crystal/crystallizer_release5.ogg";



	sound7(self,CHAN_AUTO,string_sound,1,0.25,100,0);
};
.vector rcrystal_dest;

void() wfire_crystal =
{
	if(self.ammo_crystal <= 0)
	{
		self.spawnedcrystal = 0;	
		self.soundfade = 2;
		wfire_crystal_releaseloop();
		self.think = idle_crystal;
		self.attack_finished = time + 0.5;
		self.time_fire_crystal = time + 0.5;
		self.nextthink = time;

		return;
	}
	if((self.button0))
	{
		Controller_Rumble(self, 0.0, 0.1, 120);

		if(!self.spawnedcrystal)
		{
			string string_sound = "weapons/crystal/crystallizer_fire1.ogg";
			float r = random();
			if (r < 0.8)
				string_sound = "weapons/crystal/crystallizer_fire2.ogg";
			if (r < 0.6)
				string_sound = "weapons/crystal/crystallizer_fire3.ogg";
			if (r < 0.4)
				string_sound = "weapons/crystal/crystallizer_fire4.ogg";
			if (r < 0.2)
				string_sound = "weapons/crystal/crystallizer_fire5.ogg";

        	float wvol = cvar ("weapons_fire_volume");

			sound7(self,CHAN_AUTO,string_sound,wvol,0.25,100,0);
			
			sound7(self,CHAN_WEAPONFADE,"weapons/crystal/crystallizer_fire_loop.ogg",wvol,0.25,100,0);
			self.soundfade = 1;
		}
		self.pipes.vweaponstate = 2;
		if(self.crystal_frame_time < time)
		{
			if(self.crystal_frame == 1)
			{
				self.crystal_frame_time = time + 0.9;
				self.vweaponframe = 2;
			}
			else
			{
				self.crystal_frame_time = time + 0.2;
				self.vweaponframe = 	1;
				self.crystal_frame = 1;
			}
		}
		
		if(self.crystal_ammo_timing < time)
		{
			self.crystal_ammo_timing = time + 0.1;
			self.ammo_crystal --;
		}

		if(self.beamtime < time)
		{
			vector tagorg = tag_origin("tag_muzzle",self.vweapon);
			//bloodparticles_beam(self,tagorg);
			makevectors(self.v_angle + self.punchangle);
			vector t_dest = self.origin + self.view_ofs + v_forward * 768;// + v_right * 12 + v_up * -18; // Reki: wtf is this??
            weapontracebox(tagorg - v_forward *8, t_dest, FALSE, self,'3 3 3');
			vector direction = aim(self, 100000);
			self.crystal_secondary = 1;
			float validimpact;
			if((trace_fraction != 1.0))
				validimpact = TRUE;

			vector hit_position = trace_endpos;
			entity hit_ent = trace_ent;
			if ((trace_ent.flags & FL_MONSTER) || (trace_ent.classname == "crystallised"))
			{
				hit_position = ((trace_ent.absmin + trace_ent.absmax) / 2) + (v_forward * -vlen(trace_ent.mins + trace_ent.maxs));
			}

			if (trace_fraction != 1.0 && !GetSkyMaterial())
			{
				if(self.particle_crystal_time < time)
				{
					float tracedist = vlen(tagorg - hit_position);
					if(self.centered != 1)
						vector endparticles = hit_position - v_forward *2 + v_right * -2 + v_up * 3;
					else
					{
						float relcenteredrightoffset = 1 + (tracedist / 60);
						//if(relcenteredrightoffset > 9)
							//relcenteredrightoffset = 9;
						endparticles = hit_position - v_forward *2 + v_right * -(relcenteredrightoffset) + v_up * 5;
					}
	
					self.particle_crystal_time = time +  random( 0.1,0.3);
				}

				if (trace_ent.bloodimpact && (random() < 0.3))
					explo_blood_sprite(trace_ent.bloodimpact, trace_endpos);

				if (trace_ent.takedamage && trace_ent != world)
				{
					vector dorg = hit_position;
					pointparticles(particleeffectnum("crystal_impact1"), dorg, '0 0 0', 1);

					if((trace_ent.flags & FL_MONSTER)|| (trace_ent.classname == "crystallised") ||((trace_ent.classname == "func_destruct") && (trace_ent.crystallized == 1)))
					{

						SpawnBlood(dorg, '0 0 0', 10, 1, 0);
						float subbeam_count;
						if(trace_ent.classname == "crystallised")
							subbeam_count = 5;
						else
							subbeam_count = 1;
			
						if(trace_ent.classname == "crystallised")
							float hittingacrystal = 1;	

						if(trace_ent.classname == "func_destruct")
							 hittingacrystal = 2;	

						if(hittingacrystal != 1)
						{
							if(self.lastcrystalimpacted.particle_crystal_time > time)
								entity head = self.lastcrystalimpacted;
							else
								head = findradius(trace_ent.origin, 512);
						}
						else
							head = findradius(trace_ent.origin, 512);

						if(hittingacrystal == 2)
							head = findradius(trace_endpos, 512);


						trace_ent.crystal_ammo_timing = time + 0.1;
						entity muzzle = spawn();
						setmodel(muzzle, "models/projectiles/proj_crystal.md3");
						muzzle.origin =  dorg - v_forward * -7;
						muzzle.alpha = random(0.5,1);
						muzzle.colormod = '2.25 0.5 1.5';
						muzzle.scale = random (1,1.5);
						muzzle.think = crystal_muzzle_think;
						muzzle.nextthink = time + 0.05;
						float dmge = crystal1_damage;
						if ((trace_ent.classname == "func_destruct") && (trace_ent.crystallized == 1))
							dmge = 0;
						if (trace_ent.classname == "crystallised")
							dmge = 0;
						if(dmge > 0)
						T_Damage (trace_ent, self, self, dmge);
						pointparticles(particleeffectnum("crystal_impact4"), hit_position, '0 0 0', 1);

						float monsters_hit = 0; // Reki (July 30 2023): tracking this for achievement

						float hittingmonster;
						while ((head) && (subbeam_count > 0 )) 
						{
							float visible_instances = 0;
							vector visible_part_of_enemy; 
							vector visible_part_of_enemy_offset;

							visible_part_of_enemy = head.origin;
							if(visibleb(dorg, visible_part_of_enemy,trace_ent))
								visible_instances = 1;


							if(visible_instances == 0)
							{	
								visible_part_of_enemy_offset_z = head.mins_z / 0.7;
								visible_part_of_enemy = head.origin + visible_part_of_enemy_offset;
								if(visibleb(dorg, visible_part_of_enemy ,trace_ent))
									visible_instances = 2;
							}	

							if(visible_instances == 0)
							{	
								visible_part_of_enemy_offset_z = head.maxs_z / 0.7;
								visible_part_of_enemy = head.origin - visible_part_of_enemy_offset;
								if(visibleb(dorg, visible_part_of_enemy,trace_ent))
									visible_instances = 3;
							}
								
							if ((head.takedamage) && (visible_instances != 0)&& (head != world) && ((head.flags & FL_MONSTER) || (head.classname == "boss_guardian2")) && (head.crystal_ammo_timing < time))
							{
								monsters_hit++;
								hittingmonster = 1;
								pointparticles(particleeffectnum("crystal_impact2"), head.origin, '0 0 0', 1);
								if(head.particle_time < time)
								{

									if(hittingacrystal != 1)
									{
										self.lastcrystalimpacted = head;
										self.lastcrystalimpacted.particle_crystal_time = time + 0.5;
									}
									traceline (dorg, visible_part_of_enemy, FALSE, self);
									vector alt_visible_part_of_enemy = visible_part_of_enemy ;
									visible_part_of_enemy = trace_endpos;
									
									T_Damage (head, self, self, crystal1secondary_damage);
									te_crystal2(dorg, visible_part_of_enemy,12,0.1,random(0.1, 0.25),1,world,alt_visible_part_of_enemy);
									string muzzlemodel = "";
									head.particle_time = time + 0.15;
								}
								subbeam_count --;
							}


						head = head.chain;
						}

						if (monsters_hit >= 5) // Reki (July 30 2023): Added check for simultaneous monster hits
						{
							Steam_AchievementUnlock(self, ST_ACHIEVEMENTS::SP_FEAT_CRYSTALSPREAD);
						}

						if(trace_ent && (hittingmonster == 0) && (trace_ent.attack_finished < time))
						{	
							trace_ent.attack_finished = time + 2;
							makevectors (self.v_angle);		
							wtracebox(tagorg - v_forward * 8, t_dest, MOVE_HITMODEL, self,'2 2 2');					
							vector dirnullbeam = normalize(trace_plane_normal) * 92;
							vector rdest = dorg + v_forward * 512 + v_up  * random(64,1024) + v_right * random(-256,256) +  dirnullbeam;
							rdest = normalize (rdest);			
							wtracebox(dorg, rdest * 758, MOVE_WORLDONLY, self,'2 2 2');
							te_crystal2(dorg, trace_endpos,12,0.25,0.25,1,world,rdest);
							if(trace_ent.takedamage)
								T_Damage (trace_ent, self, self, crystal1_damage);
						}
						
					}
					else
					{
						if(trace_ent.bloody == 2)
						{
							SpawnBlood(dorg, '0 0 0', 20, 6, 0);
							if ((bossvulnerable == 1))
							{
										if(trace_ent.classname == "boss_guardian2")
											explo_blood_sprite(2, trace_endpos);
										else
											explo_blood_sprite(5, trace_endpos);
							}
						}


						T_Damage (trace_ent, self, self, crystal1_damage);
						pointparticles(particleeffectnum("crystal_impact1"), dorg, '0 0 0', 1);
					}
				}	
			}
			else
			{
				#if 0
				// Reki (May 16 2023): find some terrain to hit
				for(float i = 0; i < 16; i++)
				{
					float frac = (i / 16);
					vector e_dest = t_dest + (v_right * 256 * frac * crandom()) + (v_up * 128 * frac * crandom());
					traceline(tagorg, e_dest, MOVE_WORLDONLY, self);

					if (trace_fraction < 1.0)
					{
						hit_position = trace_endpos;
						break;
					}
				}
				#else
				hit_position = trace_endpos + (v_right * 16 * crandom()) + (v_up * 8 * crandom());
				#endif
			}

			WriteByte(MSG_ALL, SVC_TEMPENTITY);
			WriteByte(MSG_ALL, TEMPENT::CRYSTALLIZER_BEZIER);
			WriteVectorL(MSG_ALL, tagorg);
			WriteVectorL(MSG_ALL, hit_position);
			WriteVectorA(MSG_ALL, self.v_angle);
			WriteShort(MSG_ALL, num_for_edict(self));
			WriteByte(MSG_ALL, (hit_ent.takedamage != 0));

			vector partoffset = -v_up * 4 + v_right * 5;

			if(self.centered == 1)
				partoffset = -v_up * 4.2 + v_right * -0.05;

			if(validimpact == TRUE)
				pointparticles(particleeffectnum("crystal_impact3"), hit_position + partoffset, '0 0 0', 1);

			#if 1
			self.beamtime = time + 0.1;
			self.spawnedcrystal = 1;
			#else
			wtracebox(tagorg - v_forward * 8, t_dest, FALSE, self,'2 2 2');	
			self.beam_lenght = vlen (tagorg - trace_endpos) / 12;
			if(self.beam_lenght > 64)
				self.beam_lenght = 64;					
			self.beamtime = time + 0.1;
			//self.crystal_beam_end = trace_endpos - v_forward * 12;
			if(!self.spawnedcrystal)
			{	
				self.beam_counter = 0;
				self.beam_counter_view = 0;
				te_crystal(self);
				self.spawnedcrystal = 1;
			}
			#endif
		}

		self.think = wfire_crystal;
	}
	else
	{	
		self.rcrystal_dest = '0 0 0';
		wfire_crystal_releaseloop();
		self.soundfade = 2;
		self.crystal_frame = 0;
		self.spawnedcrystal = 0;	
		self.crystal_frame_time = 0;
		self.think = idle_crystal;
		self.nextthink = time + 0.05;
	}
	self.nextthink = time + 0.01;
};

/*
void(entity e) beamcrystal_spawner =
{
	local entity beam;
	beam = spawn();
	beam.classname = "crystalbeam_view";
	beam.owner = e;
	setmodel (beam,"models/weapons/crystal/railb.md3");
	setattachment (beam,e.lastbeam,"tag_nextbeam");
	e.lastbeam = beam;
	beam.alpha = 1;
	beam.think = alphafade3;
	beam.nextthink = time + 1; 
}
void(entity e) te_beamcrystal =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam = beam;
	if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/weapons/crystal/raila.md3");
	else
		setmodel (beam,"models/weapons/crystal/railb.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.alpha = 1;
	beam.think = alphafade3;
	beam.nextthink = time + 1;
	float loop_lenght;
	loop_lenght = self.owner.beam_lenght;
	while(loop_lenght > 1)
	{
		beamcrystal_spawner(e);
		loop_lenght --;
	}
};
*/
void(entity e, float beamlenght) sub_beam2crystal =
{
	local entity beam;

	beam = spawn();
	//if( beamlenght > 0)
		setmodel(beam, "models/projectiles/boibeamb.md3");
	//else
	//	setmodel(beam, "models/projectiles/proj_raila.md3");
	//beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
	setattachment(beam, e.lastbeam, "tag_nextbeam");
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.colormod = '1 1 1';

	beam.alphatime = 1;
	e.lastbeam = beam;
	beam.think = alphafade;
};

void(entity e, vector tagorg, vector tangles) te_beamcrystal =
{
	local entity beam;
	local float beamlenght;

	beam = spawn();
	self.owner = e;
	e.lastbeam = beam;
	//if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/projectiles/boibeama.md3");
	//else
	//	setmodel (models/projectiles/proj_railb.md3");
	beam.origin = tagorg;
	beam.angles = tangles;
	//beam.effects = EF_NODEPTHTEST;
	//setattachment(beam, e.vweapon, "tag_muzzle");
	beam.beam_lenght = (e.beam_lenght - TRUE);
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.colormod = '1 1 1';
	beam.alphatime = 1;
	beam.think = alphafade;
	beamlenght = beam.beam_lenght;
	while ((beamlenght > 0))
	{
		beamlenght --;
		sub_beam2crystal(e, beamlenght);
	}
};

void()trail_remove2 =
{
	if(other == self.owner)
		return;
	else 
		remove(self);
};

void() fade_mark =
{
	setmodel (self, "models/warp/warp.md3");
	self.alpha -= 0.025;

	if(self.alpha <= 0)
	{
		self.alpha = -1;
		remove(self);
	}
	self.think = fade_mark;
	self.nextthink = time + 0.05;

};

void()flamedissapear =
{
	self.light_lev -= 0.48;

	if(self.light_lev < 1)
	{
		self.scale = 0.25;
		self.think = fade_mark;
		self.alpha = 1;
	}
	else
		self.think = flamedissapear;
	self.nextthink = time + 0.05;

};

void()telefrag_touch =
{
	if(other == self.owner)
		return;
	if(other.classname == "player")
		T_Damage (self, other, other, 5000);
	if(other.flags & FL_MONSTER)
		T_Damage (other, self, self, 5000);
};


.float fake_alpha;



void() monster_goodbye_touch = 
{
	if(other.solid == SOLID_TRIGGER)
		return;	
	T_Damage(self, self, self, 500);	

	if(other.takedamage)
	{	

		float dmg = crystal2_damage * (1+ self.ammo_revolver);
		if(other.classname != "player")
		T_Damage(other, self.enemy, self.enemy, dmg);	
	}	
	self.movetype = MOVETYPE_TOSS;
};

void() monster_pregoodbye = 
{

	if (!(self.flags &FL_ONGROUND)) 
	{
		self.jump_flag = self.velocity_z;
	}
	else
		self.jump_flag = 0;
	
	if(self.jump_flag <= -250)
	self.touch = monster_goodbye_touch;
	
	self.movetype = MOVETYPE_TOSS;
	self.think = monster_pregoodbye;
	self.nextthink = time + 0.05;
};

void() monster_flyer_pregoodbye = 
{
	float speed = vlen (self.velocity);

	if((self.oldorigin == self.origin) || (self.flags &FL_ONGROUND) || (speed <= 5))
	{
		self.think = monster_goodbye_touch;
		self.nextthink = time + 0.05;
		return;
	}
	
	if(self.velocity_z > -320)
	self.velocity_z -= 5; 


	self.oldorigin = self.origin;
	
	self.think = monster_flyer_pregoodbye;
	self.nextthink = time + 0.05;
};


void()cist_crystal_think =
{


	self.velocity_x = self.velocity_x * 0.9;
	self.velocity_y = self.velocity_y * 0.9;


	if(self.velocity_z > 0)
	self.velocity_z = self.velocity_z * 0.9;
	self.avelocity_x = self.avelocity_x * 0.9;
	self.avelocity_y = self.avelocity_y * 0.9;
	self.avelocity_z = self.avelocity_z * 0.9;

	float speed = vlen (self.velocity);

	if (speed < 32)
		self.movetype = MOVETYPE_BOUNCE;

	if (speed > 12)
	{	
		self.nextthink 	= time + 0.05;
		self.think 	= cist_crystal_think;
	}
	else
	{	
		self.avelocity = '0 0 0';
		self.velocity = '0 0 0';
		self.think 	= galphafade;
		self.nextthink = time + random (15,25);
	}
};

void()cist_crystal_prethink =
{
	self.origin_x = (self.absmin_x + self.absmax_x) /2;
	self.origin_y = (self.absmin_y + self.absmax_y) /2;
	self.origin_z = (self.absmin_z + self.absmax_z) /2;
	vector dir = self.origin - self.originjitter;
	dir = normalize(dir);

	self.avelocity = crandom() *'1600 1600 1600';
	self.velocity += (dir * random(64,128)) * (25 / (20 - self.scale));
	self.velocity_z = 12;
	self.think = cist_crystal_think;
	self.nextthink 	= time + 0.05;
};

void()cist_crystal_touch =
{
	if(other.solid == SOLID_TRIGGER)
		return;
	float r = random();


	if(self.attack_finished < time)
	{
		if(r < 0.2)
		{
			sound7(self, CHAN_WEAPON, "impact/destruct/glass_small_break.ogg", 1, 0.25, 80 + random() *30, 0);
			self.attack_finished =  time + random();
		}
	}

	if(other.solid == SOLID_BSP)
	{
		traceline(self.origin, self.origin -'0 0 12',TRUE,self);
		if (trace_fraction != 1.0)
			self.movetype = MOVETYPE_FLY;
		self.touch = SUB_Null;	
		self.think 	= cist_crystal_prethink;
		self.nextthink 	= time;
	}
};


void() death_crystal_gibs = 
{


	self.effects = EF_NODRAW;
	self.flags = 0;
	self.think = SUB_Remove;
	self.nextthink = time + 3.5;
	float gibaccount = 12;
	self.solid = SOLID_NOT;
	self.takedamage = 0;
	self.th_die = SUB_Null;



	gibaccount = self.maxs_x;
	if((self.classname == "func_destruct") &&(self.gibcount > 0))
		gibaccount = self.gibcount;
	float healthfactor = (self.health) * -0.005;
	if(self.classname == "func_destruct")
		healthfactor = (self.health) * -0.0075;

	if(gibaccount > 32)
		gibaccount = 32;
	if(self.classname == "func_destruct")
		SUB_UseTargets();

	//	void(string locsound, float rnd, float vol, float nchannel, float iswav, float atten) randomsound2 =
	randomsound2("impact/destruct/glass_break",3,1,CHAN_AUTO,0,0.25);

	while(gibaccount > 0)
	{
		local vector org;
		org_x = random(-gibaccount, gibaccount) + self.origin_x;
		org_y = random(-gibaccount, gibaccount) + self.origin_y;
		org_z = random(-gibaccount, gibaccount) + self.origin_z;
		entity crystalgibs = spawn();
		setmodel(crystalgibs, "models/objects/decor/crystals/crystal_small.md3");
		crystalgibs.angles_x = random() * 360;
		crystalgibs.angles_y = random() * 360;
		crystalgibs.angles_z = random() * 360;
		crystalgibs.movetype = MOVETYPE_BOUNCE;
		crystalgibs.bouncefactor = 0.5;
		crystalgibs.solid = SOLID_TRIGGER;
		crystalgibs.think = galphafade;
		crystalgibs.origin = org;
		crystalgibs.gravity = random (1,1.5);
		setorigin (crystalgibs,org);
		crystalgibs.originjitter = self.origin;

		if(self.oldclassname == "monster_wretch")
			crystalgibs.scale = random (2,7);
		else if(self.oldclassname == "executioner")
			crystalgibs.scale = random (5,12);
		else if(self.oldclassname == "monster_symbol")
			crystalgibs.scale = random (5,12);
		else if(self.oldclassname == "monster_widow")
			crystalgibs.scale = random (3,7);
		else
			crystalgibs.scale = random (1,5);

		if(self.classname == "func_destruct")
		{
			crystalgibs.scale = random(self.base_scale *0.75, self.base_scale * 3.33);
			float r = random();
			if(r < 0.3)
				pointparticles(particleeffectnum("crystallize"), crystalgibs.origin, '0 0 0', 1);
		}


		crystalgibs.wrathflags += FL_GARBAGE + FL_GIB;
		crystalgibs.avelocity = crandom() *'0 600 0';
		vector dir = org - self.origin;
		dir = normalize(dir);
		crystalgibs.velocity =  dir * random(64,128) * (5 / (5 - self.scale)) * healthfactor;
		crystalgibs.touch = cist_crystal_touch;
		crystalgibs.velocity_z = random (64,368);	
		crystalgibs.velocity_z += 10 * (35 / (30 - self.scale)) * healthfactor;
			
		crystalgibs.alpha = random(1,2);
		crystalgibs.think = cist_crystal_think;
		crystalgibs.nextthink = time;
		gibaccount --;
	}
};

void() crystalized_think = 
{
	if(self.alpha < 0.9)
	self.alpha += 0.05;
	float healthfactor = self.owner.health * -0.005;
	if(self.owner.health>0) 
	{
		self.think = crystalized_think;
		self.oldorigin = self.owner.origin;
		self.pipes.originjitter = self.owner.origin;
	}
	else
	{
		float r = random();
		if(r < 0.3)
		pointparticles(particleeffectnum("crystallize"), self.oldorigin, '0 0 0', 1);
		self.pipes.effects = 0;
		self.pipes.movetype = MOVETYPE_BOUNCE;
		self.pipes.bouncefactor = 0.5;
		self.pipes.solid = SOLID_TRIGGER;
		self.pipes.think = galphafade;
		vector org = gettaginfo(self.owner, self.tag_index);
		self.pipes.origin = org;
		setorigin (self.pipes,org);
		self.pipes.originjitter = self.owner.origin;
		if(self.owner.oldclassname == "monster_afflicted")
			self.pipes.scale = self.pipes.scale * 1;
		else if(self.owner.oldclassname == "monster_wretch")
			self.pipes.scale = self.pipes.scale * 1;
		else if(self.owner.oldclassname == "monster_symbol")
			self.pipes.scale = self.pipes.scale * 0.5;
		else if(self.owner.oldclassname == "monster_widow")
			self.pipes.scale = self.pipes.scale * 1.5;
		else if(self.owner.oldclassname == "monster_fallen")
			self.pipes.scale = self.pipes.scale * 10;
		else
			self.pipes.scale = self.pipes.scale * 2.5;
		self.pipes.wrathflags += FL_GARBAGE + FL_GIB;
		self.pipes.avelocity = crandom() *'0 600 0';

		vector dir = org - self.oldorigin;
		dir = normalize(dir);
		self.pipes.velocity = self.velocity + dir * random(64,128) * healthfactor;
		self.pipes.velocity_z = random(64,128)* healthfactor;
		self.pipes.oldvelocity = self.velocity;
		self.pipes.touch = cist_crystal_touch;

		self.think = SUB_Remove;
	}
	self.nextthink = time + 0.05;
};

void(entity e, string tagnames, float minscale) crystalized = 
{
	float gib_count = tokenizebyseparator (tagnames, ".");

	float argv_number = 0;
	sound7(self, CHAN_AUTO, "weapons/crystal/crystalise.ogg", 1, 0.25, 80 + random() *30, 0);
	while (gib_count)
	{
		entity cst1 = spawn();
		cst1.angles_x = random() * 360;
		cst1.angles_y = random() * 360;
		cst1.angles_z = random() * 360;
		setmodel(cst1, "models/objects/decor/crystals/crystal_small.md3");
		string tagname = argv (argv_number);
		cst1.owner = e;
		cst1.colormod = '1.5 1 1.5';
		cst1.scale = random (minscale,minscale * 1.5);
		entity cst2 = spawn();
		copyentity (cst1,cst2);
		cst2.effects = EF_NODRAW;
		cst2.alpha = 0.9;
		cst1.pipes = cst2;
			
		setattachment(cst1, e, tagname);
		cst1.think = crystalized_think;
		cst1.alpha = 0.05;
		cst1.nextthink =  time;
		gib_count --;
		argv_number ++;
	}

};

void() doppelalphafade = 
{ 
	self.alpha = self.alpha - ((1 / self.alphatime) / 20);
	self.frame = self.owner.frame;
	if (self.alpha <= 0)
	{
		self.alpha = -1;
		self.think = SUB_Remove;
	}
	else
		self.think = doppelalphafade;

	self.nextthink = time + 0.05;
};

.vector oldcolormod;

void() glowmodderthink = 
{
	if(self.owner.colormod_x >   self.oldcolormod_x)
		self.owner.colormod_x -= 0.25; 	
	else
		self.owner.colormod_x =  self.oldcolormod_x; 	
		
	if(self.owner.colormod_y >   self.oldcolormod_x)
		self.owner.colormod_y -= 0.25; 	
	else
		self.owner.colormod_y =  self.oldcolormod_y; 	

	if(self.owner.colormod_z >  self.oldcolormod_x)
		self.owner.colormod_z -= 0.25; 	
	else
		self.owner.colormod_z = self.oldcolormod_z; 	

	if(self.owner.colormod == self.oldcolormod)
	{	
		self.think = SUB_Remove;
	}
	else
	self.think = glowmodderthink;
	self.nextthink = time  + self.delay;

};


void(entity e, float chan, string samp, float vol, float attenn) msound;
//			msound(self, CHAN_VOICE, "weapons/crystal/raise.ogg", 0, 0);
void()heretic_run;
.float movingz;
void() loop_widow_soundoff;
float(float dmgmultiplier) crystal_impact =
{
	vector org = trace_endpos;
	if(trace_ent.classname == "player")
		float tdmg = crystal2_damage_mp * dmgmultiplier * 2;
	else
		tdmg = crystal2_damage * dmgmultiplier * 2;
		tdmg += 1.5;

	if ((trace_fraction != 1.0)  && (trace_ent.takedamage))
	{


		if((trace_ent.wrathflags & FL_CRYSTAL))
		    T_Damage(trace_ent, self, self, tdmg);

		if ((trace_ent.flags &FL_MONSTER) && ((trace_ent.health <= trace_ent.max_health * 0.25) || (tdmg >= trace_ent.health)))
		{
			self.enemy = self;
			entity oself = self;
			self =trace_ent;
			self.oldth_stand = self.th_stand;
			self.oldth_walk = self.th_walk;
			self.oldth_run = self.th_run;
			self.oldth_missile = self.th_missile;
			self.oldth_melee = self.th_melee;
			self.oldth_pain = self.th_pain;
			self.oldsolid = self.solid;
			self.oldclassname = self.classname;
			self.old2movetype = self.movetype; // dont change oldmovetype!!
			self.oldflags = self.flags;
			pointparticles(particleeffectnum("crystallize"), self.origin, '0 0 0', 2);
			//self.alpha = 0.9;
			//if(self.classname == "monster_widow")
			//	loop_widow_soundoff();
			//msound(self, CHAN_VOICE, "enemies/widow/run.ogg", 0, 0);
			
			sound(self, CHAN_BODY, "misc/null.wav", 0, 1);
			sound(self, CHAN_ITEM, "misc/null.wav", 0, 1);
			sound(self, CHAN_WEAPON, "misc/null.wav",0, 1);
			sound(self, CHAN_WEAPON2, "misc/null.wav",0, 1);
			sound(self, CHAN_VOICE, "misc/null.wav", 0, 1);
			sound(self, CHAN_VOICE2, "misc/null.wav", 0, 1);
			sound(self, CHAN_ITEM, "misc/null.wav", 0, 1);
			sound(self, CHAN_FOOT, "misc/null.wav", 0, 1);
			
			if(self.classname == "monster_afflicted")
			{			crystalized(self,"tag_leg_r_l.tag_leg_r_b.tag_leg_r_a.tag_leg_l_a.tag_head.tag_arm_r_b.tag_arm_r_a.tag_arm_l_b.tag_arm_l_a.tag_hand.tag_a.tag_b.tag_c.tag_d",5);
				self.skin = 1;

			}
			if(self.classname == "monster_brute")
			{
				crystalized(self,"tag_face.tag_arma.tag_armb.tag_armc.tag_armd.tag_arme.tag_lega.tag_legb.tag_legc.tag_legd.tag_lege.tag_back.tag_howitzer.tag_howitzer_gun",8.5);
				self.skin += 2;
			}
			else if(self.classname == "executioner")
			{
				crystalized(self,"tag_head.tag_arma.tag_armb.tag_armc.tag_armd.tag_lega.tag_legb.tag_legc.tag_legd.tag_lege.tag_backa.tag_backb.tag_arm_left.tag_arm_right.tag_fake",8.5);
				self.skin = self.skin + 3;				
			}
			else if(self.classname == "monster_fallen")
			{
				crystalized(self,"tag_head.tag_waist.tag_torso.tag_leg_b_r.tag_leg_b_l.tag_knee_r.tag_knee_l.tag_arm_b_l.tag_arm_b_r.tag_arm_a_l.tag_arm_a_r", 0.5);
				self.skin = self.skin + 6;	
			}
			else if(self.classname == "monster_heretic")
			{
				crystalized(self,"tag_muzzle.tag_tongues.tag_jawb.tag_jawa.tag_heada.tag_headb.tag_headc.tag_jawc.tag_backa.tag_backb",3.5);
				self.skin = 1;				
			}
			else if(self.classname == "monster_incisor")
			{
				crystalized(self,"tag_Head.tag_R_Upper_Arm.tag_R_Mid_Arm.tag_R_Lower_Arm.tag_L_Upper_Arm.tag_L_Mid_Arm.tag_L_Lower_Arm.tag_R_Leg_Thigh.tag_R_Leg_Mid.tag_R_Leg_Calf.tag_L_Leg_Thigh.tag_L_Leg_Mid.tag_L_Leg_Calf",3);
				self.skin = 1;	
				self.alpha = 1;	
				self.effects = 0;	

			}
			else if(self.classname == "monster_invader")
			{
				crystalized(self,"tag_leg_r.tag_leg.tag_head.tag_body.tag_head.tag_arm_r.tag_arm_l.tag_hair_a.tag_hair_b.tag_hair_c.tag_fake",3);
				self.skin = self.skin + 4;				
			}			
			else if(self.classname == "monster_lurker")
			{
				crystalized(self,"tag_arm_a_l.tag_arm_a_r.tag_arm_b_l.tag_arm_b_r.tag_head_a.tag_head_b.tag_head_c.tag_tail_a.tag_tail_b",3);
				self.skin = 1;
				self.alpha = 1;
				self.effects = 0;
			}
			else if(self.classname == "monster_oppressor")
			{
				crystalized(self,"tag_shoulder_r.tag_shoulder_l.tag_pelvis.tag_leg_r.tag_leg_l.tag_head_face.tag_head_top.tag_foota.tag_footb.tag_dripa.tag_dripb.tag_core.tag_cannon_r.tag_cannon_l",3);
				self.skin = 1;
			}
			else if(self.classname == "monster_stricken")
			{
			self.skin = 1;				
crystalized(self,"tag_cyst_a.tag_cyst_b.tag_cyst_c.tag_cyst_d.tag_cyst_e.tag_cyst_explo.tag_sides.tag_arm_l_b.tag_arm_l_a.tag_tail.tag_arm_r_b.tag_arm_r_a.tag_jaw.tag_head.tag_mouth",9);
			}

			else if(self.classname == "monster_symbol")
			{
				crystalized(self,"tag_muzzle_a.tag_muzzle_b.tag_muzzle_c.tag_muzzle_d.tag_c_br.tag_c_bl.tag_head.tag_t_fl.tag_t_fm.tag_t_fr.tag_t_bl.tag_t_bm.tag_t_br.tag_c_tl.tag_c_tr",7);
				self.skin = 1;				
			}
			else if(self.classname == "monster_wraith")
			{
				crystalized(self,"tag_head.tag_muzzle.tag_arm1.tag_arm2.tag_arm3.tag_arm4.tag_back1.tag_back2.tag_back3.tag_tail1.tag_tail2",3);
				self.skin = 1;				
			}
			else if(self.classname == "monster_wretch")
			{
				crystalized(self,"tag_leg2_l.tag_leg2_r.tag_leg1_1.tag_leg1_r.tag_head.tag_proj.tag_dest.tag_arm2_l.tag_arm2_r.tag_arm1_l.tag_arm1_r",5);
				self.skin = 1;
			}			
			else if(self.classname == "monster_widow")
			{
				crystalized(self,"tag_leg_r_b.tag_leg_l_b.tag_leg_r_a.tag_leg_l_a.tag_head.tag_arm_r_b.tag_arm_r_a.tag_arm_l_b.tag_arm_l_a",3);
				self.skin = 1;				
			}
			else	 
				crystalized(self,"tag_head.tag_arm_b_l.tag_arm_b_r.tag_arm_a_l.tag_arm_a_r",1);

			self.movetype = 0;
		    self.movetype = MOVETYPE_WALK;
			self.gravity = 1;
			if (self.classname == "monster_heretic")
			{		
				self.think = heretic_run;
				self.chasing = 0;	
				self.movingz = 0;
				self.gravity = 1;
				self.skin = 1;
			}
			if((self.classname == "monster_wraith")||(self.classname == "monster_heretic")||(self.classname == "monster_symbol"))
			{
				if(self.flags & FL_FLY)
				self.flags -= FL_FLY;
				self.gravity = 1.25;
				vector height;
				height_z = (self.absmax_z - self.absmin_z) * 1.2;
				traceline(self.origin, self.origin - height, TRUE, self);
				if (trace_fraction != 1)
					self.movetype = MOVETYPE_BOUNCE;
				else
					self.movetype = MOVETYPE_TOSS;


				self.velocity_x =  self.velocity_x * 0.2;
				self.velocity_y =  self.velocity_y * 0.2;
				self.velocity_z =  self.velocity_z * 0.2;

				if(self.classname == "monster_wraith")
				{
					self.velocity += v_forward * (tdmg / 2);
					self.velocity_z += random(64,128);
					self.ammo_revolver = 2;
				}
				if(self.classname == "monster_heretic")
				{
					self.velocity += v_forward * (tdmg / 1.75);
					self.velocity_z += random(64,128);
					self.ammo_revolver = 5;
				}
				if(self.classname == "monster_symbol")
				{
					self.velocity = v_forward * (tdmg / 1.75);
					self.velocity_z += random(128,256);
					self.ammo_revolver = 10;
				}
				self.avelocity_z = random (-128,128);
			
			}
			else
				self.velocity += v_forward * (tdmg / 4);

			if (self.classname == "monster_fallen")
				self.journal_jmessagesm = JB_A;
			if (self.classname == "monster_wraith")
				self.journal_jmessagesm = JB_B;
			if (self.classname == "monster_afflicted")
				self.journal_jmessagesm = JB_C;
			if (self.classname == "monster_widow")
				self.journal_jmessagesm = JB_D;
			if (self.classname == "monster_invader")
				self.journal_jmessagesm = JB_E;
			if (self.classname == "monster_heretic")
				self.journal_jmessagesm = JB_F;
			if (self.classname == "executioner")
				self.journal_jmessagesm = JB_G;
			if (self.classname == "monster_stricken")
				self.journal_jmessagesm = JB_H;
			if (self.classname == "monster_wretch")
				self.journal_jmessagesm = JB_I;
			if (self.classname == "monster_oppressor")
				self.journal_jmessagesm = JB_J;
			if (self.classname == "monster_lurker")
				self.journal_jmessagesm = JB_K;
			if (self.classname == "monster_symbol")
				self.journal_jmessagesm = JB_L;
			if (self.classname == "monster_brute")
				self.journal_jmessagesm = JB_M;
			if (self.classname == "monster_incisor")
				self.journal_jmessagesm = JB_N;
			if (self.classname == "monster_keeper")
				self.journal_jmessagesm = JB_O;
			entity pl = find(world, classname, "player");
			if (!(pl.journal_jmessagesm &self.journal_jmessagesm) && (self.flags &FL_MONSTER))
			{
				pl.journal_jmessagesm += self.journal_jmessagesm;
				//Hud_message(35, pl.origin, pl);
				Hud_JournalNotification(pl);
			}

			self.classentity = self.classentity;
			self.classname = "crystallised";
			killed_monsters = killed_monsters + 1;
			WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
			/*entity glowmodder = spawn();
			glowmodder.owner = self;
			glowmodder.oldcolormod = '3 1 3';	
			glowmodder.owner.colormod = '7 1 7';
			glowmodder.glowmod = '-1 -1 -1';
			glowmodder.think = glowmodderthink;
			glowmodder.nextthink = time;
			glowmodder.delay = 0.05;*/	

			self.oldthink = self.think;
			self.health = 1;

			self.flags = 0;
			self.wrathflags += FL_CRYSTAL;
			self.classentity = "corpse";
			self.th_stand = null;
			self.th_walk = null;
			self.th_run = null;
			self.ammo_crystal  = 1;
			self.th_missile = null;
			self.th_melee = null;
			self.th_pain = nullpain; // th_pain has two arguments 
			self.fake_alpha = 0.1;
			self.th_die = death_crystal_gibs;
			monster_death_use();
			self.effects = 512;
			vector flight = getlight(self.origin);

			self.colormod_x = 0.3 + flight_x * 0.7; 	
			self.colormod_y = 0.3 + flight_y * 0.7; 
			self.colormod_z = 0.3 + flight_z * 0.7; 
			if((self.movetype == MOVETYPE_BOUNCE) || (self.movetype == MOVETYPE_TOSS))
			{
				self.touch = monster_goodbye_touch;
				self.think = monster_flyer_pregoodbye;
				self.nextthink = time + random(0.1,0.3);
			}
			else
			{
				self.think = monster_pregoodbye;
				self.nextthink = time + 0.333;
			}
		

			if (oself.LifeSiphon_time > time)
			{
				life_siphon_gain(oself,self);
			}

			self = oself;
		}
		else
		{
			if ((trace_ent.health > trace_ent.max_health * 0.25)&& (trace_ent.flags & FL_MONSTER))
			{
				if(trace_ent.colormod == '0 0 0')
				trace_ent.colormod = '1 1 1';
				/*glowmodder = spawn();
				glowmodder.owner = trace_ent;
				glowmodder.oldcolormod = trace_ent.colormod;	
				glowmodder.owner.colormod = '3 1 3';
				glowmodder.think = glowmodderthink;
				glowmodder.nextthink = time;	
				glowmodder.delay = 0.0125;*/
				trace_ent.sustained_damage = trace_ent.damagetopain + 1;
			}
			if(!(trace_ent.wrathflags & FL_CRYSTAL))
			T_Damage(trace_ent, self, self, tdmg);

			if(trace_ent.bloody == 2)
			{
				SpawnBlood(trace_endpos, '0 0 0', 20, 12, 0);
				if ((bossvulnerable == 1))
				{
					if(trace_ent.classname == "boss_guardian2")
					{
						explo_blood_sprite(7, trace_endpos);
						explo_blood_sprite(7, trace_endpos +  randomvector('-5 -5 8','5 5 16'));
						explo_blood_sprite(7, trace_endpos +  randomvector('-5 -5 8','5 5 16'));
					}
					else
					{
						explo_blood_sprite(5, trace_endpos);
						explo_blood_sprite(5, trace_endpos +  randomvector('-5 -5 8','5 5 16'));
						explo_blood_sprite(5, trace_endpos +  randomvector('-5 -5 8','5 5 16'));
					}
				}
			}

			pointparticles(particleeffectnum("crystallize"), trace_ent.origin, '0 0 0', 1);
			explo_physics(self,trace_ent, 50, 3);//(entity inflictor, entity targ, float damage, float pushfactor)
		}

	return TRUE;
	}
	else
	{
		pointparticles(particleeffectnum("crystal_impact"), org, v_forward *(-24), 1);
	return FALSE;
	}

};

void()crystals_muzzle_think = 
{
	if(!self.owner.button3)	
		self.think = alphafade;
	else
		self.think = crystals_muzzle_think;
	
	self.nextthink = time + 0.01;	
};
	
void() wsfire_crystal =
{
	vector tagorg = tag_origin("tag_muzzle",self.vweapon);
	if(self.beamtime > time)
		return;
	if((self.button3))
	{
		if(!self.wsfire_crystal_dmgcnt)
		{
            float wvol = cvar ("weapons_fire_volume");
			sound7(self,CHAN_WEAPONFADE,"weapons/crystal/crystallizer_fire_alt_loop.ogg",wvol,0.25,100,0);
			self.soundfade = 1;
		}

		Controller_Rumble(self, 0.0, 0.05 + (self.wsfire_crystal_dmgcnt / 100), 30);
		self.wsfire_crystal_time = time + 0.1;		

		if(self.crystal_frame_time < time)
		{
			if(self.crystal_frame == 1)
			{
				self.crystal_frame_time = time + 0.75;
				if (self.wsfire_crystal_dmgcnt < 20)
					self.vweaponframe = 4;
				else
					self.vweaponframe = 5;

			}
			else
			{
				self.crystal_frame_time = time + 1.3;
				self.vweaponframe = 	3;
				self.crystal_frame = 1;
			}
		}

		if(self.wsfire_crystal_time_charging < time)
		{
			if ((self.ammo_crystal >= 1) && (self.wsfire_crystal_dmgcnt < 20))	
			{

				self.wsfire_crystal_dmgcnt += 1;
				self.ammo_crystal -= 1;
				self.wsfire_crystal_time_charging = time + 0.05 + (self.wsfire_crystal_dmgcnt * 0.005) ;
				entity muzzle = spawn();
				muzzle.owner = self;
				setattachment (muzzle,self.vweapon,"tag_muzzle_core");
				setmodel (muzzle,"models/projectiles/proj_wretch.md3");
				muzzle.scale = 0.3 + 0.01 * self.wsfire_crystal_dmgcnt; 
				muzzle.colormod = '1.2 0.3 0.75';	

				if(self.wsfire_crystal_dmgcnt < 19)
				{			
					muzzle.alphatime = 0.2;
					muzzle.alpha = 0.5;
					if(self.ammo_crystal > 0)
					{	
						muzzle.think = alphafade;					
						muzzle.nextthink = self.wsfire_crystal_time_charging;
					}
					else
					{
						self.beam_muzzle = muzzle;
						muzzle.think = crystals_muzzle_think;
						muzzle.nextthink = time + 0.05;
					}
				}
				else
				{
					muzzle.colormod = '1.3 0.4 0.85';	
					self.beam_muzzle = muzzle;
					muzzle.alphatime = 0.05;
					self.vweaponframe = 5;
					sound7(self,CHAN_AUTO,"weapons/crystal/crystallizer_altfire_stinger.ogg",1,0.25,100,0);
					pointparticles(particleeffectnum("crystalls_muzzle"), tagorg, '0 0 0', 1);
					Controller_Rumble(self, 0.7, 0.9, 120);
					muzzle.alpha = 0.75;
					muzzle.think = crystals_muzzle_think;
					muzzle.nextthink = time + 0.05;
				}
			}
		}	
		self.think = wsfire_crystal;
		self.pipes.vweaponstate = 3;

	}
	else
	{
		float dmg_cnt = 	self.wsfire_crystal_dmgcnt;
		self.soundfade = 2;
		wvol = cvar ("weapons_fire_volume");
		if(dmg_cnt <= 6)
			sound7(self,CHAN_AUTO,"weapons/crystal/crystallizer_altfire1_light.ogg",wvol * 0.6,0.25,100,0);
		else if ((dmg_cnt > 6) && (dmg_cnt <= 12))
			sound7(self,CHAN_AUTO,"weapons/crystal/crystallizer_altfire1_light.ogg",wvol * 0.8,0.25,100,0);
		else if ((dmg_cnt > 12) && (dmg_cnt <= 18))
			sound7(self,CHAN_AUTO,"weapons/crystal/crystallizer_altfire1_light.ogg",wvol * 1,0.25,100,0);
		else if (dmg_cnt > 18) 
		{
			//sound7(self,CHAN_AUTO,"weapons/crystal/crystallizer_fire_alt_release.ogg",1,0.25,100,0);
			sound7(self,CHAN_AUTO,"weapons/crystal/crystallizer_altfire1_max.ogg",wvol,0.25,100,0);
		}
		sound7(self, CHAN_AUTO, "weapons/lance/fire1.ogg", 0.4, 0.25,368,0);
		if (dmg_cnt > 18)
			Controller_Rumble(self, 0.6, 0.42, 240);
		else
			Controller_Rumble(self, 0.2, 0.12 + (dmg_cnt / 100), 120 + (dmg_cnt * 3));
		

		if((self.wsfire_crystal_time > time) && (self.wsfire_crystal_dmgcnt))
		{

			makevectors(self.v_angle);
			vector t_dest = self.origin + self.view_ofs + v_forward *2048;
			//void(vector start, vector end, float noents, entity attacker, vector boxsize) wtracebox
			//wtraceline(tagorg, t_dest, FALSE, self);
			wtracebox(tagorg - v_forward * 8, t_dest, FALSE, self,'7 7 7');
			muzzle = spawn();
			muzzle.owner = self;
			setmodel (muzzle,"models/projectiles/proj_wretch.md3");
			muzzle.origin = tagorg;
			muzzle.scale = 0.25;
			muzzle.alphatime = 0.15;
			muzzle.alpha = 1.5;
			muzzle.colormod = '1.2 0.3 0.75';	
			muzzle.think = alphafade;
			muzzle.nextthink = time + 0.05;
			entity muzzle2 = spawn();
			copyentity (muzzle,muzzle2);
			pointparticles(particleeffectnum("crystalls_muzzle"), tagorg, '0 0 0', self.wsfire_crystal_dmgcnt / 3);
			setorigin (muzzle2,trace_endpos + v_forward * -12);


			if(self.beam_muzzle)
				remove(self.beam_muzzle);
			if (crystal_impact(self.wsfire_crystal_dmgcnt) == FALSE)
			{
				if(dmg_cnt <= 6)
				pointparticles(particleeffectnum("crystal_altimpacta"), trace_endpos + v_forward *(-16),'0 0 0', 1);
				else if ((dmg_cnt > 6) && (dmg_cnt <= 12))
				pointparticles(particleeffectnum("crystal_altimpactb"), trace_endpos + v_forward *(-20),'0 0 0', 1);
				else if ((dmg_cnt > 12) && (dmg_cnt <= 18))
				pointparticles(particleeffectnum("crystal_altimpactc"), trace_endpos + v_forward *(-24),'0 0 0', 1);	
				else if (dmg_cnt > 18) 
				pointparticles(particleeffectnum("crystal_altimpactd"), trace_endpos + v_forward *(-32),'0 0 0', 1);
			}
			else
				pointparticles(particleeffectnum("crystal_altimpacta"), trace_endpos + v_forward *(-16),'0 0 0', 2);

			makevectors(self.v_angle);

			if(deathmatch == 1) 
				vector dir = v_forward * self.wsfire_crystal_dmgcnt * -35;
			else
				dir = v_forward * self.wsfire_crystal_dmgcnt * -12;

			dir_z =  dir_z * 0.75; 
			self.velocity += '0 0 24'; 
			self.velocity += dir;
			float active_punchangle = cvar ("cl_punch");
			if(active_punchangle == 1)			
				self.punchangle_x = -self.wsfire_crystal_dmgcnt * 0.75;
			else
				self.punchangle_x = -self.wsfire_crystal_dmgcnt * 0.25;
			float beamscale = 0.5 + (0.075 * self.wsfire_crystal_dmgcnt);
			float beamduration = 0.075 + (0.0125 * self.wsfire_crystal_dmgcnt); 
			te_crystal2(tagorg, trace_endpos,12 * beamscale,beamduration,beamduration,beamscale,self,trace_endpos);

			self.attack_finished = time + 0.5;
			self.time_fire_crystal = time + 0.5;
			self.wsfire_crystal_dmgcnt = 0;
			self.wsfire_crystal_time = 0;
			self.crystal_frame = 0;
			self.spawnedcrystal = 0;	
			self.crystal_frame_time = 0;
			if (dmg_cnt < 20)		
			{	
				self.vweaponframe = 6;
				self.nextthink = time + 0.65 ;
			}
			else
			{
				self.vweaponframe = 7;
				self.nextthink = time+ 0.95;
			}
			self.think = idle_crystal;
			return;
		}
		self.think = idle_crystal;
	}

	self.nextthink = time + 0.025;
};

void() crystal_glowmod_controller_think =
{
	float maxglow;
	float minglow;

	if(self.vweaponstate == 1)
	{
		minglow = 0.2;
		maxglow = 0.7;
	}
	if(self.vweaponstate == 2)
	{
		minglow = 0.75;
		maxglow = 1.25;		
	}
	if(self.vweaponstate == 3)
	{
		minglow = 1.3;
		maxglow = 1.8;
	}
	if(self.count == 1)
	{
		if(self.glowmod_x > maxglow + 0.05)
		{
			self.glowmod_x -= 0.15;
			self.glowmod_y -= 0.15;
			self.glowmod_z -= 0.15;
		}
		else
		{
			self.glowmod_x -= 0.05;
			self.glowmod_y -= 0.05;
			self.glowmod_z -= 0.05;
		}

		if(self.glowmod_x <= minglow)
			self.count = 0;
	}
	else
	{
		self.glowmod_x += 0.05;
		self.glowmod_y += 0.05;
		self.glowmod_z += 0.05;
		if(self.glowmod_x > maxglow)
			self.count = 1;
	}
	if(self.cnt != 1)
	{
		self.owner.pipes = self;
		self.cnt = 1;
	}
	self.owner.vweaponglowmod = self.glowmod;

	if(self.owner.weapon != IT_CRYSTAL)
		self.think = SUB_Remove;

	if(self.vweaponstate == 1)
		self.nextthink = time + 0.1;
	else
		self.nextthink = time + 0.05;

	

};

void(entity e, entity vweapn) crystal_glowmod_controller = 
{
	entity glowmod_controller = spawn();
	glowmod_controller.glowmod = '0.025 0.025 0.025';
	glowmod_controller.owner = e;
	setmodel(glowmod_controller,"");
	setattachment(glowmod_controller, vweapn, "");
	glowmod_controller.nextthink = time;
	glowmod_controller.think = crystal_glowmod_controller_think;
};

void() lower_crystal2 = 
{ 
	if (self.vweaponframe >= 18)
		self.think = raise_weapon;
	else
	{
		self.think = lower_crystal2;
		self.vweaponframe += 1;
	}
	self.nextthink = time + 0.025;
};

void() lower_crystal = 
{ 
	randomsound2("weapons/crystal/crystallizer_deselect",3,1,CHAN_AUTO,0,0.25);
	remove(self.pipes);
	self.soundfade = 3;
    self.spawnedcrystal = 0;
    self.vweaponframe = 15;
	self.attack_finished = time + 0.25;
	self.think = lower_crystal2;
	self.nextthink = time + 0.025;
};

void() raise_crystal2 = 
{ 
    self.vweaponframe += 1;
	if (self.vweaponframe == 11)
		W_SetWeapon();

	if (self.vweaponframe >= 14)
	{
		self.think = idle_crystal;
	}
	else
		self.think = raise_crystal2;
	self.nextthink = time + 0.025;
};

void() raise_crystal = 
{ 
    self.weapon = IT_CRYSTAL;
	W_SetWeapon();
	randomsound2("weapons/crystal/crystallizer_select",3,1,CHAN_AUTO,0,0.25);
	self.vweaponglowmod = '1 1 1';
	crystal_glowmod_controller (self, self.vweapon);
	self.draw_w = 0;
	self.vweaponglowmod = '0.025 0.025 0.025';
	self.vweaponframe = 9;
	self.vweaponstate = 1;
	self.attack_finished = time +  0.0125; //0.25;
	self.think = raise_crystal2;
	self.nextthink = time;
};

void() pick_up_crystal2 = { self.think = idle_crystal;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_crystal = 
{ 
    self.lastweapon = IT_CRYSTAL;
	self.weapon = IT_CRYSTAL;
	sound(self, CHAN_WEAPON, "weapons/crystal/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	crystal_glowmod_controller (self, self.vweapon);
	self.draw_w = 0;
	self.vweaponglowmod = '0.025 0.025 0.025';
	self.vweaponstate = 2; // hud state
	if (self.noltime < time)
		self.lspeedtime = time + 5;
	self.vweaponframe = 8;
	self.attack_finished = time + 0.05;
	self.think = pick_up_crystal2;
	self.nextthink = time + 3.8;
};

///////////////////////////////////end of qc file


///////////////////////////////////end of qc file
