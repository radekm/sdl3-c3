module sdl;

/* WIKI CATEGORY: IOStream */


::LINE:: #ifndef SDL_iostream_h_
::LINE:: #define SDL_iostream_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

enum SDL_IOStatus : const CInt
{
    READY,  /**< Everything is ready (no errors and not EOF). */
    ERROR,  /**< Read or write I/O error */
    EOF,  /**< End of file */
    NOT_READY,  /**< Non blocking I/O, not ready */
    READONLY,  /**< Tried to write a read-only buffer */
    WRITEONLY,  /**< Tried to read a write-only buffer */
}

enum SDL_IOWhence : const CInt
{
    SET,  /**< Seek from the beginning of data */
    CUR,  /**< Seek relative to current read point */
    END,  /**< Seek relative to the end of data */
}

struct SDL_IOStreamInterface
{
    /* The version of this interface */
    uint version;

    /**
     *  Return the number of bytes in this SDL_IOStream
     *
     *  \return the total size of the data stream, or -1 on error.
     */
::LINE::     Sint64 (SDLCALL *size)(void *userdata);

    /**
     *  Seek to `offset` relative to `whence`, one of stdio's whence values:
     *  SDL_IO_SEEK_SET, SDL_IO_SEEK_CUR, SDL_IO_SEEK_END
     *
     *  \return the final offset in the data stream, or -1 on error.
     */
::LINE::     Sint64 (SDLCALL *seek)(void *userdata, Sint64 offset, SDL_IOWhence whence);

    /**
     *  Read up to `size` bytes from the data stream to the area pointed
     *  at by `ptr`. `size` will always be > 0.
     *
     *  On an incomplete read, you should set `*status` to a value from the
     *  SDL_IOStatus enum. You do not have to explicitly set this on
     *  a complete, successful read.
     *
     *  \return the number of bytes read
     */
::LINE::     size_t (SDLCALL *read)(void *userdata, void *ptr, size_t size, SDL_IOStatus *status);

    /**
     *  Write exactly `size` bytes from the area pointed at by `ptr`
     *  to data stream. `size` will always be > 0.
     *
     *  On an incomplete write, you should set `*status` to a value from the
     *  SDL_IOStatus enum. You do not have to explicitly set this on
     *  a complete, successful write.
     *
     *  \return the number of bytes written
     */
::LINE::     size_t (SDLCALL *write)(void *userdata, const void *ptr, size_t size, SDL_IOStatus *status);

    /**
     *  If the stream is buffering, make sure the data is written out.
     *
     *  On failure, you should set `*status` to a value from the
     *  SDL_IOStatus enum. You do not have to explicitly set this on
     *  a successful flush.
     *
     *  \return true if successful or false on write error when flushing data.
     */
::LINE::     bool (SDLCALL *flush)(void *userdata, SDL_IOStatus *status);

    /**
     *  Close and free any allocated resources.
     *
     *  This does not guarantee file writes will sync to physical media; they
     *  can be in the system's file cache, waiting to go to disk.
     *
     *  The SDL_IOStream is still destroyed even if this fails, so clean up anything
     *  even if flushing buffers, etc, returns an error.
     *
     *  \return true if successful or false on write error when flushing data.
     */
::LINE::     bool (SDLCALL *close)(void *userdata);

}

::LINE:: /* Check the size of SDL_IOStreamInterface
::LINE::  *
::LINE::  * If this assert fails, either the compiler is padding to an unexpected size,
::LINE::  * or the interface has been updated and this should be updated to match and
::LINE::  * the code using this interface should be updated to handle the old version.
::LINE::  */
::LINE:: SDL_COMPILE_TIME_ASSERT(SDL_IOStreamInterface_SIZE,
::LINE::     (sizeof(void *) == 4 && sizeof(SDL_IOStreamInterface) == 28) ||
::LINE::     (sizeof(void *) == 8 && sizeof(SDL_IOStreamInterface) == 56));

typedef SDL_IOStream = void;


/* @{ */

extern fn SDL_IOStream* io_from_file(ZString file, ZString mode) @extern("SDL_IOFromFile");

const PROP_IOSTREAM_WINDOWS_HANDLE_POINTER     = "SDL.iostream.windows.handle";
const PROP_IOSTREAM_STDIO_FILE_POINTER         = "SDL.iostream.stdio.file";
const PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER     = "SDL.iostream.file_descriptor";
const PROP_IOSTREAM_ANDROID_AASSET_POINTER     = "SDL.iostream.android.aasset";

extern fn SDL_IOStream* io_from_mem(void* mem, usz size) @extern("SDL_IOFromMem");

const PROP_IOSTREAM_MEMORY_POINTER  = "SDL.iostream.memory.base";
const PROP_IOSTREAM_MEMORY_SIZE_NUMBER   = "SDL.iostream.memory.size";
const PROP_IOSTREAM_MEMORY_FREE_FUNC_POINTER  = "SDL.iostream.memory.free";

extern fn SDL_IOStream* io_from_const_mem(void* mem, usz size) @extern("SDL_IOFromConstMem");

extern fn SDL_IOStream* io_from_dynamic_mem() @extern("SDL_IOFromDynamicMem");

const PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER     = "SDL.iostream.dynamic.memory";
const PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER   = "SDL.iostream.dynamic.chunksize";

