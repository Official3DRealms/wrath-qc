//////////////////////////////////////////////////////////
// sys globals

entity self;

/////////////////////////////////////////////////////////
void		end_sys_globals;
/////////////////////////////////////////////////////////
// sys fields

/////////////////////////////////////////////////////////
void		end_sys_fields;
/////////////////////////////////////////////////////////
// sys functions

void() m_init;
void(float keynr, float ascii) m_keydown;
void(float width, float height) m_draw;
void(float mode) m_toggle;
void() m_shutdown;
void Menu_RendererRestarted();
// optional: float(float) m_gethostcachecategory;

/////////////////////////////////////////////////////////
// sys constants
///////////////////////////
// key dest constants

float KEY_UNKNOWN	= 	-1;
float KEY_GAME 		=	0;
float KEY_MENU		=	2;
float KEY_MENU_GRABBED	= 	3;

///////////////////////////
// file constants

float FILE_READ = 0;
float FILE_APPEND = 1;
float FILE_WRITE = 2;

///////////////////////////
// logical constants (just for completeness)

float TRUE 	= 1;
float FALSE = 0;

///////////////////////////
// boolean constants

float true = 1;
float false = 0;

///////////////////////////
// msg constants

float MSG_BROADCAST		= 0;		// unreliable to all
float MSG_ONE			= 1;		// reliable to one (msg_entity)
float MSG_ALL			= 2;		// reliable to all
float MSG_INIT			= 3;		// write to the init string

/////////////////////////////
// mouse target constants

float MT_MENU = 1;
float MT_CLIENT = 2;

/////////////////////////
// client state constants

float CS_DEDICATED 		= 0;
float CS_DISCONNECTED 	= 1;
float CS_CONNECTED		= 2;

///////////////////////////
// blend flags

float DRAWFLAG_NORMAL		= 0;
float DRAWFLAG_ADDITIVE 	= 1;
float DRAWFLAG_MODULATE 	= 2;
float DRAWFLAG_2XMODULATE   = 3;

///////////////////////////
// null entity (actually it is the same like the world entity)

entity null_entity;

///////////////////////////
// error constants

// file handling
float ERR_CANNOTOPEN			= -1; // fopen
float ERR_NOTENOUGHFILEHANDLES 	= -2; // fopen
float ERR_INVALIDMODE 			= -3; // fopen
float ERR_BADFILENAME 			= -4; // fopen

// drawing functions

float ERR_NULLSTRING			= -1;
float ERR_BADDRAWFLAG			= -2;
float ERR_BADSCALE				= -3;
float ERR_BADSIZE				= -3; // same as ERR_BADSCALE
float ERR_NOTCACHED				= -4;

// server list stuff
float SLIST_HOSTCACHEVIEWCOUNT  = 0;
float SLIST_HOSTCACHETOTALCOUNT = 1;
float SLIST_MASTERQUERYCOUNT 	= 2;
float SLIST_MASTERREPLYCOUNT 	= 3;
float SLIST_SERVERQUERYCOUNT 	= 4;
float SLIST_SERVERREPLYCOUNT 	= 5;
float SLIST_SORTFIELD		= 6;
float SLIST_SORTDESCENDING	= 7;
float SLIST_LEGACY_LINE1 	= 1024;
float SLIST_LEGACY_LINE2 	= 1025;
float SLIST_TEST_CONTAINS	= 0;
float SLIST_TEST_NOTCONTAIN	= 1;
float SLIST_TEST_LESSEQUAL	= 2;
float SLIST_TEST_LESS		= 3;
float SLIST_TEST_EQUAL		= 4;
float SLIST_TEST_GREATER	= 5;
float SLIST_TEST_GREATEREQUAL	= 6;
float SLIST_TEST_NOTEQUAL	= 7;
float SLIST_TEST_STARTSWITH	= 8;
float SLIST_TEST_NOTSTARTSWITH	= 9;
float SLIST_MASK_AND = 0;
float SLIST_MASK_OR  = 512;

