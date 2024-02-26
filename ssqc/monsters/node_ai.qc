
.entity follow_path;
.float followingapath;
.vector nextnode;
.float node_touch;

void() spawn_follow_path_remove =
{
	if (nodegraph_query_is_valid(self.owner.nodegraph_query_id))
		nodegraph_query_release(self.owner.nodegraph_query_id);	
	self.owner.followingapath = 0;
	remove(self);
}
void() spawn_follow_path_touch =
{
	if(other != self.owner)
	return;
	if (nodegraph_query_is_valid(other.nodegraph_query_id))
		nodegraph_query_release(other.nodegraph_query_id);	
	other.followingapath = 0;
	remove(self);
};
void(vector path_org, entity ownr) spawn_follow_path =
{
	entity local_follow_path = spawn();
	ownr.follow_path = local_follow_path;
	local_follow_path.owner = ownr;
	local_follow_path.origin = path_org;
	local_follow_path.node_touch = 1;
	setmodel (local_follow_path, "models/misc/null.md3");
	local_follow_path.solid = SOLID_TRIGGER;
	setsize (local_follow_path, '-12 -12 -32', ' 12 12 32');
	local_follow_path.touch = spawn_follow_path_touch;
	local_follow_path.think = spawn_follow_path_remove;
	local_follow_path.nextthink = time  + 0.75;
	ownr.followingapath = 1;
};

