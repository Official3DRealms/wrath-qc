.vector vcam;
.float camera_stop;
.string next_camera;

void () deactivate_cameras =
{
	single_player.cutscene = 0;
	single_player.stat_camera = FALSE;
	SetViewPoint(single_player);
};

void() camara_movetarget =
{
	local entity	temp;
	if (other.movetarget != self)
		return;
	if (other.next_camera)
		return;
	if ((self.camera_stop)||(!self.target))
	{
		remove(self);
		remove(other);
		deactivate_cameras();
	}
	other.next_camera = self.next_camera;
	other.style = self.style;
	other.speed = self.speed;
	other.cameratargetname = self.cameratargetname;
	other.cameratarget = self.cameratarget;
	other.wait = self.wait;
	other.vcam = self.vcam;
	other.target = self.target;
	other.targetname = self.targetname;
	if (!(self.cameratarget))
		other.camangles = self.angles;
};

void () missil_stop =
{
	remove(self);
	deactivate_cameras();
};

void() movetarget_camara =
{
	self.solid = SOLID_TRIGGER;
	self.touch = camara_movetarget;
	setsize (self, '-2 -2 -2', '2 2 2');
};

void() path_corner_camera =
{
	setmodel (self, "");
	if (!self.speed)
		self.speed = 100;
	movetarget_camara ();
};

void () asignate_camangles =
{
	local vector vec, vec2, yawx;
	local float yaw, velz;
	local entity campobj;
	campobj = find (world, cameratargetname, self.cameratarget);
	vec = campobj.origin - self.origin;
	yawx= vectoangles(vec);
	yaw = vectoyaw(vec);
	single_player.camera_origin_x = self.origin_x;
	single_player.camera_origin_y = self.origin_y;
	single_player.camera_origin_z = self.origin_z;

	if (self.vcam)
	{
		self.camangles = self.camangles + self.vcam; 
	}
	else
	{
		if (self.style == 1)
		{
			self.camangles_y = self.angles_y; 
			self.camangles_x = self.angles_y; 
			self.camangles_z = 0; 
		}
	}
	single_player.camera_angles_x = self.camangles_x;
	single_player.camera_angles_y = self.camangles_y;
	single_player.camera_angles_z = self.camangles_z;
};

void () camera_go;
void () change_camera_origin =
{
	local entity nextcamera
	nextcamera = find(world, targetname, self.target);
	setorigin (self, nextcamera.origin);
	asignate_camangles();
	self.next_camera = nextcamera.next_camera;
	self.style = nextcamera.style;
	self.speed = nextcamera.speed;
	self.cameratargetname = nextcamera.cameratargetname;
	self.cameratarget = nextcamera.cameratarget;
	self.vcam = nextcamera.vcam;
	self.wait = nextcamera.wait;
	self.target = nextcamera.target;
	self.targetname = nextcamera.targetname;
	self.angles = nextcamera.angles;
	self.camangles =nextcamera.angles;
	self.think = camera_go;
	self.nextthink = time;
};

void() camera_start =
{
	self.goalentity = self.movetarget = find(world, targetname, self.target);
	self.enemy = find(world, targetname, self.target);
	self.velocity = normalize(self.enemy.origin - self.origin);
	makevectors (self.angles);
	self.angles = vectoangles(self.velocity);
	vector vec = self.enemy.origin - self.origin;
	vector yaw= vectoangles(vec);
	ai_face();
	self.angles_x = yaw_x * -1;
	float old_time = time + 0.001 + self.wait;
	if ((time + 0.001) < (time + 0.001 + self.wait) )
	{
		self.nextthink = old_time;
		self.velocity = self.velocity * 0;
		self.wait = 0;
		return;
	}
	self.velocity = self.velocity * self.speed;
	if (self.next_camera)
		self.think = change_camera_origin;
	else
	{
		asignate_camangles();
		self.think = camera_start;
	}
	self.nextthink = time + self.wait;
};

void () camera_go=
{
	SetViewPoint(self);
	self.nextthink = time + self.wait;
	if (self.next_camera)
		self.think = change_camera_origin;
	else
	{
		asignate_camangles();
		self.think = camera_start;
	}
};

void () camera_wait =
{
	if ((world.camera_active > 0))
	{
		self.nextthink = time ;
		self.think =camera_go;	
	}
};

void() camera_use =
{
	single_player.cutscene = 1;
	single_player.stat_camera = 1;
	single_player.camera_origin_x = self.origin_x;
	single_player.camera_origin_y = self.origin_y;
	single_player.camera_origin_z = self.origin_z;
	single_player.camera_angles_x = self.angles_x;
	single_player.camera_angles_y = self.angles_y;
	single_player.camera_angles_z = self.angles_z;
	self.nextthink = time;
	self.think = camera_go;
};

void() missil = // ??? the name :P
{
	self.solid = SOLID_TRIGGER;
	self.classname = "camera_entity";
	self.movetype = MOVETYPE_FLY_WORLDONLY;
	setmodel (self, "models/misc/null.md3");
	setsize (self, '-0 -0 -0', '0 0 0');
	if (!self.speed)
		self.speed = 100;
	if (!self.targetname)
	{
		self.nextthink = time;
		self.think = camera_wait;
	}
	self.use = camera_use;
};//////////
