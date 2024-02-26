void() bob_blocked = 
{
	if(self.cnt == 1)
		self.cnt = 0;
	else
		self.cnt = 1;
};
void() func_bob_next =
{

	if(self.owner.using == 1)
	{
		setorigin(self, self.owner.origin);

		float dist;

		if(self.owner.cnt == 1)
		{
			dist = vlen (self.owner.ldtdest - self.owner.origin);
			self.owner.velocity = normalize(self.owner.ldtdest - self.owner.origin);
			if( dist < 10)
				self.owner.cnt = 0;
		}
		else
		{
			dist = vlen (self.owner.oldorigin - self.owner.origin);
			self.owner.velocity = normalize(self.owner.oldorigin  - self.owner.origin) ;
			if( dist < 10)
				self.owner.cnt = 1;
		}

		float vfactor = 0.0125 * self.owner.count;

		if (dist < self.owner.distancetotarget)
		{	 
			if (self.owner.speed > (200/20))
				self.owner.speed = self.owner.speed * (1 - (vfactor / 1.5) );
		}
		else
		{
			if(self.owner.speed < self.owner.maxspeed)	
				self.owner.speed = self.owner.speed * (1 + vfactor);
		}
		self.owner.velocity = self.owner.velocity * self.owner.speed;
	}
	else
		self.owner.velocity = '0 0 0';

    self.think = func_bob_next;
	self.nextthink = time + 0.0125;
};

void() func_bob_find = 
{ 
	local entity targ;
	targ = find(world, targetname, self.target);
	self.ldtdest = targ.origin;
	targ = find(world, targetname, self.target2);
	self.oldorigin = targ.origin;
	float dist = vlen (self.oldorigin - self.ldtdest);
	if ((self.distancetotarget) > (dist * 0.5))
		self.distancetotarget = dist * 0.5;
	//self.velocity = '0 0 1';
	//setorigin(self, targ.origin - self.mins);

	local entity velocity_controller = spawn();
	setmodel(velocity_controller,"");
	velocity_controller.movetype = MOVETYPE_NOCLIP;
	velocity_controller.owner = self;
    velocity_controller.think = func_bob_next;
	velocity_controller.nextthink = time + 0.1;
	self.nextthink = self.ltime + 999999999;
	self.think = SUB_Null;
};

void() func_bob =
{
	if(!self.speed)
		self.speed = 512;
	if(!self.using)
		self.using = 1;
	self.maxspeed =  self.speed;
	if(!self.distancetotarget)
		self.distancetotarget = 128;	
	if (!self.count)	
		self.count = 2;	
	if(self.count < 1)
		self.count = 1;
	self.blocked = bob_blocked;
	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.use = toggle_use;
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
    self.think = func_bob_find;
	self.nextthink = self.ltime + 0.1;
};



.float height;
.float phase;
void() func_bobbing_controller_think =
{
	local vector v;
	self.nextthink = time + 0.05;
	// calculate sinewave using makevectors
	makevectors((time * self.owner.cnt + self.owner.phase) * '0 1 0');
	v = self.owner.oldorigin + self.owner.movedir * v_forward_y;
	// * 10 so it will arrive in 0.1 sec
	self.owner.velocity = (v - self.owner.origin) * 10;
};

/*QUAKED func_bobbing (0 .5 .8) ? X_AXIS Y_AXIS
Brush model that moves back and forth on one axis (default Z).
speed : how long one cycle takes in seconds (default 4)
height : how far the cycle moves (default 32)
phase : cycle timing adjustment (0-1 as a fraction of the cycle, default 0)
*/
void() func_bobbing =
{
	local entity controller;

	if (!self.speed)
		self.speed = 16;
	if (!self.height)
		self.height = 32;
	// center of bobbing motion
	self.oldorigin = self.origin;
	// time scale to get degrees
	self.cnt = 360 / self.speed;
	// how far to bob
	//if (self.spawnflags & 1) // X
	//	self.movedir = '1 0 0' * self.height;
	//else if (self.spawnflags & 2) // Y
	//	self.movedir = '0 1 0' * self.height;
	//else // Z
	SetMovedir();
	self.movedir = self.movedir * self.height;

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);

	// wait for targets to spawn
	controller = spawn();
	controller.classname = "func_bobbing_controller";
	controller.owner = self;
	controller.nextthink = time + 1;
	controller.think = func_bobbing_controller_think;
	self.nextthink = self.ltime + 999999999;
	self.think = SUB_Null;

	self.effects |= EF_LOWPRECISION;
};

