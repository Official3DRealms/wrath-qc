////////////////////////////editor
.float editingangles;
.float modeeditor;
.float lradius;
.float lcorona;
.float lcoronasize;
.float lshadows;
.float lnormal;

.float lstyle;
.float lambient;

.float lmovex;
.float lmovey;
.float lmovez;
.float lcolorr;
.float lcolorg;
.float lcolorb;
.float ldiffuse;
.float lspecular;

.float lnormalmode;
.float lcubemap;
.float langlesx;
.float langlesy;
.float langlesz;



void()colormodel_think = 
{
	self.colormod_x = single_player.lcolorr;
	self.colormod_y = single_player.lcolorg;
	self.colormod_z = single_player.lcolorb;
	self.glowmod_x = single_player.lcolorr;
	self.glowmod_y = single_player.lcolorg;
	self.glowmod_z = single_player.lcolorb;
	self.scale = single_player.lradius / 200;
	self.think = colormodel_think;
	/*self.skin ++;
	if(self.skin >= 10)
	self.skin = 0;*/

	self.nextthink = time + 0.05;
};
////////////////////////////end-editor

void() PlayerValuesEditor = {	///////////////////////////////editor//////////////////////////
	self.lradius = 200;
	self.lcorona = 0;
	self.lcoronasize = 0;
	self.lstyle = 0;
	self.lambient = 1;
	self.lmovex = 0;
	self.lmovey = 0;
	self.lmovez = 0;
	self.lcolorr = 1;
	self.lcolorg = 1;
	self.lcolorb = 1;
	self.lnormalmode = 0;
	self.ldiffuse = 1;
	self.lspecular = 1;
	self.lcubemap = 1;
	self.langlesx = 0;
	self.langlesy = 0;
	self.langlesz = 0;

	///////////////////////////////editor//////////////////////////
};

