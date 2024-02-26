void() beam_pillar = { self.alpha = self.owner.glowmod_x;
	self.nextthink = time + 0.05;

	if (self.alpha < 1)
		self.think = beam_pillar;
	else
		self.think = SUB_Null;
};
var float relics_forhub = 5;
.float used_relicsinhub;
void() ethink = 
{
	SUB_UseTargets();
};
void() animate_pillar = { self.frame++;

	self.glowmod_x += 0.025;
	self.glowmod_y += 0.025;
	self.glowmod_z += 0.025;

	if (self.frame < 39)
		self.think = animate_pillar;
	else
	{
		local entity pl;
		pl = find(world, classname, "player");
		pl.used_relicsinhub++;
		if (pl.used_relicsinhub == relics_forhub)
		{
			//pl.splashtime = time + 5;
			self.target = self.owner.target;
			SUB_UseTargets();
			//pl.oldrelics = 0;
			pl.used_relicsinhub = 0; // activated, so reset for next hub
		}

		self.think = SUB_Null;
	}

	self.nextthink = time + 0.05;
};

void() activate_pillar_a = { if (self.owner.pillar_a_activated)
		self.think = animate_pillar;
	else
		self.think = activate_pillar_a;
	self.nextthink = time + 0.05;
};

void() activate_pillar_b = { if (self.owner.pillar_b_activated)
		self.think = animate_pillar;
	else
		self.think = activate_pillar_b;
	self.nextthink = time + 0.05;
};
void() activate_pillar_c = { if (self.owner.pillar_c_activated)
		self.think = animate_pillar;
	else
		self.think = activate_pillar_c;
	self.nextthink = time + 0.05;
};
void() activate_pillar_d = { if (self.owner.pillar_d_activated)
		self.think = animate_pillar;
	else
		self.think = activate_pillar_d;
	self.nextthink = time + 0.05;
};
void() activate_pillar_e = { if (self.owner.pillar_e_activated)
		self.think = animate_pillar;
	else
		self.think = activate_pillar_e;
	self.nextthink = time + 0.05;
};
void() pillar_usekey = {
	if (!(other.relics & self.relics))
		return;
	sound(self, CHAN_AUTO, self.noise, 1, 0.25);
	.float ptr = self.f_fieldpointer;
	if (ptr)
		self.owner.ptr = 1;
	self.usable = 0;
	other.relics &= ~self.relics;

	relic_removefromslot(other, self.relics);
	//self = other; // we need player for this 
	//quitrelic(1); // <<
};
void() portal_hub1 = { precache_model("models/objects/hubs/hub1_portal.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_a.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_a_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_b.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_b_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_c.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_c_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_d.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_d_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_e.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_e_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_beam.md3");
	precache_sound("objects/hub1_pillar.ogg");
	setmodel(self, "models/objects/hubs/hub1_portal.md3");
	relics_forhub = 5;

	local entity pillar_a, pillar_a_mesh, pillar_a_beam;

	pillar_a_mesh = spawn();
	pillar_a_mesh.solid = SOLID_BSP;
	pillar_a_mesh.owner = self;
	local vector tagorg;
	tagorg = tag_origin("tag_a", self);
	pillar_a_mesh.origin = tagorg;
	pillar_a_mesh.usable = 3;
	pillar_a_mesh.usepressed = pillar_usekey;
	pillar_a_mesh.relics = RL_E1M1;
	pillar_a_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_a_mesh.f_fieldpointer = pillar_a_activated;
	pillar_a_mesh.angles = self.angles;
	pillar_a_mesh.classname = "portalhub1_a";
	setmodel(pillar_a_mesh, "models/objects/hubs/hub1_portal_pillar_a_collision.md3");

	pillar_a = spawn();
	pillar_a.owner = self;
	setmodel(pillar_a, "models/objects/hubs/hub1_portal_pillar_a.md3");
	pillar_a.origin = self.origin;
	pillar_a.glowmod = '0.01 0.01 0.01';
	pillar_a.angles = self.angles;
	pillar_a.think = activate_pillar_a;
	pillar_a.nextthink = time;

	/*entity pillar_a_extra = spawn();
	pillar_a_extra.owner = self;
	pillar_a_extra.origin = tagorg + '-28 12 0';
	pillar_a_extra.solid = SOLID_BSP;
	pillar_a_extra.dphitcontentsmask = DPCONTENTS_PLAYERCLIP;
	setsize(pillar_a_extra,'-5 -5 0','5 5 128');*/

	pillar_a_beam = spawn();
	pillar_a_beam.owner = pillar_a;
	setmodel(pillar_a_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_a_beam, pillar_a, "tag_pillar_a");
	pillar_a_beam.alpha = 0.01;
	pillar_a_beam.think = beam_pillar;
	pillar_a_beam.nextthink = time;

	local entity pillar_b, pillar_b_mesh, pillar_b_beam;

	pillar_b_mesh = spawn();
	pillar_b_mesh.solid = SOLID_BSP;
	pillar_b_mesh.owner = self;
	tagorg = tag_origin("tag_b", self);
	pillar_b_mesh.origin = tagorg;
	pillar_b_mesh.usable = 3;
	pillar_b_mesh.usepressed = pillar_usekey;
	pillar_b_mesh.relics = RL_E1M2;
	pillar_b_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_b_mesh.f_fieldpointer = pillar_b_activated;
	pillar_b_mesh.angles = self.angles;
	pillar_b_mesh.classname = "portalhub1_b";
	setmodel(pillar_b_mesh, "models/objects/hubs/hub1_portal_pillar_b_collision.md3");

	pillar_b = spawn();
	pillar_b.owner = self;
	setmodel(pillar_b, "models/objects/hubs/hub1_portal_pillar_b.md3");
	pillar_b.origin = self.origin;
	pillar_b.glowmod = '0.01 0.01 0.01';
	pillar_b.angles = self.angles;
	pillar_b.think = activate_pillar_b;
	pillar_b.nextthink = time;

	pillar_b_beam = spawn();
	pillar_b_beam.owner = pillar_b;
	setmodel(pillar_b_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_b_beam, pillar_b, "tag_pillar_b");
	pillar_b_beam.alpha = 0.01;
	pillar_b_beam.think = beam_pillar;
	pillar_b_beam.nextthink = time;

	local entity pillar_c, pillar_c_mesh, pillar_c_beam;

	pillar_c_mesh = spawn();
	pillar_c_mesh.solid = SOLID_BSP;
	pillar_c_mesh.owner = self;
	tagorg = tag_origin("tag_c", self);
	pillar_c_mesh.origin = tagorg;
	pillar_c_mesh.usable = 3;
	pillar_c_mesh.usepressed = pillar_usekey;
	pillar_c_mesh.relics = RL_E1M3;
	pillar_c_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_c_mesh.f_fieldpointer = pillar_c_activated;
	pillar_c_mesh.angles = self.angles;
	pillar_c_mesh.classname = "portalhub1_c";
	setmodel(pillar_c_mesh, "models/objects/hubs/hub1_portal_pillar_c_collision.md3");

	pillar_c = spawn();
	pillar_c.owner = self;
	setmodel(pillar_c, "models/objects/hubs/hub1_portal_pillar_c.md3");
	pillar_c.origin = self.origin;
	pillar_c.glowmod = '0.01 0.01 0.01';
	pillar_c.angles = self.angles;
	pillar_c.think = activate_pillar_c;
	pillar_c.nextthink = time;

	pillar_c_beam = spawn();
	pillar_c_beam.owner = pillar_c;
	setmodel(pillar_c_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_c_beam, pillar_c, "tag_pillar_c");
	pillar_c_beam.alpha = 0.01;
	pillar_c_beam.think = beam_pillar;
	pillar_c_beam.nextthink = time;

	local entity pillar_d, pillar_d_mesh, pillar_d_beam;

	pillar_d_mesh = spawn();
	pillar_d_mesh.solid = SOLID_BSP;
	pillar_d_mesh.owner = self;
	tagorg = tag_origin("tag_d", self);
	pillar_d_mesh.origin = tagorg;
	pillar_d_mesh.usable = 3;
	pillar_d_mesh.usepressed = pillar_usekey;
	pillar_d_mesh.relics = RL_E1M4;
	pillar_d_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_d_mesh.f_fieldpointer = pillar_d_activated;
	pillar_d_mesh.angles = self.angles;
	pillar_d_mesh.classname = "portalhub1_d";
	setmodel(pillar_d_mesh, "models/objects/hubs/hub1_portal_pillar_d_collision.md3");

	pillar_d = spawn();
	pillar_d.owner = self;
	setmodel(pillar_d, "models/objects/hubs/hub1_portal_pillar_d.md3");
	pillar_d.origin = self.origin;
	pillar_d.glowmod = '0.01 0.01 0.01';
	pillar_d.angles = self.angles;
	pillar_d.think = activate_pillar_d;
	pillar_d.nextthink = time;

	/*entity pillar_d_extra = spawn();
	pillar_d_extra.owner = self;
	pillar_d_extra.origin = tagorg + '-28 -12 0';
	pillar_d_extra.solid = SOLID_BSP;
	pillar_d_extra.dphitcontentsmask = DPCONTENTS_PLAYERCLIP;
	setsize(pillar_d_extra,'-5 -5 0','5 5 128');*/

	pillar_d_beam = spawn();
	pillar_d_beam.owner = pillar_d;
	setmodel(pillar_d_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_d_beam, pillar_d, "tag_pillar_d");
	pillar_d_beam.alpha = 0.01;
	pillar_d_beam.think = beam_pillar;
	pillar_d_beam.nextthink = time;

	local entity pillar_e, pillar_e_mesh, pillar_e_beam;

	pillar_e_mesh = spawn();
	pillar_e_mesh.solid = SOLID_BSP;
	pillar_e_mesh.owner = self;
	tagorg = tag_origin("tag_e", self);
	pillar_e_mesh.origin = tagorg;
	pillar_e_mesh.usable = 3;
	pillar_e_mesh.usepressed = pillar_usekey;
	pillar_e_mesh.relics = RL_E1M5;
	pillar_e_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_e_mesh.f_fieldpointer = pillar_e_activated;
	pillar_e_mesh.angles = self.angles;
	pillar_e_mesh.classname = "portalhub1_e";
	setmodel(pillar_e_mesh, "models/objects/hubs/hub1_portal_pillar_e_collision.md3");

	pillar_e = spawn();
	pillar_e.owner = self;
	setmodel(pillar_e, "models/objects/hubs/hub1_portal_pillar_e.md3");
	pillar_e.origin = self.origin;
	pillar_e.glowmod = '0.01 0.01 0.01';
	pillar_e.angles = self.angles;
	pillar_e.think = activate_pillar_e;
	pillar_e.nextthink = time;

	pillar_e_beam = spawn();
	pillar_e_beam.owner = pillar_e;
	setmodel(pillar_e_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_e_beam, pillar_e, "tag_pillar_e");
	pillar_e_beam.alpha = 0.01;
	pillar_e_beam.think = beam_pillar;
	pillar_e_beam.nextthink = time;

};

