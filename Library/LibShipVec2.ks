//This script will draw vectors of based on the planet UP coordinate as a base
//and it will draw the SHIP:FACING coordinates.  This is useful to see how the
//ship orientation correlates to controls

DECLARE PARAMETER libshipvec2_init.

IF libshipvec2_init <> 0 {

    SET libshipvec2_vecShipRoll       TO VECDRAW().
    SET libshipvec2_vecShipRoll:SHOW  TO true.
    SET libshipvec2_vecShipRoll:COLOR TO RGB(1,0,0). 
    SET libshipvec2_vecShipRoll:LABEL TO "Roll Axis".
    SET libshipvec2_vecShipRoll:SCALE TO 1.

    SET libshipvec2_vecShipYaw       TO VECDRAW().
    SET libshipvec2_vecShipYaw:SHOW  TO true.
    SET libshipvec2_vecShipYaw:START TO V(0,0,0). 
    SET libshipvec2_vecShipYaw:COLOR TO RGB(1,0,0). 
    SET libshipvec2_vecShipYaw:LABEL TO "Yaw Axis".
    SET libshipvec2_vecShipYaw:SCALE TO 1.

    SET libshipvec2_vecShipPitch       TO VECDRAW().
    SET libshipvec2_vecShipPitch:SHOW  TO true.
    SET libshipvec2_vecShipPitch:COLOR TO RGB(1,0,0). 
    SET libshipvec2_vecShipPitch:LABEL TO "Pitch Axis".
    SET libshipvec2_vecShipPitch:SCALE TO 1.

    SET libshipvec2_vecUpRoll       TO VECDRAW().
    SET libshipvec2_vecUpRoll:SHOW  TO true.
    SET libshipvec2_vecUpRoll:COLOR TO RGB(0,1,0). 
    SET libshipvec2_vecUpRoll:LABEL TO "Up Roll Axis".
    SET libshipvec2_vecUpRoll:SCALE TO 1.
    
    SET libshipvec2_vecUp       TO VECDRAW().
    SET libshipvec2_vecUp:SHOW  TO true.
    SET libshipvec2_vecUp:COLOR TO RGB(1,1,0). 
    SET libshipvec2_vecUp:LABEL TO "Up".
    SET libshipvec2_vecUp:SCALE TO 1.

    SET libshipvec2_vecUpYaw       TO VECDRAW().
    SET libshipvec2_vecUpYaw:SHOW  TO true. 
    SET libshipvec2_vecUpYaw:COLOR TO RGB(0,1,0). 
    SET libshipvec2_vecUpYaw:LABEL TO "Up Yaw Axis".
    SET libshipvec2_vecUpYaw:SCALE TO 1.

    SET libshipvec2_vecUpPitch       TO VECDRAW().
    SET libshipvec2_vecUpPitch:SHOW  TO true.
    SET libshipvec2_vecUpPitch:COLOR TO RGB(0,1,0). 
    SET libshipvec2_vecUpPitch:LABEL TO "Up Pitch Axis".
    SET libshipvec2_vecUpPitch:SCALE TO 1.

    SET libshipvec2_vecCtlRoll          TO VECDRAW().
    SET libshipvec2_vecCtlRoll:SHOW     TO true.
    SET libshipvec2_vecCtlRoll:COLOR    TO RGB(0,0,1). 
    SET libshipvec2_vecCtlRoll:LABEL    TO "Roll Ctl".
    SET libshipvec2_vecCtlRoll:SCALE    TO 1.

    SET libshipvec2_vecCtlYaw            TO VECDRAW().
    SET libshipvec2_vecCtlYaw:SHOW       TO true. 
    SET libshipvec2_vecCtlYaw:COLOR      TO RGB(0,0,1). 
    SET libshipvec2_vecCtlYaw:LABEL      TO "Yaw Ctl".
    SET libshipvec2_vecCtlYaw:SCALE      TO 1.

    SET libshipvec2_vecCtlPitch          TO VECDRAW().
    SET libshipvec2_vecCtlPitch:SHOW     TO true.
    SET libshipvec2_vecCtlPitch:COLOR    TO RGB(0,0,1). 
    SET libshipvec2_vecCtlPitch:LABEL    TO "Pitch Ctl".
    SET libshipvec2_vecCtlPitch:SCALE    TO 1.
    
    SET libshipvec2_vecToUpRoll          TO VECDRAW().
    SET libshipvec2_vecToUpRoll:SHOW     TO true.
    SET libshipvec2_vecToUpRoll:COLOR    TO RGB(0,1,1). 
    SET libshipvec2_vecToUpRoll:LABEL    TO "Roll To Up".
    SET libshipvec2_vecToUpRoll:SCALE    TO 1.

    SET libshipvec2_vecToUpYaw           TO VECDRAW().
    SET libshipvec2_vecToUpYaw:SHOW      TO true. 
    SET libshipvec2_vecToUpYaw:COLOR     TO RGB(0,1,1). 
    SET libshipvec2_vecToUpYaw:LABEL     TO "Yaw To Up".
    SET libshipvec2_vecToUpYaw:SCALE     TO 1.

    SET libshipvec2_vecToUpPitch         TO VECDRAW().
    SET libshipvec2_vecToUpPitch:SHOW    TO true.
    SET libshipvec2_vecToUpPitch:COLOR   TO RGB(0,1,1). 
    SET libshipvec2_vecToUpPitch:LABEL   TO "Pitch To Up".
    SET libshipvec2_vecToUpPitch:SCALE   TO 1.
}
ELSE {

    SET libshipvec2_dirShipRollAxis     TO SHIP:FACING.
    SET libshipvec2_dirShipYawAxis      TO SHIP:FACING * R(90,0,0).
    SET libshipvec2_dirShipPitchAxis    TO SHIP:FACING * R(0,90,0).

    SET libshipvec2_vecShipRoll:START   TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecShipYaw:START    TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecShipPitch:START  TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecShipRoll:VEC     TO 2 * libshipvec2_dirShipRollAxis:VECTOR.
    SET libshipvec2_vecShipYaw:VEC      TO 2 * libshipvec2_dirShipYawAxis:VECTOR.
    SET libshipvec2_vecShipPitch:VEC    TO 2 * libshipvec2_dirShipPitchAxis:VECTOR.

    SET libshipvec2_dirUpRollAxis     TO UP.
    SET libshipvec2_dirUpYawAxis      TO UP * R(90,0,0).
    SET libshipvec2_dirUpPitchAxis    TO UP * R(0,90,0).

    SET libshipvec2_vecUpRoll:START   TO -3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecUpYaw:START    TO -3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecUpPitch:START  TO -3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecUpRoll:VEC     TO libshipvec2_dirUpRollAxis:VECTOR.
    SET libshipvec2_vecUpYaw:VEC      TO libshipvec2_dirUpYawAxis:VECTOR.
    SET libshipvec2_vecUpPitch:VEC    TO libshipvec2_dirUpPitchAxis:VECTOR.

    SET libshipvec2_Controls    TO  V(5*SHIP:CONTROL:PITCH + SHIP:CONTROL:PILOTPITCH, 5*SHIP:CONTROL:YAW + SHIP:CONTROL:PILOTYAW, 5*SHIP:CONTROL:ROLL + SHIP:CONTROL:PILOTROLL).

    SET libshipvec2_vecCtlRoll:START    TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecCtlYaw:START     TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecCtlPitch:START   TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecCtlRoll:VEC      TO libshipvec2_Controls:Z * libshipvec2_dirShipRollAxis:VECTOR.
    SET libshipvec2_vecCtlYaw:VEC       TO libshipvec2_Controls:Y * libshipvec2_dirShipYawAxis:VECTOR.
    SET libshipvec2_vecCtlPitch:VEC     TO libshipvec2_Controls:X * libshipvec2_dirShipPitchAxis:VECTOR. 
    
    SET libshipvec2_vecToUpRoll:START    TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecToUpYaw:START     TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecToUpPitch:START   TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    
    //The direction to the up vector
//    SET libshipvec2_vecToUpRoll:VEC      TO (UP - libshipvec2_dirShipRollAxis):VECTOR:Z * libshipvec2_dirShipRollAxis:VECTOR.
//    SET libshipvec2_vecToUpYaw:VEC       TO (UP - libshipvec2_dirShipYawAxis):VECTOR:Z * libshipvec2_dirShipYawAxis:VECTOR.
//    SET libshipvec2_vecToUpPitch:VEC     TO (UP - libshipvec2_dirShipPitchAxis):VECTOR:Z * libshipvec2_dirShipPitchAxis:VECTOR.
    
    //The yaw or pitch to apply
    SET libshipvec2_vecToUpRoll:VEC      TO (UP - libshipvec2_dirShipRollAxis):VECTOR:Z * libshipvec2_dirShipRollAxis:VECTOR.
    SET libshipvec2_vecToUpYaw:VEC       TO (libshipvec2_dirShipPitchAxis - UP):VECTOR:Z * libshipvec2_dirShipYawAxis:VECTOR.
    SET libshipvec2_vecToUpPitch:VEC     TO (libshipvec2_dirShipYawAxis - UP):VECTOR:Z * -1 * libshipvec2_dirShipPitchAxis:VECTOR.

    SET libshipvec2_vecUp:START   TO 3 * libshipvec2_dirShipPitchAxis:VECTOR.
    SET libshipvec2_vecUp:VEC     TO UP:VECTOR.
}
