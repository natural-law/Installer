!addincludedir "include" ;添加插件目录

Unicode true

!ifndef NSIS_UNICODE
!AddPluginDir .\plugins
!else
!AddPluginDir .\Unicode
!endif

Var MSG
Var Dialog  ;Dialog变量也需要定义，他可能是NSIS默认的对话框变量用于保存窗体中控件的信息

Var BGImage  ;背景小图
Var ImageHandle

Var BGImageLong  ;背景大图
Var ImageHandleLong

Var AirBubblesImage
Var AirBubblesHandle

Var btn_Close ;close button 
Var btn_instetup ;install now button按钮
Var btn_ins
Var btn_instend ;立即体验
var cbk_license ;安装协议勾选框
Var Txt_Xllicense
Var page1HNW
Var flag
Var txb_AppFolder
Var AppFolder ;安装目录
var btn_browse
Var txt_FileSize ;所需空间大小Mb
Var txt_AvailableSpace ;可用空间Gb
var txt_installDir ;安装目录
Var PB_ProgressBar
Var txt_installProgress ;安装进度文本
var IsEnglish
Var WarningForm
Var txt_intallStatus

;---------------------------全局编译脚本预定义的常量-----------------------------------------------------
; TODO check the values
!define PRODUCT_NAME "CocosCreator"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Cocos"
!define RESOURCE_IMG_PATH "$TEMP\${PRODUCT_NAME}"

!define PEODUCT_DEFAULT_INST_PATH "$PROGRAMFILES\${PRODUCT_NAME}" ; 默认安装路径
!define PRODUCT_INST_KEY "SOFTWARE\CocosCreator"  ;注册表的 Key
!define PRODUCT_INST_FOLDER_KEY "InstallPath"
!define PRODUCT_INST_VERSION_KEY "Version"
!define PRODUCT_ENTRANCE "CocosCreator.exe"
!define PRODUCT_UNINST_NAME "uninst.exe"

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

SetCompressor lzma
SetCompress force
SetOverwrite try
CRCCheck on

;应用程序显示名字
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe"

InstallDir "${PEODUCT_DEFAULT_INST_PATH}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails nevershow
ShowUnInstDetails nevershow

!define MUI_ABORTWARNING

!define MUI_ICON "resources\icon\install.ico"
!define MUI_UNICON "resources\icon\uninstall.ico"
;使用的UI
;!define MUI_UI "resources\ui\mod.exe"

ReserveFile "resources\images\*.bmp"
ReserveFile "resources\Skin\*.*"

; ;DLL
ReserveFile `plugins\nsDialogs.dll`
ReserveFile `plugins\nsWindows.dll`
ReserveFile `plugins\SkinBtn.dll`
ReserveFile `plugins\SkinButton.dll`
ReserveFile `plugins\SkinProgress.dll`
ReserveFile `plugins\System.dll`
ReserveFile `plugins\WndProc.dll`
ReserveFile `plugins\nsisSlideshow.dll`
ReserveFile `plugins\FindProcDLL.dll`
ReserveFile `plugins\Resource.dll`
ReserveFile `plugins\nsResize.dll`

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"
!include "WinCore.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "LoadRTF.nsh"
!include "nsResize.nsh"
!include "FileFunc.nsh"
!include "nsDialogs_createTextMultiline.nsh"
!include "LogicLib.nsh"
!include "GetProcessInfo.nsh"

; installer
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit
; 安装选项页面
Page custom  Page.1 Page.1leave
; 安装过程页面
Page custom InstFilesPageShow InstallFilesFinish
; 安装完成页面
Page custom InstallFinish

; uninstaller
!define MUI_CUSTOMFUNCTION_UNGUIINIT un.onGUIInit1
UninstPage custom un.UnPageWelcome
; 卸载反馈页面
UninstPage custom un.FeedbackPage
; 卸载过程界面
!define MUI_PAGE_CUSTOMFUNCTION_SHOW un.InstallFiles1
!insertmacro MUI_UNPAGE_INSTFILES
; 卸载完成界面
Uninstpage custom un.InstallFinish

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"
; TODO 支持繁体中文 !insertmacro MUI_LANGUAGE "TradChinese"

!include "MultiLanguage.nsi"
!include "CustomTools.nsi"

!define ChangeWindowSize `!insertmacro __ChangeWindowSize`
!define CustomSetFont `!insertmacro __CustomSetFont`
!define MoveControlPositon `!insertmacro __MoveControl`
!define FileTypeReg `!insertmacro __FileTypeReg`

Function .onInit
    ; 获取语言
    ${If} $LANGUAGE == 1033
      Push True
      Pop $IsEnglish
    ${Else}
      Push False
      Pop $IsEnglish
    ${EndIf}

    InitPluginsDir

    SetOutPath "${RESOURCE_IMG_PATH}"
    File /r "resources\images\*.bmp"

    ; SkinBtn::Init "${RESOURCE_IMG_PATH}\btn_strongbtn.bmp"
    ; SkinBtn::Init "${RESOURCE_IMG_PATH}\btn_Close.bmp"
    ; SkinBtn::Init "${RESOURCE_IMG_PATH}\btn_custom.bmp"
    ; SkinBtn::Init "${RESOURCE_IMG_PATH}\btn_install.bmp"
    ; SkinBtn::Init "${RESOURCE_IMG_PATH}\btn_express.bmp"
    ; SkinBtn::Init "${RESOURCE_IMG_PATH}\browse.bmp"

    Call InitiInstallPath
FunctionEnd

Function onGUIInit
  ;消除边框
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    ${NSW_SetWindowSize} $HWNDPARENT 600 480
    System::Call User32::GetDesktopWindow()i.R0
    ;圆角
    System::Alloc 16
    System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
    System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
    IntOp $R3 $R3 - $R1
    IntOp $R4 $R4 - $R2
    System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
    System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
    System::Free $R0
FunctionEnd

Function onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

; Function show
;   ebanner::show /NOUNLOAD /HALIGN=LEFT /VALIGN=BOTTOM "$PLUGINSDIR\Transbg.png"
; FunctionEnd

Function Page.1
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}

    nsDialogs::Create 1044
    Pop $page1HNW
    ${If} $page1HNW == error
        Abort
    ${EndIf}
    SetCtlColors $page1HNW ""  transparent ; set the background be transparent.

    ${NSW_SetWindowSize} $page1HNW 600 480
    ; custon install button
    ${NSD_CreateButton} 480 435 87 14 ""
    Pop $btn_ins
    SkinBtn::Set /IMGID=$(MSG_ImgBtnCustomDown) $btn_ins
    GetFunctionAddress $3 onCustomClick
    SkinBtn::onClick $btn_ins $3

    ;install now button
    ${NSD_CreateButton} 210 350 180 48 ""
    Pop $btn_instetup
    SkinBtn::Set /IMGID=$(MSG_ImgBtnInstall) $btn_instetup
    GetFunctionAddress $3 onClickins
    SkinBtn::onClick $btn_instetup $3
    SetCtlColors $btn_instetup FFFFFF transparent
    
    ;close button 
    ${NSD_CreateButton} 575 0 25 25 ""
    Pop $btn_Close
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\exit.bmp $btn_Close
    GetFunctionAddress $3 onCancel
    SkinBtn::onClick $btn_Close $3
    ;minimize button
    ${NSD_CreateButton} 550 0 25 25 ""
    Pop $1
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\minimize.bmp $1
    GetFunctionAddress $0 MinisizeWindows
    SkinBtn::onClick $1 $0
