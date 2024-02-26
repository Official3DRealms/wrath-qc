void() monster_army = { monster_invader();
};

void() monster_enforcer = { monster_wretch();
};
void() monster_knight = { monster_widow();
};
void() monster_ogre = { monster_afflicted();
};
void() monster_wizard = { monster_heretic();
};
void() monster_demon1 = { monster_executioner();
};
void() monster_zombie = { monster_fallen();
};
void() monster_shambler = { monster_stricken();
};

void() weapon_coachgun = {weapon_revolver();};
void()weapon_chrystaliser= {weapon_crystal();};
void()ammo_slugs= {spawnfunc_ammo_revolver();};
void()spawnfunc_ammo_shells = {spawnfunc_ammo_shotgun();};
void()ammo_fangs= {spawnfunc_ammo_spitter();};
void()ammo_cysts= {spawnfunc_ammo_retcher();};
void()ammo_ore= {spawnfunc_ammo_lance();};
void() ammo_cruor = 
{
	spawnfunc_ammo_crystal();
};

void() ammo_spore = 
{
	spawnfunc_ammo_lance();
};

void() relic_map1 = { relic_e1m1();};
void() relic_map2 = { relic_e1m2();};
void() relic_map3 = { relic_e1m3();};
void() relic_map4 = { relic_e1m4();};
void() relic_map5 = { relic_e1m2();};
////////////////end of qc file
