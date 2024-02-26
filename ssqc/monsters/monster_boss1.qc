
/*
0 20 10 1 // Idle 1
21 48 10 0 // wakeup 2
70 20 10 1 // Floating 3
91 20 10 0 // Attack Left 4
112 20 10 0// Attack Right 5
133 20 20 0// Rotate left 6
154 20 20 0// Rotate right 7
*/

$frame boss1_base

$frame boss1_idle //0 20 10 1 // Idle 1

$frame boss1_wakeup //21 10 10 0 // Wakeup 2

$frame boss1_float //31 20 10 0 // Floating 3

$frame boss1_shot1 boss1_shot2 boss1_shot3 boss1_shot4 boss1_shot5 boss1_shot6 boss1_shot7 boss1_shot8 boss1_shot9 boss1_shot10
$frame boss1_shot11 boss1_shot12 boss1_shot13 boss1_shot14 boss1_shot15 boss1_shot16 boss1_shot17 boss1_shot18 boss1_shot19 boss1_shot20

$frame boss1_scattright1 boss1_scattright2 boss1_scattright3 boss1_scattright4 boss1_scattright5 boss1_scattright6 boss1_scattright7 boss1_scattright8 boss1_scattright9 boss1_scattright10
$frame boss1_scattright11 boss1_scattright12 boss1_scattright13 boss1_scattright14 boss1_scattright15 boss1_scattright16 boss1_scattright17 boss1_scattright18 boss1_scattright19 boss1_scattright20
$frame boss1_scattright21 boss1_scattright22 boss1_scattright23 boss1_scattright24 boss1_scattright25 boss1_scattright26 boss1_scattright27 boss1_scattright28 boss1_scattright29 boss1_scattright30

$frame boss1_scattleft1 boss1_scattleft2 boss1_scattleft3 boss1_scattleft4 boss1_scattleft5 boss1_scattleft6 boss1_scattleft7 boss1_scattleft8 boss1_scattleft9 boss1_scattleft10
$frame boss1_scattleft11 boss1_scattleft12 boss1_scattleft13 boss1_scattleft14 boss1_scattleft15 boss1_scattleft16 boss1_scattleft17 boss1_scattleft18 boss1_scattleft19 boss1_scattleft20
$frame boss1_scattleft21 boss1_scattleft22 boss1_scattleft23 boss1_scattleft24 boss1_scattleft25 boss1_scattleft26 boss1_scattleft27 boss1_scattleft28 boss1_scattleft29 boss1_scattleft30

$frame boss1_hurlleft1 boss1_hurlleft2 boss1_hurlleft3 boss1_hurlleft4 boss1_hurlleft5 boss1_hurlleft6 boss1_hurlleft7 boss1_hurlleft8 boss1_hurlleft9 boss1_hurlleft10
$frame boss1_hurlleft11 boss1_hurlleft12 boss1_hurlleft13 boss1_hurlleft14 boss1_hurlleft15 boss1_hurlleft16 boss1_hurlleft17 boss1_hurlleft18 boss1_hurlleft19 boss1_hurlleft20

$frame boss1_hurlright1 boss1_hurlright2 boss1_hurlright3 boss1_hurlright4 boss1_hurlright5 boss1_hurlright6 boss1_hurlright7 boss1_hurlright8 boss1_hurlright9 boss1_hurlright10
$frame boss1_hurlright11 boss1_hurlright12 boss1_hurlright13 boss1_hurlright14 boss1_hurlright15 boss1_hurlright16 boss1_hurlright17 boss1_hurlright18 boss1_hurlright19 boss1_hurlright20

$frame boss1_rotleft //171 10 10 0 // Rotate left 9

$frame boss1_rotright //181 10 10 0 // Rotate right 10

$frame boss1_weepstart //191 10 10 0 // Weep start 11

$frame boss1_weeploop //201 20 10 1 // Weep loop 12

$frame boss1_weepend //221 10 10 0 // Weep end 13

$frame boss1_rise //231 40 10 1 // Rise 14

$frame boss1_death //271 50 10 0 // Death 15

.float guardian_attack_finished;
.float guardian_facing_time;
.float guardian_frame_time;
.float guardian_attack_time;
.float guardian_rotate_time;
.float guardian_shoot_cnt;

void() ai_face_boss =
{
	self.ideal_yaw = vectoyaw(rorigin(single_player) - rorigin(self));
	ChangeYaw();
};


float(string locsound, float rnd, float vol, float nchannel, float iswav, float atten) bosssound =
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
	r = floor((random() * rnd)) + 1;
	if ((r == self.rsound_cntr))
	{
		r ++;
	}
	if ((r > rnd))
	{
		r = 1;
	}
	self.rsound_cntr = r;
	rsound = ftos(r);
	lsound = strcat(locsound, rsound, soundend);
	sound(self, nchannel, lsound, vol, 0.25);
	sound(self, nchannel+1, lsound, vol, 0.25);
	sound(self, nchannel+2, lsound, vol * 0.2, 0);
	float soundlngt;

	soundlngt = soundlength(lsound);
	return soundlngt;
	//pointsound(self.origin + '0 0 128', lsound, vol, 0);
};

void()projectile_guardian1_think =
{
	if(self.frame < 3)
		self.frame ++;
	if(self.enemy.health < 0)
		self.lifetime = 0;
	//self.count ++;

	if(self.origin ==  self.oldorigin)
	{
		self.think = proj_wretch_explo;
		self.nextthink = time + 0.05;
		return;
	}
		local vector	dir, vtemp;


	if ((self.trinket_touched == 1) && (self.solid != SOLID_BBOX))
	{
		self.clipgroup = 0;		
		self.solid = SOLID_BBOX;
		self.touch = spit_touch;
		self.guardian_shoot_cnt = 0;
	}


	if((self.magnetized >= 1) && (self.trinket_touched == 1))
	{
		self.solid = SOLID_BBOX;
		vtemp = self.enemy.origin + randomvector('-164 -164 -4','164 164 164');
		dir = normalize(vtemp - self.origin);
		float bossproj = boss1_proj2_vel + 92;
		vector wishvel = dir * bossproj;
		self.velocity = wishvel;
		self.magnetized = 0;
	}
	if((self.magnetized >= 1) && (self.guardian_shoot_cnt >= 1) && (self.enemy.classname == "player"))
	{

		float min_dist_z =  max (self.origin_z,self.enemy.origin_z) - min (self.origin_z,self.enemy.origin_z);
		float zdist = self.ammo_revolver;
				if(visiblebox(self.enemy) && (min_dist_z < zdist))
		{
			vtemp = self.enemy.origin + '0 0 10';
			dir = normalize(vtemp - self.origin);
			self.oldvelocity = self.velocity;

			if(self.owner.bosscnt == 2)
				float extravel = 64;
			if(self.owner.bosscnt == 1)
				extravel = 128;

			float bossproj = boss1_proj2_vel + extravel;

			vector wishvel = dir * bossproj;
			self.velocity_x = (self.oldvelocity_x * 0.5)  +  (wishvel_x * 0.5);
			self.velocity_y = (self.oldvelocity_y * 0.5) +  (wishvel_y * 0.5);
			if(self.magnetized == 2 )
				self.velocity_z =( (self.oldvelocity_z * 0.5) +  (wishvel_z * 0.5) );
			else				
				self.velocity_z = (self.oldvelocity_z * 0.7) +  (wishvel_z * 0.3);

			self.nextthink = time + 0.05;
			self.guardian_shoot_cnt --;
		}
		else
			self.nextthink = time + 0.25;
		self.angles = vectoangles(self.velocity);
	}
	else
		self.nextthink = time + 0.05;

	self.angles = vectoangles(self.velocity);

	if(self.lifetime < time)
		self.think = proj_wretch_explo;
	else
		self.think = projectile_guardian1_think;

	self.oldorigin = self.origin;


};	

