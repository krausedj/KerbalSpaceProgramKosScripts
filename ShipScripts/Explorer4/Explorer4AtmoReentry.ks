//This script just uses a PID and ship controls to control to an angle off UP

SET UPDATE_RATE TO 0.025.

SET pchutes TO SHIP:PARTSTAGGED("chute").
SET antennas TO SHIP:PARTSTAGGED("antenna").
SET heatSheilds TO SHIP:PARTSTAGGED("heatSheild").
SET landingLegs TO SHIP:PARTSNAMED("miniLandingLeg").

SET UPPER_ATMO_ALT TO 120000.
SET SHEILD_DECOUPLE_RALT TO 4000.
SET SHEILD_DECOUPLE_SPD TO 250.
SET CHUTE_OPEN_RALT TO 3000.
SET CHUTE_OPEN_SPD TO 150.
SET SURF_SPD TO 0.25.

SET decentSt TO 0.
SET decentSt_SPACE TO 0.
SET decentSt_UPPER_ATMO_ENTER TO 1.
SET decentSt_AIR_BRAKE TO 2.
SET decentSt_FREE_FALL TO 3.
SET decentSt_WAIT_SURFACE TO 4.

SET exit TO 0.

UNTIL exit {
    CLEARSCREEN.

    //Print some velocity data about the surface
    SET velSurf TO SHIP:VELOCITY:SURFACE:MAG * (UP - SHIP:VELOCITY:SURFACE:DIRECTION):VECTOR.
    PRINT "Surf V Vert: " + round(velSurf:Z, 2) AT (0, 0).
    PRINT "decentSt: " + decentSt AT (0,1).

    IF decentSt = decentSt_SPACE {
        LOCK STEERING to (VELOCITY:SURFACE * -1):DIRECTION.
        IF SHIP:ALTITUDE < UPPER_ATMO_ALT {
            SET decentSt TO decentSt_UPPER_ATMO_ENTER.
        }
    }
    ELSE IF decentSt = decentSt_UPPER_ATMO_ENTER {
        FOR ant IN antennas {             
            ant:GETMODULE("ModuleRTAntenna"):DOACTION("deactivate", 1).
        }
        FOR leg IN landingLegs {             
            leg:GETMODULE("ModuleLandingLeg"):DOACTION("raise legs", 1).
        }
        
        SET decentSt TO decentSt_AIR_BRAKE.
    }
    ELSE IF decentSt = decentSt_AIR_BRAKE {
        LOCK STEERING to (VELOCITY:SURFACE * -1):DIRECTION.
        
        IF ALT:RADAR < SHEILD_DECOUPLE_RALT OR SHIP:VELOCITY:SURFACE:MAG < SHEILD_DECOUPLE_SPD {
            FOR heatSheild IN heatSheilds {
                heatSheild:GETMODULE("ModuleDecouple"):DOACTION("decouple", 1).
            }
            
            SET decentSt TO decentSt_FREE_FALL.
        }
    }
    ELSE IF decentSt = decentSt_FREE_FALL {
        LOCK STEERING to (VELOCITY:SURFACE * -1):DIRECTION.
        
        IF ALT:RADAR < CHUTE_OPEN_RALT OR SHIP:VELOCITY:SURFACE:MAG < CHUTE_OPEN_SPD {
            FOR pchute IN pchutes {
                pchute:GETMODULE("ModuleParachute"):DOACTION("deploy", 1).
            }
            FOR leg IN landingLegs {             
                leg:GETMODULE("ModuleLandingLeg"):DOACTION("lower legs", 1).
            }
            
            SET decentSt TO decentSt_WAIT_SURFACE.
        }
    }
    ELSE IF decentSt = decentSt_WAIT_SURFACE {
        UNLOCK STEERING.
        
        IF SHIP:VELOCITY:SURFACE:MAG < SURF_SPD
        {
            FOR ant IN antennas {
                ant:GETMODULE("ModuleRTAntenna"):DOACTION("activate", 0).
            }
            SET exit TO 1.
        }
    }
    
    WAIT UPDATE_RATE.
}

