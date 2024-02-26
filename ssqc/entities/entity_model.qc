void() train_next;

void() func_train_find;

void() mercenary_test_think;

void(entity e, vector r) setsizeitem;
void() train_blocked =
{
	if ((time < self.attack_finished))
	{
		return;
	}
	self.attack_finished = (time + 0.5);
	T_Damage(other, self, self, self.dmg);
};

void() train_use =
{
	if ((self.spawnflags & TRUE))
	{
		train_next();
		return;
	}
	else
	{
		if (((self.think == train_next) && (self.wait == CONTENT_EMPTY)))
		{
			train_next();
			return;
		}
		if (((self.think != func_train_find) && (self.wait != CONTENT_EMPTY)))
		{
			return;
		}
		train_next();
	}
};

void() train_stop =
{
	local entity targ;

	soundwrath(self, FL_SWIM, self.noise2, TRUE, 0.15,100,0.5);
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	self.velocity = VEC_ORIGIN;
};

void() train_wait =
{

	if (self.wait)
	{
		self.nextthink = (self.ltime + self.wait);
		soundwrath(self, FL_SWIM, self.noise2, TRUE, 0.15,100,0.5);
	}
	else
	{
		self.nextthink = (self.ltime + 0.1);
	}
	self.state = 1;
	self.think = train_next;
};

void() train_next =
{
	local vector fang;
	local entity targ;

	targ = find(world, targetname, self.target);
	if (!(self.spawnflags & TRUE))
	{
		self.target = targ.target;
	}
	if (!self.target)
	{
		objerror("train_next: no next target");
	}
	if (targ.wait)
	{
		self.wait = targ.wait;
	}
	else
	{
		self.wait = FALSE;
	}
	self.state = 0;
	//void(entity e, float chan, string samp, float vol, float atten, float speed, float flags, float trapezoid) soundwrath = #8;
	
	soundwrath(self, FL_SWIM, self.noise, TRUE, 0.15,100,0.5);
	if ((self.spawnflags & TRUE))
	{
		SUB_CalcMove(targ.origin, self.speed, train_stop);
	}
	else
	{
		SUB_CalcMove((targ.origin - self.mins), self.speed, train_wait);
	}
	if (((self.classname == "place_model") || (self.classname == "test_afflicted")))
	{
		fang = normalize((targ.origin - self.origin));
		makevectors(self.angles);
		self.angles = vectoangles(fang);
	}
};

void() func_train_find =
{
	local entity targ;

	targ = find(world, targetname, self.target);
	self.target = targ.target;
	setorigin(self, (targ.origin - self.mins));
	if (!self.targetname)
	{
		self.nextthink = (self.ltime + 0.1);
		self.think = train_next;
	}
};

void() func_train =
{
	if (!self.speed)
	{
		self.speed = CAM_ORG_X;
	}
	if (!self.target)
	{
		objerror("func_train without a target");
	}
	if (!self.dmg)
	{
		self.dmg = FL_SWIM;
	}

	if(!(self.noise))
		self.noise = "misc/null.wav";
	if(!(self.noise2)) 
		self.noise2 = "misc/null.wav";

	precache_sound(self.noise);
	precache_sound(self.noise2);

	self.cnt = TRUE;
	self.solid = MOVETYPE_STEP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "func_train";
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.oldtarget = self.target;
	if (!(self.spawnflags & TRUE))
	{
		self.nextthink = (self.ltime + 0.2);
		self.think = func_train_find;
	}
    if(self.fake_lighted == -1)
    	self.effects = 0;
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
	


};

void() misc_teleporttrain =
{
	if (!self.speed)
	{
		self.speed = CAM_ORG_X;
	}
	if (!self.target)
	{
		objerror("func_train without a target");
	}
	self.cnt = TRUE;
	self.solid = FALSE;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';
	self.noise = "misc/null.wav";
	precache_sound("misc/null.wav");
	self.noise2 = "misc/null.wav";
	precache_sound("misc/null.wav");
	precache_model2("progs/teleport.mdl");
	setmodel(self, "progs/teleport.mdl");
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.nextthink = (self.ltime + 0.1);
	self.think = func_train_find;
};

void() null =
{
};

void() mercenaryanim =
{
	local float ntag;
	local float nparticles;
	local vector shootorg;

	self.frame = (self.frame + 1);
	if ((self.frame >= 98))
	{
		self.frame = 1;
	}
	if ((self.frame == 32))
	{
		ntag = gettagindex(self, "tag_muzzle");
		shootorg = gettaginfo(self, ntag);
		sound(self, 1, "weapons/revolver/fire1_1.ogg", TRUE, TRUE);
		nparticles = particleeffectnum("mercenary_fire");
		pointparticles(nparticles, shootorg, VEC_ORIGIN, MOVETYPE_BOUNCE);
	}
	self.think = mercenaryanim;
	self.nextthink = (time + 0.1);
};

