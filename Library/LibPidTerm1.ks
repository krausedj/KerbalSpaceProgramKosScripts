// PID Controller Term Generator 
// http://en.wikipedia.org/wiki/Ziegler%E2%80%93Nichols_method
// INPUTS:
// libpidterm1_Ku: Ultimate gain
// libpidterm1_Tu: Oscillation period
// libpidterm1_dt: Update rate / delta time of the PID
// libpidterm1_Type: Type of controller to generate
// OUTPUTS:
// libpidterm1_Kp: P term
// libpidterm1_Ki: I term
// libpidterm1_Kd: D term

DECLARE PARAMETER libpidterm1_Ku.
DECLARE PARAMETER libpidterm1_Tu.
DECLARE PARAMETER libpidterm1_dt.
DECLARE PARAMETER libpidterm1_Type.

IF libpidterm1_Type = "P" {
    SET libpidterm1_Kp TO 0.5 * libpidterm1_Ku.
    SET libpidterm1_Ki TO 0.
    SET libpidterm1_Kd TO 0.
}
ELSE IF libpidterm1_Type = "PI" {
    SET libpidterm1_Kp TO 0.45 * libpidterm1_Ku.
    SET libpidterm1_Ki TO (1.2 * libpidterm1_Kp / libpidterm1_Tu) * libpidterm1_dt.
    SET libpidterm1_Kd TO 0.
}
ELSE IF libpidterm1_Type = "PD" {
    SET libpidterm1_Kp TO 0.45 * libpidterm1_Ku.
    SET libpidterm1_Ki TO 0.
    SET libpidterm1_Kd TO (libpidterm1_Kp * libpidterm1_Tu / 8) / libpidterm1_dt.
}
ELSE IF libpidterm1_Type = "PID" {
    SET libpidterm1_Kp TO 0.6 * libpidterm1_Ku.
    SET libpidterm1_Ki TO (2.0 * libpidterm1_Kp / libpidterm1_Tu) * libpidterm1_dt.
    SET libpidterm1_Kd TO (libpidterm1_Kp * libpidterm1_Tu / 8) / libpidterm1_dt.
}
ELSE IF libpidterm1_Type = "PessenIntegral" {
    SET libpidterm1_Kp TO 0.7 * libpidterm1_Ku.
    SET libpidterm1_Ki TO (2.5 * libpidterm1_Kp / libpidterm1_Tu) * libpidterm1_dt.
    SET libpidterm1_Kd TO (libpidterm1_Kp * libpidterm1_Tu / 20) / libpidterm1_dt.
}
ELSE IF libpidterm1_Type = "SomeOvershoot" {
    SET libpidterm1_Kp TO 0.33 * libpidterm1_Ku.
    SET libpidterm1_Ki TO (2.0 * libpidterm1_Kp / libpidterm1_Tu) * libpidterm1_dt.
    SET libpidterm1_Kd TO (libpidterm1_Kp * libpidterm1_Tu / 3) / libpidterm1_dt.
}
ELSE IF libpidterm1_Type = "NoOvershoot" {
    SET libpidterm1_Kp TO 0.2 * libpidterm1_Ku.
    SET libpidterm1_Ki TO (2.0 * libpidterm1_Kp * libpidterm1_Tu) * libpidterm1_dt.
    SET libpidterm1_Kd TO (libpidterm1_Kp * libpidterm1_Tu / 3) / libpidterm1_dt.
}