.386							;�ŧi�i�H�ϥ�80386���O��(Win32�t�Υ����b80386�H�W��CPU�~�����)
.model flat, stdcall			;���w�O����Ҧ�(���Z�Ҧ�)�H�ΩI�s��w(�i�D��Ķ���̥k�䪺�ѼƳ̥����J���|)
option casemap:none				;�i�D��Ķ���AML.EXE�A�ϥΧڭ̩ҩw�q���ܼƦW�١B�аO�W�١BWin32 API�W�ٵ����O�Ϥ��j�p�g��

INCLUDE         windows.inc
INCLUDE         user32.inc
INCLUDE         kernel32.inc
INCLUDE			gdi32.inc
INCLUDE			masm32.inc
;*********************************************************************************************************************************
;�w�q�U�����ѧO�X���ƭȡA���ƭȩM�귽�y�z�ɤ����ѧO�X�ۦP�A�o�Ǽƭȳ����|���ܡA�G�� equ �����O�]�w���`�ơC
;*********************************************************************************************************************************
;���ID(�@�ӼƦr)�A�b�{���̥HIDB_BITMAPxx���
;���ID�O�b�귽��(.rc)�̬��C�Ӧ�ϸ귽(XX.bmp����)�ҳ]���ѧO�X
;
;p122(�Ĥ���:�ϥθ귽), p144(5.3.2:�b�귽���w�q���)
;
;�ӤH�z��:
;�N�@��bmp�Ϥ�(���ɦW(xx.bmp))��i�귽��(.rc)�̭��A�õ����@�Ө����{�ҥΪ��Ʀr�W�P(���ID)
;����n���Ω�b�귽�ɸ̪�����귽�A���O�̷�ID(�Ʀr�W�P)�ӴM��M���X�۹������귽�C(�ɦW(��xx.bmp...)�u�|�X�{�b�귽�ɸ̩w�q�귽��)
;---------------------------------------------------------------------------------------------------------------------------------
IDB_BITMAP1  EQU 101			;character.bmp 		����Ϥ�
IDB_BITMAP2  EQU 102			;character_mask.bmp ����B�n��
IDB_BITMAP3  EQU 103			;enemy.bmp			�ĤH�Ϥ�#0	(�Ŧ�@�i��)
IDB_BITMAP4  EQU 104			;enemy_mask.bmp		�ĤH�B�n��#0	(�Ŧ�@�i��)
IDB_BITMAP5  EQU 105			;bullet.bmp			�l�u�Ϥ�
IDB_BITMAP6  EQU 106			;bullet_mask.bmp	�l�u�B�n��
IDB_BITMAP7  EQU 107			;castle.bmp			�����Ϥ�
IDB_BITMAP8  EQU 108			;castle_mask.bmp	�����B�n��
IDB_BITMAP9  EQU 109			;life.bmp			�ͩR�Ϥ�
IDB_BITMAP10 EQU 110			;life_mask.bmp		�ͩR�B�n��
IDB_BITMAP11 EQU 111			;game_over.bmp		�C�����ѹϤ�
IDB_BITMAP12 EQU 112			;game_over_mask.bmp	�C�����ѾB�n��
IDB_BITMAP13 EQU 113			;win.bmp			�C���L���Ϥ�
IDB_BITMAP14 EQU 114			;win_mask.bmp		�C���L���B�n��
IDB_BITMAP15 EQU 115			;background.bmp		�I����R�Ϥ�
IDB_BITMAP16 EQU 116			;enemy1.bmp			�ĤH�Ϥ�#1	(����@�i��)
IDB_BITMAP17 EQU 117			;enemy1_mask.bmp	�ĤH�B�n��#1	(����@�i��)
IDB_BITMAP18 EQU 118			;enemy2.bmp			�ĤH�Ϥ�#2	(���@�i��)
IDB_BITMAP19 EQU 119			;enemy2_mask.bmp	�ĤH�B�n��#2	(���@�i��)
IDB_BITMAP20 EQU 122			;item.bmp			�D��Ϥ�#0	(���J�O�B��)
IDB_BITMAP21 EQU 123			;item_mask.bmp		�D��B�n��#0	(���J�O�B��)
IDB_BITMAP22 EQU 124			;item1.bmp			�D��Ϥ�#1	(���w��)
IDB_BITMAP23 EQU 125			;item1_mask.bmp		�D��B�n��#1	(���w��)
;---------------------------------------------------------------------------------------------------------------------------------
;��L�귽�ѧO�X
;����ID(�@�ӼƦr)�A�b�{���̥HIDC_CURSORxx���
;�ϥ�ID(�@�ӼƦr)�A�b�{���̥HIDI_ICONxx���
;---------------------------------------------------------------------------------------------------------------------------------
IDC_CURSOR1  EQU 120       		;cursor.cur			���йϤ�
IDI_ICON1    EQU 121            ;icon.ico     		�C���ϥ�
;---------------------------------------------------------------------------------------------------------------------------------
;�Τ�۩w�q���� (WM_XXX)
;�w�q�۩w�q��������(uMsg)�A�H�t�Τw�ϥΪ��w�]�����Ȥ���(0000h~03ffh)���ƭ�WM_USER(=0400h)�}�l�ϥ�
;��o�ͫ��w���p�ɡA�HPostMessg�o�e���w���۩w�q�����ܥD���f�A�H�ϥD���f�@�������B�z
;---------------------------------------------------------------------------------------------------------------------------------
WM_WIN       EQU WM_USER		;�C���L������ (0400h)
WM_GAMEOVER  EQU WM_USER+1		;�C�����Ѯ��� (0401h)
;---------------------------------------------------------------------------------------------------------------------------------
;�w�ɾ��ѧO�X
;�w�ɾ�ID(�@�ӼƦr)�A�b�{���̥HIDT_TIMERxx���
;---------------------------------------------------------------------------------------------------------------------------------
IDT_TIMER1 	EQU 1				;�w�ɾ� : �C���e����s		�ɶ� :    55	�@��
IDT_TIMER2 	EQU 2				;�w�ɾ� : �C���ɶ��˼�		�ɶ� :  1000	�@��
IDT_TIMER3 	EQU 3				;�w�ɾ� : �g���ɶ����j		�ɶ� :   440	�@��	(�H�ܼ�shoot_time(�w�]��440)����)
IDT_TIMER4 	EQU 4				;�w�ɾ� : �ĤH�ͦ����j		�ɶ� :	550	�@��	(�Ŧ�@�i��)
IDT_TIMER5 	EQU 5				;�w�ɾ� : �ĤH�ͦ����j		�ɶ� :  1705	�@��	(����@�i��)
IDT_TIMER6 	EQU 6				;�w�ɾ� : �ĤH�ͦ����j		�ɶ� :   220	�@��	(���@�i��)
IDT_TIMER7 	EQU 7				;�w�ɾ� : �D��ͦ����j		�ɶ� :  3000	�@��
IDT_TIMER8 	EQU 8				;�w�ɾ� : �D��������j		�ɶ� :  3000	�@��
;---------------------------------------------------------------------------------------------------------------------------------
;�C�����T�w���ݩʼƭȡA�� equ �����O�]�w���`�ơC
;---------------------------------------------------------------------------------------------------------------------------------
win_w 		EQU 960				;�������e�Awindow_weight
win_h 		EQU 480				;���������Awindow_height

castle_w 	EQU 123 			;�������e�Acastle_weight
castle_h	EQU 480				;���������Acastle_height

character_w EQU 120				;���⪺�e�Acharacter_weight
character_h EQU 150				;���⪺���Acharacter_height

bullet_w	 EQU 65				;�l�u���e�Abullet_weight
bullet_h 	 EQU 25				;�l�u�����Abullet_height
bullet_speed EQU 30				;�l�u���t��
;---------------------------------------------------------------------------------------------------------------------------------
;�禡PROTO
;---------------------------------------------------------------------------------------------------------------------------------
start_WinStruct PROTO			;�إߵ���

WndProc PROTO hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 	
								;�w�q������U�Өƥ�(���O���U�ƹ�,���U��L����...)�o�ͮɭn������
								
Load_Image PROTO				;�B�z�ϥΦ줸�ϩһݪ���l�ơA���O�гy�����]������(DC)�M�q�귽��(.rc)���HIDŪ���줸��
Show_Image PROTO				;��s�����e��

Move_character PROTO			;���ʨ���
Draw_character PROTO			;ø�s����
Shoot_Bullet   PROTO 			;�o�g�l�u (���t�X�@�Ӥl�u���ʺA�O����å[�J�l�u�C��)
Move_Bullet    PROTO			;���ʵe�������l�u

Create_Item PROTO hWnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD	;�ͦ��D��AIDT_TIMER7���w�ɨ��
Delete_Item PROTO hWnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD	;���h�D��AIDT_TIMER8���w�ɨ�� (�g�L�@�w�ɶ���A�D��۰ʮ���)
																	
Check_Item 	PROTO				;�ˬd����P�D�㪺�I�� (�O�_���o�D��)

Draw_Life 	PROTO				;ø�s�ͩR�Ϯ� (�e���k�W��)�A�B�z�Ѩ��o�D��ҼW�[���ͩR�Ϯ�ø�s		
Erase_life 	PROTO c_life:BYTE	;���h�ͩR�Ϯ� (�e���k�W��)�A�B�z�ѱ�Ĳ�ĤH�Ҵ�֪��ͩR�Ϯ׮��h	

Create_Enemy PROTO hWnd:HWND, uMsg:UINT,idEvent:UINT, dwTime:DWORD	
								;�ͦ��ĤH�AIDT_TIMER4 (�Ŧ�@�i��)�BIDT_TIMER5(����@�i��)�BIDT_TIMER6(���@�i��)���w�ɨ��  
Move_Enemy 	PROTO				;���ʵe�������ĤH

Check_Hit 	PROTO b_X:SDWORD, b_Y:SDWORD	;�ˬd�l�u�P�ĤH���I�� (�O�_�����ĤH)
	
Game_Win 	PROTO				;�C���L���A�����ӹϤ�
Game_Over 	PROTO				;�C�����ѡA��ܥ��ѹϤ�

Quit_Game PROTO					;�����C���A��������]�����ҩM��Ϫ���B�M���p����(Heap)����
;*********************************************************************************************************************************
;�{����Ƭq�A�w�q���c�M�ܼƵ���
;*********************************************************************************************************************************
.data
;---------------------------------------------------------------------------------------------------------------------------------
;��������
;---------------------------------------------------------------------------------------------------------------------------------
hInstance HINSTANCE ?			;�@�ӵ������O(CLASS)��handle�A�������O:�Ψӳгy�X�����ݩʵ������ҪO(�����]�p��)
hstartWin HWND ?				;�@�ӵ���(Object)��handle�A�f�u���ꪺ����(��)

start_ClassName BYTE "START", 0 ;�۩w�q���������O(CLASS)�����O�W��

hgame_DC 	DWORD ?				;�x�s��s���������e�����DC��handle (�C���B��ɪ�������s)

hback_BMP 	DWORD ?				;�I���Ϥ���handle
hback_DC	DWORD ?				;�x�s��s�����ɩһݭI�����e�����DC��handle

hback_erase_DC DWORD ?			;�x�s�Ψӭ�ø�I�����e�����DC��handle
;---------------------------------------------------------------------------------------------------------------------------------
;�C���ɶ�����
;---------------------------------------------------------------------------------------------------------------------------------
hfont_type 	DWORD ?				;�x�s�ҳЫت��޿�r����handle

font_type 	BYTE "�s�ө���", 0	;�r��W�� (�Ψӳ]�m�۩w�q�r��)
font_color 	DWORD 00FFFFFFh		;��r�C�� (�զ�)

