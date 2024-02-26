.float lance_reflecttime;
.float randomattack;
.float oldrandomattack;
.float reloaded;
.float lancereloadedtime;
.float lance_rtime;
.float lance_reloadtime;


void() idle_lance_glow_controller = 
{ 

	if(self.owner.weapon !=  IT_LANCE)
		remove(self);
	if((self.owner.vweaponstate == 0) && (self.owner.vweaponframe == 0) &&(self.owner.fieldcreated != 1))
	{
		if(self.cnt != 1)
		{
			self.owner.vweaponglowmod_x += 0.02;
			self.owner.vweaponglowmod_y += 0.02;
			self.owner.vweaponglowmod_z += 0.02;
			if(self.owner.vweaponglowmod_x > 1)
				self.cnt = 1;
		}
		else
		{
			self.owner.vweaponglowmod_x -= 0.01;
			self.owner.vweaponglowmod_y -= 0.01;
			self.owner.vweaponglowmod_z -= 0.01;
			if(self.owner.vweaponglowmod_x < 0.5)
				self.cnt = 0;
		}
	}
	self.think = idle_lance_glow_controller;
	self.nextthink = time + 0.025;
};

void() spawn_glowmod_lance_controller =
{
	entity glowmodcontroller = spawn();
	glowmodcontroller.owner = self;
	self.pipes =  glowmodcontroller;
	glowmodcontroller.think = idle_lance_glow_controller;
	glowmodcontroller.nextthink = time;
};

void()wfire_post_lance;

void() idle_lance = 
{ 
	if(self.reloaded != 1)
	{
		//self.attack_finished = time + self.lance_time + 0.05;
		//self.time_fire_lance = time + self.lance_time + 0.05;
		self.vweaponframe = 0;
		self.reloaded = -1;
		self.vweaponglowmod = '0.05 0.05 0.05';
		self.think = wfire_post_lance;
		self.nextthink = time + 0.05;
		return;
	}

	if (self.pick_up_time < time)
		self.vweaponstate = 0;

	self.vweaponstate = 0;
	self.vweaponframe = 0;

};
.float spawnedlance;
.float beam_lenght;

.entity lastbeam;
.float beam_counter;

.entity lastbeam_view;
.float beam_counter_view;

void(entity e)sub_beam;
void() beam_update;

void(entity e)sub_beam =
{

};

void() beam_update_view =
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
			beam.classname = "lancebeam_view";
			beam.owner = self.owner;
			setmodel (beam,"models/projectiles/proj_beam.md3");
			beam.lastbeam_view = self.owner.lastbeam_view;
			self.owner.lastbeam_view = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = beam_update_view;
		}
		
	}		
	if(!self.owner.spawnedlance)
		self.think = alphafade3;
	else
		self.think = beam_update_view;	
	self.nextthink = time + 0.0125; 
};


//self.cursor_trace_endpos

void(entity e) te_lance2 =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam_view = beam;
	//self.beam_counter = -1;
	setmodel (beam,"models/weapons/lance/v_beam.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.nextthink = time;
	beam.alpha = 1;
	beam.think = beam_update_view;

};
void() beam_update =
{
	if(self == self.owner.lastbeam)
	{
		if(self.owner.beam_counter > (self.owner.beam_lenght + 1))
		{
			self.owner.beam_counter --;
			self.owner.lastbeam = self.lastbeam;
			remove(self);
			return;
		}
		if(self.owner.beam_counter < self.owner.beam_lenght)
		{
			self.owner.beam_counter ++;
			local entity beam;
			beam = spawn();
			beam.classname = "lancebeam";
			beam.exteriormodeltoclient = self.owner;
			beam.owner = self.owner;
			setmodel (beam,"models/projectiles/proj_beam.md3");
			beam.lastbeam = self.owner.lastbeam;
			self.owner.lastbeam = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = beam_update;
		}
		
	}		
	if(!self.owner.spawnedlance)
		self.think = alphafade3;
	else
		self.think = beam_update;	
	self.nextthink = time + 0.0125; 
};


//self.cursor_trace_endpos

void(entity e) te_lance =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam = beam;
	//self.beam_counter = -1;
	setmodel (beam,"models/projectiles/proj_beam.md3");
	setattachment (beam,e,"tag_muzzle");
	beam.nextthink = time;
	beam.exteriormodeltoclient = beam.owner;
	beam.alpha = 1;
	beam.think = beam_update;

};
float(entity targ, float dist) visibleinfront;
float(entity targ, float dist, float drange) visible2;
.float oldspeed;

