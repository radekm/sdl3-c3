module generator;

import std;

// Returned lines don't contain EOL.
fn String[] to_lines(char[] bytes)
{
    List{String} result;
    result.tinit(8192);

    usz pos;
    usz line_start;
    while (pos < bytes.len)
    {
        switch (bytes[pos])
        {
            case '\n':
                result.push((String)bytes[line_start : pos - line_start]);
                line_start = pos + 1;
            case '\r':
                result.push((String)bytes[line_start : pos - line_start]);

                // Consume optional '\n'.
                if (pos + 1 < bytes.len && bytes[pos + 1] == '\n') pos++;

                line_start = pos + 1;
        }
        pos++;
    }
    // Last line which has no EOL.
    if (line_start < pos)
    {
        result.push((String)bytes[line_start .. pos - 1]);
    }
    return result.array_view();
}

fn usz skip_comments(String[] lines, usz current_line)
{
    while (current_line < lines.len)
    {
        String line = lines[current_line];
        if (line == "/**")
        {
            while (true)
            {
                line = lines[++current_line];
                if (line == " */")
                {
                    current_line++;
                    break;
                }
            }
        }
        else if (line == "/*")
        {
            while (true)
            {
                line = lines[++current_line];
                if (line == "*/" || line == " */")
                {
                    current_line++;
                    break;
                }
            }
        }
        else
        {
            break;
        }
    }
    return current_line;
}

fn usz skip_comments_and_empty_lines(String[] lines, usz current_line)
{
    while (true)
    {
        usz initial_line = current_line;

        current_line = skip_comments(lines, current_line);

        // Skip empty lines.
        while (current_line < lines.len && lines[current_line] == "") current_line++;

        if (current_line == initial_line) break;
    }
    return current_line;
}

fn usz longest_prefix_of_enum_items(String enum_name, EnumLines* enum_lines)
{
    switch (enum_name)
    {
        // `SDL_BitmapOrder` contains items like `SDL_BITMAPORDER_4321`
        // where the removal of the longest common prefix leads to `4321`.
        // So we remove only `SDL_BITMAP`.
        case "SDL_BitmapOrder": return 10;
        // `SDL_PackedLayout` contains items like `SDL_PACKEDLAYOUT_332`,
        // so we remove only `SDL_PACKED` prefix.
        case "SDL_PackedLayout": return 10;
        // `SDL_GPUTextureType` contains items like `SDL_GPU_TEXTURETYPE_2D`,
        // so we remove only `SDL_GPU_TEXTURE`.
        case "SDL_GPUTextureType": return 15;
        // `SDL_GPUIndexElementSize` contains items like `SDL_GPU_INDEXELEMENTSIZE_16BIT`,
        // so we remove only `SDL_GPU_INDEXELEMENT`.
        case "SDL_GPUIndexElementSize": return 20;
        // `SDL_GPUSampleCount` contains items like `SDL_GPU_SAMPLECOUNT_1`,
        // so we remove only `SDL_GPU_SAMPLE`.
        case "SDL_GPUSampleCount": return 14;
    }

    String first_name;
    usz len;
    foreach (i, kind : enum_lines.kinds)
    {
        // We're only interested in enum items.
        if (kind != ITEM) continue;

        EnumItemLine item = enum_lines.lines[i].item;
        if (first_name == "")
        {
            first_name = item.name;
            len = first_name.len;
        }
        else
        {
            len = min(len, item.name.len);
            for (usz j; j < len; j++)
            {
                if (item.name[j] != first_name[j])
                {
                    len = j;
                    break;
                }
            }
        }
    }
    
    // No items.
    if (first_name == "")
    {
        return 0;
    }
    // Only one item.
    else if (len == first_name.len)
    {
        return first_name.starts_with("SDL_") ? 4 : 0;
    }
    // At least two items.
    // In this case we pick the longest prefix which ends with underscore.
    while (len > 0 && first_name[len - 1] != '_') len--;
    return len;
}

String[*] hidden_enums = {
    // `SDL_video.h`.
    "SDL_WindowFlags",
    "SDL_GLProfile",
    "SDL_GLContextFlag",
    "SDL_GLContextReleaseFlag",
    "SDL_GLContextResetNotification",

    // `SDL_gpu.h`.
    "SDL_GPUTextureUsageFlags",
    "SDL_GPUBufferUsageFlags",
    "SDL_GPUShaderFormat",
    "SDL_GPUColorComponentFlags",

    // `SDL_keycode.h`.
    "SDL_Keycode",
    "SDL_Keymod",

    // `SDL_blendmode.h`.
    "SDL_BlendMode",

    // `SDL_init.h`.
    "SDL_InitFlags",

    // `SDL_surface.h`.
    "SDL_SurfaceFlags",

    // `SDL_pen.h`.
    "SDL_PenInputFlags",

    // `SDL_mouse.h`.
    "SDL_MouseButtonFlags",
};

