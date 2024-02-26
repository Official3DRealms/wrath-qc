.float urn_armor;
.float urn_health;
.float urn_ammo;
.float urn_artifacts;
void(string locsound, float rndl, float vol) randomsound;
entity(vector org, string class, float ammount, entity ownr) drop_item;
void() urn_die = { local vector tagorg;
	local float tagindex;
	local string tagname;
	tagname = ("tag_item");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	if(self.episode == 2)
		tagorg_z += 24;
	self.classentity = "deadurn";
	float spitch;
	if (self.classname == "breakable_urn_small")
	{
		if(self.episode == 1)
			pointparticles(particleeffectnum("ep1urn1"), tagorg, '0 0 0', 1);
		if(self.episode == 2)
			pointparticles(particleeffectnum("ep2urn1"), tagorg - '0 0 16', '0 0 0', 1);
		if(self.episode == 3)
			pointparticles(particleeffectnum("ep3urn1"), tagorg - '0 0 16', '0 0 0', 1);
		spawngibs("tag_giba", self.gibmodel1, self, relvel('-15 15  0', self));
		spawngibs("tag_gibb", self.gibmodel2, self, relvel('20 10  0', self));
		spawngibs("tag_gibc", self.gibmodel3, self, relvel('-15 -15  0', self));
		spawngibs("tag_gibc", self.gibmodel4, self, relvel('20 -20  0', self));
		spitch = 100;
	}
	if (self.classname == "breakable_urn_medium")
	{
		if(self.episode == 1)
			pointparticles(particleeffectnum("ep1urn2"), tagorg, '0 0 0', 1);
		if(self.episode == 2)
			pointparticles(particleeffectnum("ep2urn2"), tagorg - '0 0 16', '0 0 0', 1);
		if(self.episode == 3)
			pointparticles(particleeffectnum("ep3urn2"), tagorg - '0 0 16', '0 0 0', 1);

		spawngibs("tag_giba", self.gibmodel1, self, relvel('-20 20  0', self));
		spawngibs("tag_gibb", self.gibmodel2, self, relvel('20 -20  0', self));
		spawngibs("tag_gibc", self.gibmodel3, self, relvel('-20 -20  0', self));
		spawngibs("tag_gibd", self.gibmodel4, self, relvel('20 20  0', self));
		spitch = 85;
	}
	if (self.classname == "breakable_urn_large")
	{
		if(self.episode == 1)
			pointparticles(particleeffectnum("ep1urn3"), tagorg, '0 0 0', 1);
		if(self.episode == 2)
			pointparticles(particleeffectnum("ep2urn3"), tagorg - '0 0 16', '0 0 0', 1);
		if(self.episode == 3)
			pointparticles(particleeffectnum("ep3urn3"), tagorg - '0 0 16', '0 0 0', 1);

		spawngibs("tag_giba", self.gibmodel1, self, relvel('-30 30  0', self));
		spawngibs("tag_gibb", self.gibmodel2, self, relvel('0 -60  0', self));
		spawngibs("tag_gibc", self.gibmodel3, self, relvel('30 30  0', self));
		spawngibs("tag_gibd", self.gibmodel4, self, relvel('30 -30  0', self));
		spitch = 70;

	}

	if(spitch <= 85)
	randomsound7("impact/destruct/urn_break", 5,1, spitch,1);

	randomsound("impact/destruct/urn_break", 5,0.7);

	if (self.urn_health == 1)
		drop_item(tagorg, "vial", 1, self);
	if (self.urn_health == 2)
		drop_item(tagorg, "beaker", 1, self);
	if (self.urn_health == 3)
		drop_item(tagorg, "chalice", 1, self);

	if (self.urn_armor == 1)
		drop_item(tagorg, "armor", 1, self);
	if (self.urn_armor == 2)
		drop_item(tagorg, "shard", 1, self);
	if (self.urn_armor == 3)
		drop_item(tagorg, "helm", 1, self);
	if (self.urn_armor == 4)
		drop_item(tagorg, "armor_dark", 1, self);
	if (self.urn_armor == 5)
		drop_item(tagorg, "shard_dark", 1, self);
	if (self.urn_armor == 6)
		drop_item(tagorg, "helm_dark", 1, self);

	if (self.urn_ammo == 1)
		drop_item(tagorg, "ammo_revolver", 15, self);
	if (self.urn_ammo == 2)
		drop_item(tagorg, "ammo_shotgun", 20, self);
	if (self.urn_ammo == 3)
		drop_item(tagorg, "ammo_spitter", 15, self);
	if (self.urn_ammo == 4)
		drop_item(tagorg, "ammo_retcher", 3, self);
	if (self.urn_ammo == 5)
		drop_item(tagorg, "ammo_cannon", 10, self);
	if (self.urn_ammo == 6)
		drop_item(tagorg, "ammo_lance", 5, self);
	if (self.urn_ammo == 7)
		drop_item(tagorg, "ammo_crystal", 20, self);
	if (self.urn_ammo == 8)
		drop_item(tagorg, "ammo_soul", 1, self);



	if (self.urn_artifacts == 1)
		drop_item(tagorg, "mark", 1, self);
	if (self.urn_artifacts == 2)
		drop_item(tagorg, "apparatus", 1, self);
	if (self.urn_artifacts == 3)
		drop_item(tagorg, "flaskrage", 1, self);
	if (self.urn_artifacts == 4)
		drop_item(tagorg, "attar", 1, self);
	if (self.urn_artifacts == 5)
		drop_item(tagorg, "tether", 1, self);
	if (self.urn_artifacts == 6)
		drop_item(tagorg, "siphon", 1, self);
	if (self.urn_artifacts == 7)
		drop_item(tagorg, "trinket", 1, self);
	if (self.urn_artifacts == 8)
		drop_item(tagorg, "aegis", 1, self);
	if (self.urn_artifacts == 9)
		drop_item(tagorg, "vicious", 1, self);
	if (self.urn_artifacts == 10)
		drop_item(tagorg, "shockwave", 1, self);
	if (self.urn_artifacts == 11)
		drop_item(tagorg, "grenade", 1, self);

	setmodel(self, self.dmodel);
	self.solid = SOLID_NOT;
	setsize(self, '0 0 0', '0 0 0');
};

