.386							;宣告可以使用80386指令集(Win32系統必須在80386以上的CPU才能執行)
.model flat, stdcall			;指定記憶體模式(平坦模式)以及呼叫協定(告訴組譯器最右邊的參數最先推入堆疊)
option casemap:none				;告訴組譯器，ML.EXE，使用我們所定義的變數名稱、標記名稱、Win32 API名稱等等是區分大小寫的

INCLUDE         windows.inc
INCLUDE         user32.inc
INCLUDE         kernel32.inc
INCLUDE			gdi32.inc
INCLUDE			masm32.inc
;*********************************************************************************************************************************
;定義各物件識別碼的數值，此數值和資源描述檔中的識別碼相同，這些數值都不會改變，故用 equ 假指令設定為常數。
;*********************************************************************************************************************************
;位圖ID(一個數字)，在程式裡以IDB_BITMAPxx表示
;位圖ID是在資源檔(.rc)裡為每個位圖資源(XX.bmp之類)所設的識別碼
;
;p122(第五章:使用資源), p144(5.3.2:在資源中定義位圖)
;
;個人理解:
;將一個bmp圖片(依檔名(xx.bmp))放進資源檔(.rc)裡面，並給它一個身分認證用的數字名牌(位圖ID)
;之後要取用放在資源檔裡的任何資源，都是依照ID(數字名牌)來尋找和取出相對應的資源。(檔名(像xx.bmp...)只會出現在資源檔裡定義資源時)
;---------------------------------------------------------------------------------------------------------------------------------
IDB_BITMAP1  EQU 101			;character.bmp 		角色圖片
IDB_BITMAP2  EQU 102			;character_mask.bmp 角色遮罩圖
IDB_BITMAP3  EQU 103			;enemy.bmp			敵人圖片#0	(藍色咖波貓)
IDB_BITMAP4  EQU 104			;enemy_mask.bmp		敵人遮罩圖#0	(藍色咖波貓)
IDB_BITMAP5  EQU 105			;bullet.bmp			子彈圖片
IDB_BITMAP6  EQU 106			;bullet_mask.bmp	子彈遮罩圖
IDB_BITMAP7  EQU 107			;castle.bmp			城堡圖片
IDB_BITMAP8  EQU 108			;castle_mask.bmp	城堡遮罩圖
IDB_BITMAP9  EQU 109			;life.bmp			生命圖片
IDB_BITMAP10 EQU 110			;life_mask.bmp		生命遮罩圖
IDB_BITMAP11 EQU 111			;game_over.bmp		遊戲失敗圖片
IDB_BITMAP12 EQU 112			;game_over_mask.bmp	遊戲失敗遮罩圖
IDB_BITMAP13 EQU 113			;win.bmp			遊戲過關圖片
IDB_BITMAP14 EQU 114			;win_mask.bmp		遊戲過關遮罩圖
IDB_BITMAP15 EQU 115			;background.bmp		背景填充圖片
IDB_BITMAP16 EQU 116			;enemy1.bmp			敵人圖片#1	(紅色咖波貓)
IDB_BITMAP17 EQU 117			;enemy1_mask.bmp	敵人遮罩圖#1	(紅色咖波貓)
IDB_BITMAP18 EQU 118			;enemy2.bmp			敵人圖片#2	(綠色咖波貓)
IDB_BITMAP19 EQU 119			;enemy2_mask.bmp	敵人遮罩圖#2	(綠色咖波貓)
IDB_BITMAP20 EQU 122			;item.bmp			道具圖片#0	(巧克力冰棒)
IDB_BITMAP21 EQU 123			;item_mask.bmp		道具遮罩圖#0	(巧克力冰棒)
IDB_BITMAP22 EQU 124			;item1.bmp			道具圖片#1	(奶泡貓)
IDB_BITMAP23 EQU 125			;item1_mask.bmp		道具遮罩圖#1	(奶泡貓)
;---------------------------------------------------------------------------------------------------------------------------------
;其他資源識別碼
;光標ID(一個數字)，在程式裡以IDC_CURSORxx表示
;圖示ID(一個數字)，在程式裡以IDI_ICONxx表示
;---------------------------------------------------------------------------------------------------------------------------------
IDC_CURSOR1  EQU 120       		;cursor.cur			光標圖片
IDI_ICON1    EQU 121            ;icon.ico     		遊戲圖示
;---------------------------------------------------------------------------------------------------------------------------------
;用戶自定義消息 (WM_XXX)
;定義自定義消息的值(uMsg)，以系統已使用的預設消息值之後(0000h~03ffh)的數值WM_USER(=0400h)開始使用
;當發生指定狀況時，以PostMessg發送指定的自定義消息至主窗口，以使主窗口作相應的處理
;---------------------------------------------------------------------------------------------------------------------------------
WM_WIN       EQU WM_USER		;遊戲過關消息 (0400h)
WM_GAMEOVER  EQU WM_USER+1		;遊戲失敗消息 (0401h)
;---------------------------------------------------------------------------------------------------------------------------------
;定時器識別碼
;定時器ID(一個數字)，在程式裡以IDT_TIMERxx表示
;---------------------------------------------------------------------------------------------------------------------------------
IDT_TIMER1 	EQU 1				;定時器 : 遊戲畫面刷新		時間 :    55	毫秒
IDT_TIMER2 	EQU 2				;定時器 : 遊戲時間倒數		時間 :  1000	毫秒
IDT_TIMER3 	EQU 3				;定時器 : 射擊時間間隔		時間 :   440	毫秒	(隨變數shoot_time(預設為440)改變)
IDT_TIMER4 	EQU 4				;定時器 : 敵人生成間隔		時間 :	550	毫秒	(藍色咖波貓)
IDT_TIMER5 	EQU 5				;定時器 : 敵人生成間隔		時間 :  1705	毫秒	(紅色咖波貓)
IDT_TIMER6 	EQU 6				;定時器 : 敵人生成間隔		時間 :   220	毫秒	(綠色咖波貓)
IDT_TIMER7 	EQU 7				;定時器 : 道具生成間隔		時間 :  3000	毫秒
IDT_TIMER8 	EQU 8				;定時器 : 道具消失間隔		時間 :  3000	毫秒
;---------------------------------------------------------------------------------------------------------------------------------
;遊戲中固定的屬性數值，用 equ 假指令設定為常數。
;---------------------------------------------------------------------------------------------------------------------------------
win_w 		EQU 960				;視窗的寬，window_weight
win_h 		EQU 480				;視窗的高，window_height

castle_w 	EQU 123 			;城堡的寬，castle_weight
castle_h	EQU 480				;城堡的高，castle_height

character_w EQU 120				;角色的寬，character_weight
character_h EQU 150				;角色的高，character_height

bullet_w	 EQU 65				;子彈的寬，bullet_weight
bullet_h 	 EQU 25				;子彈的高，bullet_height
bullet_speed EQU 30				;子彈的速度
;---------------------------------------------------------------------------------------------------------------------------------
;函式PROTO
;---------------------------------------------------------------------------------------------------------------------------------
start_WinStruct PROTO			;建立視窗

WndProc PROTO hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 	
								;定義視窗對各個事件(像是按下滑鼠,按下鍵盤按鍵...)發生時要做什麼
								
Load_Image PROTO				;處理使用位元圖所需的初始化，像是創造虛擬設備環境(DC)和從資源檔(.rc)中以ID讀取位元圖
Show_Image PROTO				;刷新視窗畫面

Move_character PROTO			;移動角色
Draw_character PROTO			;繪製角色
Shoot_Bullet   PROTO 			;發射子彈 (分配出一個子彈的動態記憶體並加入子彈列表)
Move_Bullet    PROTO			;移動畫面中的子彈

Create_Item PROTO hWnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD	;生成道具，IDT_TIMER7的定時函數
Delete_Item PROTO hWnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD	;消去道具，IDT_TIMER8的定時函數 (經過一定時間後，道具自動消失)
																	
Check_Item 	PROTO				;檢查角色與道具的碰撞 (是否取得道具)

Draw_Life 	PROTO				;繪製生命圖案 (畫面右上角)，處理由取得道具所增加的生命圖案繪製		
Erase_life 	PROTO c_life:BYTE	;擦去生命圖案 (畫面右上角)，處理由接觸敵人所減少的生命圖案消去	

