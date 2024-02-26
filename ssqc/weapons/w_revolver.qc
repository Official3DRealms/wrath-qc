.float oldammo_revolver;
.float noshells;
.float oldrevolverclip;
.float sfcg;
void() check_revolver;
void() idle_revolver;

void() idle_revolver = 
{ 
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	if (self.sfcg)
		self.sfcg = 0;
	self.realoding = 0;
	if (self.vweaponglowmod_x != -0.1)
		self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.vweaponframe = 1;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.think = idle_revolver;
	self.nextthink = time + 0.1;
};
void(vector org, vector dir, float order, entity ownerproj) launch_projectile_revolver;
void() wsfire_revolver1 =
{
	self.vweaponframe += 1;
	if(self.vweaponframe == 18)
	{
		self.vweaponglowmod = '1 1 1';	
		vector dir;
		string snd;
		makevectors (self.v_angle);
		float wvol = cvar ("weapons_fire_volume");
		snd = strcat ("weapons/revolver/fire2_", ftos (floor(random() * 2) + 1),".ogg");
		sound (self, CHAN_WEAPON, snd, wvol, ATTN_NORM);
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
			self.punchangle_x = -2;

		// Reki (December 3 2023): Added controller rumble
		Controller_Rumble(self, 0.1, 0.2, 240);
		Controller_RumbleTriggers(self, 0.6, 0, 50);
		
		dir = aim (self, 100000);
		vector tagorg;
		if (self.ammo_revolver == 1)
		{
			tagorg = tag_origin("tag_proja",self.vweapon);
			launch_projectile_revolver (tagorg, dir, 1,self);	


			self.ammo_revolver -= 1;
		}
		if (self.ammo_revolver == 2)
		{
			tagorg = tag_origin("tag_proja",self.vweapon);
			launch_projectile_revolver (tagorg, dir, 1,self);	
			tagorg = tag_origin("tag_projb",self.vweapon);
			launch_projectile_revolver (tagorg, dir, 2,self);	
			self.ammo_revolver -= 2;
		}
		if (self.ammo_revolver > 2)
		{
			tagorg = tag_origin("tag_proja",self.vweapon);
			launch_projectile_revolver (tagorg, dir, 1,self);	
			tagorg = tag_origin("tag_projb",self.vweapon);
			launch_projectile_revolver (tagorg, dir, 2,self);	
			tagorg = tag_origin("tag_projc",self.vweapon);
			launch_projectile_revolver (tagorg, dir, 3,self);	
			self.ammo_revolver -= 3;
		}

		


		self.effects += EF_MUZZLEFLASH;
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/revolver/flash_big.md3";
		muzzle = spawn();
		muzzle.owner = self;
		setmodel (muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle,self.vweapon,"tag_muzzle2");
		muzzle.angles_z = random() * 360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
	}	
	if((self.vweaponframe > 18) && (self.vweaponglowmod_x > 0))
	{
		self.vweaponglowmod_x -= 0.05; 
		self.vweaponglowmod_y -= 0.05; 
		self.vweaponglowmod_z -= 0.05;
	}
	if(self.vweaponframe >= 41)
		self.think = idle_revolver;
	else
	self.think = wsfire_revolver1;		
	self.nextthink = time +  0.05;	
};

void() wsfire_revolver = { self.vweaponglowmod = '0.5 0.5 0.5';
	self.vweaponframe = 17;
	self.think = wsfire_revolver1;
	self.nextthink = time + 0.05;
	self.attack_finished = time + 0.9;
	self.time_fire_revolver = time + 0.9;
};

