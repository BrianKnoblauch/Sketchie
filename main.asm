.686
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\windows.inc 
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\user32.lib

.data 
    about_caption   db  "About ProjectCQB...",0
    about_message   db  "In a world of conflict, few natural resources, and little energy, what's old is new again...",13,13,10,
                        "Version 1.0 Alpha",0
    
.code
start:
    call    about
    invoke  ExitProcess, 0

about   PROC
    invoke  MessageBox, NULL, offset about_message, offset about_caption, MB_OK
    ret
about   ENDP
    
end start