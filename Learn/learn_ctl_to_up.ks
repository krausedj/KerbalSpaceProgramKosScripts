//PIDD learn for space control?

SET UPDATE_RATE TO 0.025.

SET exit TO 0.

RUN LibShipVec2(1).

UNTIL exit {
    RUN LibShipVec2(0).
    
    WAIT UPDATE_RATE.
}