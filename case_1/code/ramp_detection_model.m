%% refactor Raffi's model into a function
function [detected_up_ramps, detected_down_ramps] = ramp_detection_model(input, normalization_factor, lambda)
    % wind_all = ActualGeneration;
    wind_all = input;

    % Reduce dataset size using L1-trend fitting.
    wind = (wind_all)/normalization_factor;

    % 1 - perform L1-trend filtering.
    [w_pw] = l1tf(wind, lambda);
    
    
    % 2 - use second derivative to extract line segments.
    d1_pw     = diff(w_pw);
    d2_pw     = diff(diff(w_pw));
    chng_idx  = find(abs(d2_pw) > 0.0001);

    % 3 - this is the reduced dataset.
    t_pw_dp   = chng_idx;
    w_pw_dp   = w_pw(chng_idx);

%     %%
    % Here we define the rule set we use (you can choose your own. just 
    % change COST_1 to whatever you want.
    % NOTE - this function has more parameters than our publication.

    % minimum ramp length: x(k) - x(i) > val
    params.min_rmp_len   = 0;        

    % maximum ramp length: x(k) - x(i) < val
    params.max_rmp_len   = 15;      

    % weight given for interval: w(i, k) = val*( x(k) - x(i) ).^2;
    params.cost_int_len  = 1;        

    % additional cost (NOT USED): val*( p(k) - p(i) ).^2;
    params.cost_pwr_swng = 0;        

    % pwr-swing threshold: p(k) - p(i) > val
    params.pwr_swing_thresh = 0.15;   

    % if val percent decline within interval. downramp declared.
    params.dwn_rmp_thresh   = 0.025;  

    % avg_t p.c. of time slope > avg_slope
    params.avg_t     = 0.0001;       

    % at least start_t 
    params.avg_slope = 0.001;                

    % of time slope > start_slope 
    params.start_t     = 0;          
    params.start_slope = 0;          

    % at least end_t 
    params.end_t       = 0;          

    % of time slope > start_slope   
    params.end_slope   = 0;          

    % original cost function from Raffi
    % assign cost function.
    cost_fxn  = @COST_1;
    
    % Since dynamic program is too big.  We use the sliding window ramp
    % detection method.

    % perform ramp-detect on W_size points. (this is many fewer actual points
    % since we reduced the dataset);
    W_size    = 800;

    % N_overlap: number of samples which overlap between windows:
    N_overlap = 300;

    % perform sliding_window_ramp_detect
    detected_up_ramps = sliding_window_ramp_detect...
        (W_size, N_overlap, chng_idx, wind, w_pw, params, cost_fxn);

    detected_down_ramps = sliding_window_ramp_detect...
        (W_size, N_overlap, chng_idx, 1-wind, 1-w_pw, params, cost_fxn);
    detected_down_ramps(:,3) = 1 - detected_down_ramps(:,3);
    detected_down_ramps(:,4) = 1 - detected_down_ramps(:,4);

end