Create_Enemy PROTO hWnd:HWND, uMsg:UINT,idEvent:UINT, dwTime:DWORD	
								;生成敵人，IDT_TIMER4 (藍色咖波貓)、IDT_TIMER5(紅色咖波貓)、IDT_TIMER6(綠色咖波貓)的定時函數  
Move_Enemy 	PROTO				;移動畫面中的敵人

Check_Hit 	PROTO b_X:SDWORD, b_Y:SDWORD	;檢查子彈與敵人的碰撞 (是否擊中敵人)
	
Game_Win 	PROTO				;遊戲過關，顯示獲勝圖片
Game_Over 	PROTO				;遊戲失敗，顯示失敗圖片

Quit_Game PROTO					;結束遊戲，釋放虛擬設備環境和位圖物件、清除私有堆(Heap)等等
;*********************************************************************************************************************************
;程式資料段，定義結構和變數等等
;*********************************************************************************************************************************
.data
;---------------------------------------------------------------------------------------------------------------------------------
;視窗相關
;---------------------------------------------------------------------------------------------------------------------------------
hInstance HINSTANCE ?			;一個視窗類別(CLASS)的handle，視窗類別:用來創造出對應屬性視窗的模板(車的設計圖)
hstartWin HWND ?				;一個視窗(Object)的handle，貨真價實的視窗(車)

start_ClassName BYTE "START", 0 ;自定義的視窗類別(CLASS)的類別名稱

hgame_DC 	DWORD ?				;儲存刷新視窗的內容的虛似DC的handle (遊戲運行時的視窗刷新)

hback_BMP 	DWORD ?				;背景圖片的handle
hback_DC	DWORD ?				;儲存刷新視窗時所需背景內容的虛似DC的handle

hback_erase_DC DWORD ?			;儲存用來重繪背景內容的虛似DC的handle
;---------------------------------------------------------------------------------------------------------------------------------
;遊戲時間相關
;---------------------------------------------------------------------------------------------------------------------------------
hfont_type 	DWORD ?				;儲存所創建的邏輯字型的handle

font_type 	BYTE "新細明體", 0	;字體名稱 (用來設置自定義字形)
font_color 	DWORD 00FFFFFFh		;文字顏色 (白色)

time_rect RECT < win_w - 85, win_h - 37, win_w - 10, win_h - 5 >
								;用來顯示遊戲時間的矩形範圍
time_string   BYTE 1024 DUP (?)	;存放經格式化後的字串
time_string_f BYTE "%d 秒",0		;格式化字串

rest_time DWORD 60				;當前遊戲時間 (剩餘秒數)
;---------------------------------------------------------------------------------------------------------------------------------
;城堡相關
;---------------------------------------------------------------------------------------------------------------------------------
hcastle_BMP DWORD ?				;城堡圖片的handle
hcastle_DC 	DWORD ?				;操作城堡圖片的虛擬DC的handle

hcastle_mask_BMP DWORD ?		;城堡遮罩圖的handle
hcastle_mask_DC  DWORD ?		;操作城堡遮罩圖的虛擬DC的handle
;---------------------------------------------------------------------------------------------------------------------------------
;角色相關
;---------------------------------------------------------------------------------------------------------------------------------
hcharacter_BMP 	DWORD ?			;角色圖片的handle
hcharacter_DC 	DWORD ?			;操作角色圖片的虛擬DC的handle

hcharacter_mask_BMP DWORD ?		;角色遮罩圖的handle
hcharacter_mask_DC 	DWORD ?		;操作角色遮罩圖的虛擬DC的handle

character_x 	SDWORD castle_w	;角色的X座標
character_y 	SDWORD 165		;角色的Y座標
character_speed DWORD 12		;角色的移動速度

c_X_mov 		SDWORD 0		;角色在X方向的移動量
c_Y_mov 		SDWORD 0		;角色在Y方向的移動量

shoot_time 		DWORD 440		;射出子彈的時間間隔 (440毫秒)

X SDWORD ?						;全域變數 (暫存用)
Y SDWORD ?						;全域變數 (暫存用)
;---------------------------------------------------------------------------------------------------------------------------------
;敵人相關
;---------------------------------------------------------------------------------------------------------------------------------
henemy_BMP 		DWORD ?, ?, ?	;敵人圖片的handle
henemy_DC 		DWORD ?, ?, ?	;操作敵人圖片的虛擬DC的handle

henemy_mask_BMP	DWORD ?, ?, ?	;敵人遮罩圖的handle
henemy_mask_DC 	DWORD ?, ?, ?	;操作敵人遮罩圖的虛擬DC的handle

ENEMY STRUCT					;定義ENEMY結構
	x 	SDWORD win_w			;敵人的X座標
	y 	SDWORD ?				;敵人的Y座標
	y_v SBYTE ?					;敵人的Y軸移動方向
	e_type BYTE 0 				;敵人的種類 (0 = 藍色、1 = 紅色、2 = 綠色)
ENEMY ENDS

enemy_plist DWORD 50 DUP (0)	;儲存指向各個敵人的指標(PTR)的列表

enemy_w DWORD 57, 74, 59		;敵人的寬，enemy_weight
enemy_h DWORD 46, 53, 50		;敵人的高，enemy_height
enemy_speed DWORD 20, 35, 45	;敵人的移動速度

enemy_num DWORD 0				;當前畫面中敵人的總數

enemy_temp ENEMY <>				;全域變數 (暫存用)
;---------------------------------------------------------------------------------------------------------------------------------
;子彈相關
;---------------------------------------------------------------------------------------------------------------------------------
hbullet_BMP 	DWORD ?			;子彈圖片的handle
hbullet_DC 		DWORD ?			;操作子彈圖片的虛擬DC的handle

hbullet_mask_BMP	DWORD ?		;子彈遮罩圖的handle
hbullet_mask_DC 	DWORD ?		;操作子彈遮罩圖的虛擬DC的handle

BULLET STRUCT					;定義BULLET結構
	x SDWORD ?					;子彈的X座標
	y SDWORD ?					;子彈的Y座標
	y_v SDWORD ?				;子彈的Y軸移動方向
BULLET ENDS

bullet_plist DWORD 100 DUP (0)	;儲存指向各個敵人的指標(PTR)的列表

bullet_num DWORD 0				;當前畫面中子彈的總數

bullet_temp BULLET <>			;全域變數 (暫存用)
;---------------------------------------------------------------------------------------------------------------------------------
;道具相關
;---------------------------------------------------------------------------------------------------------------------------------
hitem_BMP 	DWORD ?, ?, ?		;道具圖片的handle
hitem_DC 	DWORD ?, ?, ?		;操作道具圖片的虛擬DC的handle

hitem_mask_BMP 	DWORD ?, ?, ?	;道具遮罩圖的handle
hitem_mask_DC 	DWORD ?, ?, ?	;操作道具遮罩圖的虛擬DC的handle

ITEM STRUCT						;定義ITEM結構
	x SDWORD ?					;道具的X座標
	y SDWORD ?					;道具的Y座標
	i_type BYTE ?				;道具的種類 (0 = 冰棒、1 = 奶泡貓、2 = 愛心)
ITEM ENDS

item_list ITEM 5 DUP (<?,?,?>)	;儲存道具的列表
item_start 	DWORD 0				;下一個要消去的道具於列表中的位置
item_end 	DWORD 0				;下一個道具要添加進列表中的位置

item_w DWORD 50, 90, 75			;道具的寬，item_width
item_h DWORD 96, 78, 30			;道具的高，item_height

item_num DWORD 0				;當前畫面中道具的總數
;---------------------------------------------------------------------------------------------------------------------------------
;生命相關
;---------------------------------------------------------------------------------------------------------------------------------
hlife_BMP 	DWORD ?				;生命圖片的handle
hlife_DC 	DWORD ?				;操作生命圖片的虛擬DC的handle

hlife_mask_BMP 	DWORD ?			;生命遮罩圖的handle
hlife_mask_DC 	DWORD ?			;操作生命遮罩圖的虛擬DC的handle

life_x DWORD 585, 660, 735,		;生命圖片的X座標
			 810, 885	

life BYTE 5						;當前生命數
;---------------------------------------------------------------------------------------------------------------------------------
;其他遊戲運行相關
;---------------------------------------------------------------------------------------------------------------------------------
hbulletHeap HANDLE ?			;儲存畫面中每個子彈資料的heap的handle
henemyHeap 	HANDLE ?			;儲存畫面中每個敵人資料的heap的handle