// font stuff
float FONT_DEFAULT     = 0;
float FONT_CONSOLE     = 1;
float FONT_SBAR        = 2;
float FONT_NOTIFY      = 3;
float FONT_CHAT        = 4;
float FONT_CENTERPRINT = 5;
float FONT_INFOBAR     = 6;
float FONT_MENU        = 7;
float FONT_USER        = 8; // add to this the index, like FONT_USER+3 = user3. At least 8 of them are supported.
#define FONT_USER0	(FONT_USER)
#define FONT_USER1	(FONT_USER + 1)
#define FONT_USER2	(FONT_USER + 2)
#define FONT_USER3	(FONT_USER + 3)
#define FONT_USER4	(FONT_USER + 4)
#define FONT_USER5	(FONT_USER + 5)
#define FONT_USER6	(FONT_USER + 6)
#define FONT_USER7	(FONT_USER + 7)
float drawfont;

/* not supported at the moment
///////////////////////////
// os constants

float OS_WINDOWS	= 0;
float OS_LINUX		= 1;
float OS_MAC		= 2;
*/










//////////////////////////////////////////////////
// common cmd
//////////////////////////////////////////////////
// AK FIXME: Create perhaps a special builtin file for the common cmds

void 	checkextension(string ext) 	= #1;

// error cmds
void 	error(string err,...) 		= #2;
void 	objerror(string err,...) 	= #3;

// print

void 	print(string text,...) 		 	 = #4;
void 	bprint(string text,...)			 = #5;
void	sprint(float clientnum, string text,...) = #6;
void 	centerprint(string text,...)		 = #7;

// vector stuff

vector	normalize(vector v) 		= #8;
float 	vlen(vector v)			= #9;
float  	vectoyaw(vector v)		= #10;
vector 	vectoangles(vector v)		= #11;

float	random(void)  = #12;

void	cmd(string command, ...) = #13;

// cvar cmds

float 	cvar(string name) 			= #14;
const string str_cvar(string name)		= #71;
void	cvar_set(string name, string value)	= #15;

void	dprint(string text,...) = #16;

// conversion functions

string	ftos(float f)  	= #17;
float	fabs(float f)	= #18;
string	vtos(vector v)  = #19;
string	etos(entity e)	= #20;

float	stof(string val,...)  = #21;

entity	spawn(void) 		= #22;
void	remove(entity e) 	= #23;

entity	find(entity start, .string field, string match)  	= #24;
entity	findfloat(entity start, .float field, float match) 	= #25;
entity	findentity(entity start, .entity field, entity match) 	= #25;

entity	findchainstring(.string field, string match) 	= #26;
entity	findchainfloat(.float field, float match) 	= #27;
entity	findchainentity(.entity field, entity match)	= #27;

string	precache_file(string file) 	= #28;
string	precache_sound(string sample) 	= #29;

void	crash(void)	= #72;
void	coredump(void) 	= #30;
void	stackdump(void) = #73;
void	traceon(void) 	= #31;
void	traceoff(void) 	= #32;

void	eprint(entity e)  	= #33;
float	rint(float f) 		= #34;
float	floor(float f)  	= #35;
float	ceil(float f)  		= #36;
entity	nextent(entity e)  	= #37;
float	sin(float f)  		= #38;
float	cos(float f)  		= #39;
float	sqrt(float f)  		= #40;
vector	randomvec(void)  	= #41;

float	registercvar(string name, string value, float flags)  = #42; // returns 1 if success

float	min(float f,...)  = #43;
float	max(float f,...)  = #44;

float	bound(float min,float value, float max)  = #45;
float	pow(float a, float b)  = #46;

void	copyentity(entity src, entity dst)  = #47;

#if DEBUG
string(string format, ...) sprintf;
float(string filename, float mode) fopen_engine = #48; // opens a file inside quake/gamedir/data/ (mode is FILE_READ, FILE_APPEND, or FILE_WRITE), returns fhandle >= 0 if successful, or fhandle < 0 if unable to open file for any reason
void(float fhandle) fclose_engine = #49; // closes a file
float(string filename, float mode) fopen = { float f = fopen_engine(filename, mode); print(sprintf("MENUQC: %s(%s, %g)... %g\n", __func__, filename, mode, f)); return f;  };
void(float fhandle) fclose = { print(sprintf("MENUQC: %s(%g)\n", __func__, fhandle)); fclose_engine(fhandle); };
#else
float fopen(string filename, float mode)  = #48;
void fclose(float fhandle)  = #49;
#endif
string	fgets(float fhandle)  = #50;
void	fputs(float fhandle, string s)  = #51;

