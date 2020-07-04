CLEARSCREEN. PRINT "==V3 Hyperadvanced Launch==".

//libs

run once base.

run once aim.

set targetGeo to LatLng(5.9,-61.5).

set dir to aimTraj(5.9,-61.5, 50000).

print dir.

run cd. //COUNTDOWN

launch().


LOCK STEERING TO HEADING(dir:HEADING,88).

throttle10k().

set dir to directionOf(5.9,-61.5).

LOCK STEERING TO HEADING(dir:HEADING,60).
LOCK THROTTLE TO 1.0.


local minDist is 1000000000000.
local dist is 0.

until minDist < dist {
	set dist to groundDistance(predictImpact(), LatLng(5.9, -61.5)).
	print dist.
   if dist < minDist { set minDist to dist.}
   wait 0.5.
}

LOCK THROTTLE TO 0.25.
WAIT 1.0.


LOCK THROTTLE TO 0.0.
print "end".


print dir:HEADING.
print dir:DISTANCE.


WAIT UNTIL eta:apoapsis < 10.



// DOwn

set dir to directionOf(5.9,-61.5).
RCS ON.
lock steering to dir:position.
WAIT 10.
LOCK THROTTLE TO 0.10.
//lock throttle to 0.05.
until altitude < 5000 {
	print dir.
	print dir:distance.
	local tvec is dir:position.
	lock steering to tvec.
	set vec to vecDrawArgs(ship:position,dir:altitudeposition(0), RGB(1,0,0), "tvec", 1.0, TRUE, 1.0).
	wait 0.25.
}

