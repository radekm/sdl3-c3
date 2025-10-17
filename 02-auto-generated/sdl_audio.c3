module sdl;


::LINE:: #ifndef SDL_audio_h_
::LINE:: #define SDL_audio_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

::LINE:: #define SDL_AUDIO_MASK_BITSIZE       (0xFFu)

::LINE:: #define SDL_AUDIO_MASK_FLOAT         (1u<<8)

::LINE:: #define SDL_AUDIO_MASK_BIG_ENDIAN    (1u<<12)

::LINE:: #define SDL_AUDIO_MASK_SIGNED        (1u<<15)

::LINE:: #define SDL_DEFINE_AUDIO_FORMAT(signed, bigendian, flt, size) \
::LINE::     (((Uint16)(signed) << 15) | ((Uint16)(bigendian) << 12) | ((Uint16)(flt) << 8) | ((size) & SDL_AUDIO_MASK_BITSIZE))

enum SDL_AudioFormat : const CInt
{
    UNKNOWN = 0x0000u,  /**< Unspecified audio format */
    U8 = 0x0008u,  /**< Unsigned 8-bit samples */
        /* SDL_DEFINE_AUDIO_FORMAT(0, 0, 0, 8), */
    S8 = 0x8008u,  /**< Signed 8-bit samples */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 0, 0, 8), */
    S16LE = 0x8010u,  /**< Signed 16-bit samples */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 0, 0, 16), */
    S16BE = 0x9010u,  /**< As above, but big-endian byte order */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 1, 0, 16), */
    S32LE = 0x8020u,  /**< 32-bit integer samples */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 0, 0, 32), */
    S32BE = 0x9020u,  /**< As above, but big-endian byte order */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 1, 0, 32), */
    F32LE = 0x8120u,  /**< 32-bit floating point samples */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 0, 1, 32), */
    F32BE = 0x9120u,  /**< As above, but big-endian byte order */
        /* SDL_DEFINE_AUDIO_FORMAT(1, 1, 1, 32), */

    /* These represent the current system's byteorder. */
::LINE::     #if SDL_BYTEORDER == SDL_LIL_ENDIAN
::LINE::     SDL_AUDIO_S16 = SDL_AUDIO_S16LE,
::LINE::     SDL_AUDIO_S32 = SDL_AUDIO_S32LE,
::LINE::     SDL_AUDIO_F32 = SDL_AUDIO_F32LE
::LINE::     #else
::LINE::     SDL_AUDIO_S16 = SDL_AUDIO_S16BE,
::LINE::     SDL_AUDIO_S32 = SDL_AUDIO_S32BE,
::LINE::     SDL_AUDIO_F32 = SDL_AUDIO_F32BE
::LINE::     #endif
}


::LINE:: #define SDL_AUDIO_BITSIZE(x)         ((x) & SDL_AUDIO_MASK_BITSIZE)

::LINE:: #define SDL_AUDIO_BYTESIZE(x)        (SDL_AUDIO_BITSIZE(x) / 8)

::LINE:: #define SDL_AUDIO_ISFLOAT(x)         ((x) & SDL_AUDIO_MASK_FLOAT)

::LINE:: #define SDL_AUDIO_ISBIGENDIAN(x)     ((x) & SDL_AUDIO_MASK_BIG_ENDIAN)

::LINE:: #define SDL_AUDIO_ISLITTLEENDIAN(x)  (!SDL_AUDIO_ISBIGENDIAN(x))

::LINE:: #define SDL_AUDIO_ISSIGNED(x)        ((x) & SDL_AUDIO_MASK_SIGNED)

::LINE:: #define SDL_AUDIO_ISINT(x)           (!SDL_AUDIO_ISFLOAT(x))

::LINE:: #define SDL_AUDIO_ISUNSIGNED(x)      (!SDL_AUDIO_ISSIGNED(x))


typedef SDL_AudioDeviceID = uint;

::LINE:: #define SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK ((SDL_AudioDeviceID) 0xFFFFFFFFu)

::LINE:: #define SDL_AUDIO_DEVICE_DEFAULT_RECORDING ((SDL_AudioDeviceID) 0xFFFFFFFEu)

struct SDL_AudioSpec
{
    SDL_AudioFormat format;  /**< Audio data format */
    CInt channels;  /**< Number of channels: 1 mono, 2 stereo, etc */
    CInt freq;  /**< sample rate: sample frames per second */
}

::LINE:: #define SDL_AUDIO_FRAMESIZE(x) (SDL_AUDIO_BYTESIZE((x).format) * (x).channels)

typedef SDL_AudioStream = void;


/* Function prototypes */

extern fn CInt get_num_audio_drivers() @extern("SDL_GetNumAudioDrivers");

