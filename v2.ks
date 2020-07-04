CLEARSCREEN. PRINT "==V2 Launch==".

declare zielzeit is 57.
declare zielkurs is 78.
//libs

run once base.

//run once aim.

//run cd. //COUNTDOWN

launch(false).


//originally at V2 heading was always the same, determined by placing the rocket before start (special marked fin)
Wait 3.0.
LOCK STEERING TO HEADING(zielkurs,55).
LOCK THROTTLE TO 1.0.

//throttle10k().



WAIT zielzeit.