String[*] hidden_enums_prefixes = {
    // `SDL_video.h`.
    "SDL_WINDOW_",
    "SDL_GL_CONTEXT_PROFILE_",
    "SDL_GL_CONTEXT_",
    "SDL_GL_CONTEXT_RELEASE_",
    "SDL_GL_CONTEXT_RESET_",

    // `SDL_gpu.h`.
    "SDL_GPU_TEXTUREUSAGE_",
    "SDL_GPU_BUFFERUSAGE_",
    "SDL_GPU_SHADERFORMAT_",
    "SDL_GPU_COLORCOMPONENT_",

    // `SDL_keycode.h`.
    "SDLK_",
    "SDL_KMOD_",

    // `SDL_blendmode.h`.
    "SDL_BLENDMODE_",

    // `SDL_init.h`.
    "SDL_INIT_",

    // `SDL_surface.h`.
    "SDL_SURFACE_",

    // `SDL_pen.h`.
    "SDL_PEN_INPUT_",

    // `SDL_mouse.h`.
    "SDL_BUTTON_",
};

fn bool is_hidden_enum_with_defines(String line, String* hidden_enum_name, String* hidden_enum_prefix)
{
    if (!line.starts_with("typedef ") || !line.ends_with(";")) return false;
    line = line[..^2];  // Without semicolon.
    foreach (i, name : hidden_enums)
    {
        // Ensure that there's space before name (yes, there may be index out of bounds).
        if (line.ends_with(name) && line[^name.len + 1] == ' ')
        {
            *hidden_enum_name = name;
            *hidden_enum_prefix = hidden_enums_prefixes[i];
            return true;
        }
    }
    return false;
}

fn String nice_function_name(String function_name)
{
    if (function_name.starts_with("SDL_")) function_name = function_name[4..];

    DString result;
    result.tinit();

    foreach (i, c : function_name)
    {
        // GetNumGPUDrivers:
        //     GOOD   get_num_gpu_drivers
        //     WRONG  get_num_gpudrivers
        // SetWindowSurfaceVSync:
        //     GOOD   set_window_surface_vsync
        //     WRONG  set_window_surface_v_sync
        // SDL_GL_ResetAttributes
        //     GOOD   gl_reset_attributes
        //     WRONG  gl__reset_attributes
        if (c.is_upper() && i > 0)
        {
            bool last_lowercase = function_name[i - 1].is_lower();
            // If we use only last one then `SetWindowSurfaceVSync` becomes `set_window_surface_v_sync` which looks wrong.
            bool last_two_uppercase = i > 1 && function_name[i - 2].is_upper() && function_name[i - 1].is_upper();
            // Uppercase starts.
            if (last_lowercase)
            {
                result.append_char('_');
            }
            // Uppercase ends.
            else if (last_two_uppercase)
            {
                bool next_lowercase = i + 1 < function_name.len && function_name[i + 1].is_lower();
                if (next_lowercase) result.append_char('_');
            }
        }
        result.append_char(c.to_lower());
    }
    return result.str_view();
}

faultdef
    PARSING_FAILED,
    TYPE_TRANSLATION_FAILED;

struct Parsing
{
    String line;
    usz pos;
}

fn void? Parsing.str(&self, String str)
{
    if (!self.line[self.pos..].starts_with(str)) return PARSING_FAILED?;
    self.pos += str.len;
}

fn void Parsing.space(&self, String* out)
{
    usz start_pos = self.pos;
    usz pos = start_pos;
    while (pos < self.line.len)
    {
        if (self.line[pos] != ' ') break;
        pos++;
    }

    // `self.line[pos]` is not space. It either is a different character or it doesn't exist.
    *out = self.line[start_pos:pos-start_pos];
    self.pos = pos;
}

fn void Parsing.ignore_space(&self)
{
    String space;
    self.space(&space);
}

// At least one space.
fn void? Parsing.space1(&self, String* out)
{
    String result;
    self.space(&result);
    if (result.len == 0) return PARSING_FAILED?;
    *out = result;
}

fn void? Parsing.ignore_space1(&self)
{
    String space;
    self.space1(&space)!;
}

// Ident is never empty.
fn void? Parsing.ident(&self, String* out)
{
    usz start_pos = self.pos;
    usz pos = start_pos;

    if (pos >= self.line.len) return PARSING_FAILED?;

    char c = self.line[pos];
    if (c != '_' && !c.is_alpha()) return PARSING_FAILED?;
    pos++;

    while (pos < self.line.len)
    {
        c = self.line[pos];
        if (c != '_' && !c.is_alpha() && !c.is_digit()) break;
        pos++;
    }

    // `self.line[pos]` is not part of identifier.
    *out = self.line[start_pos:pos-start_pos];
    self.pos = pos;
}