void()projectile_guardian1_prethink =
{
	self.movetype = MOVETYPE_FLYMISSILE;
	self.effects = 0;
	self.think = projectile_guardian1_think;
	self.nextthink = time;
};

void(vector org,vector dir, float proj_angles, entity ownerproj, float proj_type,float projdelay, string tagname) launch_projectile_guardian1 = 
{ 
	local entity guardian1_projectile;
	monstersound3("enemies/wretch/fire", 5, CHAN_AUTO);	
	guardian1_projectile = spawn();	
	guardian1_projectile.origin = org;
	if((ownerproj.magnetized != 0))
		guardian1_projectile.magnetized = ownerproj.magnetized;

	guardian1_projectile.owner = ownerproj;
	guardian1_projectile.effects = EF_NODRAW;
	guardian1_projectile.wrathflags += FL_PROJECTILE;
	guardian1_projectile.solid = SOLID_TRIGGER;
	guardian1_projectile.scale = 2;
	if(proj_type == 1)
		guardian1_projectile.scale = 3;
	if(proj_type == 2)
		guardian1_projectile.scale = 4;
		
    self.clipgroup = 8;    
	guardian1_projectile.traileffectnum = particleeffectnum("proj_guardian1_trail1");

	guardian1_projectile.colormod = '3 0.2 0.2';

	if(proj_type == 1)
	{
		guardian1_projectile.colormod = '0.3 0.9 1.6';
		guardian1_projectile.traileffectnum = particleeffectnum("proj_guardian1_trail2");
	}

	if(proj_type == 2)
	{
		guardian1_projectile.colormod = '0.3 0.9 1.6';
		guardian1_projectile.traileffectnum = particleeffectnum("proj_guardian1_trail3");
	}




	guardian1_projectile.touch = projectile_touch_wre;
	guardian1_projectile.classname = "bossprojectile";
	guardian1_projectile.lifetime  = time + 7.5;
	guardian1_projectile.enemy = ownerproj.enemy;

	local entity oself;oself = self;self = guardian1_projectile;
	sound7(self, CHAN_WEAPON, "enemies/wraith/proj_loop1.ogg", 1, 0.25, 80 + random() *30, 0);
	self = oself;

	setmodel(guardian1_projectile, "models/projectiles/proj_wretch.md3");
	setsize(guardian1_projectile, '-12 -12 -12', '12 12 12');

	guardian1_projectile.angles = vectoangles(dir) ;

	float angle_y_compensation;
	if(tagname == "tag_left_hand")
		angle_y_compensation = -2;
	if(tagname == "tag_right_hand")
		angle_y_compensation = 1.79;

	guardian1_projectile.angles_y -= (proj_angles * 0.25) + angle_y_compensation ;
	makevectors2 (guardian1_projectile.angles);
	dir = v_forward;
	float extravel;
	if(ownerproj.bosscnt == 2)
		extravel = 128;
	if(ownerproj.bosscnt == 1)
		extravel = 256;




	guardian1_projectile.velocity = dir * (boss1_proj1_vel + extravel);

	if(guardian1_projectile.magnetized >= 1)
	{

		float zdist = max(ownerproj.origin_z,ownerproj.enemy.origin_z) -   min(ownerproj.origin_z,ownerproj.enemy.origin_z);


		guardian1_projectile.ammo_revolver = 192;
		if(zdist > 500)
		guardian1_projectile.ammo_revolver = 512;
	
	  	guardian1_projectile.velocity = dir * (boss1_proj2_vel);
		guardian1_projectile.guardian_shoot_cnt = boss1_proj2_homingcount; 
	}
	guardian1_projectile.oldvelocity = guardian1_projectile.velocity;
	guardian1_projectile.think = projectile_guardian1_prethink;
	guardian1_projectile.nextthink = time + (projdelay);
};

void(string tagname, float offset,float projdelay) guardian_attack_spread =
{
	ai_face_boss();
	self.colormod = '0 0 0';
	float playerspeed = (vlen (self.enemy.velocity)) * 0.5;
	vector nextpos = (normalize (self.enemy.velocity)) * playerspeed ;	



	vector newplayerorg =self.enemy.origin + nextpos;	


	vector org = tag_origin(tagname, self);
	makevectors (self.angles);

	if(!(custom_infront(self.enemy,self.angles, self.origin, 16)))
	{
		newplayerorg =v_forward * 1024;	
		newplayerorg_z = self.enemy.origin_z;	
	}	
	vector aim_org = self.origin;
	aim_org_z = org_z;

	vector player_offset = '0 0 12';

	if((self.classname == "boss_guardian2") &&(self.origin_z > (self.enemy.origin_z + 12))) 
		newplayerorg_z += random (24,64);
	else
	{	
		if(self.origin_z > (self.enemy.origin_z + 1))
			newplayerorg_z += random (-64,24);
		else
		{
			float distz = single_player.origin_z - self.origin_z;
			if(distz > 500)
				newplayerorg_z += random (-32,32);
			if(distz > 1000)
				newplayerorg_z += random (-12,64);
		}
	}




		newplayerorg_x += random (-32,32);
		newplayerorg_y += random (-32,32);
	if(self.magnetized == 1)
		player_offset += '0 0 92';

	if(self.origin_z < (self.enemy.origin_z + 1))
	{
		if(self.magnetized == 1)
			player_offset += '0 0 256';
		else
		{
			if(self.bosscnt == 1)
				player_offset += '0 0 24';
		}
		if(((self.origin_z + 800) < (self.enemy.origin_z)) && (self.magnetized == 1))
			player_offset += '0 0 186';
	}




	if(self.origin_z > (self.enemy.origin_z + 64)) 
	{
		if(self.bosscnt == 3)
			player_offset = '0 0 -32';
		else
			player_offset = '0 0 -92';

		if(self.magnetized == 1)
		{
			if(self.origin_z > (self.enemy.origin_z + 350)) 
			{				
				player_offset += '0 0 -256';
				self.magnetized = 2;
			}		
			if(self.origin_z > (self.enemy.origin_z + 700)) 
					player_offset += '0 0 -128';
		}	
		else
		{
			if(self.bosscnt == 2)
				player_offset += '0 0 64';
		}
	}

	vector dir = normalize( (newplayerorg +player_offset) - aim_org  );
	org += v_right * (offset * 1.25);
	
	if(tagname == "tag_left_hand")
		org += v_up * (offset * 0.75);
	else
		org += v_up * (offset * -0.75);
	
	float proj_type = 0;
	if(self.vweaponframe == 10)
		proj_type =  1;
	if(self.vweaponframe == 12)
		proj_type =  2;

//void(vector org, float radius, float lifetime, vector color) te_customflash = #417;

	if(self.magnetized == 1)
		te_customflash (org, 256,1,'0.35 0.35 1');
	else
		te_customflash (org, 170,0.75,'1 0.5 0.5');


	launch_projectile_guardian1(org, dir, offset,self,proj_type,projdelay, tagname);
};