#------------------------------------------
# widgets when expanded
#------------------------------------------
    ${NSD_CreateLabel} 20 436 80 25 $(MSG_InstallDir)
    Pop $txt_installDir
    SetCtlColors $txt_installDir 363636 FFFFFF
    ${CustomSetFont} $txt_installDir $(un.MSG_FontName) 12 0
    ShowWindow $txt_installDir ${SW_HIDE}
    
    ; the input of install path
    ${NSD_CreateText} 100 435 410 25 $AppFolder
    Pop $txb_AppFolder
    SetCtlColors $txb_AppFolder 363636 FFFFFF
    ${CustomSetFont} $txb_AppFolder $(un.MSG_FontName) 10 550
    ${NSD_SetText} $txb_AppFolder $AppFolder
    ShowWindow $txb_AppFolder ${SW_HIDE}
    
    ; browse button
    ${NSD_CreateButton} 515 435 60 25 $(MSG_BowseText)
    Pop $btn_browse
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\browseBG.bmp $btn_browse
    ${NSD_OnClick} $btn_browse SelectAppFolder
    SetCtlColors $btn_browse FFFFFF transparent
    ${CustomSetFont} $btn_browse $(un.MSG_FontName) 10 0
    ShowWindow $btn_browse ${SW_HIDE}
    
    ${NSD_CreateLabel} 100 472 180 25 $(MSG_FilesSize)
    Pop $txt_FileSize
    SetCtlColors $txt_FileSize 363636 FFFFFF
    ${CustomSetFont} $txt_FileSize $(un.MSG_FontName) 10 550
    ShowWindow $txt_FileSize ${SW_HIDE}
    
    ${DriveSpace} $AppFolder "/D=F /S=G" $R0
    
    ${NSD_CreateLabel} 280 472 200 25 "$(MSG_AvailableSpace) $R0 GB"
    Pop $txt_AvailableSpace
    SetCtlColors $txt_AvailableSpace 363636 FFFFFF
    ${CustomSetFont} $txt_AvailableSpace $(un.MSG_FontName) 10 550
    ShowWindow $txt_AvailableSpace ${SW_HIDE}

#------------------------------------------
# license
#------------------------------------------
    ${NSD_CreateCheckbox} 20 432 100 20 $(MSG_CheckLicense)
    Pop $cbk_license
    SetCtlColors $cbk_license "" FFFFFF
    ${NSD_Check} $cbk_license
    ${NSD_OnClick} $cbk_license Chklicense
    
    ${NSD_CreateLink} 124 435 100 16 $(MSG_License)
    Pop $Txt_Xllicense
    SetCtlColors $Txt_Xllicense 0074F3 FFFFFF
    ${NSD_OnClick} $Txt_Xllicense xllicense
    
    ;Set the image of background
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImageLong
    ${NSD_SetImage} $BGImageLong $(MSG_ImgInstallLongBG) $ImageHandleLong
    ShowWindow $BGImageLong ${SW_HIDE}

    ${NSD_CreateBitmap} 0 0 100% 100%  ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $(MSG_ImgInstallBG) $ImageHandle
    call EnglishPageSmall
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ; handle the window moved
    WndProc::onCallback $BGImageLong $0 ; handle the window moved
    nsDialogs::Show
FunctionEnd

Function Page.1leave
  ${NSD_GetText} $txb_AppFolder  $R0  ; get the install path
  Push $R0
  Push "\"
  Call GetAfterChar
  Pop $0
  ${If} $0 != "${PRODUCT_NAME}"
    StrCpy $R0 "$R0\${PRODUCT_NAME}"
  ${EndIf}

  ; check the path
  ClearErrors
  CreateDirectory "$R0"
  IfErrors 0 +3
  MessageBox MB_ICONINFORMATION|MB_OK "'$R0' $(MSG_DirNotExist)"
  Return
  StrCpy $INSTDIR  $R0
FunctionEnd

; If is English & not expanded, adjust the page
Function EnglishPageSmall
  ${If} $IsEnglish == True
     nsResize::Set $cbk_license 20 432 200 16
     nsResize::Set $Txt_Xllicense 35 450 200 16 
     nsResize::Set $btn_ins 430 435 136 14
   ${EndIf}
FunctionEnd

; If is English & expanded, adjust the page
Function EnglishPageExpand
  ${If} $IsEnglish == True
    nsResize::Set $txt_installDir 20 436 120 25
    nsResize::Set $txb_AppFolder 140 435 350 25
    nsResize::Set $btn_browse  500 435 60 25
    nsResize::Set $cbk_license 20 625 200 20
    nsResize::Set $Txt_Xllicense 35 645 200 16
    nsResize::Set $txt_FileSize 140 472 180 25
    nsResize::Set $txt_AvailableSpace 320 472 200 25
    nsResize::Set $btn_ins 430 635 136 14
  ${EndIf}
FunctionEnd

Function InstFilesPageShow
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;set the background be transparent.

    System::Call "user32::MoveWindow(i $0, i 0, i 0, i 600, i 480) i r2"
    ${ChangeWindowSize} 600 480
    ${NSD_CreateProgressBar} 70 380 460 12 ""
    Pop $PB_ProgressBar
    SkinProgress::Set $PB_ProgressBar "${RESOURCE_IMG_PATH}\progress.bmp" "${RESOURCE_IMG_PATH}\progressBG.bmp"
    
    ;close button 
    ${NSD_CreateButton} 575 0 25 25 ""
    Pop $btn_Close
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\exit.bmp $btn_Close
    GetFunctionAddress $3 onCancel
    SkinBtn::onClick $btn_Close $3
    EnableWindow $btn_Close 0

    ;minimize button
    ${NSD_CreateButton} 550 0 25 25 ""
    Pop $1
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\minimize.bmp $1
    GetFunctionAddress $0 MinisizeWindows
    SkinBtn::onClick $1 $0

    StrCpy $0 $(MSG_Installing)
    ${NSD_CreateLabel} 210 408 300 25 $0
    Pop $txt_intallStatus
    SetCtlColors $txt_intallStatus 363636 FFFFFF
    ${CustomSetFont} $txt_intallStatus $(un.MSG_FontName) 14 550

    ${NSD_CreateButton} 50 350 42 31 "0%"
    Pop $AirBubblesImage
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\bubbles.bmp $AirBubblesImage
    SetCtlColors $AirBubblesImage 4691f8 transparent
    ${CustomSetFont} $AirBubblesImage "Arial" 10 400

    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $(MSG_ImgInstallBG) $ImageHandle

    GetFunctionAddress $0 AirBubblesPosition
    nsDialogs::CreateTimer $0 1000
    
    GetFunctionAddress $0 NSD_TimerFun
    nsDialogs::CreateTimer $0 1
    
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ; handle the window moved
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
FunctionEnd