// Supports hexadecimal numbers starting with `0x`.
fn void? Parsing.integer(&self, String* out)
{
    usz start_pos = self.pos;
    usz pos = start_pos;

    if (self.line[pos..].starts_with("-"))
    {
        pos += 1;
    }
    if (self.line[pos..].starts_with("0x"))
    {
        // Read hexadecimal number.
        pos += 2;

        while (pos < self.line.len)
        {
            char c = self.line[pos];
            if (!c.is_xdigit()) break;
            pos++;
        }
        // No digits read.
        if (pos == start_pos + 2) return PARSING_FAILED?;

    }
    else
    {
        // Read decimal or octal number.
        while (pos < self.line.len)
        {
            char c = self.line[pos];
            if (!c.is_digit()) break;
            pos++;
        }
        // No digits read.
        if (pos == start_pos) return PARSING_FAILED?;
    }

    // Try to read option `u` suffix for unsigned.
    if (pos < self.line.len && self.line[pos] == 'u')
    {
        pos++;
    }

    // `self.line[pos]` is not part of number.
    *out = self.line[start_pos:pos-start_pos];
    self.pos = pos;
}

fn void Parsing.rest(&self, String* out)
{
    *out = self.line[self.pos..];
    self.pos = self.line.len;
}

// Stops when either `delimiter` or end of string is reached.
fn void Parsing.rest_until_char(&self, char delimiter, String* out)
{
    usz start_pos = self.pos;
    usz pos = start_pos;
    while (pos < self.line.len)
    {
        if (self.line[pos] == delimiter) break;
        pos++;
    }

    // `self.line[pos]` is not part of `out`.
    *out = self.line[start_pos:pos-start_pos];
    self.pos = pos;
}

// Stops when either `delimiter` or end of string is reached.
fn void Parsing.rest_until_str(&self, String delimiter, String* out)
{
    usz start_pos = self.pos;
    usz pos = start_pos;
    while (pos < self.line.len)
    {
        if (self.line[pos..].starts_with(delimiter)) break;
        pos++;
    }

    // `self.line[pos]` is not part of `out`.
    *out = self.line[start_pos:pos-start_pos];
    self.pos = pos;
}

fn void? Parsing.ensure_eol(&self)
{
    if (self.pos < self.line.len) return PARSING_FAILED?;
}

struct Chooser
{
    Parsing* parsing;
    bool done;
}

macro void? Parsing.@choose(&self; @body(Chooser* ch))
{
    Chooser ch = { .parsing = self };
    @body(&ch);
    if (!ch.done) return PARSING_FAILED?;
}