void(float orientation) Check_Editor_Commands = {	//local string selfcommand;
	local float selfvalue, selfvalueb, selfvaluec;
	if (self.button3)
	{
		self.lradius = self.lradius + orientation * 5;
		if (self.lradius < 0)
			selfvalue = 0;
		else if (self.lradius > 10000)
			selfvalue = 10000;
		else
			selfvalue = self.lradius;
		localcmd(strcat("r_editlights_edit radius  ", ftos(selfvalue), "\n"));
	}

	if (self.button4)
	{
		self.lstyle = self.lstyle + orientation;
		if (self.lstyle < 0)
			selfvalue = 0;
		else if (self.lstyle > 64)
			selfvalue = 64;
		else
			selfvalue = self.lstyle;
		localcmd(strcat("r_editlights_edit style  ", ftos(selfvalue), "\n"));
	}

	if (self.button5)
	{
		self.lcorona = self.lcorona + orientation *0.1;
		if (self.lcorona < 0)
			selfvalue = 0;
		else if (self.lcorona > 10)
			selfvalue = 10;
		else
			selfvalue = self.lcorona;
		localcmd(strcat("r_editlights_edit corona  ", ftos(selfvalue), "\n"));
	}

	if (self.button6)
	{
		self.lambient = self.lambient + orientation *0.01;
		if (self.lambient < 0)
			selfvalue = 0;
		else if (self.lambient > 1)
			selfvalue = 1;
		else
			selfvalue = self.lambient;
		localcmd(strcat("r_editlights_edit ambient  ", ftos(selfvalue), "\n"));
	}

	if (self.button7)
	{
		self.lcoronasize = self.lcoronasize + orientation *0.01;
		if (self.lcoronasize < 0)
			selfvalue = 0;
		else if (self.lcoronasize > 10)
			selfvalue = 10;
		else
			selfvalue = self.lcoronasize;
		localcmd(strcat("r_editlights_edit coronasize  ", ftos(selfvalue), "\n"));
	}

	if (self.button8)
	{
		self.lcubemap = self.lcubemap + orientation;
		if (self.lcubemap< 0)
			selfvalue = 0;
		else if (self.lcubemap > 256)
			selfvalue = 256;
		else
			selfvalue = self.lcubemap;
		localcmd(strcat("r_editlights_edit cubemap  ", "cubemaps/", ftos(selfvalue), "\n"));
	}

	if (self.button9)
	{
		self.lcolorr = self.lcolorr + orientation *0.01;
		if (self.lcolorr < 0)
			selfvalue = 0;
		else if (self.lcolorr > 10)
			selfvalue = 1;
		else
			selfvalue = self.lcolorr;
		selfvalueb = self.lcolorg;
		selfvaluec = self.lcolorb;
		localcmd(strcat("r_editlights_edit color  ", ftos(selfvalue), " ", ftos(selfvalueb), " ", ftos(selfvaluec), "\n"));
	}

	if (self.button10)
	{
		self.lcolorg = self.lcolorg + orientation *0.01;
		if (self.lcolorg < 0)
			selfvalueb = 0;
		else if (self.lcolorg > 10)
			selfvalueb = 1;
		else
			selfvalueb = self.lcolorg;
		selfvalue = self.lcolorr;
		selfvaluec = self.lcolorb;
		localcmd(strcat("r_editlights_edit color  ", ftos(selfvalue), " ", ftos(selfvalueb), " ", ftos(selfvaluec), "\n"));
	}

	if (self.button11)
	{
		self.lcolorb = self.lcolorb + orientation *0.01;
		if (self.lcolorb < 0)
			selfvaluec = 0;
		else if (self.lcolorg > 10)
			selfvaluec = 10;
		else
			selfvaluec = self.lcolorb;
		selfvalue = self.lcolorr;
		selfvalueb = self.lcolorg;
		localcmd(strcat("r_editlights_edit color  ", ftos(selfvalue), " ", ftos(selfvalueb), " ", ftos(selfvaluec), "\n"));
	}

	if (self.button12)
	{
		if (!self.editingangles)
		{
			if (orientation > 0)
				self.lmovex = 2;
			else
				self.lmovex = -2;
			selfvalue = self.lmovex;
			localcmd(strcat("r_editlights_edit movex  ", ftos(selfvalue), "\n"));
		}
		else
		{
			self.langlesx = self.langlesx + orientation * 1;
			selfvalue = self.langlesx;
			selfvalueb = self.langlesy;
			selfvaluec = self.langlesz;
			localcmd(strcat("r_editlights_edit angles  ", ftos(selfvalue), " ", ftos(selfvalueb), " ", ftos(selfvaluec), "\n"));
		}
	}

	if (self.button13)
	{
		if (!self.editingangles)
		{
			if (orientation > 0)
				self.lmovey = 2;
			else
				self.lmovey = -2;
			selfvalue = self.lmovey;
			localcmd(strcat("r_editlights_edit movey  ", ftos(selfvalue), "\n"));
		}
		else
		{
			self.langlesy = self.langlesy + orientation * 1;
			selfvalueb = self.langlesy;
			selfvalue = self.langlesx;
			selfvaluec = self.langlesz;
			localcmd(strcat("r_editlights_edit angles  ", ftos(selfvalue), " ", ftos(selfvalueb), " ", ftos(selfvaluec), "\n"));
		}
	}

	if (self.button14)
	{
		if (!self.editingangles)
		{
			if (orientation > 0)
				self.lmovez = 2;
			else
				self.lmovez = -2;
			selfvalue = self.lmovez;
			localcmd(strcat("r_editlights_edit movez  ", ftos(selfvalue), "\n"));
		}
		else
		{
			self.langlesz = self.langlesz + orientation * 1;
			selfvaluec = self.langlesz;
			selfvalue = self.langlesx;
			selfvalueb = self.langlesy;
			localcmd(strcat("r_editlights_edit angles  ", ftos(selfvalue), " ", ftos(selfvalueb), " ", ftos(selfvaluec), "\n"));
		}
	}

	if (self.button15)
	{
		self.ldiffuse = self.ldiffuse + orientation *0.1;
		if (self.ldiffuse < 0)
			selfvalue = 0;
		else if (self.ldiffuse > 10)
			selfvalue = 10;
		else
			selfvalue = self.ldiffuse;
		localcmd(strcat("r_editlights_edit diffuse  ", ftos(selfvalue), "\n"));
	}

	if (self.button16)
	{
		self.lspecular = self.lspecular + orientation *0.1;
		if (self.lspecular < 0)
			selfvalue = 0;
		else if (self.lspecular > 10)
			selfvalue = 10;
		else
			selfvalue = self.lspecular;
		localcmd(strcat("r_editlights_edit specular  ", ftos(selfvalue), "\n"));
	}
};