shoot_flag BYTE 0				;判斷是否射擊(按下射擊鍵)
hit_flag BYTE 0					;判斷子彈是否擊中敵人
;*********************************************************************************************************************************
;程式代碼段
;*********************************************************************************************************************************
.code
main PROC
	INVOKE start_WinStruct											
	INVOKE ExitProcess, NULL
main ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;start_WinStruct : 建立並在螢幕上顯示視窗
; 1.註冊窗口類別
; 2.依前面註冊的窗口類別創建一個窗口
; 3.進入無窮訊息迴圈得到訊息
;---------------------------------------------------------------------------------------------------------------------------------
start_WinStruct PROC
	LOCAL @startWC:WNDCLASSEX				;WNDCLASSEX 結構體(定義了視窗的外觀及操作方式等等，這個結構體在 Windows 環境是很重要的變數。)
	LOCAL @startMSG:MSG
	;01.註冊窗口類別
	ClassStruct:
		INVOKE RtlZeroMemory,		ADDR @startWC, SIZEOF @startWC
		INVOKE GetModuleHandle,		NULL									;GetModuleHandle API:參數為NULL，表示取得本身的模組代碼。
		mov hInstance, eax													;成功的話，傳回的模組代碼將存於暫存器EAX，這個數值稍後會用到，所以儲存在 hInstance變數裏。														
		mov @startWC.cbSize,		SIZEOF WNDCLASSEX						;cbSize:結構體長度
		mov @startWC.style,			CS_HREDRAW or CS_VREDRAW				;style:屬於此視窗類別的視窗的風格。當使用者把滑鼠移到視窗兩邊的邊框並壓下滑鼠右鍵，水平地改變視窗大小，Windows 會負責重新繪製視窗。CS_VREDRAW 只是改成垂直方向。
		mov @startWC.lpfnWndProc,	OFFSET start_WinProc					;lpfnWndProc:這個欄位是指向一個視窗函式 ( window procedure ) 的位址
		push hInstance
		pop @startWC.hInstance												;hInstance:模組代碼，表示此視窗類別屬於那一個程式模組。
		INVOKE LoadIcon, hInstance,	IDI_ICON1								;LoadIcon API:使程式自 UI 資源中載入圖示	
		mov @startWC.hIcon,	eax												;hIcon:視窗圖示代碼。
		mov @startWC.hIconSm,eax											;hIconSm:小圖示代碼(顯示在工作列上的)
		INVOKE LoadCursor, hInstance, IDC_CURSOR1							;LoadCursor API:用來傳回游標代碼
		mov @startWC.hCursor,eax											;hCursor:游標代碼
		mov @startWC.hbrBackground,	COLOR_WINDOW+1							;hbrBackground:工作區背景顏色。hbr 表示此欄位是一個刷子代碼。這裏表示在工作區著色的意思。
		mov @startWC.lpszClassName,	OFFSET start_ClassName					;一個指標，指向視窗類別名稱，以零為結尾。
		INVOKE RegisterClassEx,		ADDR @startWC							;RegisterClassEx API:向系統註冊一種視窗類別，如果註冊成功，EAX 為非零
	;02.創建窗口
	;CreateWindowEx API:建立視窗
	;CreateWindowEx 會把 WM_CREATE 訊息傳給新建立視窗的視窗函式。
	WinCreate:
		INVOKE CreateWindowEx,		WS_EX_CLIENTEDGE,						;dwExStyle
									OFFSET start_ClassName,					;所要創建的窗口類別名稱
									NULL,									;窗口名稱
									WS_OVERLAPPEDWINDOW xor WS_THICKFRAME,	;dwStyle
									CW_USEDEFAULT,							;窗口的X座標
									CW_USEDEFAULT,							;窗口的Y座標
									(win_w + 20),							;窗口的寬
									(win_h + 43),							;窗口的高
									NULL,									;父窗口
									NULL,									;選單
									hInstance,								
									NULL									
		mov hstartWin, eax
		INVOKE ShowWindow,		hstartWin, SW_SHOWNORMAL					;ShowWindow API:顯示視窗(第一個參數是想要顯示視窗的視窗代碼，第二個參數是顯示方式)
		INVOKE UpdateWindow,	hstartWin									;UpdateWindow API:假如工作區不是空無一物，它會送出一個 WM_PAINT 訊息給指定視窗的視窗函式，然後進行更新。
	;03.進入無窮訊息迴圈得到訊息
	MessageLoop:
		.while TRUE
		INVOKE GetMessage,		ADDR @startMSG, NULL, 0, 0					;GetMessage API : 從程式訊息佇列取出一項訊息
																			;第一個參數 lpMsg 是指向一個位址，這個位址是一個稱為 MSG 的結構體變數所在的位址，該結構體是用來接收從訊息佇列所傳來的訊息的結構體。
																			;第二個參數是 hWnd，表示要取得那一個視窗的訊息，假如 hWnd 為零的話，表示取得程式自己視窗的訊息。
																			;第三個和第四個參數分別表示取得訊息的編號範圍，假如要取得所有訊息的話，兩者均設為零。
		.break .if eax == 0													;GetMessage 的傳回值有三種情形，假如傳回 WM_QUIT 訊息的話，EAX 為零，則break
		INVOKE TranslateMessage,ADDR @startMSG								;TranslateMessage API : 把指定位址的 MSG 結構體的按鍵翻譯成字元，再填回程式訊息佇列等待下次的 GetMessage 取回
		INVOKE DispatchMessage,	ADDR @startMSG								;DispatchMessage API : 把 MSG 結構體的訊息傳給視窗函式加以處理
		.endw
		ret
