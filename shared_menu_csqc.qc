void(string filefrom, string fileto)fcopy_wrath2 =
{

if(fexists(strcat ("data/",filefrom)))
fcopy (filefrom, fileto);
};

void(string s)data_fremove =
{
//substring(string s, float start, float length) substring = #116; // returns a section of a string as a tempstring - see FTE_STRINGS for enhanced version
string filename = substring (s,5,(strlen(s) -5));
fremove(filename);
};

void(float istether) load_save_maps =
{
	read_currentprofileslot();

	// episode 1

	local string intromap, hub1map, e1m1map, e1m2map, e1m3map, e1m4map, e1m5map, boss1map;
	intromap = strcat("data/profiles/", profilename, "/maps/intro.sav");
	hub1map = strcat("data/profiles/", profilename, "/maps/hub1.sav");
	e1m1map = strcat("data/profiles/", profilename, "/maps/e1m1.sav");
	e1m2map = strcat("data/profiles/", profilename, "/maps/e1m2.sav");
	e1m3map = strcat("data/profiles/", profilename, "/maps/e1m3.sav");
	e1m4map = strcat("data/profiles/", profilename, "/maps/e1m4.sav");
	e1m5map = strcat("data/profiles/", profilename, "/maps/e1m5.sav");
	boss1map = strcat("data/profiles/", profilename, "/maps/boss1map.sav");

	if(fexists(intromap)) data_fremove (intromap);
	if(fexists(hub1map)) data_fremove (hub1map);
	if(fexists(e1m1map)) data_fremove (e1m1map);
	if(fexists(e1m2map)) data_fremove (e1m2map);
	if(fexists(e1m3map)) data_fremove (e1m3map);
	if(fexists(e1m4map)) data_fremove (e1m4map);
	if(fexists(e1m5map)) data_fremove (e1m5map);
	if(fexists(boss1map)) data_fremove (boss1map);


	string tointromap, tohub1map, toe1m1map, toe1m2map, toe1m3map, toe1m4map, toe1m5map, toboss1map;

	tointromap = strcat("profiles/", profilename, "/maps/intro.sav");
	tohub1map = strcat("profiles/", profilename, "/maps/hub1.sav");
	toe1m1map = strcat("profiles/", profilename, "/maps/e1m1.sav");
	toe1m2map = strcat("profiles/", profilename, "/maps/e1m2.sav");
	toe1m3map = strcat("profiles/", profilename, "/maps/e1m3.sav");
	toe1m4map = strcat("profiles/", profilename, "/maps/e1m4.sav");
	toe1m5map = strcat("profiles/", profilename, "/maps/e1m5.sav");
	toboss1map = strcat("profiles/", profilename, "/maps/boss1.sav");


	string fromintromap, fromhub1map, frome1m1map, frome1m2map, frome1m3map, frome1m4map, frome1m5map, fromboss1map;

	if(istether == 1)
	{
		fromintromap = strcat("profiles/", profilename, "/tether/maps/intro.sav");
		fromhub1map = strcat("profiles/", profilename, "/tether/maps/hub1.sav");
		frome1m1map = strcat("profiles/", profilename, "/tether/maps/e1m1.sav");
		frome1m2map = strcat("profiles/", profilename, "/tether/maps/e1m2.sav");	
		frome1m3map = strcat("profiles/", profilename, "/tether/maps/e1m3.sav");	
		frome1m4map = strcat("profiles/", profilename, "/tether/maps/e1m4.sav");	
		frome1m5map = strcat("profiles/", profilename, "/tether/maps/e1m5.sav");	
		fromboss1map = strcat("profiles/", profilename, "/tether/maps/boss1.sav");	
	}
	if(istether == 2)
	{
		fromintromap = strcat("profiles/", profilename, "/shrine/maps/intro.sav");
		fromhub1map = strcat("profiles/", profilename, "/shrine/maps/hub1.sav");
		frome1m1map = strcat("profiles/", profilename, "/shrine/maps/e1m1.sav");
		frome1m2map = strcat("profiles/", profilename, "/shrine/maps/e1m2.sav");	
		frome1m3map = strcat("profiles/", profilename, "/shrine/maps/e1m3.sav");	
		frome1m4map = strcat("profiles/", profilename, "/shrine/maps/e1m4.sav");	
		frome1m5map = strcat("profiles/", profilename, "/shrine/maps/e1m5.sav");	
		fromboss1map = strcat("profiles/", profilename, "/shrine/maps/boss1.sav");	
	}	
	if(istether == 3)
	{
		fromintromap = strcat("profiles/", profilename, "/autosave/maps/intro.sav");
		fromhub1map = strcat("profiles/", profilename, "/autosave/maps/hub1.sav");
		frome1m1map = strcat("profiles/", profilename, "/autosave/maps/e1m1.sav");
		frome1m2map = strcat("profiles/", profilename, "/autosave/maps/e1m2.sav");	
		frome1m3map = strcat("profiles/", profilename, "/autosave/maps/e1m3.sav");	
		frome1m4map = strcat("profiles/", profilename, "/autosave/maps/e1m4.sav");	
		frome1m5map = strcat("profiles/", profilename, "/autosave/maps/e1m5.sav");	
		fromboss1map = strcat("profiles/", profilename, "/autosave/maps/boss1.sav");	
	}	

	fcopy(fromintromap, tointromap);
	fcopy(fromhub1map, tohub1map);
	fcopy(frome1m1map, toe1m1map);
	fcopy(frome1m2map, toe1m2map);
	fcopy(frome1m3map, toe1m3map);
	fcopy(frome1m4map, toe1m4map);
	fcopy(frome1m5map, toe1m5map);
	fcopy(fromboss1map, toboss1map);


	local string introstat, hub1stat, e1m1stat, e1m2stat, e1m3stat, e1m4stat, e1m5stat, boss1stat;

	introstat = strcat("profiles/", profilename, "/maps/intro.stats");
	hub1stat = strcat("profiles/", profilename, "/maps/hub1.stats");
	e1m1stat = strcat("profiles/", profilename, "/maps/e1m1.stats");
	e1m2stat = strcat("profiles/", profilename, "/maps/e1m2.stats");
	e1m3stat = strcat("profiles/", profilename, "/maps/e1m3.stats");
	e1m4stat = strcat("profiles/", profilename, "/maps/e1m4.stats");
	e1m5stat = strcat("profiles/", profilename, "/maps/e1m5.stats");

	if(fexists(introstat)) fremove (introstat);
	if(fexists(hub1stat)) fremove (hub1stat);
	if(fexists(e1m1stat)) fremove (e1m1stat);
	if(fexists(e1m2stat)) fremove (e1m2stat);
	if(fexists(e1m3stat)) fremove (e1m3stat);
	if(fexists(e1m4stat)) fremove (e1m4stat);
	if(fexists(e1m5stat)) fremove (e1m5stat);

	string tointrostat, tohub1stat, toe1m1stat, toe1m2stat, toe1m3stat, toe1m4stat, toe1m5stat, toboss1stat;
	
	tointrostat = strcat("profiles/", profilename, "/maps/intro.stats");
	tohub1stat = strcat("profiles/", profilename, "/maps/hub1.stats");
	toe1m1stat = strcat("profiles/", profilename, "/maps/e1m1.stats");
	toe1m2stat = strcat("profiles/", profilename, "/maps/e1m2.stats");
	toe1m3stat = strcat("profiles/", profilename, "/maps/e1m3.stats");
	toe1m4stat = strcat("profiles/", profilename, "/maps/e1m4.stats");
	toe1m5stat = strcat("profiles/", profilename, "/maps/e1m5.stats");
	toboss1stat = strcat("profiles/", profilename, "/maps/boss1.stats");

	string fromintrostat, fromhub1stat, frome1m1stat, frome1m2stat, frome1m3stat, frome1m4stat, frome1m5stat, fromboss1stat;

	if (istether == 1)
	{
		fromintrostat = strcat("profiles/", profilename, "/tether/maps/intro.stats");
		fromhub1stat = strcat("profiles/", profilename, "/tether/maps/hub1.stats");
		frome1m1stat = strcat("profiles/", profilename, "/tether/maps/e1m1.stats");
		frome1m2stat = strcat("profiles/", profilename, "/tether/maps/e1m2.stats");
		frome1m3stat = strcat("profiles/", profilename, "/tether/maps/e1m3.stats");
		frome1m4stat = strcat("profiles/", profilename, "/tether/maps/e1m4.stats");
		frome1m5stat = strcat("profiles/", profilename, "/tether/maps/e1m5.stats");
		fromboss1stat = strcat("profiles/", profilename, "/tether/maps/boss1.stats");
	}

	if (istether == 2)
	{
		fromintrostat = strcat("profiles/", profilename, "/shrine/maps/intro.stats");
		fromhub1stat = strcat("profiles/", profilename, "/shrine/maps/hub1.stats");
		frome1m1stat = strcat("profiles/", profilename, "/shrine/maps/e1m1.stats");
		frome1m2stat = strcat("profiles/", profilename, "/shrine/maps/e1m2.stats");
		frome1m3stat = strcat("profiles/", profilename, "/shrine/maps/e1m3.stats");
		frome1m4stat = strcat("profiles/", profilename, "/shrine/maps/e1m4.stats");
		frome1m5stat = strcat("profiles/", profilename, "/shrine/maps/e1m5.stats");
		fromboss1stat = strcat("profiles/", profilename, "/shrine/maps/boss1.stats");
	}

	if (istether == 3)
	{
		fromintrostat = strcat("profiles/", profilename, "/autosave/maps/intro.stats");
		fromhub1stat = strcat("profiles/", profilename, "/autosave/maps/hub1.stats");
		frome1m1stat = strcat("profiles/", profilename, "/autosave/maps/e1m1.stats");
		frome1m2stat = strcat("profiles/", profilename, "/autosave/maps/e1m2.stats");
		frome1m3stat = strcat("profiles/", profilename, "/autosave/maps/e1m3.stats");
		frome1m4stat = strcat("profiles/", profilename, "/autosave/maps/e1m4.stats");
		frome1m5stat = strcat("profiles/", profilename, "/autosave/maps/e1m5.stats");
		fromboss1stat = strcat("profiles/", profilename, "/autosave/maps/boss1.stats");
	}

	fcopy_wrath(fromintrostat, tointrostat);
	fcopy_wrath(fromhub1stat, tohub1stat);
	fcopy_wrath(frome1m1stat, toe1m1stat);
	fcopy_wrath(frome1m2stat, toe1m2stat);
	fcopy_wrath(frome1m3stat, toe1m3stat);
	fcopy_wrath(frome1m4stat, toe1m4stat);
	fcopy_wrath(frome1m5stat, toe1m5stat);
	fcopy_wrath(fromboss1stat, toboss1stat);

	// episode 2

	local string hub2map, e2m1map, e2m2map, e2m3map, e2m4map, e2m5map,boss2map;

	hub2map = strcat("data/profiles/", profilename, "/maps/hub2.sav");
	e2m1map = strcat("data/profiles/", profilename, "/maps/e2m1.sav");
	e2m2map = strcat("data/profiles/", profilename, "/maps/e2m2.sav");
	e2m3map = strcat("data/profiles/", profilename, "/maps/e2m3.sav");
	e2m4map = strcat("data/profiles/", profilename, "/maps/e2m4.sav");
	e2m5map = strcat("data/profiles/", profilename, "/maps/e2m5.sav");
	boss2map = strcat("data/profiles/", profilename, "/maps/boss2.sav");

	if(fexists(hub2map)) fremove (hub2map);
	if(fexists(e2m1map)) fremove (e2m1map);
	if(fexists(e2m2map)) fremove (e2m2map);
	if(fexists(e2m3map)) fremove (e2m3map);
	if(fexists(e2m4map)) fremove (e2m4map);
	if(fexists(e2m5map)) fremove (e2m5map);
	if(fexists(boss2map)) fremove (boss2map);

	string tohub2map, toe2m1map, toe2m2map, toe2m3map, toe2m4map, toe2m5map, toboss2map;
	tohub2map = strcat("profiles/", profilename, "/maps/hub2.sav");
	toe2m1map = strcat("profiles/", profilename, "/maps/e2m1.sav");
	toe2m2map = strcat("profiles/", profilename, "/maps/e2m2.sav");
	toe2m3map = strcat("profiles/", profilename, "/maps/e2m3.sav");
	toe2m4map = strcat("profiles/", profilename, "/maps/e2m4.sav");
	toe2m5map = strcat("profiles/", profilename, "/maps/e2m5.sav");
	toboss2map = strcat("profiles/", profilename, "/maps/boss2.sav");

	string fromhub2map, frome2m1map, frome2m2map, frome2m3map, frome2m4map, frome2m5map, fromboss2map;
	if(istether == 1)
	{
		fromhub2map = strcat("profiles/", profilename, "/tether/maps/hub2.sav");
		frome2m1map = strcat("profiles/", profilename, "/tether/maps/e2m1.sav");
		frome2m2map = strcat("profiles/", profilename, "/tether/maps/e2m2.sav");	
		frome2m3map = strcat("profiles/", profilename, "/tether/maps/e2m3.sav");	
		frome2m4map = strcat("profiles/", profilename, "/tether/maps/e2m4.sav");	
		frome2m5map = strcat("profiles/", profilename, "/tether/maps/e2m5.sav");	
		fromboss2map = strcat("profiles/", profilename, "/tether/maps/boss2.sav");	
	}
	if(istether == 2)
	{
		fromhub2map = strcat("profiles/", profilename, "/shrine/maps/hub2.sav");
		frome2m1map = strcat("profiles/", profilename, "/shrine/maps/e2m1.sav");
		frome2m2map = strcat("profiles/", profilename, "/shrine/maps/e2m2.sav");	
		frome2m3map = strcat("profiles/", profilename, "/shrine/maps/e2m3.sav");	
		frome2m4map = strcat("profiles/", profilename, "/shrine/maps/e2m4.sav");	
		frome2m5map = strcat("profiles/", profilename, "/shrine/maps/e2m5.sav");	
		fromboss2map = strcat("profiles/", profilename, "/shrine/maps/boss2.sav");	
	}	
	if(istether == 3)
	{
		fromhub2map = strcat("profiles/", profilename, "/autosave/maps/hub2.sav");
		frome2m1map = strcat("profiles/", profilename, "/autosave/maps/e2m1.sav");
		frome2m2map = strcat("profiles/", profilename, "/autosave/maps/e2m2.sav");	
		frome2m3map = strcat("profiles/", profilename, "/autosave/maps/e2m3.sav");	
		frome2m4map = strcat("profiles/", profilename, "/autosave/maps/e2m4.sav");	
		frome2m5map = strcat("profiles/", profilename, "/autosave/maps/e2m5.sav");	
		fromboss2map = strcat("profiles/", profilename, "/autosave/maps/boss2.sav");	
	}	

	fcopy(fromhub2map, tohub2map);
	fcopy(frome2m1map, toe2m1map);
	fcopy(frome2m2map, toe2m2map);
	fcopy(frome2m3map, toe2m3map);
	fcopy(frome2m4map, toe2m4map);
	fcopy(frome2m5map, toe2m5map);
	fcopy(fromboss2map, toboss2map);


	local string hub2stat, e2m1stat, e2m2stat, e2m3stat, e2m4stat, e2m5stat, boss2stat;

	hub2stat = strcat("profiles/", profilename, "/maps/hub2.stats");
	e2m1stat = strcat("profiles/", profilename, "/maps/e2m1.stats");
	e2m2stat = strcat("profiles/", profilename, "/maps/e2m2.stats");
	e2m3stat = strcat("profiles/", profilename, "/maps/e2m3.stats");
	e2m4stat = strcat("profiles/", profilename, "/maps/e2m4.stats");
	e2m5stat = strcat("profiles/", profilename, "/maps/e2m5.stats");
	boss2stat = strcat("profiles/", profilename, "/maps/boss2.stats");

	if(fexists(hub2stat)) fremove (hub2stat);
	if(fexists(e2m1stat)) fremove (e2m1stat);
	if(fexists(e2m2stat)) fremove (e2m2stat);
	if(fexists(e2m3stat)) fremove (e2m3stat);
	if(fexists(e2m4stat)) fremove (e2m4stat);
	if(fexists(e2m5stat)) fremove (e2m5stat);
	if(fexists(boss2stat)) fremove (boss2stat);


	string tohub2stat, toe2m1stat, toe2m2stat, toe2m3stat, toe2m4stat, toe2m5stat, toboss2stat;
	string fromhub2stat, frome2m1stat, frome2m2stat, frome2m3stat, frome2m4stat, frome2m5stat, fromboss2stat;
	tohub2stat = strcat("profiles/", profilename, "/maps/hub2.stats");
	toe2m1stat = strcat("profiles/", profilename, "/maps/e2m1.stats");
	toe2m2stat = strcat("profiles/", profilename, "/maps/e2m2.stats");
	toe2m3stat = strcat("profiles/", profilename, "/maps/e2m3.stats");
	toe2m4stat = strcat("profiles/", profilename, "/maps/e2m4.stats");
	toe2m5stat = strcat("profiles/", profilename, "/maps/e2m5.stats");
	toboss2stat = strcat("profiles/", profilename, "/maps/boss2.stats");

	if (istether == 1)
	{
		fromhub2stat = strcat("profiles/", profilename, "/tether/maps/hub2.stats");
		frome2m1stat = strcat("profiles/", profilename, "/tether/maps/e2m1.stats");
		frome2m2stat = strcat("profiles/", profilename, "/tether/maps/e2m2.stats");
		frome2m3stat = strcat("profiles/", profilename, "/tether/maps/e2m3.stats");
		frome2m4stat = strcat("profiles/", profilename, "/tether/maps/e2m4.stats");
		frome2m5stat = strcat("profiles/", profilename, "/tether/maps/e2m5.stats");
		fromboss2stat = strcat("profiles/", profilename, "/tether/maps/boss2.stats");
	}

	if (istether == 2)
	{
		fromhub2stat = strcat("profiles/", profilename, "/shrine/maps/hub2.stats");
		frome2m1stat = strcat("profiles/", profilename, "/shrine/maps/e2m1.stats");
		frome2m2stat = strcat("profiles/", profilename, "/shrine/maps/e2m2.stats");
		frome2m3stat = strcat("profiles/", profilename, "/shrine/maps/e2m3.stats");
		frome2m4stat = strcat("profiles/", profilename, "/shrine/maps/e2m4.stats");
		frome2m5stat = strcat("profiles/", profilename, "/shrine/maps/e2m5.stats");
		fromboss2stat = strcat("profiles/", profilename, "/shrine/maps/boss2.stats");
	}

	if (istether == 3)
	{
		fromhub2stat = strcat("profiles/", profilename, "/autosave/maps/hub2.stats");
		frome2m1stat = strcat("profiles/", profilename, "/autosave/maps/e2m1.stats");
		frome2m2stat = strcat("profiles/", profilename, "/autosave/maps/e2m2.stats");
		frome2m3stat = strcat("profiles/", profilename, "/autosave/maps/e2m3.stats");
		frome2m4stat = strcat("profiles/", profilename, "/autosave/maps/e2m4.stats");
		frome2m5stat = strcat("profiles/", profilename, "/autosave/maps/e2m5.stats");
		fromboss2stat = strcat("profiles/", profilename, "/autosave/maps/boss2.stats");
	}

	fcopy_wrath(fromhub2stat, tohub2stat);
	fcopy_wrath(frome2m1stat, toe2m1stat);
	fcopy_wrath(frome2m2stat, toe2m2stat);
	fcopy_wrath(frome2m3stat, toe2m3stat);
	fcopy_wrath(frome2m4stat, toe2m4stat);
	fcopy_wrath(frome2m5stat, toe2m5stat);
	fcopy_wrath(fromboss2stat, toboss2stat);


	// episode 3

	local string hub3map, e3m1map, e3m2map, e3m3map, e3m4map, e3m5map,boss3map;

	hub3map = strcat("data/profiles/", profilename, "/maps/hub3.sav");
	e3m1map = strcat("data/profiles/", profilename, "/maps/e3m1.sav");
	e3m2map = strcat("data/profiles/", profilename, "/maps/e3m2.sav");
	e3m3map = strcat("data/profiles/", profilename, "/maps/e3m3.sav");
	e3m4map = strcat("data/profiles/", profilename, "/maps/e3m4.sav");
	e3m5map = strcat("data/profiles/", profilename, "/maps/e3m5.sav");
	boss3map = strcat("data/profiles/", profilename, "/maps/boss3.sav");

	if(fexists(hub3map)) fremove (hub3map);
	if(fexists(e3m1map)) fremove (e3m1map);
	if(fexists(e3m2map)) fremove (e3m2map);
	if(fexists(e3m3map)) fremove (e3m3map);
	if(fexists(e3m4map)) fremove (e3m4map);
	if(fexists(e3m5map)) fremove (e3m5map);
	if(fexists(boss3map)) fremove (boss3map);

	string tohub3map, toe3m1map, toe3m2map, toe3m3map, toe3m4map, toe3m5map, toboss3map;
	tohub3map = strcat("profiles/", profilename, "/maps/hub3.sav");
	toe3m1map = strcat("profiles/", profilename, "/maps/e3m1.sav");
	toe3m2map = strcat("profiles/", profilename, "/maps/e3m2.sav");
	toe3m3map = strcat("profiles/", profilename, "/maps/e3m3.sav");
	toe3m4map = strcat("profiles/", profilename, "/maps/e3m4.sav");
	toe3m5map = strcat("profiles/", profilename, "/maps/e3m5.sav");
	toboss3map = strcat("profiles/", profilename, "/maps/boss3.sav");

	string fromhub3map, frome3m1map, frome3m2map, frome3m3map, frome3m4map, frome3m5map, fromboss3map;
	if(istether == 1)
	{
		fromhub3map = strcat("profiles/", profilename, "/tether/maps/hub3.sav");
		frome3m1map = strcat("profiles/", profilename, "/tether/maps/e3m1.sav");
		frome3m2map = strcat("profiles/", profilename, "/tether/maps/e3m2.sav");	
		frome3m3map = strcat("profiles/", profilename, "/tether/maps/e3m3.sav");	
		frome3m4map = strcat("profiles/", profilename, "/tether/maps/e3m4.sav");	
		frome3m5map = strcat("profiles/", profilename, "/tether/maps/e3m5.sav");	
		fromboss3map = strcat("profiles/", profilename, "/tether/maps/boss3.sav");	
	}
	if(istether == 2)
	{
		fromhub3map = strcat("profiles/", profilename, "/shrine/maps/hub3.sav");
		frome3m1map = strcat("profiles/", profilename, "/shrine/maps/e3m1.sav");
		frome3m2map = strcat("profiles/", profilename, "/shrine/maps/e3m2.sav");	
		frome3m3map = strcat("profiles/", profilename, "/shrine/maps/e3m3.sav");	
		frome3m4map = strcat("profiles/", profilename, "/shrine/maps/e3m4.sav");	
		frome3m5map = strcat("profiles/", profilename, "/shrine/maps/e3m5.sav");	
		fromboss3map = strcat("profiles/", profilename, "/shrine/maps/boss3.sav");	
	}	
	if(istether == 3)
	{
		fromhub3map = strcat("profiles/", profilename, "/autosave/maps/hub3.sav");
		frome3m1map = strcat("profiles/", profilename, "/autosave/maps/e3m1.sav");
		frome3m2map = strcat("profiles/", profilename, "/autosave/maps/e3m2.sav");	
		frome3m3map = strcat("profiles/", profilename, "/autosave/maps/e3m3.sav");	
		frome3m4map = strcat("profiles/", profilename, "/autosave/maps/e3m4.sav");	
		frome3m5map = strcat("profiles/", profilename, "/autosave/maps/e3m5.sav");	
		fromboss3map = strcat("profiles/", profilename, "/autosave/maps/boss3.sav");	
	}	

	fcopy(fromhub3map, tohub3map);
	fcopy(frome3m1map, toe3m1map);
	fcopy(frome3m2map, toe3m2map);
	fcopy(frome3m3map, toe3m3map);
	fcopy(frome3m4map, toe3m4map);
	fcopy(frome3m5map, toe3m5map);
	fcopy(fromboss3map, toboss3map);


	local string hub3stat, e3m1stat, e3m2stat, e3m3stat, e3m4stat, e3m5stat, boss3stat;

	hub3stat = strcat("profiles/", profilename, "/maps/hub3.stats");
	e3m1stat = strcat("profiles/", profilename, "/maps/e3m1.stats");
	e3m2stat = strcat("profiles/", profilename, "/maps/e3m2.stats");
	e3m3stat = strcat("profiles/", profilename, "/maps/e3m3.stats");
	e3m4stat = strcat("profiles/", profilename, "/maps/e3m4.stats");
	e3m5stat = strcat("profiles/", profilename, "/maps/e3m5.stats");
	boss3stat = strcat("profiles/", profilename, "/maps/boss3.stats");

	if(fexists(hub3stat)) fremove (hub3stat);
	if(fexists(e3m1stat)) fremove (e3m1stat);
	if(fexists(e3m2stat)) fremove (e3m2stat);
	if(fexists(e3m3stat)) fremove (e3m3stat);
	if(fexists(e3m4stat)) fremove (e3m4stat);
	if(fexists(e3m5stat)) fremove (e3m5stat);
	if(fexists(boss3stat)) fremove (boss3stat);


	string tohub3stat, toe3m1stat, toe3m2stat, toe3m3stat, toe3m4stat, toe3m5stat, toboss3stat;
	string fromhub3stat, frome3m1stat, frome3m2stat, frome3m3stat, frome3m4stat, frome3m5stat, fromboss3stat;
	tohub3stat = strcat("profiles/", profilename, "/maps/hub3.stats");
	toe3m1stat = strcat("profiles/", profilename, "/maps/e3m1.stats");
	toe3m2stat = strcat("profiles/", profilename, "/maps/e3m2.stats");
	toe3m3stat = strcat("profiles/", profilename, "/maps/e3m3.stats");
	toe3m4stat = strcat("profiles/", profilename, "/maps/e3m4.stats");
	toe3m5stat = strcat("profiles/", profilename, "/maps/e3m5.stats");
	toboss3stat = strcat("profiles/", profilename, "/maps/boss3.stats");

	if (istether == 1)
	{
		fromhub3stat = strcat("profiles/", profilename, "/tether/maps/hub3.stats");
		frome3m1stat = strcat("profiles/", profilename, "/tether/maps/e3m1.stats");
		frome3m2stat = strcat("profiles/", profilename, "/tether/maps/e3m2.stats");
		frome3m3stat = strcat("profiles/", profilename, "/tether/maps/e3m3.stats");
		frome3m4stat = strcat("profiles/", profilename, "/tether/maps/e3m4.stats");
		frome3m5stat = strcat("profiles/", profilename, "/tether/maps/e3m5.stats");
		fromboss3stat = strcat("profiles/", profilename, "/tether/maps/boss3.stats");
	}

	if (istether == 2)
	{
		fromhub3stat = strcat("profiles/", profilename, "/shrine/maps/hub3.stats");
		frome3m1stat = strcat("profiles/", profilename, "/shrine/maps/e3m1.stats");
		frome3m2stat = strcat("profiles/", profilename, "/shrine/maps/e3m2.stats");
		frome3m3stat = strcat("profiles/", profilename, "/shrine/maps/e3m3.stats");
		frome3m4stat = strcat("profiles/", profilename, "/shrine/maps/e3m4.stats");
		frome3m5stat = strcat("profiles/", profilename, "/shrine/maps/e3m5.stats");
		fromboss3stat = strcat("profiles/", profilename, "/shrine/maps/boss3.stats");
	}

	if (istether == 3)
	{
		fromhub3stat = strcat("profiles/", profilename, "/autosave/maps/hub3.stats");
		frome3m1stat = strcat("profiles/", profilename, "/autosave/maps/e3m1.stats");
		frome3m2stat = strcat("profiles/", profilename, "/autosave/maps/e3m2.stats");
		frome3m3stat = strcat("profiles/", profilename, "/autosave/maps/e3m3.stats");
		frome3m4stat = strcat("profiles/", profilename, "/autosave/maps/e3m4.stats");
		frome3m5stat = strcat("profiles/", profilename, "/autosave/maps/e3m5.stats");
		fromboss3stat = strcat("profiles/", profilename, "/autosave/maps/boss3.stats");
	}

	fcopy_wrath(fromhub3stat, tohub3stat);
	fcopy_wrath(frome3m1stat, toe3m1stat);
	fcopy_wrath(frome3m2stat, toe3m2stat);
	fcopy_wrath(frome3m3stat, toe3m3stat);
	fcopy_wrath(frome3m4stat, toe3m4stat);
	fcopy_wrath(frome3m5stat, toe3m5stat);
	fcopy_wrath(fromboss3stat, toboss3stat);
};