time_rect RECT < win_w - 85, win_h - 37, win_w - 10, win_h - 5 >
								;�Ψ���ܹC���ɶ����x�νd��
time_string   BYTE 1024 DUP (?)	;�s��g�榡�ƫ᪺�r��
time_string_f BYTE "%d ��",0		;�榡�Ʀr��

rest_time DWORD 60				;��e�C���ɶ� (�Ѿl���)
;---------------------------------------------------------------------------------------------------------------------------------
;��������
;---------------------------------------------------------------------------------------------------------------------------------
hcastle_BMP DWORD ?				;�����Ϥ���handle
hcastle_DC 	DWORD ?				;�ާ@�����Ϥ�������DC��handle

hcastle_mask_BMP DWORD ?		;�����B�n�Ϫ�handle
hcastle_mask_DC  DWORD ?		;�ާ@�����B�n�Ϫ�����DC��handle
;---------------------------------------------------------------------------------------------------------------------------------
;�������
;---------------------------------------------------------------------------------------------------------------------------------
hcharacter_BMP 	DWORD ?			;����Ϥ���handle
hcharacter_DC 	DWORD ?			;�ާ@����Ϥ�������DC��handle

hcharacter_mask_BMP DWORD ?		;����B�n�Ϫ�handle
hcharacter_mask_DC 	DWORD ?		;�ާ@����B�n�Ϫ�����DC��handle

character_x 	SDWORD castle_w	;���⪺X�y��
character_y 	SDWORD 165		;���⪺Y�y��
character_speed DWORD 12		;���⪺���ʳt��

c_X_mov 		SDWORD 0		;����bX��V�����ʶq
c_Y_mov 		SDWORD 0		;����bY��V�����ʶq

shoot_time 		DWORD 440		;�g�X�l�u���ɶ����j (440�@��)

X SDWORD ?						;�����ܼ� (�Ȧs��)
Y SDWORD ?						;�����ܼ� (�Ȧs��)
;---------------------------------------------------------------------------------------------------------------------------------
;�ĤH����
;---------------------------------------------------------------------------------------------------------------------------------
henemy_BMP 		DWORD ?, ?, ?	;�ĤH�Ϥ���handle
henemy_DC 		DWORD ?, ?, ?	;�ާ@�ĤH�Ϥ�������DC��handle

henemy_mask_BMP	DWORD ?, ?, ?	;�ĤH�B�n�Ϫ�handle
henemy_mask_DC 	DWORD ?, ?, ?	;�ާ@�ĤH�B�n�Ϫ�����DC��handle

ENEMY STRUCT					;�w�qENEMY���c
	x 	SDWORD win_w			;�ĤH��X�y��
	y 	SDWORD ?				;�ĤH��Y�y��
	y_v SBYTE ?					;�ĤH��Y�b���ʤ�V
	e_type BYTE 0 				;�ĤH������ (0 = �Ŧ�B1 = ����B2 = ���)
ENEMY ENDS

enemy_plist DWORD 50 DUP (0)	;�x�s���V�U�ӼĤH������(PTR)���C��

enemy_w DWORD 57, 74, 59		;�ĤH���e�Aenemy_weight
enemy_h DWORD 46, 53, 50		;�ĤH�����Aenemy_height
enemy_speed DWORD 20, 35, 45	;�ĤH�����ʳt��

enemy_num DWORD 0				;��e�e�����ĤH���`��

enemy_temp ENEMY <>				;�����ܼ� (�Ȧs��)
;---------------------------------------------------------------------------------------------------------------------------------
;�l�u����
;---------------------------------------------------------------------------------------------------------------------------------
hbullet_BMP 	DWORD ?			;�l�u�Ϥ���handle
hbullet_DC 		DWORD ?			;�ާ@�l�u�Ϥ�������DC��handle

hbullet_mask_BMP	DWORD ?		;�l�u�B�n�Ϫ�handle
hbullet_mask_DC 	DWORD ?		;�ާ@�l�u�B�n�Ϫ�����DC��handle

BULLET STRUCT					;�w�qBULLET���c
	x SDWORD ?					;�l�u��X�y��
	y SDWORD ?					;�l�u��Y�y��
	y_v SDWORD ?				;�l�u��Y�b���ʤ�V
BULLET ENDS

bullet_plist DWORD 100 DUP (0)	;�x�s���V�U�ӼĤH������(PTR)���C��

bullet_num DWORD 0				;��e�e�����l�u���`��

bullet_temp BULLET <>			;�����ܼ� (�Ȧs��)
;---------------------------------------------------------------------------------------------------------------------------------
;�D�����
;---------------------------------------------------------------------------------------------------------------------------------
hitem_BMP 	DWORD ?, ?, ?		;�D��Ϥ���handle
hitem_DC 	DWORD ?, ?, ?		;�ާ@�D��Ϥ�������DC��handle

hitem_mask_BMP 	DWORD ?, ?, ?	;�D��B�n�Ϫ�handle
hitem_mask_DC 	DWORD ?, ?, ?	;�ާ@�D��B�n�Ϫ�����DC��handle

ITEM STRUCT						;�w�qITEM���c
	x SDWORD ?					;�D�㪺X�y��
	y SDWORD ?					;�D�㪺Y�y��
	i_type BYTE ?				;�D�㪺���� (0 = �B�ΡB1 = ���w�ߡB2 = �R��)
ITEM ENDS

