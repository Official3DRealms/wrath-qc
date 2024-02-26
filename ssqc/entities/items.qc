.float timer_item_cnt;
.float old_cnt;
.float old_item_cnt;

.float oldcnt;

float (string lightstyle_character, float ammountl) glowmodstylevalue =
{


	float multiplier = strstrofs("abcdefghijklmnopqrstuvwxyz", lightstyle_character,0) ;
	return (ammountl  * multiplier);
    
};

void() item_glowmodcontroller_flicker_fade_think =
{
	self.owner.glowmod_x = self.owner.glowmod_x * 0.75; 
    self.owner.glowmod_y = self.owner.glowmod_x;
    self.owner.glowmod_z = self.owner.glowmod_x;



	if(self.owner.glowmod_x < 0.02)
		self.think = SUB_Remove;
	else
	    self.think = item_glowmodcontroller_flicker_fade_think;
    self.nextthink = time + 0.05;
};


void() item_glowmodcontroller_flicker_think = 
{

	if(self.cnt2 >= 4)
		self.cnt2 = 0;
	self.cnt2 ++;


    if(self.cnt >= self.old_cnt)
        self.cnt = 0;
	if(!(self.owner.wrathflags & FL_MISCCONTROLLER))
		remove(self);

    if(self.owner.classname == "func_destruct")
        string glowstyle = "spikpidimkgkqpkmpkipqrqr";
    else
        glowstyle = "spmnpmkmonlnqpnopnmpqrqr";


	string lightstyle_character =  strzone (substring (glowstyle,self.cnt,1)); //;

	string nextlightstyle_character =  strzone (substring (glowstyle,self.cnt + 1,1)); //;


	if(self.cnt2 == 1)
	{
		self.owner.glowmod_x = glowmodstylevalue(lightstyle_character,self.count);
	}
	if(self.cnt2 == 2)
	{
		self.owner.glowmod_x = ((glowmodstylevalue(lightstyle_character,self.count)*0.75) + (glowmodstylevalue(nextlightstyle_character,self.count)) *0.25);
	}
	if(self.cnt2 == 3)
	{
		self.owner.glowmod_x = ((glowmodstylevalue(lightstyle_character,self.count)*0.5) + (glowmodstylevalue(nextlightstyle_character,self.count)) *0.5);
	}
	if(self.cnt2 == 4)
	{
		self.owner.glowmod_x = (glowmodstylevalue(lightstyle_character,self.count)*0.25) + (glowmodstylevalue(nextlightstyle_character,self.count)) *0.75;
	self.cnt ++;
	}

	if(self.owner.classname == "func_destruct")
		self.owner.glowmod_x = self.owner.glowmod_x; 
    self.owner.glowmod_y = self.owner.glowmod_x;
    self.owner.glowmod_z = self.owner.glowmod_x;


    self.think = item_glowmodcontroller_flicker_think;
    self.nextthink = time + 0.025; 
};

void(entity e) item_glowmodcontroller_flicker_spawn =
{
    entity glowmod_controller = spawn();
    glowmod_controller.owner = e;
	e.pipes = glowmod_controller;
	if(!(e.wrathflags & FL_MISCCONTROLLER))
	e.wrathflags += FL_MISCCONTROLLER;
	if(e.classname == "func_destruct")
	    float glowmod_multiplier = 2/22;
	else if(e.classname == "func_water")
	    glowmod_multiplier = 2/22;
	else
	    glowmod_multiplier = 2/26;
	glowmod_controller.classname = "glowmod_controller_pipes";	
    glowmod_controller.count = glowmod_multiplier;
	glowmod_controller.old_cnt = strlen("spmnpmkmonlnqpnopnmpqrq");
    glowmod_controller.think = item_glowmodcontroller_flicker_think;
    glowmod_controller.nextthink = time;
};

void() item_glowmodcontroller_pulse_think =
{
	
	if(!(self.owner.wrathflags & FL_MISCCONTROLLER))
		remove(self);

	if(self.cnt == 1)
	{
		if(self.owner.glowmod_x >= 1)
			self.cnt = 0;
		else  
			self.owner.glowmod_x += 0.05;
	}
	else
	{
		if(self.owner.glowmod_x <= 0.5)
			self.cnt = 1;
		else  
			self.owner.glowmod_x -= 0.05;
	}


    self.owner.glowmod_y = self.owner.glowmod_x;
    self.owner.glowmod_z = self.owner.glowmod_x;
    self.think = item_glowmodcontroller_pulse_think;
    self.nextthink = time + 0.05; 
};

void(entity e) item_glowmodcontroller_pulse_spawn =
{
    entity glowmod_controller = spawn();
    glowmod_controller.owner = e;
	e.wrathflags += FL_MISCCONTROLLER;
	glowmod_controller.owner.glowmod = '1 1 1';
	e.pipes = glowmod_controller;
    glowmod_controller.think = item_glowmodcontroller_pulse_think;
    glowmod_controller.nextthink = time;
};

void() item_colormodcontroller_pulse_think =
{
	
	if(!(self.owner.wrathflags & FL_MISCCONTROLLER))
		remove(self);

	if(self.cnt == 1)
	{
		if(self.owner.colormod_x >= 1)
			self.cnt = 0;
		else  
			self.owner.colormod_x += 0.025;
	}
	else
	{
		if(self.owner.colormod_x <= 0.75)
			self.cnt = 1;
		else  
			self.owner.colormod_x -= 0.025;
	}


    self.owner.colormod_y = self.owner.colormod_x;
    self.owner.colormod_z = self.owner.colormod_x;
    self.think = item_colormodcontroller_pulse_think;
    self.nextthink = time + 0.05; 
};

void(entity e) item_colormodcontroller_pulse_spawn =
{
    entity colormod_controller = spawn();
    colormod_controller.owner = e;
	e.wrathflags += FL_MISCCONTROLLER;
	colormod_controller.owner.colormod = '1 1 1';
	e.pipes = colormod_controller;
    colormod_controller.think = item_colormodcontroller_pulse_think;
    colormod_controller.nextthink = time;
};

void() hud_message2_think = 
{
	if (self.owner.item_cnt)
	{
		self.item_cnt += self.owner.item_cnt;
		self.owner.item_cnt = 0;
		self.cnt = 20;
	}
	self.old_item_cnt = self.item_cnt;
	self.cnt -= 1;
	self.SendFlags |= 0x2;
	if (self.cnt > 0)
		self.think = hud_message2_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};
.float alwaystouchable;

void(entity e) flash_screen_item =
{
	float checked_flash = cvar("saved6");
	if(checked_flash != 1)
		return;
	string flash_command_a = strcat ("bf ",ftos(flash_color_x)," ",ftos(flash_color_y)," ");
	string flash_command_b = strcat (ftos(flash_color_z)," ",ftos(flash_alpha)," ",ftos(flash_fade),"\n");
	string flash_command =  strcat (flash_command_a,flash_command_b);
	stuffcmd (e, flash_command);
}


float() Send_Item2 = 
{
	WriteByte(MSG_ENTITY, ENT::HUDMSG2);
	WriteShort(MSG_ENTITY, self.msg);
	WriteShort(MSG_ENTITY, self.item_cnt);
	return TRUE;
};

float() Send_Item = 
{
	WriteByte(MSG_ENTITY, ENT::HUDMSG);
	WriteShort(MSG_ENTITY, self.msg);
	return TRUE;
};

void(float mtype, vector org, entity ownr, float item_cntr) Hud_message2 = 
{
	//local entity HudMessage;
	if(!(ownr.flags & FL_CLIENT))return;if (ownr.classname != "player")return;
	#if 0
	HudMessage = spawn();
	HudMessage.owner = ownr;
	HudMessage.drawonlytoclient = ownr;
	setmodel(HudMessage, "models/misc/null.md3");
	HudMessage.origin = org + '0 0 25';
	HudMessage.movetype = MOVETYPE_NOCLIP;
	HudMessage.msg = mtype;
	HudMessage.item_cnt = item_cntr;
	HudMessage.cnt = 20;
	HudMessage.wrathflags += FL_MESSAGE;
	HudMessage.SendEntity = Send_Item2;
	//	HudMessage.SendFlags |= 0x2;
	HudMessage.SendFlags = -1;
	HudMessage.think = hud_message2_think;
	HudMessage.nextthink = time;
	#endif
};
.float fullitemtime;
void Hud_SendNotification_Full(entity ownr, string icon, string label, string msg, float msgflags = 0)
{
	msg_entity = ownr;
	WriteByte(MSG_ONE, SVC_TEMPENTITY);
	WriteByte(MSG_ONE, TEMPENT::NOTIFICATION);
	WriteByte(MSG_ONE, msgflags);
	WriteString(MSG_ONE, icon);
	WriteString(MSG_ONE, label);
	WriteString(MSG_ONE, msg);
}

void Hud_SendNotification(entity ownr, string icon, string msg, float msgflags = 0)
{
	Hud_SendNotification_Full(ownr, icon, icon, msg, msgflags);
};

void Hud_SendNotification_Note(entity ownr, string icon, float note)
{
	msg_entity = ownr;
	WriteByte(MSG_ONE, SVC_TEMPENTITY);
	WriteByte(MSG_ONE, TEMPENT::NOTIFICATION_NOTE);
	WriteString(MSG_ONE, icon);
	WriteByte(MSG_ONE, note);
};

void Hud_SendNotification_Control(entity ownr, string format, string cmd)
{
	msg_entity = ownr;
	WriteByte(MSG_ONE, SVC_TEMPENTITY);
	WriteByte(MSG_ONE, TEMPENT::NOTIFICATION_CONTROL);
	WriteByte(MSG_ONE, 0);
	WriteString(MSG_ONE, format);
	WriteString(MSG_ONE, cmd);
};

void Hud_SendNotification_Control2(entity ownr, string format, string cmd, string cmd2)
{
	msg_entity = ownr;
	WriteByte(MSG_ONE, SVC_TEMPENTITY);
	WriteByte(MSG_ONE, TEMPENT::NOTIFICATION_CONTROL);
	WriteByte(MSG_ONE, 1);
	WriteString(MSG_ONE, format);
	WriteString(MSG_ONE, cmd);
	WriteString(MSG_ONE, cmd2);
};


void Hud_CantUseSigilNotification(entity ownr)
{
	if(ownr.time_hudmessage < time)
	{
		stuffcmd (ownr, "bf 0 0 0 0.75 1.5\n");
		sound7(self,CHAN_AUTO,"enemies/keeper/shield_ricochet2.ogg",0.75,0.25,120,0);
		Hud_SendNotification_Full(ownr, "full", "cannotuse_sigils", ("$NOTIFY_CANTUSE_SIGILS"), 0);
		ownr.time_hudmessage = time + 1;
	}
}

void Hud_CantUseArtifactNotification(entity ownr)
{
	if(ownr.time_hudmessage < time)
	{
		stuffcmd (ownr, "bf 0 0 0 0.75 1.5\n");
		sound7(self,CHAN_AUTO,"enemies/keeper/shield_ricochet2.ogg",0.75,0.25,120,0);
		Hud_SendNotification_Full(ownr, "full", "cannotuse_artifacts", ("$NOTIFY_CANTUSE_ARTIFACTS"), 0);
		ownr.time_hudmessage = time + 2;
	}
}

void Hud_CantUseNotification(entity ownr)
{
	if(ownr.time_hudmessage < time)
	{
		stuffcmd (ownr, "bf 0 0 0 0.75 1.5\n");
		sound7(self,CHAN_AUTO,"enemies/keeper/shield_ricochet2.ogg",0.75,0.25,120,0);
		Hud_SendNotification_Full(ownr, "full", "cantuse", ("$NOTIFY_CANTUSE"), 0);
		ownr.time_hudmessage = time + 2;
	}
}

void Hud_FullNotification(entity ownr)
{
	Hud_SendNotification(ownr, "full", "$NOTIFY_FULL");
}

void Hud_JournalNotification(entity ownr)
{
	Hud_SendNotification(ownr, "journal_update", ("$NOTIFY_JOURNALUPDATED"));
}

void(float mtype, vector org, entity ownr) Hud_message = 
{ 
	if(!(ownr.flags & FL_CLIENT))
		return;
	if (ownr.classname != "player")
		return;
	
	Hud_SendNotification(ownr, "gfx/hud/messages/icons/msgicon_full", "Placeholder");
	
	#if 0
	ownr.stat_time_hudmessage = 1;
	/*if(mtype == 111)
	{
	if(ownr.time_hudmessage > time)
	return;
	}*/
	ownr.time_hudmessage = time + 2;
	local entity HudMessage;
	HudMessage = spawn();
	HudMessage.classname = "hudmessage";
	HudMessage.drawonlytoclient = ownr;
	setmodel(HudMessage, "models/misc/null.md3");
	HudMessage.origin = org + '0 0 25';
	HudMessage.movetype = MOVETYPE_NOCLIP;
	HudMessage.msg = mtype;
	HudMessage.wrathflags += FL_MESSAGE;
	HudMessage.SendEntity = Send_Item;
	//	HudMessage.SendFlags  = self.SendFlags  + 1;
	HudMessage.SendFlags = -1;
	HudMessage.think = SUB_Remove;
	HudMessage.nextthink = time + 2;
	#endif
};

void() Message_delay =
{
	self.classname = "hudmessage";
	self.SendEntity = Send_Item;
	//	HudMessage.SendFlags  = self.SendFlags  + 1;
	self.SendFlags = -1;
	self.think = SUB_Remove;
	self.nextthink = time + 2;
}	

void(float mtype, vector org, entity ownr) Hud_message_delay = 
{
	

	if(!(ownr.flags & FL_CLIENT))return;if (ownr.classname != "player")return;
	ownr.stat_time_hudmessage = 1;
	ownr.time_hudmessage = time + 2;
	local entity HudMessage;
	HudMessage.wrathflags += FL_MESSAGE;
	HudMessage = spawn();
	HudMessage.classname = "hudmessage_delay";
	HudMessage.drawonlytoclient = ownr;
	setmodel(HudMessage, "models/misc/null.md3");
	HudMessage.origin = org + '0 0 25';
	HudMessage.movetype = MOVETYPE_NOCLIP;
	HudMessage.msg = mtype;
	HudMessage.nextthink = time + 0.5;
	HudMessage.think = Message_delay;
	
};


void() respawn_items = 
{ 
	self.pflags =  self.oldpflags;
	self.touch = self.oldtouch; 
	self.solid = self.oldsolid;
	self.colormod = '1 1 1';
	self.alpha = 1;
	self.think = SUB_Null;
	self.nextthink = time; 
};

void() siframes = 
{
	/*if (self.frame >= 16)
		self.frame = 0; 
	self.frame += 1;
	*/

	self.nextthink = time + 0.05;	// items start after other solids
	self.think = siframes;
};

void() twframes = 
{
	if (self.frame >= 20)
		self.frame = 0;
	self.frame += 1;
	self.nextthink = time + 0.1;	// items start after other solids
	self.think = twframes;
};
.float rwpn;
void() artifact_drop = 
{
	

	if(self.flags & FL_ONGROUND)
	self.flags -= FL_ONGROUND;
	self.movetype = MOVETYPE_TOSS;
	self.velocity_x = crandom() *10;
	self.velocity_y = crandom() *10;
	self.velocity_z = 50 + random() *70;
}


void()check_item_onfloor =
{
	local vector rintvelocity;
	rintvelocity_x = rint(self.velocity_x);
	rintvelocity_y = rint(self.velocity_y);

	if((rintvelocity_x == 0) && (rintvelocity_y == 0) &&(!(self.flags & FL_ONGROUND)))
	{
	self.movetype = MOVETYPE_TOSS;
	self.velocity_x = crandom() *10;
	self.velocity_y = crandom() *10;
	self.velocity_z = random() *10;
	}

	if((self.flags & FL_ONGROUND) && (self.oldgroundentity == world))	
	self.think = SUB_Null;
	else
	self.think = check_item_onfloor;
	
	self.nextthink = time  + 0.05;
};

void() vel_item = 
{
	self.solid = SOLID_TRIGGER;
	
	local vector rintvelocity;
	rintvelocity_x = rint(self.velocity_x);
	rintvelocity_y = rint(self.velocity_y);

	if((rintvelocity_x == 0) && (rintvelocity_y == 0) &&(!(self.flags & FL_ONGROUND)))
	{
	self.movetype = MOVETYPE_TOSS;
	self.velocity_x = crandom() *10;
	self.velocity_y = crandom() *10;
	self.velocity_z = random() *10;
	}
	
	if((self.flags & FL_ONGROUND) && (self.oldgroundentity == world))	
	self.think = SUB_Null;
	else
	self.think = vel_item;

	self.nextthink = time + 0.05;
};
void() PlaceItem = {

	self.origin_z = self.origin_z + 12;

	if(self.displacement != 1)
	{
		self.movetype = MOVETYPE_TOSS;
		//self.velocity_z = -3000;
		/*if (!droptofloor())
		{
			dprint("Bonus item fell out of level at ");
			dprint(vtos(self.origin));
			dprint("\n");
			remove(self);
			return;
		}*/
	}
	local float oldz;
	self.solid = SOLID_TRIGGER;
	if (self.rwpn == 1)
	{
		self.modelflags = MF_ROTATE;
	}
	self.velocity = '0 0 0';
	oldz = self.origin_z;
};

void(float ie) StartItem = {

	if(!(self.wrathflags & FL_ITEMS))
		self.wrathflags += FL_ITEMS;

	if(self.classname == "bbox_touch")
	return;
	if (ie == 1)
	{
	}
	else if (ie == 2)
	{
	}
	else if (ie == 3)	//life
	{
		//self.scale = 0.5;
		self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE;
	}
	else if (ie == 4)	//armor
	{
		self.style = 0;
		self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE;
	}
	else if (ie == 5)	//artifacts
	{
		self.modelflags = MF_ROTATE;
		self.effects = EF_ADDITIVE;
		self.cnt = 1;
		self.solid = SOLID_TRIGGER;
		self.nextthink = time + 0.2;	// items start after other solids
		self.think = siframes;
		return;
	}
	else if (ie == 6)	//sigil
	{
		self.light_lev = 125;
		self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE;
		self.color = '0.3 1 0.3';
		self.style = 6;
		setsize(self, '-12 -12 -16', '12 12 16');
		self.cnt = 1;
	}
	self.use = artifact_drop;
	self.nextthink = time + 0.05;	// items start after other solids
	self.think = PlaceItem;
};

void() start_key = 
{
	copy_old_data(self);
		self.use = artifact_drop;
		self.nextthink = time + 0.2;	// items start after other solids
		self.think = PlaceItem;
		self.velocity = '0 0 2';
		self.wrathflags = FL_RESPAWN;
	}
	.float msg2;
