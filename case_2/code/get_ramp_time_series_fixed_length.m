% Returns a linear ramp time series + time series n time steps beyond the ramp
% ts_ext_length: the length beyond the end of a ramp
function [ramp_extended] = get_ramp_time_series_fixed_length(time_series, ramp_event,ts_ext_length)
    t_start = ramp_event(1);
    t_end = ramp_event(2);
    dt = t_end-t_start;
    x = 1:1:dt;
    ramp_ts = (time_series(t_end)-time_series(t_start))/dt.*(x)+time_series(t_start)
%     ramp_ts = linspace(time_series(t_start),time_series(t_end),dt); %RR from time series detected ramping durations
    if (t_end+ts_ext_length)>length(time_series)
        % if extra ramp ts exceeds the length of ts, just append the longest
        % ramp possible. Didn't loop to the beginning due to large gap
        % between ts values.
        ramp_extra = time_series(t_end+1:1:length(time_series))';
    else
        ramp_extra = time_series(t_end+1:1:t_end+ts_ext_length)';
    end
    ramp_extended = [ramp_ts,ramp_extra]';
end