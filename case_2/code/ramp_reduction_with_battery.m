
% ramps: ramps extracted from ramp detection algo (n, 4)
% time_series: hourly time series, normalized
% battery_size: Specified battery size, normalized
% battery_threshold: threshold to determine the desired battery size is
% satisfied (0 - 1)
% slope_iteration_num: number of slopes to iterate
% ts_ext_factor: new ramp time series (ramp + time series), n means the
% resulting ts is nx length of the original ramp duration, (integer>=1)

function [results] = ramp_reduction_with_battery(ramps,time_series,battery_size, battery_threshold, slope_iteration_num,ts_ext_factor)
   
    % calculate the ts ramping rate from detected ramp start and end idx
    RR = calculate_RR_ts(ramps, time_series);
    
    % Initialize results vector
    results = nan(length(ramps),2); 
    
    % Iterate over all ramp events
    for i=1:1:3
        
        % Create vector of slopes to test
        slope = linspace(0, RR(i), slope_iteration_num);
        
        % Pull desired slice from the actual wind generation time series
            % Note: we are currently pulling 2*ramp duration
        ramp_extended = get_ramp_time_series(time_series,ramps(i,:),ts_ext_factor);
        
        % Plotting
        figure
        hold on
        plot(ramp_extended)

        % Iterate over slopes
        for j=1:1:length(slope)
            % Create new time series of Wind + Battery
            battery_duration = 1:1:length(ramp_extended);
            P_battery = (ramp_extended(1)+ slope(j).*(battery_duration-1))';

            % Subtract new generation curve from the actual generation curve
            diff = ramp_extended - P_battery;
            plot(P_battery)
    %         plolt(diff)
    %         plot(zeros(length(diff),1))
    
            % Find the intersection point 
            intersection_point = find(diff<0,1);

            % If the intersection point exists
            if (~isempty(intersection_point)) 
                % Set all values after the zero point to 0
                diff(intersection_point:length(diff)) = 0;

                % Calculate needed battery capacity
                b_size = sum(diff); % area between the two curves

    %             disp(b_size);

                delta_bsize = battery_size - b_size;
                
                if delta_bsize >= 0 && delta_bsize <= battery_threshold * battery_size
                    results(i,1)= slope(j);
                    results(i,2)= b_size;
    %                 plot(P_battery);
    %                 plot(diff);
    %                 legend('Ramp Extended', 'P Battery','Diff')
                    disp('found battery discharge/charge rate')
%                     break
                end
            end    
        end
    %     disp(P_battery(1))
    %     plot(P_battery)
    %     
    %     plot(zeros(length(diff),1))
    %     figure
    %     plot(ramp_extended)
    end
    
end