start_WinStruct ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;start_WinProc : 處理訊息的"視窗函式"(當我們的程式自系統得到訊息之後，必須依照程式有興趣的訊息加以處理，處理這些訊息的一段程式就稱為『視窗函式』。)
;刷新視窗的步驟︰
; 1.呼叫 InvalidateRect 使工作區變為無效，更新無效區以發出 WM_PAINT 訊息	
; 2.處理WM_PAINT訊息以重新繪製視窗 (Windows 只重新繪製部份被遮蓋或者需要重新繪製的部份就可以了，這個區域稱為『無效區域』。)
;---------------------------------------------------------------------------------------------------------------------------------
start_WinProc PROC USES ebx edi esi edx, hWnd:HWND, uMsg:UINT, 			;hWnd視窗代碼，uMsg訊息編號，wParam,lParam額外的訊息資料
										 wParam:WPARAM, lParam:LPARAM	;因為 Windows 系統內必使用這些暫存器當作指標，所以得注意保存這四個暫存器。
	mov eax, uMsg
	;01.處理 WM_TIMER 訊息 (定時器)
	.if eax == WM_TIMER
		;01-1.若此WM_TIMER是由IDT_TIMER1計時器發出
		.if wParam == IDT_TIMER1										;IDT_TIMER1 : 畫面刷新
			.if enemy_num == 0											;判斷畫面中是否有敵人
				jmp NO_ENEMY_MOVE										;若無 (enemy_num == 0)則跳至NO_ENEMY_MOVE，跳過移動敵人的步驟 (Move_Enemy)
			.endif
			INVOKE Move_Enemy
		NO_ENEMY_MOVE:											
			.if bullet_num == 0											;判斷畫面中是否有子彈 
				jmp NO_BULLET_MOVE										;若無(bullet_num == 0)則跳至NO_BULLET_MOVE，跳過移動子彈的步驟 (Move_Bullet)
			.endif
			INVOKE Move_Bullet
		NO_BULLET_MOVE:
			.if c_X_mov == 0											;判斷人物是否移動 
				.if c_Y_mov == 0										;若無(c_X_mov == 0 && c_Y_mov == 0)												
					jmp NO_CHARACTER_MOVE								;則跳至NO_CHARACTER_MOVE，跳過移動人物的步驟 (Move_character)	
				.endif
			.endif
			INVOKE Move_character			
			NO_CHARACTER_MOVE:
			CALL Draw_character											;繪製人物
			INVOKE Check_Item											;檢查人物與道具的碰撞 (是否取得道具)
			INVOKE InvalidateRect,hWnd,0,1								;InvalidateRect API:用來設定無效區域 
																		;第二個參數lpRect 是指該視窗中要設定那一塊區域為無效區域是零的話，表示工作區的所有範圍都是無效區域。
																		;最後一個參數 bErase 是表示是否清除背景，非零表示要清除背景，在呼叫 BeginPaint 時，背景就會被清除。
			
		.endif
		;01-2.若此WM_TIMER是由IDT_TIMER3計時器發出							
		.if wParam == IDT_TIMER3										;IDT_TIMER3 : 射出子彈的間隔
			.if shoot_flag == 1											;若 shoot_flag == 1 (射擊鍵為壓下狀態)，
				CALL Shoot_Bullet										;則呼叫 Shoot_Bullet 射出子彈
			.endif
		.endif
		;01-3.若此WM_TIMER是由IDT_TIMER2計時器發出
		.if wParam == IDT_TIMER2											;IDT_TIMER2 : 遊戲時間倒數
			sub rest_time, 1												;遊戲時間-1
			;當遊戲剩餘5秒，出現綠色咖波貓
			.if rest_time == 5												
				mov font_color, 000000FFh									;將顯示遊戲時間的文字顏色設為000000FFh (紅色)
				INVOKE SetTimer, hWnd, IDT_TIMER6, 220, ADDR Create_Enemy	;創建生成綠色咖波貓的定時器 (IDT_TIMER6)
																			;IDT_TIMER6 : 生成敵人(綠色咖波貓)，由Create_Enemy 來處理 IDT_TIMER6 發送的訊息
			;當遊戲剩餘0秒，則遊戲過關
			.elseif rest_time == 0											
				INVOKE KillTimer, hWnd, IDT_TIMER1							;清除定時器
				INVOKE KillTimer, hWnd, IDT_TIMER2
				INVOKE KillTimer, hWnd, IDT_TIMER3
				INVOKE KillTimer, hWnd, IDT_TIMER4
				INVOKE KillTimer, hWnd, IDT_TIMER5
				INVOKE KillTimer, hWnd, IDT_TIMER6
				INVOKE KillTimer, hWnd, IDT_TIMER7
				INVOKE KillTimer, hWnd, IDT_TIMER8
				INVOKE Game_Win												;顯示遊戲過關圖片
			;當遊戲開始8秒，設置道具消失的定時器
			.elseif rest_time == 52											
				INVOKE SetTimer, hWnd, IDT_TIMER8, 3000, ADDR Delete_Item	;創建道具消失的定時器 (IDT_TIMER8)，以實現道具出現8秒後自動消失的效果
			.endif
		.endif
	;當程式收到 WM_PAINT，必須以 BeginPaint 及 EndPaint 這兩個 API 為起始及結束來初始化裝置內文及結束裝置內容，而我們要如何繪製圖形的程式碼則夾在這兩個 API 之間。
	;繪圖時的做法有兩種，第一種是在 WM_PAINT 訊息中使用BeginPaint 和 EndPaint 兩個 API 來開啟和釋放設備內容。
	;02.處理 WM_PAINT 訊息 (刷新窗口畫面)
	.elseif eax == WM_PAINT
		INVOKE Show_Image
	;02.處理 WM_KEYDOWN 訊息	(壓下按鍵)
	.elseif eax == WM_KEYDOWN
		UP:		
		.if wParam == VK_UP;57h							;按下W鍵
			mov ecx, 0
			sub ecx, character_speed
			mov c_Y_mov, ecx							;人物Y方向位移 = -(人物速度)
		DOWN:		
		.elseif wParam == VK_DOWN;53h					;按下S鍵
			mov ecx, 0
			add ecx, character_speed
			mov c_Y_mov, ecx							;人物Y方向位移 = 人物速度
		LEFT:
		.elseif wParam == VK_LEFT;41h					;按下A鍵
			mov ecx, 0
			sub ecx, character_speed
			mov c_X_mov, ecx							;人物X方向位移 = -(人物速度)
		RIGHT:
		.elseif wParam == VK_RIGHT;44h					;按下D鍵
			mov ecx, 0
			add ecx, character_speed
			mov c_X_mov, ecx							;人物X方向位移 = 人物速度
		.elseif wParam == VK_SPACE;44h;space			
			mov shoot_flag, 1
			;CALL Shoot_Bullet
		.endif
	;03.處理 WM_KEYUP 訊息 (放開按鍵)
	.elseif eax == WM_KEYUP	
		.if wParam == VK_UP;57h								;放開W鍵
			mov c_Y_mov, 0								;人物Y方向位移 = 0
		.elseif wParam == VK_DOWN;53h							;放開S鍵
			mov c_Y_mov, 0								;人物Y方向位移 = 0
		.elseif wParam == VK_LEFT;41h							;放開A鍵
			mov c_X_mov, 0								;人物X方向位移 = 0
		.elseif wParam == VK_RIGHT;44h							;放開D鍵
			mov c_X_mov, 0								;人物X方向位移 = 0
		.elseif wParam == VK_SPACE;44h;space
			mov shoot_flag, 0
		.endif
	;04.處理 WM_LBUTTONDOWN 訊息 (按下滑鼠左鍵)
	;.elseif eax == WM_LBUTTONDOWN
		;mov shoot_flag, 1								;將 shoot_flag 設為 1，表示射出子彈
		;CALL Shoot_Bullet	
	;05.處理 WM_LBUTTONUP 訊息 (放開滑鼠左鍵)
	;.elseif eax == WM_LBUTTONUP
		;mov shoot_flag, 0								;將 shoot_flag 設為 0
	;在 WM_CREATE 訊息中，處理程式一開始必須要完成的工作，例如初始化某些變數等等。
	;06.處理 WM_CREATE 訊息 (初始化)
	.elseif eax == WM_CREATE
		;06-1.設置亂數種子和創建私有堆(Heap)
		INVOKE GetTickCount									;取得當前系統時間
		INVOKE nseed, eax									;將當前系統時間作為隨機亂數的種子
		INVOKE HeapCreate, HEAP_NO_SERIALIZE, 320, 1600		;HeapCreate:創建私有堆的函數
															;flOptions參數是標誌，用來指定堆的屬性(HEAP_NO_SERIALIZE使堆不會進行獨佔性的檢測，訪問速度更快)
															;參數dwInitialSize指定創建堆時分配給堆的物理內存，當這些內存被用完時，堆的長度可以自動擴展。
															;dwMaximunSize參數指定了能夠擴展到的最大值，當擴展到最大值時再分配堆中內存會失敗。
		mov hbulletHeap, eax
		INVOKE HeapCreate, HEAP_NO_SERIALIZE, 400, 800
		mov henemyHeap, eax
		;在 Win32 環境裏是以訊息驅動的方式思考，也就是能夠使系統在每隔一段時間時發出一個訊息給我們的程式，要達到這個目的可以使用 SetTimer API。
		;SetTimer API:這個 API 建立一個計時器，此計時器每隔一段指定的時間，向某個指定的視窗送出 WM_TIMER 訊息
		;hWnd 是計時器所屬的視窗代碼。nIDEvent 是計時器的識別碼。uElapse 是所設定的時間，單位是毫秒。lpTimerFunc為 NULL 的話，指由 hWnd 的視窗函式來處理 WM_TIMER。
		;06-2.創建計時器
		INVOKE SetTimer, hWnd, IDT_TIMER1, 55, NULL							;IDT_TIMER1 : 遊戲畫面刷新
		INVOKE SetTimer, hWnd, IDT_TIMER2, 1000, NULL						;IDT_TIMER2 : 遊戲時間倒數
		INVOKE SetTimer, hWnd, IDT_TIMER3, shoot_time, NULL					;IDT_TIMER3 : 射出子彈間隔
		INVOKE SetTimer, hWnd, IDT_TIMER4, 550, ADDR Create_Enemy			;IDT_TIMER4 : 生成敵人(藍色咖波貓)，由Create_Enemy 來處理 IDT_TIMER4 發送的訊息
		INVOKE SetTimer, hWnd, IDT_TIMER5, 1705, ADDR Create_Enemy			;IDT_TIMER5 : 生成敵人(紅色咖波貓)，由Create_Enemy 來處理 IDT_TIMER5 發送的訊息
		INVOKE SetTimer, hWnd, IDT_TIMER7, 3000, ADDR Create_Item			;IDT_TIMER7 : 生成道具，由Create_Item 來處理 IDT_TIMER7 發送的訊息
		;06-3.處理使用位元圖所需的初始化
		INVOKE Load_Image
	;07.處理 WM_GAMEOVER 自定義訊息 (遊戲失敗)
	.elseif eax == WM_GAMEOVER
		;07-1.釋放定時器
		INVOKE KillTimer, hWnd, IDT_TIMER1				;KillTimer API:釋放計時器
		INVOKE KillTimer, hWnd, IDT_TIMER2				;hWnd 是計時器所屬的視窗代碼。uIDEvent 是計時器的識別碼。
		INVOKE KillTimer, hWnd, IDT_TIMER3				;釋放成功的話，此 API 會傳回非零值
		INVOKE KillTimer, hWnd, IDT_TIMER4			
		INVOKE KillTimer, hWnd, IDT_TIMER5
		INVOKE KillTimer, hWnd, IDT_TIMER6
		INVOKE KillTimer, hWnd, IDT_TIMER7
		INVOKE KillTimer, hWnd, IDT_TIMER8
		INVOKE Game_Over								;顯示遊戲失敗圖片
	;08.處理 WM_CLOSE 訊息 (視窗關閉) (注意 : 此時並未結束程式，只有窗口被關閉消失，程式仍在運行)
	.elseif eax == WM_CLOSE
		;08-1.釋放定時器
		INVOKE KillTimer, hWnd, IDT_TIMER1
		INVOKE KillTimer, hWnd, IDT_TIMER2
		INVOKE KillTimer, hWnd, IDT_TIMER3
		INVOKE KillTimer, hWnd, IDT_TIMER4
		INVOKE KillTimer, hWnd, IDT_TIMER5
		INVOKE KillTimer, hWnd, IDT_TIMER6
		INVOKE KillTimer, hWnd, IDT_TIMER7
		INVOKE KillTimer, hWnd, IDT_TIMER8
		INVOKE DestroyWindow,	hstartWin					;DestoryWindow 會摧毀指定的視窗，並發出 WM_DESTROY 訊息填入該視窗的程式訊息佇列裏
	;當視窗函式收到 WM_DESTROY 訊息時，視窗已被摧毀
	;09.處理 WM_DESTROY 訊息 (結束程式)
	.elseif eax == WM_DESTROY
		CALL Quit_Game
		INVOKE PostQuitMessage,	NULL						;PostQuitMessage API:使系統把 WM_QUIT 訊息放到程式訊息佇列裏，等待程式以 GetMessage 提取 WM_QUIT 訊息。
	;其他訊息交由系統依預設自行處理
	.else
		INVOKE DefWindowProc, hWnd, uMsg, wParam, lParam	;DefWindowProc API:系統內定的處理訊息函式
		ret
	.endif
	XOR eax, eax
	ret