macro void? Chooser.@variant(&self, #parse, ...)
{
    if (!self.done)
    {
        Parsing orig = *self.parsing;
        if (catch excuse = #parse(self.parsing, $vasplat))
        {
            if (excuse == PARSING_FAILED)
            {
                *self.parsing = orig;
            }
            else
            {
                return excuse?;
            }
        }
        else
        {
            self.done = true;
        }
    }
}

macro bool? Parsing.@optional(&self, #parse, ...)
{
    Parsing orig = *self;
    if (catch excuse = #parse(self, $vasplat))
    {
        if (excuse == PARSING_FAILED)
        {
            *self = orig;
            return false;
        }
        else
        {
            return excuse?;
        }
    }
    else
    {
        return true;
    }
}

fn void? parse_integer_define(String line, String* ident, String* space, String* value, String* rest)
{
    Parsing p = { .line = line };
    p.str("#define ")!;
    p.ident(ident)!;
    p.space1(space)!;
    if (try p.str("SDL_UINT64_C("))
    {
        p.integer(value)!;
        p.str(")")!;
    }
    else if (try p.str("("))
    {
        p.rest_until_char(')', value);
        p.str(")")!;
    }
    else
    {
        p.integer(value)!;
    }
    p.rest(rest);
}

fn String? translate_type_ident(String ident)
{
    String result;
    switch (ident)
    {
        case "bool":
            // Or should we return `CBool`?
            result = "bool";
        case "Uint8":
            result = "char";
        case "Sint16":
            result = "short";
        case "Uint16":
            result = "ushort";
        case "Sint32":
            result = "int";
        case "Uint32":
            result = "uint";
        case "Sint64":
            result = "long";
        case "Uint64":
            result = "ulong";
        case "int":
            result = "CInt";
        case "float":
            result = "float";
        case "void":
            result = "void";
        case "ptrdiff_t":
            result = "isz";
        case "size_t":
            result = "usz";
        case "intptr_t":
            result = "iptr";
        case "uintptr_t":
            result = "uptr";
        // Struct names may not be all uppercase.
        case "SDL_GUID":
            result = "SDL_Guid";
        default:
            if (ident.starts_with("SDL_")) result = ident;
    }
    if (result == "") return TYPE_TRANSLATION_FAILED?;
    return result;
}

fn void? Parsing.parse_and_translate_type(&self, String* translated)
{
    self.@choose(; ch)
    {
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String space;
            p.str("const char * const *")!;
            p.space(&space);
            *translated = "ZString*";
        }, translated)!;
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String space;
            p.str("const char **")!;
            p.space(&space);
            *translated = "ZString*";
        }, translated)!;
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String space;
            p.str("const char *")!;
            p.space(&space);
            *translated = "ZString";
        }, translated)!;
        // Pointer to char.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String space;
            p.str("char *")!;
            p.space(&space);
            *translated = "char*";

        }, translated)!;
        // Pointer to constant pointer to constant type.
        // For example `const void * const *channel_buffers`.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String ident;
            String space;
            p.str("const")!;
            p.space1(&space)!;
            p.ident(&ident)!;
            p.space(&space);
            p.str("*")!;
            p.space(&space);
            p.str("const")!;
            p.space(&space);
            p.str("*")!;
            p.space(&space);
            String translated_ident = translate_type_ident(ident)!;
            *translated = string::tformat("%s**", translated_ident);
        }, translated)!;
        // Pointer to constant value.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String ident;
            String space;
            p.str("const")!;
            p.space1(&space)!;
            p.ident(&ident)!;
            p.space(&space);
            p.str("*")!;
            p.space(&space);
            String translated_ident = translate_type_ident(ident)!;
            *translated = string::tformat("%s*", translated_ident);
        }, translated)!;
        // Pointer to constant pointer to type.
        // For example `SDL_GPUBuffer *const *storage_buffers`.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String ident;
            String space;
            p.ident(&ident)!;
            p.space(&space);
            p.str("*")!;
            p.space(&space);
            p.str("const")!;
            p.space(&space);
            p.str("*")!;
            p.space(&space);
            String translated_ident = translate_type_ident(ident)!;
            *translated = string::tformat("%s**", translated_ident);
        }, translated)!;
        // Pointer to pointer to type.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String ident;
            String space;
            p.ident(&ident)!;
            p.space(&space);
            p.str("**")!;
            p.space(&space);
            String translated_ident = translate_type_ident(ident)!;
            *translated = string::tformat("%s**", translated_ident);
        }, translated)!;
        // Pointer to type.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String ident;
            String space;
            p.ident(&ident)!;
            p.space(&space);
            p.str("*")!;
            p.space(&space);
            String translated_ident = translate_type_ident(ident)!;
            *translated = string::tformat("%s*", translated_ident);
        }, translated)!;
        // Just ident.
        ch.@variant(fn void?(Parsing* p, String* translated)
        {
            String ident;
            String space;
            p.ident(&ident)!;
            p.space(&space);
            String translated_ident = translate_type_ident(ident)!;
            *translated = translated_ident;
        }, translated)!;
    }!;
}

struct UnparsableLine
{
    String line;
}

// chci whitespace or comment
struct VerbatimLine
{
    String line;
}

struct EnumItemLine
{
    String name;
    String value;  // Empty if no value.
    // This comment may not be closed.
    // So it may continue on `VERBATIM` lines after the item.
    String comment_starting_after_item;
}

enum EnumLineKind
{
    UNPARSABLE,
    VERBATIM,
    ITEM,
}

union EnumLine
{
    UnparsableLine unparsable;
    VerbatimLine verbatim;
    EnumItemLine item;
}

struct EnumLines
{
    EnumLineKind[] kinds;
    EnumLine[] lines;
}

enum EnumParserMode
{
    NORMAL,
    IN_COMMENT,
    IN_IF,
}

<*
 @param [&inout] i