extern fn ZString get_audio_driver(CInt index) @extern("SDL_GetAudioDriver");

extern fn ZString get_current_audio_driver() @extern("SDL_GetCurrentAudioDriver");

extern fn SDL_AudioDeviceID* get_audio_playback_devices(CInt* count) @extern("SDL_GetAudioPlaybackDevices");

extern fn SDL_AudioDeviceID* get_audio_recording_devices(CInt* count) @extern("SDL_GetAudioRecordingDevices");

extern fn ZString get_audio_device_name(SDL_AudioDeviceID devid) @extern("SDL_GetAudioDeviceName");

extern fn bool get_audio_device_format(SDL_AudioDeviceID devid, SDL_AudioSpec* spec, CInt* sample_frames) @extern("SDL_GetAudioDeviceFormat");

extern fn CInt* get_audio_device_channel_map(SDL_AudioDeviceID devid, CInt* count) @extern("SDL_GetAudioDeviceChannelMap");

extern fn SDL_AudioDeviceID open_audio_device(SDL_AudioDeviceID devid, SDL_AudioSpec* spec) @extern("SDL_OpenAudioDevice");

extern fn bool is_audio_device_physical(SDL_AudioDeviceID devid) @extern("SDL_IsAudioDevicePhysical");

extern fn bool is_audio_device_playback(SDL_AudioDeviceID devid) @extern("SDL_IsAudioDevicePlayback");

extern fn bool pause_audio_device(SDL_AudioDeviceID devid) @extern("SDL_PauseAudioDevice");

extern fn bool resume_audio_device(SDL_AudioDeviceID devid) @extern("SDL_ResumeAudioDevice");

extern fn bool audio_device_paused(SDL_AudioDeviceID devid) @extern("SDL_AudioDevicePaused");

extern fn float get_audio_device_gain(SDL_AudioDeviceID devid) @extern("SDL_GetAudioDeviceGain");

extern fn bool set_audio_device_gain(SDL_AudioDeviceID devid, float gain) @extern("SDL_SetAudioDeviceGain");

extern fn void close_audio_device(SDL_AudioDeviceID devid) @extern("SDL_CloseAudioDevice");

extern fn bool bind_audio_streams(SDL_AudioDeviceID devid, SDL_AudioStream** streams, CInt num_streams) @extern("SDL_BindAudioStreams");

extern fn bool bind_audio_stream(SDL_AudioDeviceID devid, SDL_AudioStream* stream) @extern("SDL_BindAudioStream");

extern fn void unbind_audio_streams(SDL_AudioStream** streams, CInt num_streams) @extern("SDL_UnbindAudioStreams");

extern fn void unbind_audio_stream(SDL_AudioStream* stream) @extern("SDL_UnbindAudioStream");

extern fn SDL_AudioDeviceID get_audio_stream_device(SDL_AudioStream* stream) @extern("SDL_GetAudioStreamDevice");

extern fn SDL_AudioStream* create_audio_stream(SDL_AudioSpec* src_spec, SDL_AudioSpec* dst_spec) @extern("SDL_CreateAudioStream");

extern fn SDL_PropertiesID get_audio_stream_properties(SDL_AudioStream* stream) @extern("SDL_GetAudioStreamProperties");

const PROP_AUDIOSTREAM_AUTO_CLEANUP_BOOLEAN  = "SDL.audiostream.auto_cleanup";


extern fn bool get_audio_stream_format(SDL_AudioStream* stream, SDL_AudioSpec* src_spec, SDL_AudioSpec* dst_spec) @extern("SDL_GetAudioStreamFormat");

extern fn bool set_audio_stream_format(SDL_AudioStream* stream, SDL_AudioSpec* src_spec, SDL_AudioSpec* dst_spec) @extern("SDL_SetAudioStreamFormat");

extern fn float get_audio_stream_frequency_ratio(SDL_AudioStream* stream) @extern("SDL_GetAudioStreamFrequencyRatio");

extern fn bool set_audio_stream_frequency_ratio(SDL_AudioStream* stream, float ratio) @extern("SDL_SetAudioStreamFrequencyRatio");

extern fn float get_audio_stream_gain(SDL_AudioStream* stream) @extern("SDL_GetAudioStreamGain");

extern fn bool set_audio_stream_gain(SDL_AudioStream* stream, float gain) @extern("SDL_SetAudioStreamGain");

extern fn CInt* get_audio_stream_input_channel_map(SDL_AudioStream* stream, CInt* count) @extern("SDL_GetAudioStreamInputChannelMap");

extern fn CInt* get_audio_stream_output_channel_map(SDL_AudioStream* stream, CInt* count) @extern("SDL_GetAudioStreamOutputChannelMap");