.float beamtime;
.float lance_secondary;
.float oldlifetime;


void() lance_muzzle_think =
{
	self.frame ++;
	if(self.classname == "secondary_muzzle_lance")
		self.alpha -= 0.03;
	else
		self.alpha -= 0.1;

	if(self.alpha <= 0)
	{
		self.alpha = -1;
		remove(self);
		return;
	}
	self.think = lance_muzzle_think;
	self.nextthink = time + 0.033333;
};


void()prebacktonormal =
{
self.nextthink = time + 0.1;
self.solid = SOLID_SLIDEBOX;
self.think = backtonormal;
}
void() field_shockwave_touch = 
{
	if( (other.classname == "breakable_urn_large") || (other.classname == "breakable_urn_medium") || (other.classname == "breakable_urn_small") || (other.classname == "func_destruct"))
	{
		T_Damage(other, self, self, 220);	// its damage
		T_Damage(self.owner, self, self, 2);	// its damage
	}
}
void()follow_head = 
{
	if(vlen(self.origin - self.owner.origin) > 16)
	setorigin (self, self.owner.origin);

	if(self.lifetime > time)
	self.think = follow_head;
	else
	self.think = SUB_Remove;
	
	self.nextthink = time + 0.05;

}
.entity field_point;

void() removebylifetime =
{		
	if(self.lifetime < time)
		self.think = SUB_Remove;
	else
		self.think = removebylifetime;

	self.nextthink = time + 0.05;
};
void() projectile_fix_angles =
{

	self.think = self.oldthink;
	self.nextthink = time + 0.05;
};

void() projectile_redirect =
{

	makevectors (self.owner.v_angle);
	vector dir = normalize(cursor_trace_endpos_forced (self.owner) - self.origin);
    float speed_factor = vlen (self.owner.velocity) * 5;
	self.velocity = dir * self.oldspeed;
    self.velocity += v_up * random(-speed_factor,speed_factor)+ v_right* random(-speed_factor,speed_factor);	

	self.v_angle = '0 0 0';
	self.angles = '0 0 0';
	self.angles = self.owner.v_angle;
	self.angles = vectoangles(self.velocity);
	self.lifetime =  time + 7;
	if(self.oldthink)
		self.think = self.oldthink;
	else
		self.think = removebylifetime;
	self.nextthink = time + 0.05;
};

.float x_relativeorigin;
.float x_relativeoriginold;

void() check_newprojectile =
{
//self.movetype = MOVETYPE_FOLLOW;


if(self.owner.button3)
	self.think = check_newprojectile;
else
{	
	self.think = projectile_redirect;
}
self.nextthink = time + 0.05;
}


void() check_button3 =
{
//self.movetype = MOVETYPE_FOLLOW;


if(self.owner.fieldcreated != 1)
	self.think = SUB_Remove;
else
	self.think = check_button3;

self.nextthink = time + 0.05;
}
void()projectile_touch_str2;

