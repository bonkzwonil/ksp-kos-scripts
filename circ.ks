

PRINT SHIP:OBT:APOAPSIS.
WAIT UNTIL ETA:APOAPSIS < 25.
RCS ON.

PRINT "CIRCULARIZE!".
LOCK STEERING TO SHIP:FACING.
WAIT 5.

SET apo TO SHIP:OBT:APOAPSIS.
LOCK THROTTLE TO 1.0.

UNTIL SHIP:OBT:PERIAPSIS >= apo {
	  LOCK STEERING TO SHIP:PROGRADE.
	  IF ETA:APOAPSIS < 8 {
	  	  LOCK THROTTLE TO 1.0.
	  }ELSE IF ETA:APOAPSIS < 16{
	  	  LOCK THROTTLE TO 0.5.
	  }ELSE{
	  	  LOCK THROTTLE TO 0.0.
	  }

	  WAIT 0.05.
}


PRINT "ORBIT!".
