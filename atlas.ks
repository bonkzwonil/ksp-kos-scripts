run once base.
run once icbm.

//run cd.
launch().

throttle10k().

LIST ENGINES in engList.

for eng in engList {
	if eng:tag = "s0" {
		eng:shutdown.
   }
}

WAIT 2.0.

STAGE.

WAIT 1.5.

//STAGE.

ascent(100000, 0, true, { if ship:MAXTHRUST = 0 { STAGE. WAIT 2. } }).
