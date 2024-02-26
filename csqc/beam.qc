// beam.qc:
// handling for beam

enum BEAM:float {
	DEFAULT,
	BOSS,
};

class beam_c;
beam_c beam_list;

class beam_c {
	vector start;
	vector end;
	float scale;
	float segment_length;
	float owner_num;
	float time_updated;
	float time_hit;
	float type;

	beam_c _next;

	nonvirtual void beam_c(void) {
		this._next = beam_list;
		beam_list = this;
	};

	virtual void RemoveEntity(void) {
		
		beam_c hld;
		for(beam_c lst = beam_list; lst; hld = lst, lst = lst._next)
		{
			if (lst != this)
				continue;
			
			if (!hld)
			{
				beam_list = lst._next;
				break;
			}

			hld._next = lst._next;
		}
		
		remove(this);
	};
};

vector beamPosition(vector a, vector b, vector c, float t)
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
void Boss_Beam_Predraw(void)
{
	beam_c bez = (beam_c)self;
	float mod_num = 0;
	string mod_list[] = {
		"models/projectiles/beam_crystala.md3",
		"models/projectiles/beam_crystalb.md3",
		"models/projectiles/beam_crystalc.md3",
		"models/projectiles/beam_crystald.md3",
		"models/projectiles/beam_crystale.md3",
	}

	vector curve_start = bez.start;
	vector curve_end = bez.end;

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


	bez.colormod = '0.4 0.4 0.4' + ('0.6 0.6 0.6' * bez.luster);

	float scale = (vlen(curve_start - curve_end) / 768);
	float time_clamp = floor(time * 15) / 15;

    float segments_needed = ceil(vlen(curve_start - curve_end) / bez.segment_length);
    vector curr_org = curve_start
    vector last_org = curr_org;
    vector diff = normalize(curve_end - curve_start); // this might be flipped, I always get it mixed up
    vector angs = vectoangles(diff);
    
    for(float i = 0; i < segments_needed; i++)
    {
        curr_org = last_org + (normalize(diff) * bez.segment_length);
        setmodel(bez, mod_list[mod_num]);
        bez.angles = angs;
        bez.origin = last_org;
        addentity(bez);
        last_org = curr_org;
        mod_num = (mod_num + 1) % mod_list.length;
    }
	bez.modelindex = 0;
}

void TempEnt_Boss_Beam(void)
{
	vector r_start = ReadVectorL();
	vector r_end = ReadVectorL();
	float r_scale = ReadByte16();
	float r_own = ReadShort();
	float r_hit = ReadByte();

	if (r_own)
	{
		for(beam_c lst = beam_list; lst; lst = lst._next)
		{
			if (lst.owner_num != r_own)
				continue;
			
			if (lst.type != BEAM::BOSS)
				continue;
			
			// if we found a duplicate, update it
			lst.time_updated = time;
			lst.start = r_start;
			lst.endOld = lst.end;
			lst.end = r_end;
			lst.scale = r_scale;
			if (r_hit)
				lst.time_hit = time + (0.1 * (r_hit - 1));
			return;
		}
	}
	
	beam_c bez = spawn(beam_c);
	bez.start = r_start;
	bez.end = r_end;
	bez.endOld = r_end;
	bez.scale = r_scale;
	bez.owner_num = r_own;
	bez.type = BEAM::BOSS;
	bez.segment_length = 24 * bez.scale;
	bez.time_updated = time;
	if (r_hit)
		bez.time_hit = time + (0.1 * (r_hit - 1));
	bez.predraw = Boss_Beam_Predraw;
	bez.drawmask = MASK_NORMAL;

}











