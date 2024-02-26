vector thumbstick_right;
vector thumbstick_look;
vector thumbstick_mouse;

enum CONTROLLER:float {
	NULL,
	GENERIC,
	XBOX,
	PLAYSTATION,
	NINTENDO,
	STEAM,
	MAX
};

CONTROLLER controllerType;

#ifdef CSQC
#define getkeydest(x) (cvar("keydest"))
#endif

// Reki (December 2 2023): Added controller mapping, and made it so it
// won't interfere with our normal single-input keyboard mapping.
#define IS_KBM_KEY(k) (k == INPUT_TYPE::KEYBOARD || k == INPUT_TYPE::MOUSE)
enum INPUT_TYPE:float {
	KEYBOARD,
	MOUSE,
	XBOX,
	JOYSTICK,
};
float bind_gettype(float keycode)
{
	if (keycode >= K_MOUSE1 && keycode <= K_MOUSE16)
		return INPUT_TYPE::MOUSE;
	else if (keycode >= K_XIN_DPAD_UP && keycode <= K_XIN_RSTK_RIGHT) // xinput, nice.
		return INPUT_TYPE::XBOX;
	else if (keycode >= K_JOY1 && keycode <= K_AUX32) //icky, dinput :\
		return INPUT_TYPE::JOYSTICK;

	// if all else fails, assume keyboard
	return INPUT_TYPE::KEYBOARD;
}

string Controller_GetGlyph(string code);
void Controller_InitGlyphs(CONTROLLER type);
#include "uielement.h"

void Controller_Query(void)
{
	static float controllerquery_cooldown = 0;

	if (cvar("joy_active"))
	{
		if (cltime > controllerquery_cooldown)
		{
			controllerquery_cooldown = cltime + 6;
			controller_query(cvar("joy_index"));
		}
	}
}

void Controller_Type(float index, float type)
{
	if (index == cvar("joy_index"))
	{
		if (controllerType != type)
			Controller_InitGlyphs(type);

		controllerType = (CONTROLLER)type;
	}
}

void input_modeswitching(float EventType, float charx, float scany) 
{
	static float input_mode_pollingcooldown;
	if (cltime > input_mode_pollingcooldown)
		{
		float new_mode = input_mode;

		if (EventType == IE_KEYDOWN)
		{
			float type = bind_gettype(charx);
			if (IS_KBM_KEY(type))
			{
				new_mode = IN_MODE_KEYBOARD;
			}
			else
			{
				if (type == INPUT_TYPE::XBOX)
					new_mode = IN_MODE_GAMEPAD;
				else
					new_mode = IN_MODE_JOYSTICK;
			}
		}
		else if (EventType == IE_JOYAXIS)
		{
			if (input_mode != IN_MODE_JOYSTICK)
				new_mode = IN_MODE_GAMEPAD;
		}
		else if (EventType == IE_MOUSEDELTA)
		{
			//new_mode = IN_MODE_KEYBOARD;
		}

		if (input_mode != new_mode)
		{
			input_mode_pollingcooldown = cltime + 1;
			input_mode = new_mode;
		}
	}
}

float autocvar_joy_axisyaw;
float autocvar_joy_axispitch;
float autocvar_joy_x360_axisyaw;
float autocvar_joy_x360_axispitch;
float autocvar_joy_x360_acceleration;
void input_thumbsticks(__inout float EventType, __inout float charx, __inout float scany)
{
	if (EventType == IE_JOYAXIS)
	{
		float axis_yaw;
		float axis_pitch;
		if (input_mode == IN_MODE_GAMEPAD)
		{
			axis_pitch = autocvar_joy_x360_axispitch;
			axis_yaw = autocvar_joy_x360_axisyaw;
		}
		else
		{
			axis_pitch = autocvar_joy_axispitch;
			axis_yaw = autocvar_joy_axisyaw;
		}

		if (charx == axis_yaw || charx == axis_pitch) // right thumbstick
		{
			if (charx == axis_yaw)
				thumbstick_look[0] = scany;
			else if (charx == axis_pitch)
				thumbstick_look[1] = -scany;
		}

		if (charx == 2 || charx == 3) // right thumbstick
		{
			if (charx == 2)
				thumbstick_right[0] = scany;
			else if (charx == 3)
				thumbstick_right[1] = -scany;
		}
		
	}
	else if (EventType == IE_KEYDOWN || EventType == IE_KEYUP)
	{
		if (input_mode == IN_MODE_GAMEPAD && ui_usemouse)
		{
			float override_keycode = 0;
			if (charx == K_XIN_TRIGGER_RIGHT || charx == K_XIN_BTN_A)
				override_keycode = K_MOUSE1;
			else if (charx == K_XIN_TRIGGER_LEFT)
				override_keycode = K_MOUSE2;
			else if (charx == K_XIN_START || charx == K_XIN_BTN_B)
				override_keycode = K_ESCAPE;
			
			if (override_keycode)
			{
				charx = override_keycode;
			}
		}
	}
}

