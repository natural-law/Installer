; 更改窗口大小
!macro __ChangeWindowSize width hight
  ${NSW_SetWindowSize} $HWNDPARENT ${width} ${hight}
  ${NSW_SetWindowSize} $page1HNW ${width} ${hight}
  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0
!macroend

; 设置字体
!macro __CustomSetFont controlHWD FontName Size weight
    CreateFont $R1 ${FontName} ${Size} ${weight}
    SendMessage ${controlHWD} ${WM_SETFONT} $R1 1
!macroend

; 关联文件类型
!macro __FileTypeReg extension icon exe desc
  WriteRegExpandStr HKCR ".${extension}" "" "${extension}_FileType"
  WriteRegExpandStr HKCR "${extension}_FileType" "" "${desc}"
  WriteRegExpandStr HKCR "${extension}_FileType\DefaultIcon" "" "${icon}"
  WriteRegExpandStr HKCR "${extension}_FileType\Shell\Open\Command" "" "${exe} %1"
!macroend

; 移动控件位置
!macro __MoveControl controlHWD x y
  nsResize::GetPos ${controlHWD}
  Pop $R1
  Pop $R2
  nsResize::GetSize ${controlHWD}
  Pop $0
  Pop $1
  IntOp $0 $0 - $R1
  IntOp $1 $1 - $R2
  IntOp $R1 $R1 + ${x}
  IntOp $R2 $R2 + ${y}

  nsResize::Set ${controlHWD} $R1 $R2 $0 $1
!macroend