float	strlen(string s)  = #52;
string	strcat(string s1,string s2,...)  = #53;
string	substring(string s, float start, float length)  =  #54;// #116 FTE enhanced version

vector	stov(string s)  = #55;

string	strzone(string s)  = #56;
void	strunzone(string s) = #57;

float	tokenize(string s)  = #58;
string	argv(float n)  = #59;

float	isserver(void)  = #60;
float	clientcount(void)  = #61;
float	clientstate(void)  = #62;
void	clientcommand(float client, string s)  = #63;
void	changelevel(string map)  = #64;
void	localsound(string sample)  = #65;
vector	getmousepos(void)  	= #66;
float	gettime(void)		= #67;
void 	loadfromdata(string data) = #68;
void	loadfromfile(string file) = #69;

float	mod(float val, float m) = #70;

float	search_begin(string pattern, float caseinsensitive, float quiet) = #74;
void	search_end(float handle) = #75;
float	search_getsize(float handle) = #76;
string	search_getfilename(float handle, float num) = #77;

string	chr(float ascii) = #78;

/////////////////////////////////////////////////
// Write* Functions
/////////////////////////////////////////////////
void	WriteByte(float data, float dest, float desto)	= #401;
void	WriteChar(float data, float dest, float desto)	= #402;
void	WriteShort(float data, float dest, float desto)	= #403;
void	WriteLong(float data, float dest, float desto)	= #404;
void	WriteAngle(float data, float dest, float desto)	= #405;
void	WriteCoord(float data, float dest, float desto)	= #406;
void	WriteString(string data, float dest, float desto)= #407;
void	WriteEntity(entity data, float dest, float desto) = #408;

//////////////////////////////////////////////////
// Draw funtions
//////////////////////////////////////////////////

float	iscachedpic(string name)	= #451;
string	precache_pic(string name, ...)	= #452;
void	freepic(string name)		= #453;

float	drawcharacter(vector position, float character, vector scale, vector rgb, float alpha, float flag) = #454;

float	drawstring(vector position, string text, vector scale, vector rgb, float alpha, float flag) = #455;

float	drawcolorcodedstring(vector position, string text, vector scale, float alpha, float flag) = #467;

vector	drawcolorcodedstring2(vector position, string text, vector scale, vector rgb, float alpha, float flag) = #467;
 
float	drawpic(vector position, string pic, vector size, vector rgb, float alpha, float flag) = #456;

float	drawfill(vector position, vector size, vector rgb, float alpha, float flag) = #457;

void	drawsetcliparea(float x, float y, float width, float height) = #458;

void	drawresetcliparea(void) = #459;

vector  drawgetimagesize(string pic) = #460;

////////////////////////////////////////////////
// Menu functions
////////////////////////////////////////////////

void	setkeydest(float dest) 	= #601;
float	getkeydest(void)	= #602;

void	setmousetarget(float trg) = #603;
float	getmousetarget(void)	  = #604;

float	isfunction(string function_name) = #607;
void	callfunction(...) = #605;
void	writetofile(float fhandle, entity ent) = #606;
vector	getresolution(float number, ...) = #608; // optional argument "isfullscreen"
string	keynumtostring(float keynum) = #609;

float	gethostcachevalue(float type) = #611;
string	gethostcachestring(float type, float hostnr) = #612;

//DP_CSQC_BINDMAPS
//idea: daemon, motorsep
//darkplaces implementation: divVerent
//builtin definitions:
string(float key, float bindmap) getkeybind_bindmap = #342;
float(float key, string bind, float bindmap) setkeybind_bindmap = #630;
vector(void) getbindmaps = #631;
float(vector bm) setbindmaps = #632;
string(string command, float bindmap) findkeysforcommand = #610;
float(string key) stringtokeynum = #341;
//<also allowed builtin number to match EXT_CSQC> string(float keynum) keynumtostring = #340;
//description: key bind setting/getting including support for switchable
//bindmaps.

