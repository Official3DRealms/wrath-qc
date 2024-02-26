// Reki (May 12 2023)
// orrey.qc:
// code for animating the planetarium orrey in CSQC/SSQC
// to the modder reading this: I know this is all typo'd
//


#define ORREYMODE_STATIC	0
#define ORREYMODE_SPINUP	1
#define ORREYMODE_MOVING	2
#define ORREYMODE_SPINDOWN	3
#define ORREYMODE_READJUST	4
#define ORREY_MOMENTUM		10
#define ORREY_ACCELERATION	6
#define ORREY_DECCELERATION	1

.float orrey_momentum;
.float orrey_animtime;
.float orrey_spindown;
.float orrey_mode;
.float orrey_lastsimulated;
.float orrey_soundstarted;
.float scale;
void Orrey_Simulate()
{
	// state machine
	switch (self.orrey_mode)
	{
		case ORREYMODE_SPINUP:
		{
			if (self.orrey_momentum < ORREY_MOMENTUM)
			{
				self.orrey_momentum += frametime * ORREY_ACCELERATION;
				self.orrey_momentum = min(self.orrey_momentum, ORREY_MOMENTUM);
			}
			else
			{
				self.orrey_mode = ORREYMODE_MOVING;
			}
		} break;
		case ORREYMODE_MOVING:
		{
			if (self.orrey_momentum < ORREY_MOMENTUM)
			{
				self.orrey_momentum += frametime * ORREY_ACCELERATION;
				self.orrey_momentum = min(self.orrey_momentum, ORREY_MOMENTUM);
			}
			else if (self.orrey_momentum > ORREY_MOMENTUM)
			{
				self.orrey_momentum += frametime * ORREY_DECCELERATION;
				self.orrey_momentum = min(self.orrey_momentum, ORREY_MOMENTUM);
			}

			if (self.orrey_animtime > self.orrey_spindown)
				self.orrey_mode = ORREYMODE_SPINDOWN;
		} break;
		case ORREYMODE_SPINDOWN:
		{
			if (self.orrey_momentum > -0.5)
				self.orrey_momentum -= frametime * ORREY_ACCELERATION;
			else
				self.orrey_mode = ORREYMODE_READJUST;
		} break;
		case ORREYMODE_READJUST:
		{
			if (self.orrey_momentum < 0)
			{
				self.orrey_momentum += frametime * ORREY_DECCELERATION;
				self.orrey_momentum = min(0, self.orrey_momentum);
			}
			else
				self.orrey_mode = ORREYMODE_STATIC;
		}
	}

	self.orrey_animtime += (self.orrey_momentum * frametime) / ORREY_MOMENTUM;
}

#ifdef SSQC
float SendEntity_Orrey(entity to, float sendflags)
{
	WriteByte(MSG_ENTITY, ENT::ORREY);
	WriteByte(MSG_ENTITY, sendflags);

	if (sendflags & 0x01)
	{
		WriteVectorL(MSG_ENTITY, self.origin);
		WriteVectorA(MSG_ENTITY, self.angles);
	}

	if (sendflags & 0x02)
	{
		WriteByte(MSG_ENTITY, self.solid);
		WriteShort(MSG_ENTITY, self.modelindex);
		WriteCoord(MSG_ENTITY, self.scale);
	}

	if (sendflags & 0x04)
	{
		WriteByte(MSG_ENTITY, self.orrey_mode);
	}

	if (sendflags & 0x08)
	{
		WriteCoord(MSG_ENTITY, self.orrey_animtime);
		WriteCoord(MSG_ENTITY, self.orrey_momentum);
		WriteCoord(MSG_ENTITY, self.orrey_spindown);
	}

	if (sendflags & 0x10)
	{
		WriteCoord(MSG_ENTITY, self.orrey_soundstarted);
	}

	return TRUE;
}

void Orrey_Think()
{
	frametime = 0.025;
	Orrey_Simulate();
	self.frame1time = time - self.orrey_animtime;

	self.think = Orrey_Think;
	self.nextthink = time + 0.025;
}

void Orrey_Use()
{
	//soundwrath(self, CHAN_AUTO, "objects/orrery.ogg", 1, 0.25, 0, 0, 0.5);
	self.orrey_soundstarted = time;
	self.orrey_mode = ORREYMODE_SPINUP;
	self.orrey_spindown = self.orrey_animtime + 14;
	self.SendFlags |= 0x04 | 0x08 | 0x10;
}

void spawnfunc_object_orrery()
{
	precache_sound("objects/orrery.ogg");
	precache_model(self.model);

	self.use = Orrey_Use;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
	self.scale = self.modelscale;
	self.SendEntity = SendEntity_Orrey;

	self.think = Orrey_Think;
	self.nextthink = time + 0.1;
}
#endif