item_list ITEM 5 DUP (<?,?,?>)	;�x�s�D�㪺�C��
item_start 	DWORD 0				;�U�@�ӭn���h���D���C������m
item_end 	DWORD 0				;�U�@�ӹD��n�K�[�i�C������m

item_w DWORD 50, 90, 75			;�D�㪺�e�Aitem_width
item_h DWORD 96, 78, 30			;�D�㪺���Aitem_height

item_num DWORD 0				;��e�e�����D�㪺�`��
;---------------------------------------------------------------------------------------------------------------------------------
;�ͩR����
;---------------------------------------------------------------------------------------------------------------------------------
hlife_BMP 	DWORD ?				;�ͩR�Ϥ���handle
hlife_DC 	DWORD ?				;�ާ@�ͩR�Ϥ�������DC��handle

hlife_mask_BMP 	DWORD ?			;�ͩR�B�n�Ϫ�handle
hlife_mask_DC 	DWORD ?			;�ާ@�ͩR�B�n�Ϫ�����DC��handle

life_x DWORD 585, 660, 735,		;�ͩR�Ϥ���X�y��
			 810, 885	

life BYTE 5						;��e�ͩR��
;---------------------------------------------------------------------------------------------------------------------------------
;��L�C���B�����
;---------------------------------------------------------------------------------------------------------------------------------
hbulletHeap HANDLE ?			;�x�s�e�����C�Ӥl�u��ƪ�heap��handle
henemyHeap 	HANDLE ?			;�x�s�e�����C�ӼĤH��ƪ�heap��handle

shoot_flag BYTE 0				;�P�_�O�_�g��(���U�g����)
hit_flag BYTE 0					;�P�_�l�u�O�_�����ĤH
;*********************************************************************************************************************************
;�{���N�X�q
;*********************************************************************************************************************************
.code
main PROC
	INVOKE start_WinStruct											
	INVOKE ExitProcess, NULL
main ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;start_WinStruct : �إߨæb�ù��W��ܵ���
; 1.���U���f���O
; 2.�̫e�����U�����f���O�Ыؤ@�ӵ��f
; 3.�i�J�L�a�T���j��o��T��
;---------------------------------------------------------------------------------------------------------------------------------
start_WinStruct PROC
	LOCAL @startWC:WNDCLASSEX				;WNDCLASSEX ���c��(�w�q�F�������~�[�ξާ@�覡�����A�o�ӵ��c��b Windows ���ҬO�ܭ��n���ܼơC)
	LOCAL @startMSG:MSG
	;01.���U���f���O
	ClassStruct:
		INVOKE RtlZeroMemory,		ADDR @startWC, SIZEOF @startWC
		INVOKE GetModuleHandle,		NULL									;GetModuleHandle API:�ѼƬ�NULL�A��ܨ��o�������ҲեN�X�C
		mov hInstance, eax													;���\���ܡA�Ǧ^���ҲեN�X�N�s��Ȧs��EAX�A�o�Ӽƭȵy��|�Ψ�A�ҥH�x�s�b hInstance�ܼ��ءC														
		mov @startWC.cbSize,		SIZEOF WNDCLASSEX						;cbSize:���c�����
		mov @startWC.style,			CS_HREDRAW or CS_VREDRAW				;style:�ݩ󦹵������O������������C��ϥΪ̧�ƹ�����������䪺��ب����U�ƹ��k��A�����a���ܵ����j�p�AWindows �|�t�d���sø�s�����CCS_VREDRAW �u�O�令������V�C
		mov @startWC.lpfnWndProc,	OFFSET start_WinProc					;lpfnWndProc:�o�����O���V�@�ӵ����禡 ( window procedure ) ����}
		push hInstance
		pop @startWC.hInstance												;hInstance:�ҲեN�X�A��ܦ��������O�ݩ󨺤@�ӵ{���ҲաC
		INVOKE LoadIcon, hInstance,	IDI_ICON1								;LoadIcon API:�ϵ{���� UI �귽�����J�ϥ�	
		mov @startWC.hIcon,	eax												;hIcon:�����ϥܥN�X�C
		mov @startWC.hIconSm,eax											;hIconSm:�p�ϥܥN�X(��ܦb�u�@�C�W��)
		INVOKE LoadCursor, hInstance, IDC_CURSOR1							;LoadCursor API:�ΨӶǦ^��ХN�X
		mov @startWC.hCursor,eax											;hCursor:��ХN�X
		mov @startWC.hbrBackground,	COLOR_WINDOW+1							;hbrBackground:�u�@�ϭI���C��Chbr ��ܦ����O�@�Ө�l�N�X�C�o�ت�ܦb�u�@�ϵۦ⪺�N��C
		mov @startWC.lpszClassName,	OFFSET start_ClassName					;�@�ӫ��СA���V�������O�W�١A�H�s�������C
		INVOKE RegisterClassEx,		ADDR @startWC							;RegisterClassEx API:�V�t�ε��U�@�ص������O�A�p�G���U���\�AEAX ���D�s
	;02.�Ыص��f
	;CreateWindowEx API:�إߵ���
	;CreateWindowEx �|�� WM_CREATE �T���ǵ��s�إߵ����������禡�C
	WinCreate:
		INVOKE CreateWindowEx,		WS_EX_CLIENTEDGE,						;dwExStyle
									OFFSET start_ClassName,					;�ҭn�Ыت����f���O�W��
									NULL,									;���f�W��
									WS_OVERLAPPEDWINDOW xor WS_THICKFRAME,	;dwStyle
									CW_USEDEFAULT,							;���f��X�y��
									CW_USEDEFAULT,							;���f��Y�y��
									(win_w + 20),							;���f���e
									(win_h + 43),							;���f����
									NULL,									;�����f
									NULL,									;���
									hInstance,								
									NULL									
		mov hstartWin, eax
		INVOKE ShowWindow,		hstartWin, SW_SHOWNORMAL					;ShowWindow API:��ܵ���(�Ĥ@�ӰѼƬO�Q�n��ܵ����������N�X�A�ĤG�ӰѼƬO��ܤ覡)
		INVOKE UpdateWindow,	hstartWin									;UpdateWindow API:���p�u�@�Ϥ��O�ŵL�@���A���|�e�X�@�� WM_PAINT �T�������w�����������禡�A�M��i���s�C
	;03.�i�J�L�a�T���j��o��T��
	MessageLoop:
		.while TRUE
		INVOKE GetMessage,		ADDR @startMSG, NULL, 0, 0					;GetMessage API : �q�{���T����C���X�@���T��
																			;�Ĥ@�ӰѼ� lpMsg �O���V�@�Ӧ�}�A�o�Ӧ�}�O�@�Ӻ٬� MSG �����c���ܼƩҦb����}�A�ӵ��c��O�Ψӱ����q�T����C�ҶǨӪ��T�������c��C
																			;�ĤG�ӰѼƬO hWnd�A��ܭn���o���@�ӵ������T���A���p hWnd ���s���ܡA��ܨ��o�{���ۤv�������T���C
																			;�ĤT�өM�ĥ|�ӰѼƤ��O��ܨ��o�T�����s���d��A���p�n���o�Ҧ��T�����ܡA��̧��]���s�C
		.break .if eax == 0													;GetMessage ���Ǧ^�Ȧ��T�ر��ΡA���p�Ǧ^ WM_QUIT �T�����ܡAEAX ���s�A�hbreak
		INVOKE TranslateMessage,ADDR @startMSG								;TranslateMessage API : ����w��}�� MSG ���c�骺����½Ķ���r���A�A��^�{���T����C���ݤU���� GetMessage ���^
		INVOKE DispatchMessage,	ADDR @startMSG								;DispatchMessage API : �� MSG ���c�骺�T���ǵ������禡�[�H�B�z
		.endw
		ret
start_WinStruct ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;start_WinProc : �B�z�T����"�����禡"(��ڭ̪��{���ۨt�αo��T������A�����̷ӵ{�������쪺�T���[�H�B�z�A�B�z�o�ǰT�����@�q�{���N�٬��y�����禡�z�C)
;��s�������B�J�J
; 1.�I�s InvalidateRect �Ϥu�@���ܬ��L�ġA��s�L�İϥH�o�X WM_PAINT �T��	
; 2.�B�zWM_PAINT�T���H���sø�s���� (Windows �u���sø�s�����Q�B�\�Ϊ̻ݭn���sø�s�������N�i�H�F�A�o�Ӱϰ�٬��y�L�İϰ�z�C)
;---------------------------------------------------------------------------------------------------------------------------------
start_WinProc PROC USES ebx edi esi edx, hWnd:HWND, uMsg:UINT, 			;hWnd�����N�X�AuMsg�T���s���AwParam,lParam�B�~���T�����
										 wParam:WPARAM, lParam:LPARAM	;�]�� Windows �t�Τ����ϥγo�ǼȦs����@���СA�ҥH�o�`�N�O�s�o�|�ӼȦs���C
	mov eax, uMsg
	;01.�B�z WM_TIMER �T�� (�w�ɾ�)
	.if eax == WM_TIMER
		;01-1.�Y��WM_TIMER�O��IDT_TIMER1�p�ɾ��o�X
		.if wParam == IDT_TIMER1										;IDT_TIMER1 : �e����s
			.if enemy_num == 0											;�P�_�e�����O�_���ĤH
				jmp NO_ENEMY_MOVE										;�Y�L (enemy_num == 0)�h����NO_ENEMY_MOVE�A���L���ʼĤH���B�J (Move_Enemy)
			.endif
			INVOKE Move_Enemy
		NO_ENEMY_MOVE:											
			.if bullet_num == 0											;�P�_�e�����O�_���l�u 
				jmp NO_BULLET_MOVE										;�Y�L(bullet_num == 0)�h����NO_BULLET_MOVE�A���L���ʤl�u���B�J (Move_Bullet)
			.endif
			INVOKE Move_Bullet
		NO_BULLET_MOVE:
			.if c_X_mov == 0											;�P�_�H���O�_���� 
				.if c_Y_mov == 0										;�Y�L(c_X_mov == 0 && c_Y_mov == 0)												
					jmp NO_CHARACTER_MOVE								;�h����NO_CHARACTER_MOVE�A���L���ʤH�����B�J (Move_character)	
				.endif
			.endif
			INVOKE Move_character			
			NO_CHARACTER_MOVE:
			CALL Draw_character											;ø�s�H��
			INVOKE Check_Item											;�ˬd�H���P�D�㪺�I�� (�O�_���o�D��)
			INVOKE InvalidateRect,hWnd,0,1								;InvalidateRect API:�Ψӳ]�w�L�İϰ� 
																		;�ĤG�ӰѼ�lpRect �O���ӵ������n�]�w���@���ϰ쬰�L�İϰ�O�s���ܡA��ܤu�@�Ϫ��Ҧ��d�򳣬O�L�İϰ�C
																		;�̫�@�ӰѼ� bErase �O��ܬO�_�M���I���A�D�s��ܭn�M���I���A�b�I�s BeginPaint �ɡA�I���N�|�Q�M���C
			
		.endif
		;01-2.�Y��WM_TIMER�O��IDT_TIMER3�p�ɾ��o�X							
		.if wParam == IDT_TIMER3										;IDT_TIMER3 : �g�X�l�u�����j
			.if shoot_flag == 1											;�Y shoot_flag == 1 (�g���䬰���U���A)�A
				CALL Shoot_Bullet										;�h�I�s Shoot_Bullet �g�X�l�u
			.endif
		.endif
		;01-3.�Y��WM_TIMER�O��IDT_TIMER2�p�ɾ��o�X
		.if wParam == IDT_TIMER2											;IDT_TIMER2 : �C���ɶ��˼�
			sub rest_time, 1												;�C���ɶ�-1
			;��C���Ѿl5��A�X�{���@�i��
			.if rest_time == 5												
				mov font_color, 000000FFh									;�N��ܹC���ɶ�����r�C��]��000000FFh (����)
				INVOKE SetTimer, hWnd, IDT_TIMER6, 220, ADDR Create_Enemy	;�Ыإͦ����@�i�ߪ��w�ɾ� (IDT_TIMER6)
																			;IDT_TIMER6 : �ͦ��ĤH(���@�i��)�A��Create_Enemy �ӳB�z IDT_TIMER6 �o�e���T��
			;��C���Ѿl0��A�h�C���L��
			.elseif rest_time == 0											
				INVOKE KillTimer, hWnd, IDT_TIMER1							;�M���w�ɾ�
				INVOKE KillTimer, hWnd, IDT_TIMER2
				INVOKE KillTimer, hWnd, IDT_TIMER3
				INVOKE KillTimer, hWnd, IDT_TIMER4
				INVOKE KillTimer, hWnd, IDT_TIMER5
				INVOKE KillTimer, hWnd, IDT_TIMER6
				INVOKE KillTimer, hWnd, IDT_TIMER7
				INVOKE KillTimer, hWnd, IDT_TIMER8
				INVOKE Game_Win												;��ܹC���L���Ϥ�
			;��C���}�l8��A�]�m�D��������w�ɾ�
			.elseif rest_time == 52											
				INVOKE SetTimer, hWnd, IDT_TIMER8, 3000, ADDR Delete_Item	;�ЫعD��������w�ɾ� (IDT_TIMER8)�A�H��{�D��X�{8���۰ʮ������ĪG
			.endif
		.endif
	;��{������ WM_PAINT�A�����H BeginPaint �� EndPaint �o��� API ���_�l�ε����Ӫ�l�Ƹ˸m����ε����˸m���e�A�ӧڭ̭n�p��ø�s�ϧΪ��{���X�h���b�o��� API �����C
	;ø�Ϯɪ����k����ءA�Ĥ@�جO�b WM_PAINT �T�����ϥ�BeginPaint �M EndPaint ��� API �Ӷ}�ҩM����]�Ƥ��e�C
	;02.�B�z WM_PAINT �T�� (��s���f�e��)
	.elseif eax == WM_PAINT
		INVOKE Show_Image
	;02.�B�z WM_KEYDOWN �T��	(���U����)
	.elseif eax == WM_KEYDOWN
		UP:		
		.if wParam == VK_UP;57h							;���UW��
			mov ecx, 0
			sub ecx, character_speed
			mov c_Y_mov, ecx							;�H��Y��V�첾 = -(�H���t��)
		DOWN:		
		.elseif wParam == VK_DOWN;53h					;���US��
			mov ecx, 0
			add ecx, character_speed
			mov c_Y_mov, ecx							;�H��Y��V�첾 = �H���t��
		LEFT:
		.elseif wParam == VK_LEFT;41h					;���UA��
			mov ecx, 0
			sub ecx, character_speed
			mov c_X_mov, ecx							;�H��X��V�첾 = -(�H���t��)
		RIGHT:
		.elseif wParam == VK_RIGHT;44h					;���UD��
			mov ecx, 0
			add ecx, character_speed
			mov c_X_mov, ecx							;�H��X��V�첾 = �H���t��
		.elseif wParam == VK_SPACE;44h;space			
			mov shoot_flag, 1
			;CALL Shoot_Bullet
		.endif
	;03.�B�z WM_KEYUP �T�� (��}����)
	.elseif eax == WM_KEYUP	
		.if wParam == VK_UP;57h								;��}W��
			mov c_Y_mov, 0								;�H��Y��V�첾 = 0
		.elseif wParam == VK_DOWN;53h							;��}S��
			mov c_Y_mov, 0								;�H��Y��V�첾 = 0
		.elseif wParam == VK_LEFT;41h							;��}A��
			mov c_X_mov, 0								;�H��X��V�첾 = 0
		.elseif wParam == VK_RIGHT;44h							;��}D��
			mov c_X_mov, 0								;�H��X��V�첾 = 0
		.elseif wParam == VK_SPACE;44h;space
			mov shoot_flag, 0
		.endif
	;04.�B�z WM_LBUTTONDOWN �T�� (���U�ƹ�����)
	;.elseif eax == WM_LBUTTONDOWN
		;mov shoot_flag, 1								;�N shoot_flag �]�� 1�A��ܮg�X�l�u
		;CALL Shoot_Bullet	
	;05.�B�z WM_LBUTTONUP �T�� (��}�ƹ�����)
	;.elseif eax == WM_LBUTTONUP
		;mov shoot_flag, 0								;�N shoot_flag �]�� 0
	;�b WM_CREATE �T�����A�B�z�{���@�}�l�����n�������u�@�A�Ҧp��l�ƬY���ܼƵ����C
	;06.�B�z WM_CREATE �T�� (��l��)
	.elseif eax == WM_CREATE
		;06-1.�]�m�üƺؤl�M�Ыبp����(Heap)
		INVOKE GetTickCount									;���o��e�t�ήɶ�
		INVOKE nseed, eax									;�N��e�t�ήɶ��@���H���üƪ��ؤl
		INVOKE HeapCreate, HEAP_NO_SERIALIZE, 320, 1600		;HeapCreate:�Ыبp���諸���
															;flOptions�ѼƬO�лx�A�Ψӫ��w�諸�ݩ�(HEAP_NO_SERIALIZE�ϰ藍�|�i��W���ʪ��˴��A�X�ݳt�ק��)
															;�Ѽ�dwInitialSize���w�Ыذ�ɤ��t���諸���z���s�A��o�Ǥ��s�Q�Χ��ɡA�諸���ץi�H�۰��X�i�C
															;dwMaximunSize�Ѽƫ��w�F����X�i�쪺�̤j�ȡA���X�i��̤j�ȮɦA���t�襤���s�|���ѡC
		mov hbulletHeap, eax
		INVOKE HeapCreate, HEAP_NO_SERIALIZE, 400, 800
		mov henemyHeap, eax
		;�b Win32 �����جO�H�T���X�ʪ��覡��ҡA�]�N�O����Ϩt�Φb�C�j�@�q�ɶ��ɵo�X�@�ӰT�����ڭ̪��{���A�n�F��o�ӥت��i�H�ϥ� SetTimer API�C
		;SetTimer API:�o�� API �إߤ@�ӭp�ɾ��A���p�ɾ��C�j�@�q���w���ɶ��A�V�Y�ӫ��w�������e�X WM_TIMER �T��
		;hWnd �O�p�ɾ����ݪ������N�X�CnIDEvent �O�p�ɾ����ѧO�X�CuElapse �O�ҳ]�w���ɶ��A���O�@��ClpTimerFunc�� NULL ���ܡA���� hWnd �������禡�ӳB�z WM_TIMER�C
		;06-2.�Ыحp�ɾ�
		INVOKE SetTimer, hWnd, IDT_TIMER1, 55, NULL							;IDT_TIMER1 : �C���e����s
		INVOKE SetTimer, hWnd, IDT_TIMER2, 1000, NULL						;IDT_TIMER2 : �C���ɶ��˼�
		INVOKE SetTimer, hWnd, IDT_TIMER3, shoot_time, NULL					;IDT_TIMER3 : �g�X�l�u���j
		INVOKE SetTimer, hWnd, IDT_TIMER4, 550, ADDR Create_Enemy			;IDT_TIMER4 : �ͦ��ĤH(�Ŧ�@�i��)�A��Create_Enemy �ӳB�z IDT_TIMER4 �o�e���T��
		INVOKE SetTimer, hWnd, IDT_TIMER5, 1705, ADDR Create_Enemy			;IDT_TIMER5 : �ͦ��ĤH(����@�i��)�A��Create_Enemy �ӳB�z IDT_TIMER5 �o�e���T��
		INVOKE SetTimer, hWnd, IDT_TIMER7, 3000, ADDR Create_Item			;IDT_TIMER7 : �ͦ��D��A��Create_Item �ӳB�z IDT_TIMER7 �o�e���T��
		;06-3.�B�z�ϥΦ줸�ϩһݪ���l��
		INVOKE Load_Image
	;07.�B�z WM_GAMEOVER �۩w�q�T�� (�C������)
	.elseif eax == WM_GAMEOVER
		;07-1.����w�ɾ�
		INVOKE KillTimer, hWnd, IDT_TIMER1				;KillTimer API:����p�ɾ�
		INVOKE KillTimer, hWnd, IDT_TIMER2				;hWnd �O�p�ɾ����ݪ������N�X�CuIDEvent �O�p�ɾ����ѧO�X�C
		INVOKE KillTimer, hWnd, IDT_TIMER3				;���񦨥\���ܡA�� API �|�Ǧ^�D�s��
		INVOKE KillTimer, hWnd, IDT_TIMER4			
		INVOKE KillTimer, hWnd, IDT_TIMER5
		INVOKE KillTimer, hWnd, IDT_TIMER6
		INVOKE KillTimer, hWnd, IDT_TIMER7
		INVOKE KillTimer, hWnd, IDT_TIMER8
		INVOKE Game_Over								;��ܹC�����ѹϤ�
	;08.�B�z WM_CLOSE �T�� (��������) (�`�N : ���ɨå������{���A�u�����f�Q���������A�{�����b�B��)
	.elseif eax == WM_CLOSE
		;08-1.����w�ɾ�
		INVOKE KillTimer, hWnd, IDT_TIMER1
		INVOKE KillTimer, hWnd, IDT_TIMER2
		INVOKE KillTimer, hWnd, IDT_TIMER3
		INVOKE KillTimer, hWnd, IDT_TIMER4
		INVOKE KillTimer, hWnd, IDT_TIMER5
		INVOKE KillTimer, hWnd, IDT_TIMER6
		INVOKE KillTimer, hWnd, IDT_TIMER7
		INVOKE KillTimer, hWnd, IDT_TIMER8
		INVOKE DestroyWindow,	hstartWin					;DestoryWindow �|�R�����w�������A�õo�X WM_DESTROY �T����J�ӵ������{���T����C��
	;������禡���� WM_DESTROY �T���ɡA�����w�Q�R��
	;09.�B�z WM_DESTROY �T�� (�����{��)
	.elseif eax == WM_DESTROY
		CALL Quit_Game
		INVOKE PostQuitMessage,	NULL						;PostQuitMessage API:�Ϩt�Χ� WM_QUIT �T�����{���T����C�ءA���ݵ{���H GetMessage ���� WM_QUIT �T���C
	;��L�T����Ѩt�Ψ̹w�]�ۦ�B�z
	.else
		INVOKE DefWindowProc, hWnd, uMsg, wParam, lParam	;DefWindowProc API:�t�Τ��w���B�z�T���禡
		ret
	.endif
	XOR eax, eax
	ret
start_WinProc ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Load_Image : �B�z�ϥΦ줸�ϩһݪ���l�ơA���O�гy�����]�Ƥ��e(DC)�M�q�귽��(.rc)���HIDŪ���줸�ϡC���o�˸m���e��A
;			  ���إߤ@�өM�������ۦP���˸m���e�A�٬��O����˸m���e�A�@���w�İϡA�A�ѳo�ӽw�İϪ�����줸�϶ǰe��n��ܪ��˸m���e�W�C
;�n��� BMP �줸�Ϫ��B�J�j�P�i�����H�U�X�ӨB�J�G
; 1.�b�귽�ɤ��w�q�줸�ϡC
; 2.�� LoadBitmap API ���J�줸�ϡC
; 3.�� BeginPaint ���o�]�Ƥ��e�A�٦��]�Ƥ��e�� hdc�C
; 4.�� CreateCompatibleDC API �t�~�A�إ߻P�ӳ]�Ƥ��e�@�˪��]�Ƥ��e�A�٬� hdcMem�C
; 5.�� SelectObject API ��۸귽�ɸ��J���줸�ϵe�b hdcMem �W�C
; 6.�� BitBlt API �� hdcMem ���줸�϶ǰe�� hdc �W�C
; 7.��ܹϤ���A�� DeleteDC�BEndPaint ���O���� hdc�BhdcMem�C
;---------------------------------------------------------------------------------------------------------------------------------
Load_Image PROC USES eax
	LOCAL @hDC
	LOCAL @hbrush
	LOCAL @Font : TEXTMETRIC
	;01.�гy�����]�Ƥ��e(DC)
	Create_DC:
		;01-1.���o�˸m���e
		INVOKE GetDC, hstartWin					;���o�����u�@�Ϫ��]�Ƥ��e
		mov @hDC, eax							;�Ȧs�iLOCAL�ܼ� @hdc ��
		;01-2.�إ߽w�İϪ��O����]�Ƥ��e
		INVOKE CreateCompatibleDC,	@hDC		;CreateCompatibleDC API:�إ߬ۦP���˸m���e
		mov hgame_DC, eax						;���\�h��^�Ȧs�� EAX�A���s�ت��]�Ƥ��e�N�X�C
		INVOKE CreateCompatibleDC,	@hDC		;�w�İϪ��O����]�Ƥ��e�N�X�s��hXXX_DC�ܼ���
		mov hback_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hback_erase_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hcastle_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hcastle_mask_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hcharacter_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hcharacter_mask_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov henemy_DC[0], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov henemy_mask_DC[0], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov henemy_DC[4], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov henemy_mask_DC[4], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov henemy_DC[8], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov henemy_mask_DC[8], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hbullet_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hbullet_mask_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hlife_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hlife_mask_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hitem_DC[0], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hitem_mask_DC[0], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hitem_DC[4], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hitem_mask_DC[4], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hitem_DC[8], eax
		INVOKE CreateCompatibleDC,	@hDC
		mov hitem_mask_DC[8], eax
	;02.���J�귽�����줸�Ϩ�O�����ءC
	Load_BMP:
		;02-1.���J�I���줸�� (IDB_BITMAP15)
		INVOKE LoadBitmap, hInstance, IDB_BITMAP15			;LoadBitmap API:��귽�����줸�ϸ��J��O�����ءC
															;hInstance �O�{�����ҲեN�X�AlpBitmapName �O���V�줸���ѧO�X�r�ꪺ��}
															;���槹 LoadBitmap API ��AEAX �|�Ǧ^�줸�ϥN�X�C
		mov hback_BMP, eax									;�O���줸�ϥN�X��hback_BMP�ܼ���
		;02-2.��I���줸���ܦ�����				
		INVOKE  CreatePatternBrush, hback_BMP				;CreatePatternBrush API:��S�w���줸�ϻs������Chbmp �O�Q�n�s�@�����ꪺ�줸�ϥN�X�C�p�G���\�ACreatePatternBrush �|�Ǧ^����N�X
		mov @hbrush, eax									;��o�ӵ���N�X�O���bLOCAL�ܼ� @hbrush ��
		;02-1.���J��L�줸�� 
		INVOKE LoadBitmap, hInstance, IDB_BITMAP1
		mov hcharacter_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP2
		mov hcharacter_mask_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP3
		mov henemy_BMP[0], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP4
		mov henemy_mask_BMP[0], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP16
		mov henemy_BMP[4], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP17
		mov henemy_mask_BMP[4], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP18
		mov henemy_BMP[8], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP19
		mov henemy_mask_BMP[8], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP5
		mov hbullet_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP6
		mov hbullet_mask_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP7
		mov hcastle_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP8
		mov hcastle_mask_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP9
		mov hlife_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP10
		mov hlife_mask_BMP, eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP20
		mov hitem_BMP[0], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP21
		mov hitem_mask_BMP[0], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP22
		mov hitem_BMP[4], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP23
		mov hitem_mask_BMP[4], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP9
		mov hitem_BMP[8], eax
		INVOKE LoadBitmap, hInstance, IDB_BITMAP10
		mov hitem_mask_BMP[8], eax
	;03.�N���w�����J���w�]�Ƥ��e (DC) ��
	Link_BMPtoDC:	
		;�j�h�ɭԨϥΪ��O�귽�̤w�g�w�w�q���줸�ϡA�����ɤ]���ݭn�ϥΥ���l�ƪ��줸�ϡA�o�Ǧ줸�ϬO�b�{���B���~�Q�Ыت�
		;03-1.�H hdc �����A�� CreateCompatibleBitmap �إߥ���l�ƪ��줸�ϡC
		INVOKE CreateCompatibleBitmap, @hDC, win_w, win_h				;CreateCompatibleBitmap API:�إ߻P hdc �ۮe���줸�ϡC�p�G���\�إߦ줸�ϡA�h�Ǧ^�줸�ϥN�X
		;03-2.�� SelectObject ��줸�Ͽ�J�w�İϪ��O����]�Ƥ��e�C
		INVOKE SelectObject, hgame_DC, eax								;SelectObject API:��s�إߪ������J���w���˸m���e�ءA���N�ª���
																		;hdc �O���w���˸m���e�Ahgdiobj �O�n�Q��J�˸m���e���ϧΪ���N�X�A�i�H�Ϊ��ϧΪ��󦳦줸�� (Bitmap)�B
																		;���� (Brush)�B�r�� (Font)�B�e�� (Pen)�B�d�� (Region) ��
		
		INVOKE DeleteObject,  eax
		INVOKE CreateCompatibleBitmap, @hDC, win_w, win_h
		INVOKE SelectObject, hback_DC, eax
		INVOKE DeleteObject,  eax
		INVOKE CreateCompatibleBitmap, @hDC, win_w, win_h
		INVOKE SelectObject, hback_erase_DC, eax
		INVOKE DeleteObject,  eax
		;03-2.1.�N�I����R�����J�I���]�Ƥ��e�C
		INVOKE SelectObject, hback_DC, @hbrush
		;03-2.2.�N��L�����J�ӧO�]�Ƥ��e�C
		INVOKE SelectObject, hcastle_DC, hcastle_BMP
		INVOKE SelectObject, hcastle_mask_DC, hcastle_mask_BMP
		INVOKE SelectObject, hcharacter_DC, hcharacter_BMP
		INVOKE SelectObject, hcharacter_mask_DC, hcharacter_mask_BMP
		INVOKE SelectObject, henemy_DC[0], henemy_BMP[0]
		INVOKE SelectObject, henemy_DC[4], henemy_BMP[4]
		INVOKE SelectObject, henemy_DC[8], henemy_BMP[8]
		INVOKE SelectObject, henemy_mask_DC[0], henemy_mask_BMP[0]
		INVOKE SelectObject, henemy_mask_DC[4], henemy_mask_BMP[4]
		INVOKE SelectObject, henemy_mask_DC[8], henemy_mask_BMP[8]
		INVOKE SelectObject, hbullet_DC, hbullet_BMP
		INVOKE SelectObject, hbullet_mask_DC, hbullet_mask_BMP
		INVOKE SelectObject, hlife_DC, hlife_BMP
		INVOKE SelectObject, hlife_mask_DC, hlife_mask_BMP
		INVOKE SelectObject, hitem_DC[0], hitem_BMP[0]
		INVOKE SelectObject, hitem_DC[4], hitem_BMP[4]
		INVOKE SelectObject, hitem_DC[8], hitem_BMP[8]
		INVOKE SelectObject, hitem_mask_DC[0], hitem_mask_BMP[0]
		INVOKE SelectObject, hitem_mask_DC[4], hitem_mask_BMP[4]
		INVOKE SelectObject, hitem_mask_DC[8], hitem_mask_BMP[8]
	;04.�I���϶�R
	Fill_Background:	
		INVOKE PatBlt,  hback_DC, 0, 0, win_w, win_h, PATCOPY						;PatBlt API : �N��e�ϼ˫�����hDC���A�Ϲϼ˫��~����ӭI����
																					;�� hdc �ثe������@���ϼˡA�q�y�� ( nXLeft�AnYLeft ) �}�l��R�A
																					;��R�ϰ쪺�e�׻P���פ��O�O nWidth�BnHeight�C��R�覡�i�H�� dwRop ���w
																					;PATCOPY : ��R����
		INVOKE BitBlt,	hback_erase_DC,0, 0,win_w, win_h, hback_DC, 0, 0,SRCCOPY
	;��ܥh�IBMP���ɳz���ĪG����k:
	;�A�إߤ@�i�Ϥ��A�٬��B�n�ϡA�Ϯת��D�n�������զ� (1)�A�ӭI�����¦� (0)�A
	;�����B�n�ϻP�I���ϧ@ OR �B��A�A�Ϧ줸�ϻP�I���ϧ@ AND �B��Y�i�C
	;05.ø�s�����Ϥ�
	Draw_castle:
													;BitBlt API:�ǰe�@�Ӱ϶����줸��� ( bit-block transfer )�A�N�Y�Ϧb�O���餺���줸�ϡA�ǰe��]�Ƥ��e�C
		INVOKE BitBlt,  hback_DC,					;hdcDest �O�ت��a���]�Ƥ��e�N�X
						0, 0,						;nXDest�BnYDest �O�ت��a�]�Ƥ��e���y��
						castle_w, castle_h,			;nWidth�BnHeight �O�ǰe�Ϥ����e�׻P����
						hcastle_mask_DC, 0, 0,		;hdcSrc �O�ӷ��]�Ƥ��e�AnXSrc�BnYSrc �O�ӷ����y��
						SRCPAINT					;dwRop �O�ǰe�᪺�ާ@�覡
													;SRCPAINT : �ӷ���� OR �ؼи��
		INVOKE BitBlt,  hback_DC,
						0, 0,
						castle_w, castle_h,
						hcastle_DC, 0, 0,
						SRCAND						;SRCAND : �ӷ���� AND �ؼи��
	;06.ø�s�ͩR�Ϥ�
		movzx ecx, life
		mov eax, 0
	Draw_life:
		push ecx 
		push eax
		mov eax, life_x[eax]
		push eax
		INVOKE BitBlt,  hback_DC,
						eax, 0,
						75, 30,
						hlife_mask_DC, 0, 0,
						SRCPAINT
		pop eax
		INVOKE BitBlt,  hback_DC,
						eax, 0,
						75, 30,
						hlife_DC, 0, 0,
						SRCAND
		pop eax
		add eax, 4
		pop ecx
		LOOP Draw_life
	;07.�Ы���ܹC���ɶ����榡�Ʀr��
	Create_Font:
		INVOKE CreateFont, 32, 0, 0, 0, 700, 0, 0, 0, 0, 0, 0, 0, 0, OFFSET font_type		;�Ы��޿�r��
		mov hfont_type, eax
		INVOKE SelectObject, @hDC, eax
		INVOKE SetBkMode, @hDC, TRANSPARENT
		INVOKE wsprintf, OFFSET time_string, OFFSET time_string_f, rest_time
		INVOKE DrawText, @hDC, OFFSET time_string, -1, OFFSET time_rect, DT_VCENTER
	;08.�����I���A�ǰe�� hgame_DC �]�Ƥ��e
	Finish_Background:
		INVOKE BitBlt,	hgame_DC,
						0, 0,	
						win_w, win_h, 
						hback_DC, 0, 0,
						SRCCOPY
	;09.ø�s�H���Ϥ�
	Draw_Chacter_Image:
		INVOKE BitBlt,	hgame_DC, 
						character_x, character_y,
						character_w, character_h,
						hcharacter_mask_DC, 0, 0,
						SRCPAINT
		INVOKE BitBlt,	hgame_DC, 
						character_x, character_y,
						character_w, character_h,
						hcharacter_DC, 0, 0,
						SRCAND
		INVOKE DeleteObject, @hbrush
		INVOKE ReleaseDC, hstartWin, @hDC
		ret
Load_Image ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Show_Image : ��ø���f
;---------------------------------------------------------------------------------------------------------------------------------
Show_Image PROC USES eax
	LOCAL @PS:PAINTSTRUCT
	LOCAL @hDC

	INVOKE BeginPaint, hstartWin, ADDR @PS									;BeginPaint API : ���o�]�Ƥ��e�ö}�lø�s��L�İ�
																			;�Ĥ@�ӬO�����N�X�A�ĤG�ӬO�@���r�դj�p���ƭȡA���ƫ��V���c��APAINTSTRUCT�A����}�C
																			;���p�I�s���\�A�b eax �|�Ǧ^�]�Ƥ��e�N�X
	mov @hDC, eax
	INVOKE BitBlt,	@hDC,
					@PS.rcPaint.left,	;@x,
					@PS.rcPaint.top,	;@y,
					@PS.rcPaint.right,	;character_w,
					@PS.rcPaint.bottom,	;character_h,
					hgame_DC,	;hcharacter_DC,
					0,
					0,
					SRCCOPY
	INVOKE SelectObject, @hDC, hfont_type
	INVOKE SetTextColor, @hDC, font_color
	INVOKE SetBkMode, @hDC, TRANSPARENT
	INVOKE wsprintf, OFFSET time_string, OFFSET time_string_f, rest_time
	INVOKE DrawText, @hDC, OFFSET time_string, -1, OFFSET time_rect, DT_VCENTER
	INVOKE EndPaint, hstartWin, ADDR @PS									;EndPaint API : ����ø�s������]�Ƥ��e
	ret
Show_Image ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Move_character : ���ʤH��
;	1.���h����H��
;	2.�ˬd�O�_�IĲ��t�íp��H�����첾
;	3.�ˬd�O�_�H�������ʡA�Y�L�h������^
;	4.��s�H����m
;---------------------------------------------------------------------------------------------------------------------------------
Move_character PROC USES eax
	;01.�����H��
	INVOKE BitBlt,	hgame_DC,
					character_x, character_y,
					character_w, character_h,
					hback_DC, character_x, character_y,
					SRCCOPY
	;02.�ˬd�O�_�IĲ��t�A�YĲ�ɫh������
	Check_Bound:
		Left_Bound:
		mov ecx, character_x
		add ecx, c_X_mov					;ecx = �H������
		cmp ecx, castle_w					;����H�������M�����k��
		jge Right_Bound
		mov c_X_mov, 0						;�IĲ������ɡA�H��X��V�첾 = 0
		jl Up_Bound
		Right_Bound:
		add ecx, character_w				;ecx = �H���k��
		cmp ecx, win_w						;����H���k���M�e���k��
		jle Up_Bound
		mov c_X_mov, 0						;�IĲ�k����ɡA�H��X��V�첾 = 0
		Up_Bound:
		mov ecx, character_y		
		add ecx, c_Y_mov					;ecx = �H������
		cmp ecx, 0							;����H�����ݩM�e������
		jge Down_Bound
		mov c_Y_mov, 0						;�IĲ������ɡA�H��Y��V�첾 = 0
		jl Check_Move
		Down_Bound:
		add ecx, character_h				;ecx = �H������
		cmp ecx, win_h						;����H�����ݩM�e������
		jle Move
		mov c_Y_mov, 0						;�IĲ������ɡA�H��Y��V�첾 = 0
	;03.�P�_�H���O�_���ʡA�Y�L�h������^
	Check_Move:
		.if c_X_mov == 0
			.if c_Y_mov == 0				;�Y�H��X��V�첾 (c_X_mov) �MY��V�첾 (c_Y_mov) �Ҭ� 0
				ret							;�L���ʪ�����^
			.endif
		.endif
	;04.��s�H����m
	Move:
		mov eax, character_x
		add eax, c_X_mov
		mov character_x, eax
		mov eax, character_y
		add eax, c_Y_mov
		mov character_y, eax
	ret
Move_character ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Draw_character : ø�s�H��
;---------------------------------------------------------------------------------------------------------------------------------
Draw_character PROC
	INVOKE BitBlt,	hgame_DC, character_x, character_y,
					character_w, character_h,
					hcharacter_mask_DC, 0, 0,
					SRCPAINT
	INVOKE BitBlt,	hgame_DC, character_x, character_y,
					character_w, character_h,
					hcharacter_DC, 0, 0,
					SRCAND
	ret
Draw_character ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Shoot_Bullet : �g�X�l�u
; 1.�ͦ��l�u��� (�_�l��m�B��V��) �æs�J�Ȧs�Ϊ��l�u�ܼ� bullet_temp ��
; 2.���t�X�@�Ӥl�u (BULLET) ���O����Ŷ��A�ñN���V�ӪŶ��_�l��}�����Цs�JLOCAL�ܼ� pbullet_temp
; 3.�N bullet_temp ����ƥHmovsd, movsb�� �s�J���t�X���Ŷ� 
; 3.�N pbullet_temp �[�J�x�s�C�Ӥl�u���� (BULLET PTR) ���C�� bullet_plist ��
; 3-1.�j�M bullet_plist ���O�_�� 0 �A�Y���h��ܸ��x�s���Ъ���m���Ŷ��A�H pbullet_temp �л\�A�Y�L�h�N pbullet_temp �K�ܦC�����
; 4.�վ�l�u��ƨí��ƤT���e�z�ʧ@�ͦ�3���l�u�A�H�F��P�ɮg�X3�����P��V�l�u���ĪG
;---------------------------------------------------------------------------------------------------------------------------------
Shoot_Bullet PROC 
	LOCAL pbullet_temp:DWORD
	LOCAL y_v_temp:SDWORD
	mov y_v_temp, -1
	mov ecx, 3
	mov edx, character_y
	add edx, (character_h / 2) - 20
	;01.�ͦ��l�u���
	Create_Bullet:
		push ecx
		push edx
		mov edx, character_x
		add edx, character_w
		mov bullet_temp.x, edx			;�]�m�l�u�_�lX�y��
		pop edx
		mov bullet_temp.y, edx			;�]�m�l�u�_�lY�y��
		add edx, 20
		push edx
		mov edx, y_v_temp
		mov bullet_temp.y_v, edx		;�]�m�l�uY�b�W����V (-1 = �V�W, 0 = ���u, 1 = �V�U)
	;02.���t�O����Ŷ�
		INVOKE HeapAlloc, hbulletHeap, HEAP_ZERO_MEMORY, SIZEOF BULLET	;HeapAlloc API : �b�襤���t���s��
																		;hHeap�ѼƴN�O�e���Ыذ�ɪ�^����y�`�AdwBytes�O�ݭn���t�����s�����r�`�ơA
																		;dwFlags�O�лx(HEAP_ZERO_MEMORY:�N���t�����s��0��l��)
																		;��^�ȬO���V���s���Ĥ@�Ӧr�`�����w
		mov pbullet_temp, eax											;�N���V�Ӥ��t�Ŷ��_�l��}�����Цs�J pbullet_temp
	;03.�N�l�u��� (bullet_temp) �s�J���t�X���Ŷ�
		mov esi, OFFSET bullet_temp
		mov edi, pbullet_temp
		mov ecx, 3
		cld
		rep movsd
		
		inc bullet_num			;�l�u�`��+1
		add y_v_temp, 1			;�U�@���l�u�Үg�X����V = �e�@���l�u����V+1
	;03.�N�l�u���� (pbullet_temp) �K�J�����l�u���Ъ��C�� (bullet_plist) ��
		;03-1.�j�M��e bullet_plist ���O�_�� 0 (�Ŷ���m)
		mov edi, OFFSET bullet_plist
		mov eax, 0
		mov ecx, bullet_num
		cld
		repne scasd
		jnz Add_bulletptr
		sub edi, 4
	Add_bulletptr:
		mov eax, pbullet_temp
		mov DWORD PTR [edi], eax
		pop edx
		pop ecx
		LOOP Create_Bullet
	ret
Shoot_Bullet ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Move_Bullet : ���ʤl�u
; 1.�q bullet_plist ���X�l�u���СA�æs�JLOCAL�ܼ� bulletptr
; 2.�̨��X������(bulletptr) ���X�l�u���
; 3.���h������l�u
; 4.��s�l�u��m���ˬd�l�u�O�_�X��
; 5.�I�s Check_Hit �ˬd�O�_�����ĤH
; 6.�b�s��m���sø�W�l�u�ή��h�l�u(�X�ɩ������ĤH)
; 7.���ƥH�W�ʧ@���ܱN�e�����C�Ӥl�u�s���L�@�M (�j�馸�� = bullet_num)
;---------------------------------------------------------------------------------------------------------------------------------
Move_Bullet PROC USES esi 
	LOCAL bulletptr
	mov esi, OFFSET bullet_plist
	mov ecx, bullet_num
	;01.�q bullet_plist �̧Ǩ��X�l�u����
	Load_Bullet:
		mov eax, DWORD PTR [esi]
		add esi, 4
		cmp eax, 0							;�Y�� 0 �A��ܬ��Ŷ���m�A�S�����
		je Load_Bullet
		mov	bulletptr, eax					;�N���X�����Цs�JLOCAL�ܼ� bulletptr
		mov edi, bulletptr
		push ecx							;���Jecx ( = ��e�j�馸��)
	;02.�����l�u
		INVOKE BitBlt,	hgame_DC, (BULLET PTR [edi]).x, (BULLET PTR [edi]).y,
						bullet_w, bullet_h,
						hback_DC, (BULLET PTR [edi]).x, (BULLET PTR [edi]).y,
						SRCCOPY
	;03.��s�l�u��m���ˬd�l�u�O�_�X��
		;03-1.�ˬdX��V���
		mov eax, (BULLET PTR [edi]).x
		add eax, bullet_speed
		cmp eax, win_w						;����l�u�����M�e���k��
		jg B_Out_Bound
		;03-2.�ˬdY��V���
		mov edx, (BULLET PTR [edi]).y
		cmp (BULLET PTR [edi]).y_v, 0		;�T�{�l�u����V
		je Check_B_Hit
		jl B_y_v_up
		add edx, (bullet_speed / 10)
		cmp edx, win_h						;����l�u���ݩM�e������
		jg B_Out_Bound
		jmp Check_B_Hit
	B_y_v_up:								;y_v == -1�A�l�u�V�W����
		sub edx, (bullet_speed / 10)
		push edx
		add edx, bullet_h
		cmp edx, 0							;����l�u���ݩM�e������
		pop edx
		jl B_Out_Bound
	;04.�ˬd�O�_�����ĤH
	Check_B_Hit:
		mov (BULLET PTR [edi]).x, eax
		mov (BULLET PTR [edi]).y, edx
		.if enemy_num <= 0					;�Y�ĤH�Ƭ� 0 �h���L�ˬd (Check_Hit)
			jmp @F
		.endif
		INVOKE Check_Hit ,(BULLET PTR [edi]).x,  (BULLET PTR [edi]).y
		cmp hit_flag, 1						;�P�_�O�_���� (hit_flag == 1)
		je B_Hit
	;05.���sø�W�l�u
		@@:
		INVOKE BitBlt,	hgame_DC, (BULLET PTR [edi]).x, (BULLET PTR [edi]).y,
						bullet_w, bullet_h,
						hbullet_mask_DC,	0, 0,
						SRCPAINT
		INVOKE BitBlt,	hgame_DC, (BULLET PTR [edi]).x, (BULLET PTR [edi]).y,
						bullet_w, bullet_h,
						hbullet_DC,	0, 0,
						SRCAND
		pop ecx
		dec ecx
		jnz Load_Bullet
		ret
	;06.���h�l�u (�X�ɩ������ĤH)
	B_Hit:
		mov hit_flag, 0										;�P�_�����ĤH�h�N hit_flag ��l�Ʀ^ 0
	B_Out_Bound:
		;06-1.����Ӥl�u�Ҧ����O����Ŷ�
		INVOKE HeapFree, hbulletHeap, NULL, bulletptr		;HeapFree������t�쪺���s��
															;hHeap�ѼƬO��y�`�AlpMemory�OHeapAlloc��ƪ�^�����s�����w�AdwFlags
		pop ecx												;���X(��e�j�馸��)��Jecx
		;06-2.��s�����l�u���Ъ��C�� (bullet_plist)
		push esi
		sub esi, 4
		mov DWORD PTR [esi], 0								;�N�Ӥl�u���Цb bullet_plist ������m���ȳ]�� 0�A��ܬ��Ŷ���m
		pop esi
		dec bullet_num										;�l�u�ƥ�-1
		dec ecx
		jnz Load_Bullet
		ret