void() attach_it =
{
	local entity twin;

	twin = spawn();
	setmodel(twin, self.model);
	setattachment(twin, self.owner, "tag_hand");
	remove(self);
};
.string attached_model;
.string attached_model2;
.string attached_model3;
.string attached_model4;
.string attached_model5;

.string tag_name;
.string tag_name2;
.string tag_name3;
.string tag_name4;
.string tag_name5;
string testmodel;
void() attach_place_model =
{
	local entity t;
	local vector org;

	t = find(world, targetname, self.target);
	org = tag_origin(self.tag_name, t);
	setorigin(self, org);
	self.owner = t;
	self.think = attach_it;
	self.nextthink = (time + 0.05);
};

void() spawn_attached_models =
{
	local entity s_model;
	local entity s_model2;
	local entity s_model3;
	local entity s_model4;
	local entity s_model5;

	s_model = spawn();
	setmodel(s_model, self.attached_model);
	setattachment(s_model, self, self.tag_name);
	if (self.attached_model2)
	{
		s_model2 = spawn();
		setmodel(s_model2, self.attached_model2);
		setattachment(s_model2, self, self.tag_name2);
	}
	if (self.attached_model3)
	{
		s_model3 = spawn();
		setmodel(s_model3, self.attached_model3);
		setattachment(s_model3, self, self.tag_name3);
	}
	if (self.attached_model4)
	{
		s_model4 = spawn();
		setmodel(s_model4, self.attached_model4);
		setattachment(s_model4, self, self.tag_name4);
	}
	if (self.attached_model5)
	{
		s_model5 = spawn();
		setmodel(s_model5, self.attached_model5);
		setattachment(s_model5, self, self.tag_name5);
	}
	self.think = SUB_Null;
	self.nextthink = (time + 0.1);
};

void() boat_frames =
{
	if(self.frame == 1)
	{
		self.frame = 2;
		self.nextthink = time;
		self.think = null;
	}
	else
	{
		self.think = boat_frames;
		self.nextthink = time + 1;
		self.frame = 1;
	}
};

void() boat_check =
{
	if(self.owner.state == 1)
	{
		self.movetype = 0;
		self.velocity = '0 0 0';
		self.think = boat_frames;
		self.nextthink = time + 1.5;
	}
	else
	{
		self.think = boat_check;
		self.nextthink = time + 0.05;
	}		
};
void() place_model_checkowner =
{

	entity realt;
	local entity e;
	e = nextent(world);
	while (e)
	{
		if ((e.classname == "func_train")&& (e.targetname == self.target) )
		{
			
			{
				realt = e;
			}
		}
		e = nextent(e);
	}

	if(realt)
	{
		self.movetype = MOVETYPE_FOLLOW; // make the hole follow
		self.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
		self.aiment = realt; // make the hole follow bmodel
		self.punchangle = self.angles; // the original angles of bmodel
		self.view_ofs = self.origin - realt.origin; // relative origin
		self.v_angle = self.angles - realt.angles; // relative angles
		
		if (self.spawnflags & 2)
		{
			self.frame = 0;
			self.owner = realt;
			self.think = boat_check;
			vector xyorigin = (realt.absmin*realt.absmax) * 0.5;
			xyorigin_z = self.origin_z;
			setorigin (self,xyorigin);
			self.nextthink = time + 0.05;
			return;
		}
		
		else
			self.think = null;

		self.nextthink = time + 0.5;
	}
	
};

void() place_model =
{
	precache_model(self.model);
	setmodel(self, self.model);
	
	if (self.target)
	{
		if (self.spawnflags & 1)
		{
			self.nextthink = time + 0.1;
			self.think = place_model_checkowner;
		}
		else
		{
			if (!self.speed)
			{
				self.speed = CAM_ORG_X;
			}
			self.cnt = TRUE;
			self.movetype = MOVETYPE_PUSH;
			self.blocked = train_blocked;
			self.use = train_use;
			self.bloody = TRUE;
			self.solid = MOVETYPE_WALK;
			self.takedamage = TRUE;
			self.noise = "misc/null.wav";
			precache_sound("misc/null.wav");
			self.noise2 = "misc/null.wav";
			precache_sound("misc/null.wav");
			self.health = 999999984306749440;
			self.th_die = null;
			setsize(self, '-24 -24 0', '24 24 96');
			setorigin(self, self.origin);
			self.nextthink = (self.ltime + 0.15);
			self.think = func_train_find;
		}
		return;
	}
	if (self.attached_model)
	{
		self.think = spawn_attached_models;
		self.nextthink = (time + 0.1);
	}
};

