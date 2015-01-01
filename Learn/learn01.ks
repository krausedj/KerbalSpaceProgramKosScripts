// This was supposed to launch my DELTA heavy clone, but needed PID control cause in space, its cool to see the 
// un-dampened system go crazy, lock steering just wouldn't work
SET surfVec TO VECDRAW().
SET surfVec:SHOW TO true.
SET surfVec:START TO V(0,0,0). 
SET surfVec:COLOR TO RGB(1,0,0). 
SET surfVec:LABEL TO "Surf Prop".
SET surfVec:SCALE TO 1.0.

SET steerVec TO VECDRAW().
SET steerVec:SHOW TO true.
SET steerVec:START TO V(0,0,0). 
SET steerVec:COLOR TO RGB(0,1,0). 
SET steerVec:LABEL TO "Steering Aim".
SET steerVec:SCALE TO 10.0.

SET coreBoosters TO SHIP:PARTSTAGGED("CoreBoosterEng").
SET coreFuel TO SHIP:PARTSTAGGED("CoreBoosterTank").
SET extBoosters TO SHIP:PARTSTAGGED("ExtBoosterEng").
SET extFuel TO SHIP:PARTSTAGGED("ExtBoosterTank").
SET jetEng TO SHIP:PARTSTAGGED("JetEng").

SET boostSt TO 0.

SET boostSt_CORE_INIT_THROT TO 0.
SET boostSt_CORE_WAIT_THROT_DOWN TO 1.
SET boostSt_CORE_THROT_DOWN TO 2.
SET boostSt_EXT_WAIT_THROT_DOWN TO 3.
SET boostSt_EXT_THROT_DOWN TO 4.
SET boostSt_EXT_WAIT_JETTISON TO 5.
SET boostSt_EXT_JETTISON TO 6.
SET boostSt_CORE_THROT_UP TO 7.

SET accentSt TO 0.

SET accentSt_0_TO_TURN TO 0.
SET accentSt_TURN TO 1.
SET accentSt_TO_AP_ENTRY TO 2.
SET accentSt_TO_CIRLE TO 3.

SET ctrlSt TO 0.

SET ctrlSt_SIMPLE_CONTROL TO 0.

SET UPDATE_RATE TO 0.01.

SET CORE_PARTIAL_TRUST TO 35.
SET CORE_THRUST_RATE TO 50 * UPDATE_RATE.
SET EXT_THROT_DOWN_FUEL TO 0.0075.
SET EXT_JETTISON_FUEL TO 0.0005.
SET EXT_JETTISON_TRUST TO 15.
SET EXT_THRUST_RATE TO 100 * UPDATE_RATE.

SET ACCENT_TURN_ENTRY_ANGLE TO 5.
SET ACCENT_TURN_EXIT_ANGLE TO 45.
SET ACCENT_TURN_TURN_RATE TO 1 * UPDATE_RATE.
SET ACCENT_TURN_ALT TO 12000.

SET exit TO 0.
SET turnAng TO 0.

