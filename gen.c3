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
                if (line == "*/")
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

fn usz longest_prefix_of_enum_items(String[] names)
{
    if (names.len >= 2)
    {
        String first_name = names[0];
        usz len = first_name.len;
        for (usz i = 1; i < names.len; i++)
        {
            String name = names[i];
            len = min(len, name.len);
            for (usz j; j < len; j++)
            {
                if (name[j] != first_name[j])
                {
                    len = j;
                    break;
                }
            }
        }
        return len;
    }
    else if (names.len == 1)
    {
        String first_name = names[0];
        if (first_name.starts_with("SDL_")) return 4;
    }
    return 0;
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
    "SDL_KMOD_"
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

    bool last_lowercase;
    foreach (c : function_name)
    {
        if (c.is_upper())
        {
            if (last_lowercase) result.append_char('_');
        }
        last_lowercase = c.is_lower();
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

// At least one space.
fn void? Parsing.space1(&self, String* out)
{
    String result;
    self.space(&result);
    if (result.len == 0) return PARSING_FAILED?;
    *out = result;
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

    if (self.line[start_pos..].starts_with("0x"))
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
fn void? Parsing.rest_until(&self, char delimiter, String* out)
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
        p.rest_until(')', value)!;
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
fn bool is_useless_typedef(String line)
{
    Parsing p = { .line = line };
    String ident;
    String ident2;
    if (try p.str("typedef struct ") && try p.ident(&ident) && try p.str(" ") && try p.ident(&ident2) && try p.str(";"))
    {
        return ident == ident2;
    }
    return false;
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
        else if (is_useless_typedef(line))
        {
            // Skip typedefs which are not necessary in C3.
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
            line = lines[++i];
            List{String[]} lines_above_items;  // Lines above items usually with comments or empty.
            lines_above_items.tinit(128);
            List{String} names;
            names.tinit(128);
            List{String} rests;
            rests.tinit(128);
            List{String[]} lines_below_items;  // Lines below items where comments from `rests` continue.
            lines_below_items.tinit(128);
            while (!line.starts_with("}"))
            {
                // Save lines with comments or empty lines.
                usz first_line = i;
                while (true)
                {
                    // Empty line.
                    if (lines[i] == "")
                    {
                        i++;
                    }
                    // Single-line comment.
                    else if (lines[i].starts_with("    /*") && lines[i].ends_with("*/"))
                    {
                        i++;
                    }
                    else
                    {
                        break;
                    }
                }
                lines_above_items.push(lines[first_line:i-first_line]);
                line = lines[i];

                if (!line.starts_with("    ")) abort("Expected four spaces before each enum item, got: '%s'", line);
                // We assume that that are exactly four spaces at the beginning (not more).
                usz name_start = 4;
                usz name_len = line[name_start..].index_of_chars({' ', ','}) ?? line.len - name_start;
                String name = line[name_start:name_len];
                String rest = line[name_start+name_len..];
                names.push(name);
                rests.push(rest);
                // Comment starts in `rest` but doesn't end on current line.
                // We have to read lines below.
                first_line = i + 1;
                String[] lines_below_item;
                if (rest.contains("/*") && !rest.ends_with("*/"))
                {
                    while (!lines[++i].ends_with("*/")) {}
                }
                // Save empty lines after the item.
                while (lines[++i] == "") {}
                lines_below_item = lines[first_line:i-first_line];
                lines_below_items.push(lines_below_item);
                line = lines[i];
            }

            // Drop the longest common prefix of item names.
            usz common_prefix = longest_prefix_of_enum_items(names.array_view());
            foreach (j, name : names)
            {
                String[] lines_above_item = lines_above_items[j];
                String[] lines_below_item = lines_below_items[j];
                String rest = rests[j];
                foreach (l : lines_above_item)
                {
                    io::printfn("%s", l);
                }
                io::printfn("    %s%s", name[common_prefix..], rest);
                foreach (l : lines_below_item)
                {
                    // We drop `common_prefix` chars from non-empty lines hoping that these are spaces.
                    // We're doing this to preserve indent.
                    if (l != "") l = l[common_prefix..];
                    io::printfn("%s", l);
                }
            }

            io::printfn("}");
            i++;
        }
        else if (line.starts_with("typedef struct ") && !line.ends_with(";"))
        {
            String struct_name = line[15 ..];
            io::printfn("struct %s", struct_name);
            line = lines[++i];
            if (line != "{") abort("Expected { which opens struct, got: '%s'", line);
            io::printfn("{");

            // Read struct fields.
            line = lines[++i];
            List{String} translated_types;
            translated_types.tinit(128);
            // How much has type length increased. If negative then new type length is shorter.
            List{isz} type_len_differences;  // `c3_type_len` - `c_type_len`.
            type_len_differences.tinit(128);
            List{String} names;
            names.tinit(128);
            List{String} rests;
            rests.tinit(128);
            List{String[]} lines_below_fields;  // Lines below fields where comments from `rests` continue.
            lines_below_fields.tinit(128);
            isz max_len_difference;
            while (!line.starts_with("}"))
            {
                // We assume that that are exactly four spaces at the beginning (not more).
                if (!line.starts_with("    ")) abort("Expected four spaces before each struct field, got: '%s'", line);

                String translated_type;
                String name;
                String rest;
                Parsing p = { .line = line, .pos = 4 };
                p.parse_and_translate_type(&translated_type)!;
                usz pos = p.pos;
                isz c_type_len = pos - 4;  // Including the space after it (if there was any).
                isz c3_type_len = translated_type.len + 1;  // `+ 1` is for the space after it.
                isz type_len_difference = c3_type_len - c_type_len;
                p.ident(&name)!;

                // Struct field is array.
                // Read array size and add it into `name`.
                if (try p.str("["))
                {
                    String array_size;
                    p.rest_until(']', &array_size)!;
                    p.str("]")!;
                    name = line[pos:p.pos-pos];
                }

                p.str(";")!;
                p.rest(&rest);

                translated_types.push(translated_type);
                type_len_differences.push(type_len_difference);
                names.push(name);
                rests.push(rest);
                max_len_difference = max(max_len_difference, type_len_difference);

                usz first_line = i + 1;
                String[] lines_below_field;
                // Comment starts in `rest` but doesn't end on current line.
                // We have to read lines below.
                if (rest.contains("/*") && !rest.ends_with("*/"))
                {
                    while (!lines[++i].ends_with("*/")) {}
                }
                // Save empty lines after the field.
                while (lines[++i] == "") {}
                lines_below_field = lines[first_line:i-first_line];
                lines_below_fields.push(lines_below_field);
                line = lines[i];
            }

            foreach (j, translated_type : translated_types)
            {
                isz type_len_difference = type_len_differences[j];
                String name = names[j];
                String rest = rests[j];
                String[] lines_below_field = lines_below_fields[j];
                io::printf("    %s %s;", translated_type, name);
                // Ensure that rest has same alignment even if translated types have different lengths.
                if (rest.len > 0)
                {
                    isz spaces_to_add = max_len_difference - type_len_difference;
                    while (spaces_to_add-- > 0)
                    {
                        io::printf(" ");
                    }
                }
                io::printfn("%s", rest);
                foreach (l : lines_below_field)
                {
                    // Add spaces to preserve alignment.
                    isz spaces_to_add = max_len_difference;
                    while (spaces_to_add-- > 0)
                    {
                        io::printf(" ");
                    }

                    io::printfn("%s", l);
                }
            }

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
        else if (line.starts_with("extern SDL_DECLSPEC "))
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
