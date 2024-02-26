// Reki (July 12 2023)
// population_control.qc:
// defines monster spawn limits
// only affects monsters placed via a spawner

var entity population_control; // tracks if we already defined population control parameters
..float pop_field; // pointer to the field for a given entity
.float max_fallen;
.float max_invader;
.float max_wretch;
.float max_prowler;
.float max_widow;
.float max_wraith;
.float max_heretic;
.float max_lurker;
.float max_oppressor;
.float max_executioner;
.float max_stricken;
.float max_afflicted;
.float max_symbol;
.float max_brute;
.float max_keeper;

const .float population_control_fields[] = {max_fallen, max_invader, max_wretch, max_prowler, max_widow, max_wraith, max_heretic, max_lurker, max_oppressor, max_executioner, max_stricken, max_afflicted, max_fallen, max_symbol, max_brute, max_keeper};
void() info_population_control {
	
	if (population_control)
	{
		remove(self);
		return;
	}

	population_control = self;

	for(float i = 0; i < population_control_fields.length; i++)
	{
		.float fld = population_control_fields[i];
		if (self.fld == 0) // ignore populations that aren't defined
			self.fld = -1;
	}
}

void(entity e) pop_entitycleanup {
	if (!population_control)
		return;

	if (e.pop_field == __NULL__)
		return;

	population_control.(e.pop_field)++; // add 1 to the population controller's field, since we subtracted 1 on spawn
	e.pop_field = __NULL__;
}