; install finished
Function InstallFilesFinish
FunctionEnd

Var proPosition
Function AirBubblesPosition
  SendMessage $PB_ProgressBar ${PBM_GETPOS} 0 0 $0
  IntOp $1 $0 + 1
  ${IF} $proPosition < 95
    SendMessage $PB_ProgressBar ${PBM_SETPOS} $1 0
    IntOp $proPosition $0 + 0
    ${NSD_SetText} $AirBubblesImage "$0%"
    IntOp $0 $0 * 46
    IntOp $0 $0 / 10
    IntOp $0 $0 + 48
    nsResize::Set $AirBubblesImage $0 345 45 31
  ${EndIf}
FunctionEnd

Function NSD_TimerFun
    GetFunctionAddress $0 NSD_TimerFun
    nsDialogs::KillTimer $0
    !if 1   ; whether is running in background, 1 is true
        GetFunctionAddress $0 InstallationMainFun
        BgWorker::CallAndWait
    !else
        Call InstallationMainFun
    !endif
FunctionEnd

Var BANNER
Var COUNT
Var ARCHIVE

Function InstallationMainFun
  SendMessage $PB_ProgressBar ${PBM_SETRANGE32} 0 100

  ##################### uninstall the old version #####################
  ReadRegStr $0 HKLM "${PRODUCT_INST_KEY}" "${PRODUCT_INST_FOLDER_KEY}"
  StrCpy $1 "$0\${PRODUCT_UNINST_NAME}"
  IfFileExists "$1" 0 +4
  ${NSD_SetText} $txt_intallStatus "$(MSG_UninstOld)"
  ExecWait '"$1" /S _?=$0'
  SendMessage $PB_ProgressBar ${PBM_SETPOS} 20 0
  ####################################################

  WriteUninstaller "$INSTDIR\${PRODUCT_UNINST_NAME}"

  ; install files
  ${NSD_SetText} $txt_intallStatus "$(MSG_Installing)"
  SetOutPath "$INSTDIR"
  File /r "CocosCreator\*.*"
  SendMessage $PB_ProgressBar ${PBM_SETPOS} 70 0
  call AirBubblesPosition

  ; write registry
  ${NSD_SetText} $txt_intallStatus "$(MSG_WriteRegs)"
  Call WriterRegistry
  SendMessage $PB_ProgressBar ${PBM_SETPOS} 90 0
  call AirBubblesPosition

  ; create shortcuts
  ${NSD_SetText} $txt_intallStatus "$(MSG_Shortcut)"
  Call CreateShortcut
  SendMessage $PB_ProgressBar ${PBM_SETPOS} 100 0
  call AirBubblesPosition

  Sleep 1000
  Call NextPage
FunctionEnd

; Install finished page
Function InstallFinish
  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  nsDialogs::Create 1044
  Pop $0
  ${If} $0 == error
      Abort
  ${EndIf}
  SetCtlColors $0 ""  transparent ;set the background be transparent.

  ${NSW_SetWindowSize} $0 600 480 ; change the size of the page

  ;close button 
  ${NSD_CreateButton} 575 0 25 25 ""
  Pop $btn_Close
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\exit.bmp $btn_Close
  GetFunctionAddress $3 onClickClose
  SkinBtn::onClick $btn_Close $3

  ;minimize button
  ${NSD_CreateButton} 550 0 25 25 ""
  Pop $1
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\minimize.bmp $1
  GetFunctionAddress $0 MinisizeWindows
  SkinBtn::onClick $1 $0
  
  ; run it now
  ${NSD_CreateButton} 210 380 180 48 ""
  Pop $btn_instend
  SkinBtn::Set /IMGID=$(MSG_ImgBtnExpress) $btn_instend
  GetFunctionAddress $3 onClickexpress
  SkinBtn::onClick $btn_instend $3
  
  ${NSD_CreateBitmap} 234 335 24 24 ""
  Pop $0
  ${NSD_SetImage} $0 ${RESOURCE_IMG_PATH}\successful.bmp $1
  ${If} $IsEnglish == True
    nsResize::Set $0 170 335 24 24
  ${EndIf}
  
  ${NSD_CreateLabel} 266 328 200 50 $(MSG_InstallSuccessful)
  Pop $0
  SetCtlColors $0 363636 FFFFFF
  ${CustomSetFont} $0 $(un.MSG_FontName) 18 400
  
  ${If} $IsEnglish == True 
    nsResize::Set $0 200 330 400 30
  ${EndIf}

  ; open the folder
  ${NSD_CreateButton} 510 436 66 14 ""
  Pop $btn_ins
  SkinBtn::Set /IMGID=$(MSG_ImgBtnOpenFolder) $btn_ins
  GetFunctionAddress $3 OpenFolder
  SkinBtn::onClick $btn_ins $3

  ${If} $IsEnglish == True
     nsResize::Set $btn_ins 486 436 90 14
  ${EndIf}

  ;Set the image of background
  ${NSD_CreateBitmap} 0 0 100% 100% ""
  Pop $BGImage
  ${NSD_SetImage} $BGImage $(MSG_ImgInstallBG) $ImageHandle

  GetFunctionAddress $0 onGUICallback
  WndProc::onCallback $BGImage $0 ; handle the window moved
  nsDialogs::Show

  ${NSD_FreeImage} $ImageHandle
FunctionEnd

Function ABORT
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_ICONSTOP $(MSG_QuitCocos) IDNO CANCEL
  SendMessage $hwndparent ${WM_CLOSE} 0 0
  CANCEL:
  Abort
FunctionEnd

Function onClickins
  Call IsRunning

  StrCpy $R1 ""

  ${NSD_GetText} $txb_AppFolder  $R0 ; get the install path
  Push $R0
  Call PathVerify
  Pop $R1
  ${If} $R0 == none
  ${OrIf} $R0 == ""
    StrCpy $R1 "error"
  ${EndIf}

  ${If} $R1 == "error"
    MessageBox MB_OK $(MSG_IntallPathVerify)
  ${Else}
     Call NextPage
  ${EndIf}
FunctionEnd

; TODO Creator is running
Function IsRunning
  FindProcDLL::FindProc "Cocos.exe"
  Sleep 500
  Pop $R0
  ${If} $R0 != 0
    MessageBox MB_OK $(MSG_PleaseCloseCocos)
    Abort
  ${EndIf}
FunctionEnd