//DP_CRYPTO
//idea: divVerent
//darkplaces implementation: divVerent
//field definitions: (MENUQC)
string(string serveraddress) crypto_getkeyfp = #633; // retrieves the cached host key's CA fingerprint of a server given by IP address
string(string serveraddress) crypto_getidfp = #634; // retrieves the cached host key fingerprint of a server given by IP address
float(string serveraddress) crypto_getidstatus = #643; // retrieves the cached host key's key status. See below for CRYPTO_IDSTATUS_ defines.
string(string serveraddress) crypto_getencryptlevel = #635; // 0 if never encrypting, 1 supported, 2 requested, 3 required, appended by list of allowed methods in order of preference ("AES128"), preceded by a space each
string(float i) crypto_getmykeyfp = #636; // retrieves the CA key fingerprint of a given CA slot, or "" if slot is unused but more to come, or string_null if end of list
string(float i) crypto_getmyidfp = #637; // retrieves the ID fingerprint of a given CA slot, or "" if slot is unused but more to come, or string_null if end of list
float CRYPTO_IDSTATUS_OUTOFRANGE = -1;
float CRYPTO_IDSTATUS_EMPTY = 0;
float CRYPTO_IDSTATUS_UNSIGNED = 1;
float CRYPTO_IDSTATUS_SIGNED = 2;
float(float i) crypto_getmyidstatus = #641; // retrieves the ID's status of a given CA slot, or 0 if slot is unused but more to come, or -1 if end of list
float(string url, float id, string content_type, string delim, float buf, float keyid) crypto_uri_postbuf = #513;
//description:
//use -1 as buffer handle to justs end delim as postdata

//DP_GECKO_SUPPORT
//idea: Res2k, BlackHC
//darkplaces implementation: Res2k, BlackHC
//constant definitions:
float GECKO_BUTTON_DOWN         = 0;
float GECKO_BUTTON_UP           = 1;
// either use down and up or just press but not all of them!
float GECKO_BUTTON_PRESS        = 2;
// use this for mouse events if needed?
float GECKO_BUTTON_DOUBLECLICK  = 3;
//builtin definitions:
float gecko_create( string name ) = #487;
void gecko_destroy( string name ) = #488;
void gecko_navigate( string name, string URI ) = #489;
float gecko_keyevent( string name, float key, float eventtype ) = #490;
void gecko_mousemove( string name, float x, float y ) = #491;
void gecko_resize( string name, float w, float h ) = #492;
vector gecko_get_texture_extent( string name ) = #493;
//engine-called QC prototypes:
//string(string name, string query) Qecko_Query;
//description:
//provides an interface to the offscreengecko library and allows for internet browsing in games

//FTE_STRINGS
//idea: many
//darkplaces implementation: KrimZon
//description:
//various string manipulation functions
float(string str, string sub, float startpos) strstrofs = #221;
float(string str, float ofs) str2chr = #222;
string(float c, ...) chr2str = #223;
string(float ccase, float calpha, float cnum, string s, ...) strconv = #224;
string(float chars, string s, ...) strpad = #225;
string(string info, string key, string value, ...) infoadd = #226;
string(string info, string key) infoget = #227;
float(string s1, string s2) strcmp = #228;
float(string s1, string s2, float len) strncmp = #228;
float(string s1, string s2) strcasecmp = #229;
float(string s1, string s2, float len) strncasecmp = #230;

float loadfont(string fontname, string fontmaps, string sizes, float slot, float fix_scale, float fix_voffset) = #357;

//DP_PRECACHE_PIC_FLAGS
//idea: divVerent
//darkplaces implementation: divVerent
//constant definitions:
float PRECACHE_PIC_FROMWAD = 1; // this one actually is part of EXT_CSQC
float PRECACHE_PIC_NOTPERSISTENT = 2; // picture may get deallocated when unused
float PRECACHE_PIC_MIPMAP = 8; // mipmap the texture for possibly better downscaling at memory expense
//notes: these constants are given as optional second argument to precache_pic()

//DP_QC_CRC16
//idea: div0
//darkplaces implementation: div0
//Some hash function to build hash tables with. This has to be be the CRC-16-CCITT that is also required for the QuakeWorld download protocol.
//When caseinsensitive is set, the CRC is calculated of the lower cased string.
float(float caseinsensitive, string s, ...) crc16 = #494;

//DP_QC_CVAR_TYPE
float(string name) cvar_type = #495;
float CVAR_TYPEFLAG_EXISTS = 1;
float CVAR_TYPEFLAG_SAVED = 2;
float CVAR_TYPEFLAG_PRIVATE = 4;
float CVAR_TYPEFLAG_ENGINE = 8;
float CVAR_TYPEFLAG_HASDESCRIPTION = 16;
float CVAR_TYPEFLAG_READONLY = 32;