void() Toggle_ShadowLights = { if (self.lshadows)
	{
		self.lshadows = 0;
		localcmd("r_editlights_edit shadows 0\n");
	}
	else
	{
		self.lshadows = 1;
		localcmd("r_editlights_edit shadows 1\n");
	}
};

void() Toggle_NormalLights = { if (self.lnormal)
	{
		self.lnormal = 0;
		localcmd("r_editlights_edit normalmode 0\n");
	}
	else
	{
		self.lnormal = 1;
		localcmd("r_editlights_edit normalmode 1\n");
	}
};

void() Toggle_Angles = { if (self.editingangles)
	{
		self.editingangles = 0;
		centerprint(self, "Editing Origin\n");
	}
	else
	{
		self.editingangles = 1;
		centerprint(self, "Editing Angles\n");
	}
};

void() Toggle_Mode = 
{

	if(world.model == "maps/boss1.bsp")
	{
		entity colormodel = spawn();
		setmodel (colormodel,"models/objects/decor/crystals/crystal_base.md3");
		colormodel.origin = self.origin + '0 0 24';
		colormodel.think = colormodel_think;
		colormodel.nextthink = time;
	}
	if (self.modeeditor)
	{
		self.modeeditor = 0;
		self.movetype = MOVETYPE_WALK;
		//self.solid = SOLID_BBOX;
		stuffcmd(self, "sv_freezenonclients 0\n");
		//localcmd("exec gamebuttons.cfg\n");
		stuffcmd(self, "r_editlights \"0\"\n");
		stuffcmd(self, "unbindall \n");
		stuffcmd(self, "bind F7 \"impulse 208\"\n");
		stuffcmd(self,"exec tempcfg.cfg\n");
	}
	else
	{
		//self.cutscene = 0;
		//self.my_stat_camera = 0;
		self.modeeditor = 1;
		self.movetype = MOVETYPE_NOCLIP;
		//self.solid = SOLID_NOT;
		stuffcmd(self, "saveconfig \"tempcfg.cfg\"\n");
		stuffcmd(self, "sv_freezenonclients 1\n");
		stuffcmd(self, "sv_friction 10\n");
		stuffcmd(self, "bind TAB \"testmenu\"\n");
		stuffcmd(self, "bind SHIFT +button3\n");
		stuffcmd(self, "bind CTRL +button4\n");
		stuffcmd(self, "bind c +button5\n");
		stuffcmd(self, "bind m +button6\n");
		stuffcmd(self, "bind x +button7\n");
		stuffcmd(self, "bind u +button8\n");
		stuffcmd(self, "bind r +button9\n");
		stuffcmd(self, "bind g +button10\n");
		stuffcmd(self, "bind b +button11\n");
		stuffcmd(self, "bind RIGHTARROW +button12\n");
		stuffcmd(self, "bind LEFTARROW +button13\n");
		stuffcmd(self, "bind UPARROW +button14\n");
		stuffcmd(self, "bind i +button15\n");
		stuffcmd(self, "bind o +button16\n");
		stuffcmd(self, "bind SPACE \"+jump\"\n");
		stuffcmd(self, "bind h \"impulse 210\"\n");
		stuffcmd(self, "bind n \"impulse 211\"\n");
		stuffcmd(self, "bind F7 \"impulse 208\"\n");
		stuffcmd(self, "bind alt \"impulse 209\"\n");
		//r_editlights_edit shadows 1);
		stuffcmd(self, "bind MOUSE1 \"r_editlights_spawn\"\n");
		stuffcmd(self, "bind MOUSE2 \"r_editlights_remove\"\n");
		stuffcmd(self, "bind MWHEELUP \"impulse 27\"\n");
		stuffcmd(self, "bind MWHEELDOWN \"impulse 26\"\n");
		stuffcmd(self, "bind p \"r_editlights_save\"\n");
		stuffcmd(self, "r_editlights \"1\"\n");
	}
};

///////////////////////////////////end of qc file