void() mercenary_test_think2 =
{
	local float acframe;

	self.colormod = '0 0 3';
	acframe = self.frame + TRUE;
	if ((acframe >= 155))
	{
		self.think = mercenary_test_think;
		self.frame = MOVETYPE_BOUNCEMISSILE;
	}
	else
	{
		self.think = mercenary_test_think2;
		self.frame = acframe;
	}
	self.nextthink = (time + 0.1);
};

void() mercenary_test_think =
{
	local float acframe;

	self.colormod = '0 3 0';
	acframe = self.frame + TRUE;
	if ((acframe >= 25))
	{
		self.think = mercenary_test_think2;
		self.frame = 140;
	}
	else
	{
		self.think = mercenary_test_think;
		self.frame = acframe;
	}
	self.nextthink = (time + 0.1);
};

void() mercenary_test =
{
	self.frame = MOVETYPE_BOUNCEMISSILE;
	precache_model("models/enemies/mercenary/mercenary.md3");
	setmodel(self, "models/enemies/mercenary/mercenary.md3");
	self.think = mercenary_test_think;
	self.nextthink = (time + 0.1);
};

void() test_model_frik =
{
	local float readparms;

	readparms = fopen("map/test_model.txt", FALSE);
	testmodel = strzone(fgets(readparms));
	fclose(readparms);
};

void() test_model_fix_origin =
{
	self.oldorigin_x = self.origin_x;
	self.oldorigin_y = self.origin_y;
	self.oldorigin_z = cvar("test_model_height");
	setorigin(self, self.oldorigin);
	self.nextthink = (time + 0.1);
	self.think = test_model_fix_origin;
};

void() test_model =
{
	test_model_frik();
	self.model = testmodel;
	precache_model(testmodel);
	setmodel(self, testmodel);
	self.solid = MOVETYPE_WALK;
	self.oldorigin = self.origin;
	self.takedamage = TRUE;
	if (!self.health)
	{
		self.health = CAM_ORG_X;
	}
	self.th_die = SUB_Remove;
	if ((world.model == "maps/modelbox.bsp"))
	{
		self.nextthink = (time + 0.1);
		self.think = test_model_fix_origin;
	}
	if (self.target)
	{
		if (!self.speed)
		{
			self.speed = CAM_ORG_X;
		}
		self.cnt = TRUE;
		self.movetype = MOVETYPE_PUSH;
		self.blocked = train_blocked;
		self.use = train_use;
		self.solid = MOVETYPE_WALK;
		setorigin(self, self.origin);
		self.nextthink = (self.ltime + 0.1);
		self.think = func_train_find;
	}
};
void() TorchAmbient =
{
	ambientsound(self.origin, self.noise, TRUE, 0.5);
};

void() object_torch1 =
{
	if(!self.episode)
		self.episode = world.episode;
	self.classname = "object_torch1";
	if(self.episode == 1)
	{
		
		precache_model("models/objects/fixtures/torch1.md3");
		setmodel(self, "models/objects/fixtures/torch1.md3");
	}
	if(self.episode == 2)
	{
		precache_model("models/objects/fixtures/e2_torch.md3");
		setmodel(self, "models/objects/fixtures/e2_torch.md3");
		makevectors2 (self.angles);
		
	}
	if(self.episode == 3)
	{
		precache_model("models/objects/fixtures/e3_torch.md3");
		setmodel(self, "models/objects/fixtures/e3_torch.md3");
	}
	if(self.episode == 4)
	{
		precache_model("models/objects/fixtures/e2_torch_2.md3");
		setmodel(self, "models/objects/fixtures/e2_torch_2.md3");
		makevectors2 (self.angles);
		
	}


	precache_sound("fx/fire1.ogg");
	precache_sound("fx/fire2.ogg");
	setsize(self, '-4 -4 -8', '4 4 8');

	if(self.episode == 2)
	{
		self.solid = SOLID_BBOX;
		self.wrathflags += FL_NOONTOP;
		setsize(self, '-4 -4 -30', '4 4 12');
	}

	if (!self.skin)
	{
		float r = random();
		if ( r > 0.5)
			self.skin = 1;
	}	


	if(self.episode == 1)
	self.skin = floor(random(0,3.99));


	if (self.skin != 1)
	{
		
		self.noise = "fx/fire1.ogg";
	}
	else
	{
		self.noise = "fx/fire2.ogg";
	}
	TorchAmbient();
};

void() object_torch2 =
{
	self.episode = 2;
	precache_model("models/objects/fixtures/e2_torch.md3");
	object_torch1();

};


void() object_torch2b =
{
	self.episode = 4;
	precache_model("models/objects/fixtures/e2_torch_2.md3");
	object_torch1();

};

void() object_torch3 =
{
	self.episode = 3;
	precache_model("models/objects/fixtures/e3_torch.md3");
	object_torch1();

};



