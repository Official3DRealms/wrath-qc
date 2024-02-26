.float atten;
.float maxpitch;
.float minpitch;
.float pitch;


.float chan8_vol;
.float chan9_vol;

.float chan8_smooth_vol;
.float chan9_smooth_vol;


.float pl_chan32_vol;
.float pl_chan8_smooth_vol;


.float smoothsound_finished;

//Fade-in 0.3
//Fade out 0.2
void() UpdateChannelsVolume = 
{

	if (time > self.smoothsound_finished)
	{
		if(self.soundfade ==  1)
		{
			if(self.pl_chan32_vol  <= 1)
				self.pl_chan32_vol += 0.0833;	
			if(self.pl_chan32_vol  >= 1)
				self.soundfade = 0;

			stuffcmd(self,strcat( "set snd_channel32volume ", ftos(self.pl_chan32_vol), "\n"));
			self.smoothsound_finished =  time + 0.025;
		}
		if(self.soundfade ==  2)
		{
			if(self.pl_chan32_vol  > 0.05)
				self.pl_chan32_vol -= 0.125;	
			if(self.pl_chan32_vol <= 0.125)
			{
				self.pl_chan32_vol = 0;	
				self.soundfade = 0;
				sound7(self,CHAN_WEAPONFADE,"misc/null.wav",1,0.25,100,0);
			}	
			stuffcmd(self,strcat( "set snd_channel32volume ", ftos(self.pl_chan32_vol), "\n"));
			self.smoothsound_finished =  time + 0.025;
		}


		if(self.soundfade ==  3)
		{
			if(self.pl_chan32_vol  > 0.05)
				self.pl_chan32_vol -= 0.125;	
			if(self.pl_chan32_vol <= 0.125)
			{
				self.pl_chan32_vol = 0;	
				self.soundfade = 2;
				sound7(self,CHAN_WEAPONFADE,"misc/null.wav",1,0.25,100,0);
			}	
			stuffcmd(self,strcat( "set snd_channel32volume ", ftos(self.pl_chan32_vol), "\n"));
			self.smoothsound_finished =  time + 0.025;
		}

	}



	if (time > self.interior_time + 1.5)
		return;	

	if (time < self.interior_time)
	{
		self.chan8_vol = 1;
		self.chan9_vol = 0.1;
	}	

	if (time > self.interior_time)
	{
		self.chan8_vol = 0.1;
		self.chan9_vol = 1;
	}	

	if (time > self.smoothsound_finished)
	{
		if(self.chan8_vol  != self.chan8_smooth_vol)
		{
			if(self.chan8_vol  > self.chan8_smooth_vol)
				self.chan8_smooth_vol += 0.05;	
			if(self.chan8_vol  < self.chan8_smooth_vol)
				self.chan8_smooth_vol -= 0.05;	
			stuffcmd(self,strcat( "set snd_channel8volume ", ftos(self.chan8_smooth_vol), "\n"));
			self.smoothsound_finished =  time + 0.05;
		}
		if(self.chan9_vol  != self.chan9_smooth_vol)
		{
			if(self.chan9_vol  > self.chan9_smooth_vol)
				self.chan9_smooth_vol += 0.05;	
			if(self.chan9_vol  < self.chan9_smooth_vol)
				self.chan9_smooth_vol -= 0.05;	
			stuffcmd(self,strcat( "set snd_channel9volume ", ftos(self.chan9_smooth_vol), "\n"));
			self.smoothsound_finished =  time + 0.05;
		}
	}
};

.float channel;
void() play_ambient_sound =
{
	//self.cnt = soundlength(self.noise);
	self.volume = self.volume * 0.7;
	sound7(self, self.channel, self.noise, self.volume, self.atten,100,self.sound7flags);
	//self.think = play_ambient_sound;
	//self.nextthink = time + self.cnt;
	//sound(self, self.channel, self.noise, 1, 0.125);
};



void() trigger_interior_touch =
{
	if(other.classname == "player")
		other.interior_time = time + 0.1;	
};