.float watching_player;
void() guardian1_float;
void() guardian1_attack;
void()guardian1_scatter_left =
{
	ai_face_boss();

	if(self.guardian_frame_time > time )
	{
		self.think = guardian1_scatter_left;
		self.nextthink = time + 0.01;
		return;
	}	
	if(self.bosscnt >= 3)
		self.guardian_frame_time = time + 0.09;
	if(self.bosscnt == 2)
		self.guardian_frame_time = time + 0.07;
	if(self.bosscnt == 1)
		self.guardian_frame_time = time + 0.04;


	if(self.frame == $boss1_scattleft16)
	{	

		float proj_ammount = boss1_proj1_ammount;
		float proj_angle_dif;
		float proj_delay;
		while (proj_ammount)
		{
			guardian_attack_spread("tag_left_hand",boss1_proj1_angle - proj_angle_dif,proj_delay);
			proj_angle_dif += boss1_proj1_angle;
			proj_delay += 0.075;
			proj_ammount --;
		}

	}


	self.vweaponframe ++;
	self.frame ++;

	if(self.frame == $boss1_scattleft30)
	{

		float attackedfinished;
		if(self.bosscnt == 3)
			attackedfinished = random(1,2);
		if(self.bosscnt == 2)
			attackedfinished = random(0.5,1);
		if(self.bosscnt == 1)
			attackedfinished = random(0.25,0.5);

		self.guardian_attack_finished = time + attackedfinished;
		self.think = guardian1_float;
		self.nextthink = time + 0.1;
	}
	else
	{

		self.think = guardian1_scatter_left;
		self.nextthink = time + 0.01;
	}
};

void()guardian1_scatter_right =
{
	ai_face_boss();
	if(self.guardian_frame_time > time )
	{
		self.think = guardian1_scatter_right;
		self.nextthink = time + 0.01;
		return;
	}	
	if(self.bosscnt >= 3)
		self.guardian_frame_time = time + 0.09;
	if(self.bosscnt == 2)
		self.guardian_frame_time = time + 0.07;
	if(self.bosscnt == 1)
		self.guardian_frame_time = time + 0.04;


	if(self.frame == $boss1_scattright16)
	{	
		float proj_ammount = boss1_proj1_ammount;
		float proj_angle_dif;
		float proj_delay;
		while (proj_ammount)
		{
			guardian_attack_spread("tag_right_hand",-boss1_proj1_angle + proj_angle_dif,proj_delay);
			proj_angle_dif += boss1_proj1_angle;
			proj_delay += 0.075;
			proj_ammount --;
		}
	}


	self.vweaponframe ++;
	self.frame ++;




	if(self.frame == $boss1_scattright30)
	{
		float attackedfinished;
		if(self.bosscnt == 3)
			attackedfinished = random(1,2);
		if(self.bosscnt == 2)
			attackedfinished = random(0.5,1);
		if(self.bosscnt == 1)
			attackedfinished = random(0.25,0.5);
		self.guardian_attack_finished = time + attackedfinished;
		self.think = guardian1_float;
		self.nextthink = time + 0.1;
	}
	else
	{

		self.think = guardian1_scatter_right;
		self.nextthink = time + 0.01;
	}

};
float(vector a)behindapillar;
void()guardian1_hurl_left =
{
	ai_face_boss();
	if(self.guardian_frame_time > time )
	{
		self.think = guardian1_hurl_left;
		self.nextthink = time + 0.01;
		return;
	}	
	if(self.bosscnt >= 3)
		self.guardian_frame_time = time + 0.09;
	if(self.bosscnt == 2)
		self.guardian_frame_time = time + 0.07;
	if(self.bosscnt == 1)
		self.guardian_frame_time = time + 0.04;

	if((self.vweaponframe == 10))
	{

		if(custom_infront(self.enemy,self.angles, self.origin, 8))
		{
			guardian_attack_spread("tag_left_hand",-32,0);
			guardian_attack_spread("tag_left_hand",-16,0.1);
			guardian_attack_spread("tag_left_hand", 0,0.2);
			guardian_attack_spread("tag_left_hand", 16,0.3);
			guardian_attack_spread("tag_left_hand", 32,0.4);
		}
		else
		{

			if(behindapillar (self.enemy.origin))
			{
				float r_spread = random();
				if(r_spread < 0.5)
					r_spread = -48;
				else
					r_spread = 48;
			}
			else
				r_spread = random(-12,12);

			guardian_attack_spread("tag_chest",r_spread * 3.25,0);
			guardian_attack_spread("tag_chest",-r_spread * 3.25,0.5);
		}
	}

	self.vweaponframe ++;
	self.frame ++;


	float attackedfinished;
	if(self.bosscnt == 3)
		attackedfinished = random(0,0.5);
	if(self.bosscnt == 2)
		attackedfinished = random(0,0.25);
	if(self.bosscnt == 1)
		attackedfinished = random(0,0.1);

	if(self.frame == $boss1_hurlleft20)
	{
		self.guardian_attack_finished = time + attackedfinished;		
		self.think = guardian1_float;
		self.nextthink = time + 0.1;
	}
	else
	{

		self.think = guardian1_hurl_left;
		self.nextthink = time + 0.01;
	}
};

void()guardian1_hurl_right =
{
	ai_face_boss();
	if(self.guardian_frame_time > time )
	{
		self.think = guardian1_hurl_right;
		self.nextthink = time + 0.01;
		return;
	}	
	if(self.bosscnt >= 3)
		self.guardian_frame_time = time + 0.09;
	if(self.bosscnt == 2)
		self.guardian_frame_time = time + 0.07;
	if(self.bosscnt == 1)
		self.guardian_frame_time = time + 0.04;

	if(self.vweaponframe == 10)
	{
		if(custom_infront(self.enemy,self.angles, self.origin, 8))
		{
			guardian_attack_spread("tag_left_hand",-32,0);
			guardian_attack_spread("tag_left_hand",-16,0.1);
			guardian_attack_spread("tag_left_hand", 0,0.2);
			guardian_attack_spread("tag_left_hand", 16,0.3);
			guardian_attack_spread("tag_left_hand", 32,0.4);
		}
		else
		{
		if(behindapillar (self.enemy.origin))
		{
			float r_spread = random();
			if(r_spread < 0.5)
				r_spread = -48;
			else
				r_spread = 48;
		}
		else
			r_spread = random(-12,12);

			guardian_attack_spread("tag_chest",r_spread * 3.25,0);
			guardian_attack_spread("tag_chest",-r_spread * 3.25,0.5);
		}
	}

	self.vweaponframe ++;
	self.frame ++;


	float attackedfinished;
	if(self.bosscnt == 3)
		attackedfinished = random(0,0.5);
	if(self.bosscnt == 2)
		attackedfinished = random(0,0.25);
	if(self.bosscnt == 1)
		attackedfinished = random(0,0.1);

	if(self.frame == $boss1_hurlright20)
	{
		self.guardian_attack_finished = time + attackedfinished;	
		self.think = guardian1_float;
		self.nextthink = time + 0.1;
	}
	else
	{

		self.think = guardian1_hurl_right;
		self.nextthink = time + 0.01;
	}
};
float  (vector ent_org)behindapillar
{
	local vector spot1, spot2;
	spot1 = self.origin;
	spot1_z = ent_org_z + 16;
	spot2 = ent_org + '0 0 16';

	tracebox(spot1,'-4 -4 -4', '4 4 4', spot2, TRUE, world); 

	if (trace_fraction == 1)
		return FALSE;
	return TRUE;

};

