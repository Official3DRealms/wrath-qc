//#pragma warning error Q208

void() monster_fallen;
void() monster_fallen_boss3;
void() monster_prowler;
void() monster_wraith;
void() monster_brute;
void() monster_executioner;
.float rise;


void() check_relics = 
{ 
    self.local_classmonster = self.classmonster1;
	local entity pl;
	pl = find(world, classname, "player");
	if (!pl.oldrelics)
		return;
	if (pl.oldrelics == 1)
		self.local_classmonster = self.classmonster2;
	if (pl.oldrelics == 2)
		self.local_classmonster = self.classmonster3;
	if (pl.oldrelics == 3)
		self.local_classmonster = self.classmonster4;
	if (pl.oldrelics >= 4)
		self.local_classmonster = self.classmonster5;

    /*float dev = cvar ("developer");
    float encounter = cvar ("encounter");
    if(dev == 1)
    {
        self.local_classmonster = encounter;
        if (encounter <= 1)
            self.local_classmonster = 1;
        if (encounter >= 4)
            self.local_classmonster = 4;
    }*/
};

void() check_spawner_counter = {

/* local entity pl;
	pl = find(world, classname, "player");
	local float m_counter = self.count;

	if (pl.oldrelics == 4)
	{
		if (self.classmonster5 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (pl.oldrelics == 3)
	{
		if (self.classmonster4 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (pl.oldrelics == 2)
	{
		if (self.classmonster3 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (pl.oldrelics == 1)
	{
		if (self.classmonster2 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (!pl.oldrelics)
	{
		if (self.classmonster1 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}

*/
check_relics();
};


float() monster_counter = 
{ 
	local entity monster;
	local float monster_counter;
	monster = nextent(world);
	while (monster)
	{
		entity holder = nextent(monster);
		if ((monster.flags &FL_MONSTER) && (monster.health >= 0))
			monster_counter ++; 
		monster = holder;	
	}
	return monster_counter;
};

