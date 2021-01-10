//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                            File Description                          //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

/
* @file init_hdb.q
* @overview load HDB and initialize HTTP handler.
\

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                            Load Libraries                            //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

// Load log module
\l log.q

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                            Initial Setting                           //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

// Open port
\p 80

// Load HDB
\l hdb

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                            Global Variable                           //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

.exec.STATUS_:`success`failure;
.exec.SUCCESS_:`.exec.STATUS_$`success;
.exec.FAILURE_:`.exec.STATUS_$`failure;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                              Handler                                 //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

/
* @brief HTTP POST handler. Remove header and evaluate the query.
* @param HTTP POST request.
\
.z.pp:{[request]
  // Show request
  .log.out[request 0; .log.INFO_];
  // Evauate request
  res:@[value; request; {[error] (.exec.FAILURE_; error)}];
  res:$[.exec.FAILURE_ ~ first res;
    // In case of failure return with error message
    .h.hn["500"; `json; .j.j enlist[`error]!enlist last res];
    .h.hy[`json; .j.j res]
  ];
  // Log result up to 700 bytes
  .log.out[res; .log.INFO_];
  res
 };

/
* @brief handler for SIGTERM. Log exit.
\
.z.exit:{[]
  .log.out["SIGTERM. exit."; .log.INFO_];
 };