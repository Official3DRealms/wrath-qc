// Reki: Added this timescale system to remove "slowmo" calls from CSQC,
// which causes lots of fun bugs unless you hack and pray.
// Hopefully this should be more robust

float timescale_nextstep; // next tick
float timescale_current; // current
float timescale_wanted; // goal we're moving towards
float timescale_players;
#define TIMESCALE_STEPSIZE	0.05	// run time steps at 20hz as to not spam localcmd too much
#define TIMESCALE_SPEED 2

void Timescale_RunFrame(void)
{
	if (time < timescale_nextstep)
		return;
	
	float players = 0;
	timescale_wanted = 1;

	for(float i = 1; i < 32; i++) // loop through ents, break when you run out of players, establish a timescale to use
	{
		entity edict = edict_num(i);
		if !(edict.flags & FL_CLIENT)
			continue;
		players++;
		
		if (edict.rmenu)
		{
			if (timescale_players > 1) // in coop, lets not quite slow down so much
				timescale_wanted = min(timescale_wanted, 0.5);
			else
				timescale_wanted = min(timescale_wanted, 0.1);
		}
		if (edict.deadmenuflag || edict.deadflag)
		{
			if (edict.deadflag)
				timescale_wanted = min(timescale_wanted, 0.1);
			else
				timescale_wanted = min(timescale_wanted, 0.5);
		}
	}

	timescale_players = players; // track this for next frame, we may be in coop

	float spd = 1;
	if (fabs(timescale_current - timescale_wanted) > 0.4)
		spd = 3;
	else if (fabs(timescale_current - timescale_wanted) > 0.2)
		spd = 2;
	
	if (timescale_current < timescale_wanted)
	{
		//timescale_current = timescale_wanted;
		timescale_current = min(timescale_wanted, timescale_current + (TIMESCALE_SPEED * TIMESCALE_STEPSIZE * spd * 1.5));
	}
	else if (timescale_current > timescale_wanted)
	{
		timescale_current = max(timescale_wanted, timescale_current - (TIMESCALE_SPEED * TIMESCALE_STEPSIZE * spd));
	}
	timescale(timescale_current);
	timescale_nextstep = time + (TIMESCALE_STEPSIZE * timescale_current); 
}









