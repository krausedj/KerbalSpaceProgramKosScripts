//Test to see learn about remote tech.

//MODULES allows access to basically all the info about a part

SET antShortList TO SHIP:PARTSTAGGED("AntShort").

FOR antShort IN antShortList {
    SET list1 TO antShort:MODULES.
    FOR item IN list1 {
        PRINT item.
    }
    SET list1 TO antShort:GETMODULE("ModuleRTAntenna"):ALLACTIONS.
    FOR item IN list1 {
        PRINT item.
    }
}

PRINT "Disabling Antenna".

FOR antShort IN antShortList {             
    antShort:GETMODULE("ModuleRTAntenna"):DOACTION("deactivate", 1).
}

WAIT 1.

PRINT "Stage".

STAGE.

WAIT 1.

PRINT "Enabling Antenna".

FOR antShort IN antShortList {             
    antShort:GETMODULE("ModuleRTAntenna"):DOACTION("activate", 1).
}