//DP_QC_STRINGBUFFERS
//idea: ??
//darkplaces implementation: LordHavoc
//functions to manage string buffer objects - that is, arbitrary length string arrays that are handled by the engine
accessor strbuf : float;
strbuf() buf_create = #440; /* Part of DP_QC_STRINGBUFFERS*/
void(strbuf bufhandle) buf_del = #441; /* Part of DP_QC_STRINGBUFFERS*/
float(strbuf bufhandle) buf_getsize = #442; /* Part of DP_QC_STRINGBUFFERS*/
void(strbuf bufhandle_from, float bufhandle_to) buf_copy = #443; /* Part of DP_QC_STRINGBUFFERS*/
void(strbuf bufhandle, float sortprefixlen, float backward) buf_sort = #444; /* Part of DP_QC_STRINGBUFFERS*/
string(strbuf bufhandle, string glue) buf_implode = #445; /* Part of DP_QC_STRINGBUFFERS*/
string(strbuf bufhandle, float string_index) bufstr_get = #446; /* Part of DP_QC_STRINGBUFFERS*/
void(strbuf bufhandle, float string_index, string str) bufstr_set = #447; /* Part of DP_QC_STRINGBUFFERS*/
float(strbuf bufhandle, string str, float ordered) bufstr_add = #448; /* Part of DP_QC_STRINGBUFFERS*/
void(strbuf bufhandle, float string_index) bufstr_free = #449; /* Part of DP_QC_STRINGBUFFERS*/

// Reki (October 31 2023):
accessor strbuf : float
{
	inline get float asfloat[float idx] = {
			return stof(bufstr_get(this, idx));
		};
	inline set float asfloat[float idx] = {
			bufstr_set(this, idx, ftos(value));
		};
	
	// we can get away with directly referencing existing functions/builtins
	get string[float] = bufstr_get;
	set string[float] = bufstr_set;
	get float length = buf_getsize;
};
accessor chara : string;
inline string chara_atpos(chara this, float pos)
{
	return substring((string)this, pos, 1);
}
string chara_setpos(chara this, float pos, string c)
{
	float idx = min(pos, strlen((string)this))

	string s1 = substring((string)this, 0, idx);
	string s2 = substring((string)this, idx + 1, strlen((string)this));

	return strcat(s1, c, s2);
}
inline float chara_length(chara this)
{
	return strlen((string)this);
}
accessor chara : string
{
	inline set string char[float idx] = {
		chara_setpos(this, idx, value);
	};

	get string[float] = chara_atpos;
	get float length = chara_length;
};

//DP_QC_STRINGBUFFERS_EXT_WIP
//idea: VorteX
//darkplaces implementation: VorteX
//constant definitions:
const float MATCH_AUTO = 0;
const float MATCH_WHOLE = 1;
const float MATCH_LEFT = 2;
const float MATCH_RIGHT = 3;
const float MATCH_MIDDLE = 4;
const float MATCH_PATTERN = 5;
//builtin definitions:
float(string filename, strbuf bufhandle) buf_loadfile = #535; // append each line of file as new buffer string, return 1 if succesful
float(float filehandle, strbuf bufhandle, float startpos, float numstrings) buf_writefile = #536; // writes buffer strings as lines, returns 1 if succesful
float(float bufhandle, string match, float matchrule, float startpos, float step) bufstr_find = #537; // returns string index
float(string s, string pattern, float matchrule) matchpattern = #538; // returns 0/1
float(string s, string pattern, float matchrule, float pos) matchpatternofs = #538;
//description:
//provides a set of functions to manipulate with string buffers
//pattern wildcards: * - any character (or no characters), ? - any 1 character
//Warning: This extension is work-in-progress, it may be changed/revamped/removed at any time, dont use it if you dont want any trouble
//wip note: UTF8 is not supported yet


//DP_QC_STRING_CASE_FUNCTIONS
//idea: Dresk
//darkplaces implementation: LordHavoc / Dresk
//builtin definitions:
string(string s) strtolower = #480; // returns the passed in string in pure lowercase form
string(string s) strtoupper = #481; // returns the passed in string in pure uppercase form
//description:
//provides simple string uppercase and lowercase functions

//DP_QC_CVAR_DESCRIPTION
//idea: divVerent
//DarkPlaces implementation: divVerent
//builtin definitions:
string(string name) cvar_description = #518;
//description:
//returns the description of a cvar

