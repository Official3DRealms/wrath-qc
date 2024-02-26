// Reki (September 6 2023):
// npc_scene.qc
// source file for the Shepherd NPC, and parsing .scene files
//
// Reki (February 14 2024): This didn't end up getting used, so it never got
// polished at all. I think it still has "oh that's neat" value so I'm not removing it.
// Hopefully you (modders/mappers) can get some use out of it.
/*
Scene files are a collection of commands, run in order.
Scenes are constructed at initial run-time, so changes made mid-game will not
be reflected. AKA reload your dang maps if you make changes, a save file will
only contain the state as it was parsed initially

Syntax is simple, a list of statements ended with a semicolon. Newlines shouldn't matter
The first word in a statement is the command, then follows parameters

'player' is a reserved name, always referencing player 1 (single_player)

Variables:
health
armor
darkarmor
items
relics
alpha
serverflags // kind of a hack, since this is a global and does not belong to a specific actor

Operators:
== 	// Equals
!=  // Not-Equals
> 	// Greater-than
<	// Less-than
& 	// BITAND

Available commands are:
initactor ACTORNAME; // ACTORNAME is the targetname of the entity you wish to register as an actor

setang ACTORNAME YAW; // YAW is the angle you want the ent to face, X+ orientation in Blender and should match with angle in radiant/TB
setangto ACTORNAME PATH; // PATH is a path_corner's targetname value you wish to match the actor's yaw to
setangsmooth ACTORNAME PATH SECONDS; // SECONDS is the time over which to change the actor's angles

move ACTORNAME "X Y Z"; // X/Y/Z are relative coordinates
moveto ACTORNAME PATH; // PATH is a path_corner's targetname value you wish to move the actor's origin to
movesmooth ACTORNAME PATH SECONDS // SECONDS is the time over which to move the actor

setmodel ACTORNAME "STRING"; // STRING is the path to the model, this will be automatically precached when this command is parsed
setframe ACTORNAME FNUM; // FNUM is the frame number, this should correspond to a framegroup or single frame

playmessage "STRING"; // STRING is the text you wish to send as a centerprint to all players
playsound ACTORNAME "STRING" ATTN TRAP; // STRING is the path to the sound (will be precached automatically), ATTN is an Attenuation value (0 being unattenuated), TRAP is a trapezoid-falloff factor for the sound (leave at 0 for normal quake behavior, vocalizations should probably have ~0.25)

runtarget NAME; // NAME is the targetname you wish to trigger, similar to a trigger_once or something
wait SECONDS; // SECONDS is the time to pause the current scene, good for manually-animated frame sequences or for letting an animation/dialogue play
marker NAME; // create a marker at this instruction called NAME
goto MARKER; // go to the named MARKER instruction

stopscene SCENENAME; // SCENENAME is the name of a scene that you want to force stop

varset ACTORNAME VARIABLE VALUE; // VARIABLE is one of the vars listed above, VALUE is the value to set it to
varadd ACTORNAME VARIABLE VALUE; // same as varset, but additive instead of absolute
varbitor ACTORNAME VARIABLE VALUE; // same as varset, but performs a |= operation
varbitand ACTORNAME VARIABLE VALUE; // same as varset, but performs a &= operation
varbitiand ACTORNAME VARIABLE VALUE; // same as varbitand but invert VALUE with ~ first

Logic commands:
if ACTORNAME VARIABLE OP VALUE; // VARIABLE is one of the vars listed above, OP is one of the operators listed above, VALUE is a constant number value
else; // if the statement is not true, run this. elif can be achieved with else;if ...
endif; // must accompany an if and/or else, otherwise this is an error
*/

static enum INSTRUCTION:float {
	NOP,
	INITACTOR,
	SETANG,
	MOVE,
	SETMODEL,
	SETFRAME,
	PLAYMESSAGE,
	PLAYSOUND,
	RUNTARGET,
	WAIT,
	MARKER,
	GOTO,
	STOPSCENE,
	VARSET,
	VARADD,
	VARBITOR,
	VARBITAND,
	IF,
	ELSE,
	ENDIF,
};

static class scene_c;
static class instruction_c {
	// header info
	scene_c scene;
	instruction_c _next;

	// instruction info
	//float type; // instruction type
	nonvirtual void() instruction_c;
	virtual void() op {};
};

static class actor_c {
	// string netname; // our name
	// entity owner; // our paired entity
	actor_c _next;
};