extern fn bool set_audio_stream_input_channel_map(SDL_AudioStream* stream, CInt* chmap, CInt count) @extern("SDL_SetAudioStreamInputChannelMap");

extern fn bool set_audio_stream_output_channel_map(SDL_AudioStream* stream, CInt* chmap, CInt count) @extern("SDL_SetAudioStreamOutputChannelMap");

extern fn bool put_audio_stream_data(SDL_AudioStream* stream, void* buf, CInt len) @extern("SDL_PutAudioStreamData");

::LINE:: typedef void (SDLCALL *SDL_AudioStreamDataCompleteCallback)(void *userdata, const void *buf, int buflen);

extern fn bool put_audio_stream_data_no_copy(SDL_AudioStream* stream, void* buf, CInt len, SDL_AudioStreamDataCompleteCallback callback, void* userdata) @extern("SDL_PutAudioStreamDataNoCopy");

extern fn bool put_audio_stream_planar_data(SDL_AudioStream* stream, void** channel_buffers, CInt num_channels, CInt num_samples) @extern("SDL_PutAudioStreamPlanarData");

extern fn CInt get_audio_stream_data(SDL_AudioStream* stream, void* buf, CInt len) @extern("SDL_GetAudioStreamData");

extern fn CInt get_audio_stream_available(SDL_AudioStream* stream) @extern("SDL_GetAudioStreamAvailable");


extern fn CInt get_audio_stream_queued(SDL_AudioStream* stream) @extern("SDL_GetAudioStreamQueued");


extern fn bool flush_audio_stream(SDL_AudioStream* stream) @extern("SDL_FlushAudioStream");

extern fn bool clear_audio_stream(SDL_AudioStream* stream) @extern("SDL_ClearAudioStream");

extern fn bool pause_audio_stream_device(SDL_AudioStream* stream) @extern("SDL_PauseAudioStreamDevice");

extern fn bool resume_audio_stream_device(SDL_AudioStream* stream) @extern("SDL_ResumeAudioStreamDevice");

extern fn bool audio_stream_device_paused(SDL_AudioStream* stream) @extern("SDL_AudioStreamDevicePaused");


extern fn bool lock_audio_stream(SDL_AudioStream* stream) @extern("SDL_LockAudioStream");


extern fn bool unlock_audio_stream(SDL_AudioStream* stream) @extern("SDL_UnlockAudioStream");

::LINE:: typedef void (SDLCALL *SDL_AudioStreamCallback)(void *userdata, SDL_AudioStream *stream, int additional_amount, int total_amount);

extern fn bool set_audio_stream_get_callback(SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userdata) @extern("SDL_SetAudioStreamGetCallback");

extern fn bool set_audio_stream_put_callback(SDL_AudioStream* stream, SDL_AudioStreamCallback callback, void* userdata) @extern("SDL_SetAudioStreamPutCallback");


extern fn void destroy_audio_stream(SDL_AudioStream* stream) @extern("SDL_DestroyAudioStream");


extern fn SDL_AudioStream* open_audio_device_stream(SDL_AudioDeviceID devid, SDL_AudioSpec* spec, SDL_AudioStreamCallback callback, void* userdata) @extern("SDL_OpenAudioDeviceStream");

::LINE:: typedef void (SDLCALL *SDL_AudioPostmixCallback)(void *userdata, const SDL_AudioSpec *spec, float *buffer, int buflen);

extern fn bool set_audio_postmix_callback(SDL_AudioDeviceID devid, SDL_AudioPostmixCallback callback, void* userdata) @extern("SDL_SetAudioPostmixCallback");


extern fn bool load_wav_io(SDL_IOStream* src, bool closeio, SDL_AudioSpec* spec, char** audio_buf, uint* audio_len) @extern("SDL_LoadWAV_IO");

extern fn bool load_wav(ZString path, SDL_AudioSpec* spec, char** audio_buf, uint* audio_len) @extern("SDL_LoadWAV");

extern fn bool mix_audio(char* dst, char* src, SDL_AudioFormat format, uint len, float volume) @extern("SDL_MixAudio");

extern fn bool convert_audio_samples(SDL_AudioSpec* src_spec, char* src_data, CInt src_len, SDL_AudioSpec* dst_spec, char** dst_data, CInt* dst_len) @extern("SDL_ConvertAudioSamples");

extern fn ZString get_audio_format_name(SDL_AudioFormat format) @extern("SDL_GetAudioFormatName");

extern fn CInt get_silence_value_for_format(SDL_AudioFormat format) @extern("SDL_GetSilenceValueForFormat");


/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_audio_h_ */