void()guardian1_shot =
{
	ai_face_boss();
	if(self.guardian_frame_time > time )
	{
		self.think = guardian1_shot;
		self.nextthink = time + 0.01;
		return;
	}	
	if(self.bosscnt >= 3)
		self.guardian_frame_time = time + 0.09;
	if(self.bosscnt == 2)
		self.guardian_frame_time = time + 0.07;
	if(self.bosscnt == 1)
		self.guardian_frame_time = time + 0.04;
	
	if(behindapillar (self.enemy.origin))
	{
		float r_spread = random();
		if(r_spread < 0.5)
			r_spread = -48;
		else
			r_spread = 48;
	}
	else
		r_spread = random(-12,12);


	if(self.vweaponframe == 12)
	{
		if(self.bosscnt == 3)
			guardian_attack_spread("tag_chest",r_spread,0);

		if(self.bosscnt == 2)
		{
			guardian_attack_spread("tag_chest",r_spread * 1.25,0);
			guardian_attack_spread("tag_chest",-r_spread * 1.25,0.5);
		}

		if(self.bosscnt == 1)
		{
			float r = random();
			if(r > 0.5)
			{
				guardian_attack_spread("tag_chest",r_spread * 0.75,0);
				guardian_attack_spread("tag_chest",-r_spread * 2.5,0.5);
				guardian_attack_spread("tag_chest",r_spread * 2.5,0.75);
			}
			else
			{
				guardian_attack_spread("tag_chest",-r_spread * 0.75,0);
				guardian_attack_spread("tag_chest",-r_spread * 2.5,0.5);
				guardian_attack_spread("tag_chest",r_spread * 2.5,0.75);
			}

		}

	}
	self.vweaponframe ++;
	self.frame ++;
	self.magnetized = 1;
	if(self.frame == $boss1_shot20)
	{
		self.guardian_attack_finished = time + random(self.bosscnt * 0.2,self.bosscnt * 0.7) + 0.2;
		self.think = guardian1_float;
		self.nextthink = time + 0.15;
	}
	else
	{

		self.think = guardian1_shot;
		self.nextthink = time + 0.01;
	}
};


void()guardian1_attack = 
{
	self.magnetized = 0;

	if ( self.bosscnt == 3)
		self.ammo_shells = 4;
	if ( self.bosscnt == 2)
		self.ammo_shells = 8;

	self.guardian_shoot_cnt = 0;
	self.vweaponframe = 0;
	float r = random();
	float r2 = random();
	if (self.bosscnt == 2)
		float diceshot = 0.1;
	if (self.bosscnt == 1)
		float diceshot = 0.2;
	
	if(((self.watching_player < time) || ( r2 < diceshot)) && (self.enemy.timefly < time))
	{	
		self.think = guardian1_shot;
		self.frame = $boss1_shot1; 
		bosssound("enemies/boss1/voicing_blue", 3, 1, CHAN_VOICE, 0, 0.05);
		self.watching_player = 0;
	}	
	else
	{
		if(r < 0.5)
		{
			self.frame = $boss1_scattright1;
			self.think = guardian1_scatter_right;
			bosssound("enemies/boss1/voicing_red", 8, 1, CHAN_VOICE, 0, 0.05);
		}
		else 
		{
			bosssound("enemies/boss1/voicing_red", 8, 1, CHAN_VOICE, 0, 0.05);
			self.frame = $boss1_scattleft1;	
			self.think = guardian1_scatter_left;
		}
	}

	self.pframe = 0;
	ai_face_boss();
	self.nextthink = time;
};

void() guardian1_rise =
{
	self.frame = $boss1_rise;
	if(self.target)
	{
		SUB_UseTargets();
		self.target = "";
	}
	self.timefly = 0;
	self.attached_cloud.count = 0.01;	

	/*
	if(self.bosscnt == 2) 
		self.health = 19999;	
	if(self.bosscnt == 1) 
		self.health = 9999;	
	*/


	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_FLY;
	self.bosspain_finished = 0;
	self.velocity = '0 0 128';
	self.think = guardian1_float;
	self.nextthink = time + 5;
};

void() guardian1_weep_end =
{
	self.frame = $boss1_weepend;
	self.think = guardian1_float;
	self.attached_cloud.count = 0.01;
	self.nextthink = time + 1;
};

void() guardian1_weep_loop =
{
	self.frame = $boss1_weeploop;//$boss1_weepc_loop;
	if (self.bosspain_finished < time)
	{
		if(self.bosscnt == 3) 
			self.health = 25000;	
		if(self.bosscnt == 2) 
			self.health = 15000;	
		if(self.bosscnt == 1) 
			self.health = 7500;	
		setsize (self,'-80 -80 -128','80 80 256');
		self.think = guardian1_weep_end;
	}
	else
	{
		if(self.timefly == 1)
		{	
			setsize (self,'-80 -80 -128','80 80 256');
			self.think = guardian1_rise;
		}
		else
			self.think = guardian1_weep_loop;
	}
	pointparticles(particleeffectnum("boss1_weep_particles"), self.origin,'0 0 0', 1);


	self.nextthink = time + 0.1;
};

void() guardian1_weep=
{
	self.bosspain_finished = time + 10;
	self.attached_cloud.count = 0.1;
	self.takedamage = 0;
	self.frame = $boss1_weepstart;//$boss1_weepc;
	setsize (self,'-72 -72 -128','72 72 200');
	self.solid = SOLID_BBOX;
	self.think = guardian1_weep_loop;
	self.nextthink = time + 1;
};

void() guardian1_rotate_left =
{
	ai_face_boss();
	self.frame = $boss1_rotleft;


	if((self.yaw_speed >= 1.5) && (custom_infront(self.enemy,self.angles, self.origin, 25)))
	self.yaw_speed -= 0.01;

	if((custom_infront(self.enemy,self.angles, self.origin, 8)) && (self.guardian_rotate_time < time))
	{
		self.think = guardian1_attack;
		self.nextthink = time + 0.01;
	}
	else
	{
		self.think = guardian1_rotate_left;
		self.nextthink = time + 0.01;

	}
	//self.colormod = '1 0 0';
};