void() trigger_interior =
{

	InitTrigger ();
	self.touch = trigger_interior_touch;
	
};
.float mindelay;
.float maxdelay;
.float rad_sound_inner;
.float trapezoid_sound;
void() soundbox_think;
void() soundbox_stop = 
{
	self.using = -1;
	 if (self.count)
		sound7(self, CHAN_VOICE, "misc/null.wav", 1, 1, 100, 0);
	else
	{
		sound7(self, CHAN_VOICE, "misc/null.wav", 1, 1, 100, 0);
		remove(self);
	}

	self.use = soundbox_think;
};

void() soundbox_think = { 

	self.using = 1;
	local float spitch;
	self.cnt = soundlength(self.noise);
	if ((self.pitch) || (self.minpitch && self.maxpitch))
	{
		spitch = self.pitch * 100;
		if (self.minpitch && self.maxpitch)
		{
			spitch = (self.minpitch + self.maxpitch* random()) *100;
			self.cnt = self.cnt *(100 / spitch);
		}

		self.count = 1;
		soundwrath(self, CHAN_VOICE, self.noise, self.volume, self.atten, spitch, self.sound7flags,self.trapezoid_sound);
	}
	else	
		soundwrath(self, CHAN_VOICE, self.noise, self.volume, self.atten,100,self.sound7flags,self.trapezoid_sound);
	if (self.delay > 0)
	{
		self.think = soundbox_think;
		self.nextthink = time + self.cnt + self.wait + (random() *self.delay);
		self.use = soundbox_stop;
	}
	if (self.delay == -2)
	{
		self.think = soundbox_think;
		self.nextthink = time + self.cnt;
		self.use = soundbox_stop;
	}	
	if ((self.delay == -1) && (!(self.spawnflags & 4)))
		remove(self);
};




void() soundbox_think_wait =
{
	self.think = soundbox_think;
	self.nextthink = time + self.wait;
	
};

float testsoundrad;
float testsoundvolume;
string testsoundnoise;


void() testsound_frik =
{
	local float readparms;
	local float readfrik;

	local string readtext;
	readparms = fopen("map/test_sound.txt", FALSE);
	readtext = fgets(readfrik);
	testsoundrad = stof(readtext);
	readtext = fgets(readfrik);
	testsoundvolume = stof(readtext);
	readtext = fgets(readfrik);
	testsoundnoise = strzone(readtext);
	fclose(readparms);
};



void() Test_Sound =
{
	if(self.testsoundflag == 1)
		return;


	//entity(entity start, .string fld, string match) find = #18;
	entity soundbbox = find(world,targetname,"hasdas");
	soundbbox.effects = EF_MUZZLEFLASH;
	soundbbox.think = soundbox_think;
	soundbbox.nextthink = time;
	self.testsoundflag = 1;
};