float(entity targ, entity viewer) infront2 = 
{ 
	local vector vec;
	local float dot;
	makevectors (self.v_angle);
	vec = normalize(rorigin(targ) - rorigin(self));
	dot = vec * v_forward;

	if (dot > 0.3)
	{
		return TRUE;
	}

	return FALSE;
};
void(entity ent) boss3_homingprojectile_deflect;
float(vector targorigin, vector viewerangles,vector viewerorigin,float viewerdeviance) custom_infront2;
float(entity targ, vector viewerangles,vector viewerorigin,float viewerdeviance) custom_infront;
void() projectile_field_touch =
{
	makevectors (self.owner.v_angle);
	vector view_origin = self.owner.origin + self.owner.view_ofs + v_forward * 24+ v_up * -5;
	if(self.owner.centered != 1)
		view_origin += v_right * 5;
	float dist = vlen(view_origin - other.origin);
	vector projectile_relative_org = other.origin;
	projectile_relative_org_z = view_origin_z;
	if(other.classname == "symbol_projectile")
		projectile_relative_org += v_forward * 25;
	if((other.owner != self.owner) && (other.wrathflags & FL_PROJECTILE) && custom_infront2(projectile_relative_org,self.owner.v_angle,view_origin,70 ))
	{
		if(other.classname == "boss3_homingprojectile_c")
			boss3_homingprojectile_deflect(other);

		sound (other, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound if present
		other.oldspeed = vlen (other.velocity);
		other.velocity = '0 0 0';

		randompointsound(other.origin, "weapons/lance/shield_block", 3, 1);
		Controller_Rumble(self.owner, 0.8, 0.8, 150);

		if(other.think)
			other.oldthink = other.think;
		float bparticle = particleeffectnum("lanceforcefield"); 

		// Reki (May 16 2023): Only subtract ammo when reflecting a projectile
		// Reki (July 21 2023): Added .deflection_cost, which is a cost 0-127 with flags
		float amt = 2;
		float should_deflect = ((time > self.owner.lance_reflecttime) || (other.deflection_cost & DEFLECTION::BYPASSTIMER));
		if (other.deflection_cost)
				amt = max(0, other.deflection_cost & 127);
			
		if (self.owner.weapon == IT_LANCE && should_deflect)
		{
			//Steam_StatIncrement(self.owner, ST_STATS::projectiles_deflected, 1);
			self.owner.lance_reflecttime = time + 0.1;
			self.owner.ammo_lance = max(0, self.owner.ammo_lance - amt);
		}

		pointparticles(bparticle, other.origin,(other.velocity), 1);
		if(other.enemy)
	    other.enemy = other.owner;
		other.owner = self.owner;
		other.lifetime = time;
		other.think = projectile_redirect;
		other.nextthink = time + 0.0125;
	}
}
.float crystallized_time; // using this float

void()check_projectile_field =
{

	makevectors (self.owner.v_angle);
	vector view_origin = self.owner.origin + self.owner.view_ofs + v_forward * 24 + v_up * -5;
	setorigin (self, view_origin);
	if((self.owner.button3)&& (self.owner.ammo_lance > 0)&& (self.owner.weapon == IT_LANCE))
		self.think = check_projectile_field;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
};


.float ammo_lance_timing;
.entity muzzlelight;

void()lance_premuzzle_think =
{
	if((self.owner.button3) && (self.owner.ammo_lance > 0)&& (self.owner.weapon == IT_LANCE) )
	{
		if(self.owner.vweaponglowmod_x < 1.5)
		{
			self.muzzlelight.light_lev += 3;
			self.owner.vweaponglowmod_x += 0.09;
			self.owner.vweaponglowmod_y += 0.09;
			self.owner.vweaponglowmod_z += 0.09;
		}

		if(self.ammo_lance_timing < time)
		{

			if(self.cnt == 1)
				self.cnt = 0;
			else
				self.cnt = 1;
			
			if(self.skin == 1)
				{self.skin = 0;}
			else
				{self.skin = 1;}

			// Reki (May 16 2023): Moving this into the reflection logic
			//self.owner.ammo_lance --;
			Controller_Rumble(self.owner, random(0.0, 0.2), random(0.0, 0.3), 250);

			self.ammo_lance_timing = time + 0.2; 
		}	
		/*if(self.cnt == 1)
		{	
			if(self.alpha < 0.35)
				self.alpha += 0.005;
		}
		else
		{
			if(self.alpha > 0.1)
				self.alpha -=  0.005;
		}*/
		//self.scale = 2.7 + self.alpha;

			self.think = lance_premuzzle_think;
	}
	else
	{	
		remove(self.muzzlelight);
		self.owner.soundfade = 2;
		float wvol = cvar ("weapons_fire_volume");
		randomsound2("weapons/lance/shield_release",3,wvol,CHAN_AUTO,0,0.25);
		if(self.field_point && !(wasfreed(self.field_point)))
			remove(self.field_point);
		entity head = findradius(self.owner.origin, 192);
		while (head)
		{
			if (head.wrathflags & FL_GIB)
			{
				explo_physics_gibs (self.owner,head,150,3); 	
			}
			head = head.chain;  // cycle to next head (entity)
		}

		self.owner.vweaponglowmod = '0.75 0.75 0.75';
		self.think = lance_muzzle_think;	
	}
	self.nextthink = time + 0.005;
};

.float fieldcreated;

void() wsfire_lance =
{
	if((self.button3 > 0) && (self.fieldcreated != 1)&&(!(self.button6)))
	{
		self.fieldcreated = 1;
		string muzzlemodel = "models/weapons/lance/barrier.md3";
		entity muzzle = spawn();
		muzzle.owner = self;
		muzzle.scale = self.lance_muzzle_scale;	
		muzzle.count = 1;
		muzzle.cnt = 0;
		muzzle.classname = "secondary_muzzle_lance";
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle2");
		muzzle.think = lance_premuzzle_think;
		muzzle.nextthink = time + 0.05;
		muzzle.alpha = 0.3;

		string string_sound = "weapons/lance/shield_fire1.ogg";
		float r = random();
		if (r < 0.67)
			string_sound = "weapons/lance/shield_fire2.ogg";
		if (r < 0.33)
			string_sound = "weapons/lance/shield_fire3.ogg";

		float wvol = cvar ("weapons_fire_volume");

		sound7(self,CHAN_AUTO,string_sound,wvol,0.25,100,0);
		sound7(self,CHAN_WEAPONFADE,"weapons/lance/shield_loop.ogg",wvol,0.25,100,0);
		self.soundfade = 1;
		local entity plight = spawn();
		plight.pflags = 129;
		plight.light_lev = 48;
		plight.color = '0.15 0.35 0.5';
		setattachment(plight, self.vweapon, "");
		muzzle.muzzlelight = plight;

		makevectors(self.v_angle);
			
		entity fieldpoint =spawn();
		fieldpoint.effects = 128;
		fieldpoint.viewmodelforclient = self;
		self.field_point =fieldpoint;
		setmodel(fieldpoint,"");
		setorigin(fieldpoint, '32 0 -20');

		makevectors (self.owner.v_angle);
		vector view_origin = self.origin + self.view_ofs;// + v_forward * 24 + v_up * -5;


		if(self.owner.centered != 1)
		view_origin += v_right * 5;

		entity projectile_field = spawn();
		setsize (projectile_field, '-96 -96 -96','96 96 96');
		projectile_field.owner = self;		
		projectile_field.solid =SOLID_TRIGGER;		
		projectile_field.origin = view_origin;
		projectile_field.touch = projectile_field_touch;
		projectile_field.originoffset= tag_origin("tag_muzzle2", self.vweapon);
		projectile_field.think = check_projectile_field;
		projectile_field.nextthink = time; 
	}
};

void() ws_release_fire =
{

	self.attack_finished = time + 0.25;
	entity head = findradius(self.origin, 512);
	remove(self.field_point);
	while (head)
	{


		if (head.wrathflags & FL_GIB)
		{
	    	explo_physics_gibs (self,head,150,3); 	
		}
		head = head.chain;  // cycle to next head (entity)
	}
}
void() wsfire_lance2 =
{
	if((self.button3))
	{
		if(self.beamtime < time)
		{
			vector tagorg = tag_origin("tag_muzzle",self.vweapon);
			makevectors(self.v_angle);
			vector t_dest = self.origin + self.view_ofs + v_forward *2048;
			weapontraceline(tagorg, t_dest, FALSE, self);
			vector direction = aim(self, 100000);
			self.lance_secondary = 1;
			if (trace_fraction != 1.0)
				TraceAttack(self.lance_damage2, direction);
			ApplyMultiDamage();
			weapontraceline(tagorg, t_dest, MOVE_WORLDONLY, self);	
			self.beam_lenght = vlen (tagorg - trace_endpos) / 64;
			if(self.beam_lenght > 64)
				self.beam_lenght = 64;					
			self.beamtime = time +self.lance_time2;
			if(!self.spawnedlance)
			{	
				self.beam_counter = 0;
				self.beam_counter_view = 0;
				te_lance(self);
				te_lance2(self);
				self.spawnedlance = 1;
			}
		}
		self.think = wsfire_lance;
	self.lance_viewzoom_time = time +0.1;
	}
	else
	{	
		self.spawnedlance = 0;	
		self.think = idle_lance;
	}
	self.nextthink = time + 0.01;
};



void(entity e, float beamlenght) sub_railgun =
{
	local entity beam;

	beam = spawn();
	//if( beamlenght > 0)
		setmodel(beam, "models/projectiles/proj_railb.md3");
	//else
	//	setmodel(beam, "models/projectiles/proj_raila.md3");
	setattachment(beam, e.lastbeam, "tag_nextbeam");
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.alphatime = e.lance_alpha_time;
	e.lastbeam = beam;
	beam.think = alphafade;
};

void(entity e, vector tagorg, vector tangles) te_railgun =
{
	local entity beam;
	local float beamlenght;

	beam = spawn();
	self.owner = e;
	e.lastbeam = beam;
	//if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/projectiles/proj_raila.md3");
	//else
	//	setmodel (models/projectiles/proj_railb.md3");
	beam.origin = tagorg;
	beam.angles = tangles;
	//beam.effects = EF_NODEPTHTEST;
	//setattachment(beam, e.vweapon, "tag_muzzle");
	beam.beam_lenght = (e.beam_lenght - TRUE);
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.alphatime = e.lance_alpha_time;
	beam.think = alphafade;
	beamlenght = beam.beam_lenght;
	while ((beamlenght > 0))
	{
		beamlenght --;
		sub_railgun(e, beamlenght);
	}
};
void()trail_remove =
{
	if(other != world)
		return;
	else 
		remove(self);
}



void()wfire_post_lance =
{



	if((self.lance_reloadtime < time) && (self.reloaded != 1))
	{
		sound7(self, CHAN_AUTO, "weapons/lance/lance_recharge.ogg", 1, 1, 175, 0);

		Controller_Rumble(self, 0.05, 0.3, 110);

		self.reloaded = 1;
		self.vweaponglowmod = '1 1 1';
		self.cnt = 0;
	}


	if((self.lance_rtime > time) && (self.vweaponglowmod_x < 1))
	{
		if(self.vweaponglowmod_x >= 0.25)
			self.vweaponglowmod -= '0.25 0.25 0.25';
		if(self.vweaponglowmod_x <= 0.05)
			self.vweaponglowmod -= '0.05 0.05 0.05';
		if(self.vweaponglowmod_x <= 0)
			self.vweaponglowmod = '-0.05 -0.05 -0.05';

		self.think = wfire_post_lance;
	}	
	else
	{
		self.think = idle_lance;
	}
	self.nextthink = time + 0.05;
};

void() wfire_lance =
{


	// Reki (December 1 2023): Fixed this not having punch angle
	if(cvar("cl_punch"))
	{
		self.punchangle_x += -5;

		Controller_Rumble(self, 0.7, 0.3, 170);
		Controller_RumbleTriggers(self, 0.7, 0, 50);
	}
	vector tagorg = tag_origin("tag_muzzle",self.vweapon);
	makevectors(self.v_angle);
	vector t_dest = self.origin + self.view_ofs + v_forward *8192;
	if(self.clipgroup != 0)
	{
		self.oldclipgroup = self.clipgroup;
		self.clipgroup = 0;
	}
	
	vector direction = aim(self, 100000);
	self.lance_secondary = 0;
	weapontraceline(tagorg, t_dest, MOVE_HITMODEL, self);
	vector forg = trace_endpos;
	if ((trace_ent.takedamage))
		entity attacked = trace_ent;	
	weapontraceline(tagorg, t_dest, FALSE, self);
	if(trace_ent != attacked)
		forg = trace_endpos;

	if(!GetSkyMaterial())
	{	
		if(self.lance_secondary == 1)
			pointparticles(particleeffectnum("beam_impact"),forg, '0 0 0', 1);
		else
			pointparticles(particleeffectnum("rail_impact"),forg, '0 0 0', 1);
	}

	vector dorg = trace_endpos;

	if ((trace_ent.takedamage) && (trace_fraction != 1))
	{
		if(trace_ent != attacked)
			forg = trace_endpos;
		if(trace_ent.classname == "monster_oppressor")
			trace_ent.monster_long_pain = 1;
		if((trace_ent.classname == "monster_brute"))
			trace_ent.monster_long_pain = 1;
		if((trace_ent.classname == "monster_brute"))
			trace_ent.monster_long_pain = 1;
	

		vector old_impact = trace_endpos;

		if(trace_ent.wrathflags & FL_BREAKABLE)
		{

			if ((trace_ent.classname == "breakable_urn_small") || (trace_ent.classname == "breakable_urn_medium") || (trace_ent.classname == "breakable_urn_large"))
				TraceAttack(512, direction);
			else
				TraceAttack(256, direction);
		}
		else
			TraceAttack(self.lance_damage, direction);

		
		
		if ((bossvulnerable == 1 && attacked.bloody == 2))
		{
			if(attacked == trace_ent)
			{
				if(attacked.classname == "boss_guardian2")
					explo_blood_sprite(9, forg);
				else
					explo_blood_sprite(5, forg);
			}
		}
		if (attacked.bloodimpact)
			explo_blood_sprite(attacked.bloodimpact, forg);
	//explo_blood_sprite(7, old_impact);

		trace_ent = attacked;
		//
		ApplyMultiDamage();
	}
	self.beam_lenght = vlen (tagorg - trace_endpos) / 64;
	if(self.beam_lenght > 64)
		self.beam_lenght = 64;		
	self.vweaponframe = 2;
	self.vweaponglowmod -= '0.25 0.25 0.25';
	self.beam_counter = 0;
	self.beam_counter_view = 0;

	weapontraceline(tagorg, t_dest, MOVE_WORLDONLY, self);

	float wvol = cvar ("weapons_fire_volume");
	randomsound2("weapons/lance/fire",3,wvol,CHAN_WEAPON,0,0.25);
	sound7(self, CHAN_AUTO, "weapons/lance/fire1.ogg", 1, 0.25,512,0);
	vector dir = normalize(trace_endpos - tagorg);
	vector teangles = vectoangles(dir);	
	te_railgun(self, tagorg, teangles);
	//te_railgun2(self);
	self.think = wfire_post_lance;
	self.nextthink = time + 0.05;


	self.reloaded = 0;
	self.attack_finished = time + self.lance_time + 0.05;
	self.time_fire_lance = time + self.lance_time + 0.05;
	self.lance_rtime = self.time_fire_lance - 0.15;
	self.lance_reloadtime = self.time_fire_lance - soundlength("weapons/lance/lance_recharge.ogg") + 0.05;

	self.ammo_lance --;
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, tagorg);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *12000;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("rail_trail");
	trail.touch = trail_remove;
	trail.think = SUB_Remove;
	trail.nextthink = time + 1;
	string muzzlemodel = "models/weapons/lance/v_flash.md3";
	entity muzzle = spawn();
	muzzle.owner = self;
	setmodel(muzzle, muzzlemodel);
	muzzle.viewmodelforclient = self;
	muzzle.alpha = 1;
	setattachment(muzzle, self.vweapon, "tag_muzzle2");
	muzzle.think = lance_muzzle_think;
	muzzle.nextthink = time + 0.05;
	self.clipgroup = self.oldclipgroup;
	if (trace_ent.bloody ==  2)
		SpawnBlood(dorg, '0 0 0', 12, 6, 0);
};