void() converttriggerhurt = 
{
	self.movetype = 0;
	self.velocity = ' 0 0 0';
	setsize(self,'-18 -18 -16','18 18 16');
	setorigin (self,self.owner.origin + '0 0 12');
	if(!self.wait)
		self.wait = 1;
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
	if (!self.using)
		self.using = 1;
	self.takedamage = 0;
};

void() objecfire_getmodel =
{

	if (!self.skin)
		self.skin = floor(random(0,3.99));
	setmodel(self, "models/objects/fixtures/fire1.md3");
	entity checktriggerhurt = spawn();
	checktriggerhurt.solid = SOLID_TRIGGER;
	checktriggerhurt.origin = (self.origin + '0 0 2');
	setsize(checktriggerhurt,'0 0 0','1 1 1');
	setmodel(checktriggerhurt,"");
	checktriggerhurt.movetype = MOVETYPE_FLY;
	checktriggerhurt.velocity = ' 0 0 3';
	checktriggerhurt.takedamage = DAMAGE_YES;
	checktriggerhurt.health = 1;
	checktriggerhurt.th_die = SUB_Remove;
	checktriggerhurt.owner = self;
	checktriggerhurt.think = converttriggerhurt;
	checktriggerhurt.nextthink = time + 2;
};
void() object_fire1 =
{
	precache_model("models/objects/fixtures/fire1.md3");
	precache_sound("fx/fire1.ogg");
	precache_sound("fx/fire2.ogg");
	setmodel(self, "");
	setsize(self, '-4 -4 -8', '4 4 8');
	if (!self.skin)
	{
		self.noise = "fx/fire1.ogg";
	}
	else
	{
		self.noise = "fx/fire2.ogg";
	}
	TorchAmbient();
	if(self.spawnflags & 1)
	{
		setmodel(self, "models/objects/fixtures/fire1.md3");
	}
	else
	{
		self.think = objecfire_getmodel;
		self.nextthink = time + random (0.5,1);
	}
};

void() CyExplosionBody = { local entity newcyst;


	vector tagorg;
	if(self.owner.flags & FL_MONSTER)
		tagorg = gettaginfo(self.tag_entity, self.tag_index);
	else
		tagorg = self.origin;
	remove(self);
	
	newcyst = spawn();
	setorigin(newcyst, tagorg);
	newcyst.scale = 0.25;
	setmodel(newcyst, "particles/explo/explo_cyst.md3");
	local float skinn;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	newcyst.skin = skinn * 10;
	local string snd;
	snd = strcat("impact/projectiles/cyst_explo", ftos(floor(random() *5) + 1), ".ogg");
	sound(newcyst, CHAN_AUTO, snd, 1, 0.25);


	if(self.owner.flags & FL_MONSTER)
	{
		makevectors(self.owner.angles);
		if (self.owner.health > 0)
			pointparticles(particleeffectnum("cystbody"), tagorg, (v_forward *16), 1);
	}
	newcyst.think = cys_explode1b;
	newcyst.nextthink = time + 0.1;
};
.float cyst_flag;
.float cyst_rate_scale;
.float cyst_rate_glowmod;
void() cyst_think =
{
	if ((self.owner.wrathflags & FL_ALWAYSTOUCH))
	{
		remove(self);
		return;
	}
	if (self.cyst_flag)
	{
		if(self.owner.classname != "monster_fallen")
			self.scale = (self.scale - (self.cyst_rate_glowmod / FL_SWIM));
		self.glowmod_x = (self.glowmod_x - self.cyst_rate_glowmod);
		self.glowmod_y = (self.glowmod_y - self.cyst_rate_glowmod);
		self.glowmod_z = (self.glowmod_z - self.cyst_rate_glowmod);
		if ((self.glowmod_x <= 0.5))
		{
			self.cyst_flag = FALSE;
		}
	}
	else
	{
		if(self.owner.classname != "monster_fallen")
			self.scale = (self.scale + (self.cyst_rate_glowmod / FL_SWIM));
		self.glowmod_x = (self.glowmod_x + self.cyst_rate_glowmod);
		self.glowmod_y = (self.glowmod_y + self.cyst_rate_glowmod);
		self.glowmod_z = (self.glowmod_z + self.cyst_rate_glowmod);
		if ((self.glowmod_x >= TRUE))
		{
			self.cyst_flag = TRUE;
		}
	}
	if ((self.cnt == TRUE))
	{
		if ((self.owner.health < (afflictedhealth - ((afflictedhealth / CAM_ORG_X) * 20))))
		{
			self.think = CyExplosionBody;
		}
		else
		{
			self.think = cyst_think;
		}
	}
	if ((self.cnt == FL_SWIM))
	{
		if ((self.owner.health < (afflictedhealth - ((afflictedhealth / CAM_ORG_X) * STAT_AMMO_SHOTGUN))))
		{
			self.think = CyExplosionBody;
		}
		else
		{
			self.think = cyst_think;
		}
	}
	if ((self.cnt == MOVETYPE_WALK))
	{
		if ((self.owner.health < (afflictedhealth - ((afflictedhealth / CAM_ORG_X) * STAT_RD_ST))))
		{
			self.think = CyExplosionBody;
		}
		else
		{
			self.think = cyst_think;
		}
	}
	if ((self.cnt == MOVETYPE_STEP))
	{
		if ((self.owner.health < (afflictedhealth - ((afflictedhealth / CAM_ORG_X) * STAT_SHRINE))))
		{
			self.think = CyExplosionBody;
		}
		else
		{
			self.think = cyst_think;
		}
	}
	self.nextthink = (time + 0.05);
};