void() load_tether = { cmd("set cvar_restoregame 2\n");
	cmd("slowmo 1\n");//cmd("r_glsl_saturation 1\n");
	read_currentprofileslot();
	load_save_maps(1);
	string cname;
	cname = strcat("load data/profiles/", profilename, "/tether.sav\n");
	//	bprint(cname);
	cmd("scratch3 0 \n");
	cmd(cname);
};
void() load_shrine = { cmd("set cvar_restoregame 3\n");
	cmd("slowmo 1\n");//cmd("r_glsl_saturation 1\n");
	read_currentprofileslot();
	load_save_maps(2);
	string cname;
	cname = strcat("load data/profiles/", profilename, "/shrine.sav\n");
	cmd("scratch3 0 \n");
	//	bprint(cname);
	cmd(cname);
};
void() load_autosave = { cmd("set cvar_restoregame 0\n");
	cmd("slowmo 1\n");//cmd("r_glsl_saturation 1\n");
	read_currentprofileslot();
	load_save_maps(3);
	string savename = strcat("profiles/", profilename, "/autosave.sav\n");

//	if(fexists(strcat ("data/",savename)))
//	{
		string cname = strcat("load ","data/", savename);
		cmd("scratch3 0 \n");
		cmd(cname);
//	}
//	else
//		cmd("restart\n");

};