static class marker_c {
	// string netname; // our name
	marker_c _next;

	instruction_c instruct;
};

static class scene_c { // overall scene
	string filename;
	instruction_c instructions;
	instruction_c instructions_tail;
	actor_c actors;
	marker_c markers;
	instruction_c instruction_current;

	nonvirtual entity(string str) findactor {
		if !(str)
			return 0;

		if (str == "player")
			return single_player;
		
		// loop through our registered actors and find the right one
		for(actor_c lst = this.actors; lst; lst = lst._next)
		{
			if (lst.netname == str)
				return lst.owner;
		}

		return 0;
	};
};

// instruction constructor
void() instruction_c::instruction_c
{
	if (!this.scene)
	{
		remove(this);
		return;
	}

	if (scene.instructions == 0)
	{
		scene.instructions = this;
		scene.instructions_tail = this;
	}
	else
	{
		scene.instructions_tail._next = this;
		scene.instructions_tail = this;
	}
};
//

/* #region OP Codes */
static class initactor_c : instruction_c {
	float used;
	string name;

	nonvirtual void() initactor_c {
		this.type = INSTRUCTION::INITACTOR;
	};

	virtual void() op {
		if (this.used) // we only want to do this once, to prevent memory leaks
			return;
		this.used = TRUE;

		entity act_ent = find(world, ::targetname, this.name);
		if (!act_ent)
			return;
		
		actor_c cont = spawn(actor_c, owner: act_ent, netname: act_ent.targetname);
		cont._next = this.scene.actors;
		this.scene.actors = cont;
	};
};

static class setang_c : instruction_c {
	vector value;
	string actor;
	float is_smooth;

	nonvirtual void() setang_c {
		this.type = INSTRUCTION::SETANG;
	};

	virtual void() op {
		entity e = scene.findactor(actor);

		if (is_smooth) // smooth over time
		{
			static void() angle_smooth_over_time = {
				self.owner.angles += self.avelocity * 0.01;

				if (time >= self.attack_finished)
				{
					self.owner.angles = self.angles;
					remove(self);
					return;
				}

				self.think = angle_smooth_over_time;
				self.nextthink = time + 0.01;
			};

			entity mover = spawn();
			mover.think = angle_smooth_over_time;
			mover.nextthink = time + 0.01;

			mover.attack_finished = time + is_smooth;
			mover.angles = value;
			mover.avelocity[0] = angle_difference(value[0], e.angles[0]) / is_smooth;
			mover.avelocity[1] = angle_difference(value[1], e.angles[1]) / is_smooth;
			mover.avelocity[2] = angle_difference(value[2], e.angles[2]) / is_smooth;
			mover.owner = e;
		}
		else
		{
			e.angles = this.value;
		}
	};
};

static class move_c : instruction_c {
	vector value;
	string actor;
	float is_relative;
	float is_smooth;

	nonvirtual void() move_c {
		this.type = INSTRUCTION::MOVE;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		vector org = this.value;

		if (is_smooth) // smooth over time
		{
			static void() move_smooth_over_time = {
				self.owner.origin += self.velocity * 0.01;
				setorigin(self.owner, self.owner.origin);

				if (time >= self.attack_finished)
				{
					setorigin(self.owner, self.origin);
					remove(self);
					return;
				}

				self.think = move_smooth_over_time;
				self.nextthink = time + 0.01;
			};

			entity mover = spawn();
			mover.think = move_smooth_over_time;
			mover.nextthink = time + 0.01;

			mover.attack_finished = time + is_smooth;
			mover.velocity = (value - e.origin) / is_smooth;
			mover.origin = value;
			mover.owner = e;
		}
		else
		{
			if (is_relative)
				org += e.origin;
			setorigin(e, org);
		}
	};
};

static class setmodel_c : instruction_c {
	string value;
	string actor;

	nonvirtual void() setmodel_c {
		this.type = INSTRUCTION::SETMODEL;

		if (this.value)
			precache_model(this.value);
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		setmodel(e, this.value);
	};
};

static class setframe_c : instruction_c {
	float value;
	string actor;

	nonvirtual void() setframe_c {
		this.type = INSTRUCTION::SETFRAME;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		e.frame = this.value;
		e.frame1time = time;
	};
};

static class playmessage_c : instruction_c {
	string value;

	nonvirtual void() playmessage_c {
		this.type = INSTRUCTION::PLAYMESSAGE;
	};

