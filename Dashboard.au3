#include <GUIConstantsEx.au3>
#include <guiconstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <GuiComboBox.au3>

; ===============================================================================================================================
; Description ...: Simple Dashboard
; Author ........: Ufopilot
; Notes .........:
; ===============================================================================================================================


HotKeySet("{ESC}", "_Exit")
; GUI ROWS AND COLS
Global $Rows, $Cols
Global $Width = @DesktopWidth-12
Global $Height = @DesktopHeight-55
Global $MainX = 140
Global $MainY = 30

; Rest
Global $Title = "Dashboard"
Global $myGUI
Global $COLOR_MAIN = 0x333333;0x494E48
Global $COLOR_LEFT_PANEL = 0x464646
Global $COLOR_TITLE_BAR = 0x666666;0x5A6A50
Global $COLOR_TITLE_BAR_TEXT = 0xD8DED3
Global $COLOR_BORDER = 0x696A65
Global $COLOR_HEDEAR_TEXT = 0xC3B54C
Global $COLOR_TEXT = 0xffffff

Global $CHILD_GUIS[0]
Global $aWidgets[0], $aWidgetsContent[0], $aWidgetsHeader[0], $aWidgetsHeaderText[0], $GuiArray[0]
; Buttons
Global $drawNewWidgets,$Button6, $Button7, $iCols, $iRows, $iHeaderText, $iWidget, $iWidget2, $iContent
;Menu
Global $idFilemenu, $idFileitem,$idHelpmenu,$idInfoitem,$idExititem,$idViewmenu,$idViewstatusitem,$idStatuslabel,$idRecentfilesmenu



_Main("  " & $Title, $Width, $Height, Default, Default)


While 1
    Sleep(1000)
WEnd


Func _Main($sTitle, $sWidth, $sHeight, $sX, $sY)
    ;******************************;
	;# Main GUI
	;*****************************;
	$myGUI = GUICreate($sTitle, $sWidth, $sHeight, $sX, $sY, $WS_POPUP)
	GUISetFont(8, 400, 0, "Tahoma")
	GUISetBkColor($COLOR_LEFT_PANEL)
	;******************************;
	;# GUI-Menu
	;*****************************;
	;_DrawMenu()
    ;******************************;
	;# Panels
	;*****************************;
	_DrawTopPanel($sTitle, $sWidth)
	_DrawTopPanelIcons($sWidth)
	_DrawMainPanel()
	_DrawLeftPanel()
	_DrawBottomPanel()
    ;******************************;
	;# widgets
	;*****************************;
    ; load saved Widgets (From inifile)
	;$i = 1
	;For $r = 1 To $Rows
	;	For $c = 1 To $Cols
	;		$hWidget = _DrawWidget("Widget "&$r&":"&$c, _RowCol($r,$c), _GetWidgetWidth(), _GetWidgetHeight())
	;		$aPos = ControlGetPos($myGUI, "", $hWidget)
	;		$Text = GUICtrlCreateLabel($i, $aPos[0]+25, $aPos[1] +30, $aPos[2], $aPos[3])
	;		_ArrayAdd($aVisibleWidgets, $Text)
	;		GUICtrlSetColor($Text, 0xffffff)
	;		GUICtrlSetFont($Text, 20, 800, 0, "Tahoma")
	;		GUICtrlSetBkColor($Text, $GUI_BKCOLOR_TRANSPARENT)
	;		$i +=1
	;	Next
	;Next

	;_DrawWidget("Widget1", _RowCol(1,1), _GetWidgetWidth(), _GetWidgetHeight())
	;_DrawWidget("Widget1", _RowCol(1,2), _GetWidgetWidth(), _GetWidgetHeight())
	;_DrawWidget("Widget1", _RowCol(2,1), _GetWidgetWidth(), _GetWidgetHeight())
	;_DrawWidget("Widget1", _RowCol(2,2), _GetWidgetWidth(), _GetWidgetHeight())
	;;; Widgets End ;;;

	GUISetState(@SW_SHOW)
	While 1
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $drawNewWidgets
				$Rows = GUICtrlRead($iRows)
				$Cols = GUICtrlRead($iCols)
				If Not StringIsInt($Rows) Or Not StringIsInt($Cols) Then
				   MsgBox(1, "Error", "The row/cols value is not a valid integer " & $Rows & "/" & $Cols )
				   ContinueLoop
				EndIf
				$Answer = MsgBox (4, "DrawWidgets" ,"New Widgets - Rows: "&$Rows& " Cols: " & $Cols & @CRLF &"Delete visible widgets?")
				if $Answer = 6 Then
					;First clean out GUIS
					If IsArray($GuiArray) Then
						For $myCount = 0 To UBound($GuiArray) - 1
							ConsoleWrite(@CRLF & $myCount)
							GUIDelete($GuiArray[$myCount])
						Next
					EndIf

				   _ReDrawWidgets()

				   _GUICtrlComboBox_ResetContent($iWidget)
				   _GUICtrlComboBox_ResetContent($iWidget2)
				   For $i=1 To Ubound($aWidgets)-1
					   GUICtrlSetData($iWidget,$i)
                       GUICtrlSetData($iWidget2,$i)
                   Next
				Endif
			Case $Button6
				$Text = GUICtrlRead($iHeaderText)
				$Widget =  GUICtrlRead($iWidget)
				If UBound($aWidgetsHeaderText)-1 >= $Widget Then
					GUICtrlSetData($aWidgetsHeaderText[$Widget], $Text)
				EndIf
			Case $Button7
				$Function = GUICtrlRead($iContent)
				$Widget =  GUICtrlRead($iWidget2)
				iF $widget = "" Then ContinueLoop
				If UBound($aWidgetsContent)-1 >= $Widget Then
					$ContentHandle = $aWidgetsContent[$Widget]
					$aPos = ControlGetPos($myGUI, "", $ContentHandle)
					$w = _GetWidgetWidth()-6
					$h = _GetWidgetHeight()-28
					$x = $aPos[0]-3
					$y = $aPos[1]
					Call($Function, $w, $h, $x, $y)
				EndIf
			;**********************************************************
			; Function-Messages

		EndSwitch
		_ClockMessages()
	WEnd
