// Reki (August 22 2023):
// viewmodel.qc
// replicating DP viewmodel movement in QuakeC to prevent
// FPS-dependent stuttering in the viewmodel movement

float autocvar_cl_bobcycle;
float autocvar_cl_bobup;
float autocvar_cl_bob;
float autocvar_cl_bobmodel_speed;
float autocvar_cl_bobmodel_side;
float autocvar_cl_bobmodel_up;
float autocvar_cl_bobmodel;
float autocvar_cl_viewmodel_scale;
float autocvar_cl_leanmodel;
float autocvar_cl_followmodel;

vector viewmodel_angles;
vector viewmodel_origin;

void Viewmodel_CalculateMovement(void)
{
	static float old_pmove_flags;
	static float hitgroundtime;
	static float lastongroundtime;
	static float pmove_flags_draw;
	static float pmove_flags_nextcheck;

	vector gunorg, gunangs;
	float cycle, bob, bobfall, xyspeed;
	vector clvelocity = pmove_vel;
	float deltatime = clframetime * (frametime ? getstatf(STAT_MOVEVARS_TIMESCALE) : 0);
	deltatime = min(deltatime, 0.05); // clamp to sane values

	pmove_flags = (pmove_onground ? PMF_ONGROUND : 0);

	if (pmove_flags & PMF_ONGROUND)
	{
		if !(old_pmove_flags & PMF_ONGROUND)
			hitgroundtime = time;

		lastongroundtime = time;
	}

	// fix for ramps and sudden edges messing with viewmodel bob
	if (clvelocity[2] < 0)
	{
		if ((time - lastongroundtime) < 0.3)
		{
			// do some traces to fix up downward slopes and terrain
			tracebox(pmove_org, VEC_HULL_MIN, VEC_HULL_MAX, pmove_org + '0 0 -24', MOVE_WORLDONLY, (entity)1);
			if (trace_fraction < 1)
			{
				pmove_flags |= PMF_ONGROUND;
				clvelocity[2] = 0;
			}
		}
	}
	//

	if (time >= pmove_flags_nextcheck)
	{
		pmove_flags_draw = pmove_flags;
		pmove_flags_nextcheck = time + 0.1;
	}

	xyspeed = bound(0, sqrt(clvelocity[0]*clvelocity[0] + clvelocity[1]*clvelocity[1]), 400);

	#if 0
	if (autocvar_cl_bob && autocvar_cl_bobcycle)
	{
		// LordHavoc: this code is *weird*, but not replacable (I think it
		// should be done in QC on the server, but oh well, quake is quake)
		// LordHavoc: figured out bobup: the time at which the sin is at 180
		// degrees (which allows lengthening or squishing the peak or valley)
		cycle = time / autocvar_cl_bobcycle;
		cycle -= floor(cycle);
		if (cycle < autocvar_cl_bobup)
			cycle = sin(M_PI * cycle / autocvar_cl_bobup);
		else
			cycle = sin(M_PI + M_PI * (cycle - autocvar_cl_bobup)/(1.0 - autocvar_cl_bobup));
		// bob is proportional to velocity in the xy plane
		// (don't count Z, or jumping messes it up)
		bob = xyspeed * bound(0, autocvar_cl_bob, 0.05);
		bob = bob * 0.3 + bob *0.7 * cycle;
		// we also need to adjust gunorg, or this appears like pushing the gun!
		// In the old code, this was applied to vieworg BEFORE copying to gunorg,
		// but this is not viable with the new followmodel code as that would mean
		// that followmodel would work on the munged-by-bob vieworg and do feedback
		gunorg[2] += bob * 0.1;
	}
	#endif

	// gun model lean (trailing behind crosshair)
	//if (autocvar_cl_leanmodel)
	#if 1
	{
		static vector lean_oldviewangle;
		static vector lean_amount;
		static vector lean_oldvelocity;
		static float lean_oldvelocity_containment;
		float scaler = (!(pmove_flags_draw & PMF_ONGROUND) || autocvar_cl_leanmodel) ? 1.5 : 0.4;

		float delta = min(deltatime * 20, 1);

		lean_amount[0] -= (delta / 2) * (lean_amount[0]);
		lean_amount[1] -= (delta / 2) * (lean_amount[1]);
		lean_oldvelocity_containment -= (delta / 2) * (lean_oldvelocity_containment * 0.05);

		lean_amount[0] += angle_difference(lean_oldviewangle[0], view_angles[0]) * 0.12 * scaler;
		lean_amount[1] += angle_difference(lean_oldviewangle[1], view_angles[1]) * 0.10 * scaler;

		lean_oldvelocity_containment += bound(-20, (clvelocity[2] - lean_oldvelocity[2]) * 0.01, 20);
		lean_amount[0] += lean_oldvelocity_containment * delta;

		lean_amount[0] = bound(-5, lean_amount[0], 5);
		lean_amount[1] = bound(-7, lean_amount[1], 7);

		lean_amount[0] -= (delta / 2) * (lean_amount[0]);
		lean_amount[1] -= (delta / 2) * (lean_amount[1]);
		lean_oldvelocity_containment -= (delta / 2) * (lean_oldvelocity_containment * 0.05);

		//if (autocvar_cl_leanmodel)
		{
			gunangs[0] += lean_amount[0];
			gunangs[1] += lean_amount[1];
		}
		
		lean_oldviewangle = view_angles;
		lean_oldvelocity = clvelocity;
	}
	#endif

	// gun model follow (trailing behind movement)
	//if (autocvar_cl_followmodel)
	#if 1
	{
		static vector follow_oldvel;
		static vector follow_vel;
		static vector diff;
		static vector follow_pos;
		float scaler = (!(pmove_flags_draw & PMF_ONGROUND) || autocvar_cl_followmodel) ? 1 : 0.4;
		//float spd = deltatime * 25 * bound(0.8, vlen(clvelocity) / 400, 1);

		//diff[0] = (follow_vel[0] - clvelocity[0]);
		//diff[1] = (follow_vel[1] - clvelocity[1]);
		//diff[2] = (follow_vel[2] - clvelocity[2]);
		//diff = follow_vel - clvelocity;
		//follow_vel -= diff * 25 * deltatime;
		float spd = deltatime * 10 * bound(1, vlen(diff), 400);
		vector slowdown;
		
		// fall off over time
		slowdown = normalize(diff) * spd;
		slowdown[2] *= 0.8;
		diff -= slowdown / 2;
		//

		diff += (follow_oldvel - clvelocity) * 0.3 * scaler;
		if (vlen(diff) > 400)
			diff = normalize(diff) * 400;

		follow_pos += (diff - follow_pos) * deltatime * 20;

		//if (autocvar_cl_followmodel || !(pmove_flags_draw & PMF_ONGROUND))
		{
			gunorg[0] += follow_pos[0] * 0.005;
			gunorg[1] += follow_pos[1] * 0.005;
			gunorg[2] += follow_pos[2] * 0.008;
		}

		// fall off over time
		slowdown = normalize(diff) * spd;
		slowdown[2] *= 0.8;
		diff -= slowdown / 2;
		//

		follow_oldvel = clvelocity;
	}
	#endif

	// gun model bobbing code
	//if (autocvar_cl_bobmodel)
	#if 1
	{
		// calculate for swinging gun model
		// the gun bobs when running on the ground, but doesn't bob when you're in the air.
		// Sajt: I tried to smooth out the transitions between bob and no bob, which works
		// for the most part, but for some reason when you go through a message trigger or
		// pick up an item or anything like that it will momentarily jolt the gun.
		float bspeed;
		float s;
		float t;

		float scaler = (!(pmove_flags_draw & PMF_ONGROUND) || autocvar_cl_bobmodel) ? 1 : 0.7;

		s = time * autocvar_cl_bobmodel_speed * scaler;
		if (pmove_flags_draw & PMF_ONGROUND)
		{
			if (time - hitgroundtime < 0.2)
			{
				// just hit the ground, speed the bob back up over the next 0.2 seconds
				t = time - hitgroundtime;
				t = bound(0, t, 0.2);
				t *= 5;
			}
			else
				t = 1;
		}
		else
		{
			// recently left the ground, slow the bob down over the next 0.2 seconds
			t = time - lastongroundtime;
			t = 0.2 - bound(0, t, 0.2);
			t *= 5;
		}

		bspeed = xyspeed * 0.01;
		makevectors(view_angles);
		bob = bspeed * autocvar_cl_bobmodel_side * autocvar_cl_viewmodel_scale * sin (s) * t;
		gunorg += bob * v_right * scaler;
		bob = bspeed * autocvar_cl_bobmodel_up * autocvar_cl_viewmodel_scale * cos (s * 2) * t;
		gunorg += bob * v_up * scaler;
	}
	#endif

	gunorg += viewmodel_origin;
	gunangs += viewmodel_angles;

	setproperty(VF_VIEWMODEL_ORIGIN, gunorg);
	setproperty(VF_VIEWMODEL_ANGLES, gunangs);

	old_pmove_flags = pmove_flags;
}


