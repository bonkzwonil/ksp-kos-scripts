// BASE LIB

// by bonk


function launch {
	parameter clamp is true.
	parameter thr is 0.8.
	PRINT "LAUNCH!".
	STAGE.
    FROM {local tr is 0.3.} until tr >= thr step { set tr to tr + 0.01.} do {
	  LOCK THROTTLE TO tr.	 
 	  wait 0.05.
  }
  if clamp {
	PRINT "CLAMP".
	  STAGE. //CLAMPS
	  
  }
  wait 0.5.
  LOCK STEERING TO UP.

	UNTIL AIRSPEED  > 100 {
		SET NEWTHROTTLE TO THROTTLE + 0.01.
		LOCK THROTTLE TO NEWTHROTTLE.
		WAIT 0.2.
	}
}

function throttle10k {
	UNTIL ALTITUDE > 10000 {
		SET VRSF TO SHIP:VELOCITY:SURFACE.
		IF  SHIP:AIRSPEED < 240.0 {
	  		SET NEWTHROTTLE TO THROTTLE + 0.01.
		}ELSE{
	  	   SET NEWTHROTTLE  TO THROTTLE - 0.01.
	   }
       IF NEWTHROTTLE > 1 { SET NEWTHROTTLE  TO 1.0. }
       IF NEWTHROTTLE < 0.4 { SET NEWTHROTTLE  TO 0.4. }

	   LOCK THROTTLE TO NEWTHROTTLE.

	   WAIT 0.2.	
   }

   PRINT "10.000 reached".
}

function ascent {
	parameter apo.
	parameter dir.
	LOCK STEERING TO HEADING(dir:HEADING,88).

	trottle10k().

   LOCK STEERING TO HEADING(dir:HEADING,80).


   UNTIL SHIP:OBT:APOAPSIS > apo {

	  //Cruise by temp
	  IF (SHIP:SENSORS:TEMP < 450 AND SHIP:SENSORS:ACC:Y < 5 ) { //10m0°C or 5 G
	  	  SET NEWTHROTTLE TO THROTTLE + 0.1.
	  }ELSE {
	  	  SET NEWTHROTTLE TO THROTTLE - 0.1.
	  }
	  	IF NEWTHROTTLE > 1 { SET NEWTHROTTLE  TO 1.0. }
		IF NEWTHROTTLE < 0 { SET NEWTHROTTLE  TO 0.0. }
		  
	  	LOCK THROTTLE TO NEWTHROTTLE.

		SET hori TO (1.0 - (SHIP:OBT:APOAPSIS / apo)) * 90.0.

		LOCK STEERING TO HEADING(dir:HEADING, hori).
		PRINT SHIP:OBT:APOAPSIS.
		PRINT hori.
		WAIT 0.25.
}

LOCK THROTTLE TO 0.0.

PRINT "COASTING!".
}

