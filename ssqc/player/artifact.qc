/*		self.LifeSiphon += 1;
		self.TrinketofRespite += 1;
		self.Attar += 1;
		self.Aegis += 1;
		self.flaskrage += 1;
		self.DrownerApp += 1;
		self.MarkRevelation +=1;
		self.BlackGrenade +=1;
		self.ViciousIdol +=1;
		self.ShockWave +=1;*/
.float aegisflag;
void() nextartifact = 
{
	float cr = self.radialactive;
	while(1)
	{
		if((self.MarkRevelation) && ( cr < 1))
		{	
			self.radialactive = 1;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.DrownerApp) && ( cr < 2))
		{	
			self.radialactive = 2;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.flaskrage)&& ( cr < 3))
		{	
			self.radialactive = 3;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.Attar)&& ( cr < 4))
		{	
			self.radialactive = 4;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.BlackGrenade)&& ( cr < 5))
		{	
			self.radialactive = 5;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.LifeSiphon)&& ( cr < 6))
		{	
			self.radialactive = 6;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.TrinketofRespite)&& ( cr < 7))
		{	
			self.radialactive = 7;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.Aegis)&& ( cr < 8))
		{	
			self.radialactive = 8;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.ViciousIdol)&& ( cr < 9))
		{	
			self.radialactive = 9;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if((self.ShockWave)&& ( cr < 10))
		{	
			self.radialactive = 10;stuffcmd(self, "pulseartifact\n");
			return;
		}
		if(cr == -1)
			return;
		else
			cr  = -1;
	}

};

void() prevtartifact = 
{
	float cr = self.radialactive;
	float equip;
	while(1)
	{
		if((self.ShockWave)&& ( cr > 10))
		{	
			self.radialactive = 10;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.ViciousIdol)&& ( cr > 9))
		{	
			self.radialactive = 9;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.Aegis)&& ( cr > 8))
		{	
			self.radialactive = 8;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.TrinketofRespite)&& ( cr > 7))
		{	
			self.radialactive = 7;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.LifeSiphon)&& ( cr > 6))
		{	
			self.radialactive = 6;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.BlackGrenade)&& ( cr > 5))
		{	
			self.radialactive = 5;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.Attar)&& ( cr > 4))
		{	
			self.radialactive = 4;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.flaskrage)&& ( cr > 3))
		{	
			self.radialactive = 3;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.DrownerApp) && ( cr > 2))
		{	
			self.radialactive = 2;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if((self.MarkRevelation) && ( cr > 1))
		{	
			self.radialactive = 1;stuffcmd(self, "pulseartifact\n"); equip = 1;
			return;
		}
		if(cr == 11)
			return;
		else
			cr  = 11;
	}



};

float tether;

vector tether_org;
string tether_map;
void(float n, vector a, entity ownr) Hud_message;
.float savedlist;

float SAVED_TETHER = 1;
float SAVED_SIGIL = 2;

void() Remove_Tether = { self.alpha -= 0.025;
	if (self.alpha <= 0)
		self.think = SUB_Remove;
	self.nextthink = time + 0.01;

};

void() tether_mark_think = { local float bparticle;
	bparticle = particleeffectnum("tetherparticle");
	if (tether > 1)
	{
		self.alpha = 1;
		tether = 1;
		pointparticles(bparticle, self.origin, '0 0 0', 1);
		self.think = Remove_Tether;
		self.nextthink = time + 0.01;
	}
	else
		self.think = tether_mark_think;
	self.nextthink = time + 0.1;
};