void() portal_intro = { precache_model("models/objects/hubs/intro_portal.md3");
	precache_model("models/objects/hubs/intro_portal_pillar_a.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_a_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_beam.md3");
	precache_sound("objects/hub1_pillar.ogg");
	setmodel(self, "models/objects/hubs/intro_portal.md3");
	relics_forhub = 1;
	
	local entity pillar_a, pillar_a_mesh, pillar_a_beam;

	pillar_a_mesh = spawn();
	pillar_a_mesh.solid = SOLID_BSP;
	pillar_a_mesh.owner = self;
	local vector tagorg;
	tagorg = tag_origin("tag_a", self);
	pillar_a_mesh.origin = tagorg;
	pillar_a_mesh.usable = 3;
	pillar_a_mesh.usepressed = pillar_usekey;
	pillar_a_mesh.relics = RL_INTR;
	pillar_a_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_a_mesh.f_fieldpointer = pillar_a_activated;
	pillar_a_mesh.angles = self.angles;
	pillar_a_mesh.classname = "portalintro_a";
	setmodel(pillar_a_mesh, "models/objects/hubs/hub1_portal_pillar_a_collision.md3");

	pillar_a = spawn();
	pillar_a.owner = self;
	setmodel(pillar_a, "models/objects/hubs/intro_portal_pillar_a.md3");
	pillar_a.origin = self.origin;
	pillar_a.glowmod = '0.01 0.01 0.01';
	pillar_a.angles = self.angles;
	pillar_a.think = activate_pillar_a;
	pillar_a.nextthink = time;

	pillar_a_beam = spawn();
	pillar_a_beam.owner = pillar_a;
	setmodel(pillar_a_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_a_beam, pillar_a, "tag_pillar_a");
	pillar_a_beam.alpha = 0.01;
	pillar_a_beam.think = beam_pillar;
	pillar_a_beam.nextthink = time;
};