.float itemisweapon;
.float time_emptymessage;
////////////////////////////////
///weapons and ammo///
////////////////////////////////
void() wammo_touch = 
{
	if((self.owner.effects & EF_NODRAW) && (self.owner.wrathflags & FL_INVISIBLE))
		return;
		
	if(!(other.flags & FL_CLIENT))
		return;
	if (other.classname != "player")
		return;
	if ((other.items &self.items))
	{
		if(other.time_emptymessage < time)
			Hud_FullNotification(other);
		other.time_emptymessage = time + 2.1;return;
	}
	if ((other.attack_finished > time) && (self.itemisweapon == 1))
		return;
	
	if (self.msg == 89)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))
		if (other.weapon == 0)
		{
			entity o_self = self;
			self = other;

			self.weapon = IT_MELEE;
			W_SetWeapon();
			pick_up_melee();

			self = o_self;
		}
		else
		{
			other.oldimpulse = 1;
			other.itemtime = time + 0.5;
		}

		Hud_JournalNotification(other);
	}
	if (self.msg == 90)
	{
		other.revolverclip = 3;
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))
		other.oldimpulse = 2;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}
	if (self.msg == 91)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		other.oldimpulse = 3;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}
	if (self.msg == 92)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 4;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}
	if (self.msg == 93)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 5;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}

	if (self.msg == 94)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 6;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}
	if (self.msg == 95)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 7;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}
	if (self.msg == 96)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 8;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}
	if (self.msg == 97)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 9;
		other.itemtime = time + 0.5;
		Hud_JournalNotification(other);
	}

	if (self.msg == 120)
	{
		if ((other.ammo_revolver >= max_ammo_revolver )&& (self.alwaystouchable != 1))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
		if ((other.ammo_revolver <= 0))
		{
			other.prerevolverclip = 1;
			if ((other.weapon == IT_REVOLVER) && (other.vweaponframe == 0))
				stuffcmd(other, "impulse 30\n");
		}
	}
	if (self.msg == 121)
	{
		if ((other.ammo_shotgun >= max_ammo_shotgun)&& (self.alwaystouchable != 1))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
		if ((other.weapon == IT_SHOTGUN) && (other.empty_shells == 1))
		{
			stuffcmd(other, "impulse 36\n");
		}
	}

	if (self.msg == 122)
	{
		if ((other.ammo_spitter >= max_ammo_spitter)&& (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	}
	if (self.msg == 123)
	{
		if ((other.ammo_retcher >= max_ammo_retcher) && (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
		if ((other.ammo_retcher <= 0))
		{
			other.preloadcyst = 1;
			if ((other.weapon == IT_RETCHER) && (other.vweaponframe == 0))
				stuffcmd(other, "impulse 34\n");
		}
	}
	if (self.msg == 124)
	{
		if ((other.ammo_cannon >= max_ammo_cannon )&& (self.alwaystouchable != 1))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	}
	if (self.msg == 125)
	{
		if ((other.ammo_lance >= max_ammo_lance)&& (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	}
	if (self.msg == 126)
	{
		if ((other.ammo_crystal >= max_ammo_crystal)&& (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	}
	if(deathmatch)
		other.time_pickupweapon = 0;
	other.items |= self.items;

	other.ammo_revolver = self.ammo_revolver + other.ammo_revolver;
	if (other.ammo_revolver > max_ammo_revolver)
		other.ammo_revolver = max_ammo_revolver;

	other.ammo_shotgun = self.ammo_shotgun + other.ammo_shotgun;
	if (other.ammo_shotgun > max_ammo_shotgun)
		other.ammo_shotgun = max_ammo_shotgun;

	other.ammo_cannon = self.ammo_cannon + other.ammo_cannon;
	if (other.ammo_cannon > max_ammo_cannon)
		other.ammo_cannon = max_ammo_cannon;

	other.ammo_spitter = self.ammo_spitter + other.ammo_spitter;
	if (other.ammo_spitter > max_ammo_spitter)
		other.ammo_spitter = max_ammo_spitter;

	other.ammo_retcher = self.ammo_retcher + other.ammo_retcher;
	if (other.ammo_retcher > max_ammo_retcher)
		other.ammo_retcher = max_ammo_retcher;

	other.ammo_lance = self.ammo_lance + other.ammo_lance;
	if (other.ammo_lance > max_ammo_lance)
		other.ammo_lance = max_ammo_lance;

	other.ammo_crystal = self.ammo_crystal + other.ammo_crystal;
	if (other.ammo_crystal > max_ammo_crystal)
		other.ammo_crystal = max_ammo_crystal;

	if (self.msg_icon || self.msg_text)
		Hud_SendNotification(other, self.msg_icon, self.msg_text, HUDMSGFLAG::AGGREGATE);
	else if (self.msg)
		Hud_message(self.msg, other.origin, other);
	if(self.noise)
	 	sound(self,CHAN_AUTO,self.noise,1,0);
	SUB_UseTargets();

	if ((self.ammo_revolver) && (other.weapon == IT_REVOLVER))
	{
		stuffcmd (other,"pulseammo\n");
	}
	if ((self.ammo_shotgun) && (other.weapon == IT_SHOTGUN))
	{
		stuffcmd (other,"pulseammo\n");
	}
	if ((self.ammo_spitter)	 && (other.weapon == IT_SPITTER))
	{
		stuffcmd (other,"pulseammo\n");
	}
	if ((self.ammo_retcher) && (other.weapon == IT_RETCHER))
	{
		stuffcmd (other,"pulseammo\n");
	}
	if ((self.ammo_cannon) && (other.weapon == IT_CANNON))
	{
		stuffcmd (other,"pulseammo\n");
	}
	if ((self.ammo_lance) && (other.weapon == IT_LANCE))
	{
		stuffcmd (other,"pulseammo\n");
	}
	if ((self.ammo_crystal) && (other.weapon == IT_CRYSTAL))
	{
		stuffcmd (other,"pulseammo\n");
	}

	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_SendNotification(other, "secret", "$NOTIFY_SECRET");
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		secrets_checkperfect(other);
	}


	flash_screen_item(other);
	if (deathmatch)
	{
		self.oldsolid = self.solid;
		self.oldtouch = self.touch;
		self.touch = SUB_Null;
		self.oldpflags = self.pflags;
		self.pflags =  0;
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
		if(self.classname == "bbox_touch")
		{
		self.owner.oldpflags = self.pflags;
		self.owner.pflags =  0;
		self.owner.alpha = 0.1;
		self.owner.colormod = '0.5 0.5 1';
		self.owner.solid = SOLID_NOT;
		self.owner.think = respawn_items;
		self.owner.nextthink = time + 25;
		}	
	}
	else
	{
		if(self.pipes)
			remove(self.pipes);
		remove(self);
		if(self.classname == "bbox_touch")
			remove(self.owner);
	}

};

void() weapon_blade = 
{
	self.items = IT_MELEE;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/melee/w_blade.md3");
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.rwpn = 1;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 89;
	self.msg_icon = "blade";
	self.msg_text = "$NOTIFY_WEP_BLADE";
	setsize(self, '-12 -12 -24' ,'12 12 8');
};

void() weapon_revolver = 
{
	self.items = IT_REVOLVER;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/revolver/w_revolver.md3");
	self.ammo_revolver = 3;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.rwpn = 1;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 90;
	self.msg_icon = "revolver";
	self.msg_text = "$NOTIFY_WEP_REVOLVER";
	setsize(self, '-12 -12 -24' ,'12 12 8');
};

void() weapon_shotgun = 
{
	self.items = IT_SHOTGUN;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/shotgun/w_shotgun.md3");
	self.ammo_shotgun = 2;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.rwpn = 1;
	//self.noise  ="items/shotgun.ogg";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 91;
	self.msg_icon = "shotgun";
	self.msg_text = "$NOTIFY_WEP_SHOTGUN";
	setsize(self, '-12 -12 -24' ,'12 12 8');
};

void() weapon_spitter = 
{
	self.items = IT_SPITTER;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/spitter/w_spitter.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	self.ammo_spitter = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 92;
	self.msg_icon = "spitter";
	self.msg_text = "$NOTIFY_WEP_SPITTER";
};
void() weapon_retcher = 
{
	self.items = IT_RETCHER;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/retcher/w_retcher.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	self.ammo_retcher = 6;
	self.scale = 1;
	self.rwpn = 1;
	StartItem(1);
	self.origin_z += 24;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 93;
	self.msg_icon = "retcher";
	self.msg_text = "$NOTIFY_WEP_RETCHER";
};

void() weapon_cannon = 
{
	self.items = IT_CANNON;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/cannon/w_cannon.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.ammo_cannon = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.touch = wammo_touch;
	self.msg = 94;
	self.msg_icon = "slagcannon";
	self.msg_text = "$NOTIFY_WEP_SLAGCANNON";
};

void() weapon_lance = 
{
	self.items = IT_LANCE;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/lance/w_lance.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.ammo_lance = 10;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.touch = wammo_touch;
	self.msg = 95;
	self.msg_icon = "lance";
	self.msg_text = "$NOTIFY_WEP_LANCE";
};

void() weapon_crystal = 
{
	self.items = IT_CRYSTAL;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/crystal/w_crystal.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.ammo_crystal = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.touch = wammo_touch;
	self.msg = 96;
	self.msg_icon = "crystallizer";
	self.msg_text = "$NOTIFY_WEP_BOILER";
};

void() weapon_mace = 
{
	self.items = IT_MACE;
	self.itemisweapon = 1;
	
	//setmodel(self, "models/weapons/mace/w_mace_open.md3");
	setmodel(self, "models/weapons/mace/w_mace.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	//self.ammo_lance = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.touch = wammo_touch;
	self.msg = 97;
	self.msg_icon = "mace";
	self.msg_text = "$NOTIFY_WEP_MACE";
};


void(entity ownr) spawn_bbox_collider =
{

	//return;
	if(!(ownr.wrathflags & FL_ITEMS))
		ownr.wrathflags += FL_ITEMS;
	if(ownr.displacement == 1)
	{
		ownr.gravity = 0;
		ownr.movetype = 0;
		ownr.wrathflags += FL_INVISIBLE;
		ownr.effects = EF_NODRAW;
	}	
	ownr.wrathflags += FL_PICKUPABLE;
	entity bbox_touch;
	ownr.th_melee = ownr.touch;
	bbox_touch = spawn();
	ownr.oldenemy = bbox_touch;
	copyentity (ownr,bbox_touch);
	bbox_touch.owner = ownr;
	bbox_touch.noise = ownr.noise;
	bbox_touch.classname = "bbox_touch";
	bbox_touch.solid = SOLID_TRIGGER;
	setmodel(bbox_touch,"models/misc/null.md3");
	setsize(bbox_touch,bbox_touch.nsize_bbox,bbox_touch.size_bbox + '0 0 8');
	//bbox_touch.touch = bbox_touch.owner.oldtouch;
	bbox_touch.movetype = MOVETYPE_FOLLOW;
	bbox_touch.aiment = ownr;
	bbox_touch.think = null;
	ownr.solid = SOLID_NOT;
	ownr.touch = null;
};

void() rbboxthink = 
{
	self.solid = SOLID_TRIGGER;
	setmodel(self,"models/misc/null.md3");
	setsize(self,self.nsize_bbox,self.size_bbox + '0 0 8');
	//bbox_touch.touch = bbox_touch.owner.oldtouch;
	self.movetype = MOVETYPE_FOLLOW;
	self.aiment = self.owner;
	self.think = null;
};
void(entity ownr) spawn_bbox_collider_delay =
{

	if(!ownr.oldtouch)
	ownr.oldtouch = ownr.touch;

	if(!(ownr.wrathflags & FL_ITEMS))
		ownr.wrathflags += FL_ITEMS;
	if(ownr.displacement == 1)
	{
		ownr.gravity = 0;
		ownr.movetype = 0;
		ownr.wrathflags += FL_INVISIBLE;
		ownr.effects = EF_NODRAW;
	}	
	ownr.wrathflags += FL_PICKUPABLE;
	entity bbox_touch;
	ownr.th_melee = ownr.touch;
	bbox_touch = spawn();
	ownr.oldenemy = bbox_touch;
	copyentity (ownr,bbox_touch);
	bbox_touch.owner = ownr;
	bbox_touch.noise = ownr.noise;
	bbox_touch.classname = "bbox_touch";
	bbox_touch.think = rbboxthink;
	bbox_touch.nextthink = time + 0.25;
	ownr.solid = SOLID_NOT;
	ownr.touch = null;
};



void() spawnfunc_ammo_revolver = 
{
	self.noise = "items/ammo_revolver.ogg";
	self.ammo_revolver = revolver_ammount;
	setmodel(self, "models/items/ammo_revolver.md3");
	setsizeitem2(self, shellsl_size);
	self.msg = 120;
	self.msg_icon = "slugs";
	self.msg_text = "$NOTIFY_AMMO_REVOLVER";
	precache_sound(self.noise);
	StartItem(1);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};
void() spawnfunc_ammo_shotgun = 
{

	
	self.noise = "items/ammo_shotgun.ogg";
	self.ammo_shotgun = shotgun_ammount;
	setmodel(self, "models/items/ammo_shotgun.md3");
	setsizeitem2(self, shells_size);
	self.msg = 121;
	self.msg_icon = "shells";
	self.msg_text = "$NOTIFY_AMMO_SHOTGUN";
	precache_sound(self.noise);
	StartItem(1);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};

void() spawnfunc_ammo_spitter = 
{
	self.noise = "items/ammo_spitter.ogg";
	setmodel(self, "models/items/ammo_spitter.md3");
	setsizeitem2(self, resin_size);
	self.ammo_spitter = spitter_ammount;
	self.msg = 122;
	self.msg_icon = "fangs";
	self.msg_text = "$NOTIFY_AMMO_SPITTER";
	precache_sound(self.noise);
	StartItem(2);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() spawnfunc_ammo_retcher = 
{
	setmodel(self, "models/items/ammo_retcher.md3");
	self.noise = "items/ammo_retcher.ogg";
	setsizeitem2(self, explosives_size);
	self.ammo_retcher = retcher_ammount;
	precache_sound(self.noise);
	StartItem(2);
	self.scale = 1;
	self.msg = 123;
	self.msg_icon = "cysts";
	self.msg_text = "$NOTIFY_AMMO_RETCHER";
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};

void() spawnfunc_ammo_cannon = 
{
	setmodel(self, "models/items/ammo_cannon.md3");
	setsizeitem2(self, ore_size);
	self.ammo_cannon = cannon_ammount;
	self.noise = "items/ammo_cannon.ogg";
	self.msg = 124;
	self.msg_icon = "ore";
	self.msg_text = "$NOTIFY_AMMO_SLAGCANNON";
	precache_sound(self.noise);
	StartItem(2);
	item_glowmodcontroller_flicker_spawn(self);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};
	
void() spawnfunc_ammo_lance = 
{
	setmodel(self, "models/items/ammo_lance.md3");
	self.noise = "items/ammo_lance.ogg";
	setsizeitem2(self, explosives_size);
	self.ammo_lance = lance_ammount;
	precache_sound(self.noise);
	StartItem(2);
	item_glowmodcontroller_pulse_spawn(self);
	self.classname = "spore";
	self.scale = 1;
	self.msg = 125;
	self.msg_icon = "plasma";
	self.msg_text = "$NOTIFY_AMMO_LANCE";
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};
void() spawnfunc_ammo_crystal = 
{
	setmodel(self, "models/items/ammo_crystal.md3");
	self.noise = "items/ammo_crystallizer.ogg";
	setsizeitem2(self, explosives_size);
	self.ammo_crystal = crystal_ammount;
	precache_sound(self.noise);
	StartItem(2);
	item_glowmodcontroller_pulse_spawn(self);
	self.classname = "crystal";
	self.scale = 1;
	self.msg = 126;
	self.msg_icon = "crystals";
	self.msg_text = "$NOTIFY_AMMO_CRYSTAL";
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};

void() spawnfunc_ammo_spore = 
{
	spawnfunc_ammo_lance();
};

void() soul_touch =
{
	if(other.classname != "player")
		return;
	if(other.ammo_bfg >= 10)
		return;

	if (other.ammo_bfg < 10)
		other.ammo_bfg += 1;
	te_customflash(self.origin,other.ammo_bfg * 3.5,7,'3 0 0');

	string snd = strcat ("weapons/mace/mace_absorb",ftos(other.ammo_bfg ),".ogg");
	sound(other, CHAN_AUTO, snd, 0.7, ATTN_NORM);
	if (other.ammo_bfg == 10)
		sound(other, CHAN_AUTO,"weapons/mace/mace_unfold1.ogg", 1, ATTN_NORM);

	stuffcmd (other,"pulseammo\n");
	flash_screen_item(other);
	Hud_SendNotification(other, "soul", "$NOTIFY_AMMO_SOUL", HUDMSGFLAG::AGGREGATE);
	Steam_StatIncrement(other, ST_STATS::souls_harvested, 1);
	remove(self);
};

void() ammo_mace_think =
{
	while (self.count > 0)
	{	
		entity dropped = spawn();
		dropped.noise = "items/ammo_mace.ogg";
		setmodel(dropped,"models/weapons/mace/soul.md3");
		dropped.msg = 126;
		dropped.msg_icon = "crystals";
		dropped.msg_text = "$NOTIFY_AMMO_CRYSTAL";
		dropped.classname = "item_ammo_crystal";
		setsizeitem2(dropped, shellsl_size);
		dropped.alpha = 0.025;
		local vector voffset;
		voffset_x = random (-2,2) * self.count * 1.25;
		voffset_y = random (-2,2) * self.count * 1.25;
		voffset_z = random (-2,2) * self.count * 1.25;
		
		dropped.roaming = self.count * random(4,10);
		dropped.msg = 126;
		dropped.ldorigin = self.origin + voffset;
		dropped.origin = dropped.ldorigin;
		dropped.colormod = '1 0.5 0.5';
		dropped.solid = SOLID_TRIGGER;
		dropped.movetype = MOVETYPE_FLY;			
		dropped.velocity_x = random (-24,24);
		dropped.velocity_y = random (-24,24);
		dropped.velocity_z = random (-24,24);

		dropped.traileffectnum = particleeffectnum("soul_mace_trail");
		dropped.lifetime = time + 0.95; 
		dropped.alpha = 0.025;
		dropped.cnt = 1;
		dropped.touch = soul_touch;
		dropped.think = soulhome;
		dropped.nextthink = time;
		self.count --;
	}
};
void() spawnfunc_ammo_mace = 
{
	setmodel(self, "");
	if(!self.count)
		self.count = 1;
	self.think = ammo_mace_think;
	self.nextthink = time + 0.1;
};


void()wammo_special_touch =
{
return;
};




/////////////////////////
///armor &health///
/////////////////////////
void() larmor_touch = 
{

	if((self.owner.effects & EF_NODRAW) && (self.owner.wrathflags & FL_INVISIBLE))
		return;
	if (other.classname != "player")
		return;
	if(!(other.flags & FL_CLIENT))		
		return;

	float maxhealthvalue;

	if(self.msg == 40)
		maxhealthvalue = 999;
	else	
		maxhealthvalue = 100;

	if ((other.health >= maxhealthvalue) && (self.msg != 40) && (self.health))
	{
		if(other.time_emptymessage < time)
			Hud_FullNotification(other);
		other.time_emptymessage = time + 2.1;return;
	}

	other.health += self.health;
	if(self.msg == 40)
		other.meaxhealth_finished = time + 1;
	
	if ((other.health > maxhealthvalue) && (self.health > 0))
		other.health = maxhealthvalue;

	if (self.health)
	{
		sound(other, CHAN_AUTO, "player/gain_health.ogg", 1, ATTN_NORM);
		stuffcmd (other,"pulsehealth\n");

	}

	if (self.rarmorvalue)	//8192 - 16384
	{
		if ((other.rarmorvalue == 100))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
		other.rarmorvalue += self.rarmorvalue;
		if (other.rarmorvalue > 100)
			other.rarmorvalue = 100;
		stuffcmd (other,"pulsearmor\n");

	}
	if (self.darmorvalue)	//32768 -65536
	{
		if ((other.darmorvalue == 100))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
		other.darmorvalue += self.darmorvalue;
		if (other.darmorvalue > 100)
			other.darmorvalue = 100;
		stuffcmd (other,"pulsedarmor\n");

	}
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg_icon || self.msg_text)
		Hud_SendNotification(other, self.msg_icon, self.msg_text, HUDMSGFLAG::AGGREGATE);
	else if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_SendNotification(other, "secret", "$NOTIFY_SECRET");
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		secrets_checkperfect(other);
	}
	flash_screen_item(other);
	if (deathmatch)
	{
		self.oldsolid = self.solid;
		self.oldtouch = self.touch;
		self.touch = SUB_Null;
		self.alpha = 0.1;
		self.oldpflags = self.pflags;
		self.pflags =  0;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
		if(self.classname == "bbox_touch")
		{
		self.owner.oldpflags = self.pflags;
		self.owner.pflags =  0;
		self.owner.alpha = 0.1;
		self.owner.colormod = '0.5 0.5 1';
		self.owner.solid = SOLID_NOT;
		self.owner.think = respawn_items;
		self.owner.nextthink = time + 25;
		}	
	}
	else
	{
	remove(self);
	if(self.classname == "bbox_touch")
	remove(self.owner);
	}


};

void() health_life_vial = 
{
	self.noise = "items/lifeblood_vial1.ogg";
	self.health = 10;
	self.colormod = '1 1 1';
	setmodel(self, "models/items/lifeblood_vial.md3");
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, vial_size);
	self.touch = larmor_touch;
//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	self.msg = 11;
	self.msg_icon = "lifeblood_vial";
	self.msg_text = "$NOTIFY_HEALTH_VIAL";

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpvial)

	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() health_life_beaker = 
{
	local float r;
	r = random() *3;
	if (r < 3)
		self.noise = ("items/lifeblood_beaker3.ogg");
	if (r < 2)
		self.noise = ("items/lifeblood_beaker2.ogg");
	if (r < 1)
		self.noise = ("items/lifeblood_beaker1.ogg");

	self.health = 30;
	self.colormod = '1 1 1';
	setmodel(self, "models/items/lifeblood_beaker.md3");
	self.touch = larmor_touch;
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, beaker_size);
	self.msg = 10;
	self.msg_icon = "lifeblood_beaker";
	self.msg_text = "$NOTIFY_HEALTH_BEAKER";

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpbeaker)

//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	spawn_bbox_collider(self);
	self.oldtouch = self.touch;
	
};

void() health_life_chalice2 = 
{
	self.noise = "items/lifeblood_vial3.ogg";
	self.health = 50;
	self.colormod = '1 1 1';
	setmodel(self, "models/items/lifeblood_vial.md3");
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, chalice_size);
	self.touch = larmor_touch;
//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	self.msg = 11;
	self.msg_icon = "lifeblood_vial";
	self.msg_text = "$NOTIFY_HEALTH_VIAL";

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpchalice)

	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() health_life_chalice = 
{
	float r = random();
	if(r < 1)
		self.noise = "items/lifeblood_chalice1.ogg";
	if(r < 0.6)
		self.noise = "items/lifeblood_chalice2.ogg";
	if(r < 0.3)
		self.noise = "items/lifeblood_chalice3.ogg";
	StartItem(3);
	self.health = 100;
	self.colormod = '1 1 1';
	setmodel(self, "models/items/lifeblood_chalice.md3");
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, heart_size);
	self.touch = larmor_touch;
	self.msg = 40;
	self.msg_icon = "lifeblood_chalice";
	self.msg_text = "$NOTIFY_HEALTH_CHALICE";

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpchalice)

	//self.oldtouch = self.touch;
	//spawn_bbox_collider(self);
};