Function SelectAppFolder
  nsDialogs::SelectFolderDialog /NOUNLOAD $(MSG_SelectDir)
  Pop $0
  ${If} $0 != "error"
    Push $0
    Pop $AppFolder
  ${EndIf}
  ${NSD_SetText} $txb_AppFolder $AppFolder
  ${DriveSpace} $AppFolder "/D=F /S=G" $R0
  ${NSD_SetText} $txt_AvailableSpace "$(MSG_AvailableSpace) $R0 GB"
FunctionEnd

Function PathVerify
  Pop $0 
  StrLen $1 $0
  StrCpy $2 ''
  ; 每个中文会给strlen增加2，所以copy 1个字符时，会遇到不可显示字符，会被NSIS自动改成?
  ; 正好?本身是非法路径，所以可以用这个来判断路径是否非法
  ${Do}
    IntOp $1 $1 - 1
    ${IfThen} $1 < 0 ${|}${ExitDo}${|}
    StrCpy $2 $0 1 $1
    ;MessageBox MB_OK $2
    ${If} $2 == '?'
    ${OrIf} $2 == '@'
    ${OrIf} $2 == ' '
    ${OrIf} $2 == '~'
    ${OrIf} $2 == '#'
    ${OrIf} $2 == '$$'
    ${OrIf} $2 == '%'
    ${OrIf} $2 == '^'
    ${OrIf} $2 == '&'
    ${OrIf} $2 == '*'
    ${OrIf} $2 == '('
    ${OrIf} $2 == ')'
    ${OrIf} $2 == '{'
    ${OrIf} $2 == '}'
    ${OrIf} $2 == '['
    ${OrIf} $2 == ']'
    ${OrIf} $2 == '|'
    ${OrIf} $2 == ';'
    ${OrIf} $2 == ','
    ${OrIf} $2 == '.'
    ${OrIf} $2 == '<'
    ${OrIf} $2 == '>'
      ${ExitDo}
    ${EndIf}
  ${Loop}

    ${If} $2 == '?'
    ${OrIf} $2 == '@'
    ${OrIf} $2 == ' '
    ${OrIf} $2 == '~'
    ${OrIf} $2 == '#'
    ${OrIf} $2 == '$$'
    ${OrIf} $2 == '%'
    ${OrIf} $2 == '^'
    ${OrIf} $2 == '&'
    ${OrIf} $2 == '*'
    ${OrIf} $2 == '('
    ${OrIf} $2 == ')'
    ${OrIf} $2 == '{'
    ${OrIf} $2 == '}'
    ${OrIf} $2 == '['
    ${OrIf} $2 == ']'
    ${OrIf} $2 == '|'
    ${OrIf} $2 == ';'
    ${OrIf} $2 == ','
    ${OrIf} $2 == '.'
    ${OrIf} $2 == '<'
    ${OrIf} $2 == '>'
     Push "error"
    ${EndIf}
FunctionEnd

; Handle the goto page
Function RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

Function NextPage
  StrCpy $R9 1 ;Goto the next page
  Call RelGotoPage
  Abort
FunctionEnd

; get the name of the path.
Function GetAfterChar
  Exch $0
  Exch
  Exch $1
  Push $2
  Push $3
  StrCpy $2 0
  loop:
    IntOp $2 $2 - 1
    StrCpy $3 $1 1 $2
    StrCmp $3 "" 0 +3
      StrCpy $0 ""
      Goto exit2
    StrCmp $3 $0 exit1
    Goto loop
  exit1:
    IntOp $2 $2 + 1
    StrCpy $0 $1 "" $2
  exit2:
    Pop $3
    Pop $2
    Pop $1
    Exch $0
FunctionEnd

;custom install button clicked
Function onCustomClick
  ${If} $flag == "True"
    ${ChangeWindowSize} 600 480
    ShowWindow $BGImageLong ${SW_HIDE}
    ShowWindow $BGImage ${SW_SHOW}
    
    ShowWindow $txt_installDir ${SW_HIDE}
    ShowWindow $txb_AppFolder ${SW_HIDE}
    ShowWindow $btn_browse ${SW_HIDE}
    ShowWindow $txt_FileSize ${SW_HIDE}
    ShowWindow $txt_AvailableSpace ${SW_HIDE}
    nsResize::Set $btn_ins 480 435 87 14
    nsResize::Set $cbk_license 20 432 100 20
    nsResize::Set $Txt_Xllicense 124 435 100 16
    SkinBtn::Set /IMGID=$(MSG_ImgBtnCustomDown) $btn_ins
    Call EnglishPageSmall
    Push "False"
    Pop $flag
  ${Else}
    ${ChangeWindowSize} 600 665
    ShowWindow $BGImage ${SW_HIDE}
    ShowWindow $BGImageLong ${SW_SHOW}
    
    ShowWindow $txt_installDir ${SW_SHOW}
    ShowWindow $txb_AppFolder ${SW_SHOW}
    ShowWindow $btn_browse ${SW_SHOW}
    ShowWindow $txt_FileSize ${SW_SHOW}
    ShowWindow $txt_AvailableSpace ${SW_SHOW}
    nsResize::Set $btn_ins 480 635 87 14
    nsResize::Set $cbk_license 20 635 100 20
    nsResize::Set $Txt_Xllicense 124 640 100 16
    SkinBtn::Set /IMGID=$(MSG_ImgBtnCustomUp) $btn_ins
    call EnglishPageExpand
    Push "True"
    Pop $flag
  ${EndIf}
FunctionEnd

; write the registry
Function WriterRegistry
  WriteRegStr HKLM "${PRODUCT_INST_KEY}" "${PRODUCT_INST_FOLDER_KEY}" "$INSTDIR"
  WriteRegStr HKLM "${PRODUCT_INST_KEY}" "${PRODUCT_INST_VERSION_KEY}" "${PRODUCT_VERSION}"
  
  ; Add uninstall in Control Panel
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\${PRODUCT_UNINST_NAME}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\CocosCreator.ico"
FunctionEnd

; create shortcuts
Function CreateShortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_ENTRANCE}" "" "$INSTDIR\${PRODUCT_ENTRANCE}" 0 SW_SHOWNORMAL "" "${PRODUCT_NAME}"
FunctionEnd

;open the install folder
Function OpenFolder
  ExecShell "open" $INSTDIR
FunctionEnd

Function Chklicense
 Pop $cbk_license
  ${NSD_GetState} $cbk_license $0
  ${If} $0 == 1
    EnableWindow $btn_instetup 1 ; enable the install button
    ;EnableWindow $btn_ins 1
  ${Else}
    EnableWindow $btn_instetup 0 ; disable the install button
    ;EnableWindow $btn_ins 0
  ${EndIf}
FunctionEnd

; run now clicked
Function onClickexpress
  ExecShell "open" "$INSTDIR\${PRODUCT_ENTRANCE}"
  Call onClickClose
FunctionEnd

