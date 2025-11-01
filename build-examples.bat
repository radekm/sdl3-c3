@echo off
set "SCRIPT_DIR=%~dp0"

pushd "%SCRIPT_DIR%"
if not exist build mkdir build
cd build

REM We use compile-only because compile on Windows currently doesn't work.
REM Problem is that compile passes /NOENTRY to linker which is wrong.
REM We only want to pass --no-entry to C3 compiler because there's no entry
REM in C3 code but there's entry in sdl.c3l/c/main.c.
REM It works on macOS and Linux.
REM
REM --single-module=yes is just used to simplify linker invocation.
c3c compile-only --no-entry --libdir .. --lib sdl --single-module=yes ..\examples\let-there-be-triangles\main.c3
link obj\windows-x64\main.obj obj\windows-x64\sdl\main.obj %* dbghelp.lib /SUBSYSTEM:WINDOWS /OUT:let-there-be-triangles.exe

c3c compile-only --no-entry --libdir .. --lib sdl --single-module=yes ..\examples\spydog\common.c3 ..\examples\spydog\clear_screen.c3
link obj\windows-x64\main.obj obj\windows-x64\sdl\main.obj %* dbghelp.lib /SUBSYSTEM:WINDOWS /OUT:clear-screen.exe

c3c compile-only --no-entry --libdir .. --lib sdl --single-module=yes ..\examples\spydog\common.c3 ..\examples\spydog\clear_screen_multi_window.c3
link obj\windows-x64\main.obj obj\windows-x64\sdl\main.obj %* dbghelp.lib /SUBSYSTEM:WINDOWS /OUT:clear-screen-multi-window.exe

c3c compile-only --no-entry --libdir .. --lib sdl --single-module=yes ..\examples\spydog\common.c3 ..\examples\spydog\basic_triangle.c3
link obj\windows-x64\main.obj obj\windows-x64\sdl\main.obj %* dbghelp.lib /SUBSYSTEM:WINDOWS /OUT:basic-triangle.exe

c3c compile-only --no-entry --libdir .. --lib sdl --single-module=yes ..\examples\spydog\common.c3 ..\examples\spydog\basic_stencil.c3
link obj\windows-x64\main.obj obj\windows-x64\sdl\main.obj %* dbghelp.lib /SUBSYSTEM:WINDOWS /OUT:basic-stencil.exe

popd