void() armor_shard = 
{
	local float r;
	r = floor(random() *3);
	if (r < 1)
		self.noise = "items/armor_shard1.ogg";
	if (r < 2)
		self.noise = "items/armor_shard2.ogg";
	else
		self.noise = "items/armor_shard3.ogg";
	precache_sound(self.noise);
	self.rarmorvalue = 10;
	setmodel(self, "models/items/armor_shard.md3");
	setsize2(self, shard_nsize, shard_size);
	self.touch = larmor_touch;
	
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor_shard)
	self.color = shard_light_col;
	self.light_lev = shard_lightlev;
	StartItem(4);
	self.msg = 13;
	self.msg_icon = "shard";
	self.msg_text = "$NOTIFY_ARMOR_SHARD";
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_helm = 
{
	self.noise = "items/helm1.ogg";
	precache_sound(self.noise);
	self.rarmorvalue = 30;
	setmodel(self, "models/items/helm.md3");
	setsize2(self, helm_nsize, helm_size);
	self.touch = larmor_touch;
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor_helm)
	self.color = helm_light_col;
	self.light_lev = helm_lightlev;
	StartItem(4);
	self.msg = 9;
	self.msg_icon = "helm";
	self.msg_text = "$NOTIFY_ARMOR_HELM";
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_armor = 
{
	self.noise = "items/armor1.ogg";
	precache_sound(self.noise);
	self.rarmorvalue = 50;
	setmodel(self, "models/items/armor.md3");
	setsize2(self, armor_nsize, armor_size);
	self.touch = larmor_touch;
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor)
	self.color = armor_light_col;
	self.light_lev = armor_lightlev;
	StartItem(4);
	self.msg = 2;
	self.msg_icon = "armor";
	self.msg_text = "$NOTIFY_ARMOR";
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_shard_dark = 
{
	local float r;
	r = floor(random() *3);
	if (r < 1)
		self.noise = "items/armor_shard_dark1.ogg";
	if (r < 2)
		self.noise = "items/armor_shard_dark2.ogg";
	else
		self.noise = "items/armor_shard_dark3.ogg";
	precache_sound(self.noise);
	self.darmorvalue = 10;
	setmodel(self, "models/items/armor_shard_dark.md3");
	setsize2(self, dark_shard_nsize, dark_shard_size);
	self.touch = larmor_touch;

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_darkarmor_shard)
	self.color = dark_shard_light_col;
	self.light_lev = dark_shard_lightlev;
	StartItem(4);
	self.msg = 6;
	self.msg_icon = "dark_shard";
	self.msg_text = "$NOTIFY_DARKARMOR_SHARD";
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_armor_dark = 
{
	self.noise = "items/armor_dark1.ogg";
	precache_sound(self.noise);
	self.darmorvalue = 50;
	setmodel(self, "models/items/armor_dark.md3");
	setsize2(self, dark_armor_nsize, dark_armor_size);
	self.touch = larmor_touch;
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_darkarmor)
	self.color = dark_armor_light_col;
	//	self.skin = 1;
	self.light_lev = dark_armor_lightlev;
	StartItem(4);
	self.msg = 4;
	self.msg_icon = "dark_armor";
	self.msg_text = "$NOTIFY_DARKARMOR";
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_helm_dark = 
{
	self.noise = "items/helm_dark1.ogg";
	precache_sound(self.noise);
	self.darmorvalue = 30;
	setmodel(self, "models/items/helm_dark.md3");
	setsize2(self, dark_helm_nsize, dark_helm_size);
	self.touch = larmor_touch;
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_darkarmor_helm)
	self.color = dark_helm_light_col;
	self.light_lev = dark_helm_lightlev;
	StartItem(4);
	self.msg = 5;
	self.msg_icon = "dark_helm";
	self.msg_text = "$NOTIFY_DARKARMOR_HELM";
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() guardian_shield = {};




/////////////////////////////////////////////////////////////
////////////////////ARTIFACTS////////////////////
/////////////////////////////////////////////////////////////
	
void() artifact_touch = 
{
	if (other.classname != "player")
		return;
	if(!(other.flags & FL_CLIENT))		
		return;
	if ((other.Attar >= 9) && (self.Attar))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.LifeSiphon >= 9) && (self.LifeSiphon))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.TrinketofRespite >= 9) && (self.TrinketofRespite))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.flaskrage >= 9) && (self.flaskrage))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.Aegis >= 9) && (self.Aegis))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.DrownerApp >= 9) && (self.DrownerApp))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.MarkRevelation >= 9) && (self.MarkRevelation))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.BlackGrenade >= 9) && (self.BlackGrenade))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}
	if ((other.ViciousIdol >= 9) && (self.ViciousIdol))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}

	if ((other.ShockWave >= 9) && (self.ShockWave))
		{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}

	if ((!(other.centerprint_messages &1)) && (!self.SoulTether))
	{
		//Hud_message(256, other.origin, other);
		//Hud_SendNotification_Control(other, "$HELP_RADIAL_OPEN"), "+button6";
		centerprint(other, "$HELP_RADIAL_OPEN");
		other.centerprint_messages += 1;
	}
	if((self.SoulTether) && (!(other.centerprint_messages &4)) )
	{	
		//Hud_message(260, other.origin, other);
		//Hud_SendNotification_Control(other, "$HELP_SAVEGAME"), "impulse 81";
		centerprint(other, "$HELP_SAVEGAME");
		other.centerprint_messages += 4;
	}

	other.MarkRevelation += self.MarkRevelation;
	other.LifeSiphon += self.LifeSiphon;
	other.Attar += self.Attar;	
	other.TrinketofRespite += self.TrinketofRespite;
	other.DrownerApp += self.DrownerApp;
	other.Aegis += self.Aegis;
	other.flaskrage += self.flaskrage;
	other.BlackGrenade += self.BlackGrenade;
	other.ViciousIdol += self.ViciousIdol;
	other.ShockWave += self.ShockWave;

	other.SoulTether += self.SoulTether;

	sound(self, CHAN_AUTO, self.noise, 1, 1);

	if (self.msg_icon || self.msg_text)
		Hud_SendNotification(other, self.msg_icon, self.msg_text);
	else if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();

	flash_screen_item(other);


	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_SendNotification(other, "secret", "$NOTIFY_SECRET");
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		secrets_checkperfect(other);
		self.nextthink = time + 1;
		self.think = SUB_Remove;
		self.solid = SOLID_NOT;
		self.secret  = 0;
		self.alpha = -1;
		return;
	}
	if (deathmatch)
	{
		self.oldsolid = self.solid;
		self.oldtouch = self.touch;
		self.touch = SUB_Null;
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.oldpflags = self.pflags;
		self.pflags =  0;
		self.think = respawn_items;
		self.nextthink = time + 25;
		if(self.classname == "bbox_touch")
		{
			self.owner.oldpflags = self.pflags;
			self.owner.pflags =  0;
			self.owner.alpha = 0.1;
			self.owner.colormod = '0.5 0.5 1';
			self.owner.solid = SOLID_NOT;
			self.owner.think = respawn_items;
			self.owner.nextthink = time + 25;
		}	
	}
	else
	{
		remove(self);
		if(self.classname == "bbox_touch")
			remove(self.owner);
	}

};

void() radial = 
{
	self.scale = 1;
	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_TRIGGER;
	self.cnt = 1;
	//self.flags += FL_ITEM;
	self.origin_z += 12;
	self.use = artifact_drop;
};

void() item_tether = 
{
	radial();
	self.modelflags = MF_ROTATE;
	self.noise = "items/artifacts/artifactE_pickup.ogg";
	self.noise1 = "items/artifacts/artifactE_use.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.SoulTether = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/soul_tether.md3");
	setsize(self, artifact_nsize, artifact_size);
	//setsize (self, '-8 -8 -8', ' 9 9 9');

	self.msg = 100;
	self.msg_icon = "soul_tether";
	self.msg_text = "$NOTIFY_SOULTETHER";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;
};


void() artifact_revelation = 
{
	radial();
	self.noise = "items/artifacts/artifactA_pickup.ogg";
	self.noise1 = "items/artifacts/artifactA_use.ogg";
	self.noise2 = "items/artifacts/artifactA_end.ogg";
	self.modelflags = MF_ROTATE;
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.MarkRevelation = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_revelation.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 101;
	self.msg_icon = "artifactA";
	self.msg_text = "$NOTIFY_ARTIFACT_REVELATION";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

};


void() artifact_apparatus = 
{
	radial();
	self.noise = "items/artifacts/artifactB_pickup.ogg";
	self.noise1 = "items/artifacts/artifactB_use.ogg";
	self.noise2 = "items/artifacts/artifactB_end.ogg";
	self.modelflags = MF_ROTATE;
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.DrownerApp = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_apparatus.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 102;
	self.msg_icon = "artifactB";
	self.msg_text = "$NOTIFY_ARTIFACT_APPARATUS";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

};

void() artifact_rage = 
{
	radial();
	self.noise = "items/artifacts/artifactC_pickup.ogg";
	self.noise1 = "items/artifacts/artifactC_use.ogg";
	self.noise2 = "items/artifacts/artifactC_end.ogg";
	self.modelflags = MF_ROTATE;
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.flaskrage = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_rage.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 103;
	self.msg_icon = "artifactC";
	self.msg_text = "$NOTIFY_ARTIFACT_RAGE";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

};


void() artifact_attar = 
{
	radial();
	self.noise = "items/artifacts/artifactD_pickup.ogg";
	self.noise1 = "items/artifacts/artifactD_use.ogg";
	self.noise2 = "items/artifacts/artifactD_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = MF_ROTATE;
	self.Attar = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_attar.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 104;
	self.msg_icon = "artifactD";
	self.msg_text = "$NOTIFY_ARTIFACT_ATTAR";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;
};


void() artifact_grenade = 
{
	radial();
	self.noise = "items/artifacts/artifactE_pickup.ogg";
	self.noise1 = "items/artifacts/artifactE_use.ogg";
	self.noise2 = "items/artifacts/artifactE_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.style = 1;
	self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW | PFLAGS_LODFADE;
	self.color = '1 0 1';
	self.light_lev = 32; 	
	self.modelflags = MF_ROTATE;
	self.BlackGrenade = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_grenade.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 105;
	self.msg_icon = "artifactE";
	self.msg_text = "$NOTIFY_ARTIFACT_GRENADE";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;
};

void() artifact_TrinketofRespite = {};

void() artifact_siphon = 
{
	radial();
	self.modelflags = MF_ROTATE;
	self.noise = "items/artifacts/artifactF_pickup.ogg";
	self.noise1 = "items/artifacts/artifactF_use.ogg";
	self.noise2 = "items/artifacts/artifactF_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.LifeSiphon = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_siphon.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.traileffectnum = particleeffectnum("life_siphon");
	self.msg = 106;
	self.msg_icon = "artifactF";
	self.msg_text = "$NOTIFY_ARTIFACT_SIPHON";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;
};

void() artifact_deflection = 
{
	radial();
	self.noise = "items/artifacts/artifactG_pickup.ogg";
	self.noise1 = "items/artifacts/artifactG_use.ogg";
	self.noise2 = "items/artifacts/artifactG_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = MF_ROTATE;
	self.TrinketofRespite = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_deflection.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 107;
	self.msg_icon = "artifactG";
	self.msg_text = "$NOTIFY_ARTIFACT_DEFLECTION";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;	
};


void() artifact_aegis = 
{
	radial();
	self.noise = "items/artifacts/artifactH_pickup.ogg";
	self.noise1 = "items/artifacts/artifactH_use.ogg";
	self.noise2 = "items/artifacts/artifactH_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = MF_ROTATE;
	self.Aegis = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_aegis.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 108;
	self.msg_icon = "artifactH";
	self.msg_text = "$NOTIFY_ARTIFACT_AEGIS";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;	
};


void() artifact_animus = 
{
	radial();
	self.noise = "items/artifacts/artifactI_pickup.ogg";
	self.noise1 = "items/artifacts/artifactI_use.ogg";
	self.noise2 = "items/artifacts/artifactI_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = MF_ROTATE;
	self.ViciousIdol = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_animus.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 109;
	self.msg_icon = "artifactI";
	self.msg_text = "$NOTIFY_ARTIFACT_ANIMUS";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;	
};


void() artifact_shockwave = 
{
	radial();
	self.noise = "items/artifacts/artifactJ_pickup.ogg";
	self.noise1 = "items/artifacts/artifactJ_use.ogg";
	self.noise2 = "items/artifacts/artifactJ_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = MF_ROTATE;
	self.ShockWave = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/artifact_shockwave.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 110;
	self.msg_icon = "artifactJ";
	self.msg_text = "$NOTIFY_ARTIFACT_SHOCKWAVE";
	self.touch = artifact_touch;
	self.oldtouch = self.touch;	
};
/////////////////////////////////////////////////////////////
/////////////////////SPAWNER/////////////////////
/////////////////////////////////////////////////////////////

