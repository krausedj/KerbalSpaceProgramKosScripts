//This script just uses a PID and ship controls to control to an angle off UP

SET UPDATE_RATE TO 0.025.

SET exit TO 0.

SET pidPitchErr TO 0.
SET pidPitchErrPrev TO 0.
SET pidPitchIPrev TO 0.

SET pidYawErr TO 0.
SET pidYawErrPrev TO 0.
SET pidYawIPrev TO 0.

SET pidRollErr TO 0.
SET pidRollErrPrev TO 0.
SET pidRollIPrev TO 0.

RUN LibPidTerm1(0.05, 0.01, UPDATE_RATE, "NoOvershoot").

SET KP_BASE TO libpidterm1_Kp.
SET KI_BASE TO libpidterm1_Ki.
SET KD_BASE TO libpidterm1_Kd.

SET KP_PITCH TO KP_BASE.
SET KI_PITCH TO KI_BASE.
SET KD_PITCH TO KD_BASE.

SET KP_YAW TO KP_BASE.
SET KI_YAW TO KI_BASE.
SET KD_YAW TO KD_BASE.

SET KP_ROLL TO KP_BASE.
SET KI_ROLL TO KI_BASE.
SET KD_ROLL TO KD_BASE.

SET I_LIMIT_MAX TO 100.
SET I_LIMIT_MIN TO -100.

SET accentDirectionFromUp TO R(0,20,0).


PRINT "All Set". 
CLEARSCREEN.
RUN LibShipVec1(1).

UNTIL exit {
    SET ctrlErr TO (UP - SHIP:FACING) - accentDirectionFromUp.
    
    //Need to fix the Error Term, Error can never be outside of -180 to 180 for Polar Coordinates
    UNTIL (ctrlErr:PITCH >= -180) AND (ctrlErr:PITCH < 180) {  
        IF ctrlErr:PITCH >= 180 {
            SET ctrlErr TO ctrlErr - R(360,0,0).
        }
        ELSE
        {
            SET ctrlErr TO ctrlErr + R(360,0,0).
        }
    }
    UNTIL (ctrlErr:YAW >= -180) AND (ctrlErr:YAW < 180) {  
        IF ctrlErr:YAW >= 180 {
            SET ctrlErr TO ctrlErr - R(0,360,0).
        }
        ELSE
        {
            SET ctrlErr TO ctrlErr + R(0,360,0).
        }
    }
    UNTIL (ctrlErr:ROLL >= -180) AND (ctrlErr:ROLL < 180) {  
        IF ctrlErr:ROLL >= 180 {
            SET ctrlErr TO ctrlErr - R(0,0,360).
        }
        ELSE
        {
            SET ctrlErr TO ctrlErr + R(0,0,360).
        }
    }
    
    //Something is up with the calculation above and I get an error spike when crossing some boundary.
    
    PRINT "Accent Error: " + ctrlErr AT (0,0).
    
    SET pidPitchErr TO ctrlErr:PITCH.
    RUN LibPid1(UPDATE_RATE, pidPitchErr, pidPitchErrPrev, pidPitchIPrev, KP_PITCH, KI_PITCH, KD_PITCH).
    SET pidPitchErrPrev TO pidPitchErr.
    SET pidPitchIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlPitch TO libpid1_PidOut.
    
    SET startLine TO 1.
    PRINT "Pitch: "                             AT (0,  startLine + 0).
    PRINT " Err: " + round(ctrlErr:PITCH, 4)    AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    SET pidYawErr TO ctrlErr:Yaw.
    RUN LibPid1(UPDATE_RATE, pidYawErr, pidYawErrPrev, pidYawIPrev, KP_YAW, KI_YAW, KD_YAW).
    SET pidYawErrPrev TO pidYawErr.
    SET pidYawIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlYaw TO libpid1_PidOut.
    
    SET startLine TO 4.
    PRINT "Yaw: "                               AT (0,  startLine + 0).
    PRINT " Err: " + round(ctrlErr:YAW, 4)      AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    SET pidRollErr TO ctrlErr:Roll.
    RUN LibPid1(UPDATE_RATE, pidRollErr, pidRollErrPrev, pidRollIPrev, KP_ROLL, KI_ROLL, KD_ROLL).
    SET pidRollErrPrev TO pidRollErr.
    SET pidRollIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlRoll TO libpid1_PidOut.
    
    SET startLine TO 7.
    PRINT "Roll: "                              AT (0,  startLine + 0).
    PRINT " Err: " + round(ctrlErr:ROLL, 4)     AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    //Need to translate from planet coordinates to ship facing coordinates
    //As ship rolls, the Pitch and yaw directions change
    SET shipCtl TO (SHIP:FACING - UP) * V(ctlPitch,ctlYaw,ctlRoll).
    
    //I have no idea why these require invert on some terms
    SET SHIP:CONTROL:ROLL TO -1 * shipCtl:Z.
    SET SHIP:CONTROL:YAW TO shipCtl:Y.
    SET SHIP:CONTROL:PITCH TO -1 * shipCtl:X.
    
    //Draw useful vectors, takes up lots of time
    RUN LibShipVec1(0).
    
    WAIT UPDATE_RATE.
}