	virtual void() op {
		// loop through all players and print
		for(entity lst = findflags(world, ::flags, FL_CLIENT); lst; lst = findflags(lst, ::flags, FL_CLIENT))
		{
			centerprint(lst, this.value);
		}
	};
};

static class playsound_c : instruction_c {
	string value;
	//float atten;
	//float trapezoid_sound;
	string actor;

	nonvirtual void() playsound_c {
		this.type = INSTRUCTION::PLAYSOUND;
		if (this.value)
			precache_sound(this.value);
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		soundwrath(e, CHAN_AUTO, this.value, 1, this.atten, 0, 0, this.trapezoid_sound);
	};
};

static class runtarget_c : instruction_c {
	string value;

	nonvirtual void() runtarget_c {
		this.type = INSTRUCTION::RUNTARGET;
	};

	virtual void() op {
		this.target = this.value;
		SUB_UseTargets();
	};
};

static class wait_c : instruction_c {
	float value;

	nonvirtual void() wait_c {
		this.type = INSTRUCTION::WAIT;
	};

	virtual void() op {
		scene.attack_finished = time + this.value;
	};
};

static class initmarker_c : instruction_c {
	float used;
	string name;

	nonvirtual void() initmarker_c {
		this.type = INSTRUCTION::MARKER;
	};

	virtual void() op {
		if (this.used) // we only want to do this once, to prevent memory leaks
			return;
		this.used = TRUE;

		marker_c cont = spawn(marker_c, netname: this.name, instruct: this);
		cont._next = this.scene.markers;
		this.scene.markers = cont;
	};
};

static class goto_c : instruction_c {
	string name;

	nonvirtual void() goto_c {
		this.type = INSTRUCTION::GOTO;
	};

	virtual void() op {
		for(marker_c lst = scene.markers; lst; lst = lst._next)
		{
			if (lst.netname != this.name)
				continue;

			scene.instruction_current = lst.instruct._next;
		}
	};
};


static class stopscene_c : instruction_c {
	string name;

	nonvirtual void() stopscene_c {
		this.type = INSTRUCTION::STOPSCENE;
	};

	virtual void() op {
		for(entity e = find(world, ::classname, "scene_c"); e; e = find(e, ::classname, "scene_c"))
		{
			if (e.message != name)
				continue;

			scene_c killscene = (scene_c)e;
			killscene.instruction_current = 0;
		}
	};
};


// variable stuff
static enum VARIABLE:float {
	HEALTH,
	ARMOR,
	DARKARMOR,
	ITEMS,
	RELICS,
	ALPHA,
	SERVERFLAGS,
};

static .float VARFLD[] = {
	::health,
	::armorvalue,
	::darmorvalue,
	::items,
	::relics,
	::alpha,
	::flags,
};


static class varmod_c : instruction_c {
	float value;
	float fldindex; // entity field type
	string actor;

	nonvirtual void() varmod_c {
		if (!this.netname)
		{
			remove(this);
			return;
		}

		if (this.netname == "health")
			this.fldindex = VARIABLE::HEALTH;
		else if (this.netname == "armor")
			this.fldindex = VARIABLE::ARMOR;
		else if (this.netname == "darkarmor")
			this.fldindex = VARIABLE::DARKARMOR;
		else if (this.netname == "items")
			this.fldindex = VARIABLE::ITEMS;
		else if (this.netname == "relics")
			this.fldindex = VARIABLE::RELICS;
		else if (this.netname == "alpha")
			this.fldindex = VARIABLE::ALPHA;
		else if (this.netname == "serverflags")
			this.fldindex = VARIABLE::SERVERFLAGS;

		this.netname = 0;
	};

	virtual void() op {
		//entity e = scene.findactor(actor);
	};
};

static class varset_c : varmod_c {
	nonvirtual void() varset_c {
		this.type = INSTRUCTION::VARSET;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		.float fld = ::VARFLD[fldindex];

		if (fldindex == VARIABLE::SERVERFLAGS) // HACK: allow serverflags global to be set, even if it's not a field
			serverflags = value;
		else 
			e.fld = value;
	};
};

static class varadd_c : varmod_c {
	nonvirtual void() varadd_c {
		this.type = INSTRUCTION::VARADD;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		.float fld = ::VARFLD[fldindex];

		if (fldindex == VARIABLE::SERVERFLAGS) // HACK: allow serverflags global to be set, even if it's not a field
			serverflags += value;
		else 
			e.fld += value;
	};
};

