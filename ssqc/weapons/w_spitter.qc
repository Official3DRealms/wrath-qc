
.float spittertag;
.vector vvv2;
.vector vvv1;
//void(float damage, float type) spawn_touchblood2;

void() idle_spitter = { if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	if (self.vgearinspect == 1)
		self.vgearinspect = 0;
	if (self.pickup_spitter == 1)
		self.pickup_spitter = 0;
	self.vweaponframe = 0;

	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.think = idle_spitter;
	self.nextthink = time + 0.1;

};

void() prelease_spitter2 = { self.vweaponframe += 1;
	if (self.vweaponframe >= 30)
		self.think = idle_spitter;
	else
		self.think = prelease_spitter2;
	self.nextthink = time + 0.05;
};

void() prelease_spitter = { self.vweaponframe = 21;
	self.attack_finished = 0;
	self.think = prelease_spitter2;
	self.nextthink = time + 0.05;
};

void() srelease_spitter2 = { self.vweaponframe += 1;
	if (self.vweaponframe >= 40)
		self.think = idle_spitter;
	else
		self.think = srelease_cannon2;
	self.nextthink = time + 0.05;
};

void() srelease_spitter = {
	float wvol = cvar ("weapons_fire_volume"); 
	sound(self, CHAN_WEAPON, "weapons/spitter/fire2_release.wav", wvol, ATTN_NORM);
	self.vweaponframe = 36;
	self.think = srelease_spitter2;
	self.nextthink = time + 0.05;
};

.float frags;
.float spteeth;
void() spiral_teeth = { local vector ang;
	local float avfloat;
	avfloat = random() *1.5 + 1.33;

	if (self.spteeth)
	{
		if (self.frags == 0)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 1)
			self.angles_x = self.angles_x + avfloat;
		else if (self.frags == 2)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 3)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 4)
			self.angles_x = self.angles_x - avfloat;
		else if (self.frags == 5)
			self.angles_x = self.angles_x - avfloat;
		else if (self.frags == 6)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 7)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 8)
			self.angles_x = self.angles_x + avfloat;
		else if (self.frags == 9)
			self.angles_x = self.angles_x + avfloat;
		else if (self.frags == 10)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 11)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 12)
			self.angles_x = self.angles_x - avfloat;
		else if (self.frags == 13)
			self.angles_x = self.angles_x - avfloat;
	}
	else
	{
		if (self.frags == 0)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 1)
			self.angles_x = self.angles_x - avfloat;
		else if (self.frags == 2)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 3)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 4)
			self.angles_x = self.angles_x + avfloat;
		else if (self.frags == 5)
			self.angles_x = self.angles_x + avfloat;
		else if (self.frags == 6)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 7)
			self.angles_y = self.angles_y + avfloat;
		else if (self.frags == 8)
			self.angles_x = self.angles_x - avfloat;
		else if (self.frags == 9)
			self.angles_x = self.angles_x - avfloat;
		else if (self.frags == 10)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 11)
			self.angles_y = self.angles_y - avfloat;
		else if (self.frags == 12)
			self.angles_x = self.angles_x + avfloat;
		else if (self.frags == 13)
			self.angles_x = self.angles_x + avfloat;
	}

	self.frags = self.frags + 1;
	if (self.frags >= 13)
		self.frags = 5;

	self.nextthink = time + 0.05;
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}

	ang = self.angles;
	ang_x = ang_x *-1;
	makevectors(ang);
	self.velocity = v_forward * spittervel;
	self.velocity = ((self.velocity + ((v_right *121.000) *crandom())) + ((v_up *121.000) *crandom()));
}

vector() wall_velocity = { local vector vel;
	vel = normalize(self.velocity);
	vel = normalize(vel + v_up *(random() - 0.5) + v_right *(random() - 0.5));
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;
	return vel;
};

