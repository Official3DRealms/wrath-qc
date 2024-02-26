// Reki (May 15 2023)
// models.qc:
// handling for ent updates
// for model ents from SSQC

/* #region Eyeball */
class eyeball_c {
	float sight_distracted;
	float sight_time;
	float sight_timemult;
	vector sight_focus;
	vector sight_random;

	vector angle_constraint;
};

void Eyeball_Predraw(void)
{
	eyeball_c eyeball = (eyeball_c)self;

	vector wanted_focus = getpropertyvec(VF_ORIGIN);
	float focus_speed = 2500;

	#if 1
	float s = sin(eyeball.sight_time);
	if (s < -0.6)
	{
		if (!eyeball.sight_distracted)
		{
			eyeball.sight_distracted = TRUE;
			eyeball.sight_random = wanted_focus;
			eyeball.sight_timemult = 1 + random() * 1.8;

			float intensity = 128;
			float diff = vlen(wanted_focus - eyeball.origin);
			if (diff < 256)
				intensity = 32;
			else
				intensity *= (diff / 1024);

			#define VECSET(x) eyeball.sight_random[x] += crandom() * intensity;
			FORVECTOR
			#undef VECSET
		}

		wanted_focus = eyeball.sight_random;
		focus_speed = 5000 * max(0.4, (s + 0.6) / 0.4);

	}
	else
	#endif
	{
		eyeball.sight_distracted = FALSE;
		eyeball.sight_timemult = 1;
	}

	eyeball.sight_time += frametime * eyeball.sight_timemult;

	vector norm = normalize(wanted_focus - eyeball.sight_focus);
	float diff = vlen(wanted_focus - eyeball.sight_focus);
	focus_speed *= frametime;

	if (diff > focus_speed)
		eyeball.sight_focus += norm * focus_speed;
	else
		eyeball.sight_focus = wanted_focus;

	eyeball.angles = vectoangles(eyeball.sight_focus - eyeball.origin);


	// eyeball angle constraint
	float max_diff;
	float diff;
	// vertical
	max_diff = 20;
	diff = angle_difference(eyeball.angles[0], eyeball.angle_constraint[0]);
	if (fabs(diff) > max_diff)
		eyeball.angles[0] = eyeball.angle_constraint[0] + sign(diff) * max_diff;
	// horizontal
	max_diff = 30;
	diff = angle_difference(eyeball.angles[1], eyeball.angle_constraint[1]);
	if (fabs(diff) > max_diff)
		eyeball.angles[1] = eyeball.angle_constraint[1] + sign(diff) * max_diff;
	//
}

void EntUpdate_Eyeball(float is_new)
{
	eyeball_c eyeball = (eyeball_c)self;

	float sendflags = ReadByte();

	if (sendflags & 0x01)
	{
		setorigin(eyeball, ReadVectorL());
		eyeball.angle_constraint = ReadVectorA();
		eyeball.angle_constraint[0] *= -1;
	}

	if (sendflags & 0x02)
	{
		setmodelindex(eyeball, ReadShort());
	}

	if (sendflags & 0x04)
	{
		self.colormod = ReadVectorB();
		self.alpha = ReadByte() / 255;
		self.scale = ReadByte() / 16;
	}

	if (is_new)
	{
		eyeball.sight_focus = eyeball.origin;
		eyeball.sight_time = random() * 100;
		eyeball.predraw = Eyeball_Predraw;
		eyeball.drawmask = MASK_NORMAL;
	}
}
/* #endregion */



/* #region Boss 3 */
// Reki (July 3 2023)
void Boss3Halo_Destructor()
{
	self.health = -1;
}

void Boss3Halo_Predraw()
{
	self.origin[0] = self.oldorigin[0] + sin((time + 11.3) * 0.2) * 6;
	self.origin[1] = self.oldorigin[1] + sin(time * 0.22) * 6;
	self.origin[2] = self.oldorigin[2] + sin(time * 0.7) * 8;

	if (self.health < 0)
	{
		self.alpha -= (frametime * 5);
		self.scale = slerp(1.2, 0.7, self.alpha);
		self.colormod = lerpVector('1 0.7 0', '1 1 1', self.alpha);

		// cleanup ent once it's done exploding
		if (self.alpha <= 0.01)
			remove(self);
		
		return;
	}

	if (self.effects & EF_NODRAW)
	{
		self.alpha = 0.01;
		return;
	}

	self.alpha = bound(0.01, self.alpha + (frametime * 1.3), 1);
	self.scale = slerp(0.2, 0.6, self.alpha);
}

void EntUpdate_Boss3Halo(float is_new)
{
	float sendflags = ReadByte();

	if (sendflags & 0x01)
	{
		self.oldorigin = ReadVectorL();
	}

	if (sendflags & 0x02)
	{
		self.effects = ReadByte();
	}

	if (self.classname != "boss3halo")
		is_new = TRUE;

	if (is_new)
	{
		self.enttype = ENT::BOSS3HALO;
		self.classname = "boss3halo";
		self.predraw = Boss3Halo_Predraw;
		self.drawmask = MASK_NORMAL;
		setmodel(self, "models/enemies/boss3/halo_boss3.md3");
	}
}

class expandingorb_c {
	float starttime;
	float lifetime;
	
	float radius_start;
	float radius_end;
	float alpha_start;
	float alpha_end;

	float modelradius;

	nonvirtual void() render {
		float frac = (time - starttime) / lifetime;

		if (frac > 1)
		{
			remove(this);
			return;
		}

		this.alpha = slerp(this.alpha_start, this.alpha_end, frac);
		this.alpha = max(0.0001, this.alpha);

		this.scale = lerp(this.radius_start, this.radius_end, frac) / 128;
		this.scale = max(0.0001, this.scale);
	};
};

void TempEnt_ExpandingOrb()
{
	vector org = ReadVectorL();
	float rad_start = ReadCoord();
	float rad_end = ReadCoord();
	float alp_start = ReadByte() / 127;
	float alp_end = ReadByte() / 127;
	vector clr = ReadColor();
	float life = ReadShort() / 100;

	expandingorb_c orb = spawn();
	precache_model("models/enemies/boss3/deathsphere.md3"); // this should already be done, but just in case!
	setmodel(orb, "models/enemies/boss3/deathsphere.md3");
	setorigin(orb, org);

	orb.effects = EF_ADDITIVE;
	orb.colormod = clr;
	orb.radius_start = rad_start;
	orb.radius_end = rad_end;
	orb.alpha_start = alp_start;
	orb.alpha_end = alp_end;
	orb.lifetime = life;
	orb.starttime = time;

	orb.predraw = orb.render;
	orb.drawmask = MASK_NORMAL;
}

/* #endregion */