void() guardian1_rotate_right =
{
	ai_face_boss();
	self.frame = $boss1_rotright;

	if((self.yaw_speed >= 1.5) && (custom_infront(self.enemy,self.angles, self.origin, 25)))
	self.yaw_speed -= 0.01;

	if((custom_infront(self.enemy,self.angles, self.origin, 8)) && (self.guardian_rotate_time < time))
	{
		self.think = guardian1_attack;
		self.nextthink = time + 0.01;
	}
	else
	{
		self.think = guardian1_rotate_right;
		self.nextthink = time + 0.01;
	}
};

void() guardian1_rotate =
{
	float rotate_left;
	
	makevectors (self.angles);
	self.yaw_speed = 3;
	ai_face_boss();

	float distr, distl;
	distr = vlen((self.origin + v_right * 30) - self.enemy.origin);

	distl = vlen((self.origin + v_right * -30) - self.enemy.origin);

	if(distl > distr)
		rotate_left = 1;	
	else	
		rotate_left = 0;	

	if(rotate_left == 1)
		self.think = guardian1_rotate_left;
	else
		self.think = guardian1_rotate_right;

	self.guardian_rotate_time = time + 1.05;
	self.nextthink = time + 0.05;

};

void() guardian1_float =
{
	self.frame = $boss1_float;
	self.yaw_speed = 0.75;
	self.enemy = single_player;

	if(self.takedamage != DAMAGE_AIM)
	{
		self.takedamage = DAMAGE_AIM;
		self.pipes.health = 5;
		self.pipes.takedamage = 0;
		self.solid = SOLID_BBOX;
	}

	if(self.guardian_facing_time < time)
	{
		ai_face_boss();
		self.guardian_facing_time = time + 0.01; 
	}
	if((self.bosscnt == 3) && (self.health < 20000))
	{
		bosssound("enemies/boss1/weak", 3, 1, CHAN_VOICE, 0, 0.05);
		self.nextthink = time + 0.05;
		self.think = guardian1_weep;
		return;
	}
	
	if((self.bosscnt == 2) && (self.health < 10000))
	{
		bosssound("enemies/boss1/weak", 3, 1, CHAN_VOICE, 0, 0.05);
		self.nextthink = time + 0.05;
		self.think = guardian1_weep;
		return;
	}

	if((self.bosscnt == 1) && (self.health < 2500))
	{
		bosssound("enemies/boss1/weak", 3, 1, CHAN_VOICE, 0, 0.05);
		self.nextthink = time + 0.05;
		self.think = guardian1_weep;
		return;
	}

	if(visible(single_player) && (self.watching_player < time))
		self.watching_player = time + 1;

	if(single_player.origin_z > self.origin_z)
	{
		float r = random();
		float distz = single_player.origin_z - self.origin_z;
		if((distz > 500) && (distz <= 1000))
		{
			if (r < 0.33)
				self.watching_player = 0;
		}
		if(distz > 1000)
		{
			if (r < 0.5)
				self.watching_player = 0;
		}
	}

	if(single_player.origin_z < self.origin_z)
	{
		float r = random();
		float distz = self.origin_z - single_player.origin_z;
		if((distz > 500) && (distz <= 1000))
		{
			if (r < 0.33)
				self.watching_player = 0;
		}
		if(distz > 1000)
		{
			if (r < 0.5)
				self.watching_player = 0;
		}
	}

	if(custom_infront(self.enemy,self.angles, self.origin, 90))
	{
		if(self.guardian_attack_finished < time)
			self.think = guardian1_attack;
		else
			self.think = guardian1_float;
	}
	else
		self.think = guardian1_rotate;
	
	self.nextthink = time + 0.01;
};

void() guardian1_wakeupb =
{
	self.yaw_speed = 1.65;
	ai_face_boss();

	if(self.watching_player < time)
	{
		self.guardian_attack_finished = time  + random (1);
		self.watching_player = time + 3.5;
		self.think = guardian1_float;
	}
	else
	{
		self.think = guardian1_wakeupb;	
	}
	self.nextthink = time  + 0.01;
};

void() guardian1_wakeupa =
{
	self.frame = $boss1_wakeup;
	self.attached_cloud.count = 0.01;
	self.watching_player = time + 1.5;
	self.nextthink = time  + 0.5;
	self.think = guardian1_wakeupb;
	bosssound("enemies/boss1/sight", 1, 1, CHAN_VOICE, 0, 0.05);
};

void() guardian1_idle = 
{
	self.frame = $boss1_idle;
	self.bosscnt = 3;

	if((visible(single_player)) && (self.using == 1))
		player_enemy();

	if(!self.enemy)
		self.think = guardian1_idle;
	else
		self.think = guardian1_wakeupa;
	if (self.idle_time < time)
		self.idle_time = time + bosssound("enemies/boss1/cry", 5, 1, CHAN_VOICE, 0, 0.05);
	self.nextthink = time + 0.1;
};
#if 0
void()boss3_summon;
void() boss3_walk;
.float boss3summonwait;
.vector boss3_nextangles;
#endif
.string killtargetname;


void()boss2_path_determine_oldenemies =
{
	local entity head, near;
	local float dist, low;
	low = 9999;	
	head = find(world, classname, "boss_path");
	while (head)
	{
		if(((custom_infront(head,self.angles + '0 -90 0', self.origin, 90)) == 1) && (head.spawnflags & 1))
		{
			 
			dist = vlen(head.origin - self.origin);
			if ((dist < low) && (head != self.enemy))
			{
				low = dist;
				near = head;
			}
		}
		head = find(head, classname, "boss_path");
	}
	if (near)
	self.oldenemy = near;
}
void()boss2_path_determine_enemies =
{
	determine_subangleb();

	local entity head, near;
	local float dist, low;
	low = 9999;	
	head = find(world, classname, "boss_path");
	while (head)
	{
		if(((custom_infront(head,self.angles + '0 90 0', self.origin, 90)) == 1) && (head.spawnflags & 1))
		{
			dist = vlen(head.origin - self.origin);
			if (dist < low)
			{
				low = dist;
				near = head;
			}
		}
		head = find(head, classname, "boss_path");
	}
	if (near)
	{
		self.enemy = near;
	}

		self.think = boss2_path_determine_oldenemies;
		self.nextthink = time + random(0.1,0.3);
};
void()boss_path_touch =
{

	if(other.classname == "boss_guardian1")
	{
		other.target = self.target;
		other.velocity = '0 0 0';
		other.bosscnt --;
		other.bosspain_finished = 0;
		other.solid = SOLID_BBOX;
		other.movetype = MOVETYPE_NONE;
		other.takedamage = DAMAGE_AIM;
		other.think = guardian1_float;
		other.nextthink = time + 0.1;

		if(other.bosscnt == 2) 
			other.health = 20000;	
		if(other.bosscnt == 1) 
			other.health = 10000;	


		remove(self);
	}
	#if 0 // Reki: this is unused by boss3 now
	if((other.classname == "boss_guardian3") && (other.target != self.target))
	{
		other.velocity = '0 0 0';
		other.pipes = world; 
		other.target = self.target;
		other.target2 = self.target2;

		local entity boss3;
		boss3 = find(world, classname, "boss_guardian3");
		if(self.using != 1)
		{
			remove(self);
			return;
		}
		if(self.spawnflags & 1)
		{
			other.think = boss3_summon;
			other.boss3summonwait = self.lifetime;
		}
		else
			other.think = boss3_walk;
		other.touchtime = time + 0.3;
		other.boss3_nextangles = self.angles;
		other.boss3_nextangles_y = floor(other.boss3_nextangles_y);
		other.nextthink = time + 0.1;
	}
	#endif


	if(other.classname == "boss_guardian2")
	{


		if(other.lastpathed != self)
		{
			if (other.lefty)
				other.pipes = self.oldenemy;
			else
				other.pipes = self.enemy;
			other.lastpathed = self;
			other.ldorigin = self.origin;
			other.dest = normalize(other.pipes.origin - other.origin);
		}

	}
};


