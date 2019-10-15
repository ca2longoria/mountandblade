/*
Mount & Blade: Warband, Viking Conquest

WARNING: This consumes the use of the middle mouse button.  If you have that
hotkeyed to anything else, I would suggest modifying this to account for that.

WARNING: A few of the position values are hard-coded to reflect my monitor
resolution.  Configuration variables must be changed to match yours.

Quick deposits/withdrawals to/from Garrisons
  . click middle mouse button to Give All of the troop beneath the cursor
  . hold shift when clicking middle mouse button
    . as long as shift is held, the above action will repeat
		. NOTE: this one is finicky; still working on it.

Quick item transfer
  . hold ctrl and click middle mouse button
    . as long as ctrl is held, the mouse will ctrl-click in a grid pattern
      . will treat cursor position as top-left grid
        . and proceed down by rows, rapidly depositing items to the other side
      . limited to 18 blocks, won't keep going forever
*/

; Personal machine configuration values.
giveButtonX = 1915
giveButtonY = 1758

gridItemWidth = 340
gridItemHeight = 245

giveClickSleep = 50
repeatGiveSleep = 80
repeatItemTransferSleep = 0


; Garrison deposit/withdrawal
MButton::
IfWinActive Mount&Blade
{
	GiveClick()
}
Return

; Continuous garrison deposit/withdrawal
+MButton::
IfWinActive Mount&Blade
{
	While GetKeyState("Shift")
	{
		GiveClick()
		Sleep repeatGiveSleep
	}
}
Return

GiveClick()
{
	global giveButtonX
	global giveButtonY
	Click
	MouseGetPos, oldx, oldy
	MouseMove, giveButtonX, giveButtonY, 0
	Sleep, giveClickSleep
	Send {Ctrl Down}
	Send {LButton}
	Send {Ctrl Up}
	Sleep, giveClickSleep
	MouseMove, oldx, oldy, 0
}


; Quick item transfer
^MButton::
IfWinActive Mount&Blade
{
	MouseGetPos, oldx, oldy
	i := 0
	j := 0
	x := 0
	Loop 18
	{
		; Break out early if the Ctrl key is let go of.
		if ! GetKeyState("Ctrl")
			break
		
		; Determine mouse position for current step.
		i := mod(x,3)
		j := x // 3
		xpos := i * gridItemWidth + oldx
		ypos := j * gridItemHeight + oldy
		
		; Ctrl is already down, so the item is transferred.
		MouseMove, %xpos%, %ypos%, 0
		Click
		
		x += 1
		
		Sleep repeatItemTransferSleep
	}
}
Return