void() lower_lance2 = { self.vweaponframe += 1;
	if (self.vweaponframe >= 12)
		self.think = raise_weapon;
	else
		self.think = lower_lance2;
	self.nextthink = time + 0.025;
};

void() lower_lance = { self.vweaponframe = 8;
	self.attack_finished = time + 0.25;
	self.think = lower_lance2;
	randomsound2("weapons/lance/lance_deselect",3,1,CHAN_AUTO,0,0.25);
	self.nextthink = time + 0.025;
	remove(self.pipes);
};


void() raise_lance2 = { self.vweaponframe += 1;
	if (self.vweaponframe == 5)
		W_SetWeapon();

	if (self.vweaponframe >= 7)
	{
		self.think = idle_lance;
	}
	else
		self.think = raise_lance2;
	self.button3 = 0;

	self.nextthink = time + 0.025;
};

void() raise_lance = { self.weapon = IT_LANCE;
	W_SetWeapon();

	randomsound2("weapons/lance/lance_select",3,1,CHAN_AUTO,0,0.25);

	self.draw_w = 0;
	self.vweaponglowmod = '0.75 0.75 0.75';
	if(self.reloaded != 1)
		self.vweaponglowmod = '0.05 0.05 0.05';

	self.vweaponframe = 3;
	self.vweaponstate = 1;
	self.attack_finished = time +  0.0125; //0.25;
	self.think = raise_lance2;
	self.nextthink = time;
	self.button3 = 0;
	self.time_fire_lance = 0;
	spawn_glowmod_lance_controller();
};
void() pick_up_lance2 = { self.think = idle_lance;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_lance = { self.lastweapon = IT_LANCE;
	self.weapon = IT_LANCE;
	sound(self, CHAN_WEAPON, "weapons/lance/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.reloaded = 1;
	self.vweaponglowmod = '0.75 0.75 0.75';
	self.vweaponstate = 2; // hud state
	if (self.noltime < time)
		self.lspeedtime = time + 5;
	self.vweaponframe = 1;
	self.attack_finished = time + 0.05;
	self.think = pick_up_lance2;
	self.nextthink = time + 5.95;
	spawn_glowmod_lance_controller();
}

///////////////////////////////////end of qc file