entity(vector org, string class, float ammount, entity ownr) drop_item;
.float item_ammount;
.float classweapon1;
.float classweapon2;
.float classweapon3;
.float classweapon4;
.float classweapon5;
void(vector origin, string classt, float item_amm, entity slf) convert_to_item;
void() weapon_spawner_use = 
{
	local entity pl;
	pl = single_player;
	float isitem;
	if (pl.oldrelics)
	{
		if (pl.oldrelics == 1)
			self.cnt = self.classweapon2;
		if (pl.oldrelics == 2)
			self.cnt = self.classweapon3;
		if (pl.oldrelics == 3)
			self.cnt = self.classweapon4;
		if (pl.oldrelics == 4)
			self.cnt = self.classweapon5;
	}
	if (self.cnt == 1) 
	{
		if (!(pl.items &IT_REVOLVER))
			self.classtype = "revolver";
		else
		{	self.classtype = "ammo_revolver";
			self.item_ammount = revolver_ammount;
			self.alwaystouchable = 1;
			isitem = 1;	
		}
	}
	if (self.cnt == 2) 
	{
		if (!(pl.items &IT_SHOTGUN))
			self.classtype = "shotgun";
		else
		{	self.classtype = "ammo_shotgun";	
			self.item_ammount = shotgun_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}
	if (self.cnt == 3) 
	{
		if (!(pl.items &IT_SPITTER))
			self.classtype = "spitter";
		else
		{	self.classtype = "ammo_spitter";
			self.item_ammount = spitter_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}
	
	if (self.cnt == 4)
	{
		if (!(pl.items &IT_RETCHER))
			self.classtype = "retcher";
		else
		{	self.classtype = "ammo_retcher";
			self.item_ammount = retcher_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}
	if (self.cnt == 5)
	{
		if (!(pl.items &IT_CANNON))
			self.classtype = "cannon";
		else
		{	self.classtype = "ammo_cannon";
			self.item_ammount = cannon_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}
	if (self.cnt == 6)
	{
		if (!(pl.items &IT_LANCE))
			self.classtype = "lance";
		else
		{	self.classtype = "ammo_lance";
			self.item_ammount = lance_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}
	if (self.cnt == 7)
	{
		if (!(pl.items &IT_CRYSTAL))
			self.classtype = "crystal";
		else
		{	self.classtype = "ammo_crystal";
			self.item_ammount = crystal_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}
	if (self.cnt == 8)
	{
		if (!(pl.items &IT_MACE))
			self.classtype = "mace";
		else
		{	self.classtype = "mace_full";
			self.item_ammount = mace_ammount;
			self.alwaystouchable = 1;
			isitem = 1;
		}
	}

	if ((self.classtype) && (self.cnt))
	{
		self.use = SUB_Null;
		if(isitem == 1)
			self.origin += '0 0 16';
		convert_to_item(self.origin, self.classtype, self.item_ammount, self);
	}
	else
		remove(self);
};

void() weapon_spawner_preuse =
{
	self.nextthink = time + self.delay;
	self.think = weapon_spawner_use;
	self.use = SUB_Null;
};
void() weapon_spawner = 
{

	if (self.targetname)
		self.use = weapon_spawner_use;
	if(self.delay) 
		self.use = weapon_spawner_preuse;
	self.cnt = self.classweapon1;
	if (!self.targetname)
	{				
		self.use = SUB_Null;
		self.think = wrath_objerror;
		self.nextthink = time + random();
		return;
	}
};
.float classitem1;
.float classitem0;
.float classitem2;
.float classitem3;
.float classitem4;
.float classitem5;

.float checkweapon;
void() item_spawner_use = 
{
	local entity pl;
	pl = single_player;


	if (pl.oldrelics)
	{
		if (pl.oldrelics == 1)
			self.classitem1 = self.classitem2;
		if (pl.oldrelics == 2)
			self.classitem1 = self.classitem3;
		if (pl.oldrelics == 3)
			self.classitem1 = self.classitem4;
		if (pl.oldrelics == 4)
			self.classitem1 = self.classitem5;
		if (pl.oldrelics == 5)
			self.classitem1 = self.classitem1;
	}


	
	if(self.checkweapon == 1)
	{
		float removed;
		if((!(pl.items & IT_REVOLVER)) && (self.classitem1 ==  2))
			{remove(self);removed = 1;}
		if((!(pl.items & IT_SHOTGUN)) && (self.classitem1 ==  3))
			{remove(self);removed = 1;}
		if((!(pl.items & IT_SPITTER)) && (self.classitem1 ==  4))
			{remove(self);removed = 1;}
		if((!(pl.items & IT_RETCHER)) && (self.classitem1 ==  5))
			{remove(self);removed = 1;}
		if((!(pl.items & IT_CANNON)) && (self.classitem1 ==  6))
			{remove(self);removed = 1;}
		if((!(pl.items & IT_LANCE)) && (self.classitem1 ==  7))
			{remove(self);removed = 1;}
		if((!(pl.items & IT_CRYSTAL)) && (self.classitem1 ==  8))
			{remove(self);removed = 1;}
		if(removed == 1)
			return;
	}

	if (self.classitem1 == 1)
		(self.classtype = "theter");

	if (self.classitem1 == 2)
	{
		if (!self.item_ammount)
			self.item_ammount = revolver_ammount;	//revolver_ammount;
		self.classtype = "ammo_revolver";
	}
	if (self.classitem1 == 3)
	{
		if (!self.item_ammount)
			self.item_ammount = shotgun_ammount;
		self.classtype = "ammo_shotgun";
	}
	if (self.classitem1 == 4)
	{
		if (!self.item_ammount)
			self.item_ammount = spitter_ammount;
		self.classtype = "ammo_spitter";
	}
	if (self.classitem1 == 5)
	{
		if (!self.item_ammount)
			self.item_ammount = retcher_ammount;
		self.classtype = "ammo_retcher";
	}
	if(self.classitem1 ==  6)
	{
		if (!self.item_ammount)
		self.item_ammount  = cannon_ammount;
		self.classtype = "ammo_cannon";
	}
	if(self.classitem1 ==  7)
	{
		if (!self.item_ammount)
		self.item_ammount  = lance_ammount;
		self.classtype = "ammo_lance";
	}
	if(self.classitem1 ==  8)
	{
		if (!self.item_ammount)
		self.item_ammount  = crystal_ammount;
		self.classtype = "ammo_crystal";
	}
	if(self.classitem1 ==  9)
	{
		if (!self.item_ammount)
			self.item_ammount  = 3;
		self.classtype = "ammo_mace";
	}
	if (self.classitem1 == 10)
		(self.classtype = "vial");
	if (self.classitem1 == 11)
		(self.classtype = "beaker");
	if(self.classitem1 ==  12)
		(self.classtype = "chalice");
	if (self.classitem1 == 13)
		(self.classtype = "shard");
	if (self.classitem1 == 14)
		(self.classtype = "armor");
	if (self.classitem1 == 15)
		(self.classtype = "helm");
	if (self.classitem1 == 16)
		(self.classtype = "shard_dark");
	if (self.classitem1 == 17)
		(self.classtype = "armor_dark");
	if (self.classitem1 == 18)
		(self.classtype = "helm_dark");


	if (self.classitem1 == 21)
		(self.classtype = "mark");
	if (self.classitem1 == 22)
		(self.classtype = "apparatus");
	if (self.classitem1 == 23)
		(self.classtype = "flaskrage");
	if(self.classitem1 ==  24)
		(self.classtype = "attar");
	if(self.classitem1 ==  25)
		(self.classtype = "grenade");
	if (self.classitem1 == 26)
		(self.classtype = "siphon");
	if(self.classitem1 ==  27)
		(self.classtype = "trinket");
	if (self.classitem1 == 28)
		(self.classtype = "aegis");
	if (self.classitem1 == 29)
		(self.classtype = "vicious");
	if (self.classitem1 == 30)
		(self.classtype = "shockwave");





	if (self.classitem1)
	{
		self.use = SUB_Null;
		convert_to_item(self.origin, self.classtype, self.item_ammount, self);
	}
	//drop_item(self.origin, self.classtype, self.item_ammount, self);
	//remove(self);
};

.float classitem1;
.float classitem2;
.float classitem3;
.float classitem4;
.float classitem5;

void() item_spawner = 
{
	/*	if (!self.classitem0)
			self.classitem0 = 1;

		if (!self.classitem1)
			self.classitem1 = self.classitem0;
		if (!self.classitem2)
			self.classitem2 = self.classitem0;
		if (!self.classitem3)
			self.classitem3 = self.classitem0;
		if (!self.classitem4)
			self.classitem4 = self.classitem0;
		if (!self.classitem5)
			self.classitem5 = self.classitem0;
	*/

	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
	if (self.targetname)
		self.use = item_spawner_use;
};

.float PreStartItemvalue;

void() PreStartItem = 
{
	StartItem(self.PreStartItemvalue);
};
.float counter_coffer_use;
.float counter_coffer_ammount;

entity(vector org, string class, float ammount, entity ownr) drop_item = 
{

	local entity dropped;
	dropped = spawn();
	dropped.origin = org;
	dropped.movetype = MOVETYPE_TOSS;
	dropped.owner = ownr;
	dropped.angles = ownr.angles;
	dropped.angles_x = 0;
	dropped.angles_z = 0;
	
	
	local vector revel;
	makevectors(ownr.angles);

	if(dropped.owner.classname == "monster_oppressor")
	{
		revel = v_forward *(128 + random() *32);
		revel_z += (150 + random() *64);
	}
	if ((dropped.owner.flags &FL_MONSTER))
	{
		revel = v_forward *(120 + random() *50);
		revel_z += (150 + random() *50);
	}
	else
	{
		if (self.owner.target)
			dropped.target = self.owner.target;
	}
	if(ownr.classname == "coffer")
	{
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.gravity = coffer_item_gravity;
		dropped.bouncefactor = coffer_item_bounce;
		makevectors(ownr.angles);
		local float right_vel;
		
		if(ownr.counter_coffer_ammount == 4)
		{
			if(ownr.counter_coffer_use == 4)
				right_vel = -67.5;
			if(ownr.counter_coffer_use == 3)
				right_vel = -22.5;
			if(ownr.counter_coffer_use == 2)
				right_vel = 22.5;
			if(ownr.counter_coffer_use == 1)
				right_vel = 67.5;			
		}
		if(ownr.counter_coffer_ammount == 3)
		{
			if(ownr.counter_coffer_use == 3)
				right_vel = -45;
			if(ownr.counter_coffer_use == 1)
				right_vel = 45;			
		}
		if(ownr.counter_coffer_ammount == 2)
		{
			if(ownr.counter_coffer_use == 2)
				right_vel = -22.5;
			if(ownr.counter_coffer_use == 1)
				right_vel = 22.5;			
		}
		revel = (v_forward * coffer_item_vel) + v_right * (right_vel) * 2;
		revel_z += (coffer_item_vel);
	}


	if (class == "ammo_revolver")
	{
		dropped.noise = "items/ammo_revolver.ogg";
		setmodel(dropped, "models/items/ammo_revolver.md3");
		dropped.ammo_cannon = ammount;
		dropped.msg = 120;
		dropped.msg_icon = "slugs";
		dropped.msg_text = "$NOTIFY_AMMO_REVOLVER";
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_revolver = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_revolver";
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "ammo_revolver_inv")
	{
		dropped.noise = "items/ammo_revolver.ogg";
		setmodel(dropped, "models/items/ammo_invader.md3");
		dropped.ammo_cannon = ammount;
		dropped.msg = 120;
		dropped.msg_icon = "slugs";
		dropped.msg_text = "$NOTIFY_AMMO_REVOLVER";
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_revolver = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_revolverinv";
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "ammo_shotgun")
	{
		dropped.noise = "items/ammo_shotgun.ogg";
		setmodel(dropped, "models/items/ammo_shotgun.md3");
		dropped.msg = 121;
		dropped.msg_icon = "shells";
		dropped.msg_text = "$NOTIFY_AMMO_SHOTGUN";
		setsizeitem2(dropped, shells_size);
		dropped.ammo_shotgun = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_shotgun";
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "ammo_spitter")
	{
		dropped.noise = "items/ammo_spitter.ogg";
		setmodel(dropped, "models/items/ammo_spitter.md3");
		dropped.msg = 122;
		dropped.msg_icon = "fangs";
		dropped.msg_text = "$NOTIFY_AMMO_SPITTER";
		setsizeitem2(dropped, resin_size);
		dropped.ammo_spitter = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_spitter";
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "ammo_spitter_drop")
	{
		dropped.noise = "items/ammo_spitter.ogg";
		setmodel(dropped, "models/items/ammo_spitter_drop.md3");
		dropped.msg = 122;
		dropped.msg_icon = "fangs";
		dropped.msg_text = "$NOTIFY_AMMO_SPITTER";
		setsizeitem2(dropped, resin_size);
		dropped.ammo_spitter = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_spitter";
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "ammo_retcher")
	{
		dropped.noise = "items/ammo_retcher.ogg";
		setmodel(dropped, "models/items/ammo_retcher.md3");
		dropped.msg = 123;
		dropped.msg_icon = "cysts";
		dropped.msg_text = "$NOTIFY_AMMO_RETCHER";
		setsizeitem2(dropped, explosives_size);
		dropped.ammo_retcher = ammount;
		dropped.touch = wammo_touch;
		dropped.scale = 1;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_retcher";
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "ammo_cannon")
	{
		dropped.noise = "items/ammo_cannon.ogg";
		setmodel(dropped,"models/items/ammo_cannon.md3");
		dropped.msg = 124;
		dropped.msg_icon = "ore";
		dropped.msg_text = "$NOTIFY_AMMO_SLAGCANNON";
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_cannon = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.classname = "item_ammo_cannon";
		item_glowmodcontroller_flicker_spawn(dropped);
		dropped.oldtouch = dropped.touch;
	}	
	if (class == "ammo_lance")
	{
		dropped.noise = "items/ammo_lance.ogg";
		setmodel(dropped,"models/items/ammo_lance.md3");
		dropped.msg = 125;
		dropped.msg_icon = "laces";
		dropped.msg_text = "$NOTIFY_AMMO_LANCE";
		dropped.classname = "item_ammo_lance";
		item_glowmodcontroller_pulse_spawn(dropped);
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_lance = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
	}	
	if (class == "ammo_crystal")
	{
		dropped.noise = "items/ammo_crystallizer.ogg";
		setmodel(dropped,"models/items/ammo_crystal.md3");
		dropped.msg = 126;
		dropped.msg_icon = "crystals";
		dropped.msg_text = "$NOTIFY_AMMO_CRYSTAL";
		dropped.classname = "item_ammo_crystal";
		item_glowmodcontroller_pulse_spawn(dropped);
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_crystal = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
	}	

	if (class == "ammo_soul")
	{
		dropped.noise = "items/ammo_mace.ogg";
		setmodel(dropped,"models/weapons/mace/soul.md3");
		dropped.msg = 126;
		dropped.msg_icon = "crystals";
		dropped.msg_text = "$NOTIFY_AMMO_CRYSTAL";
		dropped.classname = "item_ammo_crystal";
		setsizeitem2(dropped, shellsl_size);
		//dropped.ammo_soul = 1;
		dropped.alpha = 0.025;

		dropped.colormod = '1 0.5 0.5';

		dropped.think = soulhome;
		dropped.solid = SOLID_NOT;
		dropped.movetype = MOVETYPE_FLY;			
		dropped.traileffectnum = particleeffectnum("soul_mace_trail");
		dropped.velocity_z = 32;
		dropped.lifetime = time + 0.95; 
		dropped.alpha = 0.025;
		dropped.nextthink = time;

		//dropped.touch = wammo_touch;
		//spawn_bbox_collider(dropped);
		//dropped.oldtouch = dropped.touch;
		return;
	}	

	if (class == "shard")
	{
		dropped.noise = "items/armor_shard3.ogg";
		dropped.rarmorvalue = 10;
		setmodel(dropped, "models/items/armor_shard.md3");
		setsize2(dropped, shard_nsize, shard_size);
		dropped.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_armor_shard)
		dropped.color = shard_light_col;
		dropped.light_lev = shard_lightlev;
		dropped.msg = 13;
		dropped.msg_icon = "shard";
		dropped.msg_text = "$NOTIFY_ARMOR_SHARD";
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "armor")
	{
		dropped.noise = "items/armor1.ogg";
		dropped.rarmorvalue = 50;
		setmodel(dropped, "models/items/armor.md3");
		setsize2(dropped, armor_nsize, armor_size);
		dropped.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_armor)
		dropped.color = armor_light_col;
		dropped.light_lev = armor_lightlev;
		dropped.msg = 2;
		dropped.msg_icon = "armor";
		dropped.msg_text = "$NOTIFY_ARMOR";
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "helm")
	{
		dropped.noise = "items/armor1.ogg";
		dropped.rarmorvalue = 30;
		setmodel(dropped, "models/items/helm.md3");
		setsize2(dropped, helm_nsize, helm_size);
		dropped.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_armor_helm)
		dropped.color = helm_light_col;
		dropped.light_lev = helm_lightlev;
		dropped.msg = 9;
		dropped.msg_icon = "helm";
		dropped.msg_text = "$NOTIFY_ARMOR_HELM";
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "shard_dark")
	{
		local float r;
		r = floor(random() *3);
		if (r < 1)
			dropped.noise = "items/armor_shard_dark1.ogg";
		if (r < 2)
			dropped.noise = "items/armor_shard_dark2.ogg";
		else
			dropped.noise = "items/armor_shard_dark3.ogg";

		dropped.darmorvalue = 10;
		setmodel(dropped, "models/items/armor_shard_dark.md3");
		setsize2(dropped, dark_shard_nsize, dark_shard_size);
		dropped.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_darkarmor_shard)
		dropped.color = dark_shard_light_col;
		dropped.light_lev = dark_shard_lightlev;
		dropped.msg = 6;
		dropped.msg_icon = "dark_shard";
		dropped.msg_text = "$NOTIFY_DARKARMOR_SHARD";
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "armor_dark")
	{
		dropped.noise = "items/armor_dark1.ogg";
		dropped.darmorvalue = 50;
		setmodel(dropped, "models/items/armor_dark.md3");
		setsize2(dropped, dark_armor_nsize, dark_armor_size);
		dropped.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_darkarmor)
		dropped.color = dark_armor_light_col;
		dropped.light_lev = dark_armor_lightlev;
		dropped.msg = 4;
		dropped.msg_icon = "dark_armor";
		dropped.msg_text = "$NOTIFY_DARKARMOR";
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "helm_dark")
	{
		dropped.noise = "items/armor_dark1.ogg";
		dropped.darmorvalue = 30;
		setmodel(dropped, "models/items/helm_dark.md3");
		setsize2(dropped, dark_helm_nsize, dark_helm_size);
		dropped.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_darkarmor_helm)
		dropped.color = dark_helm_light_col;
		dropped.light_lev = dark_helm_lightlev;
		dropped.msg = 5;
		dropped.msg_icon = "dark_helm";
		dropped.msg_text = "$NOTIFY_DARKARMOR_HELM";
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "vial")
	{
		dropped.noise = "items/lifeblood_vial1.ogg";
		dropped.health = 10;
		dropped.colormod = '1 1 1';
		setmodel(dropped, "models/items/lifeblood_vial.md3");
		dropped.touch = larmor_touch;
		setsizeitem2(dropped, vial_size);
		/*if(ownr.classname != "coffer")
		{
		dropped.nextthink = time + 0.2;	// items start after other solids
		dropped.think = PlaceItem;
		}*/
		dropped.msg = 11;
		dropped.msg_icon = "lifeblood_vial";
		dropped.msg_text = "$NOTIFY_HEALTH_VIAL";
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_hpvial)
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "beaker")
	{
		dropped.noise = ("items/lifeblood_beaker1.ogg");
		dropped.health = 30;
		dropped.colormod = '1 1 1';
		setmodel(dropped, "models/items/lifeblood_beaker.md3");
		dropped.touch = larmor_touch;
		setsizeitem2(dropped, beaker_size);
		dropped.msg = 10;
		dropped.msg_icon = "lifeblood_beaker";
		dropped.msg_text = "$NOTIFY_HEALTH_BEAKER";
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_hpbeaker)
		/*if(ownr.classname != "coffer")
		{
		dropped.nextthink = time + 0.2;	// items start after other solids
		dropped.think = PlaceItem;
		}*/
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "chalice")
	{
		dropped.noise = ("items/lifeblood_beaker1.ogg");
		dropped.health = 100;
		dropped.colormod = '1 1 1';
		setmodel(dropped, "models/items/lifeblood_chalice.md3");
		dropped.touch = larmor_touch;
		setsizeitem2(dropped, beaker_size);
		dropped.msg = 40;
		dropped.msg_icon = "lifeblood_chalice";
		dropped.msg_text = "$NOTIFY_HEALTH_CHALICE";
		SET_DYNAMIC_LIGHT_PROPERTIES(dropped, dl_hpchalice)
		//spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "siphon")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.modelflags = MF_ROTATE;
		dropped.noise = "items/artifacts/artifactF_pickup.ogg";
		dropped.LifeSiphon = 1;
		setmodel(dropped, "models/artifacts/artifact_siphon.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.traileffectnum = particleeffectnum("life_siphon");
		dropped.msg = 106;
		dropped.msg_icon = "artifactF";
		dropped.msg_text = "$NOTIFY_ARTIFACT_SIPHON";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "apparatus")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactB_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.DrownerApp = 1;
		setmodel(dropped, "models/artifacts/artifact_apparatus.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 102;
		dropped.msg_icon = "artifactB";
		dropped.msg_text = "$NOTIFY_ARTIFACT_APPARATUS";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "theter")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.modelflags = MF_ROTATE;
		dropped.noise = "items/artifacts/artifactE_pickup.ogg";
		dropped.SoulTether = 1;
		precache_model("models/artifacts/soul_tether.md3");
		setmodel(dropped, "models/artifacts/soul_tether.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 100;
		dropped.msg_icon = "soul_tether";
		dropped.msg_text = "$NOTIFY_SOULTETHER";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "aegis")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactH_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.Aegis = 1;
		setmodel(dropped, "models/artifacts/artifact_aegis.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 108;
		dropped.msg_icon = "artifactH";
		dropped.msg_text = "$NOTIFY_ARTIFACT_AEGIS";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "attar")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_confounding_attar";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactD_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.Attar = 1;
		setmodel(dropped, "models/artifacts/artifact_attar.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 104;
		dropped.msg_icon = "artifactD";
		dropped.msg_text = "$NOTIFY_ARTIFACT_ATTAR";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}
		if (class == "trinket")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_trinket_of_respite";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactG_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.TrinketofRespite = 1;
		setmodel(dropped, "models/artifacts/artifact_deflection.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 107;
		dropped.msg_icon = "artifactG";
		dropped.msg_text = "$NOTIFY_ARTIFACT_DEFLECTION";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}
if (class == "mark")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.classname = "artifact_mark_revelation";
		dropped.noise = "items/artifacts/artifactA_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.MarkRevelation = 1;
		setmodel(dropped, "models/artifacts/artifact_revelation.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 101;
		dropped.msg_icon = "artifactA";
		dropped.msg_text = "$NOTIFY_ARTIFACT_REVELATION";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}
	if (class == "flaskrage")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.classname = "artifact_flaskrage";
		dropped.noise = "items/artifacts/artifactC_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.flaskrage = 1;
		setmodel(dropped, "models/artifacts/artifact_rage.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 103;
		dropped.msg_icon = "artifactC";
		dropped.msg_text = "$NOTIFY_ARTIFACT_RAGE";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}

	if (class == "grenade")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_void_grenade";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactE_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.BlackGrenade = 1;
		setmodel(dropped, "models/artifacts/artifact_grenade.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 105;
		dropped.msg_icon = "artifactE";
		dropped.msg_text = "$NOTIFY_ARTIFACT_GRENADE";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}	

	if (class == "vicious")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_vicious_idol";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactI_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.ViciousIdol = 1;
		setmodel(dropped, "models/artifacts/artifact_animus.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 109;
		dropped.msg_icon = "artifactI";
		dropped.msg_text = "$NOTIFY_ARTIFACT_ANIMUS";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}
	if (class == "shockwave")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_ring_fire";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactJ_pickup.ogg";
		dropped.modelflags = MF_ROTATE;
		dropped.ShockWave = 1;
		setmodel(dropped, "models/artifacts/artifact_shockwave.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 110;
		dropped.msg_icon = "artifactJ";
		dropped.msg_text = "$NOTIFY_ARTIFACT_SHOCKWAVE";
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}

	dropped.nextthink = time + 0.1;	// items start after other solids
	dropped.think = check_item_onfloor;
	
	if (class == "shotgun")
	{
		dropped.items = IT_SHOTGUN;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/shotgun/w_shotgun.md3");
		dropped.ammo_shotgun = 2;
		StartItem(1);
		dropped.modelflags = MF_ROTATE;
		dropped.origin_z += 24;
		dropped.rwpn = 1;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 91;
		dropped.msg_icon = "shotgun";
		dropped.msg_text = "$NOTIFY_WEP_SHOTGUN";
		setsize(dropped, coach_nsize, coach_size);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "revolver")
	{
		dropped.items = IT_REVOLVER;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/revolver/w_revolver.md3");
		dropped.ammo_revolver = 3;
		StartItem(1);
		dropped.modelflags = MF_ROTATE;
		dropped.origin_z += 24;
		dropped.rwpn = 1;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 90;
		dropped.msg_icon = "revolver";
		dropped.msg_text = "$NOTIFY_WEP_REVOLVER";
		setsize(dropped, coach_nsize, coach_size);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "retcher")
	{
		dropped.items = IT_RETCHER;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/retcher/w_retcher.md3");
		setsize(dropped, retcher_nsize, retcher_size);
		dropped.ammo_retcher = 6;
		dropped.rwpn = 1;
		StartItem(1);
		dropped.modelflags = MF_ROTATE;
		dropped.origin_z += 24;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 95;
		dropped.msg_icon = "lace";
		dropped.msg_text = "$NOTIFY_WEP_LANCE";
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "spitter")
	{
		dropped.items = IT_SPITTER;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/spitter/w_spitter.md3");
		setsize(dropped, spitter_nsize, spitter_size);
		dropped.ammo_spitter = 20;
		dropped.rwpn = 1;
		StartItem(1);
		dropped.modelflags = MF_ROTATE;
		dropped.origin_z += 24;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 92;
		dropped.msg_icon = "spitter";
		dropped.msg_text = "$NOTIFY_WEP_SPITTER";
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "cannon")
	{
		dropped.items = IT_CANNON;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/cannon/w_cannon.md3");
		setsize(dropped, slag_nsize, slag_size);
		precache_sound(dropped.noise);
		dropped.ammo_cannon = 20;
		dropped.rwpn = 1;
		StartItem(1);
		dropped.modelflags = MF_ROTATE;
		dropped.origin_z += 24;
		dropped.touch = wammo_touch;
		dropped.msg = 94;
		dropped.msg_icon = "slagcannon";
		dropped.msg_text = "$NOTIFY_WEP_SLAGCANNON";
		dropped.oldtouch = dropped.touch;
		
	}

	dropped.velocity = revel;
	dropped.solid = SOLID_TRIGGER;
	
	
 	if(dropped.owner.classname == "coffer")
	{
	dropped.solid = SOLID_NOT;
	dropped.nextthink = time + 0.1;	// items start after other solids
	dropped.think = vel_item;
//	dropped.think = 
	}

	return dropped;
};

