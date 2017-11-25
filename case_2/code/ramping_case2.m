%% clean up 
clearvars
clc
close all

%% Load and normalize input Data
addpath(genpath('~/CEE272R')) % set main path - Siyi
addpath(genpath('~/Documents/School/Spring/CEE 272R/Project/CEE272R')) % Set main path - Sam
load('ramps_real_new.mat'); % Current ramp detection results
load('HourlyWindGenTX.mat'); % Wind generation time series

% Clean Input Data and Calculate Input Datasets

% Normalize actual wind generation by the correct scale factor 
scale_factor = 10000;
real = ActualGeneration/scale_factor;

%%

%% Set Input Parameters

% define the number of time steps to extend to beyond a ramp
% Note: we are currently using 48 hours
TS_EXTENSION_LENGTH = 48;

% the amount of slope reduced each time
SLOPE_INCREDMENT = 0.0001;
% SLOPE_INCREDMENT = 0.005;

E_TO_P = 20;


%% Run Analysis
battery_power_up = reduce_ramps_variable_size(ramps_real_up,...
                    real,SLOPE_INCREDMENT,TS_EXTENSION_LENGTH, E_TO_P);

% run same algo on down ramps after reversing the down ramps values
ramps_real_down(:,3) = 1 - ramps_real_down(:,3);
ramps_real_down(:,4) = 1 - ramps_real_down(:,4);
battery_power_down = reduce_ramps_variable_size(ramps_real_down,...
                    1-real,SLOPE_INCREDMENT,TS_EXTENSION_LENGTH, E_TO_P);

                
%% 
test_RR = calculate_RR_ts(ramps_real_up, real);
csvwrite('../results/Ramp_Rates_Up.csv', test_RR)

test_RR = calculate_RR_ts(ramps_real_down, 1-real);
csvwrite('../results/Ramp_Rates_Down.csv', test_RR)

%%
csvwrite('../results/battery_power_down.csv',battery_power_down)       
csvwrite('../results/battery_power_up.csv',battery_power_up)  
%% Data Analysis  
% figure
% hist(battery_power_up(~isnan(battery_power_up)))
% figure
% plot(nanmean(battery_power_up),'o')
% specify a range of reasonable battery size

% check if this battery size could successfully reduce each ramp

% calculate the percentage of ramps that could be reduced with each battery
% size

%% old model
% % Define battery size (MWh)
% BATTERY_SIZE = 5000; % MW 20,000MW wind installed
% % Define threshold between calculated battery size and actual size
% THRESHOLD = 0.05;
% % Define the number of slope values to iterate
% SLOPE_INTERATION = 100;
% % Define the length of time series to extend to
% TS_EXTENSION_FACTOR = 3;
% battery_power_up_old = ramp_reduction_with_battery(ramps_real_up,ActualGeneration/scale_factor,BATTERY_SIZE/scale_factor, THRESHOLD, SLOPE_INTERATION, TS_EXTENSION_FACTOR)
% [success_ramps_real_up, success_rate_ramps_real_up] = get_battery_reduction_results(battery_power_up_norm);
