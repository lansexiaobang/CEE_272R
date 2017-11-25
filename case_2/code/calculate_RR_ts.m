function RR_vec = calculate_RR_ts(ramps, times_series)
    RR_vec = (times_series(ramps(:,2)) - times_series(ramps(:,1))) ./ (ramps(:,2) - ramps(:,1));
end