void() portal_hub2 = { precache_model("models/objects/hubs/hub2_portal.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_a.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_a_collision.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_b.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_b_collision.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_c.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_c_collision.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_d.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_d_collision.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_e.md3");
	precache_model("models/objects/hubs/hub2_portal_pillar_e_collision.md3");
	precache_model("models/objects/hubs/hub1_portal_pillar_beam.md3");
	precache_sound("objects/hub1_pillar.ogg");
	setmodel(self, "models/objects/hubs/hub2_portal.md3");
	relics_forhub = 5;
	
	local entity pillar_a, pillar_a_mesh, pillar_a_beam;

	pillar_a_mesh = spawn();
	pillar_a_mesh.solid = SOLID_BSP;
	pillar_a_mesh.owner = self;
	local vector tagorg;
	tagorg = tag_origin("tag_a", self);
	pillar_a_mesh.origin = tagorg;
	pillar_a_mesh.usable = 3;
	pillar_a_mesh.usepressed = pillar_usekey;
	pillar_a_mesh.relics = RL_E2M1;
	pillar_a_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_a_mesh.f_fieldpointer = pillar_a_activated;
	pillar_a_mesh.angles = self.angles;
	pillar_a_mesh.classname = "portalhub2_a";
	setmodel(pillar_a_mesh, "models/objects/hubs/hub2_portal_pillar_a_collision.md3");

	pillar_a = spawn();
	pillar_a.owner = self;
	setmodel(pillar_a, "models/objects/hubs/hub2_portal_pillar_a.md3");
	pillar_a.origin = self.origin;
	pillar_a.glowmod = '0.01 0.01 0.01';
	pillar_a.angles = self.angles;
	pillar_a.think = activate_pillar_a;
	pillar_a.nextthink = time;

	pillar_a_beam = spawn();
	pillar_a_beam.owner = pillar_a;
	setmodel(pillar_a_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_a_beam, pillar_a, "tag_pillar_a");
	pillar_a_beam.alpha = 0.01;
	pillar_a_beam.think = beam_pillar;
	pillar_a_beam.nextthink = time;

	local entity pillar_b, pillar_b_mesh, pillar_b_beam;

	pillar_b_mesh = spawn();
	pillar_b_mesh.solid = SOLID_BSP;
	pillar_b_mesh.owner = self;
	tagorg = tag_origin("tag_b", self);
	pillar_b_mesh.origin = tagorg;
	pillar_b_mesh.usable = 3;
	pillar_b_mesh.usepressed = pillar_usekey;
	pillar_b_mesh.relics = RL_E2M2;
	pillar_b_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_b_mesh.f_fieldpointer = pillar_b_activated;
	pillar_b_mesh.angles = self.angles;
	pillar_b_mesh.classname = "portalhub2_b";
	setmodel(pillar_b_mesh, "models/objects/hubs/hub2_portal_pillar_b_collision.md3");

	pillar_b = spawn();
	pillar_b.owner = self;
	setmodel(pillar_b, "models/objects/hubs/hub2_portal_pillar_b.md3");
	pillar_b.origin = self.origin;
	pillar_b.glowmod = '0.01 0.01 0.01';
	pillar_b.angles = self.angles;
	pillar_b.think = activate_pillar_b;
	pillar_b.nextthink = time;

	pillar_b_beam = spawn();
	pillar_b_beam.owner = pillar_b;
	setmodel(pillar_b_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_b_beam, pillar_b, "tag_pillar_b");
	pillar_b_beam.alpha = 0.01;
	pillar_b_beam.think = beam_pillar;
	pillar_b_beam.nextthink = time;

	local entity pillar_c, pillar_c_mesh, pillar_c_beam;

	pillar_c_mesh = spawn();
	pillar_c_mesh.solid = SOLID_BSP;
	pillar_c_mesh.owner = self;
	tagorg = tag_origin("tag_c", self);
	pillar_c_mesh.origin = tagorg;
	pillar_c_mesh.usable = 3;
	pillar_c_mesh.usepressed = pillar_usekey;
	pillar_c_mesh.relics = RL_E2M3;
	pillar_c_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_c_mesh.f_fieldpointer = pillar_c_activated;
	pillar_c_mesh.angles = self.angles;
	pillar_c_mesh.classname = "portalhub2_c";
	setmodel(pillar_c_mesh, "models/objects/hubs/hub2_portal_pillar_c_collision.md3");

	pillar_c = spawn();
	pillar_c.owner = self;
	setmodel(pillar_c, "models/objects/hubs/hub2_portal_pillar_c.md3");
	pillar_c.origin = self.origin;
	pillar_c.glowmod = '0.01 0.01 0.01';
	pillar_c.angles = self.angles;
	pillar_c.think = activate_pillar_c;
	pillar_c.nextthink = time;

	pillar_c_beam = spawn();
	pillar_c_beam.owner = pillar_c;
	setmodel(pillar_c_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_c_beam, pillar_c, "tag_pillar_c");
	pillar_c_beam.alpha = 0.01;
	pillar_c_beam.think = beam_pillar;
	pillar_c_beam.nextthink = time;

	local entity pillar_d, pillar_d_mesh, pillar_d_beam;

	pillar_d_mesh = spawn();
	pillar_d_mesh.solid = SOLID_BSP;
	pillar_d_mesh.owner = self;
	tagorg = tag_origin("tag_d", self);
	pillar_d_mesh.origin = tagorg;
	pillar_d_mesh.usable = 3;
	pillar_d_mesh.usepressed = pillar_usekey;
	pillar_d_mesh.relics = RL_E2M4;
	pillar_d_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_d_mesh.f_fieldpointer = pillar_d_activated;
	pillar_d_mesh.angles = self.angles;
	pillar_d_mesh.classname = "portalhub2_d";
	setmodel(pillar_d_mesh, "models/objects/hubs/hub2_portal_pillar_d_collision.md3");

	pillar_d = spawn();
	pillar_d.owner = self;
	setmodel(pillar_d, "models/objects/hubs/hub2_portal_pillar_d.md3");
	pillar_d.origin = self.origin;
	pillar_d.glowmod = '0.01 0.01 0.01';
	pillar_d.angles = self.angles;
	pillar_d.think = activate_pillar_d;
	pillar_d.nextthink = time;

	pillar_d_beam = spawn();
	pillar_d_beam.owner = pillar_d;
	setmodel(pillar_d_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_d_beam, pillar_d, "tag_pillar_d");
	pillar_d_beam.alpha = 0.01;
	pillar_d_beam.think = beam_pillar;
	pillar_d_beam.nextthink = time;

	local entity pillar_e, pillar_e_mesh, pillar_e_beam;

	pillar_e_mesh = spawn();
	pillar_e_mesh.solid = SOLID_BSP;
	pillar_e_mesh.owner = self;
	tagorg = tag_origin("tag_e", self);
	pillar_e_mesh.origin = tagorg;
	pillar_e_mesh.usable = 3;
	pillar_e_mesh.usepressed = pillar_usekey;
	pillar_e_mesh.relics = RL_E2M5;
	pillar_e_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_e_mesh.f_fieldpointer = pillar_e_activated;
	pillar_e_mesh.angles = self.angles;
	pillar_e_mesh.classname = "portalhub2_e";
	setmodel(pillar_e_mesh, "models/objects/hubs/hub2_portal_pillar_e_collision.md3");

	pillar_e = spawn();
	pillar_e.owner = self;
	setmodel(pillar_e, "models/objects/hubs/hub2_portal_pillar_e.md3");
	pillar_e.origin = self.origin;
	pillar_e.glowmod = '0.01 0.01 0.01';
	pillar_e.angles = self.angles;
	pillar_e.think = activate_pillar_e;
	pillar_e.nextthink = time;

	pillar_e_beam = spawn();
	pillar_e_beam.owner = pillar_e;
	setmodel(pillar_e_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_e_beam, pillar_e, "tag_pillar_e");
	pillar_e_beam.alpha = 0.01;
	pillar_e_beam.think = beam_pillar;
	pillar_e_beam.nextthink = time;
};