void() breakable_urn_small = 
{
	if(!self.episode)
		self.episode = world.episode;

	if((self.episode == 2) && (!self.skin))
	{
		string cipherx = (ftos(floor((self.origin_x +self.origin_y) * 0.35 )));
		float nLength = strlen(cipherx) -1;
		string characterx = substring (cipherx,nLength,1); 

		float characterf = stof(characterx);
		if(characterf == 1)
		self.skin = 1;
		if(characterf == 2)
		self.skin = 1;
		if(characterf == 7)
		self.skin = 1;
		if(characterf == 8)
		self.skin = 1;
		if(characterf == 5)
		self.skin = 1;
		self.cnt = characterf;


	}


	if(self.episode ==  1)
	{
		self.gibmodel1 = ("models/destruct/urns/urn32_gibs/urn32_giba.md3");
		self.gibmodel2 = ("models/destruct/urns/urn32_gibs/urn32_gibb.md3");
		self.gibmodel3 = ("models/destruct/urns/urn32_gibs/urn32_gibc.md3");
		self.gibmodel4 = ("models/destruct/urns/urn32_gibs/urn32_gibd.md3");
		precache_model("models/destruct/urns/urn32.md3");
		precache_model("models/destruct/urns/urn32_destroyed.md3");
		setmodel(self, "models/destruct/urns/urn32.md3");
		self.dmodel = "models/destruct/urns/urn32_destroyed.md3";
	}

	if(self.episode ==  2)
	{
		self.gibmodel1 = ("models/destruct/e2urns/urn32_gibs/urn32_giba.md3");
		self.gibmodel2 = ("models/destruct/e2urns/urn32_gibs/urn32_gibb.md3");
		self.gibmodel3 = ("models/destruct/e2urns/urn32_gibs/urn32_gibc.md3");
		self.gibmodel4 = ("models/destruct/e2urns/urn32_gibs/urn32_gibd.md3");
		precache_model("models/destruct/e2urns/urn32.md3");
		precache_model("models/destruct/e2urns/urn32_destroyed.md3");
		setmodel(self, "models/destruct/e2urns/urn32.md3");
		self.dmodel = "models/destruct/e2urns/urn32_destroyed.md3";
	}

	if(self.episode ==  3)
	{
		self.gibmodel1 = ("models/destruct/e3urns/urn32_gibs/urn32_giba.md3");
		self.gibmodel2 = ("models/destruct/e3urns/urn32_gibs/urn32_gibb.md3");
		self.gibmodel3 = ("models/destruct/e3urns/urn32_gibs/urn32_gibc.md3");
		self.gibmodel4 = ("models/destruct/e3urns/urn32_gibs/urn32_gibd.md3");
		precache_model("models/destruct/e3urns/urn32.md3");
		precache_model("models/destruct/e3urns/urn32_destroyed.md3");
		setmodel(self, "models/destruct/e3urns/urn32.md3");
		self.dmodel = "models/destruct/e3urns/urn32_destroyed.md3";
	}

	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	if (!self.health)
		self.health = 10;
	self.classentity = "wrathbreakable";

	setsize(self, '-12 -12 0', '12 12 32');
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.th_die = urn_die;
	self.takedamage = DAMAGE_YES;
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_urn_medium = 
{
	if(!self.episode)
		self.episode = world.episode;
		
	if((self.episode == 2) && (!self.skin))
	{
		string cipherx = (ftos(floor((self.origin_x +self.origin_y) * 0.35 )));
		float nLength = strlen(cipherx) -1;
		string characterx = substring (cipherx,nLength,1); 

		float characterf = stof(characterx);
		if(characterf == 1)
		self.skin = 1;
		if(characterf == 3)
		self.skin = 1;
		if(characterf == 7)
		self.skin = 1;
		if(characterf == 8)
		self.skin = 1;
		if(characterf == 6)
		self.skin = 1;
		self.cnt = characterf;


	}

	if(self.episode ==  1)
	{
		self.gibmodel1 = ("models/destruct/urns/urn48_gibs/urn48_giba.md3");
		self.gibmodel2 = ("models/destruct/urns/urn48_gibs/urn48_gibb.md3");
		self.gibmodel3 = ("models/destruct/urns/urn48_gibs/urn48_gibc.md3");
		self.gibmodel4 = ("models/destruct/urns/urn48_gibs/urn48_gibd.md3");
		precache_model("models/destruct/urns/urn48.md3");
		precache_model("models/destruct/urns/urn48_destroyed.md3");
		setmodel(self, "models/destruct/urns/urn48.md3");
		self.dmodel = "models/destruct/urns/urn48_destroyed.md3";
	}

	if(self.episode ==  2)
	{
		self.gibmodel1 = ("models/destruct/e2urns/urn48_gibs/urn48_giba.md3");
		self.gibmodel2 = ("models/destruct/e2urns/urn48_gibs/urn48_gibb.md3");
		self.gibmodel3 = ("models/destruct/e2urns/urn48_gibs/urn48_gibc.md3");
		self.gibmodel4 = ("models/destruct/e2urns/urn48_gibs/urn48_gibd.md3");
		precache_model("models/destruct/e2urns/urn48.md3");
		precache_model("models/destruct/e2urns/urn48_destroyed.md3");
		setmodel(self, "models/destruct/e2urns/urn48.md3");
		self.dmodel = "models/destruct/e2urns/urn48_destroyed.md3";
	}

	if(self.episode ==  3)
	{
		self.gibmodel1 = ("models/destruct/e3urns/urn48_gibs/urn48_giba.md3");
		self.gibmodel2 = ("models/destruct/e3urns/urn48_gibs/urn48_gibb.md3");
		self.gibmodel3 = ("models/destruct/e3urns/urn48_gibs/urn48_gibc.md3");
		self.gibmodel4 = ("models/destruct/e3urns/urn48_gibs/urn48_gibd.md3");
		precache_model("models/destruct/e3urns/urn48.md3");
		precache_model("models/destruct/e3urns/urn48_destroyed.md3");
		setmodel(self, "models/destruct/e3urns/urn48.md3");
		self.dmodel = "models/destruct/e3urns/urn48_destroyed.md3";
	}

	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	if (!self.health)
		self.health = 10;
	self.classentity = "wrathbreakable";

	setsize(self, '-16 -16 0', '16 16 48');
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.th_die = urn_die;
	self.takedamage = DAMAGE_YES;
	self.wrathflags += FL_BREAKABLE;

};

void() breakable_urn_large = { 

	if(!self.episode)
		self.episode = world.episode;

	if((self.episode == 2) && (!self.skin))
	{
		string cipherx = (ftos(floor((self.origin_x +self.origin_y) * 0.35 )));
		float nLength = strlen(cipherx) -1;
		string characterx = substring (cipherx,nLength,1); 
		float characterf = stof(characterx);
		if(characterf == 1)
		self.skin = 1;
		if(characterf == 3)
		self.skin = 1;
		if(characterf == 6)
		self.skin = 1;
		if(characterf == 8)
		self.skin = 1;
		if(characterf == 5)
		self.skin = 1;
		self.cnt = characterf;
	}

	if(self.episode ==  1)
	{
		self.gibmodel1 = ("models/destruct/urns/urn64_gibs/urn64_giba.md3");
		self.gibmodel2 = ("models/destruct/urns/urn64_gibs/urn64_gibb.md3");
		self.gibmodel3 = ("models/destruct/urns/urn64_gibs/urn64_gibc.md3");
		self.gibmodel4 = ("models/destruct/urns/urn64_gibs/urn64_gibd.md3");
		precache_model("models/destruct/urns/urn64.md3");
		precache_model("models/destruct/urns/urn64_destroyed.md3");
		setmodel(self, "models/destruct/urns/urn64.md3");
		self.dmodel = "models/destruct/urns/urn64_destroyed.md3";
	}

	if(self.episode ==  2)
	{
		self.gibmodel1 = ("models/destruct/e2urns/urn64_gibs/urn64_giba.md3");
		self.gibmodel2 = ("models/destruct/e2urns/urn64_gibs/urn64_gibb.md3");
		self.gibmodel3 = ("models/destruct/e2urns/urn64_gibs/urn64_gibc.md3");
		self.gibmodel4 = ("models/destruct/e2urns/urn64_gibs/urn64_gibd.md3");
		precache_model("models/destruct/e2urns/urn64.md3");
		precache_model("models/destruct/e2urns/urn64_destroyed.md3");
		setmodel(self, "models/destruct/e2urns/urn64.md3");
		self.dmodel = "models/destruct/e2urns/urn64_destroyed.md3";
	}

	if(self.episode ==  3)
	{
		self.gibmodel1 = ("models/destruct/e3urns/urn64_gibs/urn64_giba.md3");
		self.gibmodel2 = ("models/destruct/e3urns/urn64_gibs/urn64_gibb.md3");
		self.gibmodel3 = ("models/destruct/e3urns/urn64_gibs/urn64_gibc.md3");
		self.gibmodel4 = ("models/destruct/e3urns/urn64_gibs/urn64_gibd.md3");
		precache_model("models/destruct/e3urns/urn64.md3");
		precache_model("models/destruct/e3urns/urn64_destroyed.md3");
		setmodel(self, "models/destruct/e3urns/urn64.md3");
		self.dmodel = "models/destruct/e3urns/urn64_destroyed.md3";
	}


	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	if (!self.health)
		self.health = 10;
	self.classentity = "wrathbreakable";

	setsize(self, '-16 -16 0', '16 16 64');
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.th_die = urn_die;
	self.takedamage = DAMAGE_YES;
	self.wrathflags += FL_BREAKABLE;
};



void() skull_checking_ground =
{
	local float speed;
	local vector hspeedangles;
	local vector hspeed;

	if (((self.oldorigin == self.origin) && (self.movetype != MOVETYPE_TOSS)))
	{
		traceline(self.origin, (self.origin - '0 0 18'), MOVETYPE_WALK, self);
		if ((self.classname == "breakable_skull"))
		{
			traceline(self.origin, (self.origin - '0 0 26'), MOVETYPE_WALK, self);
		}
		if (((trace_fraction == TRUE) && (self.movetype != MOVETYPE_WALK)))
		{
			self.movetype = MOVETYPE_WALK;
			self.velocity_x = (self.velocity_x + (((random() * 240) + 120) * crandom()));
			self.velocity_y = (self.velocity_y + (((random() * 240) + 120) * crandom()));
		}
		if ((trace_fraction == TRUE))
		{
			self.velocity_z = (self.velocity_z + ((random() * STAT_RD_MR) + STAT_JOURNAL));
			self.avelocity_x = ((self.velocity_x * ((random() * MOVETYPE_BOUNCE) + CONTENT_LAVA)) * 0.125);
			self.avelocity_y = ((self.velocity_y * ((random() * MOVETYPE_BOUNCE) + CONTENT_LAVA)) * 1.5);
			self.avelocity_z = ((self.velocity_z * ((random() * MOVETYPE_BOUNCE) + CONTENT_LAVA)) * 0.05);
		}
		else
		{
			self.movetype = MOVETYPE_TOSS;
		}
	}
	else
	{
		if ((self.movetype == MOVETYPE_WALK))
		{
			traceline(self.origin, (self.origin - '0 0 18'), MOVETYPE_WALK, self);
			if ((self.classname == "breakable_skull"))
			{
				traceline(self.origin, (self.origin - '0 0 26'), MOVETYPE_WALK, self);
			}
			if ((trace_fraction != TRUE))
			{
				self.velocity = (self.velocity * ((random() * 0.25) + 0.75));
			}
			speed = vlen(self.velocity);
			if ((speed < MOVETYPE_BOUNCE))
			{
				self.movetype = MOVETYPE_TOSS;
				self.avelocity = VEC_ORIGIN;
				self.velocity = VEC_ORIGIN;
			}
			makevectors(hspeedangles);
			hspeed = (v_forward * speed) + (v_right * speed);
			self.avelocity_x = ((hspeed_x * speed) * MOVETYPE_BOUNCE);
			self.avelocity_z = ((0 * speed) * MOVETYPE_BOUNCE);
		}
	}
	self.solid = FL_SWIM;
	self.health = MOVETYPE_BOUNCE;
	self.takedamage = TRUE;
	self.oldorigin = self.origin;
	if((self.flags & FL_ONGROUND))
	{
		self.nextthink = (time + 0.05);
		self.think = self.th_die;
	}
	else
	self.think = skull_checking_ground;
	self.nextthink = (time + 0.05);
};

void() skull_die =
{
	local vector tagorg;
	local float tagindex;
	local string tagname;
	local float mveldmg;
	local float veldmg;
	local entity fskull;
	local vector dir;
	local vector rvector;

	fskull = findradius(self.origin, STAT_NORMAL_MESSAGES);
	mveldmg = (self.health * 0.25);

	if(self.vgear)
	remove(self.vgear);

	if(mveldmg < -100)
	mveldmg = -100;
	while (fskull)
	{
		if (((fskull.classname == "breakable_skull_small_a") || (fskull.classname == "breakable_skull_small_b") || (fskull.classname == "breakable_skull_small_c")) && (fskull.health >= 10) && (fskull.velocity_z == 0) && (fskull.origin_z > self.origin_z))
		{
			fskull.movetype = MOVETYPE_BOUNCE;
			dir = fskull.origin - self.origin;
			dir = normalize(dir);
			fskull.velocity = (dir * (-50 + mveldmg));
			fskull.velocity_x = fskull.velocity_x * random (1,3);
			fskull.velocity_y = fskull.velocity_y * random (1,3);
			fskull.velocity_z += ((0.25 * fskull.velocity_z) * (fskull.origin_z - self.origin_z))+ random(0,64);
			fskull.avelocity_x = ((fskull.velocity_x * ((random() * MOVETYPE_BOUNCE) + CONTENT_LAVA)) * 0.25);
			fskull.avelocity_y = ((fskull.velocity_y * ((random() * MOVETYPE_BOUNCE) + CONTENT_LAVA)) * 1);
			fskull.avelocity_z = ((fskull.velocity_z * ((random() * MOVETYPE_BOUNCE) + CONTENT_LAVA)) * 0.1) + 64;
			fskull.think = skull_checking_ground;
			fskull.nextthink = (time + 0.35);
		}
		fskull = fskull.chain;
	}
	mveldmg = (self.health * -0.01) + TRUE;
	tagname = "tag_item";
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	pointparticles(particleeffectnum("skull"), tagorg, VEC_ORIGIN, TRUE);

	if(self.classname == "breakable_skull")
	pointparticles(particleeffectnum("skullbig"), tagorg, VEC_ORIGIN, TRUE);

	random();

	self.classentity = "wrathbreakableskull";
	veldmg = (random() * ((mveldmg * MOVETYPE_FLY) - mveldmg)) + mveldmg;
	relvel2('20 0 20', self, veldmg);
	relvel2('20 0 20', self, veldmg);
	spawngibs("tag_front", self.gibmodel1, self, relvel2('20 0 20', self, veldmg));
	random();
	veldmg = (random() * ((mveldmg * MOVETYPE_FLY) - mveldmg)) + mveldmg;
	relvel2('-12 0 20', self, veldmg);
	relvel2('-12 0 20', self, veldmg);
	spawngibs("tag_back", self.gibmodel2, self, relvel2('-12 0 20', self, veldmg));
	random();
	veldmg = (random() * ((mveldmg * MOVETYPE_FLY) - mveldmg)) + mveldmg;
	relvel2('0 20 18', self, veldmg);
	relvel2('0 20 18', self, veldmg);
	spawngibs("tag_r_side", self.gibmodel3, self, relvel2('0 20 18', self, veldmg));
	random();
	veldmg = (random() * ((mveldmg * MOVETYPE_FLY) - mveldmg)) + mveldmg;
	relvel2('0 -12 23', self, veldmg);
	relvel2('0 -12 23', self, veldmg);
	spawngibs("tag_l_side", self.gibmodel4, self, relvel2('0 -12 23', self, veldmg));


	if(!self.maxspeed)
	self.maxspeed = 100;

	sound7 (self, CHAN_BODY, self.noise,1, 0.25,random(80,120),0);


	if (self.urn_health == 1)
		drop_item(tagorg, "vial", 1, self);
	if (self.urn_health == 2)
		drop_item(tagorg, "beaker", 1, self);
	if (self.urn_health == 3)
		drop_item(tagorg, "chalice", 1, self);

	if (self.urn_armor == 1)
		drop_item(tagorg, "armor", 1, self);
	if (self.urn_armor == 2)
		drop_item(tagorg, "shard", 1, self);
	if (self.urn_armor == 3)
		drop_item(tagorg, "helm", 1, self);
	if (self.urn_armor == 4)
		drop_item(tagorg, "armor_dark", 1, self);
	if (self.urn_armor == 5)
		drop_item(tagorg, "shard_dark", 1, self);
	if (self.urn_armor == 6)
		drop_item(tagorg, "helm_dark", 1, self);

	if (self.urn_ammo == 1)
		drop_item(tagorg, "ammo_revolver", 15, self);
	if (self.urn_ammo == 2)
		drop_item(tagorg, "ammo_shotgun", 20, self);
	if (self.urn_ammo == 3)
		drop_item(tagorg, "ammo_spitter", 15, self);
	if (self.urn_ammo == 4)
		drop_item(tagorg, "ammo_retcher", 3, self);
	if (self.urn_ammo == 5)
		drop_item(tagorg, "ammo_cannon", 10, self);
	if (self.urn_ammo == 6)
		drop_item(tagorg, "ammo_lance", 5, self);
	if (self.urn_ammo == 7)
		drop_item(tagorg, "ammo_crystal", 20, self);
	if (self.urn_ammo == 8)
		drop_item(tagorg, "ammo_soul", 1, self);



	if (self.urn_artifacts == 1)
		drop_item(tagorg, "mark", 1, self);
	if (self.urn_artifacts == 2)
		drop_item(tagorg, "apparatus", 1, self);
	if (self.urn_artifacts == 3)
		drop_item(tagorg, "flaskrage", 1, self);
	if (self.urn_artifacts == 4)
		drop_item(tagorg, "attar", 1, self);
	if (self.urn_artifacts == 5)
		drop_item(tagorg, "tether", 1, self);
	if (self.urn_artifacts == 6)
		drop_item(tagorg, "siphon", 1, self);
	if (self.urn_artifacts == 7)
		drop_item(tagorg, "trinket", 1, self);
	if (self.urn_artifacts == 8)
		drop_item(tagorg, "aegis", 1, self);
	if (self.urn_artifacts == 9)
		drop_item(tagorg, "vicious", 1, self);
	if (self.urn_artifacts == 10)
		drop_item(tagorg, "shockwave", 1, self);
	if (self.urn_artifacts == 11)
		drop_item(tagorg, "grenade", 1, self);

	self.wrathflags = FL_MONSTER;

	setmodel(self, self.dmodel);
	vector tagdest = tag_origin("tag_base", self);
	setorigin (self,tagdest);
	self.movetype = MOVETYPE_BOUNCE;
	if(self.flags & FL_ONGROUND)
		self.flags -= FL_ONGROUND;
	self.bouncefactor = 0.35;
	self.alpha = TRUE;
	self.solid = FALSE;
	self.skin = FALSE;
	rvector_x = (random() * STAT_AMMO_SHOTGUN) + -20;
	self.avelocity = (rvector * veldmg);
	self.avelocity_x = 0;
	self.avelocity_z = 0;
	self.velocity += relvel('-32 0 16', self);
	self.velocity = self.velocity *  (self.health * 0.25);
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.think = gibalphafade4;
	self.nextthink = time + 3 + random(0,5);
};
.float clipdist;
.string oldmodel;
float(entity targ) visibleworld;

void() skull_clipdist_check =
{
	//float dist = vlen(self.origin - single_player.origin);
	//if ((dist < self.owner.clipdist) && (visibleworld(single_player)))

	if(	self.owner.classentity == "wrathbreakable")
	{
		if(checkpvs(self.origin,single_player) )
		{
			if(self.owner.cnt != 1)
			{
				self.owner.cnt = 1;
				setmodel(self.owner,self.owner.oldmodel);
			}
		}
		else
		{
			if((self.owner.cnt != 0))
			{
				self.owner.cnt = 0;
				setmodel(self.owner,"models/misc/null.md3");
			}
		}
	}
	else
		remove(self);
	self.think = skull_clipdist_check;
	self.nextthink = time + 0.05;
};
void() skull_calculate_movetype =
{
	self.classentity = "wrathbreakable";
	self.oldmodel = self.model;
	entity checkerclip = spawn();
	checkerclip.origin = self.origin;
	checkerclip.owner = self;
	self.vgear = checkerclip;
	checkerclip.think = skull_clipdist_check;
	checkerclip.nextthink = time;

	if(self.count != 1)
	{
		self.angles_x = self.angles_x * -1;
		self.count = 1;
	}
	self.movetype = 0;
	

};

void() breakable_skull =
{


	self.noise = "impact/destruct/skullbreak_big.ogg";
	precache_sound ( self.noise);

	if (!self.type)
	{
		self.type = 1;
	}

	if (self.type > 8)
 	{
 		self.type = 8;
 	}
	if ((self.type == 1))
 	{
		self.gibmodel1 = "models/destruct/skulls/b_skull1_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull1_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull1_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull1_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull1_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull1.md3";
 	}
	if ((self.type == 2))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull2_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull2_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull2_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull2_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull2_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull2.md3";
	}
	if ((self.type == 3))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull3_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull3_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull3_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull3_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull3_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull3.md3";
	}
	if ((self.type == 4))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull4_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull4_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull4_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull4_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull4_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull4.md3";
	}
	if ((self.type == 5))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull5_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull5_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull5_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull5_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull5_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull5.md3";
	}
	if ((self.type == 6))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull6_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull6_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull6_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull6_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull6_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull6.md3";
	}
	if ((self.type == 7))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull7_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull7_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull7_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull7_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull7_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull7.md3";
	}
	if ((self.type == 8))
	{
		self.gibmodel1 = "models/destruct/skulls/b_skull8_gibs/front.md3";
		self.gibmodel2 = "models/destruct/skulls/b_skull8_gibs/back.md3";
		self.gibmodel3 = "models/destruct/skulls/b_skull8_gibs/r_side.md3";
		self.gibmodel4 = "models/destruct/skulls/b_skull8_gibs/l_side.md3";
		self.dmodel = "models/destruct/skulls/b_skull8_gibs/base.md3";
		self.model = "models/destruct/skulls/b_skull8.md3";
	}

	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
	{
		self.health = MOVETYPE_BOUNCE;
	}
	setmodel(self, self.model);
	
	if (self.type == 4)
	setsize(self, '-20 -20 -20', '20 20 20');
	else
	setsize(self, '-16 -16 -16', '16 16 16');
	
	self.takedamage = TRUE;
	self.solid = FL_SWIM;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_skull_small_a =
{
	if (!self.type)
		self.type = 1;
	if ((self.type > MOVETYPE_BOUNCE))
		self.type = MOVETYPE_BOUNCE;
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);

	self.gibmodel1 = "models/destruct/skulls/skull_a_gibs/front.md3";
	self.gibmodel2 = "models/destruct/skulls/skull_a_gibs/back.md3";
	self.gibmodel3 = "models/destruct/skulls/skull_a_gibs/r_side.md3";
	self.gibmodel4 = "models/destruct/skulls/skull_a_gibs/l_side.md3";
	self.dmodel = "models/destruct/skulls/skull_a_gibs/base.md3";
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);
	if ((self.type == 1))
	{
		self.type = floor(random(2,10));
	}
	if ((self.type == 2))
		self.model = "models/destruct/skulls/skull_a2.md3";
	if ((self.type == 3))
		self.model = "models/destruct/skulls/skull_a3.md3";
	if ((self.type == 4))
		self.model = "models/destruct/skulls/skull_a4.md3";
	if ((self.type == 5))
		self.model = "models/destruct/skulls/skull_a5.md3";
	if ((self.type == 6))
		self.model = "models/destruct/skulls/skull_a6.md3";
	if ((self.type == 7))
		self.model = "models/destruct/skulls/skull_a7.md3";
	if ((self.type == 8))
		self.model = "models/destruct/skulls/skull_a8.md3";
	if ((self.type == 9))
		self.model = "models/destruct/skulls/skull_a9.md3";
	if ((self.type == 10))
		self.model = "models/destruct/skulls/skull_a10.md3";
	if(self.spawnflags & 4)
		self.model = "models/destruct/skulls/skull_a1.md3";

	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
	{
		self.health = MOVETYPE_BOUNCE;
	}
	setmodel(self, self.model);
	self.solid = FL_SWIM;
	setsize(self, '-12 -12 -12', '12 12 12');
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_skull_small_b =
{
	if (!self.type)
		self.type = 1;

	if ((self.type > MOVETYPE_TOSS))
		self.type = MOVETYPE_TOSS;
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);

	self.gibmodel1 = "models/destruct/skulls/skull_b_gibs/front.md3";
	self.gibmodel2 = "models/destruct/skulls/skull_b_gibs/back.md3";
	self.gibmodel3 = "models/destruct/skulls/skull_b_gibs/r_side.md3";
	self.gibmodel4 = "models/destruct/skulls/skull_b_gibs/l_side.md3";
	self.dmodel = "models/destruct/skulls/skull_b_gibs/base.md3";
	if ((self.type == 1))
		self.model = "models/destruct/skulls/skull_b1.md3";
	if ((self.type == 2))
		self.model = "models/destruct/skulls/skull_b2.md3";
	if ((self.type == 3))
		self.model = "models/destruct/skulls/skull_b3.md3";
	if ((self.type == 4))
		self.model = "models/destruct/skulls/skull_b4.md3";
	if ((self.type == 5))
		self.model = "models/destruct/skulls/skull_b5.md3";
	if ((self.type == 6))
		self.model = "models/destruct/skulls/skull_b6.md3";
	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
	{
		self.health = MOVETYPE_BOUNCE;
	}
	setmodel(self, self.model);
	setsize(self, '-12 -12 -12', '12 12 12');
	self.solid = FL_SWIM;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_skull_small_c =
{
	if (!self.type)
		self.type = 1;

	if ((self.type > MOVETYPE_WALK))
		self.type = MOVETYPE_WALK;
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);

	self.gibmodel1 = "models/destruct/skulls/skull_c_gibs/front.md3";
	self.gibmodel2 = "models/destruct/skulls/skull_c_gibs/back.md3";
	self.gibmodel3 = "models/destruct/skulls/skull_c_gibs/r_side.md3";
	self.gibmodel4 = "models/destruct/skulls/skull_c_gibs/l_side.md3";
	self.dmodel = "models/destruct/skulls/skull_c_gibs/base.md3";
	if ((self.type == 1))
		self.model = "models/destruct/skulls/skull_c1.md3";
	if ((self.type == 2))
		self.model = "models/destruct/skulls/skull_c2.md3";
	if ((self.type == 3))
		self.model = "models/destruct/skulls/skull_c3.md3";
	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
	{
		self.health = MOVETYPE_BOUNCE;
	}
	setmodel(self, self.model);
	setsize(self, '-12 -12 -12', '12 12 12');
	self.solid = FL_SWIM;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_skull_small_d =
{
	if (!self.type)
		self.type = TRUE;
	if ((self.type > 5))
		self.type = 5;
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);

	self.gibmodel1 = "models/destruct/skulls/skull_d_gibs/front.md3";
	self.gibmodel2 = "models/destruct/skulls/skull_d_gibs/back.md3";
	self.gibmodel3 = "models/destruct/skulls/skull_d_gibs/r_side.md3";
	self.gibmodel4 = "models/destruct/skulls/skull_d_gibs/l_side.md3";
	self.dmodel = "models/destruct/skulls/skull_d_gibs/base.md3";
	if ((self.type == 1))
		self.model = "models/destruct/skulls/skull_d1.md3";
	if ((self.type == 2))
		self.model = "models/destruct/skulls/skull_d2.md3";
	if ((self.type == 3))
		self.model = "models/destruct/skulls/skull_d3.md3";
	if ((self.type == 4))
		self.model = "models/destruct/skulls/skull_d4.md3";
	if ((self.type == 5))
		self.model = "models/destruct/skulls/skull_d5.md3";
	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
		self.health = MOVETYPE_BOUNCE;
	setmodel(self, self.model);
	setsize(self, '-12 -12 -12', '12 12 12');
	self.solid = FL_SWIM;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_skull_small_e =
{
	if (!self.type)
		self.type = 1;
	if (self.type > 8)
		self.type = 8;
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);

	self.gibmodel1 = "models/destruct/skulls/skull_e_gibs/front.md3";
	self.gibmodel2 = "models/destruct/skulls/skull_e_gibs/back.md3";
	self.gibmodel3 = "models/destruct/skulls/skull_e_gibs/r_side.md3";
	self.gibmodel4 = "models/destruct/skulls/skull_e_gibs/l_side.md3";
	self.dmodel = "models/destruct/skulls/skull_e_gibs/base.md3";
	if (self.type == 1)
		self.model = "models/destruct/skulls/skull_e1.md3";
	if (self.type == 2)
		self.model = "models/destruct/skulls/skull_e2.md3";
	if (self.type == 3)
		self.model = "models/destruct/skulls/skull_e3.md3";
	if (self.type == 4)
		self.model = "models/destruct/skulls/skull_e4.md3";
	if (self.type == 5)
		self.model = "models/destruct/skulls/skull_e5.md3";
	if (self.type == 6)
		self.model = "models/destruct/skulls/skull_e6.md3";
	if (self.type == 7)
		self.model = "models/destruct/skulls/skull_e7.md3";
	if (self.type == 8)
		self.model = "models/destruct/skulls/skull_e8.md3";
	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
		self.health = MOVETYPE_BOUNCE;
	setmodel(self, self.model);
	self.solid = FL_SWIM;
	setsize(self, '-12 -12 -12', '12 12 12');
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.wrathflags += FL_BREAKABLE;
};

