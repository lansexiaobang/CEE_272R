sliding-window-ramp-detect: Automated wind ramp detection method.

Version 0.0 , Apr 23 2012

--------------------------------------------------------------------------------

Please see the comments in the source code, for more information.

--------------------------------------------------------------------------------
Files of interest:

Main Sample Application:
    main.m         : loads dataset. uses sample cost function and extracts ramps.

Sliding Window Ramp Detection:
    DP_induction.m : dynamic program given in publication (Algorithm 1).
    ramp_extract.m : given variables calculated, extracts detected ramps.
    sliding_window_ramp_detect.m : performs action shown in Figure 2. 

L1-Trend-Fitting
    l1tf_lambdamax : utility file for finding maximum value of lambda.
    l1tf           : l1-trend fitting.  Code from http://www.stanford.edu/~boyd/l1_tf/ .

Sample Dataset:
    bpa_wind_normalized.mat : bpa sample dataset.
    

COPYRIGHT (c) 2012  Raffi Sevlian, Ram Rajagopal.

Permission to use, copy, modify, and distribute this software for
any purpose without fee is hereby granted, provided that this entire
notice is included in all copies of any software which is or includes
a copy or modification of this software and in all copies of the
supporting documentation for such software.
This software is being provided "as is", without any express or
implied warranty.  In particular, the authors do not make any
representation or warranty of any kind concerning the merchantability
of this software or its fitness for any particular purpose.