.float showsphere;
void() soundbox_visible_toggle = 
{
		if(self.ammo_shotgun == 1)
		{
			self.ammo_shotgun = 0;
			self.pipes.effects = EF_NODRAW;
			self.vgear.effects = EF_NODRAW;
			self.msprite.effects = EF_NODRAW;
			self.pipes.pipes.colormod = '0 0.1 0';
			centerprint(single_player,"\n");			
			return;
		}
		else
		{
			self.ammo_shotgun = 1;
			self.vgear.effects = 512 + EF_ADDITIVE +  EF_DOUBLESIDED + EF_NODEPTHTEST;
			self.pipes.effects = 512 + EF_ADDITIVE +  EF_DOUBLESIDED;
			self.msprite.effects = 512 + EF_ADDITIVE +  EF_DOUBLESIDED;
			self.pipes.pipes.colormod = '1 1 1';
			centerprint(single_player, strcat("soundfile: ",self.owner.noise,"\n\n"," radius: ",ftos(self.owner.rad_sound),"\n"));
			//centerprint(, ("playing a noqcprecached game\n"));
			return;
		}

};
void() randomsoundbox_think = 
{ 

	float r = ceil(random(0,self.count));
	string snoise;
	if(r == self.jmpsound)
		r ++;
	if(r >self.count)
		r = 1;

	if( r == 1)
		snoise = self.noise1;
	if( r == 2)
		snoise = self.noise2;
	if( r == 3)
		snoise = self.noise3;
	if( r == 4)
		snoise = self.noise4;
	if( r == 5)
		snoise = self.noise5;
	if( r == 6)
		snoise = self.noise6;
	if( r == 7)
		snoise = self.noise7;
	if( r == 8)
		snoise = self.noise8;
	if( r == 9)
		snoise = self.noise9;
	if( r == 10)
		snoise = self.noise10;
	if( r == 11)
		snoise = self.noise11;
	if( r == 12)
		snoise = self.noise12;
	if( r == 13)
		snoise = self.noise13;
	if( r == 14)
		snoise = self.noise14;
	if( r == 15)
		snoise = self.noise15;

	self.jmpsound = r;
	self.cnt = soundlength(snoise);
	self.noise = snoise;
	soundwrath(self, CHAN_AUTO, snoise, self.volume, self.atten,100, self.sound7flags,self.trapezoid_sound);
	self.wait = self.cnt + random(self.mindelay,self.maxdelay); 
	self.think = randomsoundbox_think;
	vector vec = normalize((rorigin(single_player) - rorigin(self)));
	self.angles = vectoangles(vec);
	//string viewxanglesfactor = strcat (self.noise,"\n");
	float dev = cvar("showsoundspheres");
	if (dev == 1)
	pointparticles(particleeffectnum("sounduse"), self.origin, '0 0 0', 1);
	//bprint (viewxanglesfactor);
	self.nextthink = time +  self.wait;
}

