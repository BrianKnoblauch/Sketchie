@echo off
echo ...Assembling...
c:\masm32\bin\ml.exe /c /coff /Cp main.asm
if ERRORLEVEL 1 GOTO assemblyerror
echo ...Linking...
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /LIBPATH:c:\masm32\lib main.obj /OUT:dist\main.exe
if ERRORLEVEL 1 GOTO linkererror
echo ...Cleaning...
del *.obj
GOTO End
:assemblyerror
echo ...Assembly error...
GOTO End
:linkererror
echo ...Linker error...
GOTO End
:End
