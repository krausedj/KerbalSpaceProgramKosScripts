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

SET pidTurnVelErr TO 0.
SET pidTurnVelErrPrev TO 0.
SET pidTurnVelIPrev TO 0.

RUN LibPidTerm1(1, 5, UPDATE_RATE, "PID").

SET KP_PITCH TO libpidterm1_Kp.
SET KI_PITCH TO libpidterm1_Ki.
SET KD_PITCH TO libpidterm1_Kd.

RUN LibPidTerm1(1, 5, UPDATE_RATE, "PID").

SET KP_YAW TO libpidterm1_Kp.
SET KI_YAW TO libpidterm1_Ki.
SET KD_YAW TO libpidterm1_Kd.

RUN LibPidTerm1(1, 5, UPDATE_RATE, "PID").

SET KP_ROLL TO libpidterm1_Kp.
SET KI_ROLL TO libpidterm1_Ki.
SET KD_ROLL TO libpidterm1_Kd.

RUN LibPidTerm1(5, 5, UPDATE_RATE, "PD").

SET KP_TURN_VEL TO libpidterm1_Kp.
SET KI_TURN_VEL TO libpidterm1_Ki.
SET KD_TURN_VEL TO libpidterm1_Kd.

SET I_LIMIT_MAX TO 100.
SET I_LIMIT_MIN TO -100.

SET accentSt_0_TO_TURN TO 0.
SET accentSt_TURN TO 1.
SET accentSt_TO_AP_ENTRY TO 2.
SET accentSt_TO_CIRLE TO 3.
SET accentSt TO accentSt_0_TO_TURN.

SET ACCENT_TURN_ENTRY_ANGLE TO 5.
SET ACCENT_TURN_ENTRY_VERT_VEL TO 400.
SET ACCENT_TURN_EXIT_ANGLE_MAX TO 90.
SET ACCENT_TURN_EXIT_VERT_VEL TO 50.
SET ACCENT_TURN_ENTRY_ALT TO 15000.
SET ACCENT_TURN_EXIT_ALT TO 60000.

SET turnAng to 0.

PRINT "All Set". 
CLEARSCREEN.
//RUN LibShipVec2(1).

UNTIL exit {
    CLEARSCREEN.

    //Print some velocity data about the surface
    SET velSurf TO SQRT(SHIP:VELOCITY:SURFACE:X ^ 2 + SHIP:VELOCITY:SURFACE:Y ^ 2 + SHIP:VELOCITY:SURFACE:Z ^ 2) * (UP - SHIP:VELOCITY:SURFACE:DIRECTION):VECTOR.
    PRINT "Surf V Vert: " + round(velSurf:Z, 2) AT (0, 0).

    IF accentSt = accentSt_0_TO_TURN {
        SET turnAng TO ACCENT_TURN_ENTRY_ANGLE * SHIP:ALTITUDE / ACCENT_TURN_ENTRY_ALT.

        IF SHIP:ALTITUDE > ACCENT_TURN_ENTRY_ALT {
            SET turnAng TO ACCENT_TURN_ENTRY_ANGLE.
            SET ACCENT_TURN_ENTRY_VERT_VEL TO velSurf:Z.
            SET accentSt TO accentSt_TURN.
        }
    }
    ELSE IF accentSt = accentSt_TURN {
        SET vertVelTgt TO ACCENT_TURN_ENTRY_VERT_VEL + (SHIP:ALTITUDE - ACCENT_TURN_ENTRY_ALT) * (ACCENT_TURN_EXIT_VERT_VEL - ACCENT_TURN_ENTRY_VERT_VEL) / (ACCENT_TURN_EXIT_ALT - ACCENT_TURN_ENTRY_ALT).
        PRINT "Tgt V Vert: " + round(vertVelTgt, 2) AT (20, 0).
        
        SET pidTurnVelErr TO (0.75 * pidTurnVelErrPrev) + (0.25 * (vertVelTgt - velSurf:Z)).
        RUN LibPid1(UPDATE_RATE, pidTurnVelErr, pidTurnVelErrPrev, pidTurnVelIPrev, KP_TURN_VEL, KI_TURN_VEL, KD_TURN_VEL).
        SET pidTurnVelErrPrev TO pidTurnVelErr.
        SET pidTurnVelIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
        SET turnAngAct TO libpid1_PidOut.
        
        SET turnAng TO MIN(MAX(0 - turnAngAct, ACCENT_TURN_ENTRY_ANGLE), ACCENT_TURN_EXIT_ANGLE_MAX).
        
        SET startLine TO 13.
        PRINT "Surf Vert Vel: "                     AT (0,  startLine + 0).
        PRINT " Err: " + round(pidTurnVelErr, 4)    AT (0,  startLine + 1).
        PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
        PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
        PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
        PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
        
        IF SHIP:ALTITUDE > ACCENT_TURN_EXIT_ALT
        {
            SET accentSt TO accentSt_TO_AP_ENTRY.
        }
    }
    ELSE
    {
    }
    
    SET accentDirection TO UP - R(0,turnAng,0).
    
    SET dirShipRollAxis     TO SHIP:FACING.
    SET dirShipYawAxis      TO SHIP:FACING * R(90,0,0).
    SET dirShipPitchAxis    TO SHIP:FACING * R(0,90,0).
    
    //Something is up with the calculation above and I get an error spike when crossing some boundary.
    
    SET pidPitchErr TO (0.75 * pidPitchErrPrev) + (0.25 * (dirShipYawAxis - accentDirection):VECTOR:Z * -1).
    RUN LibPid1(UPDATE_RATE, pidPitchErr, pidPitchErrPrev, pidPitchIPrev, KP_PITCH, KI_PITCH, KD_PITCH).
    SET pidPitchErrPrev TO pidPitchErr.
    SET pidPitchIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlPitch TO libpid1_PidOut.
    
    SET startLine TO 4.
    PRINT "Pitch: "                             AT (0,  startLine + 0).
    PRINT " Err: " + round(pidPitchErr, 4)      AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    SET pidYawErr TO (0.75 * pidYawErrPrev) + (0.25 * (dirShipPitchAxis - accentDirection):VECTOR:Z).
    RUN LibPid1(UPDATE_RATE, pidYawErr, pidYawErrPrev, pidYawIPrev, KP_YAW, KI_YAW, KD_YAW).
    SET pidYawErrPrev TO pidYawErr.
    SET pidYawIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlYaw TO libpid1_PidOut.
    
    SET startLine TO 7.
    PRINT "Yaw: "                               AT (0,  startLine + 0).
    PRINT " Err: " + round(pidYawErr, 4)        AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    SET pidRollErr TO (0.75 * pidRollErrPrev) + (0.25 * (MOD((SHIP:FACING:ROLL - 90 + 180), 360) - 180) / 180).
    RUN LibPid1(UPDATE_RATE, pidRollErr, pidRollErrPrev, pidRollIPrev, KP_ROLL, KI_ROLL, KD_ROLL).
    SET pidRollErrPrev TO pidRollErr.
    SET pidRollIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlRoll TO libpid1_PidOut.
    
    SET startLine TO 10.
    PRINT "Roll: "                              AT (0,  startLine + 0).
    PRINT " Err: " + round(pidRollErr, 4)       AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    //Control The Ship
    SET SHIP:CONTROL:ROLL TO ctlRoll.
    SET SHIP:CONTROL:YAW TO ctlYaw.
    SET SHIP:CONTROL:PITCH TO ctlPitch.
    
    //Draw useful vectors, takes up lots of time
    //RUN LibShipVec2(0).
    
    WAIT UPDATE_RATE.
}