void() mace_full_touch =
{
	if(other.classname != "player")
		return;
	other.ammo_bfg += 10;
	te_customflash(self.origin,other.ammo_bfg * 3.5,7,'3 0 0');

	string snd = strcat ("weapons/mace/mace_absorb",ftos(other.ammo_bfg ),".ogg");
	sound(other, CHAN_AUTO, snd, 0.7, ATTN_NORM);
	if (other.ammo_bfg == 10)
		sound(other, CHAN_AUTO,"weapons/mace/mace_unfold1.ogg", 1, ATTN_NORM);

	stuffcmd (other,"pulseammo\n");
	flash_screen_item(other);
	float m_ammo = 10;
	while(m_ammo > 0)
	{
		Hud_SendNotification(other, "soul", "$NOTIFY_AMMO_SOUL", HUDMSGFLAG::AGGREGATE);
		m_ammo --;
	}
	remove(self);
};


void(vector org, string class, float ammount, entity slf) convert_to_item = 
{
	self.origin = org;
	self.movetype = MOVETYPE_TOSS;
	self.angles = self.angles;
	//	if(!(self.flags &FL_ITEM))
	//	self.flags += FL_ITEM;		// make extra wide
	//self.targetname = string_null;
	self.use = artifact_drop;
	self.classtype = string_null;
	self.classitem1 = 0;
	self.classitem2 = 0;
	self.classitem3 = 0;
	self.classitem4 = 0;
	self.classitem5 = 0;
	vector revel;
	float hascollider;
	if (class == "ammo_revolver")
	{
	
		setmodel(self, "models/items/ammo_revolver.md3");
		self.noise = "items/ammo_revolver.ogg";
		self.classname = "ammo_revolver";
		self.msg = 120;
		self.msg_icon = "slugs";
		self.msg_text = "$NOTIFY_AMMO_REVOLVER";
		setsizeitem2(self, shellsl_size);
		self.ammo_revolver = ammount;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
		hascollider = 1;
	}


	if (class == "ammo_shotgun")
	{
		setmodel(self, "models/items/ammo_shotgun.md3");
		self.noise = "items/ammo_shotgun.ogg";
		self.classname = "ammo_shells";
		self.msg = 121;
		self.msg_icon = "shells";
		self.msg_text = "$NOTIFY_AMMO_SHOTGUN";
		setsizeitem2(self, shells_size);
		self.ammo_shotgun = ammount;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
		hascollider = 1;
	}

	if (class == "shells_inv")
	{
		setmodel(self, "models/items/shells_drop.md3");
		self.avelocity_y = (random() *120 + 120) *crandom();
		self.noise = "items/ammo_revolver.ogg";
		self.classname = "ammo_shells";
		self.msg = 121;
		self.msg_icon = "shells.";
		self.msg_text = "$NOTIFY_AMMO_SHOTGUN";
		setsizeitem2(self, shells_size_invader);
		self.ammo_shotgun = ammount;
		self.touch = wammo_touch;
		hascollider = 1;
	}

	if (class == "ammo_spitter")
	{
		setmodel(self, "models/items/ammo_spitter.md3");
		self.classname = "ammo_fangs";
		self.noise = "items/ammo_spitter.ogg";
		self.msg = 122;
		self.msg_icon = "fangs";
		self.msg_text = "$NOTIFY_AMMO_SPITTER";
		setsizeitem2(self, resin_size);
		self.ammo_spitter = ammount;
		self.touch = wammo_touch;
		hascollider = 1;
	}

	if (class == "ammo_retcher")
	{
		setmodel(self, "models/items/ammo_retcher.md3");
		setsizeitem2(self, explosives_size);
		self.noise = "items/ammo_retcher.ogg";
		self.classname = "ammo_cysts";
		self.msg = 123;
		self.msg_icon = "cysts";
		self.msg_text = "$NOTIFY_AMMO_RETCHER";
		self.scale = 1;
		self.ammo_retcher = ammount;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
		hascollider = 1;
	}

	if (class == "ammo_cannon")
	{
		setmodel(self, "models/items/ammo_cannon.md3");
		self.noise = "items/ammo_cannon.ogg";
		self.classname = "ammo_cannon";
		self.msg = 124;
		self.msg_icon = "ore";
		self.msg_text = "$NOTIFY_AMMO_SLAGCANNON";
		setsizeitem2(self, shellsl_size);
		self.ammo_cannon = ammount;
		self.classname = "item_ammo_cannon";
		item_glowmodcontroller_flicker_spawn(self);
		self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
		hascollider = 1;
	}

	if (class == "ammo_lance")
	{
		//self.colormod = '0 1 3';
		setmodel(self, "models/items/ammo_lance.md3");
		self.classname = "ammo_lance";
		self.noise = "items/ammo_lance.ogg";
		self.ammo_lance = ammount;
		item_glowmodcontroller_pulse_spawn(self);
		self.msg = 125;
		self.msg_icon = "plasma";
		self.msg_text = "$NOTIFY_AMMO_LANCE";
		setsizeitem2(self, resin_size);
		self.touch = wammo_touch;
		hascollider = 1;
	}

	if (class == "ammo_crystal")
	{
		//self.colormod = '0 1 3';
		setmodel(self, "models/items/ammo_crystal.md3");
		self.classname = "ammo_crystaler";
		self.noise = "items/ammo_crystallizer.ogg";
		item_glowmodcontroller_pulse_spawn(self);
		self.ammo_crystal = ammount;
		self.msg = 126;
		self.msg_icon = "crystals";
		self.msg_text = "$NOTIFY_AMMO_CRYSTAL";
		setsizeitem2(self, resin_size);
		self.touch = wammo_touch;
		hascollider = 1;
	}
	
	if (class == "ammo_mace")
	{
		self.count = ammount;
		self.think  = spawnfunc_ammo_mace;
		self.nextthink = time;
		return;		
	}	

	if (class == "shard")
	{
		self.noise = "items/armor_shard3.ogg";
		self.rarmorvalue = 10;
		setmodel(self, "models/items/armor_shard.md3");
		self.classname = "armor_shard";
		setsize2(self, shard_nsize, shard_size);
		self.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor_shard)
		self.color = shard_light_col;
		self.light_lev = shard_lightlev;
		self.msg = 13;
		self.msg_icon = "shard";
		self.msg_text = "$NOTIFY_ARMOR_SHARD";
		hascollider = 1;
	}

	if (class == "armor")
	{
		self.noise = "items/armor1.ogg";
		self.rarmorvalue = 50;
		setmodel(self, "models/items/armor.md3");
		setsize2(self, armor_nsize, armor_size);
		self.touch = larmor_touch;
		self.classname = "armor_armor";
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor)
		self.color = armor_light_col;
		self.light_lev = armor_lightlev;
		self.msg = 2;
		self.msg_icon = "armor";
		self.msg_text = "$NOTIFY_ARMOR";
		hascollider = 1;
	}


	if (class == "helm")
	{
		self.noise = "items/armor1.ogg";
		self.rarmorvalue = 30;
		setmodel(self, "models/items/helm.md3");
		setsize2(self, helm_nsize, helm_size);
		self.classname = "armor_helm";
		self.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor_helm)
		self.color = helm_light_col;
		self.light_lev = helm_lightlev;
		self.msg = 9;
		self.msg_icon = "helm";
		self.msg_text = "$NOTIFY_ARMOR_HELM";
		hascollider = 1;
	}

	if (class == "shard_dark")
	{
		local float r;
		r = floor(random() *3);
		if (r < 1)
			self.noise = "items/armor_shard_dark1.ogg";
		if (r < 2)
			self.noise = "items/armor_shard_dark2.ogg";
		else
			self.noise = "items/armor_shard_dark3.ogg";

		self.classname = "armor_shard_dark";
		self.darmorvalue = 10;
		setmodel(self, "models/items/armor_shard_dark.md3");
		setsize2(self, dark_shard_nsize, dark_shard_size);
		self.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_armor_shard)
		self.color = dark_shard_light_col;
		self.light_lev = dark_shard_lightlev;
		self.msg = 6;
		self.msg_icon = "dark_shard";
		self.msg_text = "$NOTIFY_DARKARMOR_SHARD";
		hascollider = 1;
	}

	if (class == "armor_dark")
	{
		self.noise = "items/armor_dark1.ogg";
		self.darmorvalue = 50;
		setmodel(self, "models/items/armor_dark.md3");
		setsize2(self, dark_armor_nsize, dark_armor_size);
		self.classname = "armor_armor_dark";
		self.touch = larmor_touch;
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_darkarmor)
		self.color = dark_armor_light_col;
		self.light_lev = dark_armor_lightlev;
		self.msg = 4;
		self.msg_icon = "dark_armor";
		self.msg_text = "$NOTIFY_DARKARMOR";
		hascollider = 1;
	}


	if (class == "helm_dark")
	{
		self.noise = "items/armor_dark1.ogg";
		self.darmorvalue = 30;
		setmodel(self, "models/items/helm_dark.md3");
		setsize2(self, dark_helm_nsize, dark_helm_size);
		self.touch = larmor_touch;
		self.classname = "armor_helm_dark";
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_darkarmor_helm)
		self.color = dark_helm_light_col;
		self.light_lev = dark_helm_lightlev;
		self.msg = 5;
		self.msg_icon = "dark_helm";
		self.msg_text = "$NOTIFY_DARKARMOR_HELM";
		hascollider = 1;
	}

	if (class == "vial")
	{
		self.noise = "items/lifeblood_vial1.ogg";
		self.health = 10;
		self.colormod = '1 1 1';
		self.classname = "health_life_vial";
		setmodel(self, "models/items/lifeblood_vial.md3");
		setsizeitem2(self, vial_size);
		self.touch = larmor_touch;
		self.oldtouch = self.touch;
		self.msg = 11;
		self.msg_icon = "lifeblood_vial";
		self.msg_text = "$NOTIFY_HEALTH_VIAL";
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpvial)
		hascollider = 1;	
	}

	if (class == "beaker")
	{
		self.noise = ("items/lifeblood_beaker1.ogg");
		self.health = 30;
		self.colormod = '1 1 1';
		self.classname = "health_life_beaker";
		setmodel(self, "models/items/lifeblood_beaker.md3");
		self.touch = larmor_touch;
		setsizeitem2(self, beaker_size);
		self.msg = 10;
		self.msg_icon = "lifeblood_beaker";
		self.msg_text = "$NOTIFY_HEALTH_BEAKER";
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpbeaker)
		hascollider = 1;		
	}
	if (class == "chalice")
	{
		self.noise = ("items/lifeblood_beaker1.ogg");
		self.health = 100;
		self.colormod = '1 1 1';
		self.classname = "health_life_chalice";
		setmodel(self, "models/items/lifeblood_chalice.md3");
		self.touch = larmor_touch;
		setsizeitem2(self, beaker_size);
		self.msg = 40;
		self.msg_icon = "lifeblood_chalice";
		self.msg_text = "$NOTIFY_HEALTH_CHALICE";
		SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_hpchalice)
		hascollider = 0;
	}
	if(hascollider == 1)
	spawn_bbox_collider(self);
	self.velocity = revel;
	self.solid = SOLID_TRIGGER;


	if (class == "siphon")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_life_siphon";
		self.modelflags = MF_ROTATE;
		self.noise = "items/artifacts/artifactF_pickup.ogg";
		self.LifeSiphon = 1;
		setmodel(self, "models/artifacts/life_siphon.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.traileffectnum = particleeffectnum("life_siphon");
		self.msg = 106;
		self.msg_icon = "artifactF";
		self.msg_text = "$NOTIFY_ARTIFACT_SIPHON";
		self.touch = artifact_touch;
	}


	if (class == "mark")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_mark_revelation";
		self.noise = "items/artifacts/artifactA_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.MarkRevelation = 1;
		setmodel(self, "models/artifacts/artifact_revelation.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 101;
		self.msg_icon = "artifactA";
		self.msg_text = "$NOTIFY_ARTIFACT_REVELATION";
		self.touch = artifact_touch;
	}
	if (class == "apparatus")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_drowners_apparatus";
		self.noise = "items/artifacts/artifactB_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.DrownerApp = 1;
		setmodel(self, "models/artifacts/artifact_apparatus.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 102;
		self.msg_icon = "artifactB";
		self.msg_text = "$NOTIFY_ARTIFACT_APPARATUS";
		self.touch = artifact_touch;
	}
	if (class == "flaskrage")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_flaskrage";
		self.noise = "items/artifacts/artifactC_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.flaskrage = 1;
		setmodel(self, "models/artifacts/artifact_rage.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 103;
		self.msg_icon = "artifactC";
		self.msg_text = "$NOTIFY_ARTIFACT_RAGE";
		self.touch = artifact_touch;
	}
	if (class == "attar")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_confounding_attar";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactD_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.Attar = 1;
		setmodel(self, "models/artifacts/artifact_attar.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 104;
		self.msg_icon = "artifactD";
		self.msg_text = "$NOTIFY_ARTIFACT_ATTAR";
		self.touch = artifact_touch;
	}
	if (class == "grenade")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_void_grenade";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactE_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.BlackGrenade = 1;
		setmodel(self, "models/artifacts/artifact_grenade.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 105;
		self.msg_icon = "artifactE";
		self.msg_text = "$NOTIFY_ARTIFACT_GRENADE";
		self.touch = artifact_touch;
	}	
	if (class == "trinket")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_trinket_of_respite";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactG_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.TrinketofRespite = 1;
		setmodel(self, "models/artifacts/artifact_deflection.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 107;
		self.msg_icon = "artifactG";
		self.msg_text = "$NOTIFY_ARTIFACT_DEFLECTION";
		self.touch = artifact_touch;
	}	
	if (class == "aegis")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_cruel_aegis";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactH_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.Aegis = 1;
		setmodel(self, "models/artifacts/artifact_aegis.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 108;
		self.msg_icon = "artifactH";
		self.msg_text = "$NOTIFY_ARTIFACT_AEGIS";
		self.touch = artifact_touch;
	}
	if (class == "vicious")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_vicious_idol";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactI_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.ViciousIdol = 1;
		setmodel(self, "models/artifacts/artifact_animus.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 109;
		self.msg_icon = "artifactI";
		self.msg_text = "$NOTIFY_ARTIFACT_ANIMUS";
		self.touch = artifact_touch;
	}
	if (class == "shockwave")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_ring_fire";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactJ_pickup.ogg";
		self.modelflags = MF_ROTATE;
		self.ShockWave = 1;
		setmodel(self, "models/artifacts/artifact_shockwave.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 110;
		self.msg_icon = "artifactJ";
		self.msg_text = "$NOTIFY_ARTIFACT_SHOCKWAVE";
		self.touch = artifact_touch;
	}
	if (class == "theter")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_soul_tether";
		self.modelflags = MF_ROTATE;
		self.noise = "items/artifacts/artifactE_pickup.ogg";
		self.SoulTether = 1;
		precache_model("models/artifacts/soul_tether.md3");
		setmodel(self, "models/artifacts/soul_tether.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 100;
		self.msg_icon = "soul_tether";
		self.msg_text = "$NOTIFY_SOULTETHER";
		self.touch = artifact_touch;
	}



	if (class == "shotgun")
	{
		self.items = IT_SHOTGUN;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_shotgun";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/shotgun/w_shotgun.md3");
		self.ammo_shotgun = 2;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.rwpn = 1;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 91;
		self.msg_icon = "shotgun";
		self.msg_text = "$NOTIFY_WEP_SHOTGUN";
		setsize(self, coach_nsize, coach_size);
	}

	if (class == "revolver")
	{
		self.items = IT_REVOLVER;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_revolver";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/revolver/w_revolver.md3");
		self.ammo_revolver = 3;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.rwpn = 1;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 90;
		self.msg_icon = "revolver";
		self.msg_text = "$NOTIFY_WEP_REVOLVER";
		setsize(self, coach_nsize, coach_size);
	}

	if (class == "retcher")
	{
		self.items = IT_RETCHER;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_retcher";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/retcher/w_retcher.md3");
		setsize(self, retcher_nsize, retcher_size);
		self.ammo_retcher = 6;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 93;
		self.msg_icon = "retcher";
		self.msg_text = "$NOTIFY_WEP_RETCHER";
	}

	if (class == "spitter")
	{
		self.items = IT_SPITTER;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_spitter";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/spitter/w_spitter.md3");
		setsize(self, spitter_nsize, spitter_size);
		self.ammo_spitter = 20;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 92;
		self.msg_icon = "spitter";
		self.msg_text = "$NOTIFY_WEP_SPITTER";
	}

	if (class == "cannon")
	{
		self.items = IT_CANNON;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_slaggcannon";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/cannon/w_cannon.md3");
		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.ammo_cannon = 20;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.touch = wammo_touch;
		self.msg = 94;
		self.msg_icon = "slagcannon";
		self.msg_text = "$NOTIFY_WEP_SLAGCANNON";
	}
	if (class == "lance")
	{
		self.items = IT_LANCE;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_lance";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/lance/w_lance.md3");
		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.ammo_lance = 10;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.touch = wammo_touch;
		self.msg = 95;
		self.msg_icon = "lance";
		self.msg_text = "$NOTIFY_WEP_LANCE";
	}
	if (class == "crystal")
	{
		self.items = IT_CRYSTAL;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_crystal";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/crystal/w_crystal.md3");
		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.ammo_crystal = 20;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.touch = wammo_touch;
		self.msg = 96;
		self.msg_icon = "crystallizer";
		self.msg_text = "$NOTIFY_WEP_BOILER";
	}
	if (class == "mace")
	{
		self.items = IT_MACE;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_mace";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/mace/w_mace.md3");

		if(single_player.items & IT_MACE)
			setmodel(self, "models/weapons/mace/w_mace_open.md3");

		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.touch = wammo_touch;
		self.msg = 97;
		self.msg_icon = "mace";
		self.msg_text = "$NOTIFY_WEP_MACE";
	}

	if (class == "mace_full")
	{
		self.items = IT_MACE;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_mace";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/mace/w_mace_open.md3");
		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = MF_ROTATE;
		self.origin_z += 24;
		self.touch = mace_full_touch;
		self.msg = 97;
		self.msg_icon = "mace";
		self.msg_text = "$NOTIFY_WEP_MACE";
	}
	self.velocity = revel;
	self.solid = SOLID_TRIGGER;


	self.oldtouch = self.touch;
	
};

void() item_Sigil = 
{
	StartItem(6);
	self.touch = artifact_touch;
	setsize(self, '-14 -14 -14', '14 14 14');
};