Move_Bullet ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Create_Enemy : �ͦ��ĤH
; 1.�H�H���üƥͦ��ĤH��� (�_�l��m�B��V�B������) �æs�J�Ȧs�Ϊ�ENEMY�ܼ� enemy_temp ��
; 2.���t�X�@�ӼĤH (ENEMY) ���O����Ŷ��A�ñN���V�ӪŶ��_�l��}�����Цs�JLOCAL�ܼ� penemy_temp
; 3.�N enemy_temp ����ƥHmovsd, movsb�� �s�J���t�X���Ŷ� 
; 3.�N penemy_temp �[�J�x�s�C�Ӥl�u���� (ENEMY PTR) ���C�� enemy_plist ��
; 3-1.�j�M enemy_plist ���O�_�� 0 �A�Y���h��ܸ��x�s���Ъ���m���Ŷ��A�H penemy_temp �л\�A�Y�L�h�N penemy_temp �K�ܦC�����
;---------------------------------------------------------------------------------------------------------------------------------
Create_Enemy PROC USES esi ,hWnd:HWND, uMsg:UINT,idEvent:UINT, dwTime:DWORD
	LOCAL penemy_temp:DWORD
	;01.�H�H���üƥͦ��ĤH���
	;01-1.�ͦ��ĤH�_�lY�y��
		INVOKE nrandom, 10
		mov edx, eax
		shl eax, 1
		add eax, edx
		shl eax, 4
		mov enemy_temp.y, eax			
	;01-2.�ͦ��ĤHY�b�W����V (-1 = �V�W, 0 = ���u, 1 = �V�U)
		INVOKE nrandom, 3
		mov enemy_temp.y_v, al
		sub enemy_temp.y_v, 1
	;01-3.�P�_�ӰT���ѭ��өw�ɾ��o�X�H�M�w�ĤH����
		.if idEvent == 4					;IDT_TIMER4
			mov enemy_temp.e_type, 0		;e_type = 0 (�Ŧ�@�i��)
		.elseif idEvent == 5				;IDT_TIMER5
			mov enemy_temp.e_type, 1		;e_type = 1 (����@�i��)
		.elseif idEvent == 6				;IDT_TIMER6
			mov enemy_temp.e_type, 2		;e_type = 2 (���@�i��)
		.endif
	;02.���t�O����Ŷ�
		INVOKE HeapAlloc, henemyHeap, HEAP_ZERO_MEMORY, SIZEOF ENEMY
		mov penemy_temp, eax				;�N���V�Ӥ��t�Ŷ��_�l��}�����Цs�J penemy_temp
	;03.�N�ĤH��� (enemy_temp) �s�J���t�X���Ŷ�
		mov esi, OFFSET enemy_temp
		mov edi, penemy_temp
		cld
		movsd
		movsd
		movsb
		movsb

		inc enemy_num						;�ĤH�ƥ�+1
	;04.�N�ĤH���� (penemy_temp) �K�J�����ĤH���Ъ��C�� (enemy_plist) ��
		;04-1.�j�M��e enemy_plist ���O�_�� 0 (�Ŷ���m)
		mov edi, OFFSET enemy_plist
		mov eax, 0
		mov ecx, enemy_num
		cld
		repne scasd
		jnz Add_enemyptr
		sub edi, 4
	Add_enemyptr:
		mov eax, penemy_temp
		mov DWORD PTR [edi], eax
		ret
