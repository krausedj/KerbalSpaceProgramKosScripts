// PID Controller
// Parameters
// libpidd1_dt: Time since last execution, or period of PID
// libpidd1_err: Error input
// libpidd1_errPrev: Previous Error
// libpidd1_IPrev: Previous I Term
// libpidd1_DPrev: Previous D Term
// libpidd1_KP: Proportional Term
// libpidd1_KI: Integral Term
// libpidd1_KD: Derivative Term

DECLARE PARAMETER libpidd1_dt.
DECLARE PARAMETER libpidd1_err.
DECLARE PARAMETER libpidd1_errPrev.
DECLARE PARAMETER libpidd1_IPrev.
DECLARE PARAMETER libpidd1_DPrev.
DECLARE PARAMETER libpidd1_KP.
DECLARE PARAMETER libpidd1_KI.
DECLARE PARAMETER libpidd1_KD.
DECLARE PARAMETER libpidd1_KD2.

// Calculation of the P term
SET libpidd1_P TO  libpidd1_KP * libpidd1_err.
// Calculation of the I term using Trapezoid for integration of area
SET libpidd1_I TO (libpidd1_KI * ( ((libpidd1_err + libpidd1_errPrev) / 2) * libpidd1_dt )) + libpidd1_IPrev.
// Calculation of D
SET libpidd1_D TO  libpidd1_KD * ((libpidd1_err - libpidd1_errPrev) / libpidd1_dt).
// Calculation of D2
SET libpidd1_D2 TO libpidd1_KD2 * ((libpidd1_D - libpidd1_DPrev) / libpidd1_dt).

// Output from this PID
SET libpidd1_PidOut TO libpidd1_P + libpidd1_I + libpidd1_D + + libpidd1_D2.