void() portal_hub3 = { precache_model("models/objects/hubs/hub3_portal.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_a.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_a_collision.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_b.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_b_collision.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_c.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_c_collision.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_d.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_d_collision.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_e.md3");
	precache_model("models/objects/hubs/hub3_portal_pillar_e_collision.md3");
	precache_sound("objects/hub1_pillar.ogg");
	setmodel(self, "models/objects/hubs/hub3_portal.md3");
	relics_forhub = 5;
	
	local entity pillar_a, pillar_a_mesh, pillar_a_beam;

	pillar_a_mesh = spawn();
	pillar_a_mesh.solid = SOLID_BSP;
	pillar_a_mesh.owner = self;
	local vector tagorg;
	tagorg = tag_origin("tag_a", self);
	pillar_a_mesh.origin = tagorg;
	pillar_a_mesh.usable = 3;
	pillar_a_mesh.usepressed = pillar_usekey;
	pillar_a_mesh.relics = RL_E3M1;
	pillar_a_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_a_mesh.f_fieldpointer = pillar_a_activated;
	pillar_a_mesh.angles = self.angles;
	pillar_a_mesh.classname = "portalhub3_a";
	setmodel(pillar_a_mesh, "models/objects/hubs/hub3_portal_pillar_a_collision.md3");

	pillar_a = spawn();
	pillar_a.owner = self;
	setmodel(pillar_a, "models/objects/hubs/hub3_portal_pillar_a.md3");
	pillar_a.origin = self.origin;
	pillar_a.glowmod = '0.01 0.01 0.01';
	pillar_a.angles = self.angles;
	pillar_a.think = activate_pillar_a;
	pillar_a.nextthink = time;

	pillar_a_beam = spawn();
	pillar_a_beam.owner = pillar_a;
	setmodel(pillar_a_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_a_beam, pillar_a, "tag_pillar_a");
	pillar_a_beam.alpha = 0.01;
	pillar_a_beam.think = beam_pillar;
	pillar_a_beam.nextthink = time;

	local entity pillar_b, pillar_b_mesh, pillar_b_beam;

	pillar_b_mesh = spawn();
	pillar_b_mesh.solid = SOLID_BSP;
	pillar_b_mesh.owner = self;
	tagorg = tag_origin("tag_b", self);
	pillar_b_mesh.origin = tagorg;
	pillar_b_mesh.usable = 3;
	pillar_b_mesh.usepressed = pillar_usekey;
	pillar_b_mesh.relics = RL_E3M2;
	pillar_b_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_b_mesh.f_fieldpointer = pillar_b_activated;
	pillar_b_mesh.angles = self.angles;
	pillar_b_mesh.classname = "portalhub3_b";
	setmodel(pillar_b_mesh, "models/objects/hubs/hub3_portal_pillar_b_collision.md3");

	pillar_b = spawn();
	pillar_b.owner = self;
	setmodel(pillar_b, "models/objects/hubs/hub3_portal_pillar_b.md3");
	pillar_b.origin = self.origin;
	pillar_b.glowmod = '0.01 0.01 0.01';
	pillar_b.angles = self.angles;
	pillar_b.think = activate_pillar_b;
	pillar_b.nextthink = time;

	pillar_b_beam = spawn();
	pillar_b_beam.owner = pillar_b;
	setmodel(pillar_b_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_b_beam, pillar_b, "tag_pillar_b");
	pillar_b_beam.alpha = 0.01;
	pillar_b_beam.think = beam_pillar;
	pillar_b_beam.nextthink = time;

	local entity pillar_c, pillar_c_mesh, pillar_c_beam;

	pillar_c_mesh = spawn();
	pillar_c_mesh.solid = SOLID_BSP;
	pillar_c_mesh.owner = self;
	tagorg = tag_origin("tag_c", self);
	pillar_c_mesh.origin = tagorg;
	pillar_c_mesh.usable = 3;
	pillar_c_mesh.usepressed = pillar_usekey;
	pillar_c_mesh.relics = RL_E3M3;
	pillar_c_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_c_mesh.f_fieldpointer = pillar_c_activated;
	pillar_c_mesh.angles = self.angles;
	pillar_c_mesh.classname = "portalhub3_c";
	setmodel(pillar_c_mesh, "models/objects/hubs/hub3_portal_pillar_c_collision.md3");

	pillar_c = spawn();
	pillar_c.owner = self;
	setmodel(pillar_c, "models/objects/hubs/hub3_portal_pillar_c.md3");
	pillar_c.origin = self.origin;
	pillar_c.glowmod = '0.01 0.01 0.01';
	pillar_c.angles = self.angles;
	pillar_c.think = activate_pillar_c;
	pillar_c.nextthink = time;

	pillar_c_beam = spawn();
	pillar_c_beam.owner = pillar_c;
	setmodel(pillar_c_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_c_beam, pillar_c, "tag_pillar_c");
	pillar_c_beam.alpha = 0.01;
	pillar_c_beam.think = beam_pillar;
	pillar_c_beam.nextthink = time;

	local entity pillar_d, pillar_d_mesh, pillar_d_beam;

	pillar_d_mesh = spawn();
	pillar_d_mesh.solid = SOLID_BSP;
	pillar_d_mesh.owner = self;
	tagorg = tag_origin("tag_d", self);
	pillar_d_mesh.origin = tagorg;
	pillar_d_mesh.usable = 3;
	pillar_d_mesh.usepressed = pillar_usekey;
	pillar_d_mesh.relics = RL_E3M4;
	pillar_d_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_d_mesh.f_fieldpointer = pillar_d_activated;
	pillar_d_mesh.angles = self.angles;
	pillar_d_mesh.classname = "portalhub3_d";
	setmodel(pillar_d_mesh, "models/objects/hubs/hub3_portal_pillar_d_collision.md3");

	pillar_d = spawn();
	pillar_d.owner = self;
	setmodel(pillar_d, "models/objects/hubs/hub3_portal_pillar_d.md3");
	pillar_d.origin = self.origin;
	pillar_d.glowmod = '0.01 0.01 0.01';
	pillar_d.angles = self.angles;
	pillar_d.think = activate_pillar_d;
	pillar_d.nextthink = time;

	pillar_d_beam = spawn();
	pillar_d_beam.owner = pillar_d;
	setmodel(pillar_d_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_d_beam, pillar_d, "tag_pillar_d");
	pillar_d_beam.alpha = 0.01;
	pillar_d_beam.think = beam_pillar;
	pillar_d_beam.nextthink = time;

	local entity pillar_e, pillar_e_mesh, pillar_e_beam;

	pillar_e_mesh = spawn();
	pillar_e_mesh.solid = SOLID_BSP;
	pillar_e_mesh.owner = self;
	tagorg = tag_origin("tag_e", self);
	pillar_e_mesh.origin = tagorg;
	pillar_e_mesh.usable = 3;
	pillar_e_mesh.usepressed = pillar_usekey;
	pillar_e_mesh.relics = RL_E3M5;
	pillar_e_mesh.noise = "objects/hub1_pillar.ogg";
	pillar_e_mesh.f_fieldpointer = pillar_e_activated;
	pillar_e_mesh.angles = self.angles;
	pillar_e_mesh.classname = "portalhub3_e";
	setmodel(pillar_e_mesh, "models/objects/hubs/hub3_portal_pillar_e_collision.md3");

	pillar_e = spawn();
	pillar_e.owner = self;
	setmodel(pillar_e, "models/objects/hubs/hub3_portal_pillar_e.md3");
	pillar_e.origin = self.origin;
	pillar_e.glowmod = '0.01 0.01 0.01';
	pillar_e.angles = self.angles;
	pillar_e.think = activate_pillar_e;
	pillar_e.nextthink = time;

	pillar_e_beam = spawn();
	pillar_e_beam.owner = pillar_e;
	setmodel(pillar_e_beam, "models/objects/hubs/hub1_portal_pillar_beam.md3");
	setattachment(pillar_e_beam, pillar_e, "tag_pillar_e");
	pillar_e_beam.alpha = 0.01;
	pillar_e_beam.think = beam_pillar;
	pillar_e_beam.nextthink = time;
};