void(entity e) spawn_cysts =
{
	local entity cst1;
	local entity cst2;
	local entity cst3;
	local entity cst4;
	local float pos;

	cst1 = spawn();
	cst2 = spawn();
	cst3 = spawn();
	cst4 = spawn();
	cst1.owner = e;
	cst2.owner = e;
	cst3.owner = e;
	cst4.owner = e;
	cst1.cyst_rate_glowmod = (0.025 + (0.025 * random()));
	cst2.cyst_rate_glowmod = (0.025 + (0.025 * random()));
	cst3.cyst_rate_glowmod = (0.025 + (0.025 * random()));
	cst4.cyst_rate_glowmod = (0.025 + (0.025 * random()));
	cst1.cyst_rate_scale = 0.025;
	cst2.cyst_rate_scale = 0.025;
	cst3.cyst_rate_scale = 0.025;
	cst4.cyst_rate_scale = 0.025;
	cst1.count = TRUE;
	cst2.count = FL_SWIM;
	cst3.count = MOVETYPE_WALK;
	cst4.count = MOVETYPE_STEP;
	setmodel(cst1, "models/enemies/afflicted/cyst_a.md3");
	setmodel(cst2, "models/enemies/afflicted/cyst_b.md3");
	setmodel(cst3, "models/enemies/afflicted/cyst_c.md3");
	setmodel(cst4, "models/enemies/afflicted/cyst_d.md3");
	pos = ceil(((random() * MOVETYPE_FLY) + TRUE));
	if ((pos > MOVETYPE_FLY))
	{
		pos = MOVETYPE_FLY;
	}
	if ((pos == TRUE))
	{
		cst1.cnt = MOVETYPE_STEP;
		cst2.cnt = MOVETYPE_WALK;
		cst3.cnt = FL_SWIM;
		cst4.cnt = TRUE;
	}
	if ((pos == FL_SWIM))
	{
		cst1.cnt = MOVETYPE_WALK;
		cst2.cnt = MOVETYPE_STEP;
		cst3.cnt = FL_SWIM;
		cst4.cnt = TRUE;
	}
	if ((pos == MOVETYPE_WALK))
	{
		cst1.cnt = FL_SWIM;
		cst2.cnt = MOVETYPE_WALK;
		cst3.cnt = MOVETYPE_STEP;
		cst4.cnt = TRUE;
	}
	if ((pos == MOVETYPE_STEP))
	{
		cst1.cnt = TRUE;
		cst2.cnt = FL_SWIM;
		cst3.cnt = MOVETYPE_STEP;
		cst4.cnt = MOVETYPE_WALK;
	}
	if ((pos == MOVETYPE_FLY))
	{
		cst1.cnt = TRUE;
		cst2.cnt = FL_SWIM;
		cst3.cnt = MOVETYPE_WALK;
		cst4.cnt = MOVETYPE_STEP;
	}
	cst1.think = cyst_think;
	cst2.think = cyst_think;
	cst3.think = cyst_think;
	cst4.think = cyst_think;
	cst1.scale = 0.75;
	cst2.scale = 0.75;
	cst3.scale = 0.75;
	cst4.scale = 0.75;
	cst1.glowmod = '0.5 0.5 0.5';
	cst2.glowmod = '0.5 0.5 0.5';
	cst3.glowmod = '0.5 0.5 0.5';
	cst4.glowmod = '0.5 0.5 0.5';


	if(e.classname == "monster_fallen")
	{
		cst1.scale = 0.15;
		cst2.scale = 0.15;
		cst3.scale = 0.15;
		cst4.scale = 0.15;
		setattachment(cst1, e, "tag_leg_b_r");
		setattachment(cst2, e, "tag_knee_l");
		setattachment(cst3, e, "tag_arm_b_r");
		setattachment(cst4, e, "tag_arm_a_l");
	}
	else
	{
		setattachment(cst1, e, "tag_a");
		setattachment(cst2, e, "tag_b");
		setattachment(cst3, e, "tag_c");
		setattachment(cst4, e, "tag_d");
	}
	cst1.nextthink = (time + random());
	cst2.nextthink = (time + random());
	cst3.nextthink = (time + random());
	cst4.nextthink = (time + random());
};
	.float sizeflag;