; TODO Show the license file
Function xllicense
  ${If} $IsEnglish == True
    ExecShell "open" "http://api.cocos.com/cn/LICENSE%20AGREEMENT%20CN.pdf"
  ${Else}
    ExecShell "open" "http://api.cocos.com/cn/LICENSE%20AGREEMENT%20CN.pdf"
  ${EndIf}
FunctionEnd

Function OnClickQuitCancel
  ${NSW_DestroyWindow} $WarningForm
  EnableWindow $hwndparent 1
  BringToFront
FunctionEnd

; close button clicked
Function onClickClose
     ${GetProcessInfo} 0 $0 $1 $2 $3 $4
    FindProcDLL::FindProc "$3"
    Sleep 500
    Pop $R0
    ${If} $R0 != 0
    KillProcDLL::KillProc "$3"
    ${EndIf}
FunctionEnd

Function onCancel
  IsWindow $WarningForm Create_End
  !define Style ${WS_VISIBLE}|${WS_OVERLAPPEDWINDOW}
  ${NSW_CreateWindowEx} $WarningForm $hwndparent ${ExStyle} ${Style} "" 1018

  ${NSW_SetWindowSize} $WarningForm 240 150
  EnableWindow $hwndparent 0
  System::Call `user32::SetWindowLong(i$WarningForm,i${GWL_STYLE},0x9480084C)i.R0`

  ${NSW_CreateButton} 130 102 90 28 ''
  Pop $R0
  StrCpy $1 $R0
  SkinBtn::Set /IMGID=$(MSG_ImgBtnNotInstall) $1
  ${NSW_OnClick} $R0 onClickClose

  ${NSW_CreateButton} 20 102 90 28 ''
  Pop $R0
  StrCpy $1 $R0
  SkinBtn::Set /IMGID=$(MSG_ImgBtnYes) $1
  ${NSW_OnClick} $R0 OnClickQuitCancel

  ${NSW_CreateLabel} 100 5 80 25 $(MSG_Tooltip)
  Pop $0
  SetCtlColors $0 ffffff transparent
  ${CustomSetFont} $0 "Arial" 12 0
  ${If} $IsEnglish == True
    nsResize::Set $0 80 5 80 25
  ${EndIf}
  ${NSW_CreateLabel} 60 60 180 50 $(MSG_TooltipText)
  Pop $0
  SetCtlColors $0 363636 transparent
  ${CustomSetFont} $0 "Arial" 12 0
    ${If} $IsEnglish == True
    nsResize::Set $0 30 50 180 50
  ${EndIf}

  ;close button 
  ${NSW_CreateButton} 215 0 25 25 ""
  Pop $0
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\exit.bmp $0
   ${NSW_OnClick} $0 OnClickQuitCancel
  
  ${NSW_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
  ${NSW_SetImage} $BGImage ${RESOURCE_IMG_PATH}\quit.bmp $ImageHandle
  GetFunctionAddress $0 onGUICallback
  WndProc::onCallback $BGImage $0 ; handle the window moved
  ${NSW_CenterWindow} $WarningForm $hwndparent
  ${NSW_Show}
  Create_End:
  ShowWindow $WarningForm ${SW_SHOW}
FunctionEnd

; minimize the window
Function MinisizeWindows
  ShowWindow $HWNDPARENT ${SW_MINIMIZE}
FunctionEnd

; init the install path
Function InitiInstallPath
  ReadRegStr $0 HKLM "${PRODUCT_INST_KEY}" "${PRODUCT_INST_FOLDER_KEY}"
  StrCpy $AppFolder "${PEODUCT_DEFAULT_INST_PATH}"
  ${If} $0 != ""
    StrCpy $AppFolder $0
  ${EndIf}

  ${DriveSpace} $AppFolder "/D=F /S=G" $R0
  ${NSD_SetText} $txt_AvailableSpace "$(MSG_AvailableSpace) $R0 GB"
FunctionEnd

;; Section MainSetup
;;   Sleep 1000
;;   SetDetailsPrint None ; not show anything
;;   nsisSlideshow::Show /NOUNLOAD /auto=$PLUGINSDIR\Slides.dat
;;   Sleep 500 ;在安装程序里暂停执行 "休眠时间(单位为:ms)" 毫秒。"休眠时间(单位为:ms)" 可以是一个变量， 例如 "$0" 或一个数字，例如 "666"。
;; 
;;   SetOutPath $INSTDIR
;;   SendMessage $PB_ProgressBar ${PBM_SETRANGE} 0 100
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 10 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 20 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 30 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 40 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 50 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 60 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 70 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 80 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 90 0
;;   Sleep 1000
;;   SendMessage $PB_ProgressBar ${PBM_SETPOS} 100 0
;;   nsisSlideshow::Stop
;;   SetAutoClose true
;; SectionEnd
;; 
;; Section -Post
;;   WriteUninstaller "$INSTDIR\${PRODUCT_UNINST_NAME}" ; generate the uninstaller
;; SectionEnd

; uninstall related
Var toolTipText
Var ck1
Var ck1Text
Var ck1Flag

Var ck2
Var ck2Text
Var ck2Flag

Var ck3
Var ck3Text
Var ck3Flag

Var ck4
Var ck4Text
Var ck4Flag

Var ck5
Var ck5Text
Var ck5Flag

Var ck6
Var ck6Text
Var ck6Flag

Var ck7
Var ck7Text
Var ck7Flag

Var ck8
Var ck8Text
Var ck8Flag

Var otherText

Function un.onInit
  ${If} $LANGUAGE == 1033
    Push True
    Pop $IsEnglish
  ${Else}
    Push False
    Pop $IsEnglish
  ${EndIf}

  InitPluginsDir

  ; unzip the resources files
  SetOutPath "${RESOURCE_IMG_PATH}"
  File /r "resources\images\*.bmp"
  File "resources\Skin\CocosCreator.vsf"

  NSISVCLStyles::LoadVCLStyle  ${RESOURCE_IMG_PATH}\CocosCreator.vsf

  ; SkinBtn::Init "${RESOURCE_IMG_PATH}\ck1.bmp"
  ; SkinBtn::Init "${RESOURCE_IMG_PATH}\ck1_1.bmp"
FunctionEnd

Function un.onGUIInit1
  System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`

  ; hide some widgets
  GetDlgItem $0 $HWNDPARENT 1034
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1035
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1036
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1037
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1038
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1039
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1256
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1028
  ShowWindow $0 ${SW_HIDE}

  ${NSW_SetWindowSize} $HWNDPARENT 520 400 ; change the size of window
  System::Call User32::GetDesktopWindow()i.R0
  ;圆角
  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0
FunctionEnd

; uninstall welcome page
Function un.UnPageWelcome
  GetDlgItem $0 $HWNDPARENT 1 ; Next/Close button
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2 ; cancel button
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3 ; Pre button
  ShowWindow $0 ${SW_HIDE}

  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}
  
  nsDialogs::Create /NOUNLOAD 1044
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}
  SetCtlColors $0 ""  transparent ;set the background be transparent.
  ${NSW_SetWindowSize} $0 520 400 ; change the size of the page

  ${NSD_CreateLabel} 20 11 100 30 $(un.MSG_CocosUninstaller)
  Pop $R1
  NSISVCLStyles::RemoveStyleControl $R1
  SetCtlColors $R1 A7BAF5 transparent
  ${CustomSetFont} $R1 $(un.MSG_FontName) 16 400
  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $R1 $0

  ;close button 
  ${NSD_CreateButton} 495 0 25 25 ""
  Pop $btn_Close
  NSISVCLStyles::RemoveStyleControl $btn_Close
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\exit.bmp $btn_Close

  ;minimize button
  ${NSD_CreateButton} 470 0 25 25 ""
  Pop $1
  NSISVCLStyles::RemoveStyleControl $1
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\minimize.bmp $1

  ; uninstall 
  ${NSD_CreateButton} 112 325 138 42 ""
  Pop $0
  NSISVCLStyles::RemoveStyleControl $0
  SkinBtn::Set /IMGID=$(MSG_ImgBtnUninstall) $0
  GetFunctionAddress $3 un.NextPage
  SkinBtn::onClick $0 $3

  ; cancel uninstall
  ${NSD_CreateButton} 282 325 138 42 ""
  Pop $0
  NSISVCLStyles::RemoveStyleControl $0
  SkinBtn::Set /IMGID=$(MSG_ImgBtnCancel1) $0

  ;Set the image of background
  ${NSD_CreateBitmap} 0 0 100% 100% ""
  Pop $BGImage
  ${NSD_SetImage} $BGImage $(un.MSG_ImgUninstallBG) $ImageHandle
  
  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $BGImage $0 ; handle the window moved
  nsDialogs::Show
FunctionEnd

Function un.EnglishPage
  ${If} $IsEnglish == True
    nsResize::Set $ck1 50 92 16 16
    nsResize::Set $ck1Text 76 90 180 30
  
    nsResize::Set $ck2 270 92 16 16
    nsResize::Set $ck2Text 296 90 180 30

    nsResize::Set $ck3 50 122 16 16
    nsResize::Set $ck3Text 76 120 180 30

    nsResize::Set $ck4 270 122 16 16
    nsResize::Set $ck4Text 296 120 180 30

    nsResize::Set $ck5 50 154 16 16
    nsResize::Set $ck5Text 76 152 180 30

    nsResize::Set $ck6 270 154 16 16
    nsResize::Set $ck6Text 296 152 180 30

    nsResize::Set $ck7 50 187 16 16
    nsResize::Set $ck7Text 76 185 180 30
  
    nsResize::Set $ck8 270 187 16 16
    nsResize::Set $ck8Text 296 185 180 30
  ${EndIf}
FunctionEnd

Function un.FeedbackPage
  GetDlgItem $0 $HWNDPARENT 1 ; next/close button
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2 ; cancel button
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3 ; pre button
  ShowWindow $0 ${SW_HIDE}

  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}
 
  nsDialogs::Create /NOUNLOAD 1044
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ;SetCtlColors $0 ""  transparent ;set the background be transparent.
  ${NSW_SetWindowSize} $0 520 400 ; change the size of the page

  ${NSD_CreateLabel} 20 11 100 30 $(un.MSG_CocosUninstaller)
  Pop $R1
  NSISVCLStyles::RemoveStyleControl $R1
  SetCtlColors $R1 A7BAF5 transparent
  ${CustomSetFont} $R1 $(un.MSG_FontName) 10 700
  ;GetFunctionAddress $0 un.onGUICallback
  ;WndProc::onCallback $R1 $0
  
  ;close button 
  ${NSD_CreateButton} 495 0 25 25 ""
  Pop $btn_Close
  NSISVCLStyles::RemoveStyleControl $btn_Close
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\exit.bmp $btn_Close

  ;minimize button
  ${NSD_CreateButton} 470 0 25 25 ""
  Pop $1
  NSISVCLStyles::RemoveStyleControl $1
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\minimize.bmp $1

  ${NSD_CreateLabel} 50 46 300 20 $(un.MSG_LasterTitle)
  pop $0
  NSISVCLStyles::RemoveStyleControl $0
  SetCtlColors $0 fffffff transparent
  ${CustomSetFont} $0 $(un.MSG_FontName) 10 700
  
  ;feedback options begin --------------------------------------------------------------
  ${NSD_CreateButton} 50 92 16 16 ""
  Pop $ck1
  NSISVCLStyles::RemoveStyleControl $ck1
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck1
  GetFunctionAddress $2 un.ck1Click
  SkinBtn::onClick $ck1 $2
  ${NSD_CreateLabel} 76 90 124 20 $(un.MSG_Reason1)
  pop $ck1Text
  NSISVCLStyles::RemoveStyleControl $ck1Text
  SetCtlColors $ck1Text 98c8fe transparent
  ${CustomSetFont} $ck1Text $(un.MSG_FontName) 10 700
  ;GetFunctionAddress $0 un.MouseDown
  ;WndProc::onCallback $ck1Text $0
  
  ${NSD_CreateButton} 270 92 16 16 ""
  Pop $ck2
  NSISVCLStyles::RemoveStyleControl $ck2
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck2
  GetFunctionAddress $2 un.ck2Click
  SkinBtn::onClick $ck2 $2
  ${NSD_CreateLabel} 296 90 130 20 $(un.MSG_Reason2)
  pop $ck2Text
  NSISVCLStyles::RemoveStyleControl $ck2Text
  SetCtlColors $ck2Text 98c8fe transparent
  ${CustomSetFont} $ck2Text $(un.MSG_FontName) 10 700

  ${NSD_CreateButton} 50 122 16 16 ""
  Pop $ck3
  NSISVCLStyles::RemoveStyleControl $ck3
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck3
  GetFunctionAddress $2 un.ck3Click
  SkinBtn::onClick $ck3 $2
  ${NSD_CreateLabel} 76 120 130 20 $(un.MSG_Reason3)
  pop $ck3Text
  NSISVCLStyles::RemoveStyleControl $ck3Text
  SetCtlColors $ck3Text 98c8fe transparent
  ${CustomSetFont} $ck3Text $(un.MSG_FontName) 10 700

  ${NSD_CreateButton} 270 122 16 16 ""
  Pop $ck4
  NSISVCLStyles::RemoveStyleControl $ck4
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck4
  GetFunctionAddress $2 un.ck4Click
  SkinBtn::onClick $ck4 $2
  ${NSD_CreateLabel} 296 120 130 20 $(un.MSG_Reason4)
  pop $ck4Text
  NSISVCLStyles::RemoveStyleControl $ck4Text
  SetCtlColors $ck4Text 98c8fe transparent
  ${CustomSetFont} $ck4Text $(un.MSG_FontName) 10 700

  ${NSD_CreateButton} 50 154 16 16 ""
  Pop $ck5
  NSISVCLStyles::RemoveStyleControl $ck5
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck5
  GetFunctionAddress $2 un.ck5Click
  SkinBtn::onClick $ck5 $2
  ${NSD_CreateLabel} 76 152 130 20 $(un.MSG_Reason5)
  pop $ck5Text
  NSISVCLStyles::RemoveStyleControl $ck5Text
  SetCtlColors $ck5Text 98c8fe transparent
  ${CustomSetFont} $ck5Text $(un.MSG_FontName) 10 700

  ${NSD_CreateButton} 270 154 16 16 ""
  Pop $ck6
  NSISVCLStyles::RemoveStyleControl $ck6
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck6
  GetFunctionAddress $2 un.ck6Click
  SkinBtn::onClick $ck6 $2
  ${NSD_CreateLabel} 296 152 130 20 $(un.MSG_Reason6)
  pop $ck6Text
  NSISVCLStyles::RemoveStyleControl $ck6Text
  SetCtlColors $ck6Text 98c8fe transparent
  ${CustomSetFont} $ck6Text $(un.MSG_FontName) 10 700

  ${NSD_CreateButton} 50 187 16 16 ""
  Pop $ck7
  NSISVCLStyles::RemoveStyleControl $ck7
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck7
  GetFunctionAddress $2 un.ck7Click
  SkinBtn::onClick $ck7 $2
  ${NSD_CreateLabel} 76 185 130 20 $(un.MSG_Reason7)
  pop $ck7Text
  NSISVCLStyles::RemoveStyleControl $ck7Text
  SetCtlColors $ck7Text 98c8fe transparent
  ${CustomSetFont} $ck7Text $(un.MSG_FontName) 10 700

  ${NSD_CreateButton} 270 187 16 16 ""
  Pop $ck8
  NSISVCLStyles::RemoveStyleControl $ck8
  SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck8
  GetFunctionAddress $2 un.ck8Click
  SkinBtn::onClick $ck8 $2
  ${NSD_CreateLabel} 296 185 130 20 $(un.MSG_Reason8)
  pop $ck8Text
  NSISVCLStyles::RemoveStyleControl $ck8Text
  SetCtlColors $ck8Text 98c8fe transparent
  ${CustomSetFont} $ck8Text $(un.MSG_FontName) 10 700
  ; feedback options end --------------------------------------------------------

  nsDialogs::CreateControl EDIT \
    "${__NSD_Text_STYLE}||${ES_MULTILINE}|${ES_WANTRETURN}|${ES_AUTOVSCROLL}|${ES_AUTOHSCROLL}|${WS_BORDER}" \
    "${__NSD_Text_EXSTYLE}" \
    50 220 420 70 \
    $(un.OtherReason)
    Pop $otherText
  SetCtlColors $otherText b6d8fe 418BDB
  ${CustomSetFont} $otherText $(un.MSG_FontName) 10 500
  EnableWindow $otherText 0
  
  ${NSD_CreateButton} 112 325 138 42 ""
  Pop $0
  NSISVCLStyles::RemoveStyleControl $0
    SkinBtn::Set /IMGID=$(MSG_ImgBtnStartUninstall) $0
  GetFunctionAddress $3 un.StarteUninstall
  SkinBtn::onClick $0 $3

  ; cancel button
  ${NSD_CreateButton} 282 325 138 42 ""
  Pop $0
  NSISVCLStyles::RemoveStyleControl $0
  SkinBtn::Set /IMGID=$(MSG_ImgBtnCancel) $0

  ; background
  ${NSD_CreateBitmap} 0 0 100% 100% ""
  Pop $BGImage
  ${NSD_SetImage} $BGImage ${RESOURCE_IMG_PATH}\bg_fb.bmp $ImageHandle
  Call un.EnglishPage
  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $BGImage $0 ; handle the window moved
  nsDialogs::Show
FunctionEnd

Function un.onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

Function un.InstallFiles1
  FindWindow $R2 "#32770" "" $HWNDPARENT

  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $1 $R2 1027
  ShowWindow $0 ${SW_HIDE}

  GetDlgItem $1 $R2 1
  ShowWindow $1 ${SW_HIDE}
  GetDlgItem $1 $R2 2
  ShowWindow $1 ${SW_HIDE}
  GetDlgItem $1 $R2 3
  ShowWindow $1 ${SW_HIDE}

  StrCpy $R0 $R2 ; change the size of the page. Otherwise the background will not show all
  System::Call "user32::MoveWindow(i R0, i 0, i 0, i 520, i 400) i r2"
  SetCtlColors $R0 ""  transparent ; set the background be transparent
  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $R0 $0 ; handle the window moved

  GetDlgItem $R0 $R2 1004  ; set the progress bar position
  System::Call "user32::MoveWindow(i R0, i 16, i 325, i 481, i 18) i r2"

  GetDlgItem $R1 $R2 1006  ; set the label.
  NSISVCLStyles::RemoveStyleControl $R1
  SetCtlColors $R1 ""  FFFFFF ; color with F6F6F6, Cannot set the background transparent
  System::Call "user32::MoveWindow(i R1, i 16, i 350, i 481, i 12) i r2"

  FindWindow $R2 "#32770" "" $HWNDPARENT  ; set the image
  GetDlgItem $R0 $R2 1995
  System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
  ${NSD_SetImage} $R0 ${RESOURCE_IMG_PATH}\bg.bmp $ImageHandle

  ; set the image of progressbar
  FindWindow $R2 "#32770" "" $HWNDPARENT
  GetDlgItem $5 $R2 1004
  ;SkinProgress::Set $5 "${RESOURCE_IMG_PATH}\progress.bmp" "${RESOURCE_IMG_PATH}\progressBG.bmp"
FunctionEnd

Function un.InstallFinish
  GetDlgItem $0 $HWNDPARENT 1 ; Next/close button
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2 ; cancel button
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3 ; Pre button
  ShowWindow $0 ${SW_HIDE}

  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}

  nsDialogs::Create /NOUNLOAD 1044
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}
  SetCtlColors $0 ""  transparent ; set the background be transparent.
  ${NSW_SetWindowSize} $0 520 400 ; change the size of the page.

  ${NSD_CreateLabel} 20 11 100 30 $(un.MSG_CocosUninstaller)
  Pop $R1
  NSISVCLStyles::RemoveStyleControl $R1
  SetCtlColors $R1 A7BAF5 transparent
  ${CustomSetFont} $R1 $(un.MSG_FontName) 16 400
  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $R1 $0

  ; finish button
  ${NSD_CreateButton} 203 311 138 42 $(un.MSG_Finish)
  Pop $0
  NSISVCLStyles::RemoveStyleControl $0
  SkinBtn::Set /IMGID=$(MSG_ImgBtnFinish) $0
  GetFunctionAddress $1 un.FinishClick
  SkinBtn::onClick $0 $1

  ; set the background image
  ${NSD_CreateBitmap} 0 0 100% 100% ""
  Pop $BGImage
  ${NSD_SetImage} $BGImage $(MSG_ImgUnFinishBG) $ImageHandle

  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $BGImage $0 ; handle the window moved
  WndProc::onCallback $BGImageLong $0 ; handle the window moved
  nsDialogs::Show
FunctionEnd

Function un.StarteUninstall
  Call un.IsRunning
  Call un.NextPage
FunctionEnd

Function un.NextPage
  StrCpy $R9 1 ;Goto the next page
  IntCmp $R9 0 0 Move Move
  StrCmp $R9 "X" 0 Move
  StrCpy $R9 "120"
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
  Abort
FunctionEnd

Function un.NSD_TimerFun
    GetFunctionAddress $0 un.NSD_TimerFun
    nsDialogs::KillTimer $0
    !if 1   ; whether running in background, 1 is true.
        GetFunctionAddress $0 un.InstallationMainFun
        BgWorker::CallAndWait
    !else
        Call un.InstallationMainFun
    !endif
FunctionEnd

Function un.InstallationMainFun

FunctionEnd

Function un.FinishClick
SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

; TODO Cocos Creator is running
Function un.IsRunning
  FindProcDLL::FindProc "Cocos.exe"
  Sleep 500
  Pop $R0
  ${If} $R0 != 0
    MessageBox MB_OK $(MSG_PleaseCloseCocos)
    Abort
  ${EndIf}
FunctionEnd

Function un.ck1Click
  ${If} $ck1Flag == "True"
    ShowWindow $ck1Text ${SW_HIDE}
    SetCtlColors $ck1Text 98c8fe transparent
    ShowWindow $ck1Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck1
    Push "False"
    Pop $ck1Flag
  ${Else}
    ShowWindow $ck1Text ${SW_HIDE}
    SetCtlColors $ck1Text fffffff transparent
    ShowWindow $ck1Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck1
    Push "True"
    Pop $ck1Flag
  ${EndIf}
FunctionEnd

Function un.ck2Click
  ${If} $ck2Flag == "True"
    ShowWindow $ck2Text ${SW_HIDE}
    SetCtlColors $ck2Text 98c8fe transparent
    ShowWindow $ck2Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck2
    Push "False"
    Pop $ck2Flag
  ${Else}
    ShowWindow $ck2Text ${SW_HIDE}
    SetCtlColors $ck2Text fffffff transparent
    ShowWindow $ck2Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck2
    Push "True"
    Pop $ck2Flag
  ${EndIf}
FunctionEnd
Function un.ck3Click
  ${If} $ck3Flag == "True"
    ShowWindow $ck3Text ${SW_HIDE}
    SetCtlColors $ck3Text 98c8fe transparent
    ShowWindow $ck3Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck3
    Push "False"
    Pop $ck3Flag
  ${Else}
    ShowWindow $ck3Text ${SW_HIDE}
    SetCtlColors $ck3Text fffffff transparent
    ShowWindow $ck3Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck3
    Push "True"
    Pop $ck3Flag
  ${EndIf}
FunctionEnd
Function un.ck4Click
  ${If} $ck4Flag == "True"
    ShowWindow $ck4Text ${SW_HIDE}
    SetCtlColors $ck4Text 98c8fe transparent
    ShowWindow $ck4Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck4
    Push "False"
    Pop $ck4Flag
  ${Else}
    ShowWindow $ck4Text ${SW_HIDE}
    SetCtlColors $ck4Text fffffff transparent
    ShowWindow $ck4Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck4
    Push "True"
    Pop $ck4Flag
  ${EndIf}
FunctionEnd
Function un.ck5Click
  ${If} $ck5Flag == "True"
    ShowWindow $ck5Text ${SW_HIDE}
    SetCtlColors $ck5Text 98c8fe transparent
    ShowWindow $ck5Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck5
    Push "False"
    Pop $ck5Flag
  ${Else}
    ShowWindow $ck5Text ${SW_HIDE}
    SetCtlColors $ck5Text fffffff transparent
    ShowWindow $ck5Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck5
    Push "True"
    Pop $ck5Flag
  ${EndIf}
FunctionEnd
Function un.ck6Click
  ${If} $ck6Flag == "True"
    ShowWindow $ck6Text ${SW_HIDE}
    SetCtlColors $ck6Text 98c8fe transparent
    ShowWindow $ck6Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck6
    Push "False"
    Pop $ck6Flag
  ${Else}
    ShowWindow $ck6Text ${SW_HIDE}
    SetCtlColors $ck6Text fffffff transparent
    ShowWindow $ck6Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck6
    Push "True"
    Pop $ck6Flag
  ${EndIf}
FunctionEnd
Function un.ck7Click
  ${If} $ck7Flag == "True"
    ShowWindow $ck7Text ${SW_HIDE}
    SetCtlColors $ck7Text 98c8fe transparent
    ShowWindow $ck7Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck7
    EnableWindow $otherText 0
    Push "False"
    Pop $ck7Flag
  ${Else}
    ShowWindow $ck7Text ${SW_HIDE}
    SetCtlColors $ck7Text fffffff transparent
    ShowWindow $ck7Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck7
    EnableWindow $otherText 1
    Push "True"
    Pop $ck7Flag
  ${EndIf}
FunctionEnd
Function un.ck8Click
  ${If} $ck8Flag == "True"
    ShowWindow $ck8Text ${SW_HIDE}
    SetCtlColors $ck8Text 98c8fe transparent
    ShowWindow $ck8Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\ckfalse.bmp $ck8
    Push "False"
    Pop $ck8Flag
  ${Else}
    ShowWindow $ck8Text ${SW_HIDE}
    SetCtlColors $ck8Text fffffff transparent
    ShowWindow $ck8Text ${SW_SHOW}
    SkinBtn::Set /IMGID=${RESOURCE_IMG_PATH}\cktrue.bmp $ck8
    Push "True"
    Pop $ck8Flag
  ${EndIf}
FunctionEnd

Function un.DeleteReg
  DeleteRegValue HKLM "${PRODUCT_INST_KEY}" "${PRODUCT_INST_FOLDER_KEY}"
  DeleteRegValue HKLM "${PRODUCT_INST_KEY}" "${PRODUCT_INST_VERSION_KEY}"
  DeleteRegKey HKLM "${PRODUCT_INST_KEY}"

  ; remove the registry in Control Panel
  DeleteRegKey HKCU "${PRODUCT_UNINST_KEY}"
FunctionEnd

Section Uninstall
  Call un.DeleteReg

  Delete "$INSTDIR\${PRODUCT_UNINST_NAME}"
  RMDir /r /REBOOTOK "$INSTDIR"
  Call un.NextPage
SectionEnd