static class varbitor_c : varmod_c {
	nonvirtual void() logicelse_c {
		this.type = INSTRUCTION::VARBITOR;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		.float fld = ::VARFLD[fldindex];

		if (fldindex == VARIABLE::SERVERFLAGS) // HACK: allow serverflags global to be set, even if it's not a field
			serverflags |= value;
		else 
			e.fld |= value;
	};
};

static class varbitand_c : varmod_c {
	nonvirtual void() logicelse_c {
		this.type = INSTRUCTION::VARBITAND;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		.float fld = ::VARFLD[fldindex];

		if (fldindex == VARIABLE::SERVERFLAGS) // HACK: allow serverflags global to be set, even if it's not a field
			serverflags &= value;
		else 
			e.fld &= value;
	};
};
//

// logic stuff
static enum LOGICOP:float {
	EQUALS,
	NOTEQUALS,
	GREATERTHAN,
	LESSTHAN,
	BITAND,
};

static class logic_c : instruction_c {
	instruction_c instruct_endof;
};

static class logicif_c : logic_c {
	float value;
	float fldindex; // entity field type
	float operator;
	string op_str;
	string actor;

	nonvirtual void() logicif_c {
		if (!this.netname)
		{
			remove(this);
			return;
		}

		this.type = INSTRUCTION::IF;

		if (this.netname == "health")
			this.fldindex = VARIABLE::HEALTH;
		else if (this.netname == "armor")
			this.fldindex = VARIABLE::ARMOR;
		else if (this.netname == "darkarmor")
			this.fldindex = VARIABLE::DARKARMOR;
		else if (this.netname == "items")
			this.fldindex = VARIABLE::ITEMS;
		else if (this.netname == "relics")
			this.fldindex = VARIABLE::RELICS;
		else if (this.netname == "alpha")
			this.fldindex = VARIABLE::ALPHA;
		else if (this.netname == "serverflags")
			this.fldindex = VARIABLE::SERVERFLAGS;

		if (this.op_str == "==")
			this.operator = LOGICOP::EQUALS;
		else if (this.op_str == "!=")
			this.operator = LOGICOP::NOTEQUALS;
		else if (this.op_str == ">")
			this.operator = LOGICOP::GREATERTHAN;
		else if (this.op_str == "<")
			this.operator = LOGICOP::LESSTHAN;
		else if (this.op_str == "&")
			this.operator = LOGICOP::BITAND;
		
		this.op_str = 0;
		this.netname = 0;
	};

	virtual void() op {
		entity e = scene.findactor(actor);
		.float fld = ::VARFLD[fldindex];
		float val = e.fld;
		if (fldindex == VARIABLE::SERVERFLAGS)
			val = serverflags;

		float skip_to_end = TRUE;

		if (operator == LOGICOP::EQUALS)
		{
			if (val == value)
				skip_to_end = FALSE;
		}
		else if (operator == LOGICOP::NOTEQUALS)
		{
			if (val != value)
				skip_to_end = FALSE;
		}
		else if (operator == LOGICOP::GREATERTHAN)
		{
			if (val > value)
				skip_to_end = FALSE;
		}
		else if (operator == LOGICOP::LESSTHAN)
		{
			if (val < value)
				skip_to_end = FALSE;
		}
		else if (operator == LOGICOP::BITAND)
		{
			if (val & value)
				skip_to_end = FALSE;
		}

		if (skip_to_end)
		{
			instruct_endof.flags &= ~FL_NOTARGET; // we use FL_NOTARGET to tell the else statement if it should run, weird and hacky but it seemed like a good idea at the time
			scene.instruction_current = instruct_endof;
		}
		else
		{
			instruct_endof.flags |= FL_NOTARGET; // mark our ELSE as no-run, since we succeeded
		}
	};
};

static class logicelse_c : logic_c {
	nonvirtual void() logicelse_c {
		this.type = INSTRUCTION::ELSE;
	};

	virtual void() op {
		if (this.flags & FL_NOTARGET) // the corresponding if succeeded, so we need to skip!
			scene.instruction_current = instruct_endof;
	};
};

static class logicendif_c : instruction_c {
	nonvirtual void() logicendif_c {
		this.type = INSTRUCTION::ENDIF;
	};
	// just a NOP, really
};
//
/* #endregion */

/* #region .scene Parsing */
static string StripComment(string ln)
{
	float ofs = strstrofs(ln, "//", 0);
	ln = substring(ln, 0, ofs);
	return ln;
}