void(float damage, float type) spawn_touchblood2 = { local vector vel;
	vel = wall_velocity() *0.2;
	SpawnBlood(self.origin + vel *0.01, vel, damage, type, 0);
};
void() spit_touch = { local vector org;
	org = self.origin;
	local float tdmg;
	if (other == self.owner)
		return;
	if (GetSkyMaterial())
	{
		remove(self);
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound
		return;
	}
	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.takedamage)
	{
		
		if(other.classname == "player")
		{
			if (self.classname == "spleet")
				tdmg = spitterdamg_mp;
			else
				tdmg = spitterdamg2_mp;
		}	
		else
		{
			if (self.classname == "spleet")
				tdmg = spitterdamg;
			else
				tdmg = spitterdamg2;
		}	
		if ((other.flags &FL_MONSTER)||(other.classname == "monster_keeper"))
		{
	
			if (other.classname == "monster_afflicted")
				spawn_touchblood2(9, 2);
			else if (other.classname == "monster_wraith")
				spawn_touchblood2(9, 4);
			else if (other.classname != "monster_oppressor")
				spawn_touchblood2(9, 1);

			local float r;
			r = random();
			if (r < 1)
			{
				if (other.classname == "monster_afflicted")
					explo_blood_sprite(3, org);
				else if (other.classname == "monster_oppressor")
					spawn_touchblood2(9, 5);
				else if (other.classname == "monster_wraith")
					explo_blood_sprite(4, org);
				else
				{
					if (r < 0.5)
						explo_blood_sprite(1, org);
					else
						explo_blood_sprite(2, org);
				}
			}
		}

		vector old_impact = trace_endpos;
		traceline(self.origin, self.origin + v_forward * 1024, MOVE_HITMODEL, self);
		if (trace_ent != other)
			trace_endpos = old_impact;
        if(other.bloody == 2)
        {
			makevectors2 (self.angles);
			if ((bossvulnerable == 1))
			{
				if(other == trace_ent)
				{

					if(other.classname == "boss_guardian2")
						explo_blood_sprite(2, trace_endpos + v_forward * -12);
					else
						explo_blood_sprite(5, trace_endpos + v_forward * -12);
					r = random();
					if (r < 0.3)						
						SpawnGib2(trace_endpos,randomvector('-32 -32 0','32 32 128'));

				}
				
			}
		    SpawnBlood(org, '0 0 0', tdmg, 6, 0);
        }
		if (other.bloodimpact) // new cleaner stuff
				explo_blood_sprite(other.bloodimpact, trace_endpos);

		T_Damage(other, self, self.owner, tdmg);

	}
	else
	{
		if (self.cnt == 1)
			pointparticles(particleeffectnum("fang"), org, v_forward *(-550), 1);
		else
			pointparticles(particleeffectnum("fang2"), org, v_forward *(-550), 1);

        vector partvel =normalize(trace_plane_normal) * 92;
		float material = GetTraceMaterial();


		if(material != MAT_GENERIC)
			material_impacts(material,org,partvel,1,0);
	}

	remove(self);
};
void() proj_rangles =
{
	makevectors (self.angles);
	self.velocity +=  (v_right *random(-350,350)) +  (v_up *random(-350,350));
	self.angles = vectoangles(newmis.velocity);
	self.think = SUB_Remove;
	self.nextthink = time + 5;
};

void(float type, float forg) W_FireSpitter = { local vector tagorg;
	local float sv, tagindex;
	newmis = spawn();

	if (type == 1)
    flask_v_fx(0.5);

	if (type == 3)
    flask_v_fx(0.5);

	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.dphitcontentsmask = DPCONTENTSMASK_WEAPON;
	newmis.solid = SOLID_BBOX;
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 5;
    newmis.wrathflags += FL_PROJECTILE;
	if ((type == 1)|| (type == 3))
	{
		local string tagname;
		if (forg == 1)
			tagname = "tag_barrel_right";
		else
			tagname = "tag_barrel_left";
		if (self.spteeth == 1)
			self.spteeth = 0;
		else
			self.spteeth = 1;
		newmis.spteeth = self.spteeth;
		tagindex = gettagindex(self.vweapon, tagname);
		tagorg = gettaginfo(self.vweapon, tagindex);
		sv += 0.0075 *self.slagcannonspread;
		setorigin(newmis, tagorg);
		setmodel(newmis, "models/projectiles/proj_fang1.md3");
		newmis.classname = "spleet";
		self.ammo_spitter -= 1;
		newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *spittervel;

	}
	else
	{
		tagindex = gettagindex(self.vweapon, "muzzle_3");
		tagorg = gettaginfo(self.vweapon, tagindex);
		newmis.scale = 1;
		setorigin(newmis, tagorg);
		setmodel(newmis, "models/projectiles/proj_fang2.md3");
		newmis.classname = "spleet2";
		self.ammo_spitter -= 2;
		newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *spittervel2;
	}

	if (self.ammo_spitter <= 0)
		self.ammo_spitter = 0;
	newmis.cnt = type;
	if(type == 3)
	{
		makevectors (newmis.angles);
		newmis.velocity +=  (v_right *random(-256,256)) +  (v_up *random(-256,256));
	}
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = spit_touch;
	newmis.modelflags = 0;
	newmis.effects = EF_NOSHADOW;
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
	self.punchangle_x = -2;
	setsize(newmis, '0 0 0', '0 0 0');
};