void() key_touch = 
{
	if (other.classname != "player")
		return;
	if ((other.items &self.items))
	{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}

	if (self.slot_keys)
	{
		if (!other.slot_keys)
			other.slot_keys = self.slot_keys * 100;
		else
		{
			local string slotdigits, slotdigitsdozen;
			local float slotdozens;
			slotdigits = ftos(other.slot_keys);
			slotdigitsdozen = substring(slotdigits, 1, 2);
			slotdozens = stof(slotdigitsdozen);
			if (slotdozens)
				other.slot_keys += self.slot_keys;
			else
				other.slot_keys += self.slot_keys * 10;
		}
	}
	other.items += self.items;
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	sound7(self, CHAN_AUTO, "items/coffer_key.ogg", 1, ATTN_NORM,75,0);
	if (self.msg_icon || self.msg_text)
		Hud_SendNotification(other, self.msg_icon, self.msg_text);
	else if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	flash_screen_item(other);
	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_SendNotification(other, "secret", "$NOTIFY_SECRET");
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		secrets_checkperfect(other);
	}
	if (deathmatch)
	{
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
	}
	else
	{
		self.effects = EF_NODRAW;
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;

		if (self.msg == 31)
			other.rkeyson = self;
		if (self.msg == 28)
			other.bkeyson = self;
		if (self.msg == 32)
			other.ykeyson = self;
	}
};

void() coffer_key_touch = 
{
	if (other.classname != "player")
		return;
	if ((other.items &IT_COFFERKEY3))
	{if(other.time_emptymessage < time)Hud_FullNotification(other);other.time_emptymessage = time + 2.1;return;}

	
	
	if (!(other.items & IT_COFFERKEY1))
		{other.items += self.items;other.keyson1 = self;}
	else
	{
	if ((other.items & IT_COFFERKEY1) && (other.items & IT_COFFERKEY2) )
		{other.items +=  IT_COFFERKEY3;other.keyson3 = self;}

	else
		{other.items +=  IT_COFFERKEY2;other.keyson2 = self;}

	}
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg_icon || self.msg_text)
		Hud_SendNotification(other, self.msg_icon, self.msg_text);
	else if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	flash_screen_item(other);
	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_SendNotification(other, "secret", "$NOTIFY_SECRET");
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		secrets_checkperfect(other);
	}
	if (deathmatch)
	{
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
	}
	else
	{
		self.effects = EF_NODRAW;
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;

	}
};
.float episode;
void() key_coffer = 
{
	self.modelflags = MF_ROTATE;
	self.rwpn = 1;
	self.noise = "items/coffer_key.ogg";
	precache_sound(self.noise);
	self.items = IT_COFFERKEY1;

	if(!self.episode)
		self.episode = world.episode;
	
	if(self.episode == 1)
		setmodel(self, "models/keys/key_1_coffer.md3");
	if(self.episode == 2)
		setmodel(self, "models/keys/key_2_coffer.md3");
	if(self.episode == 3)
		setmodel(self, "models/keys/key_3_coffer.md3");

	setsize(self, coffer_key_nsize, coffer_key_size);

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_cofferkey)
	self.light_lev = cofferkey_lightlev;
	self.color = cofferkey_light_col;
	StartItem(4);
	self.scale = 1;
	self.classname = "coffer_key";
	self.touch = coffer_key_touch;
	self.msg = 25;
	self.msg_icon = "coffer_key";
	self.msg_text = "$NOTIFY_KEY_COFFER";
	self.wrathflags += FL_RESPAWN;
	copy_old_data(self);
};

/*Plays sound when unlocked by glyph (objects/door_unlocked.ogg)
ITEM_GLYPH_BLUE
-4 -4 -4, 4 4 4 bbox
items/glyph.ogg (played when picked up)
models/items/glyph_blue.md3
Hud element (icon in upper right hand corner where coffer key icon goes) gfx/hud/glyph_blue.tga
Show message on pick up (gfx/hud/msg_glyph_blue.tga)
*/

void() key_red = 
{
	self.noise = "items/glyph.ogg";
	precache_sound(self.noise);
	self.items = IT_KEY1;
	self.modelflags = MF_ROTATE;
	if(!self.episode)
		self.episode = world.episode;
	
	if(self.episode == 1)
		setmodel(self, "models/keys/key_1_red.md3");
	if(self.episode == 2)
		setmodel(self, "models/keys/key_2_red.md3");
	if(self.episode == 3)
		setmodel(self, "models/keys/key_3_red.md3");

	setsize(self, coffer_key_nsize, coffer_key_size);
	StartItem(1);
	self.scale = 1;
	
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_redkey)

	self.touch = key_touch;
	self.msg = 31;
	self.msg_icon = "key_red";
	self.msg_text = "$NOTIFY_KEY_RED";
	self.slot_keys = 1;
	self.wrathflags += FL_RESPAWN;
	self.movetype = MOVETYPE_TOSS;

	copy_old_data(self);
};

void() key_blue = 
{
	self.noise = "items/glyph.ogg";
	precache_sound(self.noise);
	self.items = IT_KEY2;
	if(!self.episode)
		self.episode = world.episode;
	
	self.pflags = 129;
	self.light_lev = 48;
	self.color = '0 0 1';

	if(self.episode == 1)
		setmodel(self, "models/keys/key_1_blue.md3");
	if(self.episode == 2)
		setmodel(self, "models/keys/key_2_blue.md3");
	if(self.episode == 3)
		setmodel(self, "models/keys/key_3_blue.md3");

	setsize(self, coffer_key_nsize, coffer_key_size);
	StartItem(1);
	self.scale = 1;

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_bluekey)

	self.touch = key_touch;
	self.msg = 28;
	self.msg_icon = "key_blue";
	self.msg_text = "$NOTIFY_KEY_BLUE";
	self.modelflags = MF_ROTATE;
	self.slot_keys = 2;
	self.wrathflags += FL_RESPAWN;
	self.movetype = MOVETYPE_TOSS;

	copy_old_data(self);
};

void() key_yellow = 
{
	self.noise = "items/glyph.ogg";
	precache_sound(self.noise);
	self.items = IT_KEY3;
	self.modelflags = MF_ROTATE;
	
	if(!self.episode)
		self.episode = world.episode;
		
	self.pflags = 129;
	self.light_lev = 48;
	self.color = '1 1 0';

	if(self.episode == 1)
		setmodel(self, "models/keys/key_1_yellow.md3");
	if(self.episode == 2)
		setmodel(self, "models/keys/key_2_yellow.md3");
	if(self.episode == 3)
		setmodel(self, "models/keys/key_3_yellow.md3");

	setsize(self, coffer_key_nsize, coffer_key_size);
	StartItem(1);
	self.scale = 1;

	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_yellowkey)

	self.touch = key_touch;
	self.msg = 32;
	self.msg_icon = "key_yellow";
	self.msg_text = "$NOTIFY_KEY_YELLOW";
	self.slot_keys = 3;
	self.wrathflags += FL_RESPAWN;
	self.movetype = MOVETYPE_TOSS;
	copy_old_data(self);
};

.float relic_dthou;
.float relic_thou;
.float relic_cent;
.float relic_doze;
.float relic_unit;

void() relic_touch = 
{
	if (other.classname != "player")
		return;
	if (!(other.foundedrelics & self.relics))
	{
		// Reki (February 16 2024): for save-salvaging purposes
		// no-longer consider this full, just allow the pickup but don't
		// increase encounter number

		other.relics |= self.relics;
		other.foundedrelics |= self.relics;
		relic_addtoslot(other, self.relics);
	
		if (self.msg_icon != "relic_intro") // Reki (September 18 2023): Fixed encounter number erroneously incrementing during intro map
			other.oldrelics++;

		//if(other.time_emptymessage < time)
		//{
		//	Hud_FullNotification(other);
		//	other.time_emptymessage = time + 2.1;
		//}
		return;
	}

	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg_icon || self.msg_text)
		Hud_SendNotification(other, self.msg_icon, self.msg_text);
	else if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	flash_screen_item(other);

	remove(self);
};

