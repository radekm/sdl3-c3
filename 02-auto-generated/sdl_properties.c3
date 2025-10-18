module sdl;



::LINE:: #ifndef SDL_properties_h_
::LINE:: #define SDL_properties_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

typedef SDL_PropertiesID = uint;

enum SDL_PropertyType : const CInt
{
    INVALID,
    POINTER,
    STRING,
    NUMBER,
    FLOAT,
    BOOLEAN,
}

const PROP_NAME_STRING  = "SDL.name";

extern fn SDL_PropertiesID get_global_properties() @extern("SDL_GetGlobalProperties");

extern fn SDL_PropertiesID create_properties() @extern("SDL_CreateProperties");

extern fn bool copy_properties(SDL_PropertiesID src, SDL_PropertiesID dst) @extern("SDL_CopyProperties");

extern fn bool lock_properties(SDL_PropertiesID props) @extern("SDL_LockProperties");

extern fn void unlock_properties(SDL_PropertiesID props) @extern("SDL_UnlockProperties");

::LINE:: typedef void (SDLCALL *SDL_CleanupPropertyCallback)(void *userdata, void *value);

extern fn bool set_pointer_property_with_cleanup(SDL_PropertiesID props, ZString name, void* value, SDL_CleanupPropertyCallback cleanup, void* userdata) @extern("SDL_SetPointerPropertyWithCleanup");

extern fn bool set_pointer_property(SDL_PropertiesID props, ZString name, void* value) @extern("SDL_SetPointerProperty");

extern fn bool set_string_property(SDL_PropertiesID props, ZString name, ZString value) @extern("SDL_SetStringProperty");

extern fn bool set_number_property(SDL_PropertiesID props, ZString name, long value) @extern("SDL_SetNumberProperty");

extern fn bool set_float_property(SDL_PropertiesID props, ZString name, float value) @extern("SDL_SetFloatProperty");

extern fn bool set_boolean_property(SDL_PropertiesID props, ZString name, bool value) @extern("SDL_SetBooleanProperty");

extern fn bool has_property(SDL_PropertiesID props, ZString name) @extern("SDL_HasProperty");

extern fn SDL_PropertyType get_property_type(SDL_PropertiesID props, ZString name) @extern("SDL_GetPropertyType");

extern fn void* get_pointer_property(SDL_PropertiesID props, ZString name, void* default_value) @extern("SDL_GetPointerProperty");

extern fn ZString get_string_property(SDL_PropertiesID props, ZString name, ZString default_value) @extern("SDL_GetStringProperty");

extern fn long get_number_property(SDL_PropertiesID props, ZString name, long default_value) @extern("SDL_GetNumberProperty");

extern fn float get_float_property(SDL_PropertiesID props, ZString name, float default_value) @extern("SDL_GetFloatProperty");

extern fn bool get_boolean_property(SDL_PropertiesID props, ZString name, bool default_value) @extern("SDL_GetBooleanProperty");

extern fn bool clear_property(SDL_PropertiesID props, ZString name) @extern("SDL_ClearProperty");

::LINE:: typedef void (SDLCALL *SDL_EnumeratePropertiesCallback)(void *userdata, SDL_PropertiesID props, const char *name);

extern fn bool enumerate_properties(SDL_PropertiesID props, SDL_EnumeratePropertiesCallback callback, void* userdata) @extern("SDL_EnumerateProperties");

extern fn void destroy_properties(SDL_PropertiesID props) @extern("SDL_DestroyProperties");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_properties_h_ */
