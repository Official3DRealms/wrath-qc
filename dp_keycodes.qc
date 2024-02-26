///////////////////////////
// input event constants (descriptions taken from FTE, so they do not reflect our available features)

const float IE_KEYDOWN = 0;	/* Specifies that a key was pressed. Second argument is the scan code. Third argument is the unicode (printable) char value. Fourth argument denotes which keyboard(or mouse, if its a mouse 'scan' key) the event came from. Note that some systems may completely separate scan codes and unicode values, with a 0 value for the unspecified argument. */
const float IE_KEYUP = 1;	/* Specifies that a key was released. Arguments are the same as IE_KEYDOWN. On some systems, this may be fired instantly after IE_KEYDOWN was fired. */
const float IE_MOUSEDELTA = 2;	/* Specifies that a mouse was moved (touch screens and tablets typically give IE_MOUSEABS events instead, use _windowed_mouse 0 to test code to cope with either). Second argument is the X displacement, third argument is the Y displacement. Fourth argument is which mouse or touch event triggered the event. */
const float IE_MOUSEABS = 3;	/* Specifies that a mouse cursor or touch event was moved to a specific location relative to the virtual screen space. Second argument is the new X position, third argument is the new Y position. Fourth argument is which mouse or touch event triggered the event. */
const float IE_JOYAXIS = 6;	/* Specifies that what value a joystick/controller axis currently specifies. x=axis, y=value. Will be called multiple times, once for each axis of each active controller. */

float KEY_UNKNOWN		= 	-1;
float KEY_GAME 			=	0;
float KEY_MENU			=	2;
float KEY_MENU_GRABBED	= 	3;

float input_mode;
float IN_MODE_MOUSE 	=	0;
float IN_MODE_KEYBOARD 	=	1;
float IN_MODE_GAMEPAD 	=	2;
float IN_MODE_JOYSTICK 	=	3;

// key constants

//
// these are the key numbers that should be passed to Key_Event
//
float K_TAB			=	9;
float K_ENTER		=	13;
float K_ESCAPE		=	27;
float K_SPACE		=	32;

// normal keys should be passed as lowercased ascii

float K_BACKSPACE	=	127;
float K_UPARROW		=	128;
float K_DOWNARROW	=	129;
float K_LEFTARROW	=	130;
float K_RIGHTARROW	=	131;

float K_ALT		=	132;
float K_CTRL	=	133;
float K_SHIFT	=	134;

float K_F1		=	135;
float K_F2		=	136;
float K_F3		=	137;
float K_F4		=	138;
float K_F5		=	139;
float K_F6		=	140;
float K_F7		=	141;
float K_F8		=	142;
float K_F9		=	143;
float K_F10		=	144;
float K_F11		=	145;
float K_F12		=	146;

float K_INS		=	147;
float K_DEL		=	148;
float K_PGDN	=	149;
float K_PGUP	=	150;
float K_HOME	=	151;
float K_END		=	152;

float K_NUMLOCK		= 154;
float K_CAPSLOCK	= 155;
float K_SCROLLLOCK	= 156;

float K_KP_0	=	157;
float K_KP_INS	=	157; // same as K_KP_0
float K_KP_1	=	158;
float K_KP_END	=	158; // same as K_KP_1
float K_KP_2	=	159;
float K_KP_DOWNARROW = 159; // same as K_KP_2
float K_KP_3	=	160;
float K_KP_PGDN = 160; // same as K_KP_3
float K_KP_4	=	161;
float K_KP_LEFTARROW = 161; // same as K_KP_4
float K_KP_5	=	162;
float K_KP_6	=	163;
float K_KP_RIGHTARROW = 163; // same as K_KP_6
float K_KP_7	=	164;
float K_KP_HOME = 164; // same as K_KP_7
float K_KP_8	=	165;
float K_KP_UPARROW = 165; // same as K_KP_8
float K_KP_9	= 166;
float K_KP_PGUP = 166; // same as K_KP_9
float K_KP_PERIOD = 167;
float K_KP_DEL = 167; // same as K_KP_PERIOD
float K_KP_DIVIDE = 168;
float K_KP_SLASH = 168; // same as K_KP_DIVIDE
float K_KP_MULTIPLY = 169;
float K_KP_MINUS	= 170;
float K_KP_PLUS		= 171;
float K_KP_ENTER	= 172;
float K_KP_EQUALS	= 173;