void() recount_monsters =
{
	total_monsters = killed_monsters +  monster_counter ();
	entity pl = find(world, classname, "player");

	local entity spawner;
	spawner = nextent(world);
	while (spawner)
	{
		entity holder = nextent(spawner);
		if (spawner.wrathflags &FL_SPAWNER)
		{
		local float m_counter = spawner.count;
			if (pl.oldrelics >= 4)
			{
				if (spawner.classmonster5 > 0)
					total_monsters = total_monsters + m_counter;
			}			if (pl.oldrelics == 4)
			{
				if (spawner.classmonster5 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (pl.oldrelics == 3)
			{
				if (spawner.classmonster4 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (pl.oldrelics == 2)
			{
				if (spawner.classmonster3 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (pl.oldrelics == 1)
			{
				if (spawner.classmonster2 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (!pl.oldrelics)
			{
				if (spawner.classmonster1 > 0)
					total_monsters = total_monsters + m_counter;
			}

		}

		spawner = holder;
	}

};


void() enemy_spawner_use = {
	
	if (self.warped != 1)
	{
		
		if (self.local_classmonster <= 0)
		{
			remove(self);
			return;
		}
	}
	self.count -= 1;
	if ((self.count >= 0) && (self.local_classmonster > 0))
	{
		// Reki (July 12 2023): population control
		float allowed_to_spawn = TRUE;
		.float population_fld;
		if (population_control && self.local_classmonster <= population_control_fields.length)
		{
			population_fld = population_control_fields[self.local_classmonster - 1];
			if (population_control.population_fld == 0)
				allowed_to_spawn = FALSE;
		}
		//

		if (allowed_to_spawn)
		{
			local entity enemy;
			enemy = spawn();
			enemy.flags = FL_MONSTER;
			setorigin(enemy, self.origin);
			enemy.angles = self.angles;
			if (self.type == 1)
				enemy.grosstime = time + 0.5;
			enemy.waypointed = self.waypointed;
			enemy.rise = self.rise;
			enemy.nojump = self.nojump;
			enemy.turret = self.turret;
			enemy.likecharge = self.likecharge;
			enemy.target = self.target;
			enemy.target2 = self.target2;
			enemy.target3 = self.target3;
			enemy.target4 = self.target4;
			enemy.target5 = self.target5;
			enemy.target6 = self.target6;
			enemy.target7 = self.target7;
			enemy.target8 = self.target8;

			enemy.melonhead = self.melonhead;

			enemy.death_target = self.death_target;
			enemy.targetname = self.targetname;
			enemy.spawned = 1;
			enemy.spawnflags = self.spawnflags;
			enemy.nodroptofloor = self.nodroptofloor;
			enemy.oldorigin = self.origin;

			if (population_control) // subtract 1 from the available population points for this monster types
			{
				(population_control.population_fld)--; 
				enemy.pop_field = population_fld; // track this for later, when the monster dies it relinquishes its slot
			}

			if (self.local_classmonster == 1)
			{
				enemy.rise = self.rise;
				enemy.think = monster_fallen;
				if (self.type == 1)
					enemy.grosstime = time + 2.7;
				if (self.classname == "monster_fallen_boss3")
					enemy.think = monster_fallen_boss3; // Reki (July 9 2023): changed this to a separate spawn func, to set th_die for custom monster count
					//enemy.ammo_crystal = 32;
			}
			if (self.local_classmonster == 2)
				enemy.think = monster_invader;
			if (self.local_classmonster == 3)
				enemy.think = monster_wretch;
			if (self.local_classmonster == 4)
				enemy.think = monster_prowler;
			if (self.local_classmonster == 5)
				enemy.think = monster_widow;
			if (self.local_classmonster == 6)
				enemy.think = monster_wraith;
			if (self.local_classmonster == 7)
				enemy.think = monster_heretic;
			if (self.local_classmonster == 8)
				enemy.think = monster_lurker;
			if (self.local_classmonster == 9)
			{
				enemy.think = monster_oppressor;
			}
			if (self.local_classmonster == 10)
				enemy.think = monster_executioner;
			if (self.local_classmonster == 11)
				enemy.think = monster_stricken;
			if (self.local_classmonster == 12)
				enemy.think = monster_afflicted;
			if (self.local_classmonster == 12 + 1)
				enemy.think = monster_afflicted;
			if (self.local_classmonster == 14)
				enemy.think = monster_symbol;
			if (self.local_classmonster == 15)
				enemy.think = monster_brute;
			if (self.local_classmonster == 16)
				enemy.think = monster_keeper;
			if (self.warped)
			{

				if (self.type == 1)
					enemy.grosstime = time + 1.5;
				enemy.warped_time = time + 3;	
				enemy.warped = 1;
				enemy.colormod = '5 0 0';
				//enemy.glowmod = '10 2 2';
				enemy.frame = 88;
				enemy.lastframewarp = 97;
				if ((self.local_classmonster == 1) && (self.rise == 1))
				{
					//enemy.rise = self.rise;
					enemy.frame = 116;
					enemy.lastframewarp = 123;
				}
				if (self.local_classmonster == 2)
				{
					enemy.frame = 21;
					enemy.lastframewarp = 30;
				}
				if (self.local_classmonster == 3)
				{
					enemy.frame = 21;
					enemy.lastframewarp = 30;
				}
				if (self.local_classmonster == 4)
				{
					enemy.frame = 21;
					enemy.lastframewarp = 30;
				}

				if (self.local_classmonster == 5)
				{
					enemy.frame = 63;
					enemy.lastframewarp = 72;
				}
				if (self.local_classmonster == 6)
				{
					enemy.frame = 59;
					enemy.lastframewarp = 68;
				}
				if (self.local_classmonster == 7)
				{
					enemy.frame = 21;
					enemy.lastframewarp = 30;
				}
				if (self.local_classmonster == 9)
				{
					enemy.frame = 21;
					enemy.lastframewarp = 30;
				}
				if (self.local_classmonster == 10)
				{
					enemy.frame = 166;
					enemy.lastframewarp = 175;
				}
				if (self.local_classmonster == 11)
				{
					enemy.frame = 88;
					enemy.lastframewarp = 97;
				}
				if (self.local_classmonster == 12)
				{
					enemy.frame = 1;
					enemy.lastframewarp = 10;
				}

				if (self.local_classmonster == 15)
				{
					enemy.frame = 196;
					enemy.lastframewarp = 205;
				}
				/*entity telefragger = spawn();
				force_retouch = 2;
				telefragger.owner = enemy;
				telefragger.origin = self.origin;
				telefragger.solid = SOLID_TRIGGER;
				telefragger.touch = telefrag_touch;
				setsize(telefragger,'-16 -16 -48','16 16 48');
				telefragger.nextthink = time + 3.25;
				telefragger.think = SUB_Remove;*/

				enemy.nextthink = time+ 0.05;
			}
			else
				enemy.nextthink = time + 0.05;




			self.think = enemy_spawner_use;
			self.nextthink = time + self.delay;
		}
	}
	else
	{
		//if(self.respawnable)
		//self.wrathflags = FL_RESPAWN;
		self.think = SUB_Remove;
		self.use = null;
		self.nextthink = time + 0.1;
	}
};

void() enemy_spawner_use_wait = { self.think = enemy_spawner_use;
	self.nextthink = time + self.wait;
};

void() enemy_spawner = 
{


	if (!self.classmonster2)
		self.classmonster2 = self.classmonster1;
	if (!self.classmonster3)
		self.classmonster3 = self.classmonster1;
	if (!self.classmonster4)
		self.classmonster4 = self.classmonster1;
	if (!self.classmonster5)
		self.classmonster5 = self.classmonster1;
	self.local_classmonster = self.classmonster1;

	if (self.local_classmonster <= 0)
	{
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
		return;
	}
	self.wrathflags += FL_SPAWNER;

	if (!self.count)
		self.count = 1;
	if (!self.delay)
		self.delay = 5;
	setmodel(self, "");




	if (self.wait)
		self.use = enemy_spawner_use_wait;
	else
		self.use = enemy_spawner_use;
	self.think = check_spawner_counter;
	self.nextthink = time + 0.25;
	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
	//if(self.respawnable)
	//copy_old_data (self);
};

.float fastwarp;
void() enemy_spawner_warp_use = { 
	if (self.local_classmonster <= 0)
	{
		remove(self);
		return;
	}
	if ((!self.fastwarp) && (!self.frame))
	{
		self.frame = 1;
		self.effects -= EF_NODRAW;
		sound(self, CHAN_AUTO, "fx/warp.ogg", 1, 0.125);
	}
	if ((self.fastwarp) && (!self.frame))
	{
		self.frame = 2;
		self.cnt = 35;
		self.effects -= EF_NODRAW;
		sound(self, CHAN_AUTO, "fx/warp_fast.ogg", 1, 0.125);
		self.alpha = 1;
	}
	self.cnt += 1;
	if ((!self.fastwarp))
	{
		if ((self.alpha < 1) && (self.cnt <= 10))
			self.alpha += 0.1;
	}

	if (self.cnt == 36)
	{
		enemy_spawner_use();
		pointparticles(particleeffectnum("warp"), self.origin, '0 0 0', 1);
	}
	if (self.cnt > 36)
		self.alpha -= 0.1;
	if (self.cnt >= 45)
		self.think = SUB_Remove;
	else
		self.think = enemy_spawner_warp_use;
	self.nextthink = time + 0.05;
};

void() enemy_spawner_warp_use_wait = { self.think = enemy_spawner_warp_use;
	self.nextthink = time + self.wait;
};
void() enemy_spawner_warp = 
{ 
	if (!self.type)
		self.type = 1;
	self.frame = 0;
	self.alpha = 0.00001;
	if (!self.nodroptofloor)
		self.nodroptofloor = 1;
	setmodel(self, "models/warp/warp.md3");
	self.effects += EF_NODRAW;
	self.warped = 1;
	if (!self.classmonster2)
		self.classmonster2 = self.classmonster1;
	if (!self.classmonster3)
		self.classmonster3 = self.classmonster1;
	if (!self.classmonster4)
		self.classmonster4 = self.classmonster1;
	if (!self.classmonster5)
		self.classmonster5 = self.classmonster1;
	self.local_classmonster = self.classmonster1;

	if (self.local_classmonster <= 0)
	{
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
		return;
	}
	self.wrathflags += FL_SPAWNER;

	self.count = 1;
	if (self.wait)
		self.use = enemy_spawner_warp_use_wait;
	else
		self.use = enemy_spawner_warp_use;
	self.think = check_spawner_counter;
	self.nextthink = time + 1;
	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
};

void() trigger_aggro_touch = 
{ 
	if(self.disarmed == 1)
		return;
	if (other.classname != "player")
		return;
	if(single_player.flags &FL_NOTARGET)
		return;


	local entity e;
	if (self.target)
	{
		e = world;
		do { 	e = find(e, targetname, self.target);
			if (!e)
				return;
			e.grosstime = time + 0.1;
		}
		while (1);
	}
};

void() trigger_aggro = { 

	self.touch = trigger_aggro_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.use = toggle_disarmed;
	self.model = string_null;
};


///////////////////////////////////