void()boss_path =
{
	setmodel(self,"");
	self.solid = SOLID_TRIGGER;
	setsize (self,'-8 -8 0','8 8 16');

	self.touch = boss_path_touch;
	self.use = toggle_use;
	self.target2 = self.target;
	if(!self.using)
		self.using = 1;
	if(self.spawnflags & 1)	
	{
		setsize (self,'-8 -8 -256','8 8 256');
		self.think = boss2_path_determine_enemies;
		self.nextthink = time;
	}

};
void()guardian_bbox_think;


void()boss1_head_die =
{

	pointparticles(particleeffectnum("boss1_head"), self.origin,'0 0 0', 1);
	if(self.owner.bosscnt != 1) 
	{

		bosssound("enemies/boss1/pain", 3, 1, CHAN_VOICE, 0, 0.05);
		te_customflash(self.origin, 512, 1,'3 2 0.15');
		self.target = other.target;
		self.owner.timefly = 1;
		self.pflags =0;
		self.think = guardian_bbox_think;
		self.nextthink = time + 0.025;
	}
	else
	{
		remove(self);
		self.owner.health = 0;
		Killed (self.owner, single_player,0);
	}
};


void() guardian_bbox_think =
{

	if((self.owner.bosspain_finished > time))
	{
		if(self.effects != EF_ADDITIVE + 512)
		{
			self.pflags =129;
			self.light_lev = 128;
			self.style = 1;
			self.color ='2 1.3 0.3';
			self.solid = SOLID_BBOX;
			self.takedamage = DAMAGE_AIM;
			self.effects = EF_ADDITIVE + 512;
			self.owner.takedamage = 0;
			bossvulnerable = 0;
			//self.owner.vgear.count = 0.5;
		}	

	}
	else
	{
		if(self.effects != EF_NODRAW)
		{
			self.pflags = 0;
			self.effects = EF_NODRAW;
			self.solid = SOLID_TRIGGER;
			self.takedamage = 0;
			self.effects = EF_NODRAW;
			self.owner.takedamage = DAMAGE_AIM;
			bossvulnerable = 1;
			//self.owner.vgear.count = 0.025;
		}
	}

	vector org = tag_origin("tag_face",self.owner);
	setorigin(self,org);
	self.think = guardian_bbox_think;
	self.nextthink = time + 0.05;

};


void() boss1gib_think  = 
{

	if(self.count != 1)
	{
		self.skin ++;
		if(self.count >= 3)
			self.count = 1;
	}
	else
	{
		self.skin --;
		if(self.count <= 1)
			self.count = 0;
	}
	self.think = boss1gib_think;
	self.nextthink =  time + 0.1;
};
void(vector org, vector vel) SpawnBossGib2 = 
{
 	local entity gib;
	gib = spawn();
	setorigin(gib, org);
	setmodel(gib, "particles/explo/explo_blood4.md3");
	gib.scale = random (0.1,0.5);
	gib.solid = SOLID_TRIGGER;
	gib.alpha = 0.35;
	setsize(gib,'-1 -1 -1','1 1 1');
	gib.movetype = MOVETYPE_TOSS;
	gib.velocity = vel;
	gib.skin = 1;
	gib.colormod = '2.5 2.5 2.5';
	gib.classname = "finalbossgibs";
	gib.traileffectnum = particleeffectnum("boss1_gib_trail");
	gib.avelocity = vel * (random(-50,50));	
	gib.avelocity_z += random(-256,256);
	gib.think = boss1gib_think;
	gib.nextthink = time + random(0,0.5);
	gib.touch = sgib2_touch;
};

void(vector org, vector vel,float tmodel) SpawnBossGib3 = 
{
 	local entity gib;
	gib = spawn();
	setorigin(gib, org);
	if(tmodel == 1)
		setmodel(gib, "models/gibs/gib_small.md3");
	if(tmodel == 2)
		setmodel(gib, "models/gibs/gib_med.md3");
	if(tmodel == 3)
		setmodel(gib, "models/gibs/gib_large.md3");
	gib.scale = random (1,1.5);
	gib.solid = SOLID_TRIGGER;
	setsize(gib,'-1 -1 -1','1 1 1');
	gib.movetype = MOVETYPE_TOSS;
	gib.velocity = vel;

	gib.traileffectnum = particleeffectnum("bloodtraildense");
	gib.think = alphafade;
	gib.nextthink = time + random(2,3);
};

.string deadtarget;

void() boss1_die_end =
{


	float lgibcount = 12;
	vector tagorg = self.origin;

	while(lgibcount > 0)
	{
		vector org;
		org_x = random(self.mins_x, self.maxs_x);
		org_y = random(self.mins_y, self.maxs_y);
		org_z = random(self.mins_z, self.maxs_z);
		org += self.origin;
		vector dir = normalize( org - self.origin);
		vector vel = dir *  random(368,768);
		vel_z += 192;
		SpawnBossGib3(org,vel,1);
		SpawnBossGib3(org,vel,2);
		SpawnBossGib3(org,vel,3);
		lgibcount --;
	}
	
	lgibcount = 32;

	while(lgibcount > 0)
	{
		org_x = random(self.mins_x, self.maxs_x);
		org_y = random(self.mins_y, self.maxs_y);
		org_z = random(self.mins_z, self.maxs_z);
		org += self.origin;
		vector dir = normalize( org - self.origin);
		vector vel = dir *  random(512,1024);
		vel_z += 256;
		SpawnBossGib2(org,vel);
		lgibcount --;
	}
	float particleclount = 96;
	while(particleclount > 0)
	{
		entity secret_mark2;
		secret_mark2 = spawn();
		org_x = random(self.mins_x, self.maxs_x);
		org_y = random(self.mins_y, self.maxs_y);
		org_z = random(self.mins_z, self.maxs_z);
		org += self.origin;

		secret_mark2.origin = org;

		float r = random();
		if(r > 0.3)
			secret_mark2.colormod = '0.175 0.35 1';
		else
			secret_mark2.colormod = '0.25 0.25 0.75';
		secret_mark2.scale = random(7,15);
		secret_mark2.alpha = random(1.5,3);
		setmodel(secret_mark2,"models/artifacts/effects/revelation_particle.md3");
		secret_mark2.wrathflags += FL_GARBAGE;
		secret_mark2.effects = 512 + EF_DOUBLESIDED +EF_ADDITIVE;
		secret_mark2.solid = SOLID_NOT;
		secret_mark2.movetype = MOVETYPE_NOCLIP;
		makevectors (single_player.v_angle);

		secret_mark2.velocity = v_right * random(-256,256) * 7;

		secret_mark2.velocity_z = random(-256,256)* 3;

		secret_mark2.avelocity_z = random(-512,512);
		secret_mark2.angles_x = random (0,360);
		secret_mark2.angles_y = random (0,360);
		secret_mark2.angles_z = random (0,360);
		//setorigin (secret_mark2,dir);
		secret_mark2.think = spawned_relevelation_particles_think;
		secret_mark2.nextthink = time + 1.5; 
		particleclount --;
	}
	spawn_shaker(self,32,1.25,768);  

	te_customflash (self.origin,512,0.55,'0.9 0.9 1');
 	stuffcmd (single_player, "bf 0.95 0.95 1 0.9 0.45\n");
	self.attached_cloud.count = 0.05;
	self.think = SUB_Remove;
	self.effects = EF_NODRAW;
	//self.attached_cloud.count = 0;
	self.nextthink = time + 20;
};