// mouse buttons generate virtual keys
float K_PAUSE	=	153;

//
// joystick buttons
//
float K_JOY1 = 768;
float K_JOY2 = 769;
float K_JOY3 = 770;
float K_JOY4 = 771;

//
//
// aux keys are for multi-buttoned joysticks to generate so they can use
// the normal binding process
//
float K_AUX1	=	772;
float K_AUX2	=	773;
float K_AUX3	=	774;
float K_AUX4	=	775;
float K_AUX5	=	776;
float K_AUX6	=	777;
float K_AUX7	=	778;
float K_AUX8	=	779;
float K_AUX9	=	780;
float K_AUX10	=	781;
float K_AUX11	=	782;
float K_AUX12	=	783;
float K_AUX13	=	784;
float K_AUX14	=	785;
float K_AUX15	=	786;
float K_AUX16	=	787;
float K_AUX17	=	788;
float K_AUX18	=	789;
float K_AUX19	=	790;
float K_AUX20	=	791;
float K_AUX21	=	792;
float K_AUX22	=	793;
float K_AUX23	=	794;
float K_AUX24	=	795;
float K_AUX25	=	796;
float K_AUX26	=	797;
float K_AUX27	=	798;
float K_AUX28	=	799;
float K_AUX29	=	800;
float K_AUX30	=	801;
float K_AUX31	=	802;
float K_AUX32	=	803;

//
// xinput gamepad buttons
// names based on xbox 360 controller mapping
//
float K_XIN_DPAD_UP				=	816;
float K_XIN_DPAD_DOWN			=	817;
float K_XIN_DPAD_LEFT			=	818;
float K_XIN_DPAD_RIGHT			=	819;

float K_XIN_START				=	820;
float K_XIN_SELECT				=	821;

float K_XIN_LSTK_PRESS			=	822;
float K_XIN_RSTK_PRESS			=	823;

float K_XIN_BUMP_LEFT			=	824;
float K_XIN_BUMP_RIGHT			=	825;

float K_XIN_BTN_A				=	826;
float K_XIN_BTN_B				=	827;
float K_XIN_BTN_X				=	828;
float K_XIN_BTN_Y				=	829;

float K_XIN_TRIGGER_LEFT		=	830;
float K_XIN_TRIGGER_RIGHT		=	831;

float K_XIN_LSTK_UP				=	832;
float K_XIN_LSTK_DOWN			=	833;
float K_XIN_LSTK_LEFT			=	834;
float K_XIN_LSTK_RIGHT			=	835;
float K_XIN_RSTK_UP				=	836;
float K_XIN_RSTK_DOWN			=	837;
float K_XIN_RSTK_LEFT			=	838;
float K_XIN_RSTK_RIGHT			=	839;



//
// mouse buttons generate virtual keys
//
float K_MOUSE1		=	512;
float K_MOUSE2		=	513;
float K_MOUSE3		=	514;
float K_MWHEELUP	=	515;
float K_MWHEELDOWN	=	516;
float K_MOUSE4		=	517;
float K_MOUSE5		=	518;
float K_MOUSE6		=	519;
float K_MOUSE7		=	520;
float K_MOUSE8		=	521;
float K_MOUSE9		=	522;
float K_MOUSE10		=	523;
float K_MOUSE11		=	524;
float K_MOUSE12		=	525;
float K_MOUSE13		=	526;
float K_MOUSE14		=	527;
float K_MOUSE15		=	528;
float K_MOUSE16		=	529;


