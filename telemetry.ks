parameter prerun is 0.

local t0 is TIME:SECONDS + prerun.
local indexfile is "0:/logs/mission.csv".
local logfilename is "log_" + t0 + ".csv".
local logfile is "0:/logs/" + logfilename.
log logfilename + "," + SHIP:NAME + "," + TIME:CLOCK to indexfile.
local starttime is t0.
local timeprecision is 100.

local loggers is LEX().

loggers:ADD("MET", { return ROUND((TIME:SECONDS - starttime) * timeprecision) / timeprecision. }).
loggers:ADD("THRUST", { return SHIP:AVAILABLETHRUST. }).
loggers:ADD("MAXTHRUST", { return SHIP:MAXTHRUST. }).
loggers:ADD("ALTITUDE", { return ALTITUDE. }).
loggers:ADD("SPEED", { return SHIP:VELOCITY:SURFACE:MAG. }).
loggers:ADD("GROUNDSPEED", { return GROUNDSPEED. }).
loggers:ADD("ACCELERATION", { return SHIP:AVAILABLETHRUST / SHIP:MASS. }).
loggers:ADD("PITCH", { return 90 - VANG(SHIP:UP:VECTOR, SHIP:FACING:FOREVECTOR). }).
loggers:ADD("AoA", { return VANG(SHIP:FACING:FOREVECTOR, SHIP:VELOCITY:SURFACE). }).
loggers:ADD("Q", { return SHIP:Q. }).
loggers:ADD("ETA:APOAPSIS", { return ETA:APOAPSIS. }).
loggers:ADD("APOAPSIS", { return APOAPSIS. }).
loggers:ADD("_PERIAPSIS", { return PERIAPSIS. }). // elements starting with _ are deselected on the plot by default

log loggers:KEYS:JOIN(",") to logfile.

on floor(time:seconds * 20) {
local data is LIST().

for key in loggers:KEYS {
  data:ADD(loggers[key]:CALL()).
}

log data:JOIN(",") to logfile.
PRESERVE.
}
