% Output results are normalized
% Successes:(n x 2):
%   n is the number of ramps that have been successfully reduced
%   1st Col:battery charge/discharge rate, 
%   2nd Col:battery size

function [successes, success_rate] = get_battery_reduction_results(battery_power)
    % Pull out values that are not NaN
    successes = battery_power(~isnan(battery_power(:,1)),:);
    % Check percentage of ramp events that were successful
    success_rate = length(successes)/length(battery_power);
end