//DP_QC_DIGEST
//idea: motorsep, Spike
//DarkPlaces implementation: divVerent
//builtin definitions:
string(string digest, string data, ...) digest_hex = #639;
//description:
//returns a given hex digest of given data
//the returned digest is always encoded in hexadecimal
//only the "MD4" digest is always supported!
//if the given digest is not supported, string_null is returned
//the digest string is matched case sensitively, use "MD4", not "md4"!

//DP_QC_URI_ESCAPE
//idea: div0
//darkplaces implementation: div0
//URI::Escape's functionality
string(string in) uri_escape = #510;
string(string in) uri_unescape = #511;

//DP_QC_URI_GET
//idea: divVerent
//darkplaces implementation: divVerent
//loads text from an URL into a string
//returns 1 on success of initiation, 0 if there are too many concurrent
//connections already or if the URL is invalid
//the following callback will receive the data and MUST exist!
//  void(float id, float status, string data) URI_Get_Callback;
//status is either
//  negative for an internal error,
//  0 for success, or
//  the HTTP response code on server error (e.g. 404)
//if 1 is returned by uri_get, the callback will be called in the future
float(string url, float id) uri_get = #513;
//DP_QC_URI_POST
//idea: divVerent
//darkplaces implementation: divVerent
//loads text from an URL into a string after POSTing via HTTP
//works like uri_get, but uri_post sends data with Content-Type: content_type to the server
//and uri_post sends the string buffer buf, joined using the delimiter delim
float(string url, float id, string content_type, string data) uri_post = #513;
float(string url, float id, string content_type, string delim, float buf) uri_postbuf = #513;

//DP_QC_ENTITYDATA
//idea: KrimZon
//darkplaces implementation: KrimZon
//builtin definitions:
float() numentityfields = #496;
string(float fieldnum) entityfieldname = #497;
float(float fieldnum) entityfieldtype = #498;
string(float fieldnum, entity ent) getentityfieldstring = #499;
float(float fieldnum, entity ent, string s) putentityfieldstring = #500;
//constants:
//Returned by entityfieldtype
float FIELD_STRING   = 1;
float FIELD_FLOAT    = 2;
float FIELD_VECTOR   = 3;
float FIELD_ENTITY   = 4;
float FIELD_FUNCTION = 6;
//description:
//Versatile functions intended for storing data from specific entities between level changes, but can be customized for some kind of partial savegame.
//WARNING: .entity fields cannot be saved and restored between map loads as they will leave dangling pointers.
//numentityfields returns the number of entity fields. NOT offsets. Vectors comprise 4 fields: v, v_x, v_y and v_z.
//entityfieldname returns the name as a string, eg. "origin" or "classname" or whatever.
//entityfieldtype returns a value that the constants represent, but the field may be of another type in more exotic progs.dat formats or compilers.
//getentityfieldstring returns data as would be written to a savegame, eg... "0.05" (float), "0 0 1" (vector), or "Hello World!" (string). Function names can also be returned.
//putentityfieldstring puts the data returned by getentityfieldstring back into the entity.

//DP_COVERAGE
//idea: divVerent
//darkplaces implementation: divVerent
//function definitions:
void coverage() = #642;  // Reports a coverage event. The engine counts for each of the calls to this builtin whether it has been called.

