.float doorstate;
.float notouch;
.float splash;
void() door_return;

void() door_wait = { self.state = STATE_TOP;
	activator = self.enemy;
	self.usable = 0;
	self.nextthink = self.ltime + self.wait;
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);

	self.think = door_return;
};
void() door_fire;
void() door_blocked = 
{ 
	if (other.classname == "monster_fallen")
		other.solid = SOLID_CORPSE;
	T_Damage(other, self, self, self.dmg);

	if ((self.spawnflags &4) && (other.classname == "player"))
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			door_return();
			return;
		}
		else
			door_fire();
	}
};
.float fake_lighted;
void() door_done = { sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);
	self.state = STATE_BOTTOM;
	if (!self.notouch)
		self.usable = 1;
	self.solid = SOLID_BSP;
	/*if(self.fake_lighted != 1)
	{
	self.colormod = '0 0 0';
	self.effects = 0;
	}*/
};

void() door_return = { self.state = STATE_DOWN;
	self.usable = 0;
	sound(self, CHAN_VOICE, self.noise, self.volume, self.atten);
	SUB_CalcMove(self.pos1, self.speed, door_done);
};

void() door_fire = 
{ 

	if((self.spawnflags & 8) && (!(self.spawnflags & 16)))
		self.use = SUB_Null;

	if((self.spawnflags & 16) && (!(self.spawnflags & 8)))
	{
		self.spawnflags -= 16;
		self.spawnflags += 8;
	}
	if((self.spawnflags & 16) && (self.spawnflags & 8))
	{
		self.spawnflags -= 8;
	}

	if (self.state == STATE_UP || self.state == STATE_TOP)
	{
		door_return();
		return;
	}

	sound(self, CHAN_VOICE, self.noise, 1, self.atten);
	self.state = STATE_UP;
	self.usable = 0;

	if(self.wait == -2)
	{
		self.targetname == "";
		self.use = SUB_Null;
	}

	SUB_CalcMove(self.pos2, self.speed, door_wait);
};

void() door_use = { self.enemy = activator;
	door_fire();
};
void() door_puse = { SUB_UseTargets();
	//SUB_UseTargets2();	//targetname2 for double doors
	door_fire();
};
.float metaldoor;
.vector lastcolormod;
.vector nextcolormod;
.float minlight;
.vector vminlight;


void() lighter_think =
{

	if((self.owner.minlight > 0) )
	{
		if( (self.owner.velocity != '0 0 0')|| (self.count != 1))
		{
			
			if(self.count != 1)
			{
				vector vlight  = getlight(self.origin);	
				self.owner.lastcolormod_x = vlight_x * ((self.owner.minlight / 100));
				self.owner.lastcolormod_y = vlight_y * ((self.owner.minlight / 100));
				self.owner.lastcolormod_z = vlight_z * ((self.owner.minlight / 100));
				self.owner.colormod = self.owner.lastcolormod;
				self.count = 1;
				float speed = vlen (self.owner.velocity);
				vector dir = normalize (self.owner.velocity);
				vector nvlight  = getlight(self.origin + (dir * speed));	
				self.owner.nextcolormod_x = nvlight_x * ((self.owner.minlight / 100));
				self.owner.nextcolormod_y = nvlight_y * ((self.owner.minlight / 100));
				self.owner.nextcolormod_z = nvlight_z * ((self.owner.minlight / 100));

			}
			if(self.cnt == 0)
			{
				nvlight  = getlight(self.origin + (dir * speed));	
				self.owner.nextcolormod_x = nvlight_x * ((self.owner.minlight / 100));
				self.owner.nextcolormod_y = nvlight_y * ((self.owner.minlight / 100));
				self.owner.nextcolormod_z = nvlight_z * ((self.owner.minlight / 100));
			}

			if(self.cnt >= 0)
			{
				float fcm = self.cnt * 0.1;
				self.owner.colormod_x = self.owner.lastcolormod_x * (1 - fcm) + self.owner.nextcolormod_x * (fcm) ;
				self.owner.colormod_y = self.owner.lastcolormod_y * (1 - fcm) + self.owner.nextcolormod_y * (fcm) ;
				self.owner.colormod_z = self.owner.lastcolormod_z * (1 - fcm) + self.owner.nextcolormod_z * (fcm) ;

			}
			self.cnt ++;
			if(self.cnt == 11)
			{
				self.owner.lastcolormod = self.owner.colormod;
				self.cnt = 0;
			}

		}
		self.think = lighter_think;
		self.nextthink = time + 0.05;

	}
	else
	{
		if( (self.owner.velocity != '0 0 0'))
			fake_light(self.owner, self.origin + '0 0 0');
		self.think = lighter_think;
		self.nextthink = time + 0.05;
	}
}
.vector fake_origin;
.string attached_model;
void(entity ownr) spawn_lighter =
{
	local entity lighter;
	lighter = spawn();
	setmodel (lighter, "models/misc/null.md3");
	lighter.solid = SOLID_TRIGGER;
	setsize (self,'0 0 0', '3 3 3');
	lighter.owner = ownr;
	lighter.origin = lighter.owner.fake_origin+ '0 0 8';
	lighter.movetype = MOVETYPE_FOLLOW;
	lighter.aiment = lighter.owner;
	lighter.view_ofs = lighter.origin - lighter.owner.origin; // relative origin
	//hole.v_angle = hole.angles - bmodel.angles; // relative angles
	fake_light(lighter.owner, lighter.origin + '0 0 0');
	lighter.think = lighter_think;
	lighter.cnt = 0;
	lighter.nextthink = time + 0.025;

};

