.686
option casemap:none

include \masm32\include\masm32rt.inc

WndProc PROTO :HWND,:UINT,:WPARAM,:LPARAM
wmPaint PROTO :HWND

IDI_ICON    EQU 501
CREF_PIXEL EQU 0 ;0 = black

.data 
    about_caption   db  "About ProjectCQB...",0
    about_message   db  "In a world of conflict, few natural resources, and little energy, what's old is new again...",13,13,10,
                        "Version 1.0 Alpha",0

icc INITCOMMONCONTROLSEX <sizeof INITCOMMONCONTROLSEX,0>
wc  WNDCLASSEX <sizeof WNDCLASSEX,NULL,WndProc,0,0,?,?,?,COLOR_SCROLLBAR+1,NULL,szClassName,?>
; cbSize        dd ?
; style         dd ?
; lpfnWndProc   dd ?
; cbClsExtra    dd ?
; cbWndExtra    dd ?
; hInstance     dd ?
; hIcon         dd ?
; hCursor       dd ?
; hbrBackground dd ?
; lpszMenuName  dd ?
; lpszClassName dd ?
; hIconSm       dd ?

szAppName       db 'ProjectCQB',0
szClassName     db 'ProjectCQBClass',0

        .DATA?
        ALIGN   4

hwndMain        HWND ?
dwXpos          dd   ?
dwYpos          dd   ?

msg             MSG  <>

.code
start:
    ;call    about      ; TODO call on appropriate menu selection
    call    newmain
    invoke  ExitProcess, 0

about   PROC
    invoke  MessageBox, NULL, offset about_message, offset about_caption, MB_OK
    ret
about   ENDP

WndProc PROC    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
    mov     eax,uMsg
    .if eax==WM_PAINT
        invoke  wmPaint,hWnd
        xor     eax,eax
    .elseif eax==WM_CREATE
        invoke  GetSystemMetrics,SM_CYSCREEN
        mov     edx,eax
        push    eax
        shr     edx,1
        mov     dwYpos,edx
        invoke  GetSystemMetrics,SM_CXSCREEN
        mov     edx,eax
        shr     edx,1
        mov     dwXpos,edx
        pop     ecx
        mov     edx,hWnd
        mov     hwndMain,edx
        invoke  SetWindowPos,edx,HWND_TOPMOST,0,0,eax,ecx,0
        xor     eax,eax
    .elseif eax==WM_CHAR
        invoke  PostMessage,hWnd,WM_SYSCOMMAND,SC_CLOSE,NULL
        xor     eax,eax
    .elseif eax==WM_RBUTTONUP
        invoke  PostMessage,hWnd,WM_SYSCOMMAND,SC_CLOSE,NULL
        xor     eax,eax
    .elseif eax==WM_LBUTTONUP
        invoke  PostMessage,hWnd,WM_SYSCOMMAND,SC_CLOSE,NULL
        xor     eax,eax
    .elseif eax==WM_CLOSE
        invoke  DestroyWindow,hWnd
        xor     eax,eax
    .elseif eax==WM_DESTROY
        invoke  PostQuitMessage,NULL
        xor     eax,eax
    .else
        invoke  DefWindowProc,hWnd,uMsg,wParam,lParam
    .endif
    ret
WndProc ENDP

newmain   PROC
        INVOKE  InitCommonControlsEx,offset icc         ;initialize common controls
                                                        ;register the window class
        xor     edi,edi                                 ;EDI = 0
        mov     esi,offset wc                           ;ESI = offset wc
        invoke  GetModuleHandle,edi
        mov     [esi].WNDCLASSEX.hInstance,eax
        xchg    eax,ebx                                 ;EBX = wc.hInstance
        invoke  LoadIcon,ebx,IDI_ICON
        mov     [esi].WNDCLASSEX.hIcon,eax
        mov     [esi].WNDCLASSEX.hIconSm,eax
        invoke  LoadCursor,edi,IDC_ARROW
        mov     [esi].WNDCLASSEX.hCursor,eax
        invoke  RegisterClassEx,esi
                                                        ;create the window
        invoke  CreateWindowEx,edi,offset szClassName,offset szAppName,
                WS_POPUP or WS_VISIBLE or WS_CLIPCHILDREN,
                CW_USEDEFAULT,SW_SHOWNORMAL,edi,edi,edi,edi,ebx,edi
        invoke  UpdateWindow,eax
                                                        ;message loop
        mov     esi,offset msg                          ;ESI = msg structure address
        jmp short mLoop1
mLoop0: invoke  TranslateMessage,esi
        invoke  DispatchMessage,esi
mLoop1: invoke  GetMessage,esi,edi,edi,edi
        inc     eax                                     ;exit only
        shr     eax,1                                   ;if 0 or -1
        jnz     mLoop0                                  ;otherwise, we loop
        invoke  ExitProcess,[esi].MSG.wParam
newmain   ENDP

wmPaint PROC    hWnd:HWND
    local   ps      :PAINTSTRUCT
    invoke  BeginPaint,hWnd,addr ps
    invoke  SetPixel,ps.hdc,dwXpos,dwYpos,0
    invoke  EndPaint,hWnd,addr ps
    ret
wmPaint ENDP
    
end start