.string dmodel;
.string gibmodel1;
.string gibmodel2;
.string gibmodel3;
.string gibmodel4;

.vector tagorigin;

void(string tagname, entity e) setoriginbytag =
{
	local vector tagorg;
	local float tagindex;

	tagindex = gettagindex(e, tagname);
	tagorg = gettaginfo(e, tagindex);
	e.tagorigin = tagorg;
};
void() smallbonetocuh = 
{
	if((other.solid == SOLID_BSP) && (self.cnt < 7))
	{
	//self.effects = 1024;
	self.cnt ++;
	self.velocity_x += random(-90,90); 
	self.velocity_y += random(-90,90); 

	sound7 (self, CHAN_AUTO, self.noise, 1, 0.5,random(70,200),0);
	}
}
void(string gibtagname, string gibmodel, entity ownr, vector gvel) spawngibs =
{
	local entity gib;

	gib = spawn();
	gib.owner = ownr;
	setmodel(gib, gibmodel);
	gib.solid = TRUE;
	gib.skin = ownr.skin;
	gib.wrathflags += FL_GIB;
	gib.movetype = MOVETYPE_BOUNCE;
	gib.bouncefactor = 0.35;
	setoriginbytag(gibtagname, ownr);
	setsize(gib, '-1 -1 -1', '0 0 0');
	gib.angles = ownr.angles;
	gib.origin = ownr.tagorigin;
	gib.velocity = gvel;
	gib.alpha = TRUE;
	gib.think = gibalphafade4;
	float r = random();
	if((gib.owner.classentity == "wrathbreakableskull") && (r < 0.75))
	{
		gib.touch = smallbonetocuh;
		gib.noise = "impact/destruct/skullbreak.ogg";
	}
	gib.nextthink = time + 3 + random() * 5;;
};
.entity lastchain;
.float degrees_chain_constant;
.float degrees_chain;
.float hard_degrees;
.float distancetotarget;
.float fixed_angles;
void() create_chain =
{
	local entity chain;

	self.count = (self.count + TRUE);
	self.degrees_chain = (self.degrees_chain + self.degrees_chain_constant);
	chain = spawn();
	setmodel(chain, "models/misc/chain.md3");
	chain.scale = FL_SWIM;
	//chain.effects = FL_IGNOREINPUT;
	chain.angles = (self.lastchain.angles + '0 0 90');
	chain.angles_x = (self.hard_degrees - self.degrees_chain);
	chain.origin = tag_origin("tag_chain", self.lastchain);
	self.lastchain = chain;
	if ((self.count < self.cnt))
	{
		self.think = create_chain;
	}
	else
	{
		self.think = SUB_Null;
	}
	self.nextthink = (time + 0.005);
};

void() info_chain_spot =
{
	setmodel(self, "models/misc/chain.md3");
};

void() info_chain_think2 =
{
	local entity t;
	local float rel;
	local float a;
	local float b;
	local float radio;
	local float circunferencia;
	local float angulos;
	local float arco;

	t = find(world, targetname, self.target);
	//self.height = 34;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.distancetotarget = vlen((self.origin - t.origin));
	self.scale = 2;
	self.angles = vectoangles(normalize((self.origin - t.origin)));
	self.lastchain = self;
	float localcnt = vlen((self.origin - t.origin));
	rel = vlen((self.origin - t.origin)) / self.height;
	self.hard_degrees = (((self.height / self.distancetotarget) * 180) + self.angles_x);
	a = self.height;
	b = localcnt / 2;
	pow(a, 2);
	radio = (pow(a, 2) + pow(b, 2)) / (2 * a);
	circunferencia = 6.28319 * radio;
	angulos = acos(((((localcnt * localcnt) - (radio * radio)) - (radio * radio)) / ((CONTENT_SOLID * radio) * radio))) * RAD2DEG;
	arco = ((6.28319 * radio) * angulos) / 360;

	
	self.cnt = ((arco / 2.5) - TRUE);
	self.cnt -= self.lip;
	self.degrees_chain_constant = (angulos / self.cnt);
	self.think = create_chain;
	self.nextthink = (time + 0.5);
};

.float arch;
.float c_radius;
.float c_angle;
.float c_dist;
.float offset_angle;
.float origin_offset_angle;
.float chain_angle;
.float fspawnflags;
void() chain_makestatic =
{

	//makestatic(self);
};