void input_frame(void)
{
	#pragma region ACCELERATION
	static float thumbstick_accel = 1;
	static float thumbstick_accelcooldown = 0;
	#define THUMBSTICK_SENSITIVITY 200
	#define THUMBSTICK_ACCEL_MAX 3

	if (vlen(thumbstick_right) < 0.05)
	{
		thumbstick_accelcooldown -= clframetime;
		if (thumbstick_accelcooldown <= 0)
			thumbstick_accel = 1;
	}
	else
	{
		thumbstick_accelcooldown = 0.05;
		thumbstick_accel = bound(1, thumbstick_accel + (vlen(thumbstick_right)) * 5 * clframetime, THUMBSTICK_ACCEL_MAX);
	}

	thumbstick_mouse += ((thumbstick_right * thumbstick_accel) * THUMBSTICK_SENSITIVITY) * clframetime;
	thumbstick_mouse[0] = bound(0, thumbstick_mouse[0], cvar("vid_conwidth"));
	thumbstick_mouse[1] = bound(0, thumbstick_mouse[1], cvar("vid_conheight"));
	#pragma endregion

	#ifdef CSQC
	setsensitivityscale(1);
	if (input_mode == IN_MODE_GAMEPAD)
	{
		float accelamount = (thumbstick_accel / THUMBSTICK_ACCEL_MAX);
		accelamount = lerp(1, accelamount, bound(0, autocvar_joy_x360_acceleration, 1));
		setsensitivityscale(accelamount);
	}

	if (ui_usemouse && (input_mode == IN_MODE_GAMEPAD || input_mode == IN_MODE_JOYSTICK))
	{
		setsensitivityscale(0.00001);
	}
	else if (getkeydest() != KEY_GAME)
	{
		setsensitivityscale(0.00001);
	}
	#endif
	#ifdef MENU
	float kd = getkeydest();
	if (cvar("keydest") != kd)
		cmd(sprintf("set keydest %.0f\n", kd));
	#endif

	Controller_Query();
}

vector getpointerpos(void)
{
	if (input_mode != IN_MODE_GAMEPAD && input_mode != IN_MODE_JOYSTICK)
		return getmousepos();
	return [round(thumbstick_mouse[0]), round(thumbstick_mouse[1])];
}

string controllerglyph_folder[] = {
	"steam",
	"steam",
	"xbox",
	"playstation",
	"xbox",
	"steam"
};

float gamepadglyph_active(void) { return input_mode == IN_MODE_GAMEPAD; }
void Controller_InitGlyphs(CONTROLLER type)
{
	if (type < 0 || type >= CONTROLLER::MAX)
		type = CONTROLLER::GENERIC;

	string folder = controllerglyph_folder[type];

	for(float i = 816; i <= 831; i++) // init buttons
		precache_pic(sprintf("gfx/glyphs/%s/%.0f.tga", folder, i), PRECACHE_PIC_MIPMAP);

	string special_imgs[] = {"diagram", "rs", "ls"};
	for(float i = 0; i < special_imgs.length; i++) // init other images
		precache_pic(sprintf("gfx/glyphs/%s/%s.tga", folder, special_imgs[i]), PRECACHE_PIC_MIPMAP);
}

string Controller_GetGlyph(string code)
{
	if (controllerType == CONTROLLER::NULL)
		return __NULL__;

	float type = controllerType;
	if (type < 0 || type >= CONTROLLER::MAX)
		type = CONTROLLER::GENERIC;

	return sprintf("gfx/glyphs/%s/%s.tga", controllerglyph_folder[type], code);
}

string Controller_GetGlyph_Fallback(string code, CONTROLLER fallback)
{
	string ret;
	CONTROLLER oldcontroller = controllerType;
	if (controllerType == CONTROLLER::NULL)
		controllerType = fallback;
	ret = Controller_GetGlyph(code);
	controllerType = oldcontroller;

	return ret;
}

//