EndFunc

Func _GetWidgetWidth()
	$MainWidth = $Width-$MainX
    $wWidth = ($MainWidth - (($Cols+1)*10))/$Cols
    return $wWidth
EndFunc

Func _GetWidgetHeight()
	$MainHeight = $Height-$MainY-45
	$wHeight = ($MainHeight - (($Rows+1)*10))/$Rows
	return $wHeight
EndFunc

Func _RowCol($r, $c)
	$x = $MainX + ($c-1) * _GetWidgetWidth()
	$y = $MainY + ($r-1) * _GetWidgetHeight()
	$x = $x +(10*$c)
	$y = $y +(10*$r)

	local $coo[2]
	$coo[0] = $x
	$coo[1] = $y
	return $coo
EndFunc

Func _DrawTopPanelIcons($sWidth)
	;$Exit = GUICtrlCreateLabel("X" , $sWidth - 20 , 0 , 20 , 20 , $SS_CENTER)
	;GUICtrlSetFont($Exit, 10, 800, 0, "Tahoma") ; Bold
	;GUICtrlSetColor($Exit , 0xffffff)
	;GUICtrlSetBkColor($Exit, $COLOR_TITLE_BAR)
	;$Exit = GUICtrlCreateIcon(@ScriptDir & '\icons\delete.ico', -1, $sWidth - 20 , 0 , 20 , 20)
	;$Exit2 = GUICtrlCreateIcon(@ScriptDir & '\icons\minus.ico', -1, $sWidth - 40 , 0 , 20 , 20)
	;$Exit3 = GUICtrlCreateIcon(@ScriptDir & '\icons\plus.ico', -1, $sWidth - 60 , 0 , 20 , 20)
	;GUICtrlSetBkColor($Exit, $GUI_BKCOLOR_TRANSPARENT)

EndFunc

