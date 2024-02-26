


/* #region place_shepherd entity */
#ifdef SSQC

float SendEntity_place_shepherd(entity to, float sendflags)
{
	WriteByte(MSG_ENTITY, ENT::PLACE_SHEPHERD);
	WriteByte(MSG_ENTITY, sendflags);

	if (sendflags & 0x01)
	{
		WriteVectorL(MSG_ENTITY, self.origin);
		WriteVectorA(MSG_ENTITY, self.angles);
	}

	if (sendflags & 0x02)
	{
		WriteShort(MSG_ENTITY, self.ideal_yaw);
		WriteShort(MSG_ENTITY, self.frame);
		WriteByte(MSG_ENTITY, self.skin);
	}

	return TRUE;
}

float shepherd_hublines_spoken;
var float shepherd_hublines_lastspoken = -1;
nosave float shepherd_hublines_refresh;
nosave float shepherd_speak_cooldown;
nosave float shepherd_speak_automatic;
.float shepherd_thisautomatic;
/*
string shepherd_hublines[] = {
	"$SHEPHERD_LINE_ENCOUNTER0",
	"$SHEPHERD_LINE_ENCOUNTER1",
	"$SHEPHERD_LINE_ENCOUNTER2",
	"$SHEPHERD_LINE_ENCOUNTER3",
	"$SHEPHERD_LINE_ENCOUNTER4",
	"$SHEPHERD_LINE_ENCOUNTER5",
}
*/

float shepherd_dialogue_chooseline(void)
{
	float encounter_level = single_player.oldrelics;

	if !(shepherd_hublines_refresh) // check if we just loaded in, players might need a refresher
	{
		shepherd_hublines_refresh = TRUE;
		shepherd_hublines_spoken &= ~(1 << shepherd_hublines_lastspoken);
	}

	for(float i = min(5, encounter_level); i >= 0; i--)
	{
		float bit = 1 << i;
		if !(shepherd_hublines_spoken & bit)
		{
			return i;
		}

		if (i == 5)
			break;
	}
}

void shepherd_dialogue_usetargets(void)
{
	activator = self;
	SUB_UseTargets();
}

void shepherd_dialogue_use(void)
{
	entity lst = world;
	while(lst = findflags(lst, flags, FL_CLIENT))
	{
		centerprint(lst, strcat("&", self.message));
	}
	
	static float medium_samp = 0;
	static float short_samp = 0;
	string sample;
	if (self.wait >= 3)
		sample = sprintf("sound/npc/shepherd_voicing_medium%.0f.ogg", (medium_samp++ % 5) + 1);
	else
		sample = sprintf("sound/npc/shepherd_voicing_short%.0f.ogg", (short_samp++ % 4) + 1);

	sound(activator, CHAN_AUTO, sample, 1, ATTN_NONE);

	if (activator.classname == "place_shepherd")
		self.owner = activator;
	else
		self.owner = activator.owner;

	self.owner.pain_finished = time + 3;
	self.owner.attack_finished = time + max(5, self.wait);

	if (self.wait)
	{
		self.think = shepherd_dialogue_usetargets;
		self.nextthink = time + self.wait;
	}
}

void spawnfunc_shepherd_dialogue(void)
{
	if (!self.targetname)
	{
		remove(self);
		return;
	}

	self.use = shepherd_dialogue_use;
}

const .string targlist[] = {target, target2, target3, target4, target5, target6};

void shepherd_usepressed(void)
{
	float line = shepherd_hublines_lastspoken;
	if (line >= 0 && line < targlist.length)
	{
		activator = self;
		string targ = self.targlist[line];
		entity lst = world;
		while(lst = find(lst, targetname, targ))
		{
			self = lst;
			lst.use();
		}
		self = activator;
	}
}

