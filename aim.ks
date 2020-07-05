//V2 Aiming

function directionof {
	parameter lat.
	parameter lon.

	set coords to Kerbin:GeopositionLatLng(lat, lon).

	//print "Distance".
	//print coords:distance.

	return coords.
}



function trajMiddle {
	parameter coords.
	local shipcoords is Ship:Geoposition.

	local latdst is (coords:lat - shipcoords:lat) / 2.0.
	local lngdst is (coords:lng - shipcoords:lng) / 2.0.
	
	local middlecoords is LatLng( shipcoords:lat + latdst, shipcoords:lng+lngdst).

	return middlecoords.
}


function aimTraj {
	parameter lat.
	parameter lng.
	parameter alt.
	local coords is trajMiddle(directionOf(lat,lng)).
	//print coords.
	local aim is coords:altitudePosition(alt).
	local dir is rotatefromto(ship:position, aim).
	//vecDrawArgs(ship:position, aim, RGB(1,0,0), "TrajAim", 1.0, TRUE, 1.0).

	return coords.
}

function predictImpact
{
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

function eulerDist {
	parameter position1.
	parameter position2.
	local x is position1:x - position2:x.
	local y is position1:y - position2:y.
	local z is position1:z - position2:z.

	return sqrt(x*x +y*y + z*z).
}

function groundDistance {
	parameter geo1.
	parameter geo2.
	return eulerDist(geo1:position, geo2:position).
}