*>
fn EnumLines? parse_enum_items(String[] lines, usz* i)
{
    List{EnumLineKind} enum_line_kinds;
    enum_line_kinds.tinit(128);
    List{EnumLine} enum_lines;
    enum_lines.tinit(128);
    EnumParserMode mode;
    while PROCESS_LINE: (true)
    {
        Parsing p = { .line = lines[*i] };

        switch (mode)
        {
            case NORMAL:
                // End of enum (only in normal mode).
                if (p.line.starts_with("}")) break PROCESS_LINE;

                bool comment_starts;
                bool if_starts;
                p.@choose(; ch)
                {
                    // Line with enum item.
                    ch.@variant(fn void?(Parsing* p, List{EnumLineKind}* enum_line_kinds, List{EnumLine}* enum_lines, bool *out_comment_starts)
                    {
                        String name;
                        p.ignore_space();
                        p.ident(&name)!;
                        p.ignore_space();

                        String value;
                        p.@optional(fn void?(Parsing* p, String* out_value)
                        {
                            usz start_pos = p.pos;
                            p.str("=")!;
                            p.ignore_space();
                            p.@choose(; ch)
                            {
                                ch.@variant(fn void?(Parsing* p, String* out_value)
                                {
                                    p.integer(out_value)!;
                                }, out_value)!;
                                ch.@variant(fn void?(Parsing* p, String* out_value)
                                {
                                    p.ident(out_value)!;
                                }, out_value)!;
                                // Or of two identifiers.
                                ch.@variant(fn void?(Parsing* p, String* out_value)
                                {
                                    p.str("(")!;
                                    p.ignore_space();
                                    usz start_pos = p.pos;
                                    String ident;
                                    p.ident(&ident)!;
                                    p.ignore_space();
                                    p.str("|")!;
                                    p.ignore_space();
                                    p.ident(&ident)!;
                                    usz end_pos = p.pos;
                                    p.ignore_space();
                                    p.str(")")!;
                                    *out_value = p.line[start_pos:end_pos-start_pos];
                                }, out_value)!;
                            }!;
                            p.ignore_space();
                        }, &value)!;

                        // Read optional comma.
                        p.@optional(fn void?(Parsing* p)
                        {
                            p.str(",")!;
                            p.ignore_space();
                        })!;


                        String comment;
                        bool comment_starts;
                        p.@optional(fn void?(Parsing* p, String* out_comment, bool* out_comment_starts)
                        {
                            usz start_pos = p.pos;
                            String rest;
                            p.str("/*")!;
                            p.rest_until_str("*/", &rest);
                            *out_comment_starts = !@ok(p.str("*/"));
                            *out_comment = p.line[start_pos:p.pos-start_pos];
                        }, &comment, &comment_starts)!;

                        p.ignore_space();
                        p.ensure_eol()!;

                        *out_comment_starts = comment_starts;
                        enum_line_kinds.push(ITEM);
                        enum_lines.push({ .item = { .name = name, .value = value, .comment_starting_after_item = comment } });

                    }, &enum_line_kinds, &enum_lines, &comment_starts)!;
                    // Line with comment or empty line.
                    ch.@variant(fn void?(Parsing* p, List{EnumLineKind}* enum_line_kinds, List{EnumLine}* enum_lines, bool *out_comment_starts)
                    {
                        // We don't write to `out_comment_starts` until the whole line has been successfully parsed.
                        bool comment_starts;
                        p.ignore_space();
                        p.@optional(fn void?(Parsing* p, bool* out_comment_starts)
                        {
                            String rest;
                            p.str("/*")!;
                            p.rest_until_str("*/", &rest);
                            *out_comment_starts = !@ok(p.str("*/"));
                        }, &comment_starts)!;

                        p.ensure_eol()!;

                        *out_comment_starts = comment_starts;
                        enum_line_kinds.push(VERBATIM);
                        enum_lines.push({ .verbatim = { .line = p.line } });

                    }, &enum_line_kinds, &enum_lines, &comment_starts)!;
                    // Line with `#if`.
                    ch.@variant(fn void?(Parsing* p, List{EnumLineKind}* enum_line_kinds, List{EnumLine}* enum_lines, bool *out_if_starts)
                    {
                        p.ignore_space();
                        p.str("#if")!;
                        p.ignore_space1()!;

                        *out_if_starts = true;
                        enum_line_kinds.push(UNPARSABLE);
                        enum_lines.push({ .unparsable = { .line = p.line } });

                    }, &enum_line_kinds, &enum_lines, &if_starts)!;
                }!;
                if (comment_starts) mode = IN_COMMENT;
                if (if_starts) mode = IN_IF;
            case IN_COMMENT:
                String rest;
                p.rest_until_str("*/", &rest);
                if(@ok(p.str("*/"))) mode = NORMAL;
                p.ensure_eol()!;

                enum_line_kinds.push(VERBATIM);
                enum_lines.push({ .verbatim = { .line = p.line } });
            case IN_IF:
                String rest;
                p.rest_until_str("#endif", &rest);
                if(@ok(p.str("#endif"))) mode = NORMAL;

                enum_line_kinds.push(UNPARSABLE);
                enum_lines.push({ .unparsable = { .line = p.line } });
        }
        (*i)++;
    }
    EnumLines result = { .kinds = enum_line_kinds.array_view(), .lines = enum_lines.array_view() };
    return result;
}

struct StructFieldLine
{
    String type;
    String name;
    // This comment may not be closed.
    // So it may continue on `VERBATIM` lines after the field.
    String comment_starting_after_field;
}

enum StructLineKind
{
    UNPARSABLE,
    VERBATIM,
    ITEM,
}

union StructLine
{
    UnparsableLine unparsable;
    VerbatimLine verbatim;
    StructFieldLine field;
}

struct StructLines
{
    StructLineKind[] kinds;
    StructLine[] lines;
}