void() generate_map_chain =
{
	{
		float writeparms = fopen ("misc_model.map", FILE_WRITE);    //open what file to use in write mode

		fputs (writeparms, "{\n");
		fputs (writeparms, "\"classname\" \"worldspawn\"");
		fputs (writeparms, "\n");
		fputs (writeparms, "}");
		fputs (writeparms, "\n");                    //dont forget this
		fclose (writeparms); 
	}


	{
		local entity chain_model;
		chain_model = nextent(world);
		while (chain_model)
		{
			entity holder = nextent(chain_model);
		    if (chain_model.classname == "chained_model")
		    {
		        writeparms = fopen ("misc_model.map", FILE_APPEND);    //open what file to use in write mode
				
				//chain_model.angles_x = chain_model.angles_x * -1;	

		        fputs (writeparms, "{\n");
		        fputs (writeparms, "\"classname\" \"misc_model\"\n");                
		        fputs (writeparms, strcat("\"origin\"","\"",ftos(chain_model.origin_x)," " ,ftos(chain_model.origin_y)," " ,ftos(chain_model.origin_z),"\"\n"));                
		        fputs (writeparms, strcat("\"angles\"","\"",ftos(chain_model.angles_x * -1)," ",ftos(chain_model.angles_y)," " ,ftos(chain_model.angles_z),"\"\n"));                
		        fputs (writeparms, "\"model\" \"models/misc/chain.md3\"\n");
		        fputs (writeparms,strcat(( "\"spawnflags\" \""),ftos(chain_model.fspawnflags),("\"\n")));                                
		        fputs (writeparms, strcat("\"modelscale\" \"",ftos(chain_model.scale),"\"\n"));                                
		        fputs (writeparms, "}\n");
		        fclose (writeparms);  
		    }
		    chain_model = holder;
		}       
	}

};
.float auto_angle;
void() info_chain_think =
{
	entity t = find(world, targetname, self.target);
	float r_dist = (vlen((self.origin - t.origin)));
	self.lastchain = self;
	self.angles = vectoangles(normalize((self.origin - t.origin)));
	float firstchain = 1;	
	self.c_dist = r_dist;

	self.height = self.height * self.scale;// //max(t.origin_z , self.origin_z) - min(t.origin_z , self.origin_z);
	


	if(self.height > r_dist)
	self.height = r_dist -1;


	if(self.height)
	{
		//float c_radius; // diametro
		self.c_radius = (((r_dist/2) * (r_dist/2)) / self.height) + self.height;
		self.c_radius =  self.c_radius * 0.5;
		
		float cathetus_op = r_dist / 2;     
		self.c_angle =   asin(cathetus_op / self.c_radius)* RAD2DEG;

		self.arch = (PI * self.c_angle * (self.c_radius))/ 180;
		self.count = floor (r_dist) / 4.8;
		firstchain = 0;	
		self.chain_angle =  self.c_angle / self.count;
	}
	else
		self.count = floor (r_dist) / 5;

    self.cnt = self.c_angle;
	self.chain_angle = self.chain_angle * 1.4 + (self.offset_angle / 10);
	self.count = self.count / self.scale + self.lip;


	

	while (self.count > 0)
	{
		entity chain = spawn();
		chain.owner = self;
        chain.classname = "chained_model";
		setmodel(chain, self.model);

		vector altangles;
		altangles_z =  self.auto_angle;
		chain.angles = (self.lastchain.angles + altangles);
		chain.scale = self.scale;
		chain.fspawnflags = self.fspawnflags;

		if(firstchain == 0)
		{
			firstchain = 1;	
			chain.angles_x += self.chain_angle * (self.count * 0.5) + self.origin_offset_angle;
		}
		else
		chain.angles_x -= self.chain_angle;
		chain.origin = tag_origin(self.tag_name, self.lastchain);
		self.lastchain = chain;
		self.count --;
		chain.think = chain_makestatic;
		chain.nextthink = time + 0.5;
		
	}

	self.think = chain_makestatic;
	self.nextthink = time + 0.5;
};

void() info_chain =
{	
	if(self.model)
	{
		precache_model(self.model);
		setmodel(self, self.model);
	}
	else
	{
		precache_model("models/misc/chain.md3");
		setmodel(self, "models/misc/chain.md3");
	}
    self.classname = "chained_model";


	if(self.auto_angle == 0)	
	self.auto_angle = 0;
	else if(!self.auto_angle)
	self.auto_angle = 90;

	self.solid = TRUE;
	if(!self.scale)
		self.scale = 1;

	if(!(self.tag_name))
		self.tag_name = "tag_chain";

	if(!self.fspawnflags)
	self.fspawnflags = 7;
	self.think = info_chain_think;
	self.nextthink = (time + 0.05);
};

void() place_modelb =
{
	precache_model(self.model);
	setmodel(self, self.model);
	droptofloor();
};