void() breakable_skull_small_f =
{
	if (!self.type)
		self.type = 1;
	if (self.type > 7)
		self.type = 7;
	self.noise = "impact/destruct/skullbreak_med.ogg";
	precache_sound ( self.noise);

	self.gibmodel1 = "models/destruct/skulls/skull_f_gibs/front.md3";
	self.gibmodel2 = "models/destruct/skulls/skull_f_gibs/back.md3";
	self.gibmodel3 = "models/destruct/skulls/skull_f_gibs/r_side.md3";
	self.gibmodel4 = "models/destruct/skulls/skull_f_gibs/l_side.md3";
	self.dmodel = "models/destruct/skulls/skull_f_gibs/base.md3";
	if (self.type == 1)
		self.model = "models/destruct/skulls/skull_f1.md3";
	if (self.type == 2)
		self.model = "models/destruct/skulls/skull_f2.md3";
	if (self.type == 3)
		self.model = "models/destruct/skulls/skull_f3.md3";
	if (self.type == 4)
		self.model = "models/destruct/skulls/skull_f4.md3";
	if (self.type == 5)
		self.model = "models/destruct/skulls/skull_f5.md3";
	if (self.type == 6)
		self.model = "models/destruct/skulls/skull_f6.md3";
	if (self.type == 7)
		self.model = "models/destruct/skulls/skull_f7.md3";
	precache_model(self.model);
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model(self.dmodel);
	if (!self.health)
		self.health = MOVETYPE_BOUNCE;
	setmodel(self, self.model);
	self.solid = FL_SWIM;
	setsize(self, '-12 -12 -12', '12 12 12');
	self.th_die = skull_die;
	self.takedamage = TRUE;
	self.think = skull_calculate_movetype;
	self.nextthink = (time + 0.1);
	self.wrathflags += FL_BREAKABLE;
};