void() boss_lightning_think =
{
		float rls = rint (random(1,3));
		if (rls == 1)
			string tnoise = self.noise;
		if (rls == 2)
			tnoise = self.noise1;
		if (rls == 3)
			tnoise = self.noise2;
		sound7(self, CHAN_AUTO,tnoise, 1, 0.001, random(80,120),0);

		self.cnt = 2;
		self.think = lightningt_think;
		self.nextthink = time;
};

void() boss1_die_pre = 
{
	entity boss1lightning = spawn();
	setmodel(boss1lightning,"");
	boss1lightning.noise = "env/amb/thunder1.ogg";
	boss1lightning.origin = self.origin;	
	boss1lightning.noise1 = "env/amb/thunder2.ogg";
	boss1lightning.noise2 = "env/amb/thunder3.ogg";
	boss1lightning.using = 1;
	boss1lightning.think = boss_lightning_think;
	boss1lightning.nextthink = time;
	sound7(self, CHAN_AUTO, "enemies/stricken/explode.ogg", 1, 0.1,75,0);
	pointparticles(particleeffectnum("boss1_dead_particles"), self.origin,'0 0 0', 1);
	killed_monsters ++;
	WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
	self.think = boss1_die_end;
	self.nextthink = time + 0.0125;
};

void()bosssoulthink =
{
	
	
	if(self.origin_z >= 3240)
 	{
		self.owner.attached_cloud.count = 0;
		self.pipes.think = alphafade;
		self.pipes.nextthink = time;
		self.think = alphafade;
		soundwrath(self, CHAN_VOICE, "env/amb/thunder2.ogg", 0.53, 0.01, 50, 0, 0);
		self.alpha =1;
		te_customflash (self.origin, 4096,1,'0.35 0.35 1');
		if(self.pipes.alpha > 1)
			self.pipes.alpha =1;
		self.nextthink = time;
		return;
	}
	else
	{
		if(self.pipes.alpha < self.alpha)
		self.pipes.alpha += 0.005;
		self.velocity_z += 8;
		self.pipes.velocity = self.velocity;
		self.think =bosssoulthink;
		self.nextthink = time + 0.05;
	}
};

void() prebosssoulthink = 
{
	//self.alpha += 0.005;
	self.colormod_x = self.alpha;
	self.colormod_y = self.alpha;
	self.colormod_z = self.alpha;
	self.light_lev += 5;
	if(time < self.lifetime)
	{
		self.think = prebosssoulthink;
		self.nextthink = time + 1;
	}
	else
	{
		self.think = bosssoulthink;		
		entity siphon_effect = spawn();
		siphon_effect.origin = self.origin;
		siphon_effect.alpha = 0.01;
		siphon_effect.skin = 1;
		siphon_effect.effects = 32;
		siphon_effect.alphatime = 1;
		siphon_effect.scale = self.scale + 0.2;
		siphon_effect.movetype = self.movetype;
		self.pipes = siphon_effect;
		setmodel(siphon_effect, "models/enemies/boss1/boss1_end.md3");
		soundwrath(siphon_effect, CHAN_VOICE, "enemies/keeper/shield_loop.ogg", 0.5, 0.225, 150, 2, 0);
	}

	self.nextthink = time + 0.05;
};

void()model_boss1wave_think =
{
	float final_scale = shockwave_radius / 64;
	float total_cycles = shockwave_time * 40;
	if(!self.cnt)
	{
		self.cnt = total_cycles;
		self.count = 1 / total_cycles;
	}

	self.scale += final_scale / total_cycles;


	self.colormod_x -= 0.03;	
	self.colormod_y -= 0.03;	
	self.colormod_z -= 0.03;	


	self.alpha -= 0.0125;

	if(self.alpha <= 0)
	self.alpha = -1;


	if(self.scale >= final_scale)
		self.think = SUB_Remove;
	else
		self.think = model_boss1wave_think;
	self.nextthink = time + 0.025;

};

void() boss1_die_think = 
{
	
	if(self.attached_cloud.count == 0.1)
		self.attached_cloud.count = 0.01;
	else
		self.attached_cloud.count = 0.1;

	//self.vgear.count = 3.25;
	self.colormod_x += 0.0125;
	self.colormod_y += 0.0125;
	self.colormod_z += 0.01255;
	self.light_lev += 16;	
	self.think = boss1_die_pre;
	
	local vector tagorg;
	local float tagindex;
	tagindex = gettagindex(self, "tag_neck");
	tagorg = gettaginfo(self, tagindex);
	makevectors2 (self.angles);
	pointparticles(particleeffectnum("boss1_gib_particles"), tagorg,v_forward * 128, 1);



	if(self.lifetime < time)
	{
		entity model = spawn();
		sound7 (self, CHAN_AUTO, "items/artifacts/artifactA_end.ogg",1, 0.5,random(50,70),0);
		model.origin = self.origin;
		setmodel (model,"models/artifacts/effects/orb_shockwave1.md3");
		//model.owner = shockwave;
		model.scale = 0.1;
		model.colormod = '3 3 3';
		model.alpha = 0.5;
		model.think = model_boss1wave_think;
		model.nextthink = time;

		entity siphon_effect = spawn();
		siphon_effect.origin = self.origin + '0 0 110';
		setmodel(siphon_effect, "models/enemies/boss1/boss1_end.md3");
		siphon_effect.movetype = MOVETYPE_NOCLIP;
		siphon_effect.velocity = '0 0 0';
		siphon_effect.owner = self;
		siphon_effect.scale = 10;
		siphon_effect.colormod = '1 1 1';
		siphon_effect.color = '0.5 0.5 0.95';
		siphon_effect.alpha = 0.85;
		siphon_effect.effects = 32;
		siphon_effect.pflags =129;
		siphon_effect.light_lev = 0;
		siphon_effect.style = 1;
		siphon_effect.alphatime = 1;
		siphon_effect.lifetime = time + 5.65;
		soundwrath(siphon_effect, CHAN_VOICE, "enemies/keeper/shield_start1.ogg", 0.5, 0.225, 150, 0, 0);
		siphon_effect.think = prebosssoulthink;
		siphon_effect.nextthink = time + 1.25;
		self.think = boss1_die_pre;
		self.nextthink = time;
	}
	else
	{
		self.think = boss1_die_think;
		self.nextthink = time + 0.05;
	}
};


