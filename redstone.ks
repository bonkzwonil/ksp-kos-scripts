CLEARSCREEN. PRINT "== Redstone (ICBM) Launch ==".


declare targetGeo is LatLng(5.9,-61.5). //Insel :)
declare xtraBurn is 5.5.
declare apo is 50000. 
//libs

run once base.

run once aim.

set dir to aimTraj(targetGeo:LAT,targetGeo:LNG, apo).

print dir.

run cd. //COUNTDOWN

launch(true).


LOCK STEERING TO HEADING(dir:HEADING,85).

throttle10k().

set dir to directionOf(targetGeo:LAT,targetGeo:LNG).

LOCK STEERING TO HEADING(dir:HEADING,60).
LOCK THROTTLE TO 1.0.


local minDist is 1000000000000.
local dist is 0.

until minDist < dist {
	set dir to directionOf(targetGeo:LAT,targetGeo:LNG).
	set vec to vecDrawArgs(ship:position,dir:altitudeposition(0), RGB(1,0,0), "dir", 1.0, TRUE, 1.0).
	local prediction is predictImpact().
	set dist to groundDistance(prediction, targetGeo).
	print dist.
if dist < 60000 { lock throttle to 0.7. }
if dist < 30000 { lock throttle to 0.35. }
if dist < 10000 { lock throttle to 0.15. }
if dist < minDist { set minDist to dist.}

local errVec is rotatefromto(prediction:position, targetGeo:position).
LOCK STEERING TO HEADING(dir:HEADING,60):vector + errVec:vector.

   wait 0.5.
}

print "Reached nearest course error".
print dist.
print "burning " + xtraBurn + "s extra on 50% to reflect athmospheric drag".
LOCK THROTTLE TO 0.5.
WAIT xtraBurn.


LOCK THROTTLE TO 0.0.
print "ballistic phase".

print "MECO".

LIST ENGINES IN allengines.

FOR eng in allengines {
	PRINT eng:name.
	PRINT "CUTOFF".
	eng:SHUTDOWN.
}


print dir:HEADING.
print dir:DISTANCE.

LOCK STEERING TO SHIP:PROGRADE.

WAIT UNTIL eta:apoapsis < 10.



// DOwn

set dir to directionOf(5.9,-61.5).
//RCS ON. // no rcs on redstone
lock steering to dir:position.
WAIT 10.
until altitude < 5000 {
	print dir.
	print dir:distance.
	local tvec is dir:position.
	//if altitude < 20000 { set tvec to ship:prograde:vector. }
	lock steering to tvec.
	set vec to vecDrawArgs(ship:position,dir:altitudeposition(0), RGB(1,0,0), "tvec", 1.0, TRUE, 1.0).
	wait 0.25.
	local err is abs(eulerDist(tvec:normalized, ship:prograde:vector:normalized)).
	print err.
	if  err < 0.05 { lock throttle to 0.1. }
}