#ifdef CSQC
.float sound_length;
.float sound_playing;
.float sound_aggregateframe;
.float sound_aggregatetime;
.float sound_aggregatetimescale;
.float sound_timescale;
// mmmaaaabcdefgmmmmaaaammmaamm
static float orreyls_windup[] = {
	0.5,
	0.5,
	0.5,
	0.3,
	0.3,
	0.3,
	0.3,
	0.35,
	0.4,
	0.42,
	0.37,
	0.4,
	0.45,
	0.5,
	0.5,
	0.5,
	0.32,
	0.35,
	0.35,
	0.35,
	0.5,
	0.5,
	0.5,
	0.45,
	0.45,
	0.5,
	0.5,
}

static float orreyls_winddown[] = {
	0.5,
	0.2,
	0.5,
	0.5,
	0.2,
	0.5,
	0.5,
	0.3,
	0.2,
	0.3,
	0.1,
}

void Orrey_Predraw()
{
	Orrey_Simulate();
	
	static float ls_choice = 0;
	float glow = 0;

	self.sound_aggregateframe += frametime;
	if (cltime >= self.sound_aggregatetime) // this needs to be aggregate otherwise we run into high fps woes :(
	{
		if (self.sound_aggregateframe <= 0) // if we're paused, sound is nolonger playing!
		{
			if (self.sound_playing)
			{
				soundwrath(self, CHAN_VOICE, "misc/null.wav", 1, 0.25, 0, 0, 0.5); // stop the sound
			}
			self.sound_playing = FALSE;
		}
		else if (self.orrey_mode != ORREYMODE_STATIC)
		{
			if ((!self.sound_playing) || (self.sound_timescale != self.sound_aggregatetimescale))
			{
				if (self.orrey_soundstarted)
				{
					self.sound_timescale = getstatf(STAT_MOVEVARS_TIMESCALE);
					self.sound_playing = TRUE;
					float ptchmod = 100 * self.sound_timescale;

					sound_starttime = self.orrey_soundstarted;
					if (fabs(time - sound_starttime) < 0.1) // 100ms grace period, to prevent some crackling
						sound_starttime = 0;
					soundwrath(self, CHAN_VOICE, "objects/orrery.ogg", 1, 0.25, ptchmod, 0, 0.5); // stop the sound
					sound_starttime = 0;
				}
			}
		}
		else
		{
			// HACK: Reki (January 11 2024): technically this can lead to a bug if you go slowmo at
			// exactly the right time while the orrery is stopping.
			self.sound_playing = FALSE;
		}

		self.sound_aggregatetimescale = getstatf(STAT_MOVEVARS_TIMESCALE);
		self.sound_aggregatetime = cltime + 0.1;
		self.sound_aggregateframe = 0;
	}

	if (self.orrey_momentum > 0)
	{
		static float new_glow = 0;
		static float old_glow = 0;
		float falter = 0;
		float old_choice = ls_choice;
		
		if (self.orrey_mode == ORREYMODE_SPINDOWN || self.orrey_mode == ORREYMODE_READJUST)
			falter = 1;

		if (falter)
			ls_choice += (frametime * 13); // running out of juice
		else
			ls_choice += (frametime * 8); // normal operation

		if (floor(old_choice) != floor(ls_choice))
		{
			old_glow = new_glow;
			if (falter)
				new_glow = orreyls_winddown[floor(ls_choice) % orreyls_winddown.length];
			else
				new_glow = orreyls_windup[floor(ls_choice) % orreyls_windup.length];
		}

		glow = lerp(old_glow, new_glow, ls_choice - floor(ls_choice));
		glow *= (self.orrey_momentum / ORREY_MOMENTUM);
	}

	self.glowmod_x = max(0.0001, glow);
	//self.glowmod_x = max(0.001, ((self.orrey_momentum / ORREY_MOMENTUM) * 0.7) + (sin(self.orrey_animtime * 2) * (self.orrey_momentum / ORREY_MOMENTUM) * 0.05));
	self.glowmod_y = self.glowmod_z = self.glowmod_x;

	self.frame1time = time - self.orrey_animtime;
}

void EntUpdate_Orrey(float is_new)
{
	float sendflags = ReadByte();

	if (sendflags & 0x01)
	{
		setorigin(self, ReadVectorL());
		self.angles = ReadVectorA();
	}

	if (sendflags & 0x02)
	{
		self.solid = ReadByte();
		setmodelindex(self, ReadShort());
		self.scale = ReadCoord();
	}

	if (sendflags & 0x04)
	{
		self.orrey_mode = ReadByte();
		//if (self.orrey_mode == ORREYMODE_SPINUP)
		//	self.orrey_spindown = self.orrey_animtime + 14;
	}

	if (sendflags & 0x08)
	{
		self.orrey_animtime = ReadCoord();
		self.orrey_momentum = ReadCoord();
		self.orrey_spindown = ReadCoord();
	}

	if (sendflags & 0x10)
	{
		self.orrey_soundstarted = ReadCoord();
	}

	if (self.classname != "orrery")
		is_new = TRUE;

	if (is_new)
	{
		self.classname = "orrery";
		self.predraw = Orrey_Predraw;
		self.drawmask = MASK_ENGINE;
		self.sound_length = soundlength("objects/orrery.ogg");
		self.sound_playing = FALSE;
	}
}
#endif