Create_Enemy ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Move_Enemy : ���ʼĤH
; 1.�q enemy_plist ���X�ĤH���СA�æs�JLOCAL�ܼ� enemyptr
; 2.�̨��X������ (enemyptr) ���X�ĤH���
; 3.���h������ĤH
; 4.��s�ĤH��m���ˬd�ĤH�O�_�X�ɩM��������
; 5.�ˬd�ĤH�M�H�����I��(�O�_�����H��)
; 6.�b�s��m���sø�W�ĤH�ή��h�ĤH(�X�ɡB���������������H��)
; 7.���ƥH�W�ʧ@���ܱN�e�����C�ӼĤH�s���L�@�M (�j�馸�� = enemy_num)
;---------------------------------------------------------------------------------------------------------------------------------
Move_Enemy PROC USES edi esi
	LOCAL enemyptr:DWORD
	mov esi, OFFSET enemy_plist
	mov ecx, enemy_num
	;01.�q enemy_plist �̧Ǩ��X�ĤH����
	Load_Enemy:
		mov eax, DWORD PTR [esi]
		add esi, 4
		cmp eax, 0							;�Y�� 0 �A��ܬ��Ŷ���m�A�S�����
		je Load_Enemy
		mov	enemyptr, eax					;�N���X�����Цs�JLOCAL�ܼ� enemyptr
		mov edi, enemyptr
		push ecx							;���Jecx ( = ��e�j�馸��)
		movzx ecx, (ENEMY PTR [edi]).e_type
		shl ecx, 2
		push ecx							;���Jecx ( = (��e�ĤH����)*2 )
	;02.�����l�u
		INVOKE BitBlt,	hgame_DC,
						(ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						enemy_w[ecx], enemy_h[ecx],
						hback_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						SRCCOPY
		pop ecx								;���X ((��e�ĤH����)*2) ��Jecx
	;03.��s�ĤH��m���ˬd�ĤH�O�_�X��	
	;03-1.��s�ĤHX�y��
		mov eax, (ENEMY PTR [edi]).x
		sub eax, enemy_speed[ecx]

		mov (ENEMY PTR [edi]).x, eax
		add eax, enemy_w[ecx]				;eax = �ĤH�k��
	;03-2.�P�_�ĤH�����ʤ�V�ç�s�ĤHY�y��
		mov edx, (ENEMY PTR [edi]).y
		cmp (ENEMY PTR [edi]).y_v, 0
		je @F
		jl y_v_up
		add edx, enemy_speed[ecx]
		jmp @F
	y_v_up:									;y_v == -1�A�ĤH�V�W����
		sub edx, enemy_speed[ecx]
		@@:
		mov (ENEMY PTR [edi]).y, edx
	;03-3.�ˬdX��V���
		cmp eax, 0							;����ĤH�k���M�e������
		jl E_Out_Bound
	;03-4.�ˬd�O�_��������
		cmp eax, castle_w					;����ĤH�k���M�����k��
		jl Minus_Life						;�Y�P�_���������h���� Minus_Life
	;03-5.�ˬdY��V���
		cmp edx, 0							;����ĤH���ݩM�e������
		jg Bottom_Bound
		mov (ENEMY PTR [edi]).y_v, 1		;�IĲ������ɫh�ϼu�A�N y_v �]�� 1 (�V�U)
	Bottom_Bound:
		add edx, enemy_h[ecx]
		.if edx >= win_h					;����ĤH���ݩM�e������
			mov (ENEMY PTR [edi]).y_v, -1	;�IĲ������ɫh�ϼu�A�N y_v �]�� -1 (�V�W)
		.endif
	;04.�ˬd�O�_�����H��
		mov edx, character_x
		add edx, (character_w / 4)
		cmp eax, edx						;����ĤH�k���M�H������
		jl No_Hit_C
		mov eax, character_x
		add eax, (character_w * 3 / 4)
		cmp eax, (ENEMY PTR [edi]).x		;����H���k���M�ĤH����
		jl No_Hit_C
		mov eax, character_y
		add eax, (character_h * 4 / 5)
		cmp eax, (ENEMY PTR [edi]).y		;����H�����ݩM�ĤH����
		jl No_Hit_C
		mov eax, (ENEMY PTR [edi]).y
		add eax, enemy_h[ecx]
		mov edx, character_y
		add edx, (character_h / 5)
		cmp eax, edx 						;����ĤH���ݩM�H������
		jg E_Hit_C							;�Y�P�_�����H���h���� E_Hit_C
	;05.���sø�W�ĤH
	No_Hit_C:
		push ecx
		INVOKE BitBlt,	hgame_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						enemy_w[ecx], enemy_h[ecx], 
						henemy_mask_DC[ecx], 0, 0,
						SRCPAINT
		pop ecx
		INVOKE BitBlt,	hgame_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						enemy_w[ecx], enemy_h[ecx],
						henemy_DC[ecx], 0, 0,
						SRCAND
		pop ecx
		dec ecx
		jnz Load_Enemy
		ret
	;06.�P�_�ĤH�����H���A�����H���ê�l�ƤH���ƭ�
	E_Hit_C:
	;06-1.�����H��
		INVOKE BitBlt,	hgame_DC, character_x, character_y,
						character_w, character_h,
						hback_DC, character_x, character_y,
						SRCCOPY
		mov character_x, castle_w				;�N�H��X�y�г]�^��l��
		mov character_y, 165					;�N�H��Y�y�г]�^��l��
		mov character_speed, 12					;�N�H�����ʳt�׳]�^��l��
		mov shoot_time, 440						;�N�g���ɶ����j�]�^��l��
		INVOKE SetTimer, hstartWin, IDT_TIMER3, shoot_time, NULL
		CALL Draw_character
	;06-2.�ͩR�ƴ�֨����h�ͩR�Ϥ�
	Minus_Life:
		dec life
		INVOKE Erase_life, life
		.if life == 0									;�Ylife = 0 �h�C������
			INVOKE PostMessage, hstartWin, WM_GAMEOVER,	;�o�e WM_GAMEOVER �۩w�q�T���ܥD���f
								NULL, NULL
			ret
		.endif
	;07.���h�ĤH(�X�ɡB���������������H��)
	E_Out_Bound:
		;07-1.����ӼĤH�Ҧ����O����Ŷ�
		INVOKE HeapFree, henemyHeap, NULL, enemyptr
		pop ecx											;���X(��e�j�馸��)��Jecx
		;07-2.��s�����ĤH���Ъ��C�� (enemy_plist)
		push esi
		sub esi, 4
		mov DWORD PTR [esi], 0							;�N�ӼĤH���Цb enemy_plist ������m���ȳ]�� 0�A��ܬ��Ŷ���m
		pop esi
		dec enemy_num									;�ĤH�ƥ�-1
		dec ecx
		jnz Load_Enemy
		ret