void() wfire_spitter_loop = { if (self.ammo_spitter <= 0)
	{
		self.ammo_spitter = 0;
		self.think = prelease_spitter;
		self.nextthink = time + 0.05;
		return;
	}

	local string snd;
	if (self.button0)
	{
		if (self.vweaponframe >= 20)
			self.vweaponframe = 1;
		else
			self.vweaponframe += 1;

		if ((self.vweaponframe == 1) || (self.vweaponframe == 5) || (self.vweaponframe == 9) || (self.vweaponframe == 13) || (self.vweaponframe == 17))
			self.spittertag = 2;
		if ((self.vweaponframe == 3) || (self.vweaponframe == 7) || (self.vweaponframe == 11) || (self.vweaponframe == 15) || (self.vweaponframe == 19))
			self.spittertag = 1;

		if (self.spittertag)
		{
			snd = strcat("weapons/spitter/fire1_", ftos(floor(random() *spitter_svpf) + 1), ".wav");
			float wvol = cvar ("weapons_fire_volume");
			sound(self, CHAN_AUTO, snd, wvol, ATTN_NORM);
			W_FireSpitter(1, self.spittertag);
			Controller_Rumble(self, 0.35, 0.05, 80);
			Controller_RumbleTriggers(self, 0, 0.5, 70);
			self.spittertag = 0;
		}

		self.think = wfire_spitter_loop;
	}
	else
		self.think = prelease_spitter;
	self.nextthink = time + 0.05;

	if (self.vgearframe >= 15)
		self.vgearframe = 0;
	else
		self.vgearframe += 1;

	self.attack_finished = time + 0.05;
};

void() wfire_spitter = { local string snd;

	if (self.ammo_spitter <= 0)
	{
		self.ammo_spitter = 0;	
		self.think = prelease_spitter;
		self.nextthink = time + 0.05;
		return;
	}

	self.vweaponframe = 1;
	self.spittertag = 2;
	snd = strcat("weapons/spitter/fire1_", ftos(floor(random() *spitter_svpf) + 1), ".wav");
	float wvol = cvar ("weapons_fire_volume");
	sound(self, CHAN_AUTO, snd, wvol, ATTN_NORM);
	W_FireSpitter(1, self.spittertag);
	Controller_Rumble(self, 0.35, 0.05, 80);
	Controller_RumbleTriggers(self, 0, 0.5, 70);

	self.spittertag = 0;
	self.attack_finished = time + 0.25;
	self.think = wfire_spitter_loop;
	self.nextthink = time + 0.05;

};
void() wsfire_spitter_loop = { if (self.ammo_spitter <= 0)
	{
		self.ammo_spitter = 0;
		self.think = prelease_spitter;
		self.nextthink = time + 0.05;
		return;
	}

	local string snd;
	if (self.button3)
	{


		if (self.vweaponframe >= 20)
			self.vweaponframe = 1;
		else
			self.vweaponframe += 1;

		if ((self.vweaponframe == 1) || (self.vweaponframe == 5) || (self.vweaponframe == 9) || (self.vweaponframe == 13) || (self.vweaponframe == 17))
			self.spittertag = 2;
		if ((self.vweaponframe == 3) || (self.vweaponframe == 7) || (self.vweaponframe == 11) || (self.vweaponframe == 15) || (self.vweaponframe == 19))
			self.spittertag = 1;

		if (self.spittertag)
		{
			snd = strcat("weapons/spitter/fire1_", ftos(floor(random() *spitter_svpf) + 1), ".wav");
			float wvol = cvar ("weapons_fire_volume");
			sound(self, CHAN_AUTO, snd, wvol, ATTN_NORM);
			W_FireSpitter(3, self.spittertag);
			Controller_Rumble(self, 0.3, 0.2, 80);
			Controller_RumbleTriggers(self, 0.3, 0, 30);
			self.spittertag = 0;
		}

		self.think = wsfire_spitter_loop;
	}
	else
		self.think = prelease_spitter;
	self.nextthink = time + 0.025;

	if (self.vgearframe >= 15)
		self.vgearframe = 0;
	else
		self.vgearframe += 1;

	self.attack_finished = time + 0.025;
};