start_WinProc ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Load_Image : 處理使用位元圖所需的初始化，像是創造虛擬設備內容(DC)和從資源檔(.rc)中以ID讀取位元圖。取得裝置內容後，
;			  先建立一個和此視窗相同的裝置內容，稱為記憶體裝置內容，作為緩衝區，再由這個緩衝區直接把位元圖傳送到要顯示的裝置內容上。
;要顯示 BMP 位元圖的步驟大致可分為以下幾個步驟：
; 1.在資源檔中定義位元圖。
; 2.用 LoadBitmap API 載入位元圖。
; 3.用 BeginPaint 取得設備內容，稱此設備內容為 hdc。
; 4.用 CreateCompatibleDC API 另外再建立與該設備內容一樣的設備內容，稱為 hdcMem。
; 5.用 SelectObject API 把自資源檔載入的位元圖畫在 hdcMem 上。
; 6.用 BitBlt API 把 hdcMem 的位元圖傳送到 hdc 上。
; 7.顯示圖片後，用 DeleteDC、EndPaint 分別釋放 hdc、hdcMem。
;---------------------------------------------------------------------------------------------------------------------------------
Load_Image PROC USES eax
	LOCAL @hDC
	LOCAL @hbrush
	LOCAL @Font : TEXTMETRIC
	;01.創造虛擬設備內容(DC)
	Create_DC:
		;01-1.取得裝置內容
		INVOKE GetDC, hstartWin					;取得視窗工作區的設備內容
		mov @hDC, eax							;暫存進LOCAL變數 @hdc 裏
		;01-2.建立緩衝區的記憶體設備內容
		INVOKE CreateCompatibleDC,	@hDC		;CreateCompatibleDC API:建立相同的裝置內容
		mov hgame_DC, eax						;成功則返回值存於 EAX，為新建的設備內容代碼。
		INVOKE CreateCompatibleDC,	@hDC		;緩衝區的記憶體設備內容代碼存於hXXX_DC變數裏
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
	;02.載入資源中的位元圖到記憶體裏。
	Load_BMP:
		;02-1.載入背景位元圖 (IDB_BITMAP15)
		INVOKE LoadBitmap, hInstance, IDB_BITMAP15			;LoadBitmap API:把資源中的位元圖載入到記憶體裏。
															;hInstance 是程式的模組代碼，lpBitmapName 是指向位元圖識別碼字串的位址
															;執行完 LoadBitmap API 後，EAX 會傳回位元圖代碼。
		mov hback_BMP, eax									;記錄位元圖代碼於hback_BMP變數裏
		;02-2.把背景位元圖變成筆刷				
		INVOKE  CreatePatternBrush, hback_BMP				;CreatePatternBrush API:把特定的位元圖製成筆刷。hbmp 是想要製作成筆刷的位元圖代碼。如果成功，CreatePatternBrush 會傳回筆刷代碼
		mov @hbrush, eax									;把這個筆刷代碼記錄在LOCAL變數 @hbrush 裏
		;02-1.載入其他位元圖 
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
	;03.將指定物件選入指定設備內容 (DC) 中
	Link_BMPtoDC:	
		;大多時候使用的是資源裡已經預定義的位元圖，但有時也有需要使用未初始化的位元圖，這些位元圖是在程式運行後才被創建的
		;03-1.以 hdc 為本，用 CreateCompatibleBitmap 建立未初始化的位元圖。
		INVOKE CreateCompatibleBitmap, @hDC, win_w, win_h				;CreateCompatibleBitmap API:建立與 hdc 相容的位元圖。如果成功建立位元圖，則傳回位元圖代碼
		;03-2.用 SelectObject 把位元圖選入緩衝區的記憶體設備內容。
		INVOKE SelectObject, hgame_DC, eax								;SelectObject API:把新建立的物件選入指定的裝置內容裏，取代舊物件
																		;hdc 是指定的裝置內容，hgdiobj 是要被選入裝置內容的圖形物件代碼，可以用的圖形物件有位元圖 (Bitmap)、
																		;筆刷 (Brush)、字型 (Font)、畫筆 (Pen)、範圍 (Region) 等
		
		INVOKE DeleteObject,  eax
		INVOKE CreateCompatibleBitmap, @hDC, win_w, win_h
		INVOKE SelectObject, hback_DC, eax
		INVOKE DeleteObject,  eax
		INVOKE CreateCompatibleBitmap, @hDC, win_w, win_h
		INVOKE SelectObject, hback_erase_DC, eax
		INVOKE DeleteObject,  eax
		;03-2.1.將背景填充筆刷選入背景設備內容。
		INVOKE SelectObject, hback_DC, @hbrush
		;03-2.2.將其他物件選入個別設備內容。
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
	;04.背景圖填充
	Fill_Background:	
		INVOKE PatBlt,  hback_DC, 0, 0, win_w, win_h, PATCOPY						;PatBlt API : 將當前圖樣拷貝到hDC中，使圖樣拼揍成整個背景圖
																					;把 hdc 目前的筆刷作為圖樣，從座標 ( nXLeft，nYLeft ) 開始填充，
																					;填充區域的寬度與高度分別是 nWidth、nHeight。填充方式可以由 dwRop 指定
																					;PATCOPY : 填充筆刷
		INVOKE BitBlt,	hback_erase_DC,0, 0,win_w, win_h, hback_DC, 0, 0,SRCCOPY
	;顯示去背BMP圖檔透明效果的方法:
	;再建立一張圖片，稱為遮罩圖，圖案的主要部份為白色 (1)，而背景為黑色 (0)，
	;先讓遮罩圖與背景圖作 OR 運算，再使位元圖與背景圖作 AND 運算即可。
	;05.繪製城堡圖片
	Draw_castle:
													;BitBlt API:傳送一個區塊的位元資料 ( bit-block transfer )，意即使在記憶體內的位元圖，傳送到設備內容。
		INVOKE BitBlt,  hback_DC,					;hdcDest 是目的地的設備內容代碼
						0, 0,						;nXDest、nYDest 是目的地設備內容的座標
						castle_w, castle_h,			;nWidth、nHeight 是傳送圖片的寬度與長度
						hcastle_mask_DC, 0, 0,		;hdcSrc 是來源設備內容，nXSrc、nYSrc 是來源的座標
						SRCPAINT					;dwRop 是傳送後的操作方式
													;SRCPAINT : 來源資料 OR 目標資料
		INVOKE BitBlt,  hback_DC,
						0, 0,
						castle_w, castle_h,
						hcastle_DC, 0, 0,
						SRCAND						;SRCAND : 來源資料 AND 目標資料
	;06.繪製生命圖片
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
	;07.創建顯示遊戲時間的格式化字串
	Create_Font:
		INVOKE CreateFont, 32, 0, 0, 0, 700, 0, 0, 0, 0, 0, 0, 0, 0, OFFSET font_type		;創建邏輯字型
		mov hfont_type, eax
		INVOKE SelectObject, @hDC, eax
		INVOKE SetBkMode, @hDC, TRANSPARENT
		INVOKE wsprintf, OFFSET time_string, OFFSET time_string_f, rest_time
		INVOKE DrawText, @hDC, OFFSET time_string, -1, OFFSET time_rect, DT_VCENTER
	;08.完成背景，傳送至 hgame_DC 設備內容
	Finish_Background:
		INVOKE BitBlt,	hgame_DC,
						0, 0,	
						win_w, win_h, 
						hback_DC, 0, 0,
						SRCCOPY
	;09.繪製人物圖片
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
;Show_Image : 重繪窗口
;---------------------------------------------------------------------------------------------------------------------------------
Show_Image PROC USES eax
	LOCAL @PS:PAINTSTRUCT
	LOCAL @hDC

	INVOKE BeginPaint, hstartWin, ADDR @PS									;BeginPaint API : 取得設備內容並開始繪製其無效區
																			;第一個是視窗代碼，第二個是一雙字組大小的數值，此數指向結構體，PAINTSTRUCT，的位址。
																			;假如呼叫成功，在 eax 會傳回設備內容代碼
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
	INVOKE EndPaint, hstartWin, ADDR @PS									;EndPaint API : 結束繪製並釋放設備內容
	ret