void() attached_think =
{
	self.think = lighter_think;
	self.nextthink = time + 0.025;
};

void() attachedgib_think =
{
	self.velocity = self.owner.velocity;
	self.think = attachedgib_think;
	self.nextthink = time + 0.025;
};


void(entity ownr) spawn_attached_model =
{

};

void() funcdoorrestoreoriginalpos = 
{
	setorigin(self, self.pos1);
};

void() func_door = 
{ 
	if (self.keyrequired == 4)
	{
		if (!self.noise)
			self.noise = "doors/coffer_open.ogg";
		self.noise2 = "doors/coffer_locked.ogg";
	}

	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	self.atten = attn;
	precache_sound(self.noise);
	precache_sound(self.noise2);
	SetMovedir();
	self.classname = "func_door";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;

	if((world.model == "maps/e1m5.bsp") && (!self.startnonsolid))
		self.startnonsolid = 1;

	if(self.startnonsolid == 1)
	{
		self.oldsolid = self.solid;
		self.wrathflags += FL_STARTNONSOLID;
		self.solid = SOLID_NOT;
		self.think = turn_solid;
		self.nextthink =  self.ltime + 1;
	}

	setmodel(self, self.model);
	if (!self.speed)
		self.speed = 60;
	self.use = door_use;
	if (!self.wait)
		self.wait = 1;
	if (self.keyrequired)
		self.wait = -1;
	if (!self.lip)
		self.lip = 0;
	if (!self.notouch) 
			self.usable = 1;

	self.blocked = door_blocked;
	self.state = STATE_BOTTOM;
	self.doorstate = 0;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);
	if (self.spawnflags &1)
	{
		setorigin(self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	if ((world.model == "maps/e1m2.bsp") && (self.targetname =="SpitterSteps1"))
	{
		setorigin(self, self.pos2);
		self.think = funcdoorrestoreoriginalpos;
		self.nextthink = self.ltime + 2;
	}

	//self.effects = EF_DYNAMICMODELLIGHT;
	if (self.keyrequired)
		self.usable = 1;
	vector voffset;
	voffset_z= (self.absmax_z - self.absmin_z) / 2; 

	//self.minlight  = 70;

	if(!(self.vminlight))
	{
		self.fake_origin = 0.5 *(self.absmax + self.absmin);
		self.fake_origin_z = self.absmax_z + 8;


		vector vlight  = getlight(self.fake_origin);	
		self.vminlight = vlight;
	}
	if(self.minlight > 0)
	{
		self.effects = EF_FULLBRIGHT;
		self.colormod_x = self.vminlight_x * (self.minlight / 100);
		self.colormod_y = self.vminlight_y * (self.minlight / 100);
		self.colormod_z = self.vminlight_z * (self.minlight / 100);
		//self.fake_lighted = 0;
	}

	if(self.fake_lighted == 1)
	{
		if(!(self.effects & EF_DYNAMICMODELLIGHT))
		self.effects += EF_DYNAMICMODELLIGHT;
	}
	if(self.fake_lighted == 2)
	{
		self.fake_origin = 0.5 *(self.absmax + self.absmin);
		self.fake_origin_z = self.absmax_z + 8;


		local entity attachedmodel;
		attachedmodel = spawn();
		setmodel (attachedmodel, "models/misc/null.md3");
		attachedmodel.solid = SOLID_NOT;
		setsize (attachedmodel,'0 0 0', '3 3 3');
		attachedmodel.owner = self;
		attachedmodel.origin = self.fake_origin ;
		attachedmodel.movetype = MOVETYPE_FOLLOW;
		attachedmodel.aiment = attachedmodel.owner;
		attachedmodel.view_ofs = attachedmodel.origin - self.origin; // relative origin
		attachedmodel.think = attached_think;
		attachedmodel.nextthink = time + 0.025;
	}

	if((self.targetname == "Floor")||(self.wrathflags & FL_GIB))
	{
		self.fake_origin = 0.5 *(self.absmax + self.absmin);
		self.fake_origin_z = self.absmin_z - 4;
		local entity attachedgib;
		attachedgib = spawn();
		setmodel (attachedgib, "models/misc/null.md3");
		attachedgib.scale = 3;
		attachedgib.wrathflags = FL_SPLASH;
		attachedgib.origin = self.fake_origin ;
		attachedgib.solid = SOLID_TRIGGER;
		attachedgib.gravity = 0;
		attachedgib.movetype = MOVETYPE_FLY;
		setsize (attachedgib,'-3 -3 -3', '3 3 3');
		attachedgib.owner = self;
		attachedgib.effects = EF_NODRAW;
		attachedgib.model_ammount = 560;
		attachedgib.think = attachedgib_think;
		attachedgib.nextthink = time + 0.025;

	}

    if(self.wrathflags & FL_GIB)
        self.wrathflags -= FL_GIB;
	if(self.attached_model != string_null)
	{
		self.fake_origin = 0.5 *(self.absmax + self.absmin);
		self.fake_origin_z = self.absmax_z;
		spawn_attached_model (self);
	}
	if(self.displacement == 1)
	{
		self.wrathflags += FL_INVISIBLE;
		self.effects += EF_NODRAW;
		self.solid = 0;
	}

};

///////////////////////////////////end of qc file
