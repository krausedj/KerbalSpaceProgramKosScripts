// PID Controller
// Parameters
// libpid1_dt: Time since last execution, or period of PID
// libpid1_err: Error input
// libpid1_errPrev: Previous Error
// libpid1_errIPrev: Previous I Term
// libpid1_KP: Proportional Term
// libpid1_KI: Integral Term
// libpid1_KD: Derivative Term

DECLARE PARAMETER libpid1_dt.
DECLARE PARAMETER libpid1_err.
DECLARE PARAMETER libpid1_errPrev.
DECLARE PARAMETER libpid1_IPrev.
DECLARE PARAMETER libpid1_KP.
DECLARE PARAMETER libpid1_KI.
DECLARE PARAMETER libpid1_KD.

// Calculation of the P term
SET libpid1_P TO  libpid1_KP * libpid1_err.
// Calculation of the I term using Trapezoid for integration of area
SET libpid1_I TO (libpid1_KI * ( ((libpid1_err + libpid1_errPrev) / 2) * libpid1_updateRate )) + libpid1_IPrev.
// Calculation D calculation
SET libpid1_D TO  libpid1_KD * ((libpid1_err - libpid1_errPrev) / libpid1_updateRate).

// Output from this PID
SET libpid1_PidOut TO libpid1_P + libpid1_I + libpid1_D.