Show_Image ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Move_character : 移動人物
;	1.擦去原先人物
;	2.檢查是否碰觸邊緣並計算人物的位移
;	3.檢查是否人物有移動，若無則直接返回
;	4.更新人物位置
;---------------------------------------------------------------------------------------------------------------------------------
Move_character PROC USES eax
	;01.擦除人物
	INVOKE BitBlt,	hgame_DC,
					character_x, character_y,
					character_w, character_h,
					hback_DC, character_x, character_y,
					SRCCOPY
	;02.檢查是否碰觸邊緣，若觸界則不移動
	Check_Bound:
		Left_Bound:
		mov ecx, character_x
		add ecx, c_X_mov					;ecx = 人物左側
		cmp ecx, castle_w					;比較人物左側和城堡右側
		jge Right_Bound
		mov c_X_mov, 0						;碰觸左側邊界，人物X方向位移 = 0
		jl Up_Bound
		Right_Bound:
		add ecx, character_w				;ecx = 人物右側
		cmp ecx, win_w						;比較人物右側和畫面右側
		jle Up_Bound
		mov c_X_mov, 0						;碰觸右側邊界，人物X方向位移 = 0
		Up_Bound:
		mov ecx, character_y		
		add ecx, c_Y_mov					;ecx = 人物頂端
		cmp ecx, 0							;比較人物頂端和畫面頂端
		jge Down_Bound
		mov c_Y_mov, 0						;碰觸頂端邊界，人物Y方向位移 = 0
		jl Check_Move
		Down_Bound:
		add ecx, character_h				;ecx = 人物底端
		cmp ecx, win_h						;比較人物底端和畫面底端
		jle Move
		mov c_Y_mov, 0						;碰觸底端邊界，人物Y方向位移 = 0
	;03.判斷人物是否移動，若無則直接返回
	Check_Move:
		.if c_X_mov == 0
			.if c_Y_mov == 0				;若人物X方向位移 (c_X_mov) 和Y方向位移 (c_Y_mov) 皆為 0
				ret							;無移動直接返回
			.endif
		.endif
	;04.更新人物位置
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
;Draw_character : 繪製人物
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
;Shoot_Bullet : 射出子彈
; 1.生成子彈資料 (起始位置、方向等) 並存入暫存用的子彈變數 bullet_temp 中
; 2.分配出一個子彈 (BULLET) 的記憶體空間，並將指向該空間起始位址的指標存入LOCAL變數 pbullet_temp
; 3.將 bullet_temp 的資料以movsd, movsb等 存入分配出的空間 
; 3.將 pbullet_temp 加入儲存每個子彈指標 (BULLET PTR) 的列表 bullet_plist 中
; 3-1.搜尋 bullet_plist 中是否有 0 ，若有則表示該儲存指標的位置為空閒，以 pbullet_temp 覆蓋，若無則將 pbullet_temp 添至列表尾端
; 4.調整子彈資料並重複三次前述動作生成3顆子彈，以達到同時射出3顆不同方向子彈的效果
;---------------------------------------------------------------------------------------------------------------------------------
Shoot_Bullet PROC 
	LOCAL pbullet_temp:DWORD
	LOCAL y_v_temp:SDWORD
	mov y_v_temp, -1
	mov ecx, 3
	mov edx, character_y
	add edx, (character_h / 2) - 20
	;01.生成子彈資料
	Create_Bullet:
		push ecx
		push edx
		mov edx, character_x
		add edx, character_w
		mov bullet_temp.x, edx			;設置子彈起始X座標
		pop edx
		mov bullet_temp.y, edx			;設置子彈起始Y座標
		add edx, 20
		push edx
		mov edx, y_v_temp
		mov bullet_temp.y_v, edx		;設置子彈Y軸上的方向 (-1 = 向上, 0 = 直線, 1 = 向下)
	;02.分配記憶體空間
		INVOKE HeapAlloc, hbulletHeap, HEAP_ZERO_MEMORY, SIZEOF BULLET	;HeapAlloc API : 在堆中分配內存塊
																		;hHeap參數就是前面創建堆時返回的堆句柄，dwBytes是需要分配的內存塊的字節數，
																		;dwFlags是標誌(HEAP_ZERO_MEMORY:將分配的內存用0初始化)
																		;返回值是指向內存塊第一個字節的指針
		mov pbullet_temp, eax											;將指向該分配空間起始位址的指標存入 pbullet_temp
	;03.將子彈資料 (bullet_temp) 存入分配出的空間
		mov esi, OFFSET bullet_temp
		mov edi, pbullet_temp
		mov ecx, 3
		cld
		rep movsd
		
		inc bullet_num			;子彈總數+1
		add y_v_temp, 1			;下一顆子彈所射出的方向 = 前一顆子彈的方向+1
	;03.將子彈指標 (pbullet_temp) 添入紀錄子彈指標的列表 (bullet_plist) 中
		;03-1.搜尋當前 bullet_plist 中是否有 0 (空閒位置)
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
;Move_Bullet : 移動子彈
; 1.從 bullet_plist 取出子彈指標，並存入LOCAL變數 bulletptr
; 2.依取出的指標(bulletptr) 取出子彈資料
; 3.擦去原先的子彈
; 4.更新子彈位置並檢查子彈是否出界
; 5.呼叫 Check_Hit 檢查是否擊中敵人
; 6.在新位置重新繪上子彈或消去子彈(出界或擊中敵人)
; 7.重複以上動作直至將畫面中每個子彈瀏覽過一遍 (迴圈次數 = bullet_num)
;---------------------------------------------------------------------------------------------------------------------------------
Move_Bullet PROC USES esi 
	LOCAL bulletptr
	mov esi, OFFSET bullet_plist
	mov ecx, bullet_num
	;01.從 bullet_plist 依序取出子彈指標
	Load_Bullet:
		mov eax, DWORD PTR [esi]
		add esi, 4
		cmp eax, 0							;若為 0 ，表示為空閒位置，沒有資料
		je Load_Bullet
		mov	bulletptr, eax					;將取出的指標存入LOCAL變數 bulletptr
		mov edi, bulletptr
		push ecx							;推入ecx ( = 當前迴圈次數)
	;02.擦除子彈
		INVOKE BitBlt,	hgame_DC, (BULLET PTR [edi]).x, (BULLET PTR [edi]).y,
						bullet_w, bullet_h,
						hback_DC, (BULLET PTR [edi]).x, (BULLET PTR [edi]).y,
						SRCCOPY
	;03.更新子彈位置並檢查子彈是否出界
		;03-1.檢查X方向邊界
		mov eax, (BULLET PTR [edi]).x
		add eax, bullet_speed
		cmp eax, win_w						;比較子彈左側和畫面右側
		jg B_Out_Bound
		;03-2.檢查Y方向邊界
		mov edx, (BULLET PTR [edi]).y
		cmp (BULLET PTR [edi]).y_v, 0		;確認子彈的方向
		je Check_B_Hit
		jl B_y_v_up
		add edx, (bullet_speed / 10)
		cmp edx, win_h						;比較子彈頂端和畫面底端
		jg B_Out_Bound
		jmp Check_B_Hit
	B_y_v_up:								;y_v == -1，子彈向上移動
		sub edx, (bullet_speed / 10)
		push edx
		add edx, bullet_h
		cmp edx, 0							;比較子彈底端和畫面頂端
		pop edx
		jl B_Out_Bound
	;04.檢查是否擊中敵人
	Check_B_Hit:
		mov (BULLET PTR [edi]).x, eax
		mov (BULLET PTR [edi]).y, edx
		.if enemy_num <= 0					;若敵人數為 0 則跳過檢查 (Check_Hit)
			jmp @F
		.endif
		INVOKE Check_Hit ,(BULLET PTR [edi]).x,  (BULLET PTR [edi]).y
		cmp hit_flag, 1						;判斷是否擊中 (hit_flag == 1)
		je B_Hit
	;05.重新繪上子彈
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
	;06.消去子彈 (出界或擊中敵人)
	B_Hit:
		mov hit_flag, 0										;判斷擊中敵人則將 hit_flag 初始化回 0
	B_Out_Bound:
		;06-1.釋放該子彈所佔的記憶體空間
		INVOKE HeapFree, hbulletHeap, NULL, bulletptr		;HeapFree釋放分配到的內存塊
															;hHeap參數是堆句柄，lpMemory是HeapAlloc函數返回的內存塊指針，dwFlags
		pop ecx												;推出(當前迴圈次數)放入ecx
		;06-2.更新紀錄子彈指標的列表 (bullet_plist)
		push esi
		sub esi, 4
		mov DWORD PTR [esi], 0								;將該子彈指標在 bullet_plist 中的位置的值設為 0，表示為空閒位置
		pop esi
		dec bullet_num										;子彈數目-1
		dec ecx
		jnz Load_Bullet
		ret