PRINT "All Set". 
UNTIL exit {
    SET vel TO (VELOCITY:SURFACE:x ^ 2 + VELOCITY:SURFACE:y ^ 2 + VELOCITY:SURFACE:z ^ 2) ^ 0.5.
    
	IF boostSt = boostSt_CORE_INIT_THROT {
        LOCK THROTTLE TO 1.0.
        FOR launchX IN coreBoosters {
            launchX:ACTIVATE.
        }
        FOR launchX IN extBoosters {
            launchX:ACTIVATE.
        }
        STAGE.
        SET boostSt TO boostSt_CORE_WAIT_THROT_DOWN.
        PRINT "boostSt_CORE_WAIT_THROT_DOWN".
	}
    IF boostSt = boostSt_CORE_WAIT_THROT_DOWN {
        IF vel > 150.0 {
            SET boostSt TO boostSt_CORE_THROT_DOWN.
            PRINT "boostSt_CORE_THROT_DOWN".
        }
    }
    ELSE IF boostSt = boostSt_CORE_THROT_DOWN
    {
        FOR booster IN coreBoosters {             
            IF booster:THRUSTLIMIT > CORE_PARTIAL_TRUST
            {
                SET booster:THRUSTLIMIT TO booster:THRUSTLIMIT - CORE_THRUST_RATE.
            }
            ELSE
            {
                SET boostSt TO boostSt_EXT_WAIT_THROT_DOWN.
                PRINT "boostSt_EXT_WAIT_THROT_DOWN".
            }
        }
    }
    ELSE IF boostSt = boostSt_EXT_WAIT_THROT_DOWN {
        SET cur_fuel TO 0.
        SET max_fuel TO 0.
        FOR tank IN extFuel {
            FOR res IN tank:RESOURCES {
                SET cur_fuel TO cur_fuel + res:AMOUNT.
                SET max_fuel TO max_fuel + res:CAPACITY.
            }
        }
        SET fuel_norm TO cur_fuel / max_fuel.
        IF fuel_norm < EXT_THROT_DOWN_FUEL
        {
            SET boostSt TO boostSt_EXT_THROT_DOWN.
            PRINT "boostSt_EXT_THROT_DOWN".
        }
    }
    ELSE IF boostSt = boostSt_EXT_THROT_DOWN
    {
        FOR booster IN extBoosters {             
            IF booster:THRUSTLIMIT > EXT_JETTISON_TRUST
            {
                SET booster:THRUSTLIMIT TO booster:THRUSTLIMIT - EXT_THRUST_RATE.
            }
            ELSE
            {
                SET boostSt TO boostSt_EXT_WAIT_JETTISON.
                PRINT "boostSt_EXT_WAIT_JETTISON".
            }
        }
    }
    ELSE IF boostSt = boostSt_EXT_WAIT_JETTISON {
        SET cur_fuel TO 0.
        SET max_fuel TO 0.
        FOR tank IN extFuel {
            FOR res IN tank:RESOURCES {
                SET cur_fuel TO cur_fuel + res:AMOUNT.
                SET max_fuel TO max_fuel + res:CAPACITY.
            }
        }
        SET fuel_norm TO cur_fuel / max_fuel.
        PRINT fuel_norm.
        IF fuel_norm < EXT_JETTISON_FUEL
        {
            FOR jetX IN JetEng {             
                jetX:ACTIVATE.
            }
            FOR booster IN extBoosters {             
                SET booster:THRUSTLIMIT TO 1.
            }
            SET boostSt TO boostSt_EXT_JETTISON.
            PRINT "boostSt_EXT_JETTISON".
        }
    }
    ELSE IF boostSt = boostSt_EXT_JETTISON {
        STAGE.
        SET boostSt TO boostSt_CORE_THROT_UP.
        PRINT "boostSt_CORE_THROT_UP".
    }
    ELSE IF boostSt = boostSt_CORE_THROT_UP {
        FOR booster IN coreBoosters {             
            IF booster:THRUSTLIMIT + CORE_THRUST_RATE <= 100
            {
                SET booster:THRUSTLIMIT TO booster:THRUSTLIMIT + CORE_THRUST_RATE.
            }
            ELSE
            {
                SET booster:THRUSTLIMIT TO 100.
                SET boostSt TO 255.
                PRINT "255".
            }
        }
    }
    ELSE
    {
    }
    
    IF accentSt = accentSt_0_TO_TURN {
        SET turnAng TO -1 * ACCENT_TURN_ENTRY_ANGLE * SHIP:ALTITUDE / ACCENT_TURN_ALT.
        SET ctrlSt TO ctrlSt_SIMPLE_CONTROL.
        
        IF SHIP:ALTITUDE > ACCENT_TURN_ALT {
            SET turnAng TO -1 * ACCENT_TURN_ENTRY_ANGLE.
            SET accentSt TO accentSt_TURN.
            PRINT "accentSt_TURN".
        }
    }
    ELSE IF accentSt = accentSt_TURN {
        SET turnAng TO turnAng - ACCENT_TURN_TURN_RATE.
        SET ctrlSt TO ctrlSt_SIMPLE_CONTROL.
        
        IF turnAng <= -1 * ACCENT_TURN_EXIT_ANGLE
        {
            SET accentSt TO accentSt_TO_AP_ENTRY.
            PRINT "accentSt_TO_AP_ENTRY".
        }
    }
    ELSE
    {
    }
    
    if ctrlSt = ctrlSt_SIMPLE_CONTROL {
        SET ctrl_dir_in TO SHIP:FACING - UP.
        IF MOD(ctrl_dir_in:ROLL, 360) > 180.1 {
            SET SHIP:CONTROL:ROLL TO 0.5.
        }
        ELSE IF MOD(ctrl_dir_in:ROLL, 360) < 179.9 {
            SET SHIP:CONTROL:ROLL TO -0.5.
        }
        ELSE
        {
            SET SHIP:CONTROL:ROLL TO 0.
        }
        
        if ctrl_dir_in:YAW > 180 {
            SET yaw_in TO ctrl_dir_in:YAW - 360.0.
        }
        else
        {
            SET yaw_in TO ctrl_dir_in:YAW.
        }
        
        IF MOD(yaw_in, 360) - turnAng > 0.1 {
            SET SHIP:CONTROL:YAW TO 0.5.
        }
        ELSE IF MOD(yaw_in, 360) - turnAng < -0.1 {
            SET SHIP:CONTROL:YAW TO -0.5.
        }
        ELSE
        {
            SET SHIP:CONTROL:YAW TO 0.
        }
        
        if ctrl_dir_in:PITCH > 180 {
            SET pitch_in TO ctrl_dir_in:PITCH - 360.0.
        }
        else
        {
            SET pitch_in TO ctrl_dir_in:PITCH.
        }
        
        IF MOD(pitch_in, 360) > 0.1 {
            SET SHIP:CONTROL:PITCH TO -0.5.
        }
        ELSE IF MOD(pitch_in, 360) < -0.1 {
            SET SHIP:CONTROL:PITCH TO 0.5.
        }
        ELSE
        {
            SET SHIP:CONTROL:PITCH TO 0.
        }
    }
    ELSE {
    }
        
    IF boostSt = 255 AND accentSt = 255 {
        SET exit TO 1.
    }
    
//    SET temp TO SHIP:FACING - UP.
//    PRINT temp.

    SET surfVec:VEC TO VELOCITY:SURFACE.

    WAIT UPDATE_RATE.
}