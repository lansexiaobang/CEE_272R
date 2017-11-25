%  calculate the difference between detected ramps and the corresponding forecast time series (detected - time series)

function [diff_up, diff_down] = compare_diffs(ramps_up, ramps_down)
diff_up = ramps_up(:,3:4)- ramps_up(:,5:6);
diff_down = ramps_down(:,3:4)-ramps_down(:,5:6);

% combine
diff_up = [ramps_up(:, 1:2), diff_up];
diff_down = [ramps_down(:, 1:2), diff_down];

% delta heights
diff_up(:, 5) = diff_up(:, 4) - diff_up(:, 3);
diff_down(:, 5) = diff_down(:, 3) - diff_down(:, 4);

% Ramp Rate differences (in scale_factor/time)
diff_up(:, 6) = diff_up(:, 5) ./ (diff_up(:,2) - diff_up(:,1));
% down bias: positive means the real ramp is more extreme
diff_down(:, 6) = diff_down(:, 5) ./ (diff_down(:,2) - diff_down(:,1));
end