enum StructParserMode
{
    NORMAL,
    IN_COMMENT,
}

fn StructLines? parse_struct_or_union_fields(String[] lines, usz* i)
{
    List{StructLineKind} struct_line_kinds;
    struct_line_kinds.tinit(128);
    List{StructLine} struct_lines;
    struct_lines.tinit(128);
    StructParserMode mode;
    while PROCESS_LINE: (true)
    {
        Parsing p = { .line = lines[*i] };

        switch (mode)
        {
            case NORMAL:
                // End of struct (only in normal mode).
                if (p.line.starts_with("}")) break PROCESS_LINE;

                bool comment_starts;
                p.@choose(; ch)
                {
                    // Line with struct field.
                    ch.@variant(fn void?(Parsing* p, List{StructLineKind}* struct_line_kinds, List{StructLine}* struct_lines, bool *out_comment_starts)
                    {
                        String type;
                        String name;
                        p.ignore_space();
                        // Consumes spaces after the type so it must not be followed by `ignore_space1`.
                        p.parse_and_translate_type(&type)!;
                        p.ident(&name)!;

                        // Struct field is array.
                        // Read array size and add it into `name`.
                        if (try p.str("["))
                        {
                            String array_size;
                            p.rest_until_char(']', &array_size);
                            p.str("]")!;
                            type = string::tformat("%s[%s]", type, array_size);
                        }
                        p.str(";")!;

                        p.ignore_space();

                        String comment;
                        bool comment_starts;
                        p.@optional(fn void?(Parsing* p, String* out_comment, bool* out_comment_starts)
                        {
                            usz start_pos = p.pos;
                            String rest;
                            p.str("/*")!;
                            p.rest_until_str("*/", &rest);
                            *out_comment_starts = !@ok(p.str("*/"));
                            *out_comment = p.line[start_pos:p.pos-start_pos];
                        }, &comment, &comment_starts)!;

                        p.ignore_space();
                        p.ensure_eol()!;

                        *out_comment_starts = comment_starts;
                        struct_line_kinds.push(ITEM);
                        struct_lines.push({ .field = { .type = type, .name = name, .comment_starting_after_field = comment } });

                    }, &struct_line_kinds, &struct_lines, &comment_starts)!;
                    // Line with comment or empty line.
                    ch.@variant(fn void?(Parsing* p, List{StructLineKind}* struct_line_kinds, List{StructLine}* struct_lines, bool *out_comment_starts)
                    {
                        // We don't write to `out_comment_starts` until the whole line has been successfully parsed.
                        bool comment_starts;
                        p.ignore_space();
                        p.@optional(fn void?(Parsing* p, bool* out_comment_starts)
                        {
                            String rest;
                            p.str("/*")!;
                            p.rest_until_str("*/", &rest);
                            *out_comment_starts = !@ok(p.str("*/"));
                        }, &comment_starts)!;

                        p.ensure_eol()!;

                        *out_comment_starts = comment_starts;
                        struct_line_kinds.push(VERBATIM);
                        struct_lines.push({ .verbatim = { .line = p.line } });

                    }, &struct_line_kinds, &struct_lines, &comment_starts)!;
                    // Line with field with function pointer.
                    ch.@variant(fn void?(Parsing* p,  List{StructLineKind}* struct_line_kinds, List{StructLine}* struct_lines)
                    {
                        String translated;
                        p.ignore_space1()!;
                        p.parse_and_translate_type(&translated)!;
                        p.str("(SDLCALL *")!;

                        struct_line_kinds.push(UNPARSABLE);
                        struct_lines.push({ .unparsable = { .line = p.line } });

                    }, &struct_line_kinds, &struct_lines)!;
                }!;
                if (comment_starts) mode = IN_COMMENT;
            case IN_COMMENT:
                String rest;
                p.rest_until_str("*/", &rest);
                if(@ok(p.str("*/"))) mode = NORMAL;
                p.ensure_eol()!;

                struct_line_kinds.push(VERBATIM);
                struct_lines.push({ .verbatim = { .line = p.line } });
        }
        (*i)++;
    }
    StructLines result = { .kinds = struct_line_kinds.array_view(), .lines = struct_lines.array_view() };
    return result;
}

fn void? parse_and_translate_typedef(String line, String* translated_type, String* name)
{
    Parsing p = { .line = line };
    p.str("typedef ")!;
    p.parse_and_translate_type(translated_type)!;
    p.ident(name)!;
    String rest;
    p.rest(&rest);
    if (rest != ";") return PARSING_FAILED?;
}

// For example `typedef struct SDL_GPUDevice SDL_GPUDevice;`.
fn void? parse_opaque_type(String line, String* name)
{
    Parsing p = { .line = line };
    String ident;
    String ident2;
    if (try p.str("typedef struct ") && try p.ident(&ident) && try p.str(" ") && try p.ident(&ident2) && try p.str(";"))
    {
        if (ident == ident2)
        {
            *name = ident;
            return;
        }
    }
    return PARSING_FAILED?;
}