// Reki (November 15 2023): String parsing helper functions
string str_removeblank(string s)
{
	// strip block comments
	#if 0
	float o = -1;
	while ((o = strstrofs(s, "/*", 0)) >= 0);
	{
		float d = strstrofs(s, "*/", o);
		s = substring(s, o, (d - o) + 1);
	}
	#endif

	// strip line comments
	float o = -1;
	o = strstrofs(s, "//", 0);
	s = substring(s, 0, o);

	// remove blank space
	string sb = substring(s, 0, 1);
	while (sb == " " || sb == "\t") { s = substring(s, 1, strlen(s)); }

	string sb = substring(s, -1, 1);
	while (sb == " " || sb == "\t") { s = substring(s, 0, strlen(s) - 1); }

	return s;
}

string str_replaceallwith(string s, string offender, string replace)
{
	float o = -1;
	while((o = strstrofs(s, offender, 0)) >= 0)
	{
		string s1 = substring(s, 0, o);
		string s2 = substring(s, o + strlen(offender), strlen(s));

		s = strcat(s1, replace, s2);
	}

	return s;
}

string XML_ParseEscapeString(string es)
{
	es = str_replaceallwith(es, "&lt;", "<");
	es = str_replaceallwith(es, "&gt;", ">");
	es = str_replaceallwith(es, "&amp;", "&");
	es = str_replaceallwith(es, "&apos;", "\'");
	es = str_replaceallwith(es, "&quot;", "\"");

	#if 1
	// parse hex characters
	float o = -1;
	while((o = strstrofs(es, "&#x", 0)) >= 0)
	{
		string s1 = substring(es, 0, o);
		float o_to = strstrofs(es, ";", o) - 1;
		string s2 = substring(es, o_to + 2, strlen(es));
		
		o = o + strlen("&#x");

		float valf = 0;
		string vals = substring(es, o, (o_to - o) + 1);
		for(float i = o_to; i >= o; i--)
		{
			string char = strtolower(substring(vals, i - o, 1));
			float charf = 0;
			switch (char)
			{
				case "a": charf = 10; break;
				case "b": charf = 11; break;
				case "c": charf = 12; break;
				case "d": charf = 13; break;
				case "e": charf = 14; break;
				case "f": charf = 15; break;
				default: charf = stof(char); break;
			}

			float placemult = (o_to - i);
			placemult = pow(16, placemult);
			
			charf *= placemult;
			//print("hex char: ", char, " : ", ftos(charf), "\n");
			valf += charf;
			//print("hex debug: ", ftos((o_to - i)), "\n");
		}
		//print("hex val: ", ftos(valf), "\n");

		es = strcat(s1, chr2str(valf), s2);
	}
	#endif
	#if 1
	// parse decimal characters
	float o = -1;
	while((o = strstrofs(es, "&#", 0)) >= 0)
	{
		string s1 = substring(es, 0, o);
		float o_to = strstrofs(es, ";", 0);
		string s2 = substring(es, o_to + 1, strlen(es));

		float valf = 0;
		string vals = substring(es, o + strlen("&#"), o_to - o);
		valf = stof(vals);
		
		es = strcat(s1, chr2str(valf), s2);
	}
	#endif

	return es;
}

// Reki (February 1 2024): parse info out of a .sav file (depends on 64 parms and version 5)
#define NUM_PARMS 64
typedef struct {
	string version;
	string info;
	//float parms[NUM_PARMS];
	string skill;
	string mapname;
} saveinfo_t;

void parse_savefile(string savpath, __out saveinfo_t info)
{
	float f = fopen(savpath, FILE_READ);
	if (f < 0)
		return;

	info.version = fgets(f);
	info.info = fgets(f);
	for(float i = 0; i < NUM_PARMS; i++)
		fgets(f); // skip all the parms, with FTE opcode extensions we could do info.parm[i] = stof(fgets(f))
	info.skill = fgets(f);
	info.mapname = fgets(f);

	fclose(f);
}
//

#define HIGHLIGHT_TEXT_COLOR '0.8 -0.8 -0.85'
#define OPTIONS_TEXT_COLOR '0.2 0.2 0.2'
#define OPTIONS_HEADER_COLOR '1 1 0.6'
#define OPTIONS_HEADER_TEXT_COLOR '1 1 0.7'
