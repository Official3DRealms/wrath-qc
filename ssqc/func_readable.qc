.float message_time;
.float message_flag;
.float message_brelease;

void() readable_think = { self.colormod = '1 0 1';
};
void() func_read = { self.classname = "readable";
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.usable = 1;
};
///////////