string random_sound_from_noise_fields(entity e);
void() randomsoundbox =
{
	if (self.noise1)
		{precache_sound(self.noise1); self.count = 1;}
	if (self.noise2)
		{precache_sound(self.noise2); if(self.count == 1) self.count = 2;}
	if (self.noise3)
		{precache_sound(self.noise3); if(self.count == 2) self.count = 3;}
	if (self.noise4)
		{precache_sound(self.noise4); if(self.count == 3) self.count = 4;}
	if (self.noise5)
		{precache_sound(self.noise5); if(self.count == 4) self.count = 5;}
	if (self.noise6)
		{precache_sound(self.noise6); if(self.count == 5) self.count = 6;}
	if (self.noise7)
		{precache_sound(self.noise7); if(self.count == 6) self.count = 7;}
	if (self.noise8)
		{precache_sound(self.noise8); if(self.count == 7) self.count = 8;}
	if (self.noise9)
		{precache_sound(self.noise9); if(self.count == 8) self.count = 9;}
	if (self.noise10)
		{precache_sound(self.noise10); if(self.count == 9) self.count = 10;}
	if (self.noise11)
		{precache_sound(self.noise11); if(self.count == 10) self.count = 11;}
	if (self.noise12)
		{precache_sound(self.noise12); if(self.count == 11) self.count = 12;}
	if (self.noise13)
		{precache_sound(self.noise13); if(self.count == 12) self.count = 13;}
	if (self.noise14)
		{precache_sound(self.noise14); if(self.count == 13) self.count = 14;}
	if (self.noise15)
		{precache_sound(self.noise15); if(self.count == 14) self.count = 15;}
	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;

   if(!(self.rad_sound_inner))
    {
        self.rad_sound_inner = 0;
        self.trapezoid_sound = 0;
    }
    else
    {
        self.rad_sound += self.rad_sound_inner;
        self.trapezoid_sound = self.rad_sound_inner / self.rad_sound;
    }

	attn = 512 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	if (self.spawnflags &32)
		self.sound7flags += 32;
	self.atten = attn;



	float dev = cvar("showsoundspheres");
	if (dev == 1)
	{
		entity visible_sound = spawn();
		visible_sound.origin = self.origin;
		visible_sound.alpha = 0.25;
		visible_sound.effects = EF_NODRAW;
	
		if(self.rad_sound >= 1024)
		{
			setmodel(visible_sound,"models/dev/spherebig.md3");
			visible_sound.scale = self.rad_sound  / 192;
		}
		else
		{		
			setmodel(visible_sound,"models/dev/sphere.md3");
			visible_sound.scale = self.rad_sound  / 128;
		}

		//self.alpha = -1;
		entity speaker_icon = spawn();	
		visible_sound.colormod = '0.5 0.5 1';
		speaker_icon.colormod = '0 0.1 0';
		if ((self.targetname) && (self.using))
			speaker_icon.colormod = '0.2 0.2 1';
		if ((self.targetname) && (!self.using))
			speaker_icon.colormod = '1 0 0';
		if (world.model == "maps/testsound.bsp")
			speaker_icon.colormod = '1 1 0';
		speaker_icon.origin = self.origin;
		setmodel(speaker_icon, "particles/impact/impact_oppressor6.md3");
		speaker_icon.scale = 0.7;
		entity sself = spawn();
		sself.owner = self;
		sself.origin = self.origin;
		sself.classname = "ssoundbox";
		setmodel(sself, "models/dev/collisionbox.md3");
		setsize (sself,'-8 -8 -8','8 8 8');

		if(self.rad_sound_inner > 0)
		{
			entity visible_innersound = spawn();
			visible_innersound.origin = self.origin;
			visible_innersound.alpha = 0.25;
			visible_innersound.effects = EF_NODRAW;
			if(self.rad_sound_inner >= 1024)
			{
				setmodel(visible_innersound,"models/dev/spherebig.md3");
				visible_innersound.scale = self.rad_sound_inner  / 192;
			}
			else
			{		
				setmodel(visible_innersound,"models/dev/sphere.md3");
				visible_innersound.scale = self.rad_sound_inner  / 128;
			}

			visible_innersound.colormod = '1 0 1';
			self.msprite = visible_innersound;
		}
		sself.solid = SOLID_TRIGGER;
		sself.usable = 1;
		sself.pipes = visible_sound;
		sself.pipes.pipes = speaker_icon;
			entity visible_sound2 = spawn();
			sself.vgear = visible_sound2;
			visible_sound2.origin = self.origin;
			visible_sound2.alpha = 0.075;
			visible_sound2.effects = EF_NODRAW; //
			if(self.rad_sound >= 1024)
				setmodel(visible_sound2,"models/dev/spherebig.md3");
			else
				setmodel(visible_sound2,"models/dev/sphere.md3");
			visible_sound2.scale = visible_sound.scale;
			visible_sound2.colormod = '0.5 0.5 1';
	}	

	self.think = randomsoundbox_think; 
	self.nextthink = time + 0.25;
};