Func _DrawTopPanel($sTitle, $sWidth)
	$Bar = GUICtrlCreateLabel($sTitle , 0 , 0 , $sWidth, $MainY , $SS_NOTIFY , $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont($Bar, $MainY/2, 400, 0, "Tahoma") ; Bold
	GUICtrlSetColor($Bar , $COLOR_TITLE_BAR_TEXT)
	GUICtrlSetBkColor($Bar , $COLOR_TITLE_BAR)
	GUICtrlSetResizing($Bar, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT)
EndFunc

Func _DrawBottomPanel()
	$hBorder = GUICtrlCreateGraphic($MainX+10, $Height-45, $Width - $MainX-20, 35)
	GUICtrlSetColor($hBorder, $COLOR_BORDER)
	GUICtrlSetState($hBorder, $GUI_DISABLE)
EndFunc

Func _DrawLeftPanel()
	$z = 30 + $MainY
	$drawNewWidgets = GUICtrlCreateButton("Draw Widgets ", 10, $z, $MainX - $MainY, 25)
    $z += 30
	GUICtrlCreateLabel("Rows:",12, $z, 30, 20)
	GUICtrlSetColor(-1, $COLOR_HEDEAR_TEXT)
	$iRows = GUICtrlCreateInput("3",60, $z, $MainX/2-12, 20)
	$z += 30
	GUICtrlCreateLabel("Cols:",12, $z, 25, 20)
	GUICtrlSetColor(-1, $COLOR_HEDEAR_TEXT)
	$iCols = GUICtrlCreateInput("5",60, $z, $MainX/2-12, 20)

	$z += 60
	$Button6 = GUICtrlCreateButton("WidgetHeaderText ", 10, $z, $MainX - $MainY, 25)
    $z += 30
	GUICtrlCreateLabel("Widget:",12, $z, 35, 20)
	GUICtrlSetColor(-1, $COLOR_HEDEAR_TEXT)
	$iWidget = GUICtrlCreateCombo("",60, $z, $MainX/2-12, 20,  $CBS_DROPDOWNLIST)
	$z += 30
	GUICtrlCreateLabel("Text:",12, $z, 25, 20)
	GUICtrlSetColor(-1, $COLOR_HEDEAR_TEXT)
	$iHeaderText = GUICtrlCreateInput("New Text",60, $z, $MainX/2-12, 20)

	$z += 60
	$Button7 = GUICtrlCreateButton("WidgetsContent ", 10, $z, $MainX - $MainY, 25)
    $z += 30
	GUICtrlCreateLabel("Widget:",12, $z, 35, 20)
	GUICtrlSetColor(-1, $COLOR_HEDEAR_TEXT)
	$iWidget2 = GUICtrlCreateCombo("",60, $z, $MainX/2-12, 20,  $CBS_DROPDOWNLIST)
	$z += 30
	GUICtrlCreateLabel("Function:",12, $z, 45, 20)
	GUICtrlSetColor(-1, $COLOR_HEDEAR_TEXT)
	$iContent = GUICtrlCreateCombo("Clock",60, $z, $MainX/2-12, 20,  $CBS_DROPDOWNLIST)

EndFunc

Func _DrawMainPanel()
	$MainPanel = GUICtrlCreateGraphic($MainX, $MainY, $Width - $MainX, $Height - $MainY)
	GUICtrlSetBkColor($MainPanel, $COLOR_MAIN)
	GUICtrlSetState($MainPanel, $GUI_DISABLE)
	GUICtrlSetResizing($MainPanel, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT)
EndFunc

Func _DrawHeader($hBorder)
	$aPos = ControlGetPos($myGUI, "", $hBorder)
	$hHeader = GUICtrlCreateGraphic($aPos[0], $aPos[1], $aPos[2], 20)
    GUICtrlSetState($hHeader, $GUI_DISABLE)
	GUICtrlSetColor($hHeader, $COLOR_BORDER)
	GUICtrlSetBkColor($hHeader, $COLOR_LEFT_PANEL)
    GUICtrlSetResizing($hHeader, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT )
	_ArrayAdd($aWidgetsHeader, $hHeader)
	return $hHeader
EndFunc

Func _DrawHeaderText($eText, $hHeader)
	$aPos = ControlGetPos($myGUI, "", $hHeader)
    $Text = GUICtrlCreateLabel($eText, $aPos[0]+5, $aPos[1] +3, $aPos[2], $aPos[3])
    GUICtrlSetColor($Text, $COLOR_HEDEAR_TEXT)
	GUICtrlSetBkColor($Text, $GUI_BKCOLOR_TRANSPARENT)
    GUICtrlSetResizing($Text, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
    _ArrayAdd($aWidgetsHeaderText, $Text)
EndFunc

Func _DrawWidget($eText, $eRowCol, $eWidth, $eHeight)
	$eLeft = $eRowCol[0]
	$eTop = $eRowCol[1]
	$hBorder = GUICtrlCreateGraphic($eLeft, $eTop, $eWidth, $eHeight)
	GUICtrlSetColor($hBorder, $COLOR_BORDER)
	GUICtrlSetState($hBorder, $GUI_DISABLE)
	GUICtrlSetResizing($hBorder, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKHEIGHT )
	If $eText <> "" Then
		$hHeader = _DrawHeader($hBorder)
		_DrawHeaderText($eText, $hHeader)
	EndIf
	_ArrayAdd($aWidgets, $hBorder)
	Return $hBorder
EndFunc

Func _ReDrawWidgets()
	GuiSetState(@SW_LOCK, $myGUI)
	For $i=0 To  UBound($aWidgets)-1
		GUICtrlDelete($aWidgets[$i])
		GUICtrlDelete($aWidgetsHeader[$i])
		GUICtrlDelete($aWidgetsHeaderText[$i])
		GUICtrlDelete($aWidgetsContent[$i])
	Next

	$aWidgets = 0
    dim $aWidgets[1]
	$aWidgetsContent = 0
    dim $aWidgetsContent[1]
	$aWidgetsHeader = 0
    dim $aWidgetsHeader[1]
	$aWidgetsHeaderText = 0
    dim $aWidgetsHeaderText[1]

	$i = 1
	For $r = 1 To $Rows
		For $c = 1 To $Cols
			$hWidget = _DrawWidget("Widget "&$r&":"&$c, _RowCol($r,$c), _GetWidgetWidth(), _GetWidgetHeight())
			$aPos = ControlGetPos($myGUI, "", $hWidget)
			$Text = $i
			$Content = GUICtrlCreateLabel($Text, $aPos[0]+10, $aPos[1] +30, $aPos[2]-20, $aPos[3]-40)
			_ArrayAdd($aWidgetsContent, $Content)
			GUICtrlSetColor($Content, 0xffffff)
			GUICtrlSetFont($Content, 08, 400, 0, "Tahoma")
			GUICtrlSetBkColor($Content, $COLOR_MAIN)
			$i +=1
		Next
	Next
GuiSetState(@SW_UNLOCK, $myGUI)
EndFunc
Func _DrawMenu()
	$idFilemenu = GUICtrlCreateMenu("&File")
    $idFileitem = GUICtrlCreateMenuItem("Open", $idFilemenu)
    GUICtrlSetState(-1, $GUI_DEFBUTTON)
    $idHelpmenu = GUICtrlCreateMenu("?")
    GUICtrlCreateMenuItem("Save", $idFilemenu)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $idInfoitem = GUICtrlCreateMenuItem("Info", $idHelpmenu)
    $idExititem = GUICtrlCreateMenuItem("Exit", $idFilemenu)
    $idRecentfilesmenu = GUICtrlCreateMenu("Recent Files", $idFilemenu, 1)

    GUICtrlCreateMenuItem("", $idFilemenu, 2) ; create a separator line

    $idViewmenu = GUICtrlCreateMenu("View", -1, 1) ; is created before "?" menu
    $idViewstatusitem = GUICtrlCreateMenuItem("Statusbar", $idViewmenu)

EndFunc

Func _Exit()

	Exit
EndFunc

Func _help()
	$Text = @CRLF & "$aPos = ControlGetPos($myGUI, "", $aWidgets[$i])" &@CRLF & "$x= $aPos[0]" & @CRLF & "$y= $aPos[1]" & _
			@CRLF&"$Width = _GetWidgetWidth()" & _
			@CRLF&"$Height = _GetWidgetHeight()" & _
			@CRLF&"$ContentHandle = $aWidgetsContent[$i]" & _
			@CRLF&"$HeaderHandle = $aWidgetsHeader[$i]" & _
			@CRLF&"$HeaderTextHandle = $aWidgetsHeaderText[$i]"
	ConsoleWrite($Text)
EndFunc

;*******************************************************************************
; CLOCK
;*******************************************************************************
Func Clock($w, $h, $x, $y)
	$Clock_GUI = GUICreate("", $w, $h, $x, $y, $WS_POPUP, BitOR($WS_EX_TRANSPARENT,$WS_EX_MDICHILD), $myGUI)
    ; add GUI to Array
	_ArrayAdd($GuiArray, $Clock_GUI)
	GUISetBkColor($COLOR_MAIN, $Clock_GUI)
	$DateLabel = GUICtrlCreateLabel(@MDAY&"."&@MON&"."&@YEAR, 10, 30, "200", 30)
    GUICtrlSetFont(-1, 14, 800, 0, "Tahoma")
	GUICtrlSetColor(-1, $COLOR_TEXT)
	$TimeLabel = GUICtrlCreateLabel("", 10, 60, "200", 30)
	GUICtrlSetColor(-1, 0xDAA520)
	GUICtrlSetFont(-1, 20, 800, 0, "Tahoma")
    GUISetState(@SW_SHOW, $Clock_GUI)
EndFunc

Func _ClockMessages()
	Global $sec
	If $sec <> @SEC Then
		Global $TimeLabel
		$sec = @SEC
		GUICtrlSetData($TimeLabel,@HOUR&":"&@MIN&":"&@SEC)
	EndIf
EndFunc



;https://j2team.github.io/awesome-AutoIt/
