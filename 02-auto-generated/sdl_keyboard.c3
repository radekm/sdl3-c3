module sdl;


::LINE:: #ifndef SDL_keyboard_h_
::LINE:: #define SDL_keyboard_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

typedef SDL_KeyboardID = uint;

/* Function prototypes */

extern fn bool has_keyboard() @extern("SDL_HasKeyboard");

extern fn SDL_KeyboardID* get_keyboards(CInt* count) @extern("SDL_GetKeyboards");

extern fn ZString get_keyboard_name_for_id(SDL_KeyboardID instance_id) @extern("SDL_GetKeyboardNameForID");

extern fn SDL_Window* get_keyboard_focus() @extern("SDL_GetKeyboardFocus");

extern fn bool* get_keyboard_state(CInt* numkeys) @extern("SDL_GetKeyboardState");

extern fn void reset_keyboard() @extern("SDL_ResetKeyboard");

extern fn SDL_Keymod get_mod_state() @extern("SDL_GetModState");

extern fn void set_mod_state(SDL_Keymod modstate) @extern("SDL_SetModState");

extern fn SDL_Keycode get_key_from_scancode(SDL_Scancode scancode, SDL_Keymod modstate, bool key_event) @extern("SDL_GetKeyFromScancode");

extern fn SDL_Scancode get_scancode_from_key(SDL_Keycode key, SDL_Keymod* modstate) @extern("SDL_GetScancodeFromKey");

extern fn bool set_scancode_name(SDL_Scancode scancode, ZString name) @extern("SDL_SetScancodeName");

extern fn ZString get_scancode_name(SDL_Scancode scancode) @extern("SDL_GetScancodeName");

extern fn SDL_Scancode get_scancode_from_name(ZString name) @extern("SDL_GetScancodeFromName");

extern fn ZString get_key_name(SDL_Keycode key) @extern("SDL_GetKeyName");

extern fn SDL_Keycode get_key_from_name(ZString name) @extern("SDL_GetKeyFromName");

extern fn bool start_text_input(SDL_Window* window) @extern("SDL_StartTextInput");

enum SDL_TextInputType : const CInt
{
    TEXT,  /**< The input is text */
    TEXT_NAME,  /**< The input is a person's name */
    TEXT_EMAIL,  /**< The input is an e-mail address */
    TEXT_USERNAME,  /**< The input is a username */
    TEXT_PASSWORD_HIDDEN,  /**< The input is a secure password that is hidden */
    TEXT_PASSWORD_VISIBLE,  /**< The input is a secure password that is visible */
    NUMBER,  /**< The input is a number */
    NUMBER_PASSWORD_HIDDEN,  /**< The input is a secure PIN that is hidden */
    NUMBER_PASSWORD_VISIBLE,  /**< The input is a secure PIN that is visible */
}

enum SDL_Capitalization : const CInt
{
    NONE,  /**< No auto-capitalization will be done */
    SENTENCES,  /**< The first letter of sentences will be capitalized */
    WORDS,  /**< The first letter of words will be capitalized */
    LETTERS,  /**< All letters will be capitalized */
}

extern fn bool start_text_input_with_properties(SDL_Window* window, SDL_PropertiesID props) @extern("SDL_StartTextInputWithProperties");

const PROP_TEXTINPUT_TYPE_NUMBER                   = "SDL.textinput.type";
const PROP_TEXTINPUT_CAPITALIZATION_NUMBER         = "SDL.textinput.capitalization";
const PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN           = "SDL.textinput.autocorrect";
const PROP_TEXTINPUT_MULTILINE_BOOLEAN             = "SDL.textinput.multiline";
const PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER      = "SDL.textinput.android.inputtype";

extern fn bool text_input_active(SDL_Window* window) @extern("SDL_TextInputActive");

extern fn bool stop_text_input(SDL_Window* window) @extern("SDL_StopTextInput");

extern fn bool clear_composition(SDL_Window* window) @extern("SDL_ClearComposition");

extern fn bool set_text_input_area(SDL_Window* window, SDL_Rect* rect, CInt cursor) @extern("SDL_SetTextInputArea");

extern fn bool get_text_input_area(SDL_Window* window, SDL_Rect* rect, CInt* cursor) @extern("SDL_GetTextInputArea");

extern fn bool has_screen_keyboard_support() @extern("SDL_HasScreenKeyboardSupport");

extern fn bool screen_keyboard_shown(SDL_Window* window) @extern("SDL_ScreenKeyboardShown");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_keyboard_h_ */