void() soundbox = 
{

	if(world.model == "maps/testsound.bsp")
		testsound_frik();
	if (self.noise)
		precache_sound(self.noise);

	/*random_sound_from_noise_fields(self);
	if (self.noise1)
		precache_sound(self.noise1);
	if (self.noise2)
		precache_sound(self.noise2);
	if (self.noise3)
		precache_sound(self.noise3);
	if (self.noise4)
		precache_sound(self.noise4);
	if (self.noise5)
		precache_sound(self.noise5);
	if (self.noise6)
		precache_sound(self.noise6);
	if (self.noise7)
		precache_sound(self.noise7); 
	if (self.noise8)
		precache_sound(self.noise8); 
	if (self.noise9)
		precache_sound(self.noise9); 
	if (self.noise10)
		precache_sound(self.noise10);
	if (self.noise11)
		precache_sound(self.noise11);
	if (self.noise12)
		precache_sound(self.noise12);
	if (self.noise13)
		precache_sound(self.noise13);
	if (self.noise14)
		precache_sound(self.noise14);
	if (self.noise15)
		precache_sound(self.noise15);
	if (self.noise15)
		precache_sound(self.noise15);
	if (self.noise16)
		precache_sound(self.noise16);
	if (self.noise17)
		precache_sound(self.noise17);
	if (self.noise18)
		precache_sound(self.noise18);
	if (self.noise19)
		precache_sound(self.noise19);
	if (self.noise20)
		precache_sound(self.noise20);
    */

	if (!self.delay)
	{
		self.delay = -1;
	}


	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	if(world.model == "maps/testsound.bsp")
	{
		self.rad_sound = testsoundrad;
		self.volume = testsoundvolume;
		self.using = 1;
		self.noise = testsoundnoise;
		self.targetname = "hasdas";
		self.delay = -0.1;
	}
	
 	if(!(self.rad_sound_inner))
    {
        self.rad_sound_inner = 0;
        self.trapezoid_sound = 0;
    }
    else
    {
        self.rad_sound += self.rad_sound_inner;
        self.trapezoid_sound = self.rad_sound_inner / self.rad_sound;
    }

	attn = 512 / self.rad_sound;	// 512 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	if (self.spawnflags &1)
		attn = 0;
	if (self.spawnflags &2)
		self.sound7flags += 2;
	if (self.spawnflags &32)
		self.sound7flags += 32;

	if (self.minpitch <= 0)
		self.minpitch = 0.1;
	self.atten = attn;



	float dev = cvar("showsoundspheres");
	if ((dev == 1) || (world.model == "maps/testsound.bsp"))
	{
		entity visible_sound = spawn();
		visible_sound.origin = self.origin;
		visible_sound.alpha = 0.25;
		if (world.model != "maps/testsound.bsp")
			visible_sound.effects = EF_NODRAW;
		else
			visible_sound.effects = 512 + EF_ADDITIVE +  EF_DOUBLESIDED;
	
		if(self.rad_sound >= 1024)
		{
			setmodel(visible_sound,"models/dev/spherebig.md3");
			visible_sound.scale = self.rad_sound  / 192;
		}
		else
		{		
			setmodel(visible_sound,"models/dev/sphere.md3");
			visible_sound.scale = self.rad_sound  / 128;
		}

		//self.alpha = -1;
		entity speaker_icon = spawn();	
		visible_sound.colormod = '0.5 0.5 1';
		speaker_icon.colormod = '0 0.1 0';
		if ((self.targetname) && (self.using))
			speaker_icon.colormod = '0.2 0.2 1';
		if ((self.targetname) && (!self.using))
			speaker_icon.colormod = '1 0 0';
		if (world.model == "maps/testsound.bsp")
			speaker_icon.colormod = '1 1 0';
		speaker_icon.origin = self.origin;
		setmodel(speaker_icon, "particles/impact/impact_oppressor6.md3");
		speaker_icon.scale = 0.7;

		if(self.rad_sound_inner > 0)
		{
			entity visible_innersound = spawn();
			visible_innersound.origin = self.origin;
			visible_innersound.alpha = 0.25;
			visible_innersound.effects = EF_NODRAW;
			if(self.rad_sound_inner >= 1024)
			{
				setmodel(visible_innersound,"models/dev/spherebig.md3");
				visible_innersound.scale = self.rad_sound_inner  / 192;
			}
			else
			{		
				setmodel(visible_innersound,"models/dev/sphere.md3");
				visible_innersound.scale = self.rad_sound_inner  / 128;
			}

			visible_innersound.colormod = '1 0 1';
			self.msprite = visible_innersound;
		}

		entity sself = spawn();
		sself.owner = self;
		sself.origin = self.origin;
		sself.classname = "ssoundbox";
		setmodel(sself, "models/dev/collisionbox.md3");
		setsize (sself,'-8 -8 -8','8 8 8');
		sself.solid = SOLID_TRIGGER;
		if (world.model != "maps/testsound.bsp")
			sself.usable = 1;
		sself.pipes = visible_sound;
		sself.pipes.pipes = speaker_icon;

		if (world.model != "maps/testsound.bsp")
		{
			entity visible_sound2 = spawn();
			sself.vgear = visible_sound2;
			visible_sound2.origin = self.origin;
			visible_sound2.alpha = 0.075;
			visible_sound2.effects = EF_NODRAW; //
			if(self.rad_sound >= 1024)
				setmodel(visible_sound2,"models/dev/spherebig.md3");
			else
				setmodel(visible_sound2,"models/dev/sphere.md3");
			visible_sound2.scale = visible_sound.scale;
			visible_sound2.colormod = '0.5 0.5 1';
		}

	}	

	if ((self.targetname) && (!self.using))
	{
		if(self.wait)
			self.use = soundbox_think_wait;
		else
			self.use = soundbox_think;

	}
	else
	{
		if (self.delay >= 0)
		{
			if (!self.wait)
				self.wait = 1;
			//self.think = soundbox_think;
			//self.nextthink = time + random(1,2);
			return;
		}
		else
			{
	
				if(world.model == "maps/testsound.bsp")
					return;
				if(((self.interior == 1) || (self.interior == -1)) || (self.sound7flags > 0))
				{
					self.using = 2;

					if((self.interior == 1) || (self.interior == -1))		
					{
						if(self.interior == 1)
						self.channel = 8;
						if(self.interior == -1)
						self.channel = 9;
						//self.nextthink = time + 1;
					}
					else 
					{
						self.channel = CHAN_AUTO;
						if((self.spawnflags & 34) == 34)
						{
							//self.think = play_ambient_sound;
							//self.nextthink = time + 3 + random();
							return;
						}
						//self.nextthink = time + 0.5;
					}
					
					//self.think = play_ambient_sound;
					return;
				}
				else	
					ambientsound(self.origin, self.noise, self.volume, attn);
			}
	}
};