void shepherd_approached(void)
{
	if (time < shepherd_speak_cooldown)
		return;

	if (self.spawnflags & 1)
	{
		if (shepherd_speak_automatic)
			return;

		shepherd_speak_cooldown = time + 10;
		shepherd_speak_automatic = TRUE;

		float line = shepherd_dialogue_chooseline();
		if (line >= 0 && line < targlist.length)
		{
			shepherd_hublines_lastspoken = line;

			activator = self;
			string targ = self.targlist[line];
			entity lst = world;
			while(lst = find(lst, targetname, targ))
			{
				self = lst;
				lst.use();
			}
			self = activator;
		}
	}
	else
	{
		if (self.shepherd_thisautomatic)
			return;

		shepherd_speak_cooldown = time + 10;
		self.shepherd_thisautomatic = TRUE;

		activator = self;
		string targ = self.target;
		entity lst = world;
		while(lst = find(lst, targetname, targ))
		{
			self = lst;
			lst.use();
		}
		self = activator;
	}
}

void place_shepherd_think(void)
{
	if (self.origin != self.oldorigin || self.angles != self.v_angle)
	{
		self.oldorigin = self.origin;
		self.v_angle = self.angles;
		self.SendFlags |= 0x01;
	}
	self.SendFlags |= 0x02; // bleh, whatever

	if (time < self.pain_finished)
	{
		self.frame = 1;
	}
	else
	{
		self.frame = 0;
	}

	if (time <= self.attack_finished)
		self.frame |= 0x40;
	else if ((self.spawnflags & 2) && self.attack_finished)
	{
		self.frame |= 0x80;
		self.solid = SOLID_NOT;
		sound7(self, CHAN_AUTO, "fx/tele1.ogg", 1, 0.5, 120, 0);
		float bparticle = particleeffectnum("tetherparticle");
		pointparticles(bparticle, self.origin, '0 0 0', 1);
		return;
	}

	if (self.spawnflags & 1) // hub mode, so we expect hub lines
	{
		if (shepherd_hublines_lastspoken >= 0 && (time > self.attack_finished) && (time > shepherd_speak_cooldown))
		{
			self.usable = 3;
		}
		else
		{
			self.usable = 0;
		}

		if !(shepherd_speak_automatic)
			self.frame |= 0x40;
		
		// check for approach
		entity lst = world;
		while(lst = findflags(lst, flags, FL_CLIENT))
		{
			vector diff = vlen(lst.origin - self.origin);
			if (vlen(diff) > 256)
				continue;
			
			shepherd_approached();
			break;
		}
		//
	}
	else
	{
		if !(self.shepherd_thisautomatic)
			self.frame |= 0x40;

		entity lst = world;
		while(lst = findflags(lst, flags, FL_CLIENT))
		{
			vector diff = vlen(lst.origin - self.origin);
			if (vlen(diff) > 256)
				continue;
			
			shepherd_approached();
			break;
		}
	}

	self.think = place_shepherd_think;
	self.nextthink = time + 0.1;
}

void place_shepherd_filter(void)
{
	float loc = self.location;
	if (self.oldrelics >= 5)
		loc = 6;

	entity lst = world;
	while(lst = find(lst, classname, "place_shepherd"))
	{
		if !(lst.spawnflags & 1)
			continue;

		if (lst.location == loc)
		{
			lst.effects = 0;
			lst.solid = SOLID_BBOX;
			lst.SendEntity = SendEntity_place_shepherd;
			lst.think = place_shepherd_think;
			lst.nextthink = time + 0.1;
			continue;
		}

		lst.think = 0;
		lst.nextthink = 0;
		lst.effects = EF_NODRAW;
		lst.solid = SOLID_NOT;
		lst.SendEntity = 0;
	}
}

void spawnfunc_place_shepherd(void)
{
	precache_sound("sound/npc/shepherd_voicing_medium1.ogg");
	precache_sound("sound/npc/shepherd_voicing_medium2.ogg");
	precache_sound("sound/npc/shepherd_voicing_medium3.ogg");
	precache_sound("sound/npc/shepherd_voicing_medium4.ogg");
	precache_sound("sound/npc/shepherd_voicing_medium5.ogg");
	precache_sound("sound/npc/shepherd_voicing_short1.ogg");
	precache_sound("sound/npc/shepherd_voicing_short2.ogg");
	precache_sound("sound/npc/shepherd_voicing_short3.ogg");
	precache_sound("sound/npc/shepherd_voicing_short4.ogg");
	precache_model("models/enemies/shepherd/shepherd.md3");

	setmodel(self, "models/enemies/shepherd/shepherd.md3");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.frame = 0;
	//self.spawnflags = 1;

	self.solid = SOLID_BBOX;
	self.SendEntity = SendEntity_place_shepherd;
	self.think = place_shepherd_think;
	self.nextthink = time + 0.1;
	self.usepressed = shepherd_usepressed;
}
#endif