//// func_flicker ////
// .health: amount intensity of flicker, default is 0.6
// .wait: time between changes, default is 0.2
// .style: 0 (smooth) or 1 (choppy), default is 0
void() flicker_think = 
{
	float base = 1 - self.health;
	float deviation = self.health;

	self.glowmod[0] = 
	self.glowmod[1] =
	self.glowmod[2] = base + (random() * deviation);

	self.nextthink = time + self.wait;
	self.think = flicker_think;
}

void() flicker_think_smooth = 
{	
	if (time > self.attack_finished)
	{
		float base = 1 - self.health;
		float deviation = self.health;

		self.attack_finished = time + self.wait;
		self.ammo_revolver = self.ammo_shotgun;
		self.ammo_shotgun = base + (random() * deviation);
	}
	
	self.glowmod[0] = 
	self.glowmod[1] =
	self.glowmod[2] = lerp(self.ammo_shotgun, self.ammo_revolver, (self.attack_finished - time) / self.wait);

	self.nextthink = time + 0.01;
	self.think = flicker_think_smooth;
}

void() func_flicker =
{
	precache_model(self.model);
	setmodel(self, self.model);
	self.solid = SOLID_BSP;

	if (!self.wait)
		self.wait = 0.2;
	
	if (!self.health)
		self.health = 0.6;
	
	if (self.style < 0)
	{
		self.use = (self.style == -1) ? flicker_think_smooth : flicker_think;
		self.glowmod = '0.001 0.001 0.001';
	}
	else if (self.style)
	{
		flicker_think();
	}
	else
	{
		flicker_think_smooth();
	}
};

float SendEntity_object_eyeball(entity to, float sendflags)
{
	WriteByte(MSG_ENTITY, ENT::EYEBALL);
	WriteByte(MSG_ENTITY, sendflags);

	if (sendflags & 0x01)
	{
		WriteVectorL(MSG_ENTITY, self.origin);
		WriteVectorA(MSG_ENTITY, self.angles);
	}

	if (sendflags & 0x02)
	{
		WriteShort(MSG_ENTITY, self.modelindex);
	}

	if (sendflags & 0x04)
	{
		WriteVectorB(MSG_ENTITY, self.colormod);
		WriteByte(MSG_ENTITY, self.alpha * 255);
		WriteByte(MSG_ENTITY, self.scale * 16);
	}

	return TRUE;
}

void(entity attacker, float dmg) eyeball_pain
{
	self.health = 9999;

	if !(attacker.flags & FL_CLIENT)
		return;
	
	// play sound
	string snd = random_sound_from_noise_fields(self);
	if (snd)
	{
		sound(self, CHAN_AUTO, snd, self.volume, self.atten);
	}
	
	if (time < self.pain_finished)
		return;

	self.pain_finished = time + self.wait;
	SUB_UseTargets();

	self.attack_finished = time + 0.35; // Reki (September 21 2023): this is a hack, the eyeball should move back with the tag but for now I'll just delete it since the model isn't animated for it yet.
	self.owner.frame = 1;
	//Steam_AchievementUnlock(attacker, ST_ACHIEVEMENTS::SP_JOKE_E3M2);
}

void() eyeball_cphysics =
{
	if (self.origin != self.oldorigin)
	{
		self.SendFlags |= 0x01;
		self.oldorigin = self.origin;
	}

	if (self.attack_finished && time > self.attack_finished)
	{
		remove(self);
	}

	self.think = eyeball_cphysics;
	self.nextthink = time + 0.1;
}

void() object_eyeball =
{
	if (!self.model)
	{
		remove(self);
		return;
	}

	if (self.modelscale)
		self.scale = self.modelscale;

	if (!self.volume)
		self.volume = 1;
		
	if (!self.atten)
		self.atten = ATTN_NORM;

	if (!self.wait)
		self.wait = 5;
	
	precache_noise_fields(self);
	entity lid = spawn();

	// eyeball
	precache_model(self.model);
	setmodel(self, self.model);
	self.SendEntity = SendEntity_object_eyeball;
	self.takedamage = DAMAGE_YES;
	self.bloodimpact = 6; // BIG blood poof
	self.solid = SOLID_BSP;
	self.th_pain = eyeball_pain;
	self.th_die = SUB_Null;
	self.health = 9999;
	self.owner = lid;
	self.think = eyeball_cphysics;
	self.nextthink = time + 0.1;

	// lid
	setorigin(lid, self.origin);
	setmodel(lid, "models/objects/eyeball/eyelid.md3");
	lid.angles = self.angles; lid.angles[0] *= -1;
	setattachment(self, lid, "tag_eye");
	//float tagind = gettagindex(lid, "tag_eye");
	//setorigin(self, gettaginfo(lid, tagind));
}