void() wsfire_spitter = { local string snd;

	if (self.ammo_spitter <= 0)
	{
		self.ammo_spitter = 0;	
		self.think = prelease_spitter;
		self.nextthink = time + 0.05;
		return;
	}

	self.vweaponframe = 1;
	self.spittertag = 2;
	snd = strcat("weapons/spitter/fire1_", ftos(floor(random() *spitter_svpf) + 1), ".wav");
	float wvol = cvar ("weapons_fire_volume");
	sound(self, CHAN_AUTO, snd, wvol, ATTN_NORM);
	W_FireSpitter(3, self.spittertag);
	Controller_Rumble(self, 0.3, 0.2, 80);
	Controller_RumbleTriggers(self, 0.3, 0, 30);
	self.spittertag = 0;
	self.attack_finished = time + 0.125;
	self.think = wsfire_spitter_loop;
	self.nextthink = time + 0.025;

};


void() vgear_think = { self.frame = self.owner.vgearframe;
	if (self.owner.ammo_spitter >= 8)
		self.skin = 8;
	else
		self.skin = self.owner.ammo_spitter;
	
	if(self.owner.weapon != IT_SPITTER)
	self.think = SUB_Remove;
	else
	self.think = vgear_think;
	self.owner.phantommodelframe = self.frame;
	self.nextthink = time + 0.05;

};


void(entity e, entity vweapn) spawn_vgear = 
{  

	if((!(wasfreed(e.vgear))) && (e.vgear.wrathflags & FL_SUBWEAPONMODEL))
		remove(e.vgear);
    e.vgear = spawn();
	e.vgear.owner = e;
	e.vgear.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
	setmodel(e.vgear, "models/weapons/spitter/v_fangs.md3");
	//(entity e, entity tagentity, string tagname) setattachment
	//	e.vgear.colormod = '1 10 1';
	setattachment(e.vgear, vweapn, "tag_body");
	if (e.vgearinspect == 1)
	{
		e.vgear.skin = 8;
		e.vgear.nextthink = time + 3;
		e.vgear.frame = 16;
	}
	else
		e.vgear.nextthink = time;

	e.vgear.think = vgear_think;
};

void() pre_idle_spitter = { self.nextthink = time;
	self.pick_up_time = time + 0.5;
	self.think = idle_spitter;
	self.vweaponstate = 1;
}

void() pick_up_spitter = { self.weapon = IT_SPITTER;
	self.lastweapon = IT_SPITTER;
	sound(self, CHAN_AUTO, "weapons/spitter/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponstate = 2;
	self.vweaponframe = 51;
	if (self.noltime < time)
		self.lspeedtime = time + 3;
	self.attack_finished = time + 0.05;
	self.pickup_spitter = 1;
	self.nextthink = time + 4;
	self.vgearinspect = 1;
	spawn_vgear(self, self.vweapon);
	self.think = pre_idle_spitter;
};

void() raise_spitter2 = { if (self.vweaponframe == 42)
		W_SetWeapon();

	self.vweaponframe += 1;
	if (self.vweaponframe >= 45)
		self.think = idle_spitter;
	else
		self.think = raise_spitter2;
	self.nextthink = time + 0.015;
};

void() raise_spitter = { self.weapon = IT_SPITTER;
	W_SetWeapon();
	self.pickup_spitter = 0;
	self.vgearinspect = 0;
	self.vweaponglowmod = '1 1 1';

	if(!(self.playerflags & FL_RESTARWEAPON))
		spawn_vgear(self, self.vweapon);

	sound(self, CHAN_AUTO, "weapons/spitter/raise.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponframe = 41;
	self.attack_finished = time + 0.0125;
	self.think = raise_spitter2;
	self.vweaponstate = 1;
	self.nextthink = time + 0.025;
};

void() lower_spitter2 = { self.vweaponframe += 1;
	if (self.vweaponframe == 49)
	{
		if((!(wasfreed(self.vgear))) && (self.vgear.wrathflags & FL_SUBWEAPONMODEL))
			remove(self.vgear);
	}
	//**	remove (self.vbullet);
	//	remove (self.vbullet2);
	if (self.vweaponframe >= 50)
		self.think = raise_weapon;
	else
		self.think = lower_spitter2;
	self.nextthink = time + 0.025;
};

void() lower_spitter = { sound(self, CHAN_AUTO, "weapons/spitter/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 46;
	self.attack_finished = time + 0.125;
	self.think = lower_spitter2;
	self.vweaponstate = 2;
	self.nextthink = time + 0.025;
};

///////////////////////////////////end of qc file
