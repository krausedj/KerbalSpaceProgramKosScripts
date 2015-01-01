//This script will draw vectors of based on the planet UP coordinate as a base
//and it will draw the SHIP:FACING coordinates.  This is useful to see how the
//ship orientation correlates to controls

DECLARE PARAMETER libshipvec1_init.

IF libshipvec1_init <> 0 {

    SET libshipvec1_vecShipRoll       TO VECDRAW().
    SET libshipvec1_vecShipRoll:SHOW  TO true.
    SET libshipvec1_vecShipRoll:COLOR TO RGB(1,0,0). 
    SET libshipvec1_vecShipRoll:LABEL TO "Roll Axis".
    SET libshipvec1_vecShipRoll:SCALE TO 1.

    SET libshipvec1_vecShipYaw       TO VECDRAW().
    SET libshipvec1_vecShipYaw:SHOW  TO true.
    SET libshipvec1_vecShipYaw:START TO V(0,0,0). 
    SET libshipvec1_vecShipYaw:COLOR TO RGB(1,0,0). 
    SET libshipvec1_vecShipYaw:LABEL TO "Yaw Axis".
    SET libshipvec1_vecShipYaw:SCALE TO 1.

    SET libshipvec1_vecShipPitch       TO VECDRAW().
    SET libshipvec1_vecShipPitch:SHOW  TO true.
    SET libshipvec1_vecShipPitch:COLOR TO RGB(1,0,0). 
    SET libshipvec1_vecShipPitch:LABEL TO "Pitch Axis".
    SET libshipvec1_vecShipPitch:SCALE TO 1.

    SET libshipvec1_vecUpRoll       TO VECDRAW().
    SET libshipvec1_vecUpRoll:SHOW  TO true.
    SET libshipvec1_vecUpRoll:COLOR TO RGB(0,1,0). 
    SET libshipvec1_vecUpRoll:LABEL TO "Up Roll Axis".
    SET libshipvec1_vecUpRoll:SCALE TO 1.

    SET libshipvec1_vecUpYaw       TO VECDRAW().
    SET libshipvec1_vecUpYaw:SHOW  TO true. 
    SET libshipvec1_vecUpYaw:COLOR TO RGB(0,1,0). 
    SET libshipvec1_vecUpYaw:LABEL TO "Up Yaw Axis".
    SET libshipvec1_vecUpYaw:SCALE TO 1.

    SET libshipvec1_vecUpPitch       TO VECDRAW().
    SET libshipvec1_vecUpPitch:SHOW  TO true.
    SET libshipvec1_vecUpPitch:COLOR TO RGB(0,1,0). 
    SET libshipvec1_vecUpPitch:LABEL TO "Up Pitch Axis".
    SET libshipvec1_vecUpPitch:SCALE TO 1.

    SET libshipvec1_vecCtlRoll          TO VECDRAW().
    SET libshipvec1_vecCtlRoll:SHOW     TO true.
    SET libshipvec1_vecCtlRoll:COLOR    TO RGB(0,0,1). 
    SET libshipvec1_vecCtlRoll:LABEL    TO "Roll Ctl".
    SET libshipvec1_vecCtlRoll:SCALE    TO 1.

    SET libshipvec1_vecCtlYaw            TO VECDRAW().
    SET libshipvec1_vecCtlYaw:SHOW       TO true. 
    SET libshipvec1_vecCtlYaw:COLOR      TO RGB(0,0,1). 
    SET libshipvec1_vecCtlYaw:LABEL      TO "Yaw Ctl".
    SET libshipvec1_vecCtlYaw:SCALE      TO 1.

    SET libshipvec1_vecCtlPitch          TO VECDRAW().
    SET libshipvec1_vecCtlPitch:SHOW     TO true.
    SET libshipvec1_vecCtlPitch:COLOR    TO RGB(0,0,1). 
    SET libshipvec1_vecCtlPitch:LABEL    TO "Pitch Ctl".
    SET libshipvec1_vecCtlPitch:SCALE    TO 1.
}
ELSE {

    SET libshipvec1_dirShipRollAxis     TO SHIP:FACING.
    SET libshipvec1_dirShipYawAxis      TO SHIP:FACING * R(90,0,0).
    SET libshipvec1_dirShipPitchAxis    TO SHIP:FACING * R(0,90,0).

    SET libshipvec1_vecShipRoll:START   TO 3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecShipYaw:START    TO 3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecShipPitch:START  TO 3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecShipRoll:VEC     TO 2 * libshipvec1_dirShipRollAxis:VECTOR.
    SET libshipvec1_vecShipYaw:VEC      TO 2 * libshipvec1_dirShipYawAxis:VECTOR.
    SET libshipvec1_vecShipPitch:VEC    TO 2 * libshipvec1_dirShipPitchAxis:VECTOR.

    SET libshipvec1_dirUpRollAxis     TO UP.
    SET libshipvec1_dirUpYawAxis      TO UP * R(90,0,0).
    SET libshipvec1_dirUpPitchAxis    TO UP * R(0,90,0).

    SET libshipvec1_vecUpRoll:START   TO -3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecUpYaw:START    TO -3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecUpPitch:START  TO -3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecUpRoll:VEC     TO libshipvec1_dirUpRollAxis:VECTOR.
    SET libshipvec1_vecUpYaw:VEC      TO libshipvec1_dirUpYawAxis:VECTOR.
    SET libshipvec1_vecUpPitch:VEC    TO libshipvec1_dirUpPitchAxis:VECTOR.

    SET libshipvec1_Controls    TO  (SHIP:FACING - UP) * V(SHIP:CONTROL:PITCH + SHIP:CONTROL:PILOTPITCH, SHIP:CONTROL:YAW + SHIP:CONTROL:PILOTYAW, SHIP:CONTROL:ROLL + SHIP:CONTROL:PILOTROLL).

    SET libshipvec1_vecCtlRoll:START    TO 3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecCtlYaw:START     TO 3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecCtlPitch:START   TO 3 * libshipvec1_dirShipPitchAxis:VECTOR.
    SET libshipvec1_vecCtlRoll:VEC      TO libshipvec1_Controls:Z * libshipvec1_dirShipRollAxis:VECTOR.
    SET libshipvec1_vecCtlYaw:VEC       TO libshipvec1_Controls:Y * libshipvec1_dirShipYawAxis:VECTOR.
    SET libshipvec1_vecCtlPitch:VEC     TO libshipvec1_Controls:X * libshipvec1_dirShipPitchAxis:VECTOR. 
}