fn void? generate(String input_file)
{
    char[] bytes = file::load_temp(input_file)!;
    String[] lines = to_lines(bytes);

    io::printfn("module sdl;");

    usz i;
    while (i < lines.len)
    {
        i = skip_comments(lines, i);
        String line = lines[i];
        String hidden_enum_name;
        String hidden_enum_prefix;
        String typedef_translated_type;
        String typedef_name;
        String opaque_type_name;
        // Single-line comment.
        if (line.starts_with("/*") && line.ends_with("*/"))
        {
            io::printfn("%s", line);
            i++;
        }
        else if (line.starts_with("#include <"))
        {
            // Skip.
            i++;
        }
        else if (line == "")
        {
            io::printfn("");
            i++;
        }
        // `typedef` followed by several define #define whose name starts with `hidden_enum_prefix`.
        else if (is_hidden_enum_with_defines(line, &hidden_enum_name, &hidden_enum_prefix))
        {
            String underlying_type;
            switch {
                case line.starts_with("typedef Uint64"):
                    underlying_type = "ulong";
                case line.starts_with("typedef Uint32"):
                    underlying_type = "uint";
                case line.starts_with("typedef Uint16"):
                    underlying_type = "ushort";
                case line.starts_with("typedef Uint8"):
                    underlying_type = "char";
                default:
                    abort("Unknown underlying type of hidden enum: %s", line);
            }
            io::printfn("enum %s : const %s", hidden_enum_name, underlying_type);
            io::printfn("{");

            usz line_before_skip = ++i;
            i = skip_comments_and_empty_lines(lines, i);
            while (i < lines.len)
            {
                line = lines[i];
                String ident;
                String space;
                String value;
                String rest;
                if (catch parse_integer_define(line, &ident, &space, &value, &rest)) break;
                if (!ident.starts_with(hidden_enum_prefix)) break;
                io::printfn("    %s%s = %s,%s", ident[hidden_enum_prefix.len..], space, value, rest);
                line_before_skip = ++i;
                i = skip_comments_and_empty_lines(lines, i);
            }
            // Unskip empty lines and comments after the last item.
            i = line_before_skip;

            io::printfn("}");
        }
        else if (try parse_and_translate_typedef(line, &typedef_translated_type, &typedef_name))
        {
            // Define as distinct type.
            io::printfn("typedef %s = %s;", typedef_name, typedef_translated_type);
            i++;
        }
        else if (try parse_opaque_type(line, &opaque_type_name))
        {
            io::printfn("typedef %s = void;", opaque_type_name);
            i++;
        }
        else if (line.starts_with("typedef enum ") && !line.ends_with(";"))
        {
            String enum_name = line[13 ..];
            io::printfn("enum %s : const CInt", enum_name);
            line = lines[++i];
            if (line != "{") abort("Expected { which opens enum, got: '%s'", line);
            io::printfn("{");

            // Read enum items.
            i++;
            EnumLines? enum_lines = parse_enum_items(lines, &i);
            if (catch excuse = enum_lines)
            {
                abort("Parsing enum items failed on line %d: '%s'", i, lines[i]);
            }

            // Drop the longest common prefix of item names.
            usz common_prefix = longest_prefix_of_enum_items(enum_name, &enum_lines);
            foreach (j, kind : enum_lines.kinds)
            {
                EnumLine enum_line = enum_lines.lines[j];
                switch (kind)
                {
                    case UNPARSABLE:
                        // Line which couldn't be translated.
                        io::printfn("::LINE:: %s", enum_line.unparsable.line);
                    case VERBATIM:
                        io::printfn("%s", enum_line.verbatim.line);
                    case ITEM:
                        EnumItemLine item = enum_line.item;
                        io::printf("    %s", item.name[common_prefix..].to_upper_tcopy());
                        if (item.value != "") io::printf(" = %s", item.value);
                        io::printf(",");
                        if (item.comment_starting_after_item != "") io::printf("  %s", item.comment_starting_after_item);
                        io::printfn("");
                }
            }

            line = lines[i];
            if (!line.starts_with("}")) abort("Expected } which closes enum, got: '%s'", line);
            io::printfn("}");
            i++;
        }
        // We skip `SDL_Rect` because it contains multiple fields defined on a single line.
        else if ((line.starts_with("typedef struct ") || line.starts_with("typedef union ")) && !line.ends_with(";") && line != "typedef struct SDL_Rect")
        {
            if (line.starts_with("typedef struct "))
            {
                String struct_name = line[15 ..];
                io::printfn("struct %s", struct_name);
            }
            else
            {
                String union_name = line[14 ..];
                io::printfn("union %s", union_name);
            }
            line = lines[++i];
            if (line != "{") abort("Expected { which opens struct or union, got: '%s'", line);
            io::printfn("{");

            // Read struct or union fields.
            i++;
            StructLines? struct_lines = parse_struct_or_union_fields(lines, &i);
            if (catch excuse = struct_lines)
            {
                abort("Parsing struct or union fields failed on line %d: '%s'", i, lines[i]);
            }

            foreach (j, kind : struct_lines.kinds)
            {
                StructLine struct_line = struct_lines.lines[j];
                switch (kind)
                {
                    case UNPARSABLE:
                        // Line which couldn't be translated.
                        io::printfn("::LINE:: %s", struct_line.unparsable.line);
                    case VERBATIM:
                        io::printfn("%s", struct_line.verbatim.line);
                    case ITEM:
                        StructFieldLine field = struct_line.field;
                        io::printf("    %s %s;", field.type, field.name);
                        if (field.comment_starting_after_field != "") io::printf("  %s", field.comment_starting_after_field);
                        io::printfn("");
                }
            }

            line = lines[i];
            if (!line.starts_with("}")) abort("Expected } which closes struct or union, got: '%s'", line);
            io::printfn("}");
            i++;  // Skip line with closing brace.
        }
        // String constant.
        else if (line.starts_with("#define ") && line.ends_with("\""))
        {
            usz name_start = 8;
            usz name_len = line[name_start..].index_of_char(' ')!!;
            String name = line[name_start:name_len];
            usz space_start = name_start + name_len;
            usz space_len = line[space_start..].index_of_char('\"')!!;
            String space = line[space_start:space_len];
            String value = line[space_start+space_len..];
            if (name.starts_with("SDL_")) name = name[4..];
            io::printfn("const %s%s = %s;", name, space, value);
            i++;
        }
        // Exported function.
        else if (line.starts_with("extern SDL_DECLSPEC ") && !line.contains(" SDL_PRINTF_VARARG_FUNC") && !line.contains(" SDL_ACQUIRE(") && !line.contains(" SDL_RELEASE("))
        {
            usz return_type_end = line.index_of("SDLCALL ")!!;
            String return_type = line[20..return_type_end-1];
            String translated_return_type;
            Parsing return_type_parsing = { .line = return_type };
            return_type_parsing.parse_and_translate_type(&translated_return_type)!;
            if (return_type_parsing.pos != return_type.len)
            {
                abort("Translation '%s' of return type '%s' is incomplete", translated_return_type, return_type);
            }
            usz function_name_start = return_type_end + 8;
            usz function_name_len = line[function_name_start..].index_of_char('(')!!;
            String function_name = line[function_name_start:function_name_len];
            // Without opening paren (it may include closing paren and semicolon).
            String params = line[function_name_start+function_name_len+1..];

            String before_params = string::tformat("extern fn %s %s(", translated_return_type, nice_function_name(function_name));
            io::printf("%s", before_params);
            if (params == "void);")
            {
                // No params.
            }
            else
            {
                // Translate params.
                // They may be on multiple lines.
                // Each line except the first line may contain one or more params.
                usz params_indent = before_params.len;
                Parsing p = { .line = params };

                // No params on the first line.
                if (params == "")
                {
                    params_indent = 4;
                    // Go to the next line.
                    io::printfn("");
                    p.line = lines[++i];
                    p.pos = 0;
                    String space;
                    p.space(&space);  // Skip spaces at the beginning.
                    // Insert correct indentation.
                    io::printf("    ");
                }

                while PARAM: (true)
                {
                    String translated_param_type;
                    String param_name;
                    p.parse_and_translate_type(&translated_param_type)!;
                    p.ident(&param_name)!;
                    io::printf("%s %s", translated_param_type, param_name);

                    switch (p.line[p.pos..])
                    {
                        // All parameters have been processed.
                        case ");":
                            break PARAM;  // Without label it breaks from `switch`.
                        // Last parameter on the current line.
                        case ",":
                            io::printfn(",");
                            p.line = lines[++i];
                            p.pos = 0;
                            String space;
                            p.space(&space);  // Skip spaces at the beginning.
                            // Insert correct indentation.
                            usz spaces_to_add = params_indent;
                            while (spaces_to_add--)
                            {
                                io::printf(" ");
                            }
                        // There must be another parameter.
                        default:
                            p.str(",")!;
                            String space;
                            p.space(&space);
                            io::printf(", ");
                    }
                }
            }
            io::printfn(") @extern(\"%s\");", function_name);

            i++;
        }
        else
        {
            // Line which couldn't be translated.
            io::printfn("::LINE:: %s", line);
            i++;
        }
    }
}

fn void main(String[] args)
{
    generate(args[1])!!;
}