.float extra_speed;
.float charging;
.float walktime;
.float follownodetime;
.float evading;
.vector oldorigin2;
.entity oldenemy2;
void() widow_atk ;
.float widowspeed;
vector()widow_check_dest;
void(float dist)ai_test_monster_run = 
{

	if( (self.enemy) &&((!self.enemy.health) || (self.enemy.health < 0)))
		next_enemy();	

	if((!(self.flags & FL_ONGROUND)) && (self.jumptime > time))
		return;
	if((self.walktime2 > time) && (self.classname != "monster_brute"))
	{
		self.movetype = MOVETYPE_WALK;
		self.gravity = 1;
		makevectors2(self.angles);
	
		if(self.flags & FL_ONGROUND)
			self.velocity = v_forward *dist * 24;
		else
		{
			self.velocity = v_forward *dist * 12;
			self.velocity_z = -370;
		}
		vector pos1,pos2;
		pos1 = self.enemy.origin;
		pos2 = self.origin;
		pos2_z = pos1_z;
		
		vector vec = normalize(pos1 - pos2);
		vec = vec * 64;

		self.ideal_yaw = vectoyaw((self.enemy.origin + vec) - self.origin);	
		ChangeYaw();		
		return;	
	}


	if(self.magnettime > time)
    	return;
	if((self.evading_time > time ) || (self.timeangles > time))
	{
		if(self.classname == "executioner")
		{
			self.movetype = MOVETYPE_STEP;
			float walkeddist = walkmovedist(self.angles_y,dist  * 2.33);
		}
		else
		{
			if(self.classname == "monster_incisor")
			self.movetype = MOVETYPE_WALK;
			makevectors(self.angles);
			if(self.flags & FL_ONGROUND)
				self.velocity = v_forward *dist * 24;
			else
			{
				self.velocity = v_forward *dist * 6;
				self.velocity_z = -370;
			}
			//self.effects = E;
			
		}
		return;
	}
	if(self.classname == "executioner")
	{
		if(self.charging == 0)
		{
			self.yaw_speed = 35; 
			self.effects = 0;
		}
		else
		{
			float enemy_dist = vlen (self.origin - self.enemy.origin);
			float preyawspeed = (10 - self.extra_speed);
			float execyaw = cvar ("execyaw");

			if(enemy_dist >= 368)
				self.yaw_speed = (preyawspeed + 5);
			if(enemy_dist < 368)
				self.yaw_speed = (preyawspeed + 3) * execyaw;
			if(enemy_dist < 256)
				self.yaw_speed = (preyawspeed + 1) * execyaw;
			if(enemy_dist < 192)
				self.yaw_speed = preyawspeed;
			//self.yaw_speed += 2;	
			//self.effects = 128;
		}
	}
	if(self.evading == 1)
		self.evading = 2;

	float threshold = 182;	


	if(!self.trigger_angle_use)
	self.trigger_angle_use = 1; 
	float isvisible = (visible(self.enemy));
	if(self.classname == "monster_widow")
	{
	
		float height_check = max(self.origin_z,self.enemy.origin_z) - min(self.origin_z,self.enemy.origin_z);
		if(visible(self.enemy) && (height_check < 92))
		{
			self.colormod = '1 1 1';
			isvisible = 1;
			if(self.classname == "monster_widow")
			threshold = 512;	
		}
		else
		{
			self.colormod = '1 1 1';
			isvisible = 0;
		}
	}


	if((vlen(self.enemy.origin - self.origin) < threshold) && (isvisible == 1)  && (self.follownodetime < time))
	{
		if (nodegraph_query_is_valid(self.nodegraph_query_id))
			nodegraph_query_release(self.nodegraph_query_id);	
		if((self.follow_path) && (self.followingapath == 1))
			remove(self.follow_path);
		self.followingapath = 0;
		if(self.classname == "monster_widow")
			self.yaw_speed = 60;

	}
	else
	{
		if(!self.followingapath)
			find_node_path();
		if(self.classname == "monster_widow")
			self.yaw_speed = 20;

	}
	if (nodegraph_query_is_valid(self.nodegraph_query_id)) 
	{
		if(self.followingapath != 1)
		{
			float currentnodeid = nodegraph_query_get_nodeid(self.nodegraph_query_id, self.nodegraph_query_entry_index);
			vector currentnode = nodegraph_graph_get_node(0, currentnodeid);
			if(vlen(self.origin - currentnode) < threshold)
			{
				currentnodeid = nodegraph_query_get_nodeid(self.nodegraph_query_id, self.nodegraph_query_entry_index + 1);
				currentnode = nodegraph_graph_get_node(0, currentnodeid);
			}
			spawn_follow_path (currentnode, self);
			self.follownodetime = time  + random() * 0.5;
			self.ideal_yaw = vectoyaw(currentnode - self.origin);	
		}
		else
			self.ideal_yaw = vectoyaw(self.follow_path.origin - self.origin);	
			ChangeYaw();
	}
	else
	{
		self.followingapath = 0;

		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);	

		
		if(self.classname == "monster_widow") 
		{
			if (self.touchtime < time)
			{
				self.effects = 0;
				ChangeYaw();
			}
		}
		else
			ChangeYaw();

	}



	
	if((self.walktime > time) && (self.movetype == MOVETYPE_STEP))
	self.movetype = MOVETYPE_WALK;


	if((self.walktime < time) && (self.movetype != MOVETYPE_STEP))
	self.movetype = MOVETYPE_STEP;

	makevectors2(self.angles);


	if(self.movetype == MOVETYPE_STEP)
	{
		if(self.classname == "executioner")
			dist = dist * 2.33;
		walkeddist = walkmovedist(self.angles_y,dist);
		if(walkeddist <= 0)
		{
			if(self.strafing >time)
				check_angles();
			else
			{
				float r = random();
				if (r < 0.5)
					check_strafe();
				else
				{
					self.follownodetime = time  + random() * 2.5;
					self.walktime = time  + 2.5;
				}
			}
		}
	}
	else
	{

		makevectors(self.angles);
		if((self.classname == "monster_brute") && (self.skin != 1) ) 
		{
			tracebox(self.origin, '-8 -8 -8', '8 8 8', self.origin + v_forward * 64 - v_up *(32 + 16 + self.stepheight_delta), 3, self);

			if(trace_fraction == 1)
			{
				setorigin (self, self.origin + v_forward * -16);
				self.movetype = MOVETYPE_STEP;

				tracebox(self.origin, '-5 -5 -5', '5 5 5', self.origin + v_forward *-128, FALSE, self);
				if (trace_fraction == 1.0)
				{
					self.lastplace_spoted = trace_endpos;
					self.timeangles = time+ 0.5 + random() + 1;
					self.timeangles2 = time + 2;		
				}
				else
					check_angles();
				self.walktime2 = time - 1;

				if (visible(self.enemy))
				{
					self.think = self.th_missile;
					self.nextthink = time + 0.05;
					self.timeangles = time+ 0.5 + random() + 3;
					self.timeangles2 = time + 5;
					return;
				}

				return;
			}

		}	

		float speed = vlen (self.velocity);
		vector extravel;

		if((self.classname == "monster_widow") && (self.widowspeed < 8))
		{
			extravel = widow_check_dest();
		}
		else
		{
			if((speed < (dist * 0.5)) && (self.timeangles2 < time))
				check_angles();
		}
		float walkvel = 24;
		if(self.classname == "monster_brute")
			walkvel = 20;
		if(self.flags & FL_ONGROUND)
			self.velocity = v_forward *dist * walkvel;
		else
		{
			self.velocity = v_forward *dist * walkvel;
			self.velocity_z = -370;
		}
		self.velocity += extravel;
	}

	self.oldorigin2 = self.origin;

};	

void() test_monster_run
{
	if(!self.enemy)
		self.enemy = single_player;
	ai_test_monster_run(16);
	self.think = test_monster_run;
	self.nextthink =  time + 0.1;
};


void()test_monster_start = 
{
	self.yaw_speed = 30;
	self.think = test_monster_run;
	self.nextthink =  time + 0.1;
};	

void() test_monster =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	setmodel(self, "models/enemies/fallen/fallen1.md3");
	self.colormod ='1 1 0';
	setsize(self, '-12 -12 -32', '12 12 32');
	self.think = test_monster_start;
	self.nextthink =  time + 0.1;
};