void soundbox_initializeambients(void)
{
	for(entity loopedsound = findchain(::classname, "soundbox"); loopedsound; loopedsound = loopedsound.chain)
	{
		if ((loopedsound.interior == 1) || (loopedsound.interior == -1))
		{			
			loopedsound.think = play_ambient_sound;
			loopedsound.nextthink = time + 0.5;
		}
		if ((loopedsound.using == 2) && (loopedsound.sound7flags &  2))
		{			
			loopedsound.think = play_ambient_sound;
			loopedsound.nextthink = time + 0.5;
		}
		if ((loopedsound.using == 1) && (loopedsound.sound7flags &  2))
		{			
			loopedsound.think = soundbox_think;
			loopedsound.nextthink = time + 0.5;
		}
	}
}

.float attacksoundtime;
.float attacksnd2;
.float chatter_time;
.float chattersnd2;
.float msound_cnt1;
.float msound_cnt2;
.float msound_cnt3;
.float msound_cnt4;
.float msound_cnt5;
.float msound_cnt6;
void(entity e, float chan, string samp, float vol, float attenn) msound =
{
	if(attenn <= 0)
	{
		sound(e, chan, samp, vol, attenn);
		return;
	}
	float radsound = 512* (1/ attenn);	// 512 for snd_soundradius default cvar!
	radsound += 200;
	float trapezoidrad = 200 / radsound;
	attenn = 512 / radsound;
	soundwrath(e, chan, samp, vol, attenn,100,0,trapezoidrad);
};
void(entity e, float chan, string samp, float vol, float attenn,float spitch,float sflags) msound7 =
{
	if(attenn <= 0)
	{
		sound7(e, chan, samp, vol, attenn, spitch,0);
		return;
	}

	float radsound = 512* (1/ attenn);	// 512 for snd_soundradius default cvar!
	radsound += 200;
	float trapezoidrad = 200 / radsound;
	attenn = 512 / radsound;
	soundwrath(e, chan, samp, vol, attenn,spitch,sflags,trapezoidrad);
};

void(string locsound) painsound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * FL_SWIM)) + TRUE;
	if ((r == self.painsnd))
	{
		r = r + 1;
	}

	if(self.classname == "monster_symbol")
	{
		if (r > 5)
			r = 1;		
	}
	else
	{
		if (r > 3)
			r = 1;
	}

	self.painsnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, FL_SWIM, monstersound, TRUE, 0.25);
};

void(string locsound) attacksound =
{
	local float r;
	local string monstersound;
	local string rsound;

	if ((self.attacksoundtime > time))
	{
		return;
	}
	r = floor((random() * FL_SWIM)) + TRUE;
	if ((r == self.attacksnd))
	{
		r = r + TRUE;
	}
	if ((r > MOVETYPE_WALK))
	{
		r = TRUE;
	}
	self.attacksnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, TRUE, monstersound, TRUE, 0.25);
};