void(float num) relic_generic =
{
	self.noise = "items/relic.ogg";
	precache_sound(self.noise);
	self.relics = RL_E1M1 << (num - 1);
	setmodel(self, "models/items/relic.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.skin = num;
	StartItem(1);
	self.touch = relic_touch;
	self.msg = 50 + num;
}

void() relic_e1m1 = 
{
	relic_generic(1);
	self.msg_icon = "relic_e1m1";
	self.msg_text = "$NOTIFY_RELIC_E1M1";
};
void() relic_e1m2 = 
{
	relic_generic(2);
	self.msg_icon = "relic_e1m2";
	self.msg_text = "$NOTIFY_RELIC_E1M2";
};
void() relic_e1m3 = 
{
	relic_generic(3);
	self.msg_icon = "relic_e1m3";
	self.msg_text = "$NOTIFY_RELIC_E1M3";
};
void() relic_e1m4 = 
{
	relic_generic(4);
	self.msg_icon = "relic_e1m4";
	self.msg_text = "$NOTIFY_RELIC_E1M4";
};
void() relic_e1m5 = 
{
	relic_generic(5);
	self.msg_icon = "relic_e1m5";
	self.msg_text = "$NOTIFY_RELIC_E1M5";
};
void() relic_e2m1 = 
{
	relic_generic(6);
	self.msg_icon = "relic_e2m1";
	self.msg_text = "$NOTIFY_RELIC_E2M1";
};
void() relic_e2m2 = 
{
	relic_generic(7);
	self.msg_icon = "relic_e2m2";
	self.msg_text = "$NOTIFY_RELIC_E2M2";
};
void() relic_e2m3 = 
{
	relic_generic(8);
	self.msg_icon = "relic_e2m3";
	self.msg_text = "$NOTIFY_RELIC_E2M3";
};
void() relic_e2m4 = 
{
	relic_generic(9);
	self.msg_icon = "relic_e2m4";
	self.msg_text = "$NOTIFY_RELIC_E2M4";
};
void() relic_e2m5 = 
{
	relic_generic(10);
	self.msg_icon = "relic_e2m5";
	self.msg_text = "$NOTIFY_RELIC_E2M5";
};
void() relic_e3m1 = 
{
	relic_generic(11);
	self.msg_icon = "relic_e3m1";
	self.msg_text = "$NOTIFY_RELIC_E3M1";
};
void() relic_e3m2 = 
{
	relic_generic(12);
	self.msg_icon = "relic_e3m2";
	self.msg_text = "$NOTIFY_RELIC_E3M2";
};
void() relic_e3m3 = 
{
	relic_generic(13);
	self.msg_icon = "relic_e3m3";
	self.msg_text = "$NOTIFY_RELIC_E3M3";
};
void() relic_e3m4 = 
{
	relic_generic(14);
	self.msg_icon = "relic_e3m4";
	self.msg_text = "$NOTIFY_RELIC_E3M4";
};
void() relic_e3m5 = 
{
	relic_generic(15);
	self.msg_icon = "relic_e3m5";
	self.msg_text = "$NOTIFY_RELIC_E3M5";
};
void() relic_intro = 
{
	relic_generic(16);
	self.msg_icon = "relic_intro";
	self.msg_text = "$NOTIFY_RELIC_INTRO";
};

void() coffer_item_think = 
{
	local entity pl;
	pl = find(world, classname, "player");
	setorigin(self, pl.origin);
	self.think = SUB_Remove;
	self.nextthink = time + 2.5;
};


.float coffer_random_order;

.float coffer_step;


void() coffer_use_next  =
{
	//(entity targ, vector viewerangles,vector viewerorigin,float viewerdeviance) custom_infront

	if(custom_infront(self, self.enemy.v_angle + '0 180 0', self.enemy.origin,90))
		self.ammo_shotgun ++;
	else
		self.ammo_shotgun = 0;

	if(self.ammo_shotgun > 30)
	{
		sound(self, CHAN_AUTO, "objects/coffers/coffer2_locked.ogg", 1, 0.125);
		self.type = 3;
		remove(self.pipes);
		self.think = SUB_Remove;
		self.nextthink = time + 0.5;
	}		
	else
		self.think = coffer_use_next;
	self.nextthink = time + 0.025;

};

void() trigger_coffer_use = 
{ 	local entity ca, ch;
	self.classname = "coffer";


	if(self.counter_coffer_use == self.counter_coffer_ammount)
	{
		if(self.type == 2)
			self.think = SUB_Remove;
		else
		{
			self.noise = "objects/coffers/coffer2_locked.ogg";
			if((self.episode == 3))
			{
				self.enemy = single_player;
				self.think = coffer_use_next;
			}
			else
				self.think = SUB_Null;
		}
		self.nextthink = time + 3;
	}
	else
		self.think = trigger_coffer_use ;
	self.nextthink = time + 0.25;

	vector tagorg = tag_origin("tag_items", self);

	//vector tagorg = self.origin + '0 0 32';
	if (self.coffer_artifacts)
	{
		self.counter_coffer_use ++;
		ca = spawn();
		if(self.type != 2)
		{
			if (self.coffer_artifacts == 1)
				drop_item(tagorg, "mark", 1, self);
			if (self.coffer_artifacts == 2)
				drop_item(tagorg, "apparatus", 1, self);
			if (self.coffer_artifacts == 3)
				drop_item(tagorg, "flaskrage", 1, self);
			if (self.coffer_artifacts == 4)
				drop_item(tagorg, "attar", 1, self);
			if (self.coffer_artifacts == 11)			
				drop_item(tagorg, "grenade", 1, self);
			if (self.coffer_artifacts == 6)
				drop_item(tagorg, "siphon", 1, self);
			if (self.coffer_artifacts == 7)
				drop_item(tagorg, "trinket", 1, self);
			if (self.coffer_artifacts == 8)
				drop_item(tagorg, "aegis", 1, self);
			if (self.coffer_artifacts == 9)
				drop_item(tagorg, "vicious", 1, self);
			if (self.coffer_artifacts == 10)
				drop_item(tagorg, "shockwave", 1, self);
			if (self.coffer_artifacts == 5)
				drop_item(tagorg, "tether", 1, self);
		}
		else
			drop_item(tagorg, "helm_dark", 1, self);

		self.coffer_artifacts = 0;
		return;		
	}		
	if (self.coffer_ammo)
	{
		self.counter_coffer_use ++;
		if(self.type != 2)
		{
			if (self.coffer_ammo == 1)
				drop_item(tagorg, "ammo_revolver", 15, self);
			else if (self.coffer_ammo == 2)
				drop_item(tagorg, "ammo_shotgun", 10, self);
			else if (self.coffer_ammo == 3)
				drop_item(tagorg, "ammo_spitter", 20, self);
			else if (self.coffer_ammo == 4)
				drop_item(tagorg, "ammo_retcher", 10, self);
			else if (self.coffer_ammo == 5)
				drop_item(tagorg, "ammo_cannon", 5, self);
			else if (self.coffer_ammo == 6)
				drop_item(tagorg, "ammo_lance", 5, self);
			else if (self.coffer_ammo == 7)
				drop_item(tagorg, "ammo_crystal", 10, self);
			else if (self.coffer_ammo == 8)
				drop_item(tagorg, "ammo_soul", 1, self);
		}
		else
			drop_item(tagorg, "armor_dark", 1, self);

		self.coffer_ammo = 0;
		return;		
	}
	if (self.coffer_armor)
	{
		self.counter_coffer_use ++;
		if(self.type != 2)
		{
			if (self.coffer_armor == 1)
				drop_item(tagorg, "shard", 1, self);
			if (self.coffer_armor == 2)
				drop_item(tagorg, "armor", 1, self);
			if (self.coffer_armor == 3)
				drop_item(tagorg, "helm", 1, self);
			if (self.coffer_armor == 4)
				drop_item(tagorg, "shard_dark", 1, self);
			if (self.coffer_armor == 5)
				drop_item(tagorg, "armor_dark", 1, self);
			if (self.coffer_armor == 6)
				drop_item(tagorg, "helm_dark", 1, self);
		}
		else
			drop_item(tagorg, "shard_dark", 1, self);
		self.coffer_armor = 0;
		return;		
	}
	if (self.coffer_health)
	{
		self.counter_coffer_use ++;
		if(self.type != 2)
		{
			ch = spawn();
			if (self.coffer_health == 1)
				drop_item(tagorg, "vial", 1, self);
			if (self.coffer_health == 2)
				drop_item(tagorg, "beaker", 1, self);
			if (self.coffer_health == 3)
				drop_item(tagorg, "chalice", 1, self);
		}
		else
			drop_item(tagorg, "shard_dark", 1, self);
		self.coffer_health = 0;
		return;		
	}

};

//void() trigger_coffer = 
//{
//	self.use = trigger_coffer_use;
//};

void() manuscript_touch = 
{
	if (other.classname != "player")
		return;
	if (!(other.journal_jmessages &self.journal_jmessages))
	{
		other.journal_jmessages += self.journal_jmessages;
		sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
		remove(self);
	}
	if (!(other.journal_jmessagesm &self.journal_jmessagesm))
	{
		other.journal_jmessagesm += self.journal_jmessagesm;
		sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
		remove(self);
	}
};
.float bestiary;
.float jmessage;
.float jmessagem;
void() item_manuscript = 
{
	setmodel(self, "models/items/manuscript.md3");
	setsizeitem(self, '4 4 24');
	self.noise = "misc/null.wav";
	precache_sound(self.noise);
	if (!(self.bestiary))
	{
		if (!self.jmessage)
			self.jmessage = 1;
		self.journal_jmessages = pow(2, (self.jmessage - 1));
		if (self.jmessage == 1)
			self.journal_jmessages = 1;
	}
	else
	{
		if (!self.jmessagem)
			self.jmessagem = 1;
		self.journal_jmessagesm = pow(2, (self.jmessagem - 1));
		if (self.jmessagem == 1)
			self.journal_jmessagesm = 1;
	}
	self.origin_z += 24;
	self.light_lev = 64;
	self.pflags = 129;
	self.color = '1 1 0.5';
	self.effects = EF_FULLBRIGHT;
	StartItem(1);
	self.scale = 0.5;
	self.touch = manuscript_touch;

};


.float note;
void() readable_touch = 
{
	if (other.classname != "player")
		return;
	if (self.journal_jmessages && !(other.journal_jmessages & self.journal_jmessages))
	{
		other.journal_jmessages |= self.journal_jmessages;
		Hud_SendNotification_Note(other, self.msg_icon, self.note);
		sound7(self, CHAN_AUTO, self.noise, 1, 0,150,0);
		remove(self);
	}
	if (self.journal_jmessagesb && !(other.journal_jmessagesb & self.journal_jmessagesb))
	{
		other.journal_jmessagesb |= self.journal_jmessagesb;
		Hud_SendNotification_Note(other, self.msg_icon, self.note);
		sound7(self, CHAN_AUTO, self.noise, 1, 0,150,0);
		remove(self);
	}

	if (((other.journal_jmessages & PERFECT_LOREA) == PERFECT_LOREA) && ((other.journal_jmessagesb & PERFECT_LOREB) == PERFECT_LOREB))
	{
		Steam_AchievementUnlock(other, ST_ACHIEVEMENTS::SP_GRIND_LORE_ALL);
	}
};


void() item_readable_use =
{
	self.solid = SOLID_TRIGGER;
	self.effects -= EF_NODRAW;
	self.use = SUB_Null;
	//droptofloor();

}
void() item_readable =
{
	setmodel(self, "models/items/item_readable.md3");

	vector bbmin = '-8 -8 -0';
	vector bbmax = '8 8 6';
	
	if(self.spawnflags & 1)
	{
		bbmax_z += 24;
		bbmin_z += 12;
		self.origin_z -= 12;
	} 
	if(self.spawnflags & 2)
	{
		bbmin -= '4 4 0';
		bbmax += '4 4 0';
	}
	setsize(self, bbmin,bbmax);



	self.noise = "ui/journal/journal_open.ogg";
	precache_sound(self.noise);
	
	if(self.note <= 24)
		self.journal_jmessages = 1 << (self.note - 1);
	else
		self.journal_jmessagesb = 1 << (self.note - 25);

	//self.origin_z += 24;
	SET_DYNAMIC_LIGHT_PROPERTIES(self, dl_readable)
	//self.effects = 512;
	self.style = 1;
	self.scale = 1;
	self.touch = readable_touch;
	self.origin_z = self.origin_z + 12;

	if(!(self.targetname))
	{
		self.solid = SOLID_TRIGGER;
		self.movetype = MOVETYPE_TOSS;
	}
	else
	{
		self.use = item_readable_use;
		self.effects = EF_NODRAW;
	 }
	self.velocity = '0 0 0';
	//oldz = self.origin_z;


	self.msg_icon = "journal_update";
	item_glowmodcontroller_pulse_spawn(self);
};

void() coffer_model_think = 
{
	self.frame = self.owner.frame;
	self.glowmod = self.owner.glowmod;
	self.think = coffer_model_think;
	self.nextthink = time + 0.01;

	if (self.frame == 1)
		self.usable = 0;
	if (self.owner.frame >= 19)
	{
		//if(self.owner.classname != "coffer_open")
			//remove(self);
		if(self.owner.type == 2)
		{
			self.nextthink = time + 0.5;
			self.think = alphafade;
		}
		if(self.owner.type == 3)
		{
			self.nextthink = time;
			self.think = SUB_Remove;
		}
	}
};

void() coffer_jumpscare =
{
	life_siphon_effect(self.origin + '0 0 12', self);

	self.nextthink = time + 0.1;
	self.think = use_coffer;
}

void() use_coffer = 
{
	local float ft;
	//	if(self.frame == -5)
	//		sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_activate.ogg", 1, ATTN_NORM);
	self.frame += 1;
	if (self.frame <= 10)
	{
		self.glowmod_x -= 0.11;
		self.glowmod_y -= 0.11;
		self.glowmod_z -= 0.11;
	}
	if (self.frame < 1)
		ft = 0.1;
	if (self.frame == 1)
	{
		//	if(self.frame == 17)
		sound(self, CHAN_AUTO, "objects/coffers/coffer1_unlocked.ogg", 1, ATTN_NORM);

		//	sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_rotate.ogg", 1, ATTN_NORM);
		self.use = null;
		self.classname = "coffer_open";
		single_player.opened_coffers++; // Reki (July 24 2023): increment global opened coffer counter
		coffers_checkperfect(single_player);
	}
	if ((self.frame >= 1) && (self.frame <= 15))
	{
		ft = 0.1;
	}
	if (self.frame == 16)
	{
		if(self.type == 2)
		{
			self.coffer_artifacts = 1;
			self.coffer_ammo = 1;
			self.coffer_armor = 1;
			self.coffer_health = 1;
			self.solid = 0;

			self.think = coffer_jumpscare;
			self.nextthink = time + 0.3;
			return;
		}	
		if(self.episode == 1)
			ft = 0.4;
		else
			ft = 0.1;

	}
	if (self.frame > 16)
		ft = 0.1;
	if ((self.frame == 17) && (self.type == 2))
	{
		sound7 (self, CHAN_AUTO, "enemies/widow/sight2.ogg", 1, 0,90,0);
		sound7 (self, CHAN_AUTO, "enemies/widow/sight1.ogg", 1, 0,120,0);

		vector tagorg = self.origin + '0 0 32';
		//vector tagorg = tag_origin("tag_items", self);
		explo_blood(2, tagorg);	
		explo_blood(9, tagorg);	
		chattersound("impact/gibs/gib_explo", 3, 1);

		ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel('164 0 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('132 132 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('0 164 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel('-132 132 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel('-164 0 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('-132 -132 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('0 -164 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel('132 -132 164', self), 0, 3);	// relvel: forward, right, up

	}

	if (self.frame == 18)
	{		
		SUB_UseTargets();
	}
	self.nextthink = time + ft;
	self.think = use_coffer;
	if (self.frame >= 19)
	{
		if((self.episode == 2) && (self.episode == 3))
			ft = 0.4;
		//self.counter_coffer_use ++;
		if (self.coffer_artifacts)
			self.counter_coffer_ammount ++;
		if (self.coffer_ammo)
			self.counter_coffer_ammount ++;
		if (self.coffer_armor)
			self.counter_coffer_ammount ++;
		if (self.coffer_health)
			self.counter_coffer_ammount ++;
		self.nextthink = time + ft;
		self.think = trigger_coffer_use;
	}
};

void() object_coffer = 
{

	string coffermodel, collisionmodel;
	if(!self.episode)
		self.episode = world.episode;
	if(self.episode == 1)
	{
		coffermodel = "models/objects/coffers/coffer1_locked.md3";
		collisionmodel = "models/objects/coffers/coffer1_collision.md3";
	}
	if(self.episode == 2)
	{
		coffermodel = "models/objects/coffers/coffer2_locked.md3";
		collisionmodel = "models/objects/coffers/coffer2_collision.md3";
	
	}
	if(self.episode == 3)
	{
		coffermodel = "models/objects/coffers/coffer3_locked.md3";
		collisionmodel = "models/objects/coffers/coffer3_collision.md3";
	
	}
	precache_model(coffermodel);
	precache_model(collisionmodel);
	precache_sound ("objects/coffers/coffer2_locked.ogg");
	
	self.glowmod = '1 1 1';
	//self.noise = 
	self.noise2 = "objects/coffers/coffer1_locked.ogg";
	self.classname = "coffer";
	self.frame = 0;
	self.usable = 1;
	self.keyrequired = 1;
	self.alpha = -1;
	local entity coffer_model;
	coffer_model = spawn();
	coffer_model.usable = 1;
	coffer_model.owner = self;
	setmodel(coffer_model,coffermodel);
	setattachment(coffer_model, self, "");
	coffer_model.think = coffer_model_think;
	coffer_model.nextthink = time + 0.05;
	self.pipes = coffer_model;
	self.solid = SOLID_BSP;
	if(self.displacement == 1)
	{
		self.wrathflags += FL_INVISIBLE;
		self.effects = EF_NODRAW;
		self.solid = 0;
	}	

	setmodel(self, collisionmodel);
	self.use = use_coffer;
};

void(float velf) spawn_spining_head =
{
	makevectors(self.angles);
	vector revel = v_forward *(64 + random(32, 64)) * velf * 2;
	revel += v_right * random (-64 ,64) * velf;
	revel_z += (32 + random(16,32)) * velf;
	entity new = spawn();
	new.origin = self.origin + ' 0 0 16';
	setmodel(new,"models/enemies/wretch/gibs/gib_head_spin.md3");
	//setsize(new, '-8 -8 -8', '8 8 8');
	new.wrathflags += FL_GIB;
	new.bouncefactor = 0;
	new.touch = gib_touch2;
	new.time2 = time + random(3,5); // timing for nextthink alternative
	new.lifetime = time + wretch_sht;
	new.movetype = MOVETYPE_BOUNCE;
	new.bouncefactor = 1;
	new.velocity = revel;
	new.solid = SOLID_CORPSE;
	new.think = wretch_spining_head;
	new.nextthink = time + 0.05;
	new.frame = 0;
	new.flags = 0;
};
.entity ent_light;
void() use_fakecoffer = 
{
	local float ft;
	//	if(self.frame == -5)
	//		sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_activate.ogg", 1, ATTN_NORM);
	self.frame += 1;
	if (self.frame <= 10)
	{
		self.glowmod_x -= 0.11;
		self.glowmod_y -= 0.11;
		self.glowmod_z -= 0.11;
	}
	if (self.frame < 1)
		ft = 0.1;
	if (self.frame == 1)
	{
		//	if(self.frame == 17)
		sound(self, CHAN_AUTO, "objects/coffers/coffer1_unlocked.ogg", 1, ATTN_NORM);

		//	sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_rotate.ogg", 1, ATTN_NORM);
		self.use = null;
		self.classname = "coffer_open";
	}
	if ((self.frame >= 1) && (self.frame <= 15))
	{
		ft = 0.1;
	}
	if (self.frame == 16)
	{
		if(self.type != 1)
		{
			makevectors (self.angles);
			life_siphon_effect(self.origin + '0 0 12', self);
			life_siphon_effect(self.origin + '0 0 16' + v_right * 12, self);
			life_siphon_effect(self.origin + '0 0 8' + v_right * -12, self);
			sound7 (self, CHAN_AUTO, "enemies/widow/sight2.ogg", 1, 0,90,0);
			sound7 (self, CHAN_AUTO, "enemies/widow/sight2.ogg", 1, 0,112,0);
			sound7 (self, CHAN_AUTO, "enemies/widow/sight2.ogg", 1, 0,120,0);
			sound7 (self, CHAN_AUTO, "enemies/widow/sight1.ogg", 1, 0,105,0);
			sound7 (self, CHAN_AUTO, "enemies/widow/sight1.ogg", 1, 0,120,0);
		}	
		self.solid = SOLID_NOT;
	}
	if (self.frame > 16)
		ft = 0.1;

	if (self.frame == 17)
	{

		vector tagorg = self.origin + '0 0 32';
		pointparticles(particleeffectnum("wretch_bloodshower"), tagorg , '0 0 0', 1);
		explo_blood(2, tagorg);	
		explo_blood(9, tagorg);	
		chattersound("impact/gibs/gib_explo", 3, 1);

		ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel('164 0 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('132 132 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('0 164 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel('-132 132 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel('-164 0 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('-132 -132 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel('0 -164 164', self), 0, 3);	// relvel: forward, right, up
		ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel('132 -132 164', self), 0, 3);	// relvel: forward, right, up

		if(self.type == 1)
		spawn_spining_head (1);
	}
	if (self.frame == 18)
	{		
		if(self.type == 1)
		spawn_spining_head (1.5);
		ft = 0.4;
	}
	if (self.frame >= 19)
	{

		if(self.type == 1)
		spawn_spining_head (2);
		sound(self, CHAN_WEAPON, "misc/null.wav", 1, 1);
		self.attached_cloud.think = alphafade;
		self.attached_cloud.nextthink = time;
		remove(self.ent_light);	
		remove(self);

	}
	else
	self.think = use_fakecoffer;
	self.nextthink = time + ft;
};

void() object_fakecoffer = 
{

	precache_model("models/objects/coffers/coffer1_collision.md3");


	self.glowmod = '1 1 1';
	//self.noise = 
	self.noise2 = "objects/coffers/coffer1_locked.ogg";
	self.classname = "coffer_trap";
	self.usable = 1;
	self.alpha = -1;
	local entity coffer_model;
	coffer_model = spawn();
	self.attached_cloud = coffer_model;
	randomsound2("enemies/wraith/proj_loop", 3, 0.25, CHAN_WEAPON, 0, 0.75);

	entity selflight = spawn();
	selflight.origin = self.origin + '0 0 48';
	selflight.pflags = 129;
	selflight.light_lev = 128;
	selflight.style = 11;
	self.ent_light = self;
	coffer_model.usable = 1;
	coffer_model.owner = self;

	if(self.type == 1)
	{
	selflight.color =  '0.75 0.75 1';
	coffer_model.colormod = '0.75 0.75 1';
	}
	else
	{
	selflight.color =  '1 0.85 0.85';
	coffer_model.colormod = '1 0.85 0.85';
	}
	setmodel(coffer_model, "models/objects/coffers/coffer1_locked.md3");
	setattachment(coffer_model, self, "");
	coffer_model.think = coffer_model_think;
	coffer_model.nextthink = time + 0.05;
	self.solid = SOLID_BSP;
	setmodel(self, "models/objects/coffers/coffer1_collision.md3");
	self.use = use_fakecoffer;
	droptofloor();
};

void() cannon_item_think = {	//void(float effectnum, vector org, vector vel, float howmany) pointparticles 

	if (self.cnt != 1)
	{
		self.glowmod_x += 0.05;
		self.glowmod_y += 0.05;
		self.glowmod_z += 0.05;
		self.light_lev += 0.5;
		self.color_x += 0.05;
		self.color_y += 0.1;
		self.color_z += 0.05;
		self.count += 1;

		if (self.glowmod_x >= 2.2)
			self.cnt = 1;
	}
	else
	{
		self.color_x -= 0.05;
		self.color_y -= 0.1;
		self.color_z -= 0.05;
		self.glowmod_x -= 0.05;
		self.glowmod_y -= 0.05;
		self.glowmod_z -= 0.05;
		self.light_lev -= 0.5;
		self.count -= 1;
		if (self.glowmod_x <= 0.2)
			self.cnt = 0;
	}

	if (self.glowmod_x > 1.9)
		pointparticles(particleeffectnum("cystsnow4"), self.origin, '0 0 0', 1);
	if ((self.glowmod_x < 1.9) && (self.glowmod_x > 1.6))
		pointparticles(particleeffectnum("cystsnow3"), self.origin, '0 0 0', 1);
	if ((self.glowmod_x < 1.6) && (self.glowmod_x > 1.2))
		pointparticles(particleeffectnum("cystsnow2"), self.origin, '0 0 0', 1);
	if ((self.glowmod_x < 1.2) && (self.glowmod_x > 0.8))
		pointparticles(particleeffectnum("cystsnow1"), self.origin, '0 0 0', 1);
	if (self.glowmod_x < 0.8)
		pointparticles(particleeffectnum("cystsnow"), self.origin, '0 0 0', 1);

	self.think = cannon_item_think;
	self.nextthink = time + 0.1;
};
void() cannon_item = 
{
	setmodel(self, "models/projectiles/proj_cyst.md3");
	self.glowmod = '0.2 0.2 0.2';
	self.color = '0.5 1 0.5';
	self.scale = 1;
	self.cnt = 0;
	self.light_lev = 32;
	self.pflags = 131;
	self.think = cannon_item_think;
	self.nextthink = time + 0.05;
};
float rel_totalmonsters;


void (string classnme,vector org, float c1, float c2, float c3, float c4, float c5, float coun, float collectedrelics) write_stuff_monsters =
{
    local float    writeparms;
    local string m_name; 


    string sorg = vtos (org);
	if ((c1 <0) || (c1 > 16) || ( c1 == 13))
		c1 = 0;
	if ((c2 <0) || (c2 > 16) || ( c2 == 13))
		c2 = 0;
	if ((c3 <0) || (c3 > 16) || ( c3 == 13))
		c3 = 0;
	if ((c4 <0) || (c4 > 16) || ( c4 == 13))
		c4 = 0;
	if ((c5 <0) || (c5 > 16) || ( c5 == 13))
		c5 = 0;

    string monst_lookup[] = {
        "null",
        "fallen",
        "invader",
        "wretch",
        "incisor",
        "widow",
        "wraith",
        "heretic",
        "prowler",
        "oppressor",
        "executioner",
        "stricken",
        "afflicted",
        "symbol",
        "brute",
        "keeper",
    };

	if(collectedrelics == 0)
	    m_name = monst_lookup[c1];
	if(collectedrelics == 1)
	    m_name = monst_lookup[c2];
	if(collectedrelics == 2)
	    m_name = monst_lookup[c3];
	if(collectedrelics == 3)
	    m_name = monst_lookup[c4];
	if(collectedrelics == 4)
	    m_name = monst_lookup[c5];

	if(m_name != "null")
	{
		while (coun > 0)
		{
			writeparms = fopen (strcat ("reportmonsters/",mapname, "_encounter_",ftos(collectedrelics + 1),".txt"), FILE_APPEND);    //open what file to use in write mode
			string string1 = strcat ("origin ",sorg," --",m_name,"\n");
			fputs (writeparms,(string1));
			coun --;
		}
	}
    fclose (writeparms);
};

void(float collectedrelics) recount_spawner_monsters =
{
	local entity spawner;
	spawner = findradius(self.origin, 1000000);

	float writeparms = fopen (strcat ("reportmonsters/",mapname, "_encounter_",ftos(collectedrelics + 1),".txt"), FILE_WRITE); 
	fputs (writeparms,(""));
    fclose (writeparms);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if ((spawner.wrathflags &FL_SPAWNER))
		{
			write_stuff_monsters(spawner.classname,spawner.origin, spawner.classmonster1, spawner.classmonster2, spawner.classmonster3, spawner.classmonster4, spawner.classmonster5, spawner.count,collectedrelics);
		}
		spawner = spawner.chain;
	}
};
void (string classnme,vector org,float mhealth) write_stuff_alivemonsters =
{
	float writeparms = fopen (strcat ("reportmonsters/",mapname, "_alive_monsters",".txt"), FILE_APPEND);    //open what file to use in write mode
	string string1 = strcat (classnme," origin:",vtos(org)," health:",ftos(mhealth),"\n");
	fputs (writeparms,(string1));
	fclose (writeparms);
};

void() recount_alive_monsters =
{
	entity alivemonster;
	alivemonster = findradius(self.origin, 1000000);

	float writeparms = fopen (strcat ("reportmonsters/",mapname, "_alive_monsters",".txt"), FILE_WRITE); 
	fputs (writeparms,(""));
    fclose (writeparms);
	while (alivemonster)	//Loops through everything put in the missile entit
	{
		if ((alivemonster.flags &FL_MONSTER) && (alivemonster.health > 0))
		{
			write_stuff_alivemonsters(alivemonster.classname,alivemonster.origin,alivemonster.health);
		}
		alivemonster = alivemonster.chain;
	}
};
void (vector org, float c1, float c2,float c3,float c4,float c5) write_stuff_items =
{
	local float	writeparms;
	local string	s1, s2, s3, s4, s5; 
	writeparms = fopen (strcat ("reportmonsters/",mapname, "items_list.txt"), FILE_APPEND);    //open what file to use in write mode
	string sorg = vtos (org);
	s1 =  ftos (c1);
	s2 =  ftos (c2);
	s3 =  ftos (c3);
	s4 =  ftos (c4);
	s5 =  ftos (c5);
	string string1 = strcat ("item_spawner ","origin ",sorg," ",s1," ",s2," ");
	string string2 =  strcat (s3," ",s4," ",s5,"\n");
	fputs (writeparms, strcat (string1,string2));
	fclose (writeparms);
};

void() recount_spawner_itemss =
{

	float writeparms = fopen (strcat (mapname, "items_list.txt"), FILE_WRITE);
	fputs (writeparms,(""));
    fclose (writeparms);

	local entity spawner;
	spawner = findradius(self.origin, 1000000);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if ((spawner.classname == "item_spawner"))
		{
			write_stuff_items(spawner.origin, spawner.classitem1, spawner.classitem2, spawner.classitem3, spawner.classitem4, spawner.classitem5);
		}

		spawner = spawner.chain;
	}

};

void() recount_spawner_items =
{
/*
1 : "Slugs" - TOTAL AMOUNT IN MAP
2 : "Cysts" - TOTAL AMOUNT IN MAP
3 : "Shells" - TOTAL AMOUNT IN MAP
4 : "Fans" - TOTAL AMOUNT IN MAP
25 : "Ammo Cannon" - TOTAL AMOUNT IN MAP
26 : "Ammo Lance" - TOTAL AMOUNT IN MAP
5 : "Armor Shard" - TOTAL AMOUNT IN MAP
6 : "Armor Armor" - TOTAL AMOUNT IN MAP
7 : "Armor Helm" - TOTAL AMOUNT IN MAP
8 : "Dark Armor Shard" - TOTAL AMOUNT IN MAP
9 : "Dark Armor Armor" - TOTAL AMOUNT IN MAP
10 : "Dark Armor Helm" - TOTAL AMOUNT IN MAP
11 : "Health Vial" - TOTAL AMOUNT IN MAP
12 : "Health Baker" - TOTAL AMOUNT IN MAP
20 : "Artifact Apparatus" - TOTAL AMOUNT IN MAP
21 : "Artifact Theter" - TOTAL AMOUNT IN MAP
22 : "Artifact Siphon" - TOTAL AMOUNT IN MAP
23 : "Artifact Aegis" - TOTAL AMOUNT IN MAP
24 : "Confounding Attar" - TOTAL AMOUNT IN MAP
*/



	float ammount1, ammount2, ammount3, ammount4, ammount5;
	float ammounta1, ammounta2, ammounta3, ammounta4, ammounta5;
	float ammountb1, ammountb2, ammountb3, ammountb4, ammountb5;
	float ammountc1, ammountc2, ammountc3, ammountc4, ammountc5;
	float ammountd1, ammountd2, ammountd3, ammountd4, ammountd5;
	float ammounte1, ammounte2, ammounte3, ammounte4, ammounte5;
	float ammountf1, ammountf2, ammountf3, ammountf4, ammountf5;
	float ammountg1, ammountg2, ammountg3, ammountg4, ammountg5;
	float ammounth1, ammounth2, ammounth3, ammounth4, ammounth5;
	float ammountz1, ammountz2, ammountz3, ammountz4, ammountz5;
	float ammounti1, ammounti2, ammounti3, ammounti4, ammounti5;
	float ammountj1, ammountj2, ammountj3, ammountj4, ammountj5;
	float ammountk1, ammountk2, ammountk3, ammountk4, ammountk5;
	float ammountl1, ammountl2, ammountl3, ammountl4, ammountl5;
	float ammountm1, ammountm2, ammountm3, ammountm4, ammountm5;
	float ammountn1, ammountn2, ammountn3, ammountn4, ammountn5;
	float ammounto1, ammounto2, ammounto3, ammounto4, ammounto5;
	float ammountp1, ammountp2, ammountp3, ammountp4, ammountp5;
	float ammountq1, ammountq2, ammountq3, ammountq4, ammountq5;
	//float ammountr1, ammountr2, ammountr3, ammountr4, ammountr5;



	local entity spawner;
	spawner = findradius(self.origin, 1000000);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if ((spawner.classname == "item_spawner"))
		{
			if(spawner.classitem1 == 1) ammount1 ++;		if(spawner.classitem2 == 1) ammount2 ++;		if(spawner.classitem3 == 1) ammount3 ++;		if(spawner.classitem4 == 1) ammount4 ++; if(spawner.classitem5 == 1) ammount5 ++;	
			if(spawner.classitem1 == 2) ammounta1 ++;	if(spawner.classitem2 == 2) ammounta2 ++;	if(spawner.classitem3 == 2) ammounta3 ++;	if(spawner.classitem4 == 2) ammounta4 ++; if(spawner.classitem5 == 2) ammounta5 ++;	
			if(spawner.classitem1 == 3) ammountb1 ++;	if(spawner.classitem2 == 3) ammountb2 ++;	if(spawner.classitem3 == 3) ammountb3 ++;	if(spawner.classitem4 == 3) ammountb4 ++; if(spawner.classitem5 == 3) ammountb5 ++;	
			if(spawner.classitem1 == 4) ammountc1 ++;	if(spawner.classitem2 == 4) ammountc2 ++;	if(spawner.classitem3 == 4) ammountc3 ++;	if(spawner.classitem4 == 4) ammountc4 ++; if(spawner.classitem5 == 4) ammountc5 ++;	
			if(spawner.classitem1 == 25) ammountd1 ++;	if(spawner.classitem2 == 25) ammountd2 ++;	if(spawner.classitem3 == 25) ammountd3 ++;	if(spawner.classitem4 == 25) ammountd4 ++; if(spawner.classitem5 == 25) ammountd5 ++;	
			if(spawner.classitem1 == 26) ammounte1 ++;	if(spawner.classitem2 == 26) ammounte2 ++;	if(spawner.classitem3 == 26) ammounte3 ++;	if(spawner.classitem4 == 26) ammounte4 ++; if(spawner.classitem5 == 26) ammounte5 ++;	
			if(spawner.classitem1 == 5) ammountf1 ++;	if(spawner.classitem2 == 5) ammountf2 ++;	if(spawner.classitem3 == 5) ammountf3 ++;	if(spawner.classitem4 == 5) ammountf4 ++; if(spawner.classitem5 == 5) ammountf5 ++;	
			if(spawner.classitem1 == 6) ammountg1 ++;	if(spawner.classitem2 == 6) ammountg2 ++;	if(spawner.classitem3 == 6) ammountg3 ++;	if(spawner.classitem4 == 6) ammountg4 ++; if(spawner.classitem5 == 6) ammountg5 ++;	
			if(spawner.classitem1 == 7) ammounth1 ++;	if(spawner.classitem2 == 7) ammounth2 ++;	if(spawner.classitem3 == 7) ammounth3 ++;	if(spawner.classitem4 == 7) ammounth4 ++; if(spawner.classitem5 == 7) ammounth5 ++;	
			if(spawner.classitem1 == 8) ammountz1 ++;	if(spawner.classitem2 == 8) ammountz2 ++;	if(spawner.classitem3 == 8) ammountz3 ++;		if(spawner.classitem4 == 8) ammountz4 ++; if(spawner.classitem5 == 8) ammountz5 ++;	
			if(spawner.classitem1 == 9) ammounti1 ++;	if(spawner.classitem2 == 9) ammounti2 ++;	if(spawner.classitem3 == 9) ammounti3 ++;	if(spawner.classitem4 == 9) ammounti4 ++; if(spawner.classitem5 == 9) ammounti5 ++;	
			if(spawner.classitem1 == 10) ammountj1 ++;	if(spawner.classitem2 == 10) ammountj2 ++;	if(spawner.classitem3 == 10) ammountj3 ++;	if(spawner.classitem4 == 10) ammountj4 ++; if(spawner.classitem5 == 10) ammountj5 ++;	
			if(spawner.classitem1 == 11) ammountk1 ++;	if(spawner.classitem2 == 11) ammountk2 ++;	if(spawner.classitem3 == 11) ammountk3 ++;	if(spawner.classitem4 == 11) ammountk4 ++; if(spawner.classitem5 == 11) ammountk5 ++;	
			if(spawner.classitem1 == 12) ammountl1 ++;	if(spawner.classitem2 == 12) ammountl2 ++;	if(spawner.classitem3 == 12) ammountl3 ++;	if(spawner.classitem4 == 12) ammountl4 ++; if(spawner.classitem5 == 12) ammountl5 ++;	
			if(spawner.classitem1 == 20) ammountm1 ++;	if(spawner.classitem2 == 20) ammountm2 ++;	if(spawner.classitem3 == 20) ammountm3 ++;	if(spawner.classitem4 == 20) ammountm4 ++; if(spawner.classitem5 == 20) ammountm5 ++;	
			if(spawner.classitem1 == 21) ammountn1 ++;	if(spawner.classitem2 == 21) ammountn2 ++;	if(spawner.classitem3 == 21) ammountn3 ++;	if(spawner.classitem4 == 21) ammountn4 ++; if(spawner.classitem5 == 21) ammountn5 ++;	
			if(spawner.classitem1 == 22) ammounto1 ++;	if(spawner.classitem2 == 22) ammounto2 ++;	if(spawner.classitem3 == 22) ammounto3 ++;	if(spawner.classitem4 == 22) ammounto4 ++; if(spawner.classitem5 == 22) ammounto5 ++;	
			if(spawner.classitem1 == 23) ammountp1 ++;	if(spawner.classitem2 == 23) ammountp2 ++;	if(spawner.classitem3 == 23) ammountp3 ++;	if(spawner.classitem4 == 23) ammountp4 ++; if(spawner.classitem5 == 23) ammountp5 ++;	
			if(spawner.classitem1 == 24) ammountq1 ++;	if(spawner.classitem2 == 24) ammountq2 ++;	if(spawner.classitem3 == 24) ammountq3 ++;	if(spawner.classitem4 == 24) ammountq4 ++; if(spawner.classitem5 == 24) ammountq5 ++;	
		}

		spawner = spawner.chain;
	}




	string subline1 =strcat("1: Slugs-", " enc1:",(ftos (ammount1)),  " enc2:",(ftos (ammount2)),  " enc3:",(ftos (ammount3)),  " enc4");
	string subline1b =strcat((ftos (ammount4)),  " enc5:",(ftos (ammount5)));  
	string line1 = strcat (subline1, subline1b);

	string subline2 =strcat("2: Cysts -", " enc1:",(ftos (ammounta1)),  " enc2:",(ftos (ammounta2)),  " enc3:",(ftos (ammounta3)),  " enc4");
	string subline2b =strcat((ftos (ammounta4)),  " enc5:",(ftos (ammounta5)));  
	string line2 = strcat (subline2, subline2b);

	string subline3 =strcat("3: Shells -", " enc1:",(ftos (ammountb1)),  " enc2:",(ftos (ammountb2)),  " enc3:",(ftos (ammountb3)),  " enc4");
	string subline3b =strcat((ftos (ammountb4)),  " enc5:",(ftos (ammountb5)));  
	string line3 = strcat (subline3, subline3b); 

	string subline4 =strcat("4: Fans -", " enc1:",(ftos (ammountc1)),  " enc2:",(ftos (ammountc2)),  " enc3:",(ftos (ammountc3)),  " enc4");
	string subline4b =strcat((ftos (ammountc4)),  " enc5:",(ftos (ammountc5)));  
	string line4 = strcat (subline4, subline4b);

	string subline5 =strcat("25: Ammo Cannon -", " enc1:",(ftos (ammountd1)),  " enc2:",(ftos (ammountd2)),  " enc3:",(ftos (ammountd3)),  " enc4");
	string subline5b =strcat((ftos (ammountd4)),  " enc5:",(ftos (ammountd5)));  
	string line5 = strcat (subline5, subline5b);

	string subline6 =strcat("26: Ammo Lance -", " enc1:",(ftos (ammounte1)),  " enc2:",(ftos (ammounte2)),  " enc3:",(ftos (ammounte3)),  " enc4");
	string subline6b =strcat((ftos (ammounte4)),  " enc5:",(ftos (ammounte5)));  
	string line6 = strcat (subline6, subline6b);

	string subline7 =strcat("5: Armor Shard -", " enc1:",(ftos (ammountf1)),  " enc2:",(ftos (ammountf2)),  " enc3:",(ftos (ammountf3)),  " enc4");
	string subline7b =strcat((ftos (ammountf4)),  " enc5:",(ftos (ammountf5)));  
	string line7 = strcat (subline7, subline7b);

	string subline8 =strcat("6: Armor Armor -", " enc1:",(ftos (ammountg1)),  " enc2:",(ftos (ammountg2)),  " enc3:",(ftos (ammountg3)),  " enc4");
	string subline8b =strcat((ftos (ammountg4)),  " enc5:",(ftos (ammountg5)));  
	string line8 = strcat (subline8, subline8b);

	string subline9 =strcat("7: Armor Helm -", " enc1:",(ftos (ammounth1)),  " enc2:",(ftos (ammounth2)),  " enc3:",(ftos (ammounth3)),  " enc4");
	string subline9b =strcat((ftos (ammounth4)),  " enc5:",(ftos (ammounth5)));  
	string line9 = strcat (subline9, subline9b);

	string subline10 =strcat("8: Dark Armor Shard -", " enc1:",(ftos (ammountz1)),  " enc2:",(ftos (ammountz2)),  " enc3:",(ftos (ammountz3)),  " enc4");
	string subline10b =strcat((ftos (ammountz4)),  " enc5:",(ftos (ammountz5)));  
	string line10 = strcat (subline10, subline10b);

	string subline11 =strcat("9: Dark Armor Armor -", " enc1:",(ftos (ammounti1)),  " enc2:",(ftos (ammounti2)),  " enc3:",(ftos (ammounti3)),  " enc4");
	string subline11b =strcat((ftos (ammounti4)),  " enc5:",(ftos (ammounti5)));  
	string line11 = strcat (subline11, subline11b);

	string subline12 =strcat("10: Dark Armor Helm -", " enc1:",(ftos (ammountj1)),  " enc2:",(ftos (ammountj2)),  " enc3:",(ftos (ammountj3)),  " enc4");
	string subline12b =strcat((ftos (ammountj4)),  " enc5:",(ftos (ammountj5)));  
	string line12 = strcat (subline12, subline12b);

	string subline13 =strcat("11: Health Vial -", " enc1:",(ftos (ammountk1)),  " enc2:",(ftos (ammountk2)),  " enc3:",(ftos (ammountk3)),  " enc4");
	string subline13b =strcat((ftos (ammountk4)),  " enc5:",(ftos (ammountk5)));  
	string line13 = strcat (subline13, subline13b);

	string subline14 =strcat("12: Health Baker -", " enc1:",(ftos (ammountl1)),  " enc2:",(ftos (ammountl2)),  " enc3:",(ftos (ammountl3)),  " enc4");
	string subline14b =strcat((ftos (ammountl4)),  " enc5:",(ftos (ammountl5)));  
	string line14 = strcat (subline14, subline14b);

	string subline15 =strcat("20: Artifact Apparatus -", " enc1:",(ftos (ammountm1)),  " enc2:",(ftos (ammountm2)),  " enc3:",(ftos (ammountm3)),  " enc4");
	string subline15b =strcat((ftos (ammountm4)),  " enc5:",(ftos (ammountm5)));  
	string line15 = strcat (subline15, subline15b);

	string subline16 =strcat("21: Artifact Theter -", " enc1:",(ftos (ammountn1)),  " enc2:",(ftos (ammountn2)),  " enc3:",(ftos (ammountn3)),  " enc4");
	string subline16b =strcat((ftos (ammountn4)),  " enc5:",(ftos (ammountn5)));  
	string line16 = strcat (subline16, subline16b);

	string subline17 =strcat("22: Artifact Siphon -", " enc1:",(ftos (ammounto1)),  " enc2:",(ftos (ammounto2)),  " enc3:",(ftos (ammounto3)),  " enc4");
	string subline17b =strcat((ftos (ammounto4)),  " enc5:",(ftos (ammounto5)));  
	string line17 = strcat (subline17, subline17b);

	string subline18 =strcat("23: Artifact Aegis -", " enc1:",(ftos (ammountp1)),  " enc2:",(ftos (ammountp2)),  " enc3:",(ftos (ammountp3)),  " enc4");
	string subline18b =strcat((ftos (ammountp4)),  " enc5:",(ftos (ammountp5)));  
	string line18 = strcat (subline18, subline18b);

	string subline19 =strcat("24: Confounding Attar -", " enc1:",(ftos (ammountq1)),  " enc2:",(ftos (ammountq2)),  " enc3:",(ftos (ammountq3)),  " enc4");
	string subline19b =strcat((ftos (ammountq4)),  " enc5:",(ftos (ammountq5)));
	string line19 = strcat (subline19, subline19b);

	local float	writeparms;
	writeparms = fopen (strcat (mapname, "items_list.txt"), FILE_APPEND);    //open what file to use in write mode
	fputs (writeparms, strcat (line1,"\n"));
	fputs (writeparms, strcat (line2,"\n"));
	fputs (writeparms, strcat (line3,"\n"));
	fputs (writeparms, strcat (line4,"\n"));
	fputs (writeparms, strcat (line5,"\n"));
	fputs (writeparms, strcat (line6,"\n"));
	fputs (writeparms, strcat (line7,"\n"));
	fputs (writeparms, strcat (line8,"\n"));
	fputs (writeparms, strcat (line9,"\n"));
	fputs (writeparms, strcat (line10,"\n"));
	fputs (writeparms, strcat (line11,"\n"));
	fputs (writeparms, strcat (line12,"\n"));
	fputs (writeparms, strcat (line13,"\n"));
	fputs (writeparms, strcat (line14,"\n"));
	fputs (writeparms, strcat (line15,"\n"));
	fputs (writeparms, strcat (line16,"\n"));
	fputs (writeparms, strcat (line17,"\n"));
	fputs (writeparms, strcat (line18,"\n"));
	fputs (writeparms, strcat (line19,"\n"));
	fclose (writeparms);

};

.float fweapon_shotgun;
.float fweapon_revolver;
.float fweapon_spitter;
.float fweapon_retcher;
.float fweapon_cannon;
.float fweapon_lance;
.float fweapon_crystal;
.float fweapon_mace;
.float ammo_mace;
.float VoidGrenade;
.float OrbOfDeflection;
.float FlaskOfRage;
void() item_donor_think =
{
	if (self.classname == "item_donor")
	{
		if (self.enhealth <= 0)
			return;
		self.enhealth--;
	}

    if (self.fweapon_revolver > 0)
        single_player.items |= IT_REVOLVER; 
    if (self.fweapon_shotgun > 0)
        single_player.items |= IT_SHOTGUN; 
    if (self.fweapon_spitter > 0)
        single_player.items |= IT_SPITTER; 
    if (self.fweapon_retcher > 0)
        single_player.items |= IT_RETCHER; 
    if (self.fweapon_cannon > 0)
        single_player.items |= IT_CANNON; 
    if (self.fweapon_lance > 0)
        single_player.items |= IT_LANCE; 
    if (self.fweapon_crystal > 0)
        single_player.items |= IT_CRYSTAL; 
    if (self.fweapon_mace > 0)
        single_player.items |= IT_MACE;
	
    single_player.ammo_revolver = max(single_player.ammo_revolver, self.ammo_revolver);
    single_player.ammo_shotgun = max(single_player.ammo_shotgun, self.ammo_shotgun);
    single_player.ammo_spitter = max(single_player.ammo_spitter, self.ammo_spitter);
    single_player.ammo_retcher = max(single_player.ammo_retcher, self.ammo_retcher);
    single_player.ammo_cannon = max(single_player.ammo_cannon, self.ammo_cannon);
    single_player.ammo_lance = max(single_player.ammo_lance, self.ammo_lance);
    single_player.ammo_crystal = max(single_player.ammo_crystal, self.ammo_crystal);
    single_player.ammo_bfg = max(single_player.ammo_bfg, self.ammo_mace);

	single_player.health = max(single_player.health, self.health);
    single_player.rarmorvalue = max(single_player.rarmorvalue, self.rarmorvalue);
    single_player.darmorvalue = max(single_player.darmorvalue, self.darmorvalue);

    single_player.SoulTether = max(single_player.SoulTether, self.SoulTether);
    single_player.LifeSiphon = max(single_player.LifeSiphon, self.LifeSiphon);
    single_player.TrinketofRespite = max(single_player.TrinketofRespite, self.OrbOfDeflection);
    single_player.Attar = max(single_player.Attar, self.Attar);
    single_player.Aegis = max(single_player.Aegis, self.Aegis);
    single_player.flaskrage = max(single_player.flaskrage, self.FlaskOfRage);
    single_player.DrownerApp = max(single_player.DrownerApp, self.DrownerApp);
    single_player.MarkRevelation = max(single_player.MarkRevelation, self.MarkRevelation);
    single_player.BlackGrenade = max(single_player.BlackGrenade, self.VoidGrenade);
    single_player.ViciousIdol = max(single_player.ViciousIdol, self.ViciousIdol);
    single_player.ShockWave = max(single_player.ShockWave, self.ShockWave);

	//flash_screen_item(single_player);
	stuffcmd(single_player, "set map_command 0\n");
	self.think = SUB_Null;
	self.nextthink = time + 1;
};


void() item_donor_forcethink =
{
	for(entity itemdonor = findchain(::classname, "item_donor"); itemdonor; itemdonor = itemdonor.chain)
	{		
		itemdonor.think = item_donor_think;
		itemdonor.nextthink = time + 1;
	}
}


void() item_donor_mapforcethink =
{
	for(entity itemdonor = findchain(::classname, "item_donor_map"); itemdonor; itemdonor = itemdonor.chain)
	{
		itemdonor.think = item_donor_think;
		itemdonor.nextthink = time + 1;
	}
}

void() item_donor_map = // link it to set new parms
{
	setmodel(self,"");
    //self.nextthink = time + 1;
    //self.think = item_donor_think;	
};

void() item_donor =
{
	setmodel(self,"");
	self.enhealth = 1;
    //self.nextthink = time + 1;
    //self.think = item_donor_think;

}; 

void() item_weapon_fixer =
{	
	entity spawnedweapon = nextent(world);
	while (spawnedweapon)	
	{
		entity holder = nextent(spawnedweapon);
		if (spawnedweapon.itemisweapon == 1)
		{
			if(single_player.items & spawnedweapon.items)
			{
				vector tagorg = spawnedweapon.origin;
				if (spawnedweapon.items & IT_REVOLVER)
					drop_item(tagorg, "ammo_revolver", 15, spawnedweapon);
				if (spawnedweapon.items & IT_SHOTGUN)
					drop_item(tagorg, "ammo_shotgun", 10, spawnedweapon);
				if (spawnedweapon.items & IT_SPITTER)
					drop_item(tagorg, "ammo_spitter", 20, spawnedweapon);
				if (spawnedweapon.items & IT_RETCHER)
					drop_item(tagorg, "ammo_retcher", 10, spawnedweapon);
				if (spawnedweapon.items & IT_CANNON)
					drop_item(tagorg, "ammo_cannon", 5, spawnedweapon);
				if (spawnedweapon.items & IT_LANCE)
					drop_item(tagorg, "ammo_lance", 5, spawnedweapon);
				if (spawnedweapon.items & IT_CRYSTAL)
					drop_item(tagorg, "ammo_crystal", 10, spawnedweapon);
				if (spawnedweapon.items & IT_MACE)
				{
					spawnedweapon.items = IT_MACE;
					spawnedweapon.classname = "weapon_mace";
					spawnedweapon.itemisweapon = 1;
					setmodel(spawnedweapon, "models/weapons/mace/w_mace_open.md3");
					setsize(spawnedweapon, slag_nsize, slag_size);
					spawnedweapon.rwpn = 1;
					StartItem(1);
					spawnedweapon.modelflags = MF_ROTATE;
					spawnedweapon.origin_z += 24;
					spawnedweapon.touch = mace_full_touch;
					spawnedweapon.msg = 97;
					spawnedweapon.msg_icon = "mace";
					spawnedweapon.msg_text = "$NOTIFY_WEP_MACE";
				}

				remove(spawnedweapon);
			}
		}
		spawnedweapon = holder;	
	}
};
///////////////end of qc file
