//
// /*
//   FIXME 数据库直接冗余 jsKeyCode, iosKeyCode 等字段，避免按键等各种转换，
//    或者把干脆数据库表 Input 拆分成 JavaScript, Android, iOS 对应的 Input_JavaScript, Input/Input_Android, Input_iOS
// */
//
// const KeyEvent = {
//     /** Key code constant: Unknown key code. */
//     KEYCODE_UNKNOWN         : 0,
//     /** Key code constant: Soft Left key.
//      * Usually situated below the display on phones and used as a multi-function
//      * feature key for selecting a software defined function shown on the bottom left
//      * of the display. */
//     KEYCODE_SOFT_LEFT       : 1,
//     /** Key code constant: Soft Right key.
//      * Usually situated below the display on phones and used as a multi-function
//      * feature key for selecting a software defined function shown on the bottom right
//      * of the display. */
//     KEYCODE_SOFT_RIGHT      : 2,
//     /** Key code constant: Home key.
//      * This key is handled by the framework and is never delivered to applications. */
//     KEYCODE_HOME            : 3,
//     /** Key code constant: Back key. */
//     KEYCODE_BACK            : 4,
//     /** Key code constant: Call key. */
//     KEYCODE_CALL            : 5,
//     /** Key code constant: End Call key. */
//     KEYCODE_ENDCALL         : 6,
//     /** Key code constant: '0' key. */
//     KEYCODE_0               : 7,
//     /** Key code constant: '1' key. */
//     KEYCODE_1               : 8,
//     /** Key code constant: '2' key. */
//     KEYCODE_2               : 9,
//     /** Key code constant: '3' key. */
//     KEYCODE_3               : 10,
//     /** Key code constant: '4' key. */
//     KEYCODE_4               : 11,
//     /** Key code constant: '5' key. */
//     KEYCODE_5               : 12,
//     /** Key code constant: '6' key. */
//     KEYCODE_6               : 13,
//     /** Key code constant: '7' key. */
//     KEYCODE_7               : 14,
//     /** Key code constant: '8' key. */
//     KEYCODE_8               : 15,
//     /** Key code constant: '9' key. */
//     KEYCODE_9               : 16,
//     /** Key code constant: '*' key. */
//     KEYCODE_STAR            : 17,
//     /** Key code constant: '#' key. */
//     KEYCODE_POUND           : 18,
//     /** Key code constant: Directional Pad Up key.
//      * May also be synthesized from trackball motions. */
//     KEYCODE_DPAD_UP         : 19,
//     /** Key code constant: Directional Pad Down key.
//      * May also be synthesized from trackball motions. */
//     KEYCODE_DPAD_DOWN       : 20,
//     /** Key code constant: Directional Pad Left key.
//      * May also be synthesized from trackball motions. */
//     KEYCODE_DPAD_LEFT       : 21,
//     /** Key code constant: Directional Pad Right key.
//      * May also be synthesized from trackball motions. */
//     KEYCODE_DPAD_RIGHT      : 22,
//     /** Key code constant: Directional Pad Center key.
//      * May also be synthesized from trackball motions. */
//     KEYCODE_DPAD_CENTER     : 23,
//     /** Key code constant: Volume Up key.
//      * Adjusts the speaker volume up. */
//     KEYCODE_VOLUME_UP       : 24,
//     /** Key code constant: Volume Down key.
//      * Adjusts the speaker volume down. */
//     KEYCODE_VOLUME_DOWN     : 25,
//     /** Key code constant: Power key. */
//     KEYCODE_POWER           : 26,
//     /** Key code constant: Camera key.
//      * Used to launch a camera application or take pictures. */
//     KEYCODE_CAMERA          : 27,
//     /** Key code constant: Clear key. */
//     KEYCODE_CLEAR           : 28,
//     /** Key code constant: 'A' key. */
//     KEYCODE_A               : 29,
//     /** Key code constant: 'B' key. */
//     KEYCODE_B               : 30,
//     /** Key code constant: 'C' key. */
//     KEYCODE_C               : 31,
//     /** Key code constant: 'D' key. */
//     KEYCODE_D               : 32,
//     /** Key code constant: 'E' key. */
//     KEYCODE_E               : 33,
//     /** Key code constant: 'F' key. */
//     KEYCODE_F               : 34,
//     /** Key code constant: 'G' key. */
//     KEYCODE_G               : 35,
//     /** Key code constant: 'H' key. */
//     KEYCODE_H               : 36,
//     /** Key code constant: 'I' key. */
//     KEYCODE_I               : 37,
//     /** Key code constant: 'J' key. */
//     KEYCODE_J               : 38,
//     /** Key code constant: 'K' key. */
//     KEYCODE_K               : 39,
//     /** Key code constant: 'L' key. */
//     KEYCODE_L               : 40,
//     /** Key code constant: 'M' key. */
//     KEYCODE_M               : 41,
//     /** Key code constant: 'N' key. */
//     KEYCODE_N               : 42,
//     /** Key code constant: 'O' key. */
//     KEYCODE_O               : 43,
//     /** Key code constant: 'P' key. */
//     KEYCODE_P               : 44,
//     /** Key code constant: 'Q' key. */
//     KEYCODE_Q               : 45,
//     /** Key code constant: 'R' key. */
//     KEYCODE_R               : 46,
//     /** Key code constant: 'S' key. */
//     KEYCODE_S               : 47,
//     /** Key code constant: 'T' key. */
//     KEYCODE_T               : 48,
//     /** Key code constant: 'U' key. */
//     KEYCODE_U               : 49,
//     /** Key code constant: 'V' key. */
//     KEYCODE_V               : 50,
//     /** Key code constant: 'W' key. */
//     KEYCODE_W               : 51,
//     /** Key code constant: 'X' key. */
//     KEYCODE_X               : 52,
//     /** Key code constant: 'Y' key. */
//     KEYCODE_Y               : 53,
//     /** Key code constant: 'Z' key. */
//     KEYCODE_Z               : 54,
//     /** Key code constant: ',' key. */
//     KEYCODE_COMMA           : 55,
//     /** Key code constant: '.' key. */
//     KEYCODE_PERIOD          : 56,
//     /** Key code constant: Left Alt modifier key. */
//     KEYCODE_ALT_LEFT        : 57,
//     /** Key code constant: Right Alt modifier key. */
//     KEYCODE_ALT_RIGHT       : 58,
//     /** Key code constant: Left Shift modifier key. */
//     KEYCODE_SHIFT_LEFT      : 59,
//     /** Key code constant: Right Shift modifier key. */
//     KEYCODE_SHIFT_RIGHT     : 60,
//     /** Key code constant: Tab key. */
//     KEYCODE_TAB             : 61,
//     /** Key code constant: Space key. */
//     KEYCODE_SPACE           : 62,
//     /** Key code constant: Symbol modifier key.
//      * Used to enter alternate symbols. */
//     KEYCODE_SYM             : 63,
//     /** Key code constant: Explorer special function key.
//      * Used to launch a browser application. */
//     KEYCODE_EXPLORER        : 64,
//     /** Key code constant: Envelope special function key.
//      * Used to launch a mail application. */
//     KEYCODE_ENVELOPE        : 65,
//     /** Key code constant: Enter key. */
//     KEYCODE_ENTER           : 66,
//     /** Key code constant: Backspace key.
//      * Deletes characters before the insertion point, unlike {@link #KEYCODE_FORWARD_DEL}. */
//     KEYCODE_DEL             : 67,
//     /** Key code constant: '`' (backtick) key. */
//     KEYCODE_GRAVE           : 68,
//     /** Key code constant: '-'. */
//     KEYCODE_MINUS           : 69,
//     /** Key code constant: '=' key. */
//     KEYCODE_EQUALS          : 70,
//     /** Key code constant: '[' key. */
//     KEYCODE_LEFT_BRACKET    : 71,
//     /** Key code constant: ']' key. */
//     KEYCODE_RIGHT_BRACKET   : 72,
//     /** Key code constant: '\' key. */
//     KEYCODE_BACKSLASH       : 73,
//     /** Key code constant: ',' key. */
//     KEYCODE_SEMICOLON       : 74,
//     /** Key code constant: ''' (apostrophe) key. */
//     KEYCODE_APOSTROPHE      : 75,
//     /** Key code constant: '/' key. */
//     KEYCODE_SLASH           : 76,
//     /** Key code constant: '@' key. */
//     KEYCODE_AT              : 77,
//     /** Key code constant: Number modifier key.
//      * Used to enter numeric symbols.
//      * This key is not Num Lock, it is more like {@link #KEYCODE_ALT_LEFT} and is
//      * interpreted as an ALT key by {@link android.text.method.MetaKeyKeyListener}. */
//     KEYCODE_NUM             : 78,
//     /** Key code constant: Headset Hook key.
//      * Used to hang up calls and stop media. */
//     KEYCODE_HEADSETHOOK     : 79,
//     /** Key code constant: Camera Focus key.
//      * Used to focus the camera. */
//     KEYCODE_FOCUS           : 80,   // *Camera* focus
//     /** Key code constant: '+' key. */
//     KEYCODE_PLUS            : 81,
//     /** Key code constant: Menu key. */
//     KEYCODE_MENU            : 82,
//     /** Key code constant: Notification key. */
//     KEYCODE_NOTIFICATION    : 83,
//     /** Key code constant: Search key. */
//     KEYCODE_SEARCH          : 84,
//     /** Key code constant: Play/Pause media key. */
//     KEYCODE_MEDIA_PLAY_PAUSE: 85,
//     /** Key code constant: Stop media key. */
//     KEYCODE_MEDIA_STOP      : 86,
//     /** Key code constant: Play Next media key. */
//     KEYCODE_MEDIA_NEXT      : 87,
//     /** Key code constant: Play Previous media key. */
//     KEYCODE_MEDIA_PREVIOUS  : 88,
//     /** Key code constant: Rewind media key. */
//     KEYCODE_MEDIA_REWIND    : 89,
//     /** Key code constant: Fast Forward media key. */
//     KEYCODE_MEDIA_FAST_FORWARD : 90,
//     /** Key code constant: Mute key.
//      * Mutes the microphone, unlike {@link #KEYCODE_VOLUME_MUTE}. */
//     KEYCODE_MUTE            : 91,
//     /** Key code constant: Page Up key. */
//     KEYCODE_PAGE_UP         : 92,
//     /** Key code constant: Page Down key. */
//     KEYCODE_PAGE_DOWN       : 93,
//     /** Key code constant: Picture Symbols modifier key.
//      * Used to switch symbol sets (Emoji, Kao-moji). */
//     KEYCODE_PICTSYMBOLS     : 94,   // switch symbol-sets (Emoji,Kao-moji)
//     /** Key code constant: Switch Charset modifier key.
//      * Used to switch character sets (Kanji, Katakana). */
//     KEYCODE_SWITCH_CHARSET  : 95,   // switch char-sets (Kanji,Katakana)
//     /** Key code constant: A Button key.
//      * On a game controller, the A button should be either the button labeled A
//      * or the first button on the bottom row of controller buttons. */
//     KEYCODE_BUTTON_A        : 96,
//     /** Key code constant: B Button key.
//      * On a game controller, the B button should be either the button labeled B
//      * or the second button on the bottom row of controller buttons. */
//     KEYCODE_BUTTON_B        : 97,
//     /** Key code constant: C Button key.
//      * On a game controller, the C button should be either the button labeled C
//      * or the third button on the bottom row of controller buttons. */
//     KEYCODE_BUTTON_C        : 98,
//     /** Key code constant: X Button key.
//      * On a game controller, the X button should be either the button labeled X
//      * or the first button on the upper row of controller buttons. */
//     KEYCODE_BUTTON_X        : 99,
//     /** Key code constant: Y Button key.
//      * On a game controller, the Y button should be either the button labeled Y
//      * or the second button on the upper row of controller buttons. */
//     KEYCODE_BUTTON_Y        : 100,
//     /** Key code constant: Z Button key.
//      * On a game controller, the Z button should be either the button labeled Z
//      * or the third button on the upper row of controller buttons. */
//     KEYCODE_BUTTON_Z        : 101,
//     /** Key code constant: L1 Button key.
//      * On a game controller, the L1 button should be either the button labeled L1 (or L)
//      * or the top left trigger button. */
//     KEYCODE_BUTTON_L1       : 102,
//     /** Key code constant: R1 Button key.
//      * On a game controller, the R1 button should be either the button labeled R1 (or R)
//      * or the top right trigger button. */
//     KEYCODE_BUTTON_R1       : 103,
//     /** Key code constant: L2 Button key.
//      * On a game controller, the L2 button should be either the button labeled L2
//      * or the bottom left trigger button. */
//     KEYCODE_BUTTON_L2       : 104,
//     /** Key code constant: R2 Button key.
//      * On a game controller, the R2 button should be either the button labeled R2
//      * or the bottom right trigger button. */
//     KEYCODE_BUTTON_R2       : 105,
//     /** Key code constant: Left Thumb Button key.
//      * On a game controller, the left thumb button indicates that the left (or only)
//      * joystick is pressed. */
//     KEYCODE_BUTTON_THUMBL   : 106,
//     /** Key code constant: Right Thumb Button key.
//      * On a game controller, the right thumb button indicates that the right
//      * joystick is pressed. */
//     KEYCODE_BUTTON_THUMBR   : 107,
//     /** Key code constant: Start Button key.
//      * On a game controller, the button labeled Start. */
//     KEYCODE_BUTTON_START    : 108,
//     /** Key code constant: Select Button key.
//      * On a game controller, the button labeled Select. */
//     KEYCODE_BUTTON_SELECT   : 109,
//     /** Key code constant: Mode Button key.
//      * On a game controller, the button labeled Mode. */
//     KEYCODE_BUTTON_MODE     : 110,
//     /** Key code constant: Escape key. */
//     KEYCODE_ESCAPE          : 111,
//     /** Key code constant: Forward Delete key.
//      * Deletes characters ahead of the insertion point, unlike {@link #KEYCODE_DEL}. */
//     KEYCODE_FORWARD_DEL     : 112,
//     /** Key code constant: Left Control modifier key. */
//     KEYCODE_CTRL_LEFT       : 113,
//     /** Key code constant: Right Control modifier key. */
//     KEYCODE_CTRL_RIGHT      : 114,
//     /** Key code constant: Caps Lock key. */
//     KEYCODE_CAPS_LOCK       : 115,
//     /** Key code constant: Scroll Lock key. */
//     KEYCODE_SCROLL_LOCK     : 116,
//     /** Key code constant: Left Meta modifier key. */
//     KEYCODE_META_LEFT       : 117,
//     /** Key code constant: Right Meta modifier key. */
//     KEYCODE_META_RIGHT      : 118,
//     /** Key code constant: Function modifier key. */
//     KEYCODE_FUNCTION        : 119,
//     /** Key code constant: System Request / Print Screen key. */
//     KEYCODE_SYSRQ           : 120,
//     /** Key code constant: Break / Pause key. */
//     KEYCODE_BREAK           : 121,
//     /** Key code constant: Home Movement key.
//      * Used for scrolling or moving the cursor around to the start of a line
//      * or to the top of a list. */
//     KEYCODE_MOVE_HOME       : 122,
//     /** Key code constant: End Movement key.
//      * Used for scrolling or moving the cursor around to the end of a line
//      * or to the bottom of a list. */
//     KEYCODE_MOVE_END        : 123,
//     /** Key code constant: Insert key.
//      * Toggles insert / overwrite edit mode. */
//     KEYCODE_INSERT          : 124,
//     /** Key code constant: Forward key.
//      * Navigates forward in the history stack.  Complement of {@link #KEYCODE_BACK}. */
//     KEYCODE_FORWARD         : 125,
//     /** Key code constant: Play media key. */
//     KEYCODE_MEDIA_PLAY      : 126,
//     /** Key code constant: Pause media key. */
//     KEYCODE_MEDIA_PAUSE     : 127,
//     /** Key code constant: Close media key.
//      * May be used to close a CD tray, for example. */
//     KEYCODE_MEDIA_CLOSE     : 128,
//     /** Key code constant: Eject media key.
//      * May be used to eject a CD tray, for example. */
//     KEYCODE_MEDIA_EJECT     : 129,
//     /** Key code constant: Record media key. */
//     KEYCODE_MEDIA_RECORD    : 130,
//     /** Key code constant: F1 key. */
//     KEYCODE_F1              : 131,
//     /** Key code constant: F2 key. */
//     KEYCODE_F2              : 132,
//     /** Key code constant: F3 key. */
//     KEYCODE_F3              : 133,
//     /** Key code constant: F4 key. */
//     KEYCODE_F4              : 134,
//     /** Key code constant: F5 key. */
//     KEYCODE_F5              : 135,
//     /** Key code constant: F6 key. */
//     KEYCODE_F6              : 136,
//     /** Key code constant: F7 key. */
//     KEYCODE_F7              : 137,
//     /** Key code constant: F8 key. */
//     KEYCODE_F8              : 138,
//     /** Key code constant: F9 key. */
//     KEYCODE_F9              : 139,
//     /** Key code constant: F10 key. */
//     KEYCODE_F10             : 140,
//     /** Key code constant: F11 key. */
//     KEYCODE_F11             : 141,
//     /** Key code constant: F12 key. */
//     KEYCODE_F12             : 142,
//     /** Key code constant: Num Lock key.
//      * This is the Num Lock key, it is different from {@link #KEYCODE_NUM}.
//      * This key alters the behavior of other keys on the numeric keypad. */
//     KEYCODE_NUM_LOCK        : 143,
//     /** Key code constant: Numeric keypad '0' key. */
//     KEYCODE_NUMPAD_0        : 144,
//     /** Key code constant: Numeric keypad '1' key. */
//     KEYCODE_NUMPAD_1        : 145,
//     /** Key code constant: Numeric keypad '2' key. */
//     KEYCODE_NUMPAD_2        : 146,
//     /** Key code constant: Numeric keypad '3' key. */
//     KEYCODE_NUMPAD_3        : 147,
//     /** Key code constant: Numeric keypad '4' key. */
//     KEYCODE_NUMPAD_4        : 148,
//     /** Key code constant: Numeric keypad '5' key. */
//     KEYCODE_NUMPAD_5        : 149,
//     /** Key code constant: Numeric keypad '6' key. */
//     KEYCODE_NUMPAD_6        : 150,
//     /** Key code constant: Numeric keypad '7' key. */
//     KEYCODE_NUMPAD_7        : 151,
//     /** Key code constant: Numeric keypad '8' key. */
//     KEYCODE_NUMPAD_8        : 152,
//     /** Key code constant: Numeric keypad '9' key. */
//     KEYCODE_NUMPAD_9        : 153,
//     /** Key code constant: Numeric keypad '/' key (for division). */
//     KEYCODE_NUMPAD_DIVIDE   : 154,
//     /** Key code constant: Numeric keypad '*' key (for multiplication). */
//     KEYCODE_NUMPAD_MULTIPLY : 155,
//     /** Key code constant: Numeric keypad '-' key (for subtraction). */
//     KEYCODE_NUMPAD_SUBTRACT : 156,
//     /** Key code constant: Numeric keypad '+' key (for addition). */
//     KEYCODE_NUMPAD_ADD      : 157,
//     /** Key code constant: Numeric keypad '.' key (for decimals or digit grouping). */
//     KEYCODE_NUMPAD_DOT      : 158,
//     /** Key code constant: Numeric keypad ',' key (for decimals or digit grouping). */
//     KEYCODE_NUMPAD_COMMA    : 159,
//     /** Key code constant: Numeric keypad Enter key. */
//     KEYCODE_NUMPAD_ENTER    : 160,
//     /** Key code constant: Numeric keypad '=' key. */
//     KEYCODE_NUMPAD_EQUALS   : 161,
//     /** Key code constant: Numeric keypad '(' key. */
//     KEYCODE_NUMPAD_LEFT_PAREN : 162,
//     /** Key code constant: Numeric keypad ')' key. */
//     KEYCODE_NUMPAD_RIGHT_PAREN : 163,
//     /** Key code constant: Volume Mute key.
//      * Mutes the speaker, unlike {@link #KEYCODE_MUTE}.
//      * This key should normally be implemented as a toggle such that the first press
//      * mutes the speaker and the second press restores the original volume. */
//     KEYCODE_VOLUME_MUTE     : 164,
//     /** Key code constant: Info key.
//      * Common on TV remotes to show additional information related to what is
//      * currently being viewed. */
//     KEYCODE_INFO            : 165,
//     /** Key code constant: Channel up key.
//      * On TV remotes, increments the television channel. */
//     KEYCODE_CHANNEL_UP      : 166,
//     /** Key code constant: Channel down key.
//      * On TV remotes, decrements the television channel. */
//     KEYCODE_CHANNEL_DOWN    : 167,
//     /** Key code constant: Zoom in key. */
//     KEYCODE_ZOOM_IN         : 168,
//     /** Key code constant: Zoom out key. */
//     KEYCODE_ZOOM_OUT        : 169,
//     /** Key code constant: TV key.
//      * On TV remotes, switches to viewing live TV. */
//     KEYCODE_TV              : 170,
//     /** Key code constant: Window key.
//      * On TV remotes, toggles picture-in-picture mode or other windowing functions.
//      * On Android Wear devices, triggers a display offset. */
//     KEYCODE_WINDOW          : 171,
//     /** Key code constant: Guide key.
//      * On TV remotes, shows a programming guide. */
//     KEYCODE_GUIDE           : 172,
//     /** Key code constant: DVR key.
//      * On some TV remotes, switches to a DVR mode for recorded shows. */
//     KEYCODE_DVR             : 173,
//     /** Key code constant: Bookmark key.
//      * On some TV remotes, bookmarks content or web pages. */
//     KEYCODE_BOOKMARK        : 174,
//     /** Key code constant: Toggle captions key.
//      * Switches the mode for closed-captioning text, for example during television shows. */
//     KEYCODE_CAPTIONS        : 175,
//     /** Key code constant: Settings key.
//      * Starts the system settings activity. */
//     KEYCODE_SETTINGS        : 176,
//     /** Key code constant: TV power key.
//      * On TV remotes, toggles the power on a television screen. */
//     KEYCODE_TV_POWER        : 177,
//     /** Key code constant: TV input key.
//      * On TV remotes, switches the input on a television screen. */
//     KEYCODE_TV_INPUT        : 178,
//     /** Key code constant: Set-top-box power key.
//      * On TV remotes, toggles the power on an external Set-top-box. */
//     KEYCODE_STB_POWER       : 179,
//     /** Key code constant: Set-top-box input key.
//      * On TV remotes, switches the input mode on an external Set-top-box. */
//     KEYCODE_STB_INPUT       : 180,
//     /** Key code constant: A/V Receiver power key.
//      * On TV remotes, toggles the power on an external A/V Receiver. */
//     KEYCODE_AVR_POWER       : 181,
//     /** Key code constant: A/V Receiver input key.
//      * On TV remotes, switches the input mode on an external A/V Receiver. */
//     KEYCODE_AVR_INPUT       : 182,
//     /** Key code constant: Red "programmable" key.
//      * On TV remotes, acts as a contextual/programmable key. */
//     KEYCODE_PROG_RED        : 183,
//     /** Key code constant: Green "programmable" key.
//      * On TV remotes, actsas a contextual/programmable key. */
//     KEYCODE_PROG_GREEN      : 184,
//     /** Key code constant: Yellow "programmable" key.
//      * On TV remotes, acts as a contextual/programmable key. */
//     KEYCODE_PROG_YELLOW     : 185,
//     /** Key code constant: Blue "programmable" key.
//      * On TV remotes, acts as a contextual/programmable key. */
//     KEYCODE_PROG_BLUE       : 186,
//     /** Key code constant: App switch key.
//      * Should bring up the application switcher dialog. */
//     KEYCODE_APP_SWITCH      : 187,
//     /** Key code constant: Generic Game Pad Button #1.*/
//     KEYCODE_BUTTON_1        : 188,
//     /** Key code constant: Generic Game Pad Button #2.*/
//     KEYCODE_BUTTON_2        : 189,
//     /** Key code constant: Generic Game Pad Button #3.*/
//     KEYCODE_BUTTON_3        : 190,
//     /** Key code constant: Generic Game Pad Button #4.*/
//     KEYCODE_BUTTON_4        : 191,
//     /** Key code constant: Generic Game Pad Button #5.*/
//     KEYCODE_BUTTON_5        : 192,
//     /** Key code constant: Generic Game Pad Button #6.*/
//     KEYCODE_BUTTON_6        : 193,
//     /** Key code constant: Generic Game Pad Button #7.*/
//     KEYCODE_BUTTON_7        : 194,
//     /** Key code constant: Generic Game Pad Button #8.*/
//     KEYCODE_BUTTON_8        : 195,
//     /** Key code constant: Generic Game Pad Button #9.*/
//     KEYCODE_BUTTON_9        : 196,
//     /** Key code constant: Generic Game Pad Button #10.*/
//     KEYCODE_BUTTON_10       : 197,
//     /** Key code constant: Generic Game Pad Button #11.*/
//     KEYCODE_BUTTON_11       : 198,
//     /** Key code constant: Generic Game Pad Button #12.*/
//     KEYCODE_BUTTON_12       : 199,
//     /** Key code constant: Generic Game Pad Button #13.*/
//     KEYCODE_BUTTON_13       : 200,
//     /** Key code constant: Generic Game Pad Button #14.*/
//     KEYCODE_BUTTON_14       : 201,
//     /** Key code constant: Generic Game Pad Button #15.*/
//     KEYCODE_BUTTON_15       : 202,
//     /** Key code constant: Generic Game Pad Button #16.*/
//     KEYCODE_BUTTON_16       : 203,
//     /** Key code constant: Language Switch key.
//      * Toggles the current input language such as switching between English and Japanese on
//      * a QWERTY keyboard.  On some devices, the same function may be performed by
//      * pressing Shift+Spacebar. */
//     KEYCODE_LANGUAGE_SWITCH : 204,
//     /** Key code constant: Manner Mode key.
//      * Toggles silent or vibrate mode on and off to make the device behave more politely
//      * in certain settings such as on a crowded train.  On some devices, the key may only
//      * operate when long-pressed. */
//     KEYCODE_MANNER_MODE     : 205,
//     /** Key code constant: 3D Mode key.
//      * Toggles the display between 2D and 3D mode. */
//     KEYCODE_3D_MODE         : 206,
//     /** Key code constant: Contacts special function key.
//      * Used to launch an address book application. */
//     KEYCODE_CONTACTS        : 207,
//     /** Key code constant: Calendar special function key.
//      * Used to launch a calendar application. */
//     KEYCODE_CALENDAR        : 208,
//     /** Key code constant: Music special function key.
//      * Used to launch a music player application. */
//     KEYCODE_MUSIC           : 209,
//     /** Key code constant: Calculator special function key.
//      * Used to launch a calculator application. */
//     KEYCODE_CALCULATOR      : 210,
//     /** Key code constant: Japanese full-width / half-width key. */
//     KEYCODE_ZENKAKU_HANKAKU : 211,
//     /** Key code constant: Japanese alphanumeric key. */
//     KEYCODE_EISU            : 212,
//     /** Key code constant: Japanese non-conversion key. */
//     KEYCODE_MUHENKAN        : 213,
//     /** Key code constant: Japanese conversion key. */
//     KEYCODE_HENKAN          : 214,
//     /** Key code constant: Japanese katakana / hiragana key. */
//     KEYCODE_KATAKANA_HIRAGANA : 215,
//     /** Key code constant: Japanese Yen key. */
//     KEYCODE_YEN             : 216,
//     /** Key code constant: Japanese Ro key. */
//     KEYCODE_RO              : 217,
//     /** Key code constant: Japanese kana key. */
//     KEYCODE_KANA            : 218,
//     /** Key code constant: Assist key.
//      * Launches the global assist activity.  Not delivered to applications. */
//     KEYCODE_ASSIST          : 219,
//     /** Key code constant: Brightness Down key.
//      * Adjusts the screen brightness down. */
//     KEYCODE_BRIGHTNESS_DOWN : 220,
//     /** Key code constant: Brightness Up key.
//      * Adjusts the screen brightness up. */
//     KEYCODE_BRIGHTNESS_UP   : 221,
//     /** Key code constant: Audio Track key.
//      * Switches the audio tracks. */
//     KEYCODE_MEDIA_AUDIO_TRACK : 222,
//     /** Key code constant: Sleep key.
//      * Puts the device to sleep.  Behaves somewhat like {@link #KEYCODE_POWER} but it
//      * has no effect if the device is already asleep. */
//     KEYCODE_SLEEP           : 223,
//     /** Key code constant: Wakeup key.
//      * Wakes up the device.  Behaves somewhat like {@link #KEYCODE_POWER} but it
//      * has no effect if the device is already awake. */
//     KEYCODE_WAKEUP          : 224,
//     /** Key code constant: Pairing key.
//      * Initiates peripheral pairing mode. Useful for pairing remote control
//      * devices or game controllers, especially if no other input mode is
//      * available. */
//     KEYCODE_PAIRING         : 225,
//     /** Key code constant: Media Top Menu key.
//      * Goes to the top of media menu. */
//     KEYCODE_MEDIA_TOP_MENU  : 226,
//     /** Key code constant: '11' key. */
//     KEYCODE_11              : 227,
//     /** Key code constant: '12' key. */
//     KEYCODE_12              : 228,
//     /** Key code constant: Last Channel key.
//      * Goes to the last viewed channel. */
//     KEYCODE_LAST_CHANNEL    : 229,
//     /** Key code constant: TV data service key.
//      * Displays data services like weather, sports. */
//     KEYCODE_TV_DATA_SERVICE : 230,
//     /** Key code constant: Voice Assist key.
//      * Launches the global voice assist activity. Not delivered to applications. */
//     KEYCODE_VOICE_ASSIST : 231,
//     /** Key code constant: Radio key.
//      * Toggles TV service / Radio service. */
//     KEYCODE_TV_RADIO_SERVICE : 232,
//     /** Key code constant: Teletext key.
//      * Displays Teletext service. */
//     KEYCODE_TV_TELETEXT : 233,
//     /** Key code constant: Number entry key.
//      * Initiates to enter multi-digit channel nubmber when each digit key is assigned
//      * for selecting separate channel. Corresponds to Number Entry Mode (0x1D) of CEC
//      * User Control Code. */
//     KEYCODE_TV_NUMBER_ENTRY : 234,
//     /** Key code constant: Analog Terrestrial key.
//      * Switches to analog terrestrial broadcast service. */
//     KEYCODE_TV_TERRESTRIAL_ANALOG : 235,
//     /** Key code constant: Digital Terrestrial key.
//      * Switches to digital terrestrial broadcast service. */
//     KEYCODE_TV_TERRESTRIAL_DIGITAL : 236,
//     /** Key code constant: Satellite key.
//      * Switches to digital satellite broadcast service. */
//     KEYCODE_TV_SATELLITE : 237,
//     /** Key code constant: BS key.
//      * Switches to BS digital satellite broadcasting service available in Japan. */
//     KEYCODE_TV_SATELLITE_BS : 238,
//     /** Key code constant: CS key.
//      * Switches to CS digital satellite broadcasting service available in Japan. */
//     KEYCODE_TV_SATELLITE_CS : 239,
//     /** Key code constant: BS/CS key.
//      * Toggles between BS and CS digital satellite services. */
//     KEYCODE_TV_SATELLITE_SERVICE : 240,
//     /** Key code constant: Toggle Network key.
//      * Toggles selecting broacast services. */
//     KEYCODE_TV_NETWORK : 241,
//     /** Key code constant: Antenna/Cable key.
//      * Toggles broadcast input source between antenna and cable. */
//     KEYCODE_TV_ANTENNA_CABLE : 242,
//     /** Key code constant: HDMI #1 key.
//      * Switches to HDMI input #1. */
//     KEYCODE_TV_INPUT_HDMI_1 : 243,
//     /** Key code constant: HDMI #2 key.
//      * Switches to HDMI input #2. */
//     KEYCODE_TV_INPUT_HDMI_2 : 244,
//     /** Key code constant: HDMI #3 key.
//      * Switches to HDMI input #3. */
//     KEYCODE_TV_INPUT_HDMI_3 : 245,
//     /** Key code constant: HDMI #4 key.
//      * Switches to HDMI input #4. */
//     KEYCODE_TV_INPUT_HDMI_4 : 246,
//     /** Key code constant: Composite #1 key.
//      * Switches to composite video input #1. */
//     KEYCODE_TV_INPUT_COMPOSITE_1 : 247,
//     /** Key code constant: Composite #2 key.
//      * Switches to composite video input #2. */
//     KEYCODE_TV_INPUT_COMPOSITE_2 : 248,
//     /** Key code constant: Component #1 key.
//      * Switches to component video input #1. */
//     KEYCODE_TV_INPUT_COMPONENT_1 : 249,
//     /** Key code constant: Component #2 key.
//      * Switches to component video input #2. */
//     KEYCODE_TV_INPUT_COMPONENT_2 : 250,
//     /** Key code constant: VGA #1 key.
//      * Switches to VGA (analog RGB) input #1. */
//     KEYCODE_TV_INPUT_VGA_1 : 251,
//     /** Key code constant: Audio description key.
//      * Toggles audio description off / on. */
//     KEYCODE_TV_AUDIO_DESCRIPTION : 252,
//     /** Key code constant: Audio description mixing volume up key.
//      * Louden audio description volume as compared with normal audio volume. */
//     KEYCODE_TV_AUDIO_DESCRIPTION_MIX_UP : 253,
//     /** Key code constant: Audio description mixing volume down key.
//      * Lessen audio description volume as compared with normal audio volume. */
//     KEYCODE_TV_AUDIO_DESCRIPTION_MIX_DOWN : 254,
//     /** Key code constant: Zoom mode key.
//      * Changes Zoom mode (Normal, Full, Zoom, Wide-zoom, etc.) */
//     KEYCODE_TV_ZOOM_MODE : 255,
//     /** Key code constant: Contents menu key.
//      * Goes to the title list. Corresponds to Contents Menu (0x0B) of CEC User Control
//      * Code */
//     KEYCODE_TV_CONTENTS_MENU : 256,
//     /** Key code constant: Media context menu key.
//      * Goes to the context menu of media contents. Corresponds to Media Context-sensitive
//      * Menu (0x11) of CEC User Control Code. */
//     KEYCODE_TV_MEDIA_CONTEXT_MENU : 257,
//     /** Key code constant: Timer programming key.
//      * Goes to the timer recording menu. Corresponds to Timer Programming (0x54) of
//      * CEC User Control Code. */
//     KEYCODE_TV_TIMER_PROGRAMMING : 258,
//     /** Key code constant: Help key. */
//     KEYCODE_HELP : 259,
//     /** Key code constant: Navigate to previous key.
//      * Goes backward by one item in an ordered collection of items. */
//     KEYCODE_NAVIGATE_PREVIOUS : 260,
//     /** Key code constant: Navigate to next key.
//      * Advances to the next item in an ordered collection of items. */
//     KEYCODE_NAVIGATE_NEXT   : 261,
//     /** Key code constant: Navigate in key.
//      * Activates the item that currently has focus or expands to the next level of a navigation
//      * hierarchy. */
//     KEYCODE_NAVIGATE_IN     : 262,
//     /** Key code constant: Navigate out key.
//      * Backs out one level of a navigation hierarchy or collapses the item that currently has
//      * focus. */
//     KEYCODE_NAVIGATE_OUT    : 263,
//     /** Key code constant: Primary stem key for Wear
//      * Main power/reset button on watch. */
//     KEYCODE_STEM_PRIMARY : 264,
//     /** Key code constant: Generic stem key 1 for Wear */
//     KEYCODE_STEM_1 : 265,
//     /** Key code constant: Generic stem key 2 for Wear */
//     KEYCODE_STEM_2 : 266,
//     /** Key code constant: Generic stem key 3 for Wear */
//     KEYCODE_STEM_3 : 267,
//     /** Key code constant: Directional Pad Up-Left */
//     KEYCODE_DPAD_UP_LEFT    : 268,
//     /** Key code constant: Directional Pad Down-Left */
//     KEYCODE_DPAD_DOWN_LEFT  : 269,
//     /** Key code constant: Directional Pad Up-Right */
//     KEYCODE_DPAD_UP_RIGHT   : 270,
//     /** Key code constant: Directional Pad Down-Right */
//     KEYCODE_DPAD_DOWN_RIGHT : 271,
//     /** Key code constant: Skip forward media key. */
//     KEYCODE_MEDIA_SKIP_FORWARD : 272,
//     /** Key code constant: Skip backward media key. */
//     KEYCODE_MEDIA_SKIP_BACKWARD : 273,
//     /** Key code constant: Step forward media key.
//      * Steps media forward, one frame at a time. */
//     KEYCODE_MEDIA_STEP_FORWARD : 274,
//     /** Key code constant: Step backward media key.
//      * Steps media backward, one frame at a time. */
//     KEYCODE_MEDIA_STEP_BACKWARD : 275,
//     /** Key code constant: put device to sleep unless a wakelock is held. */
//     KEYCODE_SOFT_SLEEP : 276,
//     /** Key code constant: Cut key. */
//     KEYCODE_CUT : 277,
//     /** Key code constant: Copy key. */
//     KEYCODE_COPY : 278,
//     /** Key code constant: Paste key. */
//     KEYCODE_PASTE : 279,
//     /** Key code constant: Consumed by the system for navigation up */
//     KEYCODE_SYSTEM_NAVIGATION_UP : 280,
//     /** Key code constant: Consumed by the system for navigation down */
//     KEYCODE_SYSTEM_NAVIGATION_DOWN : 281,
//     /** Key code constant: Consumed by the system for navigation left*/
//     KEYCODE_SYSTEM_NAVIGATION_LEFT : 282,
//     /** Key code constant: Consumed by the system for navigation right */
//     KEYCODE_SYSTEM_NAVIGATION_RIGHT : 283,
//     /** Key code constant: Show all apps */
//     KEYCODE_ALL_APPS : 284,
//     /** Key code constant: Refresh key. */
//     KEYCODE_REFRESH : 285,
//     /** Key code constant: Thumbs up key. Apps can use this to let user upvote content. */
//     KEYCODE_THUMBS_UP : 286,
//     /** Key code constant: Thumbs down key. Apps can use this to let user downvote content. */
//     KEYCODE_THUMBS_DOWN : 287,
//     /**
//      * Key code constant: Used to switch current {@link android.accounts.Account} that is
//      * consuming content. May be consumed by system to set account globally.
//      */
//     KEYCODE_PROFILE_SWITCH : 288,
//
//
//     keyCodeToString(keyCode) {
//         switch (keyCode) {
//                 case this.KEYCODE_UNKNOWN         : return "KEYCODE_UNKNOWN"; // 0,
//                 case this.KEYCODE_SOFT_LEFT       : return "KEYCODE_CALL";  // 1,
//                 case this.KEYCODE_SOFT_RIGHT      : return "KEYCODE_SOFT_RIGHT"; // 2,
//                 case this.KEYCODE_HOME            : return "KEYCODE_HOME"; // 3,
//                 case this.KEYCODE_BACK            : return "KEYCODE_BACK"; // 4,
//                 case this.KEYCODE_CALL            : return "KEYCODE_CALL"; // 5,
//                 case this.KEYCODE_ENDCALL         : return "KEYCODE_CALL"; // 6,
//                 /** Key code constant: return "KEYCODE_CALL"; // return "KEYCODE_CALL"; // '0' key. */
//                 case this.KEYCODE_0               : return "KEYCODE_CALL"; // return "KEYCODE_CALL"; // 7,
//                 /** Key code constant: return "KEYCODE_CALL"; // '1' key. */
//                 case this.KEYCODE_1               : return "KEYCODE_CALL"; // 8,
//                 /** Key code constant: return "KEYCODE_CALL"; // '2' key. */
//                 case this.KEYCODE_2               : return "KEYCODE_CALL"; // 9,
//                 /** Key code constant: return "KEYCODE_CALL"; // '3' key. */
//                 case this.KEYCODE_3               : return "KEYCODE_CALL"; // 10,
//                 /** Key code constant: return "KEYCODE_CALL"; // '4' key. */
//                 case this.KEYCODE_4               : return "KEYCODE_CALL"; // 11,
//                 /** Key code constant: return "KEYCODE_CALL"; // '5' key. */
//                 case this.KEYCODE_5               : return "KEYCODE_CALL"; // 12,
//                 /** Key code constant: return "KEYCODE_CALL"; // '6' key. */
//                 case this.KEYCODE_6               : return "KEYCODE_CALL"; // 13,
//                 /** Key code constant: return "KEYCODE_CALL"; // '7' key. */
//                 case this.KEYCODE_7               : return "KEYCODE_CALL"; // 14,
//                 /** Key code constant: return "KEYCODE_CALL"; // '8' key. */
//                 case this.KEYCODE_8               : return "KEYCODE_CALL"; // 15,
//                 /** Key code constant: return "KEYCODE_CALL"; // '9' key. */
//                 case this.KEYCODE_9               : return "KEYCODE_CALL"; // 16,
//                 /** Key code constant: return "KEYCODE_CALL"; // '*' key. */
//                 case this.KEYCODE_STAR            : return "KEYCODE_CALL"; // 17,
//                 /** Key code constant: return "KEYCODE_CALL"; // '#' key. */
//                 case this.KEYCODE_POUND           : return "KEYCODE_CALL"; // 18,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Up key.
//                  * May also be synthesized from trackball motions. */
//                 case this.KEYCODE_DPAD_UP         : return "KEYCODE_CALL"; // 19,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Down key.
//                  * May also be synthesized from trackball motions. */
//                 case this.KEYCODE_DPAD_DOWN       : return "KEYCODE_CALL"; // 20,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Left key.
//                  * May also be synthesized from trackball motions. */
//                 case this.KEYCODE_DPAD_LEFT       : return "KEYCODE_CALL"; // 21,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Right key.
//                  * May also be synthesized from trackball motions. */
//                 case this.KEYCODE_DPAD_RIGHT      : return "KEYCODE_CALL"; // 22,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Center key.
//                  * May also be synthesized from trackball motions. */
//                 case this.KEYCODE_DPAD_CENTER     : return "KEYCODE_CALL"; // 23,
//                 /** Key code constant: return "KEYCODE_CALL"; // Volume Up key.
//                  * Adjusts the speaker volume up. */
//                 case this.KEYCODE_VOLUME_UP       : return "KEYCODE_CALL"; // 24,
//                 /** Key code constant: return "KEYCODE_CALL"; // Volume Down key.
//                  * Adjusts the speaker volume down. */
//                 case this.KEYCODE_VOLUME_DOWN     : return "KEYCODE_CALL"; // 25,
//                 /** Key code constant: return "KEYCODE_CALL"; // Power key. */
//                 case this.KEYCODE_POWER           : return "KEYCODE_CALL"; // 26,
//                 /** Key code constant: return "KEYCODE_CALL"; // Camera key.
//                  * Used to launch a camera application or take pictures. */
//                 case this.KEYCODE_CAMERA          : return "KEYCODE_CALL"; // 27,
//                 /** Key code constant: return "KEYCODE_CALL"; // Clear key. */
//                 case this.KEYCODE_CLEAR           : return "KEYCODE_CALL"; // 28,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'A' key. */
//                 case this.KEYCODE_A               : return "KEYCODE_CALL"; // 29,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'B' key. */
//                 case this.KEYCODE_B               : return "KEYCODE_CALL"; // 30,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'C' key. */
//                 case this.KEYCODE_C               : return "KEYCODE_CALL"; // 31,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'D' key. */
//                 case this.KEYCODE_D               : return "KEYCODE_CALL"; // 32,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'E' key. */
//                 case this.KEYCODE_E               : return "KEYCODE_CALL"; // 33,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'F' key. */
//                 case this.KEYCODE_F               : return "KEYCODE_CALL"; // 34,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'G' key. */
//                 case this.KEYCODE_G               : return "KEYCODE_CALL"; // 35,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'H' key. */
//                 case this.KEYCODE_H               : return "KEYCODE_CALL"; // 36,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'I' key. */
//                 case this.KEYCODE_I               : return "KEYCODE_CALL"; // 37,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'J' key. */
//                 case this.KEYCODE_J               : return "KEYCODE_CALL"; // 38,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'K' key. */
//                 case this.KEYCODE_K               : return "KEYCODE_CALL"; // 39,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'L' key. */
//                 case this.KEYCODE_L               : return "KEYCODE_CALL"; // 40,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'M' key. */
//                 case this.KEYCODE_M               : return "KEYCODE_CALL"; // 41,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'N' key. */
//                 case this.KEYCODE_N               : return "KEYCODE_CALL"; // 42,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'O' key. */
//                 case this.KEYCODE_O               : return "KEYCODE_CALL"; // 43,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'P' key. */
//                 case this.KEYCODE_P               : return "KEYCODE_CALL"; // 44,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'Q' key. */
//                 case this.KEYCODE_Q               : return "KEYCODE_CALL"; // 45,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'R' key. */
//                 case this.KEYCODE_R               : return "KEYCODE_CALL"; // 46,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'S' key. */
//                 case this.KEYCODE_S               : return "KEYCODE_CALL"; // 47,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'T' key. */
//                 case this.KEYCODE_T               : return "KEYCODE_CALL"; // 48,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'U' key. */
//                 case this.KEYCODE_U               : return "KEYCODE_CALL"; // 49,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'V' key. */
//                 case this.KEYCODE_V               : return "KEYCODE_CALL"; // 50,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'W' key. */
//                 case this.KEYCODE_W               : return "KEYCODE_CALL"; // 51,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'X' key. */
//                 case this.KEYCODE_X               : return "KEYCODE_CALL"; // 52,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'Y' key. */
//                 case this.KEYCODE_Y               : return "KEYCODE_CALL"; // 53,
//                 /** Key code constant: return "KEYCODE_CALL"; // 'Z' key. */
//                 case this.KEYCODE_Z               : return "KEYCODE_CALL"; // 54,
//                 /** Key code constant: return "KEYCODE_CALL"; // ',' key. */
//                 case this.KEYCODE_COMMA           : return "KEYCODE_CALL"; // 55,
//                 /** Key code constant: return "KEYCODE_CALL"; // '.' key. */
//                 case this.KEYCODE_PERIOD          : return "KEYCODE_CALL"; // 56,
//                 /** Key code constant: return "KEYCODE_CALL"; // Left Alt modifier key. */
//                 case this.KEYCODE_ALT_LEFT        : return "KEYCODE_CALL"; // 57,
//                 /** Key code constant: return "KEYCODE_CALL"; // Right Alt modifier key. */
//                 case this.KEYCODE_ALT_RIGHT       : return "KEYCODE_CALL"; // 58,
//                 /** Key code constant: return "KEYCODE_CALL"; // Left Shift modifier key. */
//                 case this.KEYCODE_SHIFT_LEFT      : return "KEYCODE_CALL"; // 59,
//                 /** Key code constant: return "KEYCODE_CALL"; // Right Shift modifier key. */
//                 case this.KEYCODE_SHIFT_RIGHT     : return "KEYCODE_CALL"; // 60,
//                 /** Key code constant: return "KEYCODE_CALL"; // Tab key. */
//                 case this.KEYCODE_TAB             : return "KEYCODE_CALL"; // 61,
//                 /** Key code constant: return "KEYCODE_CALL"; // Space key. */
//                 case this.KEYCODE_SPACE           : return "KEYCODE_CALL"; // 62,
//                 /** Key code constant: return "KEYCODE_CALL"; // Symbol modifier key.
//                  * Used to enter alternate symbols. */
//                 case this.KEYCODE_SYM             : return "KEYCODE_CALL"; // 63,
//                 /** Key code constant: return "KEYCODE_CALL"; // Explorer special function key.
//                  * Used to launch a browser application. */
//                 case this.KEYCODE_EXPLORER        : return "KEYCODE_CALL"; // 64,
//                 /** Key code constant: return "KEYCODE_CALL"; // Envelope special function key.
//                  * Used to launch a mail application. */
//                 case this.KEYCODE_ENVELOPE        : return "KEYCODE_CALL"; // 65,
//                 /** Key code constant: return "KEYCODE_CALL"; // Enter key. */
//                 case this.KEYCODE_ENTER           : return "KEYCODE_CALL"; // 66,
//                 /** Key code constant: return "KEYCODE_CALL"; // Backspace key.
//                  * Deletes characters before the insertion point, unlike {@link #case this.KEYCODE_FORWARD_DEL}. */
//                 case this.KEYCODE_DEL             : return "KEYCODE_CALL"; // 67,
//                 /** Key code constant: return "KEYCODE_CALL"; // '`' (backtick) key. */
//                 case this.KEYCODE_GRAVE           : return "KEYCODE_CALL"; // 68,
//                 /** Key code constant: return "KEYCODE_CALL"; // '-'. */
//                 case this.KEYCODE_MINUS           : return "KEYCODE_CALL"; // 69,
//                 /** Key code constant: return "KEYCODE_CALL"; // '=' key. */
//                 case this.KEYCODE_EQUALS          : return "KEYCODE_CALL"; // 70,
//                 /** Key code constant: return "KEYCODE_CALL"; // '[' key. */
//                 case this.KEYCODE_LEFT_BRACKET    : return "KEYCODE_CALL"; // 71,
//                 /** Key code constant: return "KEYCODE_CALL"; // ']' key. */
//                 case this.KEYCODE_RIGHT_BRACKET   : return "KEYCODE_CALL"; // 72,
//                 /** Key code constant: return "KEYCODE_CALL"; // '\' key. */
//                 case this.KEYCODE_BACKSLASH       : return "KEYCODE_CALL"; // 73,
//                 /** Key code constant: return "KEYCODE_CALL"; // ',' key. */
//                 case this.KEYCODE_SEMICOLON       : return "KEYCODE_CALL"; // 74,
//                 /** Key code constant: return "KEYCODE_CALL"; // ''' (apostrophe) key. */
//                 case this.KEYCODE_APOSTROPHE      : return "KEYCODE_CALL"; // 75,
//                 /** Key code constant: return "KEYCODE_CALL"; // '/' key. */
//                 case this.KEYCODE_SLASH           : return "KEYCODE_CALL"; // 76,
//                 /** Key code constant: return "KEYCODE_CALL"; // '@' key. */
//                 case this.KEYCODE_AT              : return "KEYCODE_CALL"; // 77,
//                 /** Key code constant: return "KEYCODE_CALL"; // Number modifier key.
//                  * Used to enter numeric symbols.
//                  * This key is not Num Lock, it is more like {@link #case this.KEYCODE_ALT_LEFT} and is
//                  * interpreted as an ALT key by {@link android.text.method.MetaKeyKeyListener}. */
//                 case this.KEYCODE_NUM             : return "KEYCODE_CALL"; // 78,
//                 /** Key code constant: return "KEYCODE_CALL"; // Headset Hook key.
//                  * Used to hang up calls and stop media. */
//                 case this.KEYCODE_HEADSETHOOK     : return "KEYCODE_CALL"; // 79,
//                 /** Key code constant: return "KEYCODE_CALL"; // Camera Focus key.
//                  * Used to focus the camera. */
//                 case this.KEYCODE_FOCUS           : return "KEYCODE_CALL"; // 80,   // *Camera* focus
//                 /** Key code constant: return "KEYCODE_CALL"; // '+' key. */
//                 case this.KEYCODE_PLUS            : return "KEYCODE_CALL"; // 81,
//                 /** Key code constant: return "KEYCODE_CALL"; // Menu key. */
//                 case this.KEYCODE_MENU            : return "KEYCODE_CALL"; // 82,
//                 /** Key code constant: return "KEYCODE_CALL"; // Notification key. */
//                 case this.KEYCODE_NOTIFICATION    : return "KEYCODE_CALL"; // 83,
//                 /** Key code constant: return "KEYCODE_CALL"; // Search key. */
//                 case this.KEYCODE_SEARCH          : return "KEYCODE_CALL"; // 84,
//                 /** Key code constant: return "KEYCODE_CALL"; // Play/Pause media key. */
//                 case this.KEYCODE_MEDIA_PLAY_PAUSE: return "KEYCODE_CALL"; // 85,
//                 /** Key code constant: return "KEYCODE_CALL"; // Stop media key. */
//                 case this.KEYCODE_MEDIA_STOP      : return "KEYCODE_CALL"; // 86,
//                 /** Key code constant: return "KEYCODE_CALL"; // Play Next media key. */
//                 case this.KEYCODE_MEDIA_NEXT      : return "KEYCODE_CALL"; // 87,
//                 /** Key code constant: return "KEYCODE_CALL"; // Play Previous media key. */
//                 case this.KEYCODE_MEDIA_PREVIOUS  : return "KEYCODE_CALL"; // 88,
//                 /** Key code constant: return "KEYCODE_CALL"; // Rewind media key. */
//                 case this.KEYCODE_MEDIA_REWIND    : return "KEYCODE_CALL"; // 89,
//                 /** Key code constant: return "KEYCODE_CALL"; // Fast Forward media key. */
//                 case this.KEYCODE_MEDIA_FAST_FORWARD : return "KEYCODE_CALL"; // 90,
//                 /** Key code constant: return "KEYCODE_CALL"; // Mute key.
//                  * Mutes the microphone, unlike {@link #case this.KEYCODE_VOLUME_MUTE}. */
//                 case this.KEYCODE_MUTE            : return "KEYCODE_CALL"; // 91,
//                 /** Key code constant: return "KEYCODE_CALL"; // Page Up key. */
//                 case this.KEYCODE_PAGE_UP         : return "KEYCODE_CALL"; // 92,
//                 /** Key code constant: return "KEYCODE_CALL"; // Page Down key. */
//                 case this.KEYCODE_PAGE_DOWN       : return "KEYCODE_CALL"; // 93,
//                 /** Key code constant: return "KEYCODE_CALL"; // Picture Symbols modifier key.
//                  * Used to switch symbol sets (Emoji, Kao-moji). */
//                 case this.KEYCODE_PICTSYMBOLS     : return "KEYCODE_CALL"; // 94,   // switch symbol-sets (Emoji,Kao-moji)
//                 /** Key code constant: return "KEYCODE_CALL"; // Switch Charset modifier key.
//                  * Used to switch character sets (Kanji, Katakana). */
//                 case this.KEYCODE_SWITCH_CHARSET  : return "KEYCODE_CALL"; // 95,   // switch char-sets (Kanji,Katakana)
//                 /** Key code constant: return "KEYCODE_CALL"; // A Button key.
//                  * On a game controller, the A button should be either the button labeled A
//                  * or the first button on the bottom row of controller buttons. */
//                 case this.KEYCODE_BUTTON_A        : return "KEYCODE_CALL"; // 96,
//                 /** Key code constant: return "KEYCODE_CALL"; // B Button key.
//                  * On a game controller, the B button should be either the button labeled B
//                  * or the second button on the bottom row of controller buttons. */
//                 case this.KEYCODE_BUTTON_B        : return "KEYCODE_CALL"; // 97,
//                 /** Key code constant: return "KEYCODE_CALL"; // C Button key.
//                  * On a game controller, the C button should be either the button labeled C
//                  * or the third button on the bottom row of controller buttons. */
//                 case this.KEYCODE_BUTTON_C        : return "KEYCODE_CALL"; // 98,
//                 /** Key code constant: return "KEYCODE_CALL"; // X Button key.
//                  * On a game controller, the X button should be either the button labeled X
//                  * or the first button on the upper row of controller buttons. */
//                 case this.KEYCODE_BUTTON_X        : return "KEYCODE_CALL"; // 99,
//                 /** Key code constant: return "KEYCODE_CALL"; // Y Button key.
//                  * On a game controller, the Y button should be either the button labeled Y
//                  * or the second button on the upper row of controller buttons. */
//                 case this.KEYCODE_BUTTON_Y        : return "KEYCODE_CALL"; // 100,
//                 /** Key code constant: return "KEYCODE_CALL"; // Z Button key.
//                  * On a game controller, the Z button should be either the button labeled Z
//                  * or the third button on the upper row of controller buttons. */
//                 case this.KEYCODE_BUTTON_Z        : return "KEYCODE_CALL"; // 101,
//                 /** Key code constant: return "KEYCODE_CALL"; // L1 Button key.
//                  * On a game controller, the L1 button should be either the button labeled L1 (or L)
//                  * or the top left trigger button. */
//                 case this.KEYCODE_BUTTON_L1       : return "KEYCODE_CALL"; // 102,
//                 /** Key code constant: return "KEYCODE_CALL"; // R1 Button key.
//                  * On a game controller, the R1 button should be either the button labeled R1 (or R)
//                  * or the top right trigger button. */
//                 case this.KEYCODE_BUTTON_R1       : return "KEYCODE_CALL"; // 103,
//                 /** Key code constant: return "KEYCODE_CALL"; // L2 Button key.
//                  * On a game controller, the L2 button should be either the button labeled L2
//                  * or the bottom left trigger button. */
//                 case this.KEYCODE_BUTTON_L2       : return "KEYCODE_CALL"; // 104,
//                 /** Key code constant: return "KEYCODE_CALL"; // R2 Button key.
//                  * On a game controller, the R2 button should be either the button labeled R2
//                  * or the bottom right trigger button. */
//                 case this.KEYCODE_BUTTON_R2       : return "KEYCODE_CALL"; // 105,
//                 /** Key code constant: return "KEYCODE_CALL"; // Left Thumb Button key.
//                  * On a game controller, the left thumb button indicates that the left (or only)
//                  * joystick is pressed. */
//                 case this.KEYCODE_BUTTON_THUMBL   : return "KEYCODE_CALL"; // 106,
//                 /** Key code constant: return "KEYCODE_CALL"; // Right Thumb Button key.
//                  * On a game controller, the right thumb button indicates that the right
//                  * joystick is pressed. */
//                 case this.KEYCODE_BUTTON_THUMBR   : return "KEYCODE_CALL"; // 107,
//                 /** Key code constant: return "KEYCODE_CALL"; // Start Button key.
//                  * On a game controller, the button labeled Start. */
//                 case this.KEYCODE_BUTTON_START    : return "KEYCODE_CALL"; // 108,
//                 /** Key code constant: return "KEYCODE_CALL"; // Select Button key.
//                  * On a game controller, the button labeled Select. */
//                 case this.KEYCODE_BUTTON_SELECT   : return "KEYCODE_CALL"; // 109,
//                 /** Key code constant: return "KEYCODE_CALL"; // Mode Button key.
//                  * On a game controller, the button labeled Mode. */
//                 case this.KEYCODE_BUTTON_MODE     : return "KEYCODE_CALL"; // 110,
//                 /** Key code constant: return "KEYCODE_CALL"; // Escape key. */
//                 case this.KEYCODE_ESCAPE          : return "KEYCODE_CALL"; // 111,
//                 /** Key code constant: return "KEYCODE_CALL"; // Forward Delete key.
//                  * Deletes characters ahead of the insertion point, unlike {@link #case this.KEYCODE_DEL}. */
//                 case this.KEYCODE_FORWARD_DEL     : return "KEYCODE_CALL"; // 112,
//                 /** Key code constant: return "KEYCODE_CALL"; // Left Control modifier key. */
//                 case this.KEYCODE_CTRL_LEFT       : return "KEYCODE_CALL"; // 113,
//                 /** Key code constant: return "KEYCODE_CALL"; // Right Control modifier key. */
//                 case this.KEYCODE_CTRL_RIGHT      : return "KEYCODE_CALL"; // 114,
//                 /** Key code constant: return "KEYCODE_CALL"; // Caps Lock key. */
//                 case this.KEYCODE_CAPS_LOCK       : return "KEYCODE_CALL"; // 115,
//                 /** Key code constant: return "KEYCODE_CALL"; // Scroll Lock key. */
//                 case this.KEYCODE_SCROLL_LOCK     : return "KEYCODE_CALL"; // 116,
//                 /** Key code constant: return "KEYCODE_CALL"; // Left Meta modifier key. */
//                 case this.KEYCODE_META_LEFT       : return "KEYCODE_CALL"; // 117,
//                 /** Key code constant: return "KEYCODE_CALL"; // Right Meta modifier key. */
//                 case this.KEYCODE_META_RIGHT      : return "KEYCODE_CALL"; // 118,
//                 /** Key code constant: return "KEYCODE_CALL"; // Function modifier key. */
//                 case this.KEYCODE_FUNCTION        : return "KEYCODE_CALL"; // 119,
//                 /** Key code constant: return "KEYCODE_CALL"; // System Request / Print Screen key. */
//                 case this.KEYCODE_SYSRQ           : return "KEYCODE_CALL"; // 120,
//                 /** Key code constant: return "KEYCODE_CALL"; // Break / Pause key. */
//                 case this.KEYCODE_BREAK           : return "KEYCODE_CALL"; // 121,
//                 /** Key code constant: return "KEYCODE_CALL"; // Home Movement key.
//                  * Used for scrolling or moving the cursor around to the start of a line
//                  * or to the top of a list. */
//                 case this.KEYCODE_MOVE_HOME       : return "KEYCODE_CALL"; // 122,
//                 /** Key code constant: return "KEYCODE_CALL"; // End Movement key.
//                  * Used for scrolling or moving the cursor around to the end of a line
//                  * or to the bottom of a list. */
//                 case this.KEYCODE_MOVE_END        : return "KEYCODE_CALL"; // 123,
//                 /** Key code constant: return "KEYCODE_CALL"; // Insert key.
//                  * Toggles insert / overwrite edit mode. */
//                 case this.KEYCODE_INSERT          : return "KEYCODE_CALL"; // 124,
//                 /** Key code constant: return "KEYCODE_CALL"; // Forward key.
//                  * Navigates forward in the history stack.  Complement of {@link #case this.KEYCODE_BACK}. */
//                 case this.KEYCODE_FORWARD         : return "KEYCODE_CALL"; // 125,
//                 /** Key code constant: return "KEYCODE_CALL"; // Play media key. */
//                 case this.KEYCODE_MEDIA_PLAY      : return "KEYCODE_CALL"; // 126,
//                 /** Key code constant: return "KEYCODE_CALL"; // Pause media key. */
//                 case this.KEYCODE_MEDIA_PAUSE     : return "KEYCODE_CALL"; // 127,
//                 /** Key code constant: return "KEYCODE_CALL"; // Close media key.
//                  * May be used to close a CD tray, for example. */
//                 case this.KEYCODE_MEDIA_CLOSE     : return "KEYCODE_CALL"; // 128,
//                 /** Key code constant: return "KEYCODE_CALL"; // Eject media key.
//                  * May be used to eject a CD tray, for example. */
//                 case this.KEYCODE_MEDIA_EJECT     : return "KEYCODE_CALL"; // 129,
//                 /** Key code constant: return "KEYCODE_CALL"; // Record media key. */
//                 case this.KEYCODE_MEDIA_RECORD    : return "KEYCODE_CALL"; // 130,
//                 /** Key code constant: return "KEYCODE_CALL"; // F1 key. */
//                 case this.KEYCODE_F1              : return "KEYCODE_CALL"; // 131,
//                 /** Key code constant: return "KEYCODE_CALL"; // F2 key. */
//                 case this.KEYCODE_F2              : return "KEYCODE_CALL"; // 132,
//                 /** Key code constant: return "KEYCODE_CALL"; // F3 key. */
//                 case this.KEYCODE_F3              : return "KEYCODE_CALL"; // 133,
//                 /** Key code constant: return "KEYCODE_CALL"; // F4 key. */
//                 case this.KEYCODE_F4              : return "KEYCODE_CALL"; // 134,
//                 /** Key code constant: return "KEYCODE_CALL"; // F5 key. */
//                 case this.KEYCODE_F5              : return "KEYCODE_CALL"; // 135,
//                 /** Key code constant: return "KEYCODE_CALL"; // F6 key. */
//                 case this.KEYCODE_F6              : return "KEYCODE_CALL"; // 136,
//                 /** Key code constant: return "KEYCODE_CALL"; // F7 key. */
//                 case this.KEYCODE_F7              : return "KEYCODE_CALL"; // 137,
//                 /** Key code constant: return "KEYCODE_CALL"; // F8 key. */
//                 case this.KEYCODE_F8              : return "KEYCODE_CALL"; // 138,
//                 /** Key code constant: return "KEYCODE_CALL"; // F9 key. */
//                 case this.KEYCODE_F9              : return "KEYCODE_CALL"; // 139,
//                 /** Key code constant: return "KEYCODE_CALL"; // F10 key. */
//                 case this.KEYCODE_F10             : return "KEYCODE_CALL"; // 140,
//                 /** Key code constant: return "KEYCODE_CALL"; // F11 key. */
//                 case this.KEYCODE_F11             : return "KEYCODE_CALL"; // 141,
//                 /** Key code constant: return "KEYCODE_CALL"; // F12 key. */
//                 case this.KEYCODE_F12             : return "KEYCODE_CALL"; // 142,
//                 /** Key code constant: return "KEYCODE_CALL"; // Num Lock key.
//                  * This is the Num Lock key, it is different from {@link #case this.KEYCODE_NUM}.
//                  * This key alters the behavior of other keys on the numeric keypad. */
//                 case this.KEYCODE_NUM_LOCK        : return "KEYCODE_CALL"; // 143,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '0' key. */
//                 case this.KEYCODE_NUMPAD_0        : return "KEYCODE_CALL"; // 144,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '1' key. */
//                 case this.KEYCODE_NUMPAD_1        : return "KEYCODE_CALL"; // 145,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '2' key. */
//                 case this.KEYCODE_NUMPAD_2        : return "KEYCODE_CALL"; // 146,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '3' key. */
//                 case this.KEYCODE_NUMPAD_3        : return "KEYCODE_CALL"; // 147,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '4' key. */
//                 case this.KEYCODE_NUMPAD_4        : return "KEYCODE_CALL"; // 148,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '5' key. */
//                 case this.KEYCODE_NUMPAD_5        : return "KEYCODE_CALL"; // 149,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '6' key. */
//                 case this.KEYCODE_NUMPAD_6        : return "KEYCODE_CALL"; // 150,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '7' key. */
//                 case this.KEYCODE_NUMPAD_7        : return "KEYCODE_CALL"; // 151,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '8' key. */
//                 case this.KEYCODE_NUMPAD_8        : return "KEYCODE_CALL"; // 152,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '9' key. */
//                 case this.KEYCODE_NUMPAD_9        : return "KEYCODE_CALL"; // 153,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '/' key (for division). */
//                 case this.KEYCODE_NUMPAD_DIVIDE   : return "KEYCODE_CALL"; // 154,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '*' key (for multiplication). */
//                 case this.KEYCODE_NUMPAD_MULTIPLY : return "KEYCODE_CALL"; // 155,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '-' key (for subtraction). */
//                 case this.KEYCODE_NUMPAD_SUBTRACT : return "KEYCODE_CALL"; // 156,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '+' key (for addition). */
//                 case this.KEYCODE_NUMPAD_ADD      : return "KEYCODE_CALL"; // 157,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '.' key (for decimals or digit grouping). */
//                 case this.KEYCODE_NUMPAD_DOT      : return "KEYCODE_CALL"; // 158,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad ',' key (for decimals or digit grouping). */
//                 case this.KEYCODE_NUMPAD_COMMA    : return "KEYCODE_CALL"; // 159,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad Enter key. */
//                 case this.KEYCODE_NUMPAD_ENTER    : return "KEYCODE_CALL"; // 160,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '=' key. */
//                 case this.KEYCODE_NUMPAD_EQUALS   : return "KEYCODE_CALL"; // 161,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad '(' key. */
//                 case this.KEYCODE_NUMPAD_LEFT_PAREN : return "KEYCODE_CALL"; // 162,
//                 /** Key code constant: return "KEYCODE_CALL"; // Numeric keypad ')' key. */
//                 case this.KEYCODE_NUMPAD_RIGHT_PAREN : return "KEYCODE_CALL"; // 163,
//                 /** Key code constant: return "KEYCODE_CALL"; // Volume Mute key.
//                  * Mutes the speaker, unlike {@link #case this.KEYCODE_MUTE}.
//                  * This key should normally be implemented as a toggle such that the first press
//                  * mutes the speaker and the second press restores the original volume. */
//                 case this.KEYCODE_VOLUME_MUTE     : return "KEYCODE_CALL"; // 164,
//                 /** Key code constant: return "KEYCODE_CALL"; // Info key.
//                  * Common on TV remotes to show additional information related to what is
//                  * currently being viewed. */
//                 case this.KEYCODE_INFO            : return "KEYCODE_CALL"; // 165,
//                 /** Key code constant: return "KEYCODE_CALL"; // Channel up key.
//                  * On TV remotes, increments the television channel. */
//                 case this.KEYCODE_CHANNEL_UP      : return "KEYCODE_CALL"; // 166,
//                 /** Key code constant: return "KEYCODE_CALL"; // Channel down key.
//                  * On TV remotes, decrements the television channel. */
//                 case this.KEYCODE_CHANNEL_DOWN    : return "KEYCODE_CALL"; // 167,
//                 /** Key code constant: return "KEYCODE_CALL"; // Zoom in key. */
//                 case this.KEYCODE_ZOOM_IN         : return "KEYCODE_CALL"; // 168,
//                 /** Key code constant: return "KEYCODE_CALL"; // Zoom out key. */
//                 case this.KEYCODE_ZOOM_OUT        : return "KEYCODE_CALL"; // 169,
//                 /** Key code constant: return "KEYCODE_CALL"; // TV key.
//                  * On TV remotes, switches to viewing live TV. */
//                 case this.KEYCODE_TV              : return "KEYCODE_CALL"; // 170,
//                 /** Key code constant: return "KEYCODE_CALL"; // Window key.
//                  * On TV remotes, toggles picture-in-picture mode or other windowing functions.
//                  * On Android Wear devices, triggers a display offset. */
//                 case this.KEYCODE_WINDOW          : return "KEYCODE_CALL"; // 171,
//                 /** Key code constant: return "KEYCODE_CALL"; // Guide key.
//                  * On TV remotes, shows a programming guide. */
//                 case this.KEYCODE_GUIDE           : return "KEYCODE_CALL"; // 172,
//                 /** Key code constant: return "KEYCODE_CALL"; // DVR key.
//                  * On some TV remotes, switches to a DVR mode for recorded shows. */
//                 case this.KEYCODE_DVR             : return "KEYCODE_CALL"; // 173,
//                 /** Key code constant: return "KEYCODE_CALL"; // Bookmark key.
//                  * On some TV remotes, bookmarks content or web pages. */
//                 case this.KEYCODE_BOOKMARK        : return "KEYCODE_CALL"; // 174,
//                 /** Key code constant: return "KEYCODE_CALL"; // Toggle captions key.
//                  * Switches the mode for closed-captioning text, for example during television shows. */
//                 case this.KEYCODE_CAPTIONS        : return "KEYCODE_CALL"; // 175,
//                 /** Key code constant: return "KEYCODE_CALL"; // Settings key.
//                  * Starts the system settings activity. */
//                 case this.KEYCODE_SETTINGS        : return "KEYCODE_CALL"; // 176,
//                 /** Key code constant: return "KEYCODE_CALL"; // TV power key.
//                  * On TV remotes, toggles the power on a television screen. */
//                 case this.KEYCODE_TV_POWER        : return "KEYCODE_CALL"; // 177,
//                 /** Key code constant: return "KEYCODE_CALL"; // TV input key.
//                  * On TV remotes, switches the input on a television screen. */
//                 case this.KEYCODE_TV_INPUT        : return "KEYCODE_CALL"; // 178,
//                 /** Key code constant: return "KEYCODE_CALL"; // Set-top-box power key.
//                  * On TV remotes, toggles the power on an external Set-top-box. */
//                 case this.KEYCODE_STB_POWER       : return "KEYCODE_CALL"; // 179,
//                 /** Key code constant: return "KEYCODE_CALL"; // Set-top-box input key.
//                  * On TV remotes, switches the input mode on an external Set-top-box. */
//                 case this.KEYCODE_STB_INPUT       : return "KEYCODE_CALL"; // 180,
//                 /** Key code constant: return "KEYCODE_CALL"; // A/V Receiver power key.
//                  * On TV remotes, toggles the power on an external A/V Receiver. */
//                 case this.KEYCODE_AVR_POWER       : return "KEYCODE_CALL"; // 181,
//                 /** Key code constant: return "KEYCODE_CALL"; // A/V Receiver input key.
//                  * On TV remotes, switches the input mode on an external A/V Receiver. */
//                 case this.KEYCODE_AVR_INPUT       : return "KEYCODE_CALL"; // 182,
//                 /** Key code constant: return "KEYCODE_CALL"; // Red "programmable" key.
//                  * On TV remotes, acts as a contextual/programmable key. */
//                 case this.KEYCODE_PROG_RED        : return "KEYCODE_CALL"; // 183,
//                 /** Key code constant: return "KEYCODE_CALL"; // Green "programmable" key.
//                  * On TV remotes, actsas a contextual/programmable key. */
//                 case this.KEYCODE_PROG_GREEN      : return "KEYCODE_CALL"; // 184,
//                 /** Key code constant: return "KEYCODE_CALL"; // Yellow "programmable" key.
//                  * On TV remotes, acts as a contextual/programmable key. */
//                 case this.KEYCODE_PROG_YELLOW     : return "KEYCODE_CALL"; // 185,
//                 /** Key code constant: return "KEYCODE_CALL"; // Blue "programmable" key.
//                  * On TV remotes, acts as a contextual/programmable key. */
//                 case this.KEYCODE_PROG_BLUE       : return "KEYCODE_CALL"; // 186,
//                 /** Key code constant: return "KEYCODE_CALL"; // App switch key.
//                  * Should bring up the application switcher dialog. */
//                 case this.KEYCODE_APP_SWITCH      : return "KEYCODE_CALL"; // 187,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #1.*/
//                 case this.KEYCODE_BUTTON_1        : return "KEYCODE_CALL"; // 188,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #2.*/
//                 case this.KEYCODE_BUTTON_2        : return "KEYCODE_CALL"; // 189,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #3.*/
//                 case this.KEYCODE_BUTTON_3        : return "KEYCODE_CALL"; // 190,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #4.*/
//                 case this.KEYCODE_BUTTON_4        : return "KEYCODE_CALL"; // 191,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #5.*/
//                 case this.KEYCODE_BUTTON_5        : return "KEYCODE_CALL"; // 192,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #6.*/
//                 case this.KEYCODE_BUTTON_6        : return "KEYCODE_CALL"; // 193,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #7.*/
//                 case this.KEYCODE_BUTTON_7        : return "KEYCODE_CALL"; // 194,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #8.*/
//                 case this.KEYCODE_BUTTON_8        : return "KEYCODE_CALL"; // 195,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #9.*/
//                 case this.KEYCODE_BUTTON_9        : return "KEYCODE_CALL"; // 196,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #10.*/
//                 case this.KEYCODE_BUTTON_10       : return "KEYCODE_CALL"; // 197,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #11.*/
//                 case this.KEYCODE_BUTTON_11       : return "KEYCODE_CALL"; // 198,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #12.*/
//                 case this.KEYCODE_BUTTON_12       : return "KEYCODE_CALL"; // 199,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #13.*/
//                 case this.KEYCODE_BUTTON_13       : return "KEYCODE_CALL"; // 200,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #14.*/
//                 case this.KEYCODE_BUTTON_14       : return "KEYCODE_CALL"; // 201,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #15.*/
//                 case this.KEYCODE_BUTTON_15       : return "KEYCODE_CALL"; // 202,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic Game Pad Button #16.*/
//                 case this.KEYCODE_BUTTON_16       : return "KEYCODE_CALL"; // 203,
//                 /** Key code constant: return "KEYCODE_CALL"; // Language Switch key.
//                  * Toggles the current input language such as switching between English and Japanese on
//                  * a QWERTY keyboard.  On some devices, the same function may be performed by
//                  * pressing Shift+Spacebar. */
//                 case this.KEYCODE_LANGUAGE_SWITCH : return "KEYCODE_CALL"; // 204,
//                 /** Key code constant: return "KEYCODE_CALL"; // Manner Mode key.
//                  * Toggles silent or vibrate mode on and off to make the device behave more politely
//                  * in certain settings such as on a crowded train.  On some devices, the key may only
//                  * operate when long-pressed. */
//                 case this.KEYCODE_MANNER_MODE     : return "KEYCODE_CALL"; // 205,
//                 /** Key code constant: return "KEYCODE_CALL"; // 3D Mode key.
//                  * Toggles the display between 2D and 3D mode. */
//                 case this.KEYCODE_3D_MODE         : return "KEYCODE_CALL"; // 206,
//                 /** Key code constant: return "KEYCODE_CALL"; // Contacts special function key.
//                  * Used to launch an address book application. */
//                 case this.KEYCODE_CONTACTS        : return "KEYCODE_CALL"; // 207,
//                 /** Key code constant: return "KEYCODE_CALL"; // Calendar special function key.
//                  * Used to launch a calendar application. */
//                 case this.KEYCODE_CALENDAR        : return "KEYCODE_CALL"; // 208,
//                 /** Key code constant: return "KEYCODE_CALL"; // Music special function key.
//                  * Used to launch a music player application. */
//                 case this.KEYCODE_MUSIC           : return "KEYCODE_CALL"; // 209,
//                 /** Key code constant: return "KEYCODE_CALL"; // Calculator special function key.
//                  * Used to launch a calculator application. */
//                 case this.KEYCODE_CALCULATOR      : return "KEYCODE_CALL"; // 210,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese full-width / half-width key. */
//                 case this.KEYCODE_ZENKAKU_HANKAKU : return "KEYCODE_CALL"; // 211,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese alphanumeric key. */
//                 case this.KEYCODE_EISU            : return "KEYCODE_CALL"; // 212,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese non-conversion key. */
//                 case this.KEYCODE_MUHENKAN        : return "KEYCODE_CALL"; // 213,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese conversion key. */
//                 case this.KEYCODE_HENKAN          : return "KEYCODE_CALL"; // 214,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese katakana / hiragana key. */
//                 case this.KEYCODE_KATAKANA_HIRAGANA : return "KEYCODE_CALL"; // 215,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese Yen key. */
//                 case this.KEYCODE_YEN             : return "KEYCODE_CALL"; // 216,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese Ro key. */
//                 case this.KEYCODE_RO              : return "KEYCODE_CALL"; // 217,
//                 /** Key code constant: return "KEYCODE_CALL"; // Japanese kana key. */
//                 case this.KEYCODE_KANA            : return "KEYCODE_CALL"; // 218,
//                 /** Key code constant: return "KEYCODE_CALL"; // Assist key.
//                  * Launches the global assist activity.  Not delivered to applications. */
//                 case this.KEYCODE_ASSIST          : return "KEYCODE_CALL"; // 219,
//                 /** Key code constant: return "KEYCODE_CALL"; // Brightness Down key.
//                  * Adjusts the screen brightness down. */
//                 case this.KEYCODE_BRIGHTNESS_DOWN : return "KEYCODE_CALL"; // 220,
//                 /** Key code constant: return "KEYCODE_CALL"; // Brightness Up key.
//                  * Adjusts the screen brightness up. */
//                 case this.KEYCODE_BRIGHTNESS_UP   : return "KEYCODE_CALL"; // 221,
//                 /** Key code constant: return "KEYCODE_CALL"; // Audio Track key.
//                  * Switches the audio tracks. */
//                 case this.KEYCODE_MEDIA_AUDIO_TRACK : return "KEYCODE_CALL"; // 222,
//                 /** Key code constant: return "KEYCODE_CALL"; // Sleep key.
//                  * Puts the device to sleep.  Behaves somewhat like {@link #case this.KEYCODE_POWER} but it
//                  * has no effect if the device is already asleep. */
//                 case this.KEYCODE_SLEEP           : return "KEYCODE_CALL"; // 223,
//                 /** Key code constant: return "KEYCODE_CALL"; // Wakeup key.
//                  * Wakes up the device.  Behaves somewhat like {@link #case this.KEYCODE_POWER} but it
//                  * has no effect if the device is already awake. */
//                 case this.KEYCODE_WAKEUP          : return "KEYCODE_CALL"; // 224,
//                 /** Key code constant: return "KEYCODE_CALL"; // Pairing key.
//                  * Initiates peripheral pairing mode. Useful for pairing remote control
//                  * devices or game controllers, especially if no other input mode is
//                  * available. */
//                 case this.KEYCODE_PAIRING         : return "KEYCODE_CALL"; // 225,
//                 /** Key code constant: return "KEYCODE_CALL"; // Media Top Menu key.
//                  * Goes to the top of media menu. */
//                 case this.KEYCODE_MEDIA_TOP_MENU  : return "KEYCODE_CALL"; // 226,
//                 /** Key code constant: return "KEYCODE_CALL"; // '11' key. */
//                 case this.KEYCODE_11              : return "KEYCODE_CALL"; // 227,
//                 /** Key code constant: return "KEYCODE_CALL"; // '12' key. */
//                 case this.KEYCODE_12              : return "KEYCODE_CALL"; // 228,
//                 /** Key code constant: return "KEYCODE_CALL"; // Last Channel key.
//                  * Goes to the last viewed channel. */
//                 case this.KEYCODE_LAST_CHANNEL    : return "KEYCODE_CALL"; // 229,
//                 /** Key code constant: return "KEYCODE_CALL"; // TV data service key.
//                  * Displays data services like weather, sports. */
//                 case this.KEYCODE_TV_DATA_SERVICE : return "KEYCODE_CALL"; // 230,
//                 /** Key code constant: return "KEYCODE_CALL"; // Voice Assist key.
//                  * Launches the global voice assist activity. Not delivered to applications. */
//                 case this.KEYCODE_VOICE_ASSIST : return "KEYCODE_CALL"; // 231,
//                 /** Key code constant: return "KEYCODE_CALL"; // Radio key.
//                  * Toggles TV service / Radio service. */
//                 case this.KEYCODE_TV_RADIO_SERVICE : return "KEYCODE_CALL"; // 232,
//                 /** Key code constant: return "KEYCODE_CALL"; // Teletext key.
//                  * Displays Teletext service. */
//                 case this.KEYCODE_TV_TELETEXT : return "KEYCODE_CALL"; // 233,
//                 /** Key code constant: return "KEYCODE_CALL"; // Number entry key.
//                  * Initiates to enter multi-digit channel nubmber when each digit key is assigned
//                  * for selecting separate channel. Corresponds to Number Entry Mode (0x1D) of CEC
//                  * User Control Code. */
//                 case this.KEYCODE_TV_NUMBER_ENTRY : return "KEYCODE_CALL"; // 234,
//                 /** Key code constant: return "KEYCODE_CALL"; // Analog Terrestrial key.
//                  * Switches to analog terrestrial broadcast service. */
//                 case this.KEYCODE_TV_TERRESTRIAL_ANALOG : return "KEYCODE_CALL"; // 235,
//                 /** Key code constant: return "KEYCODE_CALL"; // Digital Terrestrial key.
//                  * Switches to digital terrestrial broadcast service. */
//                 case this.KEYCODE_TV_TERRESTRIAL_DIGITAL : return "KEYCODE_CALL"; // 236,
//                 /** Key code constant: return "KEYCODE_CALL"; // Satellite key.
//                  * Switches to digital satellite broadcast service. */
//                 case this.KEYCODE_TV_SATELLITE : return "KEYCODE_CALL"; // 237,
//                 /** Key code constant: return "KEYCODE_CALL"; // BS key.
//                  * Switches to BS digital satellite broadcasting service available in Japan. */
//                 case this.KEYCODE_TV_SATELLITE_BS : return "KEYCODE_CALL"; // 238,
//                 /** Key code constant: return "KEYCODE_CALL"; // CS key.
//                  * Switches to CS digital satellite broadcasting service available in Japan. */
//                 case this.KEYCODE_TV_SATELLITE_CS : return "KEYCODE_CALL"; // 239,
//                 /** Key code constant: return "KEYCODE_CALL"; // BS/CS key.
//                  * Toggles between BS and CS digital satellite services. */
//                 case this.KEYCODE_TV_SATELLITE_SERVICE : return "KEYCODE_CALL"; // 240,
//                 /** Key code constant: return "KEYCODE_CALL"; // Toggle Network key.
//                  * Toggles selecting broacast services. */
//                 case this.KEYCODE_TV_NETWORK : return "KEYCODE_CALL"; // 241,
//                 /** Key code constant: return "KEYCODE_CALL"; // Antenna/Cable key.
//                  * Toggles broadcast input source between antenna and cable. */
//                 case this.KEYCODE_TV_ANTENNA_CABLE : return "KEYCODE_CALL"; // 242,
//                 /** Key code constant: return "KEYCODE_CALL"; // HDMI #1 key.
//                  * Switches to HDMI input #1. */
//                 case this.KEYCODE_TV_INPUT_HDMI_1 : return "KEYCODE_CALL"; // 243,
//                 /** Key code constant: return "KEYCODE_CALL"; // HDMI #2 key.
//                  * Switches to HDMI input #2. */
//                 case this.KEYCODE_TV_INPUT_HDMI_2 : return "KEYCODE_CALL"; // 244,
//                 /** Key code constant: return "KEYCODE_CALL"; // HDMI #3 key.
//                  * Switches to HDMI input #3. */
//                 case this.KEYCODE_TV_INPUT_HDMI_3 : return "KEYCODE_CALL"; // 245,
//                 /** Key code constant: return "KEYCODE_CALL"; // HDMI #4 key.
//                  * Switches to HDMI input #4. */
//                 case this.KEYCODE_TV_INPUT_HDMI_4 : return "KEYCODE_CALL"; // 246,
//                 /** Key code constant: return "KEYCODE_CALL"; // Composite #1 key.
//                  * Switches to composite video input #1. */
//                 case this.KEYCODE_TV_INPUT_COMPOSITE_1 : return "KEYCODE_CALL"; // 247,
//                 /** Key code constant: return "KEYCODE_CALL"; // Composite #2 key.
//                  * Switches to composite video input #2. */
//                 case this.KEYCODE_TV_INPUT_COMPOSITE_2 : return "KEYCODE_CALL"; // 248,
//                 /** Key code constant: return "KEYCODE_CALL"; // Component #1 key.
//                  * Switches to component video input #1. */
//                 case this.KEYCODE_TV_INPUT_COMPONENT_1 : return "KEYCODE_CALL"; // 249,
//                 /** Key code constant: return "KEYCODE_CALL"; // Component #2 key.
//                  * Switches to component video input #2. */
//                 case this.KEYCODE_TV_INPUT_COMPONENT_2 : return "KEYCODE_CALL"; // 250,
//                 /** Key code constant: return "KEYCODE_CALL"; // VGA #1 key.
//                  * Switches to VGA (analog RGB) input #1. */
//                 case this.KEYCODE_TV_INPUT_VGA_1 : return "KEYCODE_CALL"; // 251,
//                 /** Key code constant: return "KEYCODE_CALL"; // Audio description key.
//                  * Toggles audio description off / on. */
//                 case this.KEYCODE_TV_AUDIO_DESCRIPTION : return "KEYCODE_CALL"; // 252,
//                 /** Key code constant: return "KEYCODE_CALL"; // Audio description mixing volume up key.
//                  * Louden audio description volume as compared with normal audio volume. */
//                 case this.KEYCODE_TV_AUDIO_DESCRIPTION_MIX_UP : return "KEYCODE_CALL"; // 253,
//                 /** Key code constant: return "KEYCODE_CALL"; // Audio description mixing volume down key.
//                  * Lessen audio description volume as compared with normal audio volume. */
//                 case this.KEYCODE_TV_AUDIO_DESCRIPTION_MIX_DOWN : return "KEYCODE_CALL"; // 254,
//                 /** Key code constant: return "KEYCODE_CALL"; // Zoom mode key.
//                  * Changes Zoom mode (Normal, Full, Zoom, Wide-zoom, etc.) */
//                 case this.KEYCODE_TV_ZOOM_MODE : return "KEYCODE_CALL"; // 255,
//                 /** Key code constant: return "KEYCODE_CALL"; // Contents menu key.
//                  * Goes to the title list. Corresponds to Contents Menu (0x0B) of CEC User Control
//                  * Code */
//                 case this.KEYCODE_TV_CONTENTS_MENU : return "KEYCODE_CALL"; // 256,
//                 /** Key code constant: return "KEYCODE_CALL"; // Media context menu key.
//                  * Goes to the context menu of media contents. Corresponds to Media Context-sensitive
//                  * Menu (0x11) of CEC User Control Code. */
//                 case this.KEYCODE_TV_MEDIA_CONTEXT_MENU : return "KEYCODE_CALL"; // 257,
//                 /** Key code constant: return "KEYCODE_CALL"; // Timer programming key.
//                  * Goes to the timer recording menu. Corresponds to Timer Programming (0x54) of
//                  * CEC User Control Code. */
//                 case this.KEYCODE_TV_TIMER_PROGRAMMING : return "KEYCODE_CALL"; // 258,
//                 /** Key code constant: return "KEYCODE_CALL"; // Help key. */
//                 case this.KEYCODE_HELP : return "KEYCODE_CALL"; // 259,
//                 /** Key code constant: return "KEYCODE_CALL"; // Navigate to previous key.
//                  * Goes backward by one item in an ordered collection of items. */
//                 case this.KEYCODE_NAVIGATE_PREVIOUS : return "KEYCODE_CALL"; // 260,
//                 /** Key code constant: return "KEYCODE_CALL"; // Navigate to next key.
//                  * Advances to the next item in an ordered collection of items. */
//                 case this.KEYCODE_NAVIGATE_NEXT   : return "KEYCODE_CALL"; // 261,
//                 /** Key code constant: return "KEYCODE_CALL"; // Navigate in key.
//                  * Activates the item that currently has focus or expands to the next level of a navigation
//                  * hierarchy. */
//                 case this.KEYCODE_NAVIGATE_IN     : return "KEYCODE_CALL"; // 262,
//                 /** Key code constant: return "KEYCODE_CALL"; // Navigate out key.
//                  * Backs out one level of a navigation hierarchy or collapses the item that currently has
//                  * focus. */
//                 case this.KEYCODE_NAVIGATE_OUT    : return "KEYCODE_CALL"; // 263,
//                 /** Key code constant: return "KEYCODE_CALL"; // Primary stem key for Wear
//                  * Main power/reset button on watch. */
//                 case this.KEYCODE_STEM_PRIMARY : return "KEYCODE_CALL"; // 264,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic stem key 1 for Wear */
//                 case this.KEYCODE_STEM_1 : return "KEYCODE_CALL"; // 265,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic stem key 2 for Wear */
//                 case this.KEYCODE_STEM_2 : return "KEYCODE_CALL"; // 266,
//                 /** Key code constant: return "KEYCODE_CALL"; // Generic stem key 3 for Wear */
//                 case this.KEYCODE_STEM_3 : return "KEYCODE_CALL"; // 267,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Up-Left */
//                 case this.KEYCODE_DPAD_UP_LEFT    : return "KEYCODE_CALL"; // 268,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Down-Left */
//                 case this.KEYCODE_DPAD_DOWN_LEFT  : return "KEYCODE_CALL"; // 269,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Up-Right */
//                 case this.KEYCODE_DPAD_UP_RIGHT   : return "KEYCODE_CALL"; // 270,
//                 /** Key code constant: return "KEYCODE_CALL"; // Directional Pad Down-Right */
//                 case this.KEYCODE_DPAD_DOWN_RIGHT : return "KEYCODE_CALL"; // 271,
//                 /** Key code constant: return "KEYCODE_CALL"; // Skip forward media key. */
//                 case this.KEYCODE_MEDIA_SKIP_FORWARD : return "KEYCODE_CALL"; // 272,
//                 /** Key code constant: return "KEYCODE_CALL"; // Skip backward media key. */
//                 case this.KEYCODE_MEDIA_SKIP_BACKWARD : return "KEYCODE_CALL"; // 273,
//                 /** Key code constant: return "KEYCODE_CALL"; // Step forward media key.
//                  * Steps media forward, one frame at a time. */
//                 case this.KEYCODE_MEDIA_STEP_FORWARD : return "KEYCODE_CALL"; // 274,
//                 /** Key code constant: return "KEYCODE_CALL"; // Step backward media key.
//                  * Steps media backward, one frame at a time. */
//                 case this.KEYCODE_MEDIA_STEP_BACKWARD : return "KEYCODE_CALL"; // 275,
//                 /** Key code constant: return "KEYCODE_CALL"; // put device to sleep unless a wakelock is held. */
//                 case this.KEYCODE_SOFT_SLEEP : return "KEYCODE_CALL"; // 276,
//                 /** Key code constant: return "KEYCODE_CALL"; // Cut key. */
//                 case this.KEYCODE_CUT : return "KEYCODE_CALL"; // 277,
//                 /** Key code constant: return "KEYCODE_CALL"; // Copy key. */
//                 case this.KEYCODE_COPY : return "KEYCODE_CALL"; // 278,
//                 /** Key code constant: return "KEYCODE_CALL"; // Paste key. */
//                 case this.KEYCODE_PASTE : return "KEYCODE_CALL"; // 279,
//                 /** Key code constant: return "KEYCODE_CALL"; // Consumed by the system for navigation up */
//                 case this.KEYCODE_SYSTEM_NAVIGATION_UP : return "KEYCODE_CALL"; // 280,
//                 /** Key code constant: return "KEYCODE_CALL"; // Consumed by the system for navigation down */
//                 case this.KEYCODE_SYSTEM_NAVIGATION_DOWN : return "KEYCODE_CALL"; // 281,
//                 /** Key code constant: return "KEYCODE_CALL"; // Consumed by the system for navigation left*/
//                 case this.KEYCODE_SYSTEM_NAVIGATION_LEFT : return "KEYCODE_CALL"; // 282,
//                 /** Key code constant: return "KEYCODE_CALL"; // Consumed by the system for navigation right */
//                 case this.KEYCODE_SYSTEM_NAVIGATION_RIGHT : return "KEYCODE_CALL"; // 283,
//                 /** Key code constant: return "KEYCODE_CALL"; // Show all apps */
//                 case this.KEYCODE_ALL_APPS : return "KEYCODE_CALL"; // 284,
//                 /** Key code constant: return "KEYCODE_CALL"; // Refresh key. */
//                 case this.KEYCODE_REFRESH : return "KEYCODE_CALL"; // 285,
//                 /** Key code constant: return "KEYCODE_CALL"; // Thumbs up key. Apps can use this to let user upvote content. */
//                 case this.KEYCODE_THUMBS_UP : return "KEYCODE_CALL"; // 286,
//                 /** Key code constant: return "KEYCODE_CALL"; // Thumbs down key. Apps can use this to let user downvote content. */
//                 case this.KEYCODE_THUMBS_DOWN : return "KEYCODE_CALL"; // 287,
//                 /**
//                  * Key code constant: return "KEYCODE_CALL"; // Used to switch current {@link android.accounts.Account} that is
//                  * consuming content. May be consumed by system to set account globally.
//                  */
//                 case this.KEYCODE_PROFILE_SWITCH : return "KEYCODE_CALL"; // 288,
//             default: return "KEYCODE_UNKNOWN";
//         }
//
//     }
// }