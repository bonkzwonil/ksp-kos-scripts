CLEARSCREEN. PRINT "==1st Launch==".

LOCK TROTTLE TO 1.0

PRINT "Countdown"

FROM {local countdown is 10.} until countdown = 0 step [set countdown to countdown -1.} do {
	 print "..." + countdown.
	 wait 1.
}

UNTIL SHIP:MAXTHRUST > 0 {
    WAIT 0.5. // pause half a second between stage attempts.
    PRINT "Stage activated.".
    STAGE. // same as hitting the spacebar.
}

WAIT UNTIL SHIP:ALTITUDE > 20000.

STAGE.

