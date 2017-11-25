function [ramp_extended] = get_ramp_time_series(time_series, ramp_event,ts_ext_factor)
    t_start = ramp_event(1);
    t_end = ramp_event(2);
    dt = t_end-t_start;
    x = 1:1:dt;
    ramp_ts = (time_series(t_end)-time_series(t_start))/dt.*x + time_series(t_start);
    if (t_end+dt*(ts_ext_factor-1))>length(time_series)
        % if extra ramp ts exceeds the length of ts, just append the longest
        % ramp possible. Didn't loop to the beginning due to large gap
        % between ts values.
        ramp_extra = time_series(t_end+1:1:length(time_series))';
    else
        ramp_extra = time_series(t_end+1:1:t_end+dt*(ts_ext_factor-1))';
    end
    ramp_extended = [ramp_ts,ramp_extra]';
end