void() boss_copymodel_think =
{
	if(self.scale > 2)
	{
		self.scale = 1;
		self.alpha = 0.5;
	}

	if(self.lifetime < time)
	{
		remove(self);
		return;
	}
	self.scale  += 0.025;
	self.alpha -= 0.0125;
	self.glowmod = self.owner.glowmod;
	self.think = boss_copymodel_think;
	self.cnt = self.cnt * 0.85; 
	self.nextthink = time + self.cnt;
};

void() boss1_die =
{
	entity copymodel = spawn();
	setmodel(copymodel,"models/enemies/boss1/guardian.md3");
	copymodel.frame = $boss1_death;
	copymodel.origin = self.origin;
	copymodel.angles = self.angles;
	copymodel.effects = 512;
	copymodel.alpha = 0.5;
	copymodel.colormod = '0.7 0.7 1';
	copymodel.scale = 1;
	copymodel.cnt = 0.1;
	copymodel.owner = self;
	copymodel.movetype = MOVETYPE_FLY;
	copymodel.avelocity = '0 180 0';
	copymodel.think = boss_copymodel_think;
	copymodel.nextthink = time;
	copymodel.lifetime = time + 5.2;
	self.colormod = '1 1 1';
	spawn_shaker(self,10,6,768);  
	self.pflags =129;
	self.light_lev = 0;
	self.style = 1;
	self.color ='0.5 0.5 1';

	self.frame = $boss1_death;
	remove(self.pipes);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	self.takedamage = 0;
	self.enemy = world;
	self.target = self.deadtarget;	
	self.avelocity = '0 180 0';
	sound(self, CHAN_VOICE, "enemies/boss1/die1.ogg", 1, 0.05);
	SUB_UseTargets();
	self.think = boss1_die_think;
	self.nextthink = time + 0.4;
	self.attached_cloud.count = 0.01;
	self.lifetime = time + 5.4;

};
void() fog_controller_think = 
{
	float fog_intensity;
	fog_intensity = self.cnt * 0.25;

	if(self.lip == 1)
	string strfog = strcat ("fog ",ftos(fog_intensity)," 0.5 0.5 0.6\n");
	stuffcmd (single_player, strfog);
	if(self.cnt == self.count)
	{
		self.lip = 0;	
	}	
	else
	{

		float fog_value_variation = 0.0025;
		if((self.owner.frame == $boss1_rise))
			fog_value_variation = 0.00025;
		if( (self.owner.effects == EF_NODRAW))
			fog_value_variation = 0.0025;

		if(self.cnt > self.count)
		self.cnt -= fog_value_variation;
		if(self.cnt < self.count)
		self.cnt += fog_value_variation;
		self.lip = 1;
	}
	
	self.nextthink = time + 0.02;
};
void()glowmodcontrollerboss1_think =
{
	if(self.owner.effects == EF_NODRAW)
	{
		remove(self);
		return;
	}


	if(self.cnt != self.count)
	{

		float glow_value_variation = 0.0025;

		if(self.cnt > self.count)
			self.cnt -= glow_value_variation;
		if(self.cnt < self.count)
			self.cnt += glow_value_variation;

		self.owner.glowmod_x = self.cnt;
		self.owner.glowmod_y = self.cnt;
		self.owner.glowmod_z = self.cnt;

	}

	self.think = glowmodcontrollerboss1_think;
	self.nextthink = time + 0.05;

};

void() precache_monster_boss1 =
{
	precache_sound("enemies/boss1/die1.ogg");
	precache_sound("enemies/boss1/filename1");
	precache_sound("enemies/boss1/pain1.ogg");
	precache_sound("enemies/boss1/pain2.ogg");
	precache_sound("enemies/boss1/pain3.ogg");
	precache_sound("enemies/boss1/voicing_blue1.ogg");
	precache_sound("enemies/boss1/voicing_blue2.ogg");
	precache_sound("enemies/boss1/voicing_blue3.ogg");
	precache_sound("enemies/boss1/voicing_red1.ogg");
	precache_sound("enemies/boss1/voicing_red2.ogg");
	precache_sound("enemies/boss1/voicing_red3.ogg");
	precache_sound("enemies/boss1/voicing_red4.ogg");
	precache_sound("enemies/boss1/voicing_red5.ogg");
	precache_sound("enemies/boss1/voicing_red6.ogg");
	precache_sound("enemies/boss1/voicing_red7.ogg");
	precache_sound("enemies/boss1/voicing_red8.ogg");
	precache_sound("enemies/boss1/weak1.ogg");
	precache_sound("enemies/boss1/weak2.ogg");
	precache_sound("enemies/boss1/weak3.ogg");
	precache_sound("enemies/boss1/sight1.ogg");
	precache_sound("enemies/boss1/cry1.ogg");
	precache_sound("enemies/boss1/cry2.ogg");
	precache_sound("enemies/boss1/cry3.ogg");
	precache_sound("enemies/boss1/cry4.ogg");
	precache_sound("enemies/boss1/cry5.ogg");
	precache_model("models/enemies/boss1/guardian.md3");
	precache_model ("models/enemies/boss1/boss1_end.md3");
	precache_sound ("env/amb/thunder1.ogg");
	precache_sound ("env/amb/thunder2.ogg");
	precache_sound ("env/amb/thunder3.ogg");
	precache_sound ("enemies/stricken/explode.ogg");
	precache_sound ("enemies/keeper/shield_loop.ogg");


};


void() boss_guardian1 =
{
    precache_monster_boss1();

	precache_model("models/enemies/boss1/halo_boss1.md3");
	setmodel(self,"models/enemies/boss1/guardian.md3");
	self.classname = "boss_guardian1";
	setsize (self,'-80 -80 -128','80 80 256');
	self.health = 30000;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_BBOX;
	self.yaw_speed = 5;
	local entity bbox = spawn();
	bbox.owner = self;
	bbox.movetype = MOVETYPE_FLY;
	bbox.takedamage = 0;
	bbox.solid = SOLID_TRIGGER;
	bbox.health = 5;
	setmodel (bbox,"models/enemies/boss1/halo_boss1.md3");
	bossvulnerable = 1;
	bbox.effects = EF_NODRAW;
	bbox.alpha = 0.75;
	bbox.scale = 1;
	bbox.frame = 8;
	bbox.th_die = boss1_head_die;	
	bbox.think = guardian_bbox_think;
	self.pipes = bbox;
	makevectors(self.angles);
	bbox.origin = tag_origin("tag_face",self.owner);
	setsize (bbox,'-24 -24 -24','24 24 24');

	bbox.nextthink = time;
	self.use = toggle_use;
	self.using = 0;
	self.frame = $boss1_idle;
	self.th_die = boss1_die;	
	self.think = guardian1_idle;
	self.nextthink = time + 1;
	self.bloody = 2;
	entity fog_controller = spawn();
	fog_controller.owner = self;
	fog_controller.origin = self.origin;
	fog_controller.count = 0.15;
	fog_controller.cnt = 0.1;
	self.attached_cloud = fog_controller;
	fog_controller.think = fog_controller_think;
	fog_controller.nextthink =  time;
	self.glowmod = '0.025 0.025 0.025';

};