Move_Bullet ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Create_Enemy : 生成敵人
; 1.以隨機亂數生成敵人資料 (起始位置、方向、種類等) 並存入暫存用的ENEMY變數 enemy_temp 中
; 2.分配出一個敵人 (ENEMY) 的記憶體空間，並將指向該空間起始位址的指標存入LOCAL變數 penemy_temp
; 3.將 enemy_temp 的資料以movsd, movsb等 存入分配出的空間 
; 3.將 penemy_temp 加入儲存每個子彈指標 (ENEMY PTR) 的列表 enemy_plist 中
; 3-1.搜尋 enemy_plist 中是否有 0 ，若有則表示該儲存指標的位置為空閒，以 penemy_temp 覆蓋，若無則將 penemy_temp 添至列表尾端
;---------------------------------------------------------------------------------------------------------------------------------
Create_Enemy PROC USES esi ,hWnd:HWND, uMsg:UINT,idEvent:UINT, dwTime:DWORD
	LOCAL penemy_temp:DWORD
	;01.以隨機亂數生成敵人資料
	;01-1.生成敵人起始Y座標
		INVOKE nrandom, 10
		mov edx, eax
		shl eax, 1
		add eax, edx
		shl eax, 4
		mov enemy_temp.y, eax			
	;01-2.生成敵人Y軸上的方向 (-1 = 向上, 0 = 直線, 1 = 向下)
		INVOKE nrandom, 3
		mov enemy_temp.y_v, al
		sub enemy_temp.y_v, 1
	;01-3.判斷該訊息由哪個定時器發出以決定敵人種類
		.if idEvent == 4					;IDT_TIMER4
			mov enemy_temp.e_type, 0		;e_type = 0 (藍色咖波貓)
		.elseif idEvent == 5				;IDT_TIMER5
			mov enemy_temp.e_type, 1		;e_type = 1 (紅色咖波貓)
		.elseif idEvent == 6				;IDT_TIMER6
			mov enemy_temp.e_type, 2		;e_type = 2 (綠色咖波貓)
		.endif
	;02.分配記憶體空間
		INVOKE HeapAlloc, henemyHeap, HEAP_ZERO_MEMORY, SIZEOF ENEMY
		mov penemy_temp, eax				;將指向該分配空間起始位址的指標存入 penemy_temp
	;03.將敵人資料 (enemy_temp) 存入分配出的空間
		mov esi, OFFSET enemy_temp
		mov edi, penemy_temp
		cld
		movsd
		movsd
		movsb
		movsb

		inc enemy_num						;敵人數目+1
	;04.將敵人指標 (penemy_temp) 添入紀錄敵人指標的列表 (enemy_plist) 中
		;04-1.搜尋當前 enemy_plist 中是否有 0 (空閒位置)
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
;Move_Enemy : 移動敵人
; 1.從 enemy_plist 取出敵人指標，並存入LOCAL變數 enemyptr
; 2.依取出的指標 (enemyptr) 取出敵人資料
; 3.擦去原先的敵人
; 4.更新敵人位置並檢查敵人是否出界和擊中城堡
; 5.檢查敵人和人物的碰撞(是否擊中人物)
; 6.在新位置重新繪上敵人或消去敵人(出界、擊中城堡或擊中人物)
; 7.重複以上動作直至將畫面中每個敵人瀏覽過一遍 (迴圈次數 = enemy_num)
;---------------------------------------------------------------------------------------------------------------------------------
Move_Enemy PROC USES edi esi
	LOCAL enemyptr:DWORD
	mov esi, OFFSET enemy_plist
	mov ecx, enemy_num
	;01.從 enemy_plist 依序取出敵人指標
	Load_Enemy:
		mov eax, DWORD PTR [esi]
		add esi, 4
		cmp eax, 0							;若為 0 ，表示為空閒位置，沒有資料
		je Load_Enemy
		mov	enemyptr, eax					;將取出的指標存入LOCAL變數 enemyptr
		mov edi, enemyptr
		push ecx							;推入ecx ( = 當前迴圈次數)
		movzx ecx, (ENEMY PTR [edi]).e_type
		shl ecx, 2
		push ecx							;推入ecx ( = (當前敵人種類)*2 )
	;02.擦除子彈
		INVOKE BitBlt,	hgame_DC,
						(ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						enemy_w[ecx], enemy_h[ecx],
						hback_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						SRCCOPY
		pop ecx								;取出 ((當前敵人種類)*2) 放入ecx
	;03.更新敵人位置並檢查敵人是否出界	
	;03-1.更新敵人X座標
		mov eax, (ENEMY PTR [edi]).x
		sub eax, enemy_speed[ecx]

		mov (ENEMY PTR [edi]).x, eax
		add eax, enemy_w[ecx]				;eax = 敵人右側
	;03-2.判斷敵人的移動方向並更新敵人Y座標
		mov edx, (ENEMY PTR [edi]).y
		cmp (ENEMY PTR [edi]).y_v, 0
		je @F
		jl y_v_up
		add edx, enemy_speed[ecx]
		jmp @F
	y_v_up:									;y_v == -1，敵人向上移動
		sub edx, enemy_speed[ecx]
		@@:
		mov (ENEMY PTR [edi]).y, edx
	;03-3.檢查X方向邊界
		cmp eax, 0							;比較敵人右側和畫面左側
		jl E_Out_Bound
	;03-4.檢查是否擊中城堡
		cmp eax, castle_w					;比較敵人右側和城堡右側
		jl Minus_Life						;若判斷擊中城堡則跳至 Minus_Life
	;03-5.檢查Y方向邊界
		cmp edx, 0							;比較敵人頂端和畫面頂端
		jg Bottom_Bound
		mov (ENEMY PTR [edi]).y_v, 1		;碰觸頂端邊界則反彈，將 y_v 設為 1 (向下)
	Bottom_Bound:
		add edx, enemy_h[ecx]
		.if edx >= win_h					;比較敵人底端和畫面底端
			mov (ENEMY PTR [edi]).y_v, -1	;碰觸底端邊界則反彈，將 y_v 設為 -1 (向上)
		.endif
	;04.檢查是否擊中人物
		mov edx, character_x
		add edx, (character_w / 4)
		cmp eax, edx						;比較敵人右側和人物左側
		jl No_Hit_C
		mov eax, character_x
		add eax, (character_w * 3 / 4)
		cmp eax, (ENEMY PTR [edi]).x		;比較人物右側和敵人左側
		jl No_Hit_C
		mov eax, character_y
		add eax, (character_h * 4 / 5)
		cmp eax, (ENEMY PTR [edi]).y		;比較人物底端和敵人頂端
		jl No_Hit_C
		mov eax, (ENEMY PTR [edi]).y
		add eax, enemy_h[ecx]
		mov edx, character_y
		add edx, (character_h / 5)
		cmp eax, edx 						;比較敵人底端和人物頂端
		jg E_Hit_C							;若判斷擊中人物則跳至 E_Hit_C
	;05.重新繪上敵人
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
	;06.判斷敵人擊中人物，擦除人物並初始化人物數值
	E_Hit_C:
	;06-1.擦除人物
		INVOKE BitBlt,	hgame_DC, character_x, character_y,
						character_w, character_h,
						hback_DC, character_x, character_y,
						SRCCOPY
		mov character_x, castle_w				;將人物X座標設回初始值
		mov character_y, 165					;將人物Y座標設回初始值
		mov character_speed, 12					;將人物移動速度設回初始值
		mov shoot_time, 440						;將射擊時間間隔設回初始值
		INVOKE SetTimer, hstartWin, IDT_TIMER3, shoot_time, NULL
		CALL Draw_character
	;06-2.生命數減少並擦去生命圖片
	Minus_Life:
		dec life
		INVOKE Erase_life, life
		.if life == 0									;若life = 0 則遊戲失敗
			INVOKE PostMessage, hstartWin, WM_GAMEOVER,	;發送 WM_GAMEOVER 自定義訊息至主窗口
								NULL, NULL
			ret
		.endif
	;07.消去敵人(出界、擊中城堡或擊中人物)
	E_Out_Bound:
		;07-1.釋放該敵人所佔的記憶體空間
		INVOKE HeapFree, henemyHeap, NULL, enemyptr
		pop ecx											;推出(當前迴圈次數)放入ecx
		;07-2.更新紀錄敵人指標的列表 (enemy_plist)
		push esi
		sub esi, 4
		mov DWORD PTR [esi], 0							;將該敵人指標在 enemy_plist 中的位置的值設為 0，表示為空閒位置
		pop esi
		dec enemy_num									;敵人數目-1
		dec ecx
		jnz Load_Enemy
		ret
Move_Enemy ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Check_Hit : 檢查當前子彈與敵人的碰撞 (是否擊中敵人)
; 1.從 enemy_plist 取出敵人指標，並依取出的指標讀入敵人資料
; 2.比對當前子彈與該敵人的座標，檢查是否擊中該敵人
; 3.若擊中則擦去該敵人並返回
; 4.重複以上動作直至將畫面中每個敵人皆比對過一遍 (迴圈次數 = enemy_num)
;---------------------------------------------------------------------------------------------------------------------------------
Check_Hit PROC USES ecx esi edi, b_X:SDWORD, b_Y:SDWORD
		mov eax, b_X
		mov edx, b_Y
		mov esi, OFFSET enemy_plist
		mov ecx, enemy_num
	;01.從 enemy_plist 依序取出敵人指標
	_Load_Enemy:
		mov eax, DWORD PTR [esi]
		add esi, 4
		cmp eax, 0								;若為 0 ，表示為空閒位置，沒有資料
		je _Load_Enemy
		mov edi, eax
		push ecx								;推入ecx ( = 當前迴圈次數)
		movzx ecx, (ENEMY PTR [edi]).e_type
		shl ecx, 2								;ecx = (當前敵人種類)*2 
	;02.檢查是否擊中該敵人
	;02-1.比對當前子彈與該敵人的X座標
		mov eax, (ENEMY PTR [edi]).x			;eax = 敵人左側
		mov edx, eax
		add edx, enemy_w[ecx]					;edx = 敵人右側
		cmp edx, b_X							;比較敵人右側和子彈左側
		jl No_Hit
		add b_X, bullet_w						;b_X = 子彈右側
		cmp eax, b_X							;比較敵人左側和子彈右側
		jg No_Hit
	;02-1.比對當前子彈與該敵人的Y座標
		mov eax, (ENEMY PTR [edi]).y			;eax = 敵人頂端
		mov edx, eax
		add edx, enemy_h[ecx]					;edx = 敵人底端
		cmp edx, b_Y							;比較敵人底端和子彈頂端
		jl No_Hit
		add b_Y, bullet_h						;b_Y = 子彈底端
		cmp eax, b_Y							;比較敵人頂端和子彈底端
		jg No_Hit
	;03.擊中該敵人，則消去該敵人並將 hit_flag 設為 1 後返回
	Hit:
	;03-1.擦除該敵人
		INVOKE BitBlt,	hgame_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						enemy_w[ecx], enemy_h[ecx],
						hback_DC, (ENEMY PTR [edi]).x, (ENEMY PTR [edi]).y,
						SRCCOPY
	;03-2.釋放該敵人所佔的記憶體空間
		INVOKE HeapFree, henemyHeap, NULL, edi
	;03-3.更新紀錄敵人指標的列表 (enemy_plist)
		sub esi, 4
		mov DWORD PTR [esi], 0					;將該敵人指標在 enemy_plist 中的位置的值設為 0，表示為空閒位置
		pop ecx									;推出(當前迴圈次數)放入ecx
		dec enemy_num	
		mov hit_flag, 1							;將 hit_flag 設為 1 ，表示有擊中
		ret
	;04.無擊中
	No_Hit:
		pop ecx									;推出(當前迴圈次數)放入ecx
		dec ecx
		jnz _Load_Enemy
	ret
Check_Hit ENDP
;---------------------------------------------------------------------------------------------------------------------------------
;Create_Item : 生成道具
;(((((我不想寫，自殺了)))))
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
;Check_Item : 檢查道具與人物的碰撞 (是否取得道具)
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
		cmp eax, character_x						;比較道具右側和人物左側
		jl No_Get_I
		mov eax, character_x
		add eax, character_w
		cmp eax, (ITEM PTR item_list[esi]).x		;比較人物右側和道具左側
		jl No_Get_I
		mov eax, character_y
		add eax, character_h
		cmp eax, (ITEM PTR item_list[esi]).y		;比較人物底端和道具頂端
		jl No_Get_I
		mov eax, (ITEM PTR item_list[esi]).y
		add eax, item_h[edx]
		cmp eax, character_y						;比較道具底端和人物頂端
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
;Delete_Item : 消去道具，以實現道具一定時間後自動消失的效果
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
;Draw_Life : 繪製生命圖片 (畫面右上角)
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
;Erase_Life : 擦去生命圖片 (畫面右上角)
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
;Game_Win : 繪製遊戲過關圖片
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
;Game_Over : 繪製遊戲失敗圖片
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
;Quit_Game : 結束程序時的收尾，包含釋放私有堆(Heap)、設備內容(DC)、位元圖物件等
;---------------------------------------------------------------------------------------------------------------------------------
Quit_Game PROC
		
		INVOKE HeapDestroy, hbulletHeap						;HeapDestroy API : 釋放指定私有堆(Heap)
		INVOKE HeapDestroy, henemyHeap
		
		INVOKE DeleteDC, hgame_DC							;DeleteDC API:釋放指定的裝置內容。若成功，則 EAX 傳回非零數
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

		INVOKE DeleteObject, hback_BMP						;DeleteObject API:用來刪除畫筆、筆刷、字型、位元圖、範圍或或調色盤 ( Palette )，以節省資源。
															;hObject 是要刪除的物件代碼。DeleteObject 成功刪除物件時，會傳回非零值
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