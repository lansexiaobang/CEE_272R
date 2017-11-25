function results = reduce_ramps_variable_size(ramps, Pgen, slope_iter, ts_ext_length, E_to_P_ratio)

    % calculate the ts ramping rate from detected ramp start and end idx
    RR = calculate_RR_ts(ramps, Pgen);
    
    csvwrite('../results/ramp_rates_test.csv', RR)
    % Initialize results vector
    results = nan(length(ramps),ceil(max(RR)/slope_iter));
    
    % define the number of slope reductions to perform
    slope_reduction_idx = size(results,2);
    
    % Iterate over each ramp event
    for i=1:length(RR)
%     for i=1:5 % test
        % Pull desired slice from the actual wind generation time series
        % Note: pulling ramp duration + ts_ext_length
        ramp_extended = get_ramp_time_series_fixed_length(Pgen,ramps(i,:),ts_ext_length);
    
% %         TEST: plot check
%         figure
%         hold on
%         plot(ramp_extended,'LineWidth',2)

        % Create new time series Ffor Battery
        battery_duration = 1:1:length(ramp_extended);
        
        % Iterate over slope reduction values
        for j=1:slope_reduction_idx
%         for j=1:10 % test
            % find current slope for the battery
            curr_slope = RR(i) - slope_iter*(j-1);        
            
            if curr_slope >= 0 % P_battery slope has to be flat or upward
                P_battery = (ramp_extended(1)+ curr_slope.*(battery_duration-1))';
                
                % Subtract new generation curve from the actual generation curve
                diff = ramp_extended - P_battery;
                
                
                
                % Find the intersection point 
                intersection_point = find(diff<0,1);
%                 plot(intersection_point,P_battery(intersection_point),'o')
                if (~isempty(intersection_point)) 
                    
                    % Set all values after the zero point to 0
                    diff(intersection_point:length(diff)) = 0;
                    
                    % Calculate maximum power output needed from the battery
                    P_max = max(diff);

                    % Calculate corresponding battery capacity under specified
                    % RR reduction
                    area = max([P_max*E_to_P_ratio, sum(diff)]); 
                    % area between the two curves
                   
                    results(i,j) = area;
                end
                
%                 Plotting
                
%                 plot(P_battery,'--') 
                
%                 plot(diff)
            end
%             xlabel('Time (hr)', 'FontSize',15)
%             ylabel('Normalized Power', 'FontSize',15)
%             legend('Extended Ramp Event','Ramp Reduction with Various Storage Sizes')
%             ylim([0,1])
        end        
    end
end