void() wfire_revolver1 = { self.vweaponframe += 1;
	if (self.vweaponframe == 3)
	{
		self.vweaponglowmod = '1 1 1';
		#if 0
		local vector dir;
		local string snd;
		makevectors(self.v_angle);
		snd = strcat("weapons/revolver/fire1_", ftos(floor(random() *3) + 1), ".ogg");
		float wvol = cvar ("weapons_fire_volume");
		sound(self, CHAN_WEAPON, snd, wvol, ATTN_NORM);
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
			self.punchangle_x = -2;
		dir = aim(self, 100000);
		FireBullets(1, dir, '0.01 0.02 0', self.revolver_damage1, self.revolver_spread1);
		self.effects += EF_MUZZLEFLASH;
		self.ammo_revolver -= 1;
		//muzzle_revolver(self.vweapon, 1);
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/revolver/flash_small.md3";
		muzzle = spawn();
		muzzle.owner = self;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
		#endif
	}

	if ((self.vweaponframe > 4) && (self.vweaponglowmod_x > 0))
	{
		self.vweaponglowmod_x -= 0.1;
		self.vweaponglowmod_y -= 0.1;
		self.vweaponglowmod_z -= 0.1;
	}

	if (self.vweaponframe >= 15)
		self.think = idle_revolver;
	else
		self.think = wfire_revolver1;
	self.nextthink = time + 0.05;
};

void() wfire_revolver = { self.vweaponglowmod = '0.5 0.5 0.5';
	self.vweaponframe = 2;
	self.time_fire_revolver = time + 0.35;
	self.think = wfire_revolver1;
	self.nextthink = time + 0.05;

	#if 1
	local vector dir;
	local string snd;
	makevectors(self.v_angle);
	snd = strcat("weapons/revolver/fire1_", ftos(floor(random() *3) + 1), ".ogg");
	float wvol = cvar ("weapons_fire_volume");
	sound(self, CHAN_WEAPON, snd, wvol, ATTN_NORM);
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
		self.punchangle_x = -2;

	// Reki (December 3 2023): Added controller rumble
	Controller_Rumble(self, 0.2, 0.1, 120);
	Controller_RumbleTriggers(self, 0.3, 0, 50);
	
	dir = aim(self, 100000);
	FireBullets(1, dir, '0.01 0.02 0', self.revolver_damage1, self.revolver_spread1);
	self.effects += EF_MUZZLEFLASH;
	self.ammo_revolver -= 1;
	//muzzle_revolver(self.vweapon, 1);
	local entity muzzle;
	local string muzzlemodel;
	muzzlemodel = "models/weapons/revolver/flash_small.md3";
	muzzle = spawn();
	muzzle.owner = self;
	setmodel(muzzle, muzzlemodel);
	muzzle.viewmodelforclient = self;
	setattachment(muzzle, self.vweapon, "tag_muzzle");
	muzzle.angles_z = random() *360;
	muzzle.think = SUB_Remove;
	muzzle.nextthink = time + 0.05;
	#endif
};

void() pick_up_revolver2 = { self.think = idle_revolver;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_revolver = { self.lastweapon = IT_REVOLVER;
	self.weapon = IT_REVOLVER;
	sound(self, CHAN_WEAPON, "weapons/revolver/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponskin = self.revolverclip;
	self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.vweaponstate = 2;
	if (self.noltime < time)
		self.lspeedtime = time + 5;
	self.vweaponframe = 0;
	self.attack_finished = time + 0.05;
	self.think = pick_up_revolver2;
	self.nextthink = time + 5.95;
}

void() raise_revolver2 = { self.vweaponframe += 1;
	if (self.vweaponframe == 45)
		W_SetWeapon();

	if (self.vweaponframe >= 47)
	{
		self.think = idle_revolver;
	}
	else
		self.think = raise_revolver2;
	self.nextthink = time + 0.025;
};

void() raise_revolver = { self.weapon = IT_REVOLVER;
	W_SetWeapon();
	sound(self, CHAN_AUTO, "weapons/revolver/raise.ogg", 1, ATTN_NORM);
	self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.draw_w = 0;
	self.vweaponskin = self.revolverclip;
	self.vweaponframe = 43;
	self.vweaponstate = 1;
	self.attack_finished = time +  0.0125; //0.25;
	self.think = raise_revolver2;
	self.nextthink = time;
};

void() lower_revolver2 = { self.vweaponframe += 1;
	if (self.vweaponframe >= 51)
		self.think = raise_weapon;
	else
		self.think = lower_revolver2;
	self.nextthink = time + 0.025;
};

void() lower_revolver = { sound(self, CHAN_AUTO, "weapons/revolver/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 48;
	self.attack_finished = time + 0.125;
	self.think = lower_revolver2;
	self.vweaponstate = 2;
	self.nextthink = time + 0.025;
};

///////////////////////////////////end of qc file