void() check_tether = { read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");

	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	tether = stof(readtext);
	readtext = fgets(readparms);
	tether_org_x = stof(readtext);
	readtext = fgets(readparms);
	tether_org_y = stof(readtext);
	readtext = fgets(readparms);
	tether_org_z = stof(readtext);
	readtext = fgets(readparms);
	tether_map = readtext;
	fclose(readparms);
	if (world.model != tether_map)
	{
		tether = 0;
		return;
	}

	local entity tether_mark;
	tether_mark = spawn();
	tether_mark.color = '1 1 1';
	tether_mark.light_lev = 75;
	tether_mark.pflags = 129;
	tether_mark.style = 6;
	tether_mark.classname = "tether_mark";
	tether_mark.scale = 1;
	tether_mark.effects = EF_ADDITIVE;
	setmodel(tether_mark, "models/artifacts/soul_marker.md3");
	setorigin(tether_mark, tether_org);
	tether_mark.think = tether_mark_think;
	tether_mark.nextthink = time + 0.1;
	if (profilename)
		strunzone(profilename);
};
void() check_tether_inmap = { local entity tm;
	tm = find(world, classname, "tether_mark");
	if (tm)
		remove(tm);

	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	tether = stof(readtext);
	readtext = fgets(readparms);
	tether_org_x = stof(readtext);
	readtext = fgets(readparms);
	tether_org_y = stof(readtext);
	readtext = fgets(readparms);
	tether_org_z = stof(readtext);
	readtext = fgets(readparms);
	tether_map = readtext;
	fclose(readparms);
	if (world.model != tether_map)
	{
		tether = 0;
		return;
	}

	local entity tether_mark;
	tether_mark = spawn();
	tether_mark.color = '1 1 1';
	tether_mark.light_lev = 75;
	tether_mark.pflags = 129;
	tether_mark.style = 6;
	tether_mark.classname = "tether_mark";
	tether_mark.scale = 1;
	tether_mark.effects = EF_ADDITIVE;
	setmodel(tether_mark, "models/artifacts/soul_marker.md3");
	setorigin(tether_mark, tether_org);
	tether_mark.think = tether_mark_think;
	tether_mark.nextthink = time + 0.1;
	if (profilename)
		strunzone(profilename);
};
.float tether_global;
void() nowater_type; 
.float tether_model_client;
void() artifact_client_remove3;
void()message_garbage_collector;
void(entity who)trigger_all_soultether_checkers;
void() write_tether = { 

	nowater_type();
	Kill_Tether();
	write_tether2(0);

	message_garbage_collector ();

	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen(campaignloc, FILE_WRITE);	//open what file to use in write mode
	tether += 1;
	writethis = ftos(1);	//prepare the next thing to write
	fputs(writeparms, writethis);	//line 1
	fputs(writeparms, "\n");	//and again
	writethis = ftos(tether_org_x);
	fputs(writeparms, writethis);
	fputs(writeparms, "\n");
	writethis = ftos(tether_org_y);
	fputs(writeparms, writethis);
	fputs(writeparms, "\n");
	writethis = ftos(tether_org_z);
	fputs(writeparms, writethis);
	fputs(writeparms, "\n");
	writethis = world.model;
	fputs(writeparms, writethis);
	fputs(writeparms, "\n");
	fclose(writeparms);

	local entity artifact_client3;
	artifact_client3 = spawn();
	artifact_client3.lifetime = time + 2;
	artifact_client3.owner = self;
	artifact_client3.effects = 256;
	artifact_client3.viewmodelforclient = self;
	setorigin(artifact_client3, '0 0 0');
	artifact_client3.oldangles = self.angles;
	artifact_client3.frame = 0;
	self.tether_model_client = 1;
	artifact_client3.alpha = 1;
	setmodel(artifact_client3, "models/artifacts/active/soul_tether_active.md3");
	artifact_client3.think = artifact_client_remove3;
	artifact_client3.nextthink = time;
	local entity tether_mark;
	tether_mark = spawn();
	sound(self, CHAN_AUTO, "items/artifacts/artifactE_use.ogg", 1, ATTN_NORM);
	setmodel(tether_mark, "models/artifacts/soul_marker.md3");
	tether_mark.scale = 1;
	setorigin(tether_mark, tether_org);
	local float bparticle;
	bparticle = particleeffectnum("tetherparticle");
	pointparticles(bparticle, tether_org, '0 0 0', 1);
	tether_mark.color = '1 1 1';
	tether_mark.light_lev = 75;
	tether_mark.pflags = 129;
	tether_mark.style = 6;
	tether_mark.classname = "tether_mark";
	tether_mark.effects = EF_ADDITIVE;
	self.tether_global = time + 1;
	self.radialruning = 1;

	float infinitesaves = cvar("infinite_saves");
	if(infinitesaves != 1)
		self.SoulTether -= 1;
	self.tetherhasmodel = 1;
	tether_mark.think = tether_mark_think;
	tether_mark.nextthink = time + 2.2;
	//	read_currentprofileslot();
	local string saveloc;
	copy_save_maps(1);
	saveloc = strcat("save data/profiles/", profilename, "/tether\n");

	stuffcmd(self, "scratch1 1\n");
	stuffcmd(self, saveloc);
	stuffcmd(self, "scratch1 0\n");

	// Reki (June 8 2023): Trigger trigger_soultether_checker entities
	trigger_all_soultether_checkers();

	if (!(self.savedlist &SAVED_TETHER))
		self.savedlist += SAVED_TETHER;
	local float savestotalnumber;
	savestotalnumber = self.savedlist;
	writeprofilesavedlist(savestotalnumber);

	update_latest_saveslot(1);

	if (profilename)
		strunzone(profilename);
	save_screenshot(2,0);
	writedates(2);
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void() LifeSiphon_selected = { self.radialruning = 1;
	sound(self, CHAN_AUTO, "items/artifacts/artifactF_use.ogg", 1, 0.25);
	self.LifeSiphon_time = time + 20.8;
	self.radial_time = time + 21;
	self.LifeSiphon -= 1;
	//	self.radialactive = 0;
	sprint(self, "Life Siphon selected\n");
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void() Aegis_selected = { self.radialruning = 1;
	sound(self, CHAN_AUTO, "items/artifacts/artifactH_use.ogg", 1, 0.25);
	sound(self, CHAN_AUTO, "items/artifacts/aegis.ogg", 1, 0.25);
	self.Aegis_time = time + 20.8;
	self.radial_time = time + 21;
	self.aegisflag = 1;
	self.Aegis -= 1;
	self.health = 1;
	stuffcmd (self, "bf 0.1 0.1 0.25 0.5 0.5\n");
	//	self.radialactive = 0;
	sprint(self, "Aegis selected\n");
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void() Drowner_selected = { self.radialruning = 1;
	sound(self, CHAN_AUTO, "items/artifacts/artifactB_use.ogg", 1, 0.25);
	///stuffcmd (self, "bf 0.25 0.25 0.5 1 0.75\n");
	self.DrownerApp_time = time + 20.8;
	self.radial_time = time + 21;
	self.DrownerApp -= 1;
	//	self.radialactive = 0;
	sprint(self, "Drowner Apparatus selected\n");
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

.entity exenemy;
void ()ai_face;
void()fmck_maker_touch;
.float turret;
void() stricken_preattack1;

void()deactivate_turret2;
void()deactivate_turret;
void() FindNearestEnemy;
void() remove_attar_enemy =
{

	if((self.owner.health > 0) && (self.owner.alreadykilled != 1))
	{
		self.owner.enemy = self.exenemy;
		self.owner.friendly_monster = 0;	
		if(self.owner.classname == "monster_stricken")
		{
			self.owner.turret = self.owner.oldturret;
			if(self.owner.turret == 1)
			self.owner.th_run = stricken_preattack1;
			else
			self.owner.th_run = stricken_run1;
		}

		else
		{
			local entity oself = self;
			self = self.owner;
			FoundTarget();
			local entity pl;
			pl = find(world, classname, "player");
			self.enemy = pl;
			ai_face();
			self.think = self.th_run;
			self.nextthink = time;	
			self.goalentity = self.enemy;
			self = oself;
		}
	}
	self.think = alphafade;	
	self.nextthink = time;	
};
void() spawn_attar_enemy_think =
{
	if(self.owner.health <= 0)
	{
	self.think = alphafade;	
	self.nextthink = time;
	return;
	}
	if(self.frame < 4)
		self.frame ++;

	if(self.lifetime < time)
	{
		self.alphatime = 1;		
		self.think = remove_attar_enemy;
	}
	else
	self.think = spawn_attar_enemy_think;
	self.nextthink = time + 0.05;
};


void() find_next_enemy =
{
	next_enemy();
	self.nextthink = time;
	self.think = self.th_run;
};

void(entity ownr)spawn_attar_enemy =
{
	local entity mark;
	mark = spawn();
	mark.owner = ownr;
	ownr.attached_cloud = mark;
	setmodel(mark,"models/artifacts/effects/confounding_attar_enemy.md3");
	mark.nextthink = time + 0.01;
	mark.lifetime = time + attar_effect_time;
	mark.think = spawn_attar_enemy_think;
	setattachment (mark,ownr,"");		
};


void(entity friend) Create_friendly_monster = 
{
	friend.friendly_monster = 1;
	if(friend.enemy)
		friend.exenemy = friend.enemy; 

	friend.enemy = 0;
	friend.attar_timem = time  + 1;
	if(friend.classname == "monster_heretic")
	{
		if(friend.movetype != MOVETYPE_STEP)
			friend.movetype = MOVETYPE_STEP;
	}
	friend.think = find_next_enemy;
	friend.nextthink = time;
	spawn_attar_enemy(friend);
	local entity oself;
	oself = self;
	self = friend;
	ai_face();
	self = oself;
};

void()cloudtouch =
{
	if ((other.classentity ==  "monsters") && (other.friendly_monster != 1) && (	other.warped_time < time))
		Create_friendly_monster(other);

};



void() 	recheck_friendly_enemies =
{
	entity friend = nextent(world);
	while (friend)	
	{
		entity holder = nextent(friend);
		if ((friend.flags & FL_MONSTER) &&((friend.alreadykilled != 1))&&((friend.enemy.classname == "player")) && (friend.friendly_monster == 1) &&(friend.health > 0))
		{
			entity oself= self;
			self = friend;
			FindNearestEnemy();
			//self.colormod = '1 0 0';
			self = oself;
		}
		friend = holder;	
	}
	self.timefootstep = time + 1;
};


void() search_monster =
{
	local vector source;
	local entity head;
	source = self.origin;
	head = findradius(source, attar_bbox_x);
	while (head)
	{
		if ((head.classentity ==  "monsters") && (head.friendly_monster != 1) && (	head.warped_time < time))
		{
			Create_friendly_monster(head);
		}
		head = head.chain;
	}
};
void()fmck_maker_touch;
void() AttarExplode =
{
	if(self.frame < 4)
		self.frame ++;
	if(self.classname == "AttarCloud")
	{
		search_monster();

		if (time > self.timefootstep)
			recheck_friendly_enemies();
	}
	if(time > self.lifetime)
	{
		self.think = alphafade;	
		self.alphatime = 1.5;		
	}
	else
		self.think = AttarExplode;
	self.nextthink = time + 0.1;
};


.float alreadytouched1;
void() attar_touch =
{
	//pointparticles(particleeffectnum("retcherdecal"), self.origin, '0 0 0', 1);
	if ((other == self.owner))
		return;	// don't explode on owner
	if((other == world) || (other.flags & FL_MONSTER) || (other.solid == SOLID_BSP))
	{	
		self.traileffectnum = particleeffectnum("null");
		sound(self, CHAN_AUTO, "items/artifacts/artifactD_end.ogg", 1, 0.25);
		setmodel(self, "models/artifacts/effects/confounding_attar_cloud.md3");	
		self.movetype = 0;
		self.solid = SOLID_TRIGGER;
		setsize (self, attar_bboxn, attar_bbox);
		self.angles_x = 0;
		self.angles_z = 0;
		self.classname = "AttarCloud";
		self.lifetime = time + attar_time;
		self.touch = fmck_maker_touch ;
		self.nextthink =time + 0.1;
		self.think =  AttarExplode;
		pointparticles(particleeffectnum("attarparimpact"), self.origin, '0 0 0', 1);
		
		makevectors (self.angles);
		vector org = self.origin +'0 0 16';
		traceline(org ,org + v_forward *64, FALSE, self);
		//if (trace_fraction == 1.0)
		{
			entity cloud1 = spawn();
			cloud1.origin = trace_endpos;
			setmodel(cloud1,"models/artifacts/effects/confounding_attar_cloud.md3");	
			cloud1.solid = SOLID_TRIGGER;
			setsize(cloud1, attar_bboxn, attar_bbox);
			cloud1.touch = cloudtouch;
			cloud1.lifetime = time + attar_time;
			cloud1.nextthink =time + 0.1;
			cloud1.think = AttarExplode;	
			cloud1.alphatime = 1.5;	
		}
		traceline(org ,org + v_forward *-64, FALSE, self);
		//if (trace_fraction == 1.0)
		{
			entity cloud2 = spawn();
			cloud2.origin = trace_endpos;
			setmodel(cloud2,"models/artifacts/effects/confounding_attar_cloud.md3");	
			cloud2.solid = SOLID_TRIGGER;
			setsize(cloud2, attar_bboxn, attar_bbox);
			cloud2.touch = cloudtouch;
			cloud2.lifetime = time + attar_time;
			cloud2.nextthink =time + 0.1;
			cloud2.think = AttarExplode;	
			cloud2.alphatime = 1.5;	
		}
		traceline(org ,org + v_right *64, FALSE, self);
		//if (trace_fraction == 1.0)
		{
			entity cloud3 = spawn();
			cloud3.origin = trace_endpos;
			setmodel(cloud3,"models/artifacts/effects/confounding_attar_cloud.md3");	
			cloud3.solid = SOLID_TRIGGER;
			setsize(cloud3, attar_bboxn, attar_bbox);
			cloud3.touch = cloudtouch;
			cloud3.lifetime = time + attar_time;
			cloud3.nextthink =time + 0.1;
			cloud3.think = AttarExplode;	
			cloud3.alphatime = 1.5;	
		}
		traceline(org ,org + v_right *-64, FALSE, self);
		//if (trace_fraction == 1.0)
		{
			entity cloud4 = spawn();
			cloud4.origin = trace_endpos;
			setmodel(cloud1,"models/artifacts/effects/confounding_attar_cloud.md3");	
			cloud4.solid = SOLID_TRIGGER;
			setsize(cloud4, attar_bboxn, attar_bbox);
			cloud4.touch = cloudtouch;
			cloud4.lifetime = time + attar_time;
			cloud4.nextthink =time + 0.1;
			cloud4.think = AttarExplode;	
			cloud4.alphatime = 1.5;	
		}
		
	}
};

void() attar_think_fly =
{
	local vector source;
	local entity head;
	source = self.origin;
	head = findradius(source, 16);
	local float fm;
	while (head)
	{
		if ((head.classentity ==  "monsters") && (head.friendly_monster != 1))
		{
			fm = 1;		
		}
		head = head.chain;	
	}
	if(fm == 1)
		self.think = attar_touch;
	else
		self.think = attar_think_fly; 
	self.nextthink = time + 0.05;	
}
void() Attar_selected =
{
	if(!self.Attar)
		return;
	local entity missile;
	missile = spawn ();
	self.Attar --;
	self.radial_time = time + 1;
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER;
	missile.classname = "grenade";
	sound(self, CHAN_AUTO, "items/artifacts/artifactD_use.ogg", 1, 0.25);
	Controller_Rumble(self, 0, 0.8, 120);
	makevectors (self.v_angle);
	if (self.v_angle_x)
		missile.velocity = v_forward*attar_vel + v_up * attar_velz + crandom()*v_right*1 + crandom()*v_up*1;
	else
	{
		//missile.velocity = aim(self, 10000);
		missile.velocity = normalize(self.cursor_trace_endpos - missile.origin) *attar_vel;
		//missile.velocity = missile.velocity * attar_vel;
		missile.velocity_z += attar_velz;
	}
	missile.angles = vectoangles(missile.velocity);
	missile.gravity = attar_grav;
	missile.touch = attar_touch;
	missile.think = attar_think_fly; 
	//missile.avelocity_x = random( -250,250); 
	missile.avelocity_y = 360; //crandom( -150,150);
	missile.avelocity_z = random( -250,250);
	missile.traileffectnum = particleeffectnum("attarparticle");
	missile.nextthink = time + 0.05;
	setmodel (missile, "models/artifacts/effects/confounding_attar_proj.md3");
	setsize(missile, attar_pbboxn,attar_pbbox);
	setorigin (missile, self.origin);
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.float trinket_touched;

void(vector org, string locsound, float rnd, float vol) randompointsound;
void() trinket2_touch =
{
	if((other.wrathflags & FL_PROJECTILE)&& (other.owner.owner  != self.owner)&& (other.owner  != self.owner) && (other.trinket_touched != 1))
	{

		
		if(other.owner.classname == "monster_invader")
		{float bparticle = particleeffectnum("forcefieldsmall"); string string_sound = "impact/projectiles/trinket_small.ogg";}
		else if((other.owner.classname == "monster_heretic") || (other.owner.classname == "monster_stricken"))
		{bparticle = particleeffectnum("forcefieldbig"); string_sound = "impact/projectiles/trinket_med.ogg";}
		else
		{bparticle = particleeffectnum("forcefield"); string_sound = "impact/projectiles/trinket_med.ogg";}


		pointsound(other.origin, string_sound, 0.5, 1);

		pointparticles(bparticle, other.origin,(other.velocity), 1);
		sound (other, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound if present

		other.velocity_x = other.velocity_x * random (-3, -0.5);
		other.velocity_y = other.velocity_y * random (-3, -0.5);
		other.velocity_z = other.velocity_z * random (-3, -0.5);
		if(other.enemy)
		other.enemy = other.owner;
		other.owner = self.owner;

		other.trinket_touched = 1;

		Steam_StatIncrement(self.owner, ST_STATS::projectiles_deflected, 1);
	}
};
void() dome_remove =
{
	self.scale = 1;
	self.light_lev = 256;	
	self.color = '0.75 0.72 0.2';
	sound (self, CHAN_BODY, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound
	sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound
	sound(self, CHAN_AUTO, "items/artifacts/artifactG_end.ogg", 1, 0.25);
	self.color = '1.5 1.45 0.5';
	self.think = SUB_RemoveScale;
	self.nextthink = time;
};

void() dome_flicker =
{

	if(self.alpha == 1)
	{
		self.light_lev = 10;	
		self.alpha = random (0.125, 0.5);
		sound7 (self, CHAN_BODY, "items/artifacts/artifactG_loop.ogg", 0.75, 0.5,150,0);
	}
	else
	{
		self.light_lev = 180;	
		self.alpha = 1;
		sound(self, CHAN_BODY, "items/artifacts/artifactG_end.ogg", 1, 0.25);
	}
	if(self.lifetime > time)
	{
		self.nextthink = time + random(0.125, 0.25);
		self.think = dome_flicker;
	}
	else
	{
		self.nextthink = time ;
		self.think = dome_remove;
	}

};


void() trinket_postspawn =
{
	self.light_lev += 18;
	self.scale += 0.12;
	self.alpha += 0.1;
	if(self.light_lev >= 180)
	{
		self.think = dome_flicker;
		self.nextthink = time + 15.775;
	}
	else
	{
		self.think = trinket_postspawn;
		self.nextthink = time + 0.025;
	}
};

void() trinket_spawn = 
{
	entity trinket2 = spawn();
	trinket2.origin = self.origin;
	trinket2.owner = self;
	trinket2.origin = self.origin+ '0 0 64';
	trinket2.classname = "dome";
	trinket2.solid = SOLID_TRIGGER;
	setsize(trinket2, '-148 -148 -148', '148 148 148');
	trinket2.touch = trinket2_touch;
	trinket2.nextthink = time + 20;
	trinket2.think = SUB_Remove;
	entity trinket4 = spawn();
	trinket4.origin = self.origin;
	setmodel(trinket4,"models/artifacts/effects/orb_deflection.md3");
	trinket4.pflags = 129;
	trinket4.color = '0.75 0.72 0.2';
	trinket4.style = 1;
	trinket4.alpha = 0.1;
	trinket4.light_lev = 18;	
	trinket4.scale = 0.12;
	trinket4.lifetime = time + 20.8;
	sound (trinket4, CHAN_WEAPON, "items/artifacts/artifactG_loop.ogg", 1, 0.5);
	force_retouch = 2;	
	trinket4.nextthink = time + 0.05;
	trinket4.think = trinket_postspawn;
};

void() TrinketofRespite_selected = 
{ 
	self.radialruning = 1;
	sound7 (self,CHAN_AUTO,"items/artifacts/artifactG_use.ogg",0.75,0.25,130,0);
	TrinketofRespite_time = time + 20.8;
	stuffcmd (self, "bf 0.9 0.9 0.35 0.5 1\n");

	Controller_Rumble(self, 0.1, 0.3, 260);

	self.TrinketofRespite -= 1;
	//	self.radialactive = 0;
	self.radial_time = time + 21;
	trinket_spawn();
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void() W_ChangeWeapon;
//void(entity ownr) spawn_wrath_weapon;
void() raise_weapon;
void(entity e) item_glowmodcontroller_flicker_spawn;

/*
void() energy_blade_think =
{
	if(self.owner.flaskrage_active == 2)
	{
		if(self.ammo_shells < 0.2)
			self.ammo_shells += 0.025; 
		if(self.alpha >= 1)
			self.alpha = 1;
		else
			self.alpha =  self.ammo_shells + (self.flaskrage_kills * 0.1);
	}
	else
	{
		if(self.alpha > 0)
			self.alpha -= 0.1; 
		if(self.alpha <= 0)
		{
			self.effects = EF_NODRAW;
			self.think = SUB_Remove;
			self.nextthink = time + 0.05;
			return;
		}
	}
	self.think = energy_blade_think;
	self.nextthink = time + 0.05;
};
void()	attach_to_blade =
{
	setattachment(self, self.owner.vweapon, "tag_blade");
	self.think = energy_blade_think;
	self.effects = 0;
	self.nextthink = time;
};

*/

void() raise_weapon;
void() trigger_wrath_touch2= 
{ 
	if(other.radial_time > time)
	{
		other.Aegis_time = 0;  other.LifeSiphon_time = 0;  other.DrownerApp_time = 0;  other.Tether_time = 0;
		other.wrath_time = 0;	
		other.radial_time = 0;
		return;	
	}


	if(other.classname != "player")
		return;
	if(other.wrath_time > (time + 2))
	return;

	other.sigil_time = time + self.duration;

	entity oself = self;
	self = other;
	raise_weapon();
	self = oself;
	
	//spawn_wrath_weapon(other);	
	other.wrath_time = time + self.duration;
	other.wrath_active = 1;
	other.sigil_time = time + self.duration;

	te_customflash((self.absmin + self.absmax) / 2, 256, 3, '1 0.12 0.6');

	sound (other, CHAN_AUTO, "items/sigils/sigil_flight_start.ogg",1 ,1);
	te_customflash(other.origin, 256, 1, '1 0.67 0');
	string flash_command_a = strcat ("bf ",ftos(1)," ",ftos(0.12)," ");
	string flash_command_b = strcat (ftos(0.17)," ",ftos(1.25)," ",ftos(1.75),"\n");
	string flash_command =  strcat (flash_command_a,flash_command_b);
	stuffcmd (other, flash_command);



};



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void() Think_RageSubweapon = 
{

	if (self.owner.weapon != self.weapon)	
	self.think = SUB_Remove;
	else
	{
		self.think = Think_RageSubweapon;

		if (self.owner.weapon == IT_SPITTER)
		{
			self.frame = self.owner.phantommodelframe;
			if (self.owner.ammo_spitter >= 8)
				self.skin = 9 + 8;
			else
				self.skin = 9 + self.owner.ammo_spitter;
		}
		if (self.owner.weapon == IT_MACE)
		{
			self.frame = self.owner.phantommodelframe;
		}
		if(self.owner.flaskrage_time < time)
		{
			self.alpha -= 0.025;
			self.nextthink = time + 0.01;
			if(self.alpha <= 0)
			{
				self.alpha = -1;


				self.think = SUB_Remove;
				self.nextthink = time + 0.01;
				return;
			}
		}
		else
			self.alpha = 0.5;
	
	}

	self.nextthink = time;
};

void() Think_Rageweapon = 
{ 

	float spawnsubmodel = 0;
	/*if (self.owner.weapon == IT_LANCE)
	{

		if((self.model != self.owner.vweapon.model ))
		{
			if (self.model != "models/weapons/lance/v_lance_wrath.md3")
				setmodel(self, "models/weapons/lance/v_lance_wrath.md3");
		}
		if(self.skin != 0)
			self.skin = 0;
	}
	else*/
	{
	
		if((self.model != self.owner.vweapon.model ))
		{
			setmodel(self, self.owner.vweapon.model );
			self.lastweapon = 1;

			if (self.owner.weapon == IT_RETCHER)
				self.skin = 2;
			else
				self.skin = 1;
		}
	}


	self.scale = self.owner.vweapon.scale;
	self.origin_x = self.owner.vweapon.origin_x;
	self.origin_y = self.owner.vweapon.origin_y;
	self.origin_z = self.owner.vweapon.origin_z;
	self.angles = self.owner.vweapon.angles;
	self.frame = self.owner.vweaponframe;
	self.glowmod = self.owner.vweaponglowmod;
	if(self.lastweapon == 1)
	{
		entity bvmelee; 
		if (self.owner.weapon == IT_MELEE)
		{
			bvmelee = spawn();
			bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
			bvmelee.owner = self.owner;
			setmodel(bvmelee, "models/weapons/melee/v_blade.md3");
			setattachment(bvmelee, self.owner.vweapon, "tag_blade");
			bvmelee.skin = 1;
			bvmelee.weapon = IT_MELEE;
			bvmelee.alpha = self.alpha;
			bvmelee.think = Think_RageSubweapon;
			bvmelee.nextthink = time;
		}	
		if (self.owner.weapon == IT_CANNON)
		{
			bvmelee = spawn();
			bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
			bvmelee.owner = self.owner;
			setmodel(bvmelee, "models/weapons/cannon/v_pipes.md3");
			setattachment(bvmelee, self.owner.vweapon, "tag_pipes");
			bvmelee.skin = 1;
			bvmelee.weapon = IT_CANNON;
			bvmelee.alpha = self.alpha;
			bvmelee.think = Think_RageSubweapon;
			bvmelee.nextthink = time;
		}

		if (self.owner.weapon == IT_SPITTER)
		{
			bvmelee = spawn();
			bvmelee.owner = self.owner;
			bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
			setmodel(bvmelee, "models/weapons/spitter/v_fangs.md3");
			setattachment(bvmelee, self.owner.vweapon, "tag_body");
			if (self.owner.vgearinspect == 1)
			{
				bvmelee.skin = 9 + 8;
				bvmelee.nextthink = time + 3;
				bvmelee.frame = 16;
			}
			else
				bvmelee.skin = 9;
			bvmelee.weapon = IT_SPITTER;
			bvmelee.alpha = self.alpha;
			bvmelee.think = Think_RageSubweapon;
			bvmelee.nextthink = time;
		}
		if (self.owner.weapon == IT_MACE)
		{
			bvmelee = spawn();
			bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
			bvmelee.owner = self.owner;
			setmodel(bvmelee, "models/weapons/mace/v_mace.md3");
			setattachment(bvmelee, self.owner.vweapon, "tag_mace");
			bvmelee.skin = 7;
			bvmelee.weapon = IT_MACE;
			bvmelee.alpha = self.alpha;
			bvmelee.think = Think_RageSubweapon;
			bvmelee.nextthink = time;
		}
		if(self.owner.vweapon.model == "models/weapons/lance/v_lance.md3")
		bvmelee.effects = EF_NODRAW;
		self.lastweapon = 0;
	}	
	self.think = Think_Rageweapon;
	if(self.owner.flaskrage_time < time)
	{
		self.alpha -= 0.025;
		self.nextthink = time + 0.01;
		if(self.alpha <= 0)
		{
			self.alpha = -1;


			self.think = SUB_Remove;
			self.nextthink = time + 0.01;
			return;
		}
	}

	self.nextthink = time;
};
void() Think_preRageweapon =
{
	float currentframe = self.ammo_shells - 1;
	entity oself = self;
	self = self.owner;
	self.vweaponframe = currentframe;
	self = oself;
	self.think = Think_Rageweapon;
	self.nextthink = time;
};

void(entity ownr) spawn_rage_weapon = 
{
	entity wrath_vweapon = spawn();
	wrath_vweapon.owner = ownr;
	wrath_vweapon.viewmodelforclient = ownr;
	wrath_vweapon.classname = "player_wrathweaponmodel";
	wrath_vweapon.alpha = 0.5;
	wrath_vweapon.effects = 512 + EF_ADDITIVE;
	//wrath_vweapon.colormod = '0.5 0.7 0.7';
	local string fwmodel;
	if (ownr.weapon == IT_MELEE)
	{
		fwmodel = "models/weapons/melee/v_gauntlet.md3";
		wrath_vweapon.skin = 1;
		entity bvmelee = spawn();
		setattachment(bvmelee, ownr.vweapon, "tag_blade");
		bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
		bvmelee.owner = ownr;
		setmodel(bvmelee, "models/weapons/melee/v_blade.md3");
		bvmelee.skin = 1;
		bvmelee.weapon = IT_MELEE;
		bvmelee.alpha = wrath_vweapon.alpha;
		bvmelee.think = Think_RageSubweapon;
		bvmelee.nextthink = time;
	}		
	else if (ownr.weapon == IT_REVOLVER)
	{
		fwmodel = "models/weapons/revolver/v_revolver.md3";
		wrath_vweapon.skin = 1;
	}
	else if (ownr.weapon == IT_SHOTGUN)
	{
		fwmodel = "models/weapons/shotgun/v_shotgun.md3";
		wrath_vweapon.skin = 1;
	}
	else if (ownr.weapon == IT_RETCHER)
	{
		fwmodel = "models/weapons/retcher/v_retcher.md3";
		wrath_vweapon.skin = 2;
	}
	else if (ownr.weapon == IT_SPITTER)
	{
		fwmodel = "models/weapons/spitter/v_spitter.md3";
		wrath_vweapon.skin = 1;
		bvmelee = spawn();
		bvmelee.owner = ownr;
		bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
		setmodel(bvmelee, "models/weapons/spitter/v_fangs.md3");
		setattachment(bvmelee, ownr.vweapon, "tag_body");
		if (ownr.vgearinspect == 1)
		{
			bvmelee.skin = 9 + 8;
			bvmelee.nextthink = time + 3;
			bvmelee.frame = 16;
		}
		else
			bvmelee.skin = 9;
		bvmelee.weapon = IT_SPITTER;
		bvmelee.alpha = self.alpha;
		bvmelee.think = Think_RageSubweapon;
		bvmelee.nextthink = time;
	}
	else if (ownr.weapon == IT_CANNON)
	{
		fwmodel = "models/weapons/cannon/v_cannon.md3";
		wrath_vweapon.skin = 1;
		bvmelee = spawn();
		setattachment(bvmelee, ownr.vweapon, "tag_pipes");
		bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
		bvmelee.owner = ownr;
		setmodel(bvmelee, "models/weapons/cannon/v_pipes.md3");
		bvmelee.skin = 1;
		bvmelee.weapon = IT_CANNON;
		bvmelee.alpha = self.alpha;
		bvmelee.think = Think_RageSubweapon;
		bvmelee.nextthink = time;

	}
	else if (ownr.weapon == IT_LANCE)
	{
		fwmodel = "models/weapons/lance/v_lance.md3";
		wrath_vweapon.skin = 1;
	}
	else if (ownr.weapon == IT_CRYSTAL)
	{
		fwmodel = "models/weapons/crystal/v_crystal.md3";
		wrath_vweapon.skin = 1;
	}
	else if (ownr.weapon == IT_MACE)
	{
		fwmodel = "models/weapons/mace/v_gauntlet.md3";
		wrath_vweapon.skin = 1;
		bvmelee = spawn();
		bvmelee.wrathflags += FL_GARBAGE + FL_SUBWEAPONMODEL;
		bvmelee.owner = ownr;
		setmodel(bvmelee, "models/weapons/mace/v_mace.md3");
		setattachment(bvmelee, ownr.vweapon, "tag_mace");
		bvmelee.skin = 7;
		bvmelee.weapon = IT_MACE;
		bvmelee.alpha = self.alpha;
		bvmelee.think = Think_RageSubweapon;
		bvmelee.nextthink = time;
	}




	setmodel(wrath_vweapon, fwmodel);

	wrath_vweapon.think = Think_Rageweapon;
	wrath_vweapon.nextthink = time;


};


void() flaskrage_selected = 
{ 

	self.radialruning = 1;
	self.flaskrage -= 1;
	//W_ChangeWeapon();
	self.radial_time = time + 20.1;

	raise_weapon();

	spawn_rage_weapon(self);	
	self.flaskrage_time = time + 20;
	self.flaskrage_active = 1;
	self.flaskrage_damagedelt = 0; // Reki (July 30 2023): zero out damage so we can accurately track for achievement

	Controller_Rumble(self, 0, 0.5, 240);

	te_customflash((self.absmin + self.absmax) / 2, 256, 3, FLASKRAGECOLOR);
	float bparticle = particleeffectnum("flaskrage_selected");
	pointparticles(bparticle, self.origin, '0 0 16', 5);

	sound (self, CHAN_AUTO, "items/sigils/sigil_flight_start.ogg",1 ,1);
	te_customflash(self.origin, 256, 1, FLASKRAGECOLOR);
	string flash_command_a = strcat ("bf ",ftos(FLASKRAGECOLOR_x)," ",ftos(FLASKRAGECOLOR_y)," ");
	string flash_command_b = strcat (ftos(FLASKRAGECOLOR_z)," ",ftos(0.5)," ",ftos(1.75),"\n");
	string flash_command =  strcat (flash_command_a,flash_command_b);
	stuffcmd (self, flash_command);

};





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float revelation_mark;
.entity oldowner;
.float secret;


void() spawned_relevelation_particles_think =
{

	self.alpha -= 0.075;
	self.velocity_x = self.velocity_x * 1.075;
	self.velocity_y = self.velocity_y * 1.075;
	self.velocity_z = self.velocity_z * 1.075;
	self.scale  -= 0.15;
	if(self.alpha == 0)
		self.alpha = -1;
	if(self.alpha <= 0)
		self.think = SUB_Remove;
	else
		self.think = spawned_relevelation_particles_think;
	self.nextthink = time + 0.05; 
};

void(vector org,float particleclount,vector pcolormod,float ttype) spawn_relevelation_particles=
{
	float pcount = particleclount;
	while(particleclount > 1)
	{
		entity secret_mark2;
		secret_mark2 = spawn();
		secret_mark2.origin = org;
		secret_mark2.colormod = pcolormod;
		secret_mark2.scale = random(5,7);
		secret_mark2.alpha = random(1,1.5);
		if (ttype & 64)
			setmodel(secret_mark2, "models/artifacts/effects/revelation_note_particle.md3");
		else
			setmodel(secret_mark2, "models/artifacts/effects/revelation_particle.md3");
		secret_mark2.wrathflags += FL_GARBAGE;
		secret_mark2.effects = 512 + EF_NODEPTHTEST + EF_DOUBLESIDED +EF_ADDITIVE;


		secret_mark2.solid = SOLID_NOT;
		secret_mark2.movetype = MOVETYPE_NOCLIP;
		makevectors (single_player.v_angle);

		secret_mark2.velocity = v_right * random(-128,128);

		if(pcount != 9)
		secret_mark2.velocity_z = random(-128,128);
		else
		secret_mark2.velocity_z = random(-256,-128);

		if(ttype & 1)
		{
			secret_mark2.scale += 3;
			secret_mark2.alpha ++;
			secret_mark2.effects -= EF_NODEPTHTEST;
			secret_mark2.velocity = secret_mark2.velocity * 0.5;
		}

		secret_mark2.avelocity_z = random(-512,512);
		secret_mark2.angles_x = random (0,360);
		secret_mark2.angles_y = random (0,360);
		secret_mark2.angles_z = random (0,360);
		//setorigin (secret_mark2,dir);
		secret_mark2.think = spawned_relevelation_particles_think;
		secret_mark2.nextthink = time + 0.5; 
		particleclount --;
	}
};

void() secret_mark2_think = 
{

	self.scale -= 0.02; 
	self.alpha -= 0.05;
	if(self.alpha == 0)
		self.alpha = -1;
	
	if(self.alpha >= 0.05)	
		self.think = secret_mark2_think;
	else
		self.think = SUB_Remove; 

	self.nextthink = time + 0.025; 
};

void() secret_mark3_think = 
{

	self.scale += 0.05; 
	self.alpha -= 0.025;
	if(self.alpha == 0)
		self.alpha = -1;
	
	if(self.alpha >= 0.05)	
		self.think = secret_mark3_think;
	else
	{
		spawn_relevelation_particles(self.origin, 7, '1 1 1', self.type == 1 ? 64 : 0);
		self.think = SUB_Remove; 
	}
	self.nextthink = time + 0.025; 
};
void() secret_mark_think =
{
	//self.colormod = stov (cvar_string ("marker_color"));
	if(self.cnt == 0)
	{
		if(self.alpha <= 1)	
		self.alpha += 0.025;
		if(self.alpha > 1)
		{	
			self.alpha = 1;
			self.cnt = 1;
            self.colormod = '3 3 3';
		}
	}

	if(self.cnt == 1)
	{
		if(self.alpha > 0.5)	
		{	
        self.colormod = '1 1 1';
		self.alpha -= 0.025;
		}
	}

	float found;
	if (self.type == 0)
		found = (self.owner.secret != 1);
	else if (self.type == 1)
		found = wasfreed(self.owner);

	if (found)
	{	
		sound7(self, CHAN_AUTO, "items/artifacts/mark_of_revelation_use.ogg", 0.5, 0.25, 150 + random() *30, 0);
		spawn_relevelation_particles(self.origin, 9, '1 1.1 1', self.type == 1 ? 64 : 0);
		self.think = SUB_Remove;
	}
	else
		self.think = secret_mark_think;
	self.nextthink = time + 0.05; 
};

void() info_mark_think =
{
	float disttoplayer;
	if(revelation_mark == 1)
	{
		disttoplayer = vlen (single_player.origin - self.origin);
		if(disttoplayer <= 1024)
		{	
			self.alpha = 1;
			if(disttoplayer <= 128)
			{
				self.pflags = 129;
				self.scale = 1;
			}
			else
			{
				self.pflags = 0;
				self.scale = 0.5;	
			}
		}

		else
			self.alpha = -1;
	}
	else
		self.alpha = -1;

//	if(self.owner.secret != 1)
//		self.think = SUB_Remove;
//	else
		self.think = info_mark_think;
	self.nextthink = time + 0.05; 
};

void() info_mark =
{
	self.owner = find (world, targetname, self.target);
	self.oldowner = self.owner;
	self.effects = 512 + EF_ADDITIVE;
	setmodel (self,"models/artifacts/mark_flame.md3");
	self.scale =0.5;
	self.pflags = 0;
	self.origin_z +=7;
	self.style = 1; 
	self.color= '1 1 7';
	self.light_lev = 32;
	self.wrathflags += FL_GARBAGE;
 	self.think = info_mark_think;
	self.nextthink = time + 0.25; 
};

void() mark_revelation =
{
	revelation_mark = 1;
	local entity secret_entity;
	self.MarkRevelation --;
	entity secret_mark;
	entity secret_mark2;
	entity secret_mark3;
	vector org;
	self.radial_time = time + 1;
	float disttoplayer = vlen (single_player.origin - self.origin);

	secret_entity = world;//findradius(self.origin, 1000000);

	makevectors (self.v_angle);
	sound(self, CHAN_AUTO, "items/artifacts/mark_of_revelation_use.ogg", 1, 0.25);

	spawn_relevelation_particles(self.origin + self.view_ofs + v_forward * 72,24,'1 1.1 1',0);
	stuffcmd (self, "bf 0.85 1.1 0.9 0.5 0.5\n");
	while (secret_entity = nextent(secret_entity))
	{
		if (secret_entity.wrathflags & FL_SECRET)
		{
			if(secret_entity.classname == "trigger_secret")
				org = (secret_entity.absmin + secret_entity.absmax) * 0.5;
			else
				org = secret_entity.origin;

			if(secret_entity.ammo_revolver != 5)
			{
				secret_mark = spawn();
				secret_mark.origin = org;
				secret_mark.owner = secret_entity;
				secret_mark.oldowner = secret_mark.owner;
				setmodel(secret_mark,"models/artifacts/effects/revelation.md3");
				//secret_mark.colormod = stov (cvar_string ("marker_color"));
				secret_mark.wrathflags += FL_GARBAGE;
				secret_mark.effects = 512 + EF_NODEPTHTEST + EF_ADDITIVE;
				secret_mark.think = secret_mark_think;
		        secret_mark.alpha = 0.05;
				secret_mark.nextthink = time + 0.1; 
				secret_entity.ammo_revolver = 5;
			}

			secret_mark2 = spawn();
			secret_mark2.origin = org;
            secret_mark2.scale = 1.2;
            secret_mark2.alpha = 1;
			setmodel(secret_mark2,"models/artifacts/effects/revelation_blur.md3");
			secret_mark2.wrathflags += FL_GARBAGE;
			secret_mark2.effects = 512 + EF_NODEPTHTEST;
			secret_mark2.think = secret_mark2_think;
			secret_mark2.nextthink = time + 0.5; 

			secret_mark3 = spawn();
			secret_mark3.origin = org;
            secret_mark3.scale = 0.1;
            secret_mark3.alpha = 1.2;
			setmodel(secret_mark3,"models/artifacts/effects/revelation_blur.md3");
			secret_mark3.wrathflags += FL_GARBAGE;
			secret_mark3.effects = 512 + EF_NODEPTHTEST;
			secret_mark3.think = secret_mark3_think;
			secret_mark3.nextthink = time; 


			//sound7(secret_mark, CHAN_AUTO, "items/artifacts/artifactA_spawn.ogg", 1, 0.15, 80 + random() *30, 0);
			if(disttoplayer <= 1024)
				spawn_relevelation_particles(org,12,'0.175 0.35 1',0);
		}
		else if (secret_entity.classname == "item_readable")
		{
			org = secret_entity.origin;

			if(secret_entity.ammo_revolver != 5)
			{
				secret_mark = spawn();
				secret_mark.origin = org;
				secret_mark.owner = secret_entity;
				secret_mark.oldowner = secret_mark.owner;
				setmodel(secret_mark,"models/artifacts/effects/revelation_note.md3");
				secret_mark.wrathflags |= FL_GARBAGE;
				secret_mark.effects = EF_FULLBRIGHT + EF_NODEPTHTEST + EF_ADDITIVE;
				secret_mark.think = secret_mark_think;
				secret_mark.nextthink = time + 0.1; 
				secret_mark.alpha = 0.05;
				secret_entity.ammo_revolver = 5;
				secret_mark.type = 1;
			}
			
			secret_mark2 = spawn();
			secret_mark2.origin = org;
            secret_mark2.scale = 1.2;
            secret_mark2.alpha = 1;
			setmodel(secret_mark2,"models/artifacts/effects/revelation_note_blur.md3");
			secret_mark2.wrathflags |= FL_GARBAGE;
			secret_mark2.effects = EF_FULLBRIGHT | EF_NODEPTHTEST;
			secret_mark2.think = secret_mark2_think;
			secret_mark2.nextthink = time + 0.5; 
			secret_mark2.type = 1;

			secret_mark3 = spawn();
			secret_mark3.origin = org;
            secret_mark3.scale = 0.1;
            secret_mark3.alpha = 1.2;
			setmodel(secret_mark3,"models/artifacts/effects/revelation_note_blur.md3");
			secret_mark3.wrathflags |= FL_GARBAGE;
			secret_mark3.effects = EF_FULLBRIGHT | EF_NODEPTHTEST;
			secret_mark3.think = secret_mark3_think;
			secret_mark3.nextthink = time;
			secret_mark3.type = 1;

			if(disttoplayer <= 1024)
				spawn_relevelation_particles(org, 12, '1 1 1', 64);
		}
	}


};


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.float magnettime;
void(float plimit )grenade_magnet_force =
{

	while (plimit > 0)
	{
		vector randomorigin;
		randomorigin_x = random(self.origin_x - 256,  self.origin_x + 256);
		randomorigin_y = random(self.origin_y - 256,  self.origin_y + 256);
		randomorigin_z = random(self.origin_z - 256,  self.origin_z + 256);
		if(vlen (randomorigin - self.origin) < 512)
			vector pdir = normalize (randomorigin - self.origin) * vlen (randomorigin - self.origin) * -32; 
		pointparticles(particleeffectnum("magneticgrenade"), randomorigin, pdir, 1);
		plimit --;
	}

	entity magnetobject = findradius(self.origin + '0 0 12', 512);
	while (magnetobject)
	{
		if((magnetobject.flags & FL_MONSTER) && (magnetobject.health> 0))
		{
			float dist = vlen((self.origin - magnetobject.origin));
			vector dir = normalize((self.origin - magnetobject.origin));
			magnetobject.velocity = ((dir * 800));
			magnetobject.magnettime = time + 0.3;
			if(dist < 128)
				magnetobject.velocity = ((dir * dist * 2));
			if(dist < 192)
			{
				entity oldself = self;
				self = magnetobject;
				if(self.enemy != oldself)
				{	
					self.enemy = oldself;
					self.goalentity = oldself;
				}
				if(time > self.pain_finished)
				{
					self.th_pain(single_player, 100000);
					self.pain_finished = time + (0.7);
				}		
				
				self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
				ChangeYaw();

				self =  oldself;
			}	
			if(dist < 32)
				magnetobject.velocity = '0 0 0';
			if ((magnetobject.flags & FL_FLY))
				magnetobject.flags = (magnetobject.flags - FL_FLY);
			if ((magnetobject.flags & FL_ONGROUND))
				magnetobject.flags = (magnetobject.flags - FL_ONGROUND);

			float plimitb = random(2,5);
			while (plimitb > 0)
			{
				randomorigin_x = random(magnetobject.absmin_x,  magnetobject.absmax_x);
				randomorigin_y = random(magnetobject.absmin_y,  magnetobject.absmax_y);
				randomorigin_z = random(magnetobject.absmin_z,  magnetobject.absmax_z);
				if(vlen (randomorigin - self.origin) < 512)
					pdir = normalize (randomorigin - self.origin) * vlen (randomorigin - self.origin) * -32; 
				pointparticles(particleeffectnum("magneticgrenadeb"), randomorigin, pdir, 1);
				plimitb --;
			}

		}
		magnetobject = magnetobject.chain;
	}
};
void()grenade_magnet_push =
{
	entity head = findradius(self.origin + '0 0 12', 512);
	while (head)
	{
		if (head.wrathflags & FL_GIB)
		{
			explo_physics_gibs (self,head,100,5);
			entity gib_follower = spawn();
			setmodel (gib_follower,"models/misc/null.md3");							
			setattachment(gib_follower,head,"");
			gib_follower.traileffectnum = particleeffectnum("magnetic_trail");
			gib_follower.think = SUB_Remove;
			gib_follower.nextthink = time + random (1,3);
		}
		head = head.chain;  // cycle to next head (entity)
	}
	remove(self);
};


void()grenade_magnet_kill =
{
	//vector pdir = normalize (randomorigin - self.origin) * vlen (randomorigin - self.origin) * 32; 
	magnetic_time =  time + 2.5;

	// Reki (June 12 2023): Refactored this for clarity, and added takedamage check.
	float flyingmonsters_killed = 0;
	for(entity magnetobject = findradius(self.origin, 256); magnetobject; magnetobject = magnetobject.chain)
	{
		if (!(magnetobject.flags & FL_MONSTER) && !(magnetobject.wrathflags & FL_CRYSTAL))
			continue;

		if (magnetobject.takedamage == DAMAGE_NO)
			continue;

		if(magnetobject.classname == "monster_wretch")
			magnetobject.health = -495;
		else
			magnetobject.health = -1000;

		if (magnetobject.classname == "monster_symbol" || magnetobject.classname == "monster_heretic" || magnetobject.classname == "monster_wraith" || magnetobject.classname == "monster_keeper")
			flyingmonsters_killed++;

		Killed(magnetobject, self.owner, 1);
	}

	if (flyingmonsters_killed >= 3)
	{
		Steam_AchievementUnlock(world, ST_ACHIEVEMENTS::SP_GRIND_VOID);
	}

	self.think = grenade_magnet_push;
	self.nextthink = time + 0.1;
};
void() blackgrenade_orb2_think =
{
	if((self.enemy.oldcount == 1) && (self.oldcount != 1))
	{
	self.oldcount = 1;
	setorigin (self,self.rel_origin);
	}
	if(self.oldcount == 1)
	{
		if(self.scale >= 3)
		{		
				remove(self); 
				return;
		}
		else
			self.scale += 0.12;
		self.colormod = '1 1 1';
		self.alpha -= 0.05;
	}
	else
	{
		if((self.scale < 2) && (self.ammo_shells != 1))
		{	
			if(self.alpha < 1)
			self.alpha += 0.1;
			self.scale += 0.015;
		}
		else
		{
			setmodel (self,"models/artifacts/effects/orb_blackhole.md3");
			self.scale = 0.15;
			self.ammo_shells = 1;
			self.light_lev ++;
		}
	}
	if(self.colormod_x > 0.5)
	{
		self.colormod_x -= 0.5;
		self.colormod_y -= 0.5;
		self.colormod_z -= 0.5;

	}
	//if(self.colormod_x < 1)
	
	if(self.alpha <= 0)
		self.alpha = -1;
	self.think = blackgrenade_orb2_think;
	self.nextthink = time + 0.025;
};
void()blackgrenade_orb_think =
{
	if(self.scale == 4)
	{
		self.msprite.cnt ++;
		vector colorflash;
		if(self.msprite.cnt == 3)
		{
			sound(self, CHAN_AUTO, "items/artifacts/void_grenade_riser.ogg", 1, 0.25);
		}
		colorflash_x = self.msprite.cnt* 0.375;
		colorflash_y = self.msprite.cnt* 0.03;
		colorflash_z = self.msprite.cnt* 0.3;
		setorigin (self,self.rel_origin);
		te_customflash (self.msprite.origin,64 + (self.msprite.cnt * 12) ,0.25,colorflash);
		vector colormodgrenade;	
		//self.msprite.scale = 0.2 + self.msprite.cnt * 0.3;
		colormodgrenade_x = 1 + self.msprite.cnt * 0.3;
		colormodgrenade_y = 1 + self.msprite.cnt * 0.3;
		colormodgrenade_z = 1 + self.msprite.cnt * 0.3;

		self.msprite.colormod = colormodgrenade;
		float plimit = self.msprite.cnt * 8;
		while (plimit > 0)
		{
			float size_particlecube = 32 + self.msprite.cnt * 8;
			vector randomorigin;
			randomorigin_x = random(self.msprite.origin_x - size_particlecube,  self.msprite.origin_x + size_particlecube);
			randomorigin_y = random(self.msprite.origin_y - size_particlecube,  self.msprite.origin_y + size_particlecube);
			randomorigin_z = random(self.msprite.origin_z - size_particlecube,  self.msprite.origin_z + size_particlecube);
			if(vlen (randomorigin - self.msprite.origin) < (size_particlecube * 2))
				vector pdir = normalize (randomorigin - self.msprite.origin) * vlen (randomorigin - self.msprite.origin) * - size_particlecube * 0.3; 
			pointparticles(particleeffectnum("magnetic_particle"), randomorigin, pdir, self.msprite.cnt);
			plimit --;
		}


		//pointparticles(particleeffectnum("magnetic_particle"), self.msprite.origin + '0 0 7', '0 0 12', self.msprite.cnt);
		sound7 (self, CHAN_BODY, "weapons/lance/fire1.ogg", 0.5, 0.25,random(150,175),0);
		self.count += 0.5;
		//pointparticles(particleeffectnum("shockwave_impact"), self.origin + '0 0 12', '0 0 0', 8);
	}
	if(self.scale < 0.2)
	{		
		if(self.owner.count == 1)
		{
			remove(self); 
			return;
		}
		else	
		{
			self.scale = 4;
		}
	}
	else
		self.scale -= 0.1;



	self.alpha = 1/(self.scale * 10);

	self.think = blackgrenade_orb_think;
	self.nextthink = time + (0.025 / self.count);
};
void()blackgrenade_explo_think =
{
	if(self.scale >= 7)
	{		
			remove(self); 
			return;
	}
	else
		self.scale += 0.25;
	self.alpha = 1/(self.scale * 10);

	self.think = blackgrenade_explo_think;
	self.nextthink = time + 0.025;
};
.vector intensity;
.float sradius;
.float sattenuation;
void()trigger_shake_use;


void(entity e,float intensity,float waittime, float radius) spawn_shaker =
{
	entity shaker = spawn();
	shaker.origin = e.origin;
	shaker.classname = "spawnedshaker";
	shaker.wait = waittime;
    shaker.sradius = radius;
	shaker.intensity_x = intensity;
	shaker.intensity_y = intensity;

	if(e.classname == "monster_brute")
		shaker.sattenuation = 1;
	shaker.shake_camera_refresh_rate = 0.05;
    shaker.think = trigger_shake_use;
    shaker.nextthink = time;
};

void() BlackGrenade_fade = 
{ 
	self.frame += 1;
	self.alpha -= 0.1;
	self.light_lev = self.frame * 25;

	
	if(self.frame <= 3)
		grenade_magnet_force(0);
	if(self.frame == 3)
	{
		self.oldcount = 1;
		soundwrath(self, CHAN_VOICE, "items/artifacts/void_grenade_explosion.ogg", 1, 0.25, 100, 0,0.33);
		//sound(self, CHAN_AUTO, "items/artifacts/void_grenade_explosion.ogg", 1, 0.25);
		//sound7 (self, CHAN_AUTO, "weapons/lance/fire1.ogg", 1, 0.075,random(70,75),0);
		//sound7 (self, CHAN_BODY, "enemies/heretic/proj_impact1.ogg", 1, 0.075,random(70,75),0);
		entity exp =  spawn();
		exp.owner = self.owner;
		exp.origin = self.origin + '0 0 24';	
		exp.think = grenade_magnet_kill;
		exp.nextthink = time;
		entity orb = spawn();
		setmodel (orb,"models/artifacts/orb_grenade.md3");
		orb.origin = self.origin;
		orb.colormod = self.colormod;
		orb.scale = 0.1;
		orb.alpha = 1;
		orb.think = blackgrenade_explo_think;
		orb.nextthink = time + 0.05;
		spawn_shaker(self,15,1,768);  
		pointparticles(particleeffectnum("magneticgrenadekill"), self.origin + '0 0 12', '0 0 0', 8);


	}
	if (self.frame < 8)
		self.count = 1;
	if (self.frame < 10)
		self.think = BlackGrenade_fade;
	else
		self.think = SUB_Remove;

	self.nextthink = time + 0.05;
};


.float pushed_time;

void()BlackGrenade_wait =
{

	self.cnt ++;
	grenade_magnet_force(16 - self.cnt);

	self.nextthink = time + 0.1;
	if(self.cnt < 25)
		self.think = BlackGrenade_wait;
	else
	{
		self.think = BlackGrenade_fade;	
		setorigin (self,self.rel_origin);
	}
};

void()BlackGrenade_think =
{
	self.frame -= 1;
	self.alpha += 0.1;


	self.light_lev = self.frame * 25;
	grenade_magnet_force(16);

	if(self.frame > 0)
	{
		self.think = BlackGrenade_think;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.light_lev =38;
		self.alpha = 1;
		self.think = BlackGrenade_wait;
		self.nextthink = time + 0.1;
	}

};

void() BlackGrenade_posttouch =
{
	if ((other == self.owner))
		return;	
	//if(!(other == world))
	//	return;	
/*	self.pflags = 129;
	self.style = 1; 
	self.color= '3 0.125 2';*/

	self.colormod = '3 0.125 2';
	self.origin_z += 4;
	self.touch = SUB_Null;
	self.movetype = 0;
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	//self.solid = SOLID_TRIGGER;
	setmodel(self, "particles/explo/explo_wretch.md3");
	self.alpha = 0.1;
	self.frame = 9;
	pointparticles(particleeffectnum("bgrenadeimpact"), self.origin, '0 0 0', 1);

	entity orb = spawn();
	orb.owner = self;
	setmodel (orb,"models/artifacts/orb_grenade.md3");
	orb.alpha = 0.125;
	orb.origin = self.origin;
	orb.colormod = self.colormod;
	orb.scale = 4;
	orb.count = 1;
	orb.think = blackgrenade_orb_think;
	orb.nextthink = time + 0.05;

	entity orb2 = spawn();
	orb2.enemy = self;
	setmodel (orb2,"models/artifacts/effects/orb_blackhole_small.md3");
	orb2.alpha = 0;
	orb2.origin = self.origin;
	orb2.scale = 0.1;
	orb2.count = 1;
	orb2.think = blackgrenade_orb2_think;
	orb2.colormod = '1 1 1';
	orb2.nextthink = time + 0.05;
	orb.msprite = orb2;
	orb.rel_origin = self.origin;
	orb2.rel_origin = self.origin;
	self.rel_origin = self.origin;
	pointparticles(particleeffectnum("grenadeartimpact"), self.origin, '0 0 128', 1);
	setorigin (self, self.rel_origin);
	self.think = BlackGrenade_think;
	self.nextthink = time + 0.1;

};
.float surfacing_sound_time;

void() BlackGrenade_pretthink =
{
	if(self.lifetime > time)
	{
		sound7 (self, CHAN_AUTO, "weapons/mace/mace_hit_stone4.ogg", 0.5, 0.5,random(370,450),0);
		self.lifetime = 0;
	}

	if((self.colormod_x > 0.5) ||(self.oldorigin == self.origin)|| (self.lifetime < time) || (self.flags & FL_ONGROUND))
	{

		self.angles_x += random (-7,7);
		self.angles_y += random (-7,7);
		self.angles_z += random (-7,7);
		self.velocity_x += random(-15,15);
		self.velocity_y += random(-15,15);
		self.colormod += '0.015 0.0125 0.015';
	}	
	if(self.colormod_x >= 1.05)	
	{
		self.think = BlackGrenade_posttouch;
		self.velocity = '0 0 0';

		sound7 (self, CHAN_AUTO, "impact/destruct/glass_break1.ogg", 0.5, 0.5,random(200,250),0);
		self.nextthink = time;
		return;
	}
	else
		self.think = BlackGrenade_pretthink;

	self.oldorigin = self.origin;
	self.nextthink = time + 0.0125 + ((1 - self.colormod_x) * 0.125);
};
void() BlackGrenade_pretouch =
{
		
	if(other.solid == SOLID_TRIGGER)
		return;
	if(other == self.owner)
		return;
	if((self.surfacing_sound_time < time) && (other.solid == SOLID_BSP))
	{
		sound7 (self, CHAN_AUTO, "weapons/mace/mace_hit_stone4.ogg", 0.5, 0.5,random(370,450),0);
		self.surfacing_sound_time = time + random(0.25,0.37);

		self.avelocity_x += random(-256,256);
		self.avelocity_y += random(-256,256);
		self.avelocity_z += random(-256,256);
	}

	if((other.flags & FL_MONSTER) && (other.takedamage > 0))
	{
		self.think = BlackGrenade_pretthink;
		self.colormod_x = 1.05;
		self.nextthink = time;
		self.lifetime = 0;
		self.movetype = 0;
		return;
	}
};
void() BlackGrenade_selected =
{
	self.BlackGrenade --;
	float BlackGrenade_vel = 512;
	float BlackGrenade_velz = 128;
	self.radial_time = time + 1;
	local entity missile;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	setsize(missile,'0 0 0','0 0 0');
	missile.classname = "bgrenade";
	makevectors (self.v_angle);
	if (self.v_angle_x)
		missile.velocity = v_forward*BlackGrenade_vel + v_up * BlackGrenade_velz + crandom()*v_right*1 + crandom()*v_up*1;
	else
	{
		missile.velocity = normalize(self.cursor_trace_endpos - missile.origin) *BlackGrenade_vel;
		missile.velocity_z += BlackGrenade_velz;
	}
	sound(self, CHAN_AUTO, "items/artifacts/void_grenade_throw.ogg", 1, 0.25);
	Controller_Rumble(self, 0, 0.8, 120);
	missile.lifetime = time + 10;
	missile.colormod = '0.5 0.5 0.5';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = BlackGrenade_pretouch;
	missile.think = BlackGrenade_pretthink;
	missile.nextthink = time + 1;
	setmodel (missile, "models/artifacts/grenade.md3");
	setsize(missile, '-4 -4 -5','4 4 5');
	setorigin (missile, self.origin);
};

///////////////////////////////////

///////////////////////////////////
.float shockwave_touched;
void() shockwave_touch =
{
	if (other == self.owner)
		return;
	if (other.takedamage)
	{
		float damage;
		if(self.cnt <= shockwave_critical_radius)
			damage = shockwave_dmg;
		else
			damage = shockwave_dmg * (1 - (self.cnt / (shockwave_radius - shockwave_critical_radius)));
		T_Damage(other, self, self.owner, damage);	
	}

};
.float shockwaved;
.float shockwave_kills;

void() spark_spawner_think = 
{
	float r = random();	
	pointparticles(particleeffectnum("shockwave_impact"), self.owner.origin, '0 0 0', 1);
	if ((r < 0.05)|| (self.shockwaved > 3))
	{
		self.shockwaved ++;
		self.owner.velocity_x += random (-32,32);
		self.owner.velocity_y += random (-32,32);

		if(self.flags & FL_ONGROUND)
		self.owner.velocity_z += random (32,96);
		pointparticles(particleeffectnum("shockwave_impact2"), self.owner.origin, '0 0 0', 1);
		float r2 = random();
		if(r2 < 0.5)
			sound7 (self, CHAN_BODY, "fx/tele4.ogg", 0.75, 0.5,random(150,200),0);

		if(r2 < 0.5)
			te_customflash ( self.owner.origin,16,1,' 0.12 0.12 1');
	}
	if((self.lifetime < time) )
	{	
		self.think = SUB_Remove;
		self.owner.think = alphafade;
		self.owner.nextthink = time + random(2, 5);
	}
	else
		self.think = spark_spawner_think;

	self.nextthink = time + random(0.5, 1);
		
};
void(entity targ) shockwave_killincrement =
{
	if (targ.flags & FL_MONSTER)
	{
		self.shockwave_kills++;
		if (self.shockwave_kills >= 10)
			Steam_AchievementUnlock(self.owner, ST_ACHIEVEMENTS::SP_GRIND_SHOCKWAVE);
	}
}
void() shockwave_think =
{
	if(!self.count)
		self.count = shockwave_radius / (shockwave_time * 10);
	self.lip ++;// cycles counter
	if (self.cnt >= shockwave_radius)
		remove(self);
	else
	{
		self.cnt += self.count;
		local entity head;
		head = findradius(self.origin, self.cnt);

		float damage;
		if(self.cnt <= shockwave_critical_radius)
		{
			damage = shockwave_dmg;
			self.oldcount ++; // cycles counter of critical radius
		}
		else
			damage = shockwave_dmg - ((shockwave_dmg / (shockwave_time * 10))* self.lip) + (self.oldcount * (shockwave_dmg / (shockwave_time * 10)));

		while (head)	// while looking for head
		{
			if((head.wrathflags & FL_GIB) && (head.shockwaved != 1))
			{	
				entity spark_spawner = spawn();
				spark_spawner.shockwaved = 1;
				//setmodel (spark_spawner, "sedrser");
				spark_spawner.origin = head.origin;
				head.shockwaved = 1;
				spark_spawner.owner = head;
				spark_spawner.lifetime = time + random(2,5);
				spark_spawner.think = spark_spawner_think;
				spark_spawner.nextthink = time;
			}

			if ((head.takedamage) && (head != self.owner) && (head.shockwave_touched != self.owner.shockwave_touched))	
			{

				float plimitb = random(2,5);
				while (plimitb > 0)
				{
					vector randomorigin;
					randomorigin_x = random(head.absmin_x,  head.absmax_x);
					randomorigin_y = random(head.absmin_y,  head.absmax_y);
					randomorigin_z = random(head.absmin_z,  head.absmax_z);
					pointparticles(particleeffectnum("shockwave_impact"), randomorigin, head.velocity, 1);
					plimitb --;
				}


				if(head.solid == SOLID_BSP)
				{
					if (visibleb(head.maxs + '0 0 2', self.origin, self))
					{
						if(head.health > damage)	
							T_Damage(head, self, self.owner, damage);	// its damage
						else
						{	
							head.health -= damage;
							head.shockwaved = 1;	
							te_customflash(head.origin,128,0.25,'0.5 0.5 2');
							Killed(head, self.owner, 1);
							//void(vector org, float radius, float lifetime, vector color) te_customflash = #417;
							shockwave_killincrement(head);
						}					
					}
				}	
				else				
				{
					if (visibleb(head.origin, self.origin, self))
					{
						if(head.health > damage)	
							T_Damage(head, self, self.owner, damage);	// its damage
						else
						{	
							head.health -= damage;
							head.shockwaved = 1;
							//te_customflash(head.origin,128,0.25,'0.5 0.5 2');
							Killed(head, self.owner, 1);
							shockwave_killincrement(head);
						}
						pointparticles(particleeffectnum("shockwave_impact3"), head.origin, head.velocity, 1);					
					}
				}
				head.shockwave_touched = self.owner.shockwave_touched;	
			}
			head = head.chain;	// go to next enemy
		}
	}
	self.think = shockwave_think;
	self.nextthink = time + 0.1;
};
.float oldalpha;
void()model_shockwave_think =
{
	float final_scale = shockwave_radius / 128;
	float total_cycles = shockwave_time * 40;
	if(!self.cnt)
	{
		self.cnt = total_cycles;
		self.count = 1 / total_cycles;
	}

	self.scale += final_scale / total_cycles;

	self.oldalpha -= self.count;	
	self.colormod_x -= 0.03;	
	self.colormod_y -= 0.03;	
	self.colormod_z -= 0.03;	

	float orbalpha = cvar ("orb_alpha");


	if(self.effects == EF_NODEPTHTEST)
		self.alpha = self.oldalpha * orbalpha * 0.3;
	else
		self.alpha = self.oldalpha * orbalpha * 0.7;

	if(self.scale >= final_scale)
		self.think = SUB_Remove;
	else
		self.think = model_shockwave_think;
	self.nextthink = time + 0.025;

};

void() ShockWave_selected = 
{ 

	if(self.fshockwave_time > time)
		return;
	self.fshockwave_time = time + shockwave_time;
	float orbalpha = cvar ("orb_alpha");
	if(!orbalpha)	
	localcmd("set orb_alpha 0.5\n");

	// Reki (December 3 2023): Added controller rumble
	Controller_Rumble(self, 0.7, 0.15, 1100);
	makevectors (self.v_angle);
	pointparticles(particleeffectnum("shockwave_start"), self.origin + self.view_ofs+ v_forward * 12, '0 0 0', 1);					
	spawn_shaker(self,20,1,768);  
	self.radial_time = time + 1;
	entity shockwave;
	shockwave = spawn();
	setmodel (shockwave, "");
	te_customflash ( self.origin,shockwave_radius * 0.7,shockwave_time,' 1 1 2');
	shockwave.origin = self.origin;
	shockwave.solid = SOLID_TRIGGER;
	shockwave.movetype = MOVETYPE_FLY;
	shockwave.owner = self;
	self.shockwave_touched ++;
	self.ShockWave --;
	//shockwave.touch = shockwave_touch;
	shockwave.think = shockwave_think;
	shockwave.nextthink = time;
	stuffcmd (self, "bf 0.2 0.2 0.55 0.5 0.5\n");
	entity model = spawn();
	//sound7 (self, CHAN_AUTO, "items/artifacts/artifactA_end.ogg",1, 0.5,random(50,70),0);

	
	local float r; string tnoise;
	r = floor(random() *3);
	if (r < 1)
		tnoise= "env/amb/thunder1.ogg";
	if (r < 2)
		tnoise = "env/amb/thunder2.ogg";
	else
		tnoise = "env/amb/thunder3.ogg";

	sound7 (self, CHAN_AUTO, tnoise,1, 0.25,random(90,110),0);

	//sound7 (self, CHAN_AUTO, "items/artifacts/artifactA_end.ogg",1, 0.5,random(50,70),0);

	model.origin = shockwave.origin;
	setmodel (model,"models/artifacts/effects/orb_shockwave1.md3");
	model.owner = shockwave;
	model.scale = 0.1;
	model.colormod = '2 2 3';
	model.oldalpha = 1.1;
	model.think = model_shockwave_think;
	model.nextthink = time;
	entity model2 = spawn();
	copyentity(model,model2);
	setmodel (model2,"models/artifacts/effects/orb_shockwave2.md3");

	entity model3 = spawn();
	copyentity(model,model3);
	setmodel (model3,"models/artifacts/effects/orb_shockwave1.md3");
	model3.effects = EF_NODEPTHTEST;

	entity model4 = spawn();
	copyentity(model,model4);
	setmodel (model4,"models/artifacts/effects/orb_shockwave2.md3");
	model4.effects = EF_NODEPTHTEST;

};
///////////////////////////////////

/*
0 0 0 0
1 20 10 1 //sprout (?) 
2 // attack
3
4
5
6
7
8 16 10 1//idle (?) 
24 16 10 0// shake
40 20 10 0// death 
*/

$frame Vicious_pose0
$frame Vicious_sprout
$frame Vicious_attack1 Vicious_attack2 Vicious_attack3 Vicious_attack4 Vicious_attack5 Vicious_attack6
$frame Vicious_idle
$frame Vicious_shake
$frame Vicious_death
float test_ia;
void()vicious_idol_waiting1;
void()vicious_idol_attacka1;
void()vicious_idol_attacka6; 


void() 	recheck_vicious_enemies =
{
	entity viciousenemy = nextent(world);
	while (viciousenemy)	
	{
		entity holder = nextent(viciousenemy);
		if ((viciousenemy.flags & FL_MONSTER) &&(viciousenemy.enemy == self) && (viciousenemy.friendly_monster < 1) &&(viciousenemy.health > 0))
		{
			entity oself= self;
			self = viciousenemy;
			next_enemy();
			self = oself;
		}

		viciousenemy = holder;	
	}
};

void() FindBoss = 
{ 
	local entity head;
	self.enemy = world;
	head = find(world, classname,"boss_guardian1");
	if(!head)
		head = find(world, classname,"boss_guardian2");
	if(!head)
		head = find(world, classname,"boss_guardian3");
	if((head) && (visible(head)))
		self.enemy = head;
};

void() vicious_idol_shake = [$Vicious_shake, vicious_idol_waiting1]
{
	self.glowmod = '1 1 1';	
	self.nextthink = time + 1.6;
	self.wait = time + 1.6 + random (3,7);
};

void() vicious_idol_waiting1 =[$Vicious_idle, vicious_idol_waiting1]
{
	self.movetype = MOVETYPE_TOSS;

	if (visible(self.enemy))
		self.think = vicious_idol_attacka1;
	else
	{	
		FindBoss();
		if(self.enemy == world)
			next_enemy();
	}

	if((self.wait < time) && (random() < 0.2))
		self.think = vicious_idol_shake;
};
void(string sound, float random, float channel)monstersound2;

void()vicious_idol_attacka1 =[$Vicious_attack1,vicious_idol_attacka2]
{
	ai_face();
	sound(self, CHAN_AUTO, "enemies/wretch/preattack.ogg", 1, 0.25);
};

void()vicious_idol_attacka2 =[$Vicious_attack2,vicious_idol_attacka3]{ai_face();};
void()wretch_attack;
void()vicious_idol_attacka3 =[$Vicious_attack3,vicious_idol_attacka4]
{
	ai_face();

	if(test_ia == 1)
		self.enemy_prediction = self.oldposition.origin;

	entity closer_monster = findradius(self.origin, 512);
	while (closer_monster)
	{
		if((closer_monster.flags & FL_MONSTER) && (closer_monster.health> 0) && (closer_monster.enemy!= self) && (visible(closer_monster)))
			T_Damage (closer_monster,self,self,0.1);

		closer_monster = closer_monster.chain;
	}

	self.movetype = 0;
	self.glowmod = '1.75 1.75 1.75';	
	monstersound2("items/artifacts/vicious_animus_attack", 3, CHAN_AUTO);
	wretch_attack();
};

void()vicious_idol_attacka4 =[$Vicious_attack4,vicious_idol_attacka5]
{
	ai_face();
	
	if(self.enemy.health <0)
		self.enemy = world;
};

void()vicious_idol_attacka5 =[$Vicious_attack5,vicious_idol_attacka6]
{	
	ai_face();
	float enemy_is_visible = visible(self.enemy);

	if((!self.enemy) || (!enemy_is_visible))
		next_enemy();
	
	//self.nextthink = time + 0.1;

	if (enemy_is_visible)
		self.think = vicious_idol_attacka6;
	else
		self.think = vicious_idol_waiting1;	
};

void()vicious_idol_attacka6 =[$Vicious_attack6,vicious_idol_attacka1]{ai_face();};

void() vicious_deleter_think =
{
	if(self.owner.lifetime < time)
	{
		entity oself = self;
		self = self.owner;
		self.frame = $Vicious_death;
		self.nextthink = time;
		self.alphatime = 2;
		self.alpha = 1;
		sound (self, CHAN_AUTO, "items/artifacts/vicious_animus_death1.ogg",1, 0.25);
		sound (self, CHAN_BODY, "misc/null.wav",0, 0.25);
		self.think = alphafade;
		recheck_vicious_enemies();
		self = oself;
		remove(self);
	}
	
	self.think = vicious_deleter_think;
	self.nextthink = time + 0.1;
};

void() vicious_glowcontrol_think =
{
	if(self.owner.lifetime < time)
		remove(self);
		
	if(self.owner.glowmod_x > 0.3)
	{
		self.owner.glowmod_x -= 0.05;
		self.owner.glowmod_y -= 0.05;
		self.owner.glowmod_z -= 0.05;
	}
	
	if(self.owner.glowmod_x < 0.01)
		self.owner.glowmod = '0.01 0.01 0.01';

	self.think = vicious_glowcontrol_think;
	self.nextthink = time + 0.025;
};

void() vicious_idol_die =
{
	self.lifetime = 0;
	self.alpha = 1;
};

void()vicious_idol_sprout2 =
{
	float bparticle = particleeffectnum("tetherparticle");
	pointparticles(bparticle, self.origin, '0 0 0', 3);
	bparticle = particleeffectnum("eggimpact");
	pointparticles(bparticle, self.origin, '0 0 0', 3);

	self.pipes.pflags = 0;
	remove(self.pipes.pipes);
	remove(self.pipes);
	self.think =vicious_idol_waiting1;
	sound (self, CHAN_BODY, "items/artifacts/vicious_animus_loop.ogg",0.5, 0.5);
	self.scale = 1;
	self.movetype = MOVETYPE_WALK;
	self.nextthink = time + 0.7;
};

void() vicious_idol_sprout = [$Vicious_sprout, vicious_idol_sprout2]
{
	self.movetype = MOVETYPE_TOSS;
	self.effects = 0;
	self.nextthink = time + 0.7;
	self.wait = time + random(1,5);
};
void(vector org, entity e)spawn_tdeath;
void(entity e) ViciousIdol_Spawner =
{
	entity vicious = spawn();
	copyentity (e,vicious);
	vicious.origin_z -= 2;
	vicious.pflags = 0;
	vicious.colormod = '1 1 1';
	vicious.movetype = MOVETYPE_NONE;
	vicious.angles_x = 0;
	vicious.angles_z = 0;
	vicious.velocity = '0 0 -320';
	vicious.frame = 0;
	vicious.pipes = e;
	vicious.effects = EF_NODRAW;
	vicious.yaw_speed =30;	
	vicious.scale = 0.5;
	vicious.classname = "viciousidol";
	vicious.health = 750;
	vicious.friendly_monster = 2;
	vicious.takedamage = DAMAGE_YES;
	spawn_tdeath(vicious.origin, vicious);
	vicious.th_run = vicious_idol_attacka1;
	vicious.th_die = vicious_idol_die;
	vicious.th_pain = nullpain;
	setmodel(vicious, "models/artifacts/vicious_animus.md3"); 
	setsize(vicious,'-16 -16 0','16 16 56');
	setorigin (vicious, vicious.origin);
	vicious.yaw_speed = 20;
	vicious.lifetime = time + 20;
	vicious.think = vicious_idol_sprout;
	vicious.nextthink = time + 0.3;

	//float bparticle = particleeffectnum("tetherparticle");
	//pointparticles(bparticle, vicious.origin - '0 0 12', '0 0 0', 1);


	
	entity deleter = spawn();
	deleter.owner =  vicious;
	deleter.think = vicious_deleter_think;
	deleter.nextthink = time + 0.1;

	entity glow_controller = spawn();
	glow_controller.owner =  vicious;
	glow_controller.think = vicious_glowcontrol_think;
	glow_controller.nextthink = time + 0.1;

};

void() ViciousIdol_Spawn =
{
	if(self.cnt == 2)
		sound (self, CHAN_AUTO, "items/artifacts/vicious_animus_breaking.ogg",1, 0.25);
	if(self.cnt <= 2)
	{
		self.cnt ++;
		if(self.count == 2)
		{
			self.angles_x = self.angles_x * -1;
			self.angles_z = self.angles_z * -1;
		}
		else
		{
			self.angles_x += random(-20,20);
			self.angles_z += random(-20,20);
		}

		if(self.cnt >= 2)
		{
			self.skin = 1;	
			float bparticle = particleeffectnum("eggimpact");
			pointparticles(bparticle, self.origin, '0 0 0', 1);
		}
		if(self.flags & FL_ONGROUND)
			self.flags -= FL_ONGROUND;
		self.velocity_z += random (32,48); 
		self.think = ViciousIdol_Spawn;
		self.nextthink = time + 0.25;
	}
	else
	{
		ViciousIdol_Spawner (self);
		setsize(self, '-2 -2 -2','2 2 0');
		self.think = SUB_Null;
		self.nextthink = time;
	}
};

void() egg_glowcontrol_think =
{
	self.owner.colormod_x += 0.05; 
	self.owner.colormod_y += 0.05; 
	self.owner.colormod_z += 0.05; 
	self.owner.light_lev += 1;
	self.think = egg_glowcontrol_think;
	self.nextthink = time + 0.025;
};

void()ViciousIdol_think =
{
	if((self.origin_z == self.oldorigin_z) && (self.flags & FL_ONGROUND) || (self.lifetime < time))
	{
		self.think = ViciousIdol_Spawn;
		self.alphatime = 1.7;
		self.nextthink = time + random(0.5,1);
		entity glow_controller = spawn();
		glow_controller.owner =  self;
		self.pipes = glow_controller;
		glow_controller.think = egg_glowcontrol_think;
		glow_controller.nextthink = time + 0.1;
		self.pflags = 129;
		self.color = '0.3 0.3 0.3';
		self.light_lev += 1;	
		self.style = 1;
		return;
	}
	
	setsize(self, '-16 -16 -7','16 16 7');
	self.oldorigin = self.origin;
	self.think = ViciousIdol_think;
	self.nextthink = time + 0.05;
};

void() ViciousIdol_selected =
{
	float ViciousIdol_vel = 256;
	float ViciousIdol_velz = 64;
	self.ViciousIdol --;
	self.radial_time = time + 0.2;
	makevectors (self.v_angle);
	
	local entity ViciousIdol;
	ViciousIdol = spawn ();
	ViciousIdol.movetype = MOVETYPE_BOUNCE;
	ViciousIdol.bouncefactor = 0.25;
	ViciousIdol.owner = self;
	ViciousIdol.solid = SOLID_BBOX;
	ViciousIdol.classname = "viciousgrenade";
	ViciousIdol.colormod = '1 1 1';
	if (self.v_angle_x)
		ViciousIdol.velocity = v_forward*ViciousIdol_vel + v_up * ViciousIdol_velz + crandom()*v_right*1 + crandom()*v_up*1;
	else
	{
		ViciousIdol.velocity = normalize(self.cursor_trace_endpos - ViciousIdol.origin) *ViciousIdol_vel;
		ViciousIdol.velocity_z += ViciousIdol_velz;
	}
	
	ViciousIdol.angles = vectoangles(ViciousIdol.velocity);
	ViciousIdol.think = ViciousIdol_think;
	ViciousIdol.nextthink = time + 0.05;
	ViciousIdol.lifetime =  time + 2.5;


	sound (self, CHAN_AUTO, "items/artifacts/vicious_animus_throw.ogg",1, 0.25);
	Controller_Rumble(self, 0.2, 0.8, 120);

	setmodel (ViciousIdol, "models/artifacts/artifact_animus_proj.md3");
	setsize(ViciousIdol, '-2 -2 -2','2 2 2');
	setorigin (ViciousIdol, self.origin + self.view_ofs + v_forward * 7);
};
///////////////////////////////////end of qc file

