// Reki (May 15 2023)
// bezier.qc:
// handling for bezier curves
// initially used for TEMPENT::CRYSTALLIZER_BEZIER
// to replace the yucky SSQC noodle thing

enum BEZIER:float {
	DEFAULT,
	CRYSTALLIZER,
};

class bezier_c;
bezier_c bezier_list;

class bezier_c {
	vector start;
	vector end;
	vector angle;
	float segment_length;
	float owner_num;
	float time_updated;
	float time_hit;
	float type;

	bezier_c _next;

	nonvirtual void bezier_c(void) {
		this._next = bezier_list;
		bezier_list = this;
	};

	virtual void RemoveEntity(void) {
		
		bezier_c hld;
		for(bezier_c lst = bezier_list; lst; hld = lst, lst = lst._next)
		{
			if (lst != this)
				continue;
			
			if (!hld)
			{
				bezier_list = lst._next;
				break;
			}

			hld._next = lst._next;
		}
		
		remove(this);
	};
};

vector bezierPosition(vector a, vector b, vector c, float t)
{
	vector Qa = lerpVector(a, b, t);
	vector Qb = lerpVector(b, c, t);
	vector Qc = lerpVector(Qa, Qb, t);
	return Qc;
}

.float endPoll;
.vector endOld;
.vector controlRand;
.vector old_controlRand;
.float old_controlTime;
.float luster;
float autocvar_cl_straightbeam;
void Crystallizer_Bezier_Predraw(void)
{
	bezier_c bez = (bezier_c)self;
	float mod_num = 0;
	string mod_list[] = {
		"models/projectiles/beam_crystala.md3",
		"models/projectiles/beam_crystalb.md3",
		"models/projectiles/beam_crystalc.md3",
		"models/projectiles/beam_crystald.md3",
		"models/projectiles/beam_crystale.md3",
	}

	makevectors(bez.angle);
	vector curve_start = bez.start;
	vector curve_end = bez.end;
	if (bez.owner_num == player_localentnum)
	{
		makevectors(view_angles + getpropertyvec(VF_VIEWMODEL_ANGLES));
		curve_start = getpropertyvec(VF_ORIGIN) + getpropertyvec(VF_VIEWMODEL_ORIGIN);
		if (cvar("saved3")) // centered viewmodel
		{
			curve_start += v_forward * 17;
			curve_start += v_up * -8;
		}
		else // normal viewmodel
		{
			curve_start += v_right * 8;
			curve_start += v_forward * 26;
			curve_start += v_up * -6;
		}
		makevectors(view_angles);
	}
	
	if (time < (bez.time_updated + 0.12))
	{
		bez.alpha = 1;
	}
	else
	{
		bez.alpha -= frametime * 10;
		if (bez.alpha <= 0)
		{
			bez.RemoveEntity();
			return;
		}
	}

	if (time < (bez.time_hit + 0.08))
	{
		bez.luster = 1;
	}
	else
	{
		bez.luster -= frametime * 4;
		bez.luster = max(0, bez.luster);
	}

	if (autocvar_cl_straightbeam && bez.owner_num == player_localentnum)
	{
		vector t_dest = getpropertyvec(VF_ORIGIN);
		t_dest += v_forward * 768;
		traceline(curve_start, t_dest, MOVE_NORMAL, edict_num(player_localentnum));
		curve_end = trace_endpos + (v_forward * 32);
	}

	bez.colormod = '0.4 0.4 0.4' + ('0.6 0.6 0.6' * bez.luster);

	float scale = (vlen(curve_start - curve_end) / 768);
	vector controlPoint = curve_start + v_forward * (256 * scale);
	float time_clamp = floor(time * 15) / 15;
	#if 1
	if (bez.old_controlTime != time_clamp)
	{
		bez.old_controlTime = time_clamp;
		bez.old_controlRand = bez.controlRand;
		bez.controlRand[0] = cprandom(time_clamp * 8) * 5 * scale;
		bez.controlRand[1] = cprandom(time_clamp * 2) * 8 * scale;
		bez.controlRand[2] = cprandom(time_clamp * 6) * 11 * scale;
	}

	if (!autocvar_cl_straightbeam)
	{
		float frac = (time - time_clamp) * 15;
		controlPoint += lerpVector(bez.old_controlRand, bez.controlRand, frac);
		//controlPoint += bez.old_controlRand * frac;
		//controlPoint += bez.controlRand;
	}
	#else
	bez.controlRand[0] = cprandom(time_clamp * 8) * 5 * scale;
	bez.controlRand[1] = cprandom(time_clamp * 2) * 8 * scale;
	bez.controlRand[2] = cprandom(time_clamp * 6) * 11 * scale;

	if (!autocvar_cl_straightbeam)
	{
		controlPoint += bez.controlRand;
	}
	#endif

	#if 0
	float frac = bound(0, (time - bez.time_updated) / 0.05, 1);
	curve_end = lerpVector(bez.endOld, bez.end, frac);
	#endif

	
	vector last_org = curve_start;
	for(float i = 0; i <= 1.2; i += 0.05)
	{
		vector curr_org = bezierPosition(curve_start, controlPoint, curve_end, i);
		vector diff = curr_org - last_org;
		float len = vlen(diff);
		if (len < bez.segment_length)
		{
			if (vlen(curr_org - curve_end) < bez.segment_length) // hack to add the final beam, probably a better way to do this
			{
				setmodel(bez, mod_list[mod_num]);
				bez.angles = vectoangles(diff);
				bez.origin = last_org;
				addentity(bez);
				break;
			}
			continue;
		}
		
		while(len >= bez.segment_length)
		{
			len -= bez.segment_length;
			curr_org = last_org + (normalize(diff) * bez.segment_length);

			setmodel(bez, mod_list[mod_num]);
			bez.angles = vectoangles(diff);
			bez.origin = last_org;
			addentity(bez);

			last_org = curr_org;
			mod_num = (mod_num + 1) % mod_list.length;
		}
	}

	bez.modelindex = 0;
}

void TempEnt_Crystallizer_Bezier(void)
{
	vector r_start = ReadVectorL();
	vector r_end = ReadVectorL();
	vector r_ang = ReadVectorA();
	float r_own = ReadShort();
	float r_hit = ReadByte();

	if (r_own)
	{
		for(bezier_c lst = bezier_list; lst; lst = lst._next)
		{
			if (lst.owner_num != r_own)
				continue;
			
			if (lst.type != BEZIER::CRYSTALLIZER)
				continue;
			
			// if we found a duplicate, update it
			lst.time_updated = time;
			lst.start = r_start;
			lst.endOld = lst.end;
			lst.end = r_end;
			lst.angle = r_ang;
			if (r_hit)
				lst.time_hit = time + (0.1 * (r_hit - 1));
			return;
		}
	}
	
	bezier_c bez = spawn(bezier_c);
	bez.start = r_start;
	bez.end = r_end;
	bez.endOld = r_end;
	bez.angle = r_ang;
	bez.owner_num = r_own;
	bez.type = BEZIER::CRYSTALLIZER;
	bez.segment_length = 24;
	bez.time_updated = time;
	if (r_hit)
		bez.time_hit = time + (0.1 * (r_hit - 1));
	bez.predraw = Crystallizer_Bezier_Predraw;
	bez.drawmask = MASK_NORMAL;

}











