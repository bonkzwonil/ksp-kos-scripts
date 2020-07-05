CLEARSCREEN. PRINT "== Redstone (ICBM) Launch ==".


//declare targetGeo is LatLng(5.9,-61.5). //Insel :)
declare targetGeo is LatLng(5,-110.0). //Wüste 
declare xtraBurn is 0.1.
declare apo is 100000.
declare pitch_aim is 43.
//libs

run once base.

run once aim.

set dir to aimTraj(targetGeo:LAT,targetGeo:LNG, apo).

print dir.

run cd. //COUNTDOWN

launch(true,0.8).


LOCK STEERING TO HEADING(dir:HEADING,85).

WAIT UNTIL ALTITUDE > 7500.

//throttle10k(). //I think redstone is not capable of fine throttling

set dir to directionOf(targetGeo:LAT,targetGeo:LNG).

LOCK STEERING TO HEADING(dir:HEADING,pitch_aim).
LOCK THROTTLE TO 1.0.


local minDist is 1000000000000.
local dist is 0.

until minDist < dist-1 and dist < 15000{
	set dir to directionOf(targetGeo:LAT,targetGeo:LNG).
	set vec to vecDrawArgs(ship:position,dir:altitudeposition(0), RGB(1,0,0), "dir", 1.0, TRUE, 1.0).
	local prediction is predictImpact().

	//Calculate planet rotation
	local rotErr is  targetGeo:VELOCITY:ORBIT * (prediction:time - time):SECONDS .
	local targetCalc is ship:body:geopositionof(targetGeo:position+rotErr).
	set zielV to targetCalc:position - prediction:geo:position.

	set dist to groundDistance(prediction:geo, targetCalc).

	print dist.
if dist < 80000 { lock throttle to 0.6. }
if dist < 50000 { lock throttle to 0.30. }
if dist < 15000 { lock throttle to 0.10. }
if dist < minDist { set minDist to dist.}

local errVec is rotatefromto(prediction:geo:position, targetCalc:position).
set evecd to vecDrawArgs(prediction:geo:position, targetCalc:position-prediction:geo:position, RGB(1,1,0), "err", 1.0, TRUE, 1.0).


if dist > 5000 { LOCK STEERING TO HEADING(ship:body:geopositionof(zielV):HEADING,pitch_aim). }
else { lock steering to "kill". }  //No steer at end because of overshooting
   wait 0.25.
}
lock steering to ship:prograde.

print "Reached nearest course error".
print dist.
print "burning " + xtraBurn + "s extra on 50% to reflect athmospheric drag".
LOCK THROTTLE TO 0.5.
WAIT xtraBurn.


LOCK THROTTLE TO 0.0.
print "ballistic phase".

print "MECO".

LIST ENGINES IN allengines.

SET maineng TO allengines [0].

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

set dir to directionOf(targetGeo:LAT,targetGeo:LNG).
//RCS ON. // no rcs on redstone
lock steering to dir:position.
WAIT 10.
until altitude < 1000 {
	print dir.
	print dir:distance.
	local tvec is dir:position.
	//if altitude < 20000 { set tvec to ship:prograde:vector. }
	lock steering to tvec.
	set vec to vecDrawArgs(ship:position,dir:altitudeposition(0), RGB(1,0,0), "tvec", 1.0, TRUE, 1.0).
	wait 0.25.
	local err is abs(eulerDist(tvec:normalized, ship:prograde:vector:normalized)).
	print err.
//	if  err < 0.10 and altitude < 10000 { maineng:ACTIVATE. lock throttle to 0.25. }
}