Move_Enemy ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Check_Hit : �ˬd��e�l�u�P�ĤH���I�� (�O�_�����ĤH)
; 1.�q enemy_plist ���X�ĤH���СA�ę̀��X������Ū�J�ĤH���
; 2.����e�l�u�P�ӼĤH���y�СA�ˬd�O�_�����ӼĤH
; 3.�Y�����h���h�ӼĤH�ê�^
; 4.���ƥH�W�ʧ@���ܱN�e�����C�ӼĤH�Ҥ��L�@�M (�j�馸�� = enemy_num)
;---------------------------------------------------------------------------------------------------------------------------------
Check_Hit PROC USES ecx esi edi, b_X:SDWORD, b_Y:SDWORD
		mov eax, b_X
		mov edx, b_Y
		mov esi, OFFSET enemy_plist
		mov ecx, enemy_num
	;01.�q enemy_plist �̧Ǩ��X�ĤH����
	_Load_Enemy:
		mov eax, DWORD PTR [esi]
		add esi, 4
		cmp eax, 0								;�Y�� 0 �A��ܬ��Ŷ���m�A�S�����
		je _Load_Enemy
		mov edi, eax
		push ecx								;���Jecx ( = ��e�j�馸��)
		movzx ecx, (ENEMY PTR [edi]).e_type
		shl ecx, 2								;ecx = (��e�ĤH����)*2 
	;02.�ˬd�O�_�����ӼĤH
	;02-1.����e�l�u�P�ӼĤH��X�y��
		mov eax, (ENEMY PTR [edi]).x			;eax = �ĤH����
		mov edx, eax
		add edx, enemy_w[ecx]					;edx = �ĤH�k��
		cmp edx, b_X							;����ĤH�k���M�l�u����
		jl No_Hit
		add b_X, bullet_w						;b_X = �l�u�k��
		cmp eax, b_X							;����ĤH�����M�l�u�k��
		jg No_Hit
	;02-1.����e�l�u�P�ӼĤH��Y�y��
		mov eax, (ENEMY PTR [edi]).y			;eax = �ĤH����
		mov edx, eax
		add edx, enemy_h[ecx]					;edx = �ĤH����
		cmp edx, b_Y							;����ĤH���ݩM�l�u����
		jl No_Hit
		add b_Y, bullet_h						;b_Y = �l�u����
		cmp eax, b_Y							;����ĤH���ݩM�l�u����
		jg No_Hit
	;03.�����ӼĤH�A�h���h�ӼĤH�ñN hit_flag �]�� 1 ���^
	Hit:
	;03-1.�����ӼĤH
		INVOKE BitBlt,	hgame_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						enemy_w[ecx], enemy_h[ecx],
						hback_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						SRCCOPY
	;03-2.����ӼĤH�Ҧ����O����Ŷ�
		INVOKE HeapFree, henemyHeap, NULL, edi
	;03-3.��s�����ĤH���Ъ��C�� (enemy_plist)
		sub esi, 4
		mov DWORD PTR [esi], 0					;�N�ӼĤH���Цb enemy_plist ������m���ȳ]�� 0�A��ܬ��Ŷ���m
		pop ecx									;���X(��e�j�馸��)��Jecx
		dec enemy_num	
		mov hit_flag, 1							;�N hit_flag �]�� 1 �A��ܦ�����
		ret
	;04.�L����
	No_Hit:
		pop ecx									;���X(��e�j�馸��)��Jecx
		dec ecx
		jnz _Load_Enemy
	ret
