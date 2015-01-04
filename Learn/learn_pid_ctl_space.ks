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

RUN LibPidTerm1(1, 0.1, UPDATE_RATE, "PID").

SET KP_PITCH TO libpidterm1_Kp.
SET KI_PITCH TO libpidterm1_Ki.
SET KD_PITCH TO libpidterm1_Kd.

RUN LibPidTerm1(1, 0.1, UPDATE_RATE, "PID").

SET KP_YAW TO libpidterm1_Kp.
SET KI_YAW TO libpidterm1_Ki.
SET KD_YAW TO libpidterm1_Kd.

RUN LibPidTerm1(1, 0.1, UPDATE_RATE, "PID").

SET KP_ROLL TO libpidterm1_Kp.
SET KI_ROLL TO libpidterm1_Ki.
SET KD_ROLL TO libpidterm1_Kd.

SET I_LIMIT_MAX TO 100.
SET I_LIMIT_MIN TO -100.

SET accentDirectionFromUp TO R(0,20,0).

PRINT "All Set". 
CLEARSCREEN.
RUN LibShipVec2(1).

UNTIL exit {
    //SET ctrlErr TO (UP:VECTOR - SHIP:FACING:VECTOR).
    
    SET dirShipRollAxis     TO SHIP:FACING.
    SET dirShipYawAxis      TO SHIP:FACING * R(90,0,0).
    SET dirShipPitchAxis    TO SHIP:FACING * R(0,90,0).
    
    //Something is up with the calculation above and I get an error spike when crossing some boundary.
    
    //PRINT "Accent Error: " + ctrlErr AT (0,0).
    
    SET pidPitchErr TO (0.75 * pidPitchErrPrev) + (0.25 * (dirShipYawAxis - UP):VECTOR:Z * -1).
    RUN LibPid1(UPDATE_RATE, pidPitchErr, pidPitchErrPrev, pidPitchIPrev, KP_PITCH, KI_PITCH, KD_PITCH).
    SET pidPitchErrPrev TO pidPitchErr.
    SET pidPitchIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlPitch TO libpid1_PidOut.
    
    SET startLine TO 1.
    PRINT "Pitch: "                             AT (0,  startLine + 0).
    PRINT " Err: " + round(pidPitchErr, 4)        AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    SET pidYawErr TO (0.75 * pidYawErrPrev) + (0.25 * (dirShipPitchAxis - UP):VECTOR:Z).
    RUN LibPid1(UPDATE_RATE, pidYawErr, pidYawErrPrev, pidYawIPrev, KP_YAW, KI_YAW, KD_YAW).
    SET pidYawErrPrev TO pidYawErr.
    SET pidYawIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlYaw TO libpid1_PidOut.
    
    SET startLine TO 4.
    PRINT "Yaw: "                               AT (0,  startLine + 0).
    PRINT " Err: " + round(pidYawErr, 4)        AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    SET pidRollErr TO (0.75 * pidRollErrPrev) + (0.25 * (MOD((SHIP:FACING:ROLL - 45 + 180), 360) - 180) / 180).
    RUN LibPid1(UPDATE_RATE, pidRollErr, pidRollErrPrev, pidRollIPrev, KP_ROLL, KI_ROLL, KD_ROLL).
    SET pidRollErrPrev TO pidRollErr.
    SET pidRollIPrev TO MAX(MIN(libpid1_I, I_LIMIT_MAX), I_LIMIT_MIN).
    SET ctlRoll TO libpid1_PidOut.
    
    SET startLine TO 7.
    PRINT "Roll: "                              AT (0,  startLine + 0).
    PRINT " Err: " + round(pidRollErr, 4)        AT (0,  startLine + 1).
    PRINT " Out: " + round(libpid1_PidOut, 4)   AT (10, startLine + 1).
    PRINT " P: "   + round(libpid1_P, 4)        AT (0,  startLine + 2).
    PRINT " I: "   + round(libpid1_I, 4)        AT (15, startLine + 2).
    PRINT " D: "   + round(libpid1_D, 4)        AT (30, startLine + 2).
    
    //Control The Ship
    SET SHIP:CONTROL:ROLL TO ctlRoll.
    SET SHIP:CONTROL:YAW TO ctlYaw.
    SET SHIP:CONTROL:PITCH TO ctlPitch.
    
    //Draw useful vectors, takes up lots of time
    RUN LibShipVec2(0).
    
    WAIT UPDATE_RATE.
}