#ifdef CSQC
const float shepherd_positions = 6;
const float shepherd_blendtime = 0.3;
.float frame_pose;
.float frame_nextcheck;
.float frame_dir;

void place_shepherd_predraw(void)
{
	if (self.frame_pose & 0x80) // fade out!
	{
		self.effects = EF_DOUBLESIDED | EF_ADDITIVE;
		self.colormod = '0.8 0.5 0.3';
		self.alpha = max(0.001, self.alpha - (frametime * 5));
		if (self.alpha < 0.01)
			self.effects |= EF_NODRAW;
		return;
	}

	self.alpha = 1;
	self.colormod = 0;
	self.effects = 0;

	float f_dir = bound(0, 2 + self.frame_dir, 5);
	float f_pose = 0;//self.frame_pose & (0x3F);
	
	if (self.frame_pose & 0x40) // we should try to face the outlander
	{
		vector cam_diff = getpropertyvec(VF_ORIGIN) - self.origin;
		if (vlen(cam_diff) < 512 && vlen(cam_diff) > 64)
		{
			float ang_to = vectoangles(cam_diff)[1];
			float ang_diff = angle_difference(ang_to, self.angles[1]);
			if (fabs(ang_diff) > 130)
				ang_diff = 0;
			
			ang_diff += 90;
			ang_diff = bound(0, ang_diff, 180);
			f_dir = round(ang_diff / 45);
		}
	}
	
	float old_dir = self.frame % shepherd_positions;
	float old_pose = floor(self.frame / shepherd_positions);

	if (old_dir != f_dir)
	{
		float diff = fabs(old_dir - f_dir);
		if (diff > 1)
			f_dir = old_dir - sign(old_dir - f_dir);
	}

	if (((old_dir != f_dir) || (old_pose != f_pose)) && (time >= self.frame_nextcheck))
	{
		self.frame_nextcheck = time + shepherd_blendtime;

		self.lerpfrac = 1;
		self.frame2 = self.frame;
		self.frame = (f_pose * shepherd_positions) + f_dir;

		if (old_pose != f_pose) // new pose, so new anim time
		{
			self.frame2time = self.frame1time;
			self.frame1time = time;
		}
	}
	
	if (self.lerpfrac > 0)
	{
		self.lerpfrac -= frametime * (1 / shepherd_blendtime);
		self.lerpfrac = max(0, self.lerpfrac);
	}


	#if 0 // Reki (October 11 2023): Ethereal effect
	vector o_org = self.origin;
	vector o_col = self.colormod;
	float o_alph = self.alpha;
	float o_eff = self.effects;
	float o_scal = self.scale;

	makevectors(view_angles);

	self.effects = EF_ADDITIVE | EF_DOUBLESIDED;
	self.colormod = '0.3 0.5 0.8';
	self.alpha = 0.1;
	self.scale = 1.05;
	self.origin = o_org + (v_forward * 8) + (v_right * 0.5);
	addentity(self);

	self.origin = o_org + (v_forward * 16) + (v_right * -0.5);
	self.colormod = '0.8 0.5 0.3';
	addentity(self);

	self.origin = o_org;
	self.colormod = o_col;
	self.alpha = o_alph;
	self.effects = o_eff;
	self.scale = o_scal;
	#endif
}

void EntUpdate_place_shepherd(float is_new)
{
	float sendflags = ReadByte();
	
	if (sendflags & 0x01)
	{
		setorigin(self, ReadVectorL());
		self.angles = ReadVectorA();
	}

	if (sendflags & 0x02)
	{
		self.frame_dir = ReadShort();
		self.frame_pose = ReadShort();
		self.skin = ReadByte();
	}

	if (self.classname != "place_shepherd")
		is_new = TRUE;

	if (is_new)
	{
		self.classname = "place_shepherd";
		setmodel(self, "models/enemies/shepherd/shepherd.md3");
		//self.frame1time = time;
		self.alpha = 1;

		self.predraw = place_shepherd_predraw;
		self.drawmask = MASK_NORMAL;
	}
}

#endif

/* #endregion */