// assorted undocumented extensions
string(string, float) netaddress_resolve = #625;
string(string search, string replace, string subject) strreplace = #484;
string(float uselocaltime, string format, ...) strftime = #478;
float(string s) tokenize_console = #514;
float(float i) argv_start_index = #515;
float(float i) argv_end_index = #516;
string(float, float) getgamedirinfo = #626;
#define GETGAMEDIRINFO_NAME 0
#define GETGAMEDIRINFO_DESCRIPTION 1
float log(float f) = #532;
string(string format, ...) sprintf = #627;
string(string s) strdecolorize = #477;
entity	findflags(entity start, .float field, float match) = #87;
entity	findchainflags(.float field, float match) = #88;
float(string s, string separator1, ...) tokenizebyseparator = #479;
float 	etof(entity ent) = #79;
entity 	ftoe(float num)	 = #80;
float   validstring(string str) = #81;
float 	altstr_count(string str) = #82;
string  altstr_prepare(string str) = #83;
string  altstr_get(string str, float num) = #84;
string  altstr_set(string str, float num, string set) = #85;
string 	altstr_ins(string str, float num, string set) = #86;
float	isdemo() = #349;
float	drawsubpic(vector position, vector size, string pic, vector srcPosition, vector srcSize, vector rgb, float alpha, float flag) = #469;
//vector	getresolution(float number, ...) = #608; // optional argument "isfullscreen"
void 	parseentitydata(entity ent, string data) = #613;
void 	resethostcachemasks(void) = #615;
void 	sethostcachemaskstring(float mask, float fld, string str, float op) = #616;
void	sethostcachemasknumber(float mask, float fld, float num, float op) = #617;
void 	resorthostcache(void) = #618;
float SLSF_DESCENDING = 1;
float SLSF_FAVORITES = 2;
float SLSF_CATEGORIES = 4;
void	sethostcachesort(float fld, float slsf) = #619;
void	refreshhostcache(...) = #620;  // optional boolean argument "clear_list"
float	gethostcachenumber(float fld, float hostnr) = #621;
float	gethostcacheindexforkey(string key) = #622;
void	addwantedhostcachekey(string key) = #623;
string	getextresponse(void) = #624;
const string cvar_string(string name) = #71;
const string cvar_defstring(string name) = #89;
float	stringwidth(string text, float handleColors, vector size) = #468;

// EXT_WRATH
// additional file operations
// these all work only on files inside data/ and return 0 on success, <0 on failure
#if DEBUG
float(string fnfrom, string fnto) fcopy_engine = #650;
float(string fnfrom, string fnto) fcopy = { float f = fcopy_engine(fnfrom, fnto); print(sprintf("MENUQC: %s(%s, %s)... %g\n", __func__, fnfrom, fnto, f)); return f; };

float(string fnold, string fnnew) frename_engine = #651;
float(string fnold, string fnnew) frename = { float f = frename_engine(fnold, fnnew); print(sprintf("MENUQC: %s(%s, %s)... %g\n", __func__, fnold, fnnew, f)); return f; };

float(string fname) fremove_engine = #652;
float(string filename) fremove = { float f = fremove_engine(filename); print(sprintf("MENUQC: %s(%s)... %g\n", __func__, filename, f)); return f; };

float(string filename) fexists_engine = #653;
float(string filename) fexists = { float f = fexists_engine(filename); print(sprintf("MENUQC: %s(%s)... %g\n", __func__, filename, f)); return f; };

float(string path) rmtree_engine = #654;
float(string path) rmtree = { float f = rmtree_engine(path); print(sprintf("MENUQC: %s(%s)... %g\n", __func__, path, f)); return f; };
#else
float(string fnfrom, string fnto) fcopy = #650;
float(string fnold, string fnnew) frename = #651;
float(string fname) fremove = #652;
float(string filename) fexists = #653;
float(string path) rmtree = #654;
#endif

string string_null;
string(string filename) whichpack = #503;
float(string filename) fexists_pak = {
	if ((whichpack(filename) != string_null) || fexists(filename))
		return 1;
	return 0;
};

// Reki (December 13 2023): From FTE, implementation from DOOMBRINGER
void m_drawloading(vector screensize, float opaque);

// EXT_STEAM_REKI
// void Menu_Steam_StatValue(string stat_name, float value)
// void Menu_Steam_AchievementValue(string achievement_name, float value)
void(string achievement_id) stachievement_unlock = #730; // unlocks a steam achievement given that the engine is connected to the launcher, otherwise there will be no effect
void(string achievement_id) stachievement_query = #731;  // will later call CSQC_Steam_AchievementValue upon a successful stat fetch
void(string stat_id, float value) ststat_setvalue = #732;
void(string stat_id, float value) ststat_increment = #733;
void(string stat_id) ststat_query = #734; // will later call CSQC_Steam_StatValue upon a successful stat fetch
void(string achievement_id) stachievement_register = #735; // registers an achievement in the launcher
void(string stat_id) ststat_register = #736; // registers a stat in the launcher

// EXT_CONTROLLER_REKI
void(float index) controller_query = #740;
void(float index, float lowmult, float highmult, float msec) controller_rumble = #741;
void(float index, float leftmult, float rightmult, float msec) controller_rumbletriggers = #742;

