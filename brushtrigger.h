// Reki (September 24 2023): Precise brush collisions, borrowed
// from Xonotic's version of the Nehara WarpzoneLib

static vector BoxTouchesBrush_mins;
static vector BoxTouchesBrush_maxs;
static entity BoxTouchesBrush_ent;
static entity BoxTouchesBrush_ignore;
static float BoxTouchesBrush_Recurse()
{
	float s;
	entity se;
	float f;

	tracebox('0 0 0', BoxTouchesBrush_mins, BoxTouchesBrush_maxs, '0 0 0', MOVE_NOMONSTERS, BoxTouchesBrush_ignore);
#ifdef CSQC
	if (trace_networkentity)
	{
		dprint(__func__, ": ", "hit a network ent, cannot continue BoxTouchesBrush\n");
		// we cannot continue, as a player blocks us...
		// so, abort
		return 0;
	}
#endif

	if (!trace_ent)
		return 0;
	if (trace_ent == BoxTouchesBrush_ent)
		return 1;

	se = trace_ent;
	s = se.solid;
	se.solid = SOLID_NOT;
	f = BoxTouchesBrush_Recurse();
	se.solid = s;

	return f;
}

static float BoxTouchesBrush(vector mi, vector ma, entity e, entity ig)
{
    float f, s;

    if(!e.modelindex)
        return 1;

    s = e.solid;
    e.solid = SOLID_BSP;
    BoxTouchesBrush_mins = mi;
    BoxTouchesBrush_maxs = ma;
    BoxTouchesBrush_ent = e;
    BoxTouchesBrush_ignore = ig;
    f = BoxTouchesBrush_Recurse();
    e.solid = s;

    return f;
}

void init_precise_trigger_collision()
{
	if (self.touch) // we only want this to happen if we have a touch function
	{
		for(entity e = findflags(world, flags, FL_CLIENT); e; e = findflags(e, flags, FL_CLIENT))
		{
			if !(boxesoverlap(e.absmin, e.absmax, self.absmin, self.absmax))
				continue;

			if !(BoxTouchesBrush(e.origin + e.mins, e.origin + e.maxs, self, __NULL__))
				continue;

			other = e;
			self.touch();
		}
	}

	self.solid = SOLID_NOT;
	self.nextthink = time + 0.013;
	self.think = init_precise_trigger_collision;
};