void(string locsound) attacksound2 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * FL_SWIM)) + TRUE;
	if ((r == self.attacksnd2))
	{
		r = r + TRUE;
	}
	if ((r > MOVETYPE_WALK))
	{
		r = TRUE;
	}
	self.attacksnd2 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, FL_SWIM, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd) walksound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	if ((self.classname == "monster_widow"))
	{
		msound(self, 4, monstersound, 0.5, 0.5);
	}
	else
	{
		msound(self, 4, monstersound, TRUE, 0.25);
	}
};

void(string locsound, float rnd) bosswalksound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");

	soundwrath(self, CHAN_AUTO, monstersound, 1, 0.25,70,0,0.3);


};
void(string locsound, float rnd, float vol) chattersound2 =
{
	local float r;
	local string monstersound;
	local string rsound;

	if ((self.chatter_time > time))
	{
		return;
	}
	if (!vol)
	{
		vol = TRUE;
	}
	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd2))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd2 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	self.chatter_time = (time + soundlength(monstersound));
	if ((self.classname == "monster_fallen"))
	{
		self.chatter_time = (((time + soundlength(monstersound)) + MOVETYPE_FLY) + (random() * MOVETYPE_FLY));
	}
	if ((self.classname == "monster_widow"))
	{
		self.chatter_time = (((time + soundlength(monstersound)) + MOVETYPE_FLY) + (random() * MOVETYPE_FLY));
	}
	if ((vol == 0.5))
	{
		msound(self, FL_SWIM, monstersound, vol, 0.5);
	}
	else
	{
		msound(self, FL_SWIM, monstersound, vol, 0.25);
	}
};

void(string locsound, float rnd, float vol) chattersound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	if ((vol == 0.5))
	{
		msound(self, FALSE, monstersound, TRUE, 0.5);
	}
	else
	{
		msound(self, FALSE, monstersound, TRUE, 0.25);
	}
};

void(string locsound, float rnd, float vol) randomsound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt1 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, FALSE, monstersound, vol, 0.5);
};

void(string locsound, float rnd, float vol,float pitch) randomsound7 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt1 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound7(self,CHAN_WEAPON,monstersound,vol,0.25,pitch,0);
};
//void(entity e, float chan, string samp, float vol, float attenn,float spitch,float sflags) msound7 =

.float rdmsound_cnt1;
void(vector org, string locsound, float rnd, float vol) randompointsound =
{
	local float r;
	local string samplesound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.rdmsound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.rdmsound_cnt1 = r;
	rsound = ftos(r);
	samplesound = strcat(locsound, rsound, ".ogg");
	pointsound(org, samplesound, vol, 0.25);
};
void(vector org,string locsound, float rnd, float vol, float sspeed) randompointsound7 =
{
	local float r;
	local string samplesound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.rdmsound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.rdmsound_cnt1 = r;
	rsound = ftos(r);
	samplesound = strcat(locsound, rsound, ".ogg");

	entity sound_emitter = spawn();
	sound_emitter.origin = org;
	//	void(entity e, float chan, string samp, float vol, float atten, float speed, float flags) sound7 = #8;
	//pointsound(org, samplesound, vol, 0.25);
	sound7(sound_emitter, CHAN_AUTO,samplesound,vol,0.25,sspeed,0);
	remove(sound_emitter);
};

void(string locsound, float rnd, float vol, float nchannel, float iswav, float atten) randomsound2 =
{
	local float r;
	local string soundend;
	local string lsound;
	local string rsound;

	if (iswav)
	{
		soundend = ".wav";
	}
	else
	{
		soundend = ".ogg";
	}
	r = floor((random() * rnd)) + TRUE;
	if ((r == self.rsound_cntr))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.rsound_cntr = r;
	rsound = ftos(r);
	lsound = strcat(locsound, rsound, soundend);
	sound(self, nchannel, lsound, vol, atten);
};

