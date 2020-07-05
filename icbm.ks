PRINT "== ICBM Library (C) bonk ==".

//high level functions

//*** Ballistic Missile ascent.
// Will ascent on the given incline in heading of the Target
// while continously calculating the predicted
// Impact and the deviation of the target
// including those caused by planet rotation
//
// Continues burning until the solution gets worse by
// more burning and then shuts down all engines
// for an ballistic flight
//
// - targetGeo : A Target in geocoordinates
// - incline : Ascent incline
function icbmAscent {
	parameter targetGeo.
	parameter incline is 50.
	parameter xtraBurn is 0.0.
	parameter tick is 0.25.
	parameter debug is false.
	
	LOCK STEERING TO HEADING(targetGeo:HEADING,pitch_aim).
	LOCK THROTTLE TO 1.0.

	local minDist is 100000000000000.
	local dist is 0.

	until minDist < dist-1 and dist < 15000{
		set dir to directionOf(targetGeo:LAT,targetGeo:LNG).
		//set vec to vecDrawArgs(ship:position,dir:altitudeposition(0), RGB(1,0,0), "dir", 1.0, TRUE, 1.0).
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

		if debug {
		local errVec is rotatefromto(prediction:geo:position, targetCalc:position).
			set evecd to vecDrawArgs(prediction:geo:position, targetCalc:position-prediction:geo:position, RGB(1,1,0), "err", 1.0, TRUE, 1.0).
		}


        if dist > 5000 { LOCK STEERING TO HEADING(ship:body:geopositionof(zielV):HEADING,pitch_aim). }
        else { lock steering to "kill". }  //No steer at end because of possible overshooting

		wait tick.
	}
	
	lock steering to ship:prograde.

	print "Reached nearest course error".
	print dist.
	print "burning " + xtraBurn + "s extra on 50% to reflect athmospheric drag".
	LOCK THROTTLE TO 0.5.
	WAIT xtraBurn.


	LOCK THROTTLE TO 0.0.
	
	print "MECO".

	LIST ENGINES IN allengines.

	SET maineng TO allengines [0].

	FOR eng in allengines {
		PRINT eng:name.
		PRINT "CUTOFF".
		eng:SHUTDOWN.
	}

	print "entered ballistic phase".

}



// Aimed Impact
// Aimes geolocation for impacting as ballistic missile
function aimedImpact{
	parameter targetGeo.
	parameter debug is false.
	until altitude < 1000 {
	print "Distance: "+targetGeo:distance.
	local tvec is targetGeo:position.
	//if altitude < 20000 { set tvec to ship:prograde:vector. }
	lock steering to tvec.
	if debug {set vec to vecDrawArgs(ship:position,targetGeo:altitudeposition(0), RGB(1,0,0), "tvec", 1.0, TRUE, 1.0).}
	wait 0.25.
	local err is abs(eulerDist(tvec:normalized, ship:prograde:vector:normalized)).
//	print "ERR: " + err.
//	if  err < 0.10 and altitude < 10000 { maineng:ACTIVATE. lock throttle to 0.25. }
    //print "Temp: "+SHIP:SENSORS:TEMP.
}


}

// prediction and aiming

//Predicts an impact based on prediction simulation
// - step : finegranularity of simulation steps in second
// returns a Lexicon with
//   :GEO = geolocation of impact and
//   :TIME = time of impact
function predictImpact
{
	parameter step is 1.
	local apoPos is POSITIONAT(ship, TIME+eta:apoapsis).
	local apoGeo is ship:body:geopositionof(apoPos).
	// now predict from here a free fall
	local alt is ship:body:altitudeof(apoPos).
	local i is TIME+eta:apoapsis.
	local pos is 0.
	local geo is 0.
	//print alt.
	until alt < 0 {
		//simulate
		set i to i+1.
		set pos to positionat(ship, i).
		set geo to ship:body:geopositionof(pos).
		set alt to ship:body:altitudeof(pos).
		//print alt.
    }
	//print "Impact at".
	//print geo.
	//print i.

	return LEXICON("geo",geo, "time", i).
}

//Euler Distance between 2 vectors
function eulerDist {
	parameter position1.
	parameter position2.
	local x is position1:x - position2:x.
	local y is position1:y - position2:y.
	local z is position1:z - position2:z.

	return sqrt(x*x +y*y + z*z).
}

//Distance between two geo coordinates
function groundDistance {
	parameter geo1.
	parameter geo2.
	return eulerDist(geo1:position, geo2:position).
}


