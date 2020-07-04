PRINT "Countdown".

FROM {local countdown is 10.} until countdown = 0 step {set countdown to countdown -1.} do {
	 print "..." + countdown.
	 wait 1.
}