static string StripCommand(string ln)
{
	while(substring(ln, 0, 1) == " " || substring(ln, 0, 1) == "	")
	{
		ln = substring(ln, 1, strlen(ln) - 1);
	}
	return ln;
}

static logic_c if_logic_stack;
static float GenerateCommand(scene_c sc, string cmdstr)
{
	float argc = tokenize_console(cmdstr);
	if (argc == 0) // NOP
		return TRUE;

	string cmd = argv(0);
	switch (cmd)
	{
		// init
		case "initactor":
			initactor_c actor = spawn(initactor_c, scene: sc, name: strzone(argv(1)));
			dprint("init actor command! ", actor.name, "\n");
			break;

		// angles
		case "setang":
			setang_c ang = spawn(setang_c, scene: sc, actor: strzone(argv(1)), value: [0, stof(argv(2)), 0]);
			break;
		case "setangto":
			entity path = find(world, ::targetname, argv(2));
			setang_c ang = spawn(setang_c, scene: sc, actor: strzone(argv(1)), value: path.angles);
			break;
		case "setangsmooth":
			entity path = find(world, ::targetname, argv(2));
			setang_c ang = spawn(setang_c, scene: sc, actor: strzone(argv(1)), value: path.angles, is_smooth: fabs(stof(argv(3))));
			break;
		
		// move
		case "move":
			move_c move = spawn(move_c, scene: sc, actor: strzone(argv(1)), value: stov(argv(2)), is_relative: 1);
			break;
		case "moveto":
			entity path = find(world, ::targetname, argv(2));
			move_c move = spawn(move_c, scene: sc, actor: strzone(argv(1)), value: path.origin);
			break;
		case "movesmooth":
			entity path = find(world, ::targetname, argv(2));
			move_c move = spawn(move_c, scene: sc, actor: strzone(argv(1)), value: path.origin, is_smooth: fabs(stof(argv(3))));
			break;
		
		// setmodel
		case "setmodel":
			setmodel_c mod = spawn(setmodel_c, scene: sc, actor: strzone(argv(1)), value: strzone(argv(2)));
			break;

		// setframe
		case "setframe":
			setframe_c frm = spawn(setframe_c, scene: sc, actor: strzone(argv(1)), value: stof(argv(2)));
			break;

		// playmessage
		case "playmessage":
			playmessage_c msg = spawn(playmessage_c, scene: sc, value: strzone(argv(1)));
			break;

		// playsound
		case "playsound":
			playsound_c snd = spawn(playsound_c, scene: sc, actor: strzone(argv(1)), value: strzone(argv(2)), atten: stof(argv(3)), trapezoid_sound: stof(argv(4)));
			break;

		// runtarget
		case "runtarget":
			runtarget_c targ = spawn(runtarget_c, scene: sc, value: strzone(argv(1)));
			break;

		// wait
		case "wait":
			wait_c wait = spawn(wait_c, scene: sc, value: stof(argv(1)));
			dprint("wait command! ", ftos(wait.value), "\n");
			break;

		// marker
		case "mark":
		case "marker":
			initmarker_c mrk = spawn(initmarker_c, scene: sc, name: strzone(argv(1)));
			break;

		// goto
		case "goto":
			goto_c gt = spawn(goto_c, scene: sc, name: strzone(argv(1)));
			break;

		// goto
		case "stopscene":
			stopscene_c ssc = spawn(stopscene_c, scene: sc, name: strzone(argv(1)));
			break;

		// variable funcs
		case "varset":
			varset_c v1 = spawn(varset_c, scene: sc, actor: strzone(argv(1)), netname: argv(2), value: stof(argv(3)));
			break;
		case "varadd":
			varadd_c v2 = spawn(varadd_c, scene: sc, actor: strzone(argv(1)), netname: argv(2), value: stof(argv(3)));
			break;
		case "varbitor":
			varbitor_c v3 = spawn(varbitor_c, scene: sc, actor: strzone(argv(1)), netname: argv(2), value: stof(argv(3)));
			break;
		case "varbitand":
			varbitand_c v4 = spawn(varbitand_c, scene: sc, actor: strzone(argv(1)), netname: argv(2), value: stof(argv(3)));
			break;
		case "varbitiand":
			varbitand_c v4 = spawn(varbitand_c, scene: sc, actor: strzone(argv(1)), netname: argv(2), value: ~(stof(argv(3))));
			break;

		// logic cmds
		case "if":
			logicif_c cif = spawn(logicif_c, scene: sc, actor: strzone(argv(1)), netname: argv(2), op_str: argv(3), value: stof(argv(4)));
			cif.chain = if_logic_stack;
			if_logic_stack = cif;
			break;
		case "else":
			logicelse_c celse = spawn(logicelse_c, scene: sc);
			if (if_logic_stack)
			{
				if_logic_stack.instruct_endof = celse;
				if_logic_stack = (logic_c)if_logic_stack.chain;
			}
			celse.chain = if_logic_stack;
			if_logic_stack = celse;
			break;
		case "endif":
			logicendif_c cendif = spawn(logicendif_c, scene: sc);
			if (if_logic_stack)
			{
				if_logic_stack.instruct_endof = cendif;
				if_logic_stack = (logic_c)if_logic_stack.chain;
			}
			break;
		
		// bad cmd
		default:
			dprint("^1BAD SCENE COMMAND: ", cmd, "\n");
			break;
	}
}