void(string locsound, float vol, float nchannel, float iswav, float atten) alreadyrandomsound2 =
{
	local string soundend;
	local string lsound;
	local string rsound;

	if (iswav)
	{
		soundend = ".wav";
	}
	else
	{
		soundend = ".ogg";
	}
	rsound = ftos(self.rsound_cntr);
	lsound = strcat(locsound, rsound, soundend);
	sound(self, nchannel, lsound, vol, atten);
};


void(string locsound, float rnd, float nchannel, float volume) monstersounda =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + 1;
	if ((r == self.msound_cnt1))
		r = r + 1;
	if (r > rnd)
		r = 1;
	self.msound_cnt1 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, volume, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound1 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt1 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	if ((self.classname == "monster_fallen"))
	{
		msound(self, nchannel, monstersound, 0.3, 0.25);
	}
	else
	{
		msound(self, nchannel, monstersound, TRUE, 0.25);
	}
};

void(string locsound, float rnd, float nchannel) monstersound2 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt2))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt2 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound3 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt3))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt3 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound4 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt4))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt4 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound5 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt5))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt5 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound6 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt6))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt6 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

.float shoot_sound;
.float sound_time;
void(string locsound, float rnd) weapon_sound =
{
	float r = floor(random() * rnd) + 1;
	if (r == self.shoot_sound)
		r = r + 1;
	if (r > rnd)
		r = 1;
	self.shoot_sound = r;
	string rsound = ftos(r);
	string weapon_sound = strcat(locsound, rsound, ".ogg");
	float current_sound_time = time + soundlength(weapon_sound);
	self.sound_time = current_sound_time;
	if(self.sound_time > time)
	{
		msound(self, CHAN_AUTO, weapon_sound, TRUE, 0.25);
	//	self.sound_time = 0;
	}
	else
		msound(self, CHAN_WEAPON, weapon_sound, TRUE, 0.25);
	
};

// Reki (September 4 2023): Precache all entity noise fields
void precache_noise_fields(entity e)
{
	.string fields[] = {noise, noise1, noise2, noise3, noise4, noise5, noise6, noise7, noise8, noise9, noise10, noise11, noise12, noise13, noise14, noise15, noise16, noise17, noise18, noise19, noise20};
	for(float i = 0; i < fields.length; i++)
	{
		.string fld = fields[i];
		if (!e.fld)
			continue;

		if (e.fld)
			precache_sound(e.fld);
	}
}

// Reki (August 21 2023): Poll sound from any noise field randomly
string random_sound_from_noise_fields(entity e)
{
	.string fields[] = {noise, noise1, noise2, noise3, noise4, noise5, noise6, noise7, noise8, noise9, noise10, noise11, noise12, noise13, noise14, noise15, noise16, noise17, noise18, noise19, noise20};
	.string selection_fields[fields.length];
	float selection_seek = 0;

	for(float i = 0; i < fields.length; i++)
	{
		.string fld = fields[i];
		if (!e.fld)
			continue;
		selection_fields[selection_seek] = fld;
		selection_seek++;
	}

	if (selection_seek <= 0)
		return 0;

	float rnd = bound(0, floor(random(0, selection_seek)), selection_seek - 1);
	return e.fields[rnd];
}

void sound_point_use(void)
{
	if (time < self.pain_finished)
		return;

	string snd = random_sound_from_noise_fields(self);
	float chan = CHAN_AUTO;
	if (self.spawnflags & 1)
		chan = CHAN_VOICE;
	sound(self, chan, snd, self.volume, self.atten);
	self.pain_finished = time + self.wait;
}

void spawnfunc_sound_point(void)
{
	if (!self.noise || !self.targetname)
	{
		remove(self);
		return;
	}

	if (!self.wait)
		self.wait = 0.1;
	if (!self.volume)
		self.volume = 1;
	if (!self.atten)
		self.atten = ATTN_NORM;
	else if (self.atten < 0)
		self.atten = ATTN_NONE;

	self.use = sound_point_use;
}

/////////////////end of qc file