/* @} *//* IOFrom functions */


extern fn SDL_IOStream* open_io(SDL_IOStreamInterface* iface, void* userdata) @extern("SDL_OpenIO");

extern fn bool close_io(SDL_IOStream* context) @extern("SDL_CloseIO");

extern fn SDL_PropertiesID get_io_properties(SDL_IOStream* context) @extern("SDL_GetIOProperties");

extern fn SDL_IOStatus get_io_status(SDL_IOStream* context) @extern("SDL_GetIOStatus");

extern fn long get_io_size(SDL_IOStream* context) @extern("SDL_GetIOSize");

extern fn long seek_io(SDL_IOStream* context, long offset, SDL_IOWhence whence) @extern("SDL_SeekIO");

extern fn long tell_io(SDL_IOStream* context) @extern("SDL_TellIO");

extern fn usz read_io(SDL_IOStream* context, void* ptr, usz size) @extern("SDL_ReadIO");

extern fn usz write_io(SDL_IOStream* context, void* ptr, usz size) @extern("SDL_WriteIO");

::LINE:: extern SDL_DECLSPEC size_t SDLCALL SDL_IOprintf(SDL_IOStream *context, SDL_PRINTF_FORMAT_STRING const char *fmt, ...)  SDL_PRINTF_VARARG_FUNC(2);

::LINE:: extern SDL_DECLSPEC size_t SDLCALL SDL_IOvprintf(SDL_IOStream *context, SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(2);

extern fn bool flush_io(SDL_IOStream* context) @extern("SDL_FlushIO");

extern fn void* load_file_io(SDL_IOStream* src, usz* datasize, bool closeio) @extern("SDL_LoadFile_IO");

extern fn void* load_file(ZString file, usz* datasize) @extern("SDL_LoadFile");

extern fn bool save_file_io(SDL_IOStream* src, void* data, usz datasize, bool closeio) @extern("SDL_SaveFile_IO");

extern fn bool save_file(ZString file, void* data, usz datasize) @extern("SDL_SaveFile");

/* @{ */

extern fn bool read_u8(SDL_IOStream* src, char* value) @extern("SDL_ReadU8");

extern fn bool read_s8(SDL_IOStream* src, ichar* value) @extern("SDL_ReadS8");

extern fn bool read_u16le(SDL_IOStream* src, ushort* value) @extern("SDL_ReadU16LE");

extern fn bool read_s16le(SDL_IOStream* src, short* value) @extern("SDL_ReadS16LE");

extern fn bool read_u16be(SDL_IOStream* src, ushort* value) @extern("SDL_ReadU16BE");

extern fn bool read_s16be(SDL_IOStream* src, short* value) @extern("SDL_ReadS16BE");

extern fn bool read_u32le(SDL_IOStream* src, uint* value) @extern("SDL_ReadU32LE");

extern fn bool read_s32le(SDL_IOStream* src, int* value) @extern("SDL_ReadS32LE");

extern fn bool read_u32be(SDL_IOStream* src, uint* value) @extern("SDL_ReadU32BE");

extern fn bool read_s32be(SDL_IOStream* src, int* value) @extern("SDL_ReadS32BE");

extern fn bool read_u64le(SDL_IOStream* src, ulong* value) @extern("SDL_ReadU64LE");

extern fn bool read_s64le(SDL_IOStream* src, long* value) @extern("SDL_ReadS64LE");

extern fn bool read_u64be(SDL_IOStream* src, ulong* value) @extern("SDL_ReadU64BE");

extern fn bool read_s64be(SDL_IOStream* src, long* value) @extern("SDL_ReadS64BE");
/* @} *//* Read endian functions */

/* @{ */

extern fn bool write_u8(SDL_IOStream* dst, char value) @extern("SDL_WriteU8");

extern fn bool write_s8(SDL_IOStream* dst, ichar value) @extern("SDL_WriteS8");

extern fn bool write_u16le(SDL_IOStream* dst, ushort value) @extern("SDL_WriteU16LE");

extern fn bool write_s16le(SDL_IOStream* dst, short value) @extern("SDL_WriteS16LE");

extern fn bool write_u16be(SDL_IOStream* dst, ushort value) @extern("SDL_WriteU16BE");

extern fn bool write_s16be(SDL_IOStream* dst, short value) @extern("SDL_WriteS16BE");

extern fn bool write_u32le(SDL_IOStream* dst, uint value) @extern("SDL_WriteU32LE");

extern fn bool write_s32le(SDL_IOStream* dst, int value) @extern("SDL_WriteS32LE");

extern fn bool write_u32be(SDL_IOStream* dst, uint value) @extern("SDL_WriteU32BE");

extern fn bool write_s32be(SDL_IOStream* dst, int value) @extern("SDL_WriteS32BE");

extern fn bool write_u64le(SDL_IOStream* dst, ulong value) @extern("SDL_WriteU64LE");

extern fn bool write_s64le(SDL_IOStream* dst, long value) @extern("SDL_WriteS64LE");

extern fn bool write_u64be(SDL_IOStream* dst, ulong value) @extern("SDL_WriteU64BE");

extern fn bool write_s64be(SDL_IOStream* dst, long value) @extern("SDL_WriteS64BE");

/* @} *//* Write endian functions */

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_iostream_h_ */
