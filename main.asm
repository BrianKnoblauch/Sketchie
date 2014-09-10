.686
.model flat, stdcall 

include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib 

.data 
    
.code
start:
    invoke  ExitProcess, 0
    
end start