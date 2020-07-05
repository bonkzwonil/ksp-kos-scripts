CLEARSCREEN. PRINT "== Redstone (ICBM) Launch ==".


// CONFIG


//declare targetGeo is LatLng(5.9,-61.5). //Insel :)
declare targetGeo is LatLng(5,-110.0). //Wüste 
declare xtraBurn is 0.1.
declare apo is 100000.
declare pitch_aim is 43.

declare warhead_detach is true.


//END CONFIG



//libs

run once base.

run once icbm.

run cd. //COUNTDOWN

launch(true,0.8).


LOCK STEERING TO HEADING(targetGeo:HEADING,85).

Print "Initial Climb".

WAIT UNTIL ALTITUDE > 7500.

//throttle10k(). //I think redstone is not capable of fine throttling

icbmAscent(targetGeo).

WAIT UNTIL eta:apoapsis < 10.

WAIT 10.

//At apoapsis

if (warhead_detach) { STAGE. }

aimedImpact(targetGeo).


WAIT UNTIL ALTITUDE < 500.


