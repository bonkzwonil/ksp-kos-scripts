SET apo TO SHIP:OBT:APOAPSIS.
LOCK THROTTLE TO 1.0.

UNTIL SHIP:OBT:PERIAPSIS >= apo {
	  LOCK STEERING TO SHIP:PROGRADE.
	  IF ETA:APOAPSIS < 16 {
	  	  LOCK THROTTLE TO 1.0.
	  }ELSE IF ETA:APOAPSIS < 40{
	  	  LOCK THROTTLE TO 0.5.
	  }ELSE{
	  	  LOCK THROTTLE TO 0.0.
	  }

	  WAIT 0.05.
}
