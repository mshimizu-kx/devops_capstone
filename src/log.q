//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                            File Description                          //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

/
* @file log.q
* @overview Defien log functionality.
\

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                            Global Variable                           //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

/
* @brief Log level enum to be passed to `.log.out`.
\
.log.LEVELS_:`info`warning`error;
.log.INFO_:`.log.LEVELS_$`info; 
.log.WARNING_:`.log.LEVELS_$`warning; 
.log.ERROR_:`.log.LEVELS_$`error;

/
* @brief Maximum number of bytes to show log message.
\
.log.MAXIMUM_DISPLAY_BYTES:700;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                             Functions                                //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

/
* @brief Write log message to standard out/error.
* @param message {string}: Message to write.
* @param level {enum}: Enum value indicating one of `info`warning`error.
* @param display_limit {dynamic}: Maximum bytes to show.
* @type
* - int
* - long
\
.log.out:{[message; level]
  if[not -20h ~ type level;
   -2 "[", string[.z.p], "] ### ERROR ### ", string[.z.h], " ### ", string[.z.u], " ### level must be enum";
   // Escape
   :()
  ];
  $[
    lower[level] in `info`warning;
    -1;
    // `error ~ level
    -2 
  ] "[", string[.z.p], "] ### ", string[upper level], " ### ", string[.z.h], " ### ", string[.z.u], " ### ", .log.MAXIMUM_DISPLAY_BYTES sublist message;
 };

/
* @brief Update maximum length of log message to display.
\
.log.set_maximum_log_length:{[length]
  if[type[length] ~ 6 7h; .log.out["log length must be int or long."; .log.ERROR_]; :()];
  .log.MAXIMUM_DISPLAY_BYTES:length;
 };