static void Scene_Think()
{
	scene_c currentscene = (scene_c)self;

	if !(currentscene.instruction_current)
		return;

	while (time > currentscene.attack_finished)
	{
		if !(currentscene.instruction_current)
			break;

		instruction_c opcode = currentscene.instruction_current;
		currentscene.instruction_current = opcode._next;
		//dprint(sprintf("^3SCENE RUNNING OPCODE OF TYPE %.0f (%s)\n", opcode.type, opcode.classname));
		opcode.op();
	}

	currentscene.think = Scene_Think;
	currentscene.nextthink = time + 0.0138;
}

static void Scene_Use()
{
	scene_c currentscene = (scene_c)self;
	currentscene.think = Scene_Think;
	currentscene.nextthink = time + 0.0138;
	currentscene.instruction_current = currentscene.instructions;
}

static scene_c Scene_ParseFile(string filename)
{
	float f = fopen(filename, FILE_READ);
	if (f < 0)
	{
		dprint(sprintf("^3Scene file not found: %s\n", filename));
		return 0;
	}

	scene_c currentscene = spawn(scene_c);
	currentscene.use = Scene_Use;

	string commands;
	float blankcount;
	while(blankcount < 30) // yuck, stupid DP not telling EOF
	{
		string ln = fgets(f);
		if (ln == __NULL__)
		{
			blankcount++;
			continue;
		}

		ln = StripComment(ln);
		commands = strcat(commands, ln);
	}
	
	// we need to allocate dynamic memory the only way we know how... entities :\
	// this is because we can't store the current state of tokenize, so while we're
	// generating the op codes we'll run into big issues when we try to tokenize the
	// commands.
	entity commandlist_first;
	entity commandlist_last;
	float numcmds = tokenizebyseparator(commands, ";");
	dprint(sprintf("^3Scene file: %s with %.0f commands\n", filename, numcmds));
	for(float i = 0; i < numcmds; i++)
	{
		//dprint("    ", StripCommand(argv(i)), "\n");
		string cmd = StripCommand(argv(i));
		entity cmdent = spawn();

		cmdent.netname = StripCommand(argv(i)); // pray that DP can allocate enough tempstring space for us!

		if (!commandlist_first) // the first command
		{
			commandlist_first = cmdent;
			commandlist_last = cmdent;
			continue;
		}

		commandlist_last.chain = cmdent;
		commandlist_last = cmdent;
	}

	if_logic_stack = 0;
	for(entity lst = commandlist_first, entity hld; lst; hld = lst, lst = lst.chain, remove(hld))
	{
		dprint(">>  ", lst.netname, "\n"); // print whole command out to debug console
		GenerateCommand(currentscene, lst.netname);
	}

	if (if_logic_stack)
	{
		dprint("^1SYNTAX ERROR: HANGING IF OR ELSE, PLEASE FIX YOUR LOGIC\n");
		if_logic_stack = 0;
	}

	fclose(f);

	return currentscene;
}

void info_scene_init(void)
{
	scene_c currentscene = Scene_ParseFile(self.message);
	if !(currentscene)
		return;

	currentscene.targetname = self.targetname;
}

void spawnfunc_info_scene(void)
{
	if (!self.message)
	{
		remove(self);
		return;
	}

	self.think = info_scene_init;
	self.nextthink = time + 0.1;
}
/* #endregion */