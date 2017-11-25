% receives detected ramps from raffis algorithm and the actual time series
% of the corresponding other dataset

% returns t_start, t_end, ramp_s, ramp_e, ts_s, ts_e

function [ramps] = compare_ramps(detected_ramps,time_series,scale_factor)
    %
    time_series_ramp_start = time_series(detected_ramps(:,1));
    time_series_ramp_end = time_series(detected_ramps(:,2));
    ramps = [detected_ramps, time_series_ramp_start,time_series_ramp_end];
    ramps(:,3:4) = ramps(:,3:4)*scale_factor; 
end