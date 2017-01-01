/*---------------------------------------------------------------------------
Very silly and old function to map keys to piano notes.
---------------------------------------------------------------------------*/
function ToKey(val)
	if type(val) ~= "string" then return "INVALID KEY" end
	local V = string.lower(val)
	if string.find(V, "mouse") then return "mouse"..tostring(ToMouse(V)) end
	if V == "a" then return KEY_A
	elseif V == "b" then return KEY_B
	elseif V == "c" then return KEY_C
	elseif V == "d" then return KEY_D
	elseif V == "e" then return KEY_E
	elseif V == "f" then return KEY_F
	elseif V == "g" then return KEY_G
	elseif V == "h" then return KEY_B
	elseif V == "i" then return KEY_I
	elseif V == "j" then return KEY_J
	elseif V == "k" then return KEY_K
	elseif V == "l" then return KEY_L
	elseif V == "m" then return KEY_M
	elseif V == "n" then return KEY_N
	elseif V == "o" then return KEY_O
	elseif V == "p" then return KEY_P
	elseif V == "q" then return KEY_Q
	elseif V == "r" then return KEY_R
	elseif V == "s" then return KEY_S
	elseif V == "t" then return KEY_T
	elseif V == "u" then return KEY_U
	elseif V == "v" then return KEY_V
	elseif V == "w" then return KEY_W
	elseif V == "x" then return KEY_X
	elseif V == "y" then return KEY_Y
	elseif V == "z" then return KEY_Z

	elseif V == "1" then return KEY_1
	elseif V == "2" then return KEY_2
	elseif V == "3" then return KEY_3
	elseif V == "4" then return KEY_4
	elseif V == "5" then return KEY_5
	elseif V == "6" then return KEY_6
	elseif V == "7" then return KEY_7
	elseif V == "8" then return KEY_8
	elseif V == "9" then return KEY_9
	elseif V == "0" then return KEY_0

	elseif V == "'" then return KEY_APOSTROPHE
	elseif V == "`" then return KEY_BACKQUOTE
	elseif V == "[" then return KEY_LBRACKET
	elseif V == "]" then return KEY_RBRACKET
	elseif V == "-" then return KEY_MINUS
	elseif V == "=" then return KEY_EQUAL
	elseif V == "," then return KEY_COMMA
	elseif V == ";" then return KEY_SEMICOLON
	elseif V == "/" then return KEY_SLASH
	elseif V == "." then return KEY_PERIOD
	elseif V == "del" or v == "delete" then return KEY_DELETE
	elseif V == "home" then return KEY_HOME
	elseif V == "insert" then return KEY_INSERT
	elseif V == "end" then return KEY_end
	elseif V == "pgup" or v == "page up" or v == "pageup"  then return KEY_PAGEUP
	elseif V == "pgdown" or V == "pgdn" or v == "page down" or v == "pagedown"  then return KEY_PAGEDOWN

	elseif V == "f1" then return KEY_F1
	elseif V == "f2" then return KEY_F2
	elseif V == "f3" then return KEY_F3
	elseif V == "f4" then return KEY_F4
	elseif V == "f5" then return KEY_F5
	elseif V == "f6" then return KEY_F6
	elseif V == "f7" then return KEY_F7
	elseif V == "f8" then return KEY_F8
	elseif V == "f9" then return KEY_F9
	elseif V == "f10" then return KEY_F10
	elseif V == "f11" then return KEY_F11
	elseif V == "f12" then return KEY_F12

	elseif V == "kp_0" then return KEY_PAD_0
	elseif V == "kp_1" then return KEY_PAD_1
	elseif V == "kp_2" then return KEY_PAD_2
	elseif V == "kp_3" then return KEY_PAD_3
	elseif V == "kp_4" then return KEY_PAD_4
	elseif V == "kp_5" then return KEY_PAD_5
	elseif V == "kp_6" then return KEY_PAD_6
	elseif V == "kp_7" then return KEY_PAD_7
	elseif V == "kp_8" then return KEY_PAD_8
	elseif V == "kp_9" then return KEY_PAD_9
	elseif V == "kp_/" then return KEY_PAD_DIVIDE
	elseif V == "kp_." then return KEY_PAD_DECIMAL
	elseif V == "kp_-" then return KEY_PAD_MINUS
	elseif V == "kp_+" then return KEY_PAD_PLUS
	elseif V == "kp_*" then return KEY_PAD_MULTIPLY
	elseif V == "numlock" then return KEY_NUMLOCK

	elseif V == "alt" then return KEY_LALT
	elseif V == "lalt" then return KEY_LALT
	elseif V == "ralt" then return KEY_RALT
	elseif V == "control" then return KEY_LCONTROL
	elseif V == "ctrl" then return KEY_LCONTROL
	elseif V == "lcontrol" then return KEY_LCONTROL
	elseif V == "lctrl" then return KEY_LCONTROL
	elseif V == "rcontrol" then return KEY_RCONTROL
	elseif V == "rctrl" then return KEY_RCONTROL
	elseif V == "space" then return KEY_SPACE
	elseif V == "spacebar" then return KEY_SPACE

	elseif V == "shift" or V == "lshift" then return KEY_LSHIFT
	elseif V == "rshift" then return KEY_RSHIFT

	elseif V == "capslock" or V == "caps lock" then return KEY_CAPSLOCK
	else return "INVALID KEY"
	end
end

function ToMouse(val)
	if type(val) ~= "string" then return "INVALID MOUSE BUTTON" end
	local V = string.lower(val)
	if V == "mouse left" then return MOUSE_LEFT
	elseif V == "left mouse" then return MOUSE_LEFT
	elseif V == "leftmouse" then return MOUSE_LEFT
	elseif V == "mouseleft" then return MOUSE_LEFT
	elseif V == "mouse1" then return MOUSE_LEFT

	elseif V == "right mouse" then return MOUSE_RIGHT
	elseif V == "rightmouse" then return MOUSE_RIGHT
	elseif V == "mouseright" then return MOUSE_RIGHT
	elseif V == "mouse2" then return MOUSE_RIGHT

	elseif V == "mouse3" then return MOUSE_MIDDLE
	elseif V == "middle mouse" then return MOUSE_MIDDLE
	elseif V == "mouse middle" then return MOUSE_MIDDLE
	elseif V == "mousemiddle" then return MOUSE_MIDDLE

	elseif V == "mouse4" then return MOUSE_4
	elseif V == "mouse 4" then return MOUSE_4

	elseif V == "mouse5" then return MOUSE_5
	elseif V == "mouse 5" then return MOUSE_5
	else return "INVALID MOUSE BUTTON"
	end
end