Check_Hit ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Create_Item : �ͦ��D��
;(((((�ڤ��Q�g�A�۱��F)))))
;---------------------------------------------------------------------------------------------------------------------------------
Create_Item PROC USES edi eax edx ecx ,hWnd:HWND, uMsg:UINT,idEvent:UINT, dwTime:DWORD
	LOCAL temp_w : DWORD
	LOCAL temp_h : DWORD
	.if item_num >= 5
		ret
	.endif
	mov edi, item_end
	mov eax, (ITEM PTR item_list[edi]).x
	movzx ecx, (ITEM PTR item_list[edi]).i_type
	shl ecx, 2
	.if eax != 0
		INVOKE BitBlt,	hback_DC, (ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
						item_w[ecx], item_h[ecx],
						hback_erase_DC, (ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
						SRCCOPY
		INVOKE BitBlt,	hgame_DC, (ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
						item_w[ecx], item_h[ecx],
						hback_DC, (ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
						SRCCOPY
		sub item_num, 1
	.endif
	INVOKE nrandom, 3
	mov (ITEM PTR item_list[edi]).i_type, al
	movzx ecx, (ITEM PTR item_list[edi]).i_type
	shl ecx, 2
	push ecx
	mov edx, item_w[ecx]
	mov temp_w, edx
	mov edx, item_h[ecx]
	mov temp_h, edx
	INVOKE nrandom, 10
	mov edx, eax
	shl eax, 4
	sub eax, edx
	shl eax, 2
	add eax, 180
	mov (ITEM PTR item_list[edi]).x, eax
	
	INVOKE nrandom, 4
	shl eax, 6
	add eax, 64
	mov (ITEM PTR item_list[edi]).y, eax
	pop ecx
	push ecx
	INVOKE BitBlt,  hgame_DC,
					(ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
					temp_w,temp_h,
					hitem_mask_DC[ecx], 0, 0,
					SRCPAINT
	pop ecx
	push ecx
	INVOKE BitBlt,  hgame_DC,
					(ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
					temp_w,temp_h,
					hitem_DC[ecx], 0, 0,
					SRCAND
	pop ecx
	push ecx
	INVOKE BitBlt,  hback_DC,
					(ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
					temp_w,temp_h,
					hitem_mask_DC[ecx], 0, 0,
					SRCPAINT
	pop ecx
	push ecx
	INVOKE BitBlt,  hback_DC,
					(ITEM PTR item_list[edi]).x, (ITEM PTR item_list[edi]).y,
					temp_w,temp_h,
					hitem_DC[ecx], 0, 0,
					SRCAND
	pop ecx
	.if item_num < 5
		add item_num, 1
	.endif
	add item_end, SIZEOF ITEM
	.if item_end >= 45
		mov item_end, 0
	.endif
	
	ret
Create_Item ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Check_Item : �ˬd�D��P�H�����I�� (�O�_���o�D��)
;---------------------------------------------------------------------------------------------------------------------------------
Check_Item PROC USES esi ecx eax edx
		.if item_num == 0
			ret
		.endif
		mov ecx, 5
		mov esi, 0
	Load_Item:
		mov eax, (ITEM PTR item_list[esi]).x
		.if eax == 0
			add esi, SIZEOF ITEM
			LOOP Load_Item
			ret
		.endif
		movzx edx, (ITEM PTR item_list[esi]).i_type
		shl edx, 2
		mov eax, (ITEM PTR item_list[esi]).x
		add eax, item_w[edx]
		cmp eax, character_x						;����D��k���M�H������
		jl No_Get_I
		mov eax, character_x
		add eax, character_w
		cmp eax, (ITEM PTR item_list[esi]).x		;����H���k���M�D�㥪��
		jl No_Get_I
		mov eax, character_y
		add eax, character_h
		cmp eax, (ITEM PTR item_list[esi]).y		;����H�����ݩM�D�㳻��
		jl No_Get_I
		mov eax, (ITEM PTR item_list[esi]).y
		add eax, item_h[edx]
		cmp eax, character_y						;����D�㩳�ݩM�H������
		jg C_Get_I
	No_Get_I:
		add esi, SIZEOF ITEM
		LOOP Load_Item
		ret
	C_Get_I:
		push ecx
		push edx
		INVOKE BitBlt,	hback_DC, (ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
						item_w[edx], item_h[edx],
						hback_erase_DC, (ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
						SRCCOPY
		pop edx
		INVOKE BitBlt,	hgame_DC, (ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
						item_w[edx], item_h[edx],
						hback_DC, (ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
						SRCCOPY
		movzx edx, (ITEM PTR item_list[esi]).i_type
		.if edx == 0
			.if character_speed < 20
				add character_speed, 2
			.endif
		.elseif edx == 1
			.if shoot_time > 220
				sub shoot_time, 55
				INVOKE SetTimer, hstartWin, IDT_TIMER3, shoot_time, NULL
			.endif
		.elseif edx == 2
			.if life < 5
				add life, 1
				CALL Draw_Life
			.endif
		.endif
		mov (ITEM PTR item_list[esi]).x, 0
		.if item_num > 0
			sub item_num, 1
		.endif
		add esi, SIZEOF ITEM
		pop ecx
		dec ecx
		jnz Load_Item
	ret
Check_Item ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Delete_Item : ���h�D��A�H��{�D��@�w�ɶ���۰ʮ������ĪG
;---------------------------------------------------------------------------------------------------------------------------------
Delete_Item PROC USES edi eax edx ecx ,hWnd:HWND, uMsg:UINT,idEvent:UINT, dwTime:DWORD
	.if item_num == 0
		ret
	.endif
	mov esi, item_start
	mov edx, (ITEM PTR item_list[esi]).x
	.if edx == 0
		add item_start, SIZEOF ITEM
		.if item_start >= 45
			mov item_start, 0
		.endif 
		ret
	.endif
	movzx edx, (ITEM PTR item_list[esi]).i_type
	shl edx, 2
	push edx
	INVOKE BitBlt,  hback_DC,
					(ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
					item_w[edx],item_h[edx],
					hback_erase_DC, (ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
					SRCCOPY
	pop edx
	INVOKE BitBlt,  hgame_DC,
					(ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
					item_w[edx],item_h[edx],
					hback_DC, (ITEM PTR item_list[esi]).x, (ITEM PTR item_list[esi]).y,
					SRCCOPY
	add item_start, SIZEOF ITEM
	.if item_start >= 45
		mov item_start, 0
	.endif 
	mov (ITEM PTR item_list[esi]).x, 0
	sub item_num, 1
	ret
Delete_Item ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Draw_Life : ø�s�ͩR�Ϥ� (�e���k�W��)
;---------------------------------------------------------------------------------------------------------------------------------
Draw_Life PROC 
	mov eax, 5
	sub al, life
	shl eax, 2
	mov eax, life_x[eax]
	push eax
	INVOKE BitBlt,  hback_DC,
					eax, 0,
					75,30,
					hlife_mask_DC, 0, 0,
					SRCPAINT
	pop eax
	push eax
	INVOKE BitBlt,  hback_DC,
					eax, 0,
					75,30,
					hlife_DC, 0, 0,
					SRCAND
	pop eax
	push eax
	INVOKE BitBlt,  hgame_DC,
					eax, 0,
					75,30,
					hlife_mask_DC, 0, 0,
					SRCPAINT
	pop eax
	INVOKE BitBlt,  hgame_DC,
					eax, 0,
					75,30,
					hlife_DC, 0, 0,
					SRCAND
	ret
Draw_Life ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Erase_Life : ���h�ͩR�Ϥ� (�e���k�W��)
;---------------------------------------------------------------------------------------------------------------------------------
Erase_life PROC USES eax ecx edx,c_life:BYTE
	mov eax, 5
	sub al, c_life
	sub eax, 1
	shl eax, 2
	mov eax, life_x[eax]
	push eax
	INVOKE BitBlt,  hgame_DC,
					eax, 0,
					75,30,
					hback_erase_DC, 0, 0,
					SRCCOPY
	pop eax
	INVOKE BitBlt,  hback_DC,
					eax, 0,
					75,30,
					hback_erase_DC, 0, 0,
					SRCCOPY
	ret
Erase_life ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Game_Win : ø�s�C���L���Ϥ�
;---------------------------------------------------------------------------------------------------------------------------------
Game_Win PROC
	LOCAL @hDC
	LOCAL @hwin_DC, @hwin_mask_DC
	LOCAL @hwin_BMP, @hwin_mask_BMP
		
		INVOKE GetDC, hstartWin
		mov @hDC, eax
		
		INVOKE CreateCompatibleDC,	@hDC
		mov @hwin_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov @hwin_mask_DC, eax
		
		INVOKE LoadBitmap, hInstance, IDB_BITMAP13
		mov @hwin_BMP, eax
		INVOKE SelectObject, @hwin_DC, @hwin_BMP
		INVOKE LoadBitmap, hInstance, IDB_BITMAP14
		mov @hwin_mask_BMP, eax
		INVOKE SelectObject, @hwin_mask_DC, @hwin_mask_BMP

		INVOKE BitBlt,	hgame_DC,((win_w / 2) - 206),0,413,480,
						@hwin_mask_DC,0,0,
						SRCPAINT
		
		INVOKE BitBlt,	hgame_DC,((win_w / 2) - 206),0, 413, 480,
						@hwin_DC,0, 0, 
						SRCAND

		INVOKE DeleteDC, @hwin_DC
		INVOKE DeleteObject, @hwin_BMP

		INVOKE DeleteDC, @hwin_mask_DC
		INVOKE DeleteObject, @hwin_mask_BMP
		
		INVOKE ReleaseDC, hstartWin, @hDC
		INVOKE InvalidateRect, hstartWin,0,1
		ret
Game_Win ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Game_Over : ø�s�C�����ѹϤ�
;---------------------------------------------------------------------------------------------------------------------------------
Game_Over PROC
	LOCAL @hDC
	LOCAL @hgameover_DC, @hgameover_mask_DC
	LOCAL @hgameover_BMP, @hgameover_mask_BMP
		
		INVOKE GetDC, hstartWin
		mov @hDC, eax
		
		INVOKE CreateCompatibleDC,	@hDC
		mov @hgameover_DC, eax
		INVOKE CreateCompatibleDC,	@hDC
		mov @hgameover_mask_DC, eax
		
		INVOKE LoadBitmap, hInstance, IDB_BITMAP11
		mov @hgameover_BMP, eax
		INVOKE SelectObject, @hgameover_DC, @hgameover_BMP
		INVOKE LoadBitmap, hInstance, IDB_BITMAP12
		mov @hgameover_mask_BMP, eax
		INVOKE SelectObject, @hgameover_mask_DC, @hgameover_mask_BMP

		INVOKE BitBlt,	hgame_DC,((win_w / 2) - 145),0,290,480,
						@hgameover_mask_DC,0,0,
						SRCPAINT
		
		INVOKE BitBlt,	hgame_DC,((win_w / 2) - 145),0, 290, 480,
						@hgameover_DC,0, 0, 
						SRCAND

		INVOKE DeleteDC, @hgameover_DC
		INVOKE DeleteObject, @hgameover_BMP

		INVOKE DeleteDC, @hgameover_mask_DC
		INVOKE DeleteObject, @hgameover_mask_BMP
		
		INVOKE ReleaseDC, hstartWin, @hDC
		INVOKE InvalidateRect, hstartWin,0,1
		ret
Game_Over ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Quit_Game : �����{�Ǯɪ������A�]�t����p����(Heap)�B�]�Ƥ��e(DC)�B�줸�Ϫ���
;---------------------------------------------------------------------------------------------------------------------------------
Quit_Game PROC
		
		INVOKE HeapDestroy, hbulletHeap						;HeapDestroy API : ������w�p����(Heap)
		INVOKE HeapDestroy, henemyHeap
		
		INVOKE DeleteDC, hgame_DC							;DeleteDC API:������w���˸m���e�C�Y���\�A�h EAX �Ǧ^�D�s��
		INVOKE DeleteDC, hback_DC

		INVOKE DeleteDC, hcastle_DC
		INVOKE DeleteDC, hcastle_mask_DC
		
		INVOKE DeleteDC, hcharacter_DC
		INVOKE DeleteDC, hcharacter_mask_DC
		
		INVOKE DeleteDC, henemy_DC [8]
		INVOKE DeleteDC, henemy_mask_DC [8]
		INVOKE DeleteDC, henemy_DC [4]
		INVOKE DeleteDC, henemy_mask_DC [4]
		INVOKE DeleteDC, henemy_DC [0]
		INVOKE DeleteDC, henemy_mask_DC [0]

		INVOKE DeleteDC, hitem_DC [8]
		INVOKE DeleteDC, hitem_mask_DC [8]
		INVOKE DeleteDC, hitem_DC [4]
		INVOKE DeleteDC, hitem_mask_DC [4]
		INVOKE DeleteDC, hitem_DC [0]
		INVOKE DeleteDC, hitem_mask_DC [0]
		
		INVOKE DeleteDC, hbullet_DC
		INVOKE DeleteDC, hbullet_mask_DC

		INVOKE DeleteDC, hlife_DC
		INVOKE DeleteDC, hlife_mask_DC

		INVOKE DeleteObject, hback_BMP						;DeleteObject API:�ΨӧR���e���B����B�r���B�줸�ϡB�d��Ωνզ�L ( Palette )�A�H�`�ٸ귽�C
															;hObject �O�n�R��������N�X�CDeleteObject ���\�R������ɡA�|�Ǧ^�D�s��
		INVOKE DeleteObject, hcastle_BMP
		INVOKE DeleteObject, hcastle_mask_BMP
		
		INVOKE DeleteObject, hcharacter_BMP
		INVOKE DeleteObject, hcharacter_mask_BMP
		
		INVOKE DeleteObject, henemy_BMP[8]
		INVOKE DeleteObject, henemy_mask_BMP[8]
		INVOKE DeleteObject, henemy_BMP[4]
		INVOKE DeleteObject, henemy_mask_BMP[4]
		INVOKE DeleteObject, henemy_BMP[0]
		INVOKE DeleteObject, henemy_mask_BMP[0]
	
		INVOKE DeleteObject, hbullet_BMP
		INVOKE DeleteObject, hbullet_mask_BMP
	
		INVOKE DeleteObject, hitem_BMP[8]
		INVOKE DeleteObject, hitem_mask_BMP[8]
		INVOKE DeleteObject, hitem_BMP[4]
		INVOKE DeleteObject, hitem_mask_BMP[4]
		INVOKE DeleteObject, hitem_BMP[0]
		INVOKE DeleteObject, hitem_mask_BMP[0]
		
		INVOKE DeleteObject, hlife_BMP
		INVOKE DeleteObject, hlife_mask_BMP
	
		ret
Quit_Game ENDP

END main