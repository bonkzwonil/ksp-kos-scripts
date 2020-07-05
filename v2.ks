CLEARSCREEN. PRINT "==V2 Launch==".


// Ziel: Insel :) 
declare zielzeit is 56.  //Ziel: Insel :)
declare zielkurs is 63.
//libs

run once base.

print "Ready".
//STAGE. //(platform)
LOCK THROTTLE TO 0.03.
//run cd. //COUNTDOWN

launch(true).



//originally at V2 heading was always the same fixed bearing, determined by placing the rocket before start (special marked fin)
//for convinience we use heading here
Wait 3.0.
LOCK THROTTLE TO 1.0.
set dir to HEADING(zielkurs,65). 

wait 6.
set timeend to time + zielzeit.
set dir to HEADING(zielkurs,43). //Original V2 was 43°
lock steering to dir.
WAIT zielzeit-6.


LOCK THROTTLE TO 0.0.
lock steering to ship:prograde. //Ballistic flight now
print "ballistische flugphase erreicht.".

//End Program
