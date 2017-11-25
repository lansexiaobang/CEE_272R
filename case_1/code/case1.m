clear all
close all
clc
%% Load in the wind generation data
addpath(genpath('~/CEE272R')) % set main path
% addpath(genpath('~/cvx_temp')) % set cvx path % Oskar
load('HourlyWindGenTX.mat') % Raw hourly wind generation and forecast data
%old % load('WindGenRampResults.mat') % Ramp detection algorithm results
load('ramps_real_new.mat') % new extracted real ramps

%% algorithm hyperparameters
% max(ActualGeneration) % 8.5304e+03
% max(HouraheadForecast) % 9.4779e+03
% choose normalization factor to 10,000 MW to be consistant with max of
% actual and forecast generation
pre_scale_factor = 10000;
% hyperparameter for L1TF - determines how many points are used to fit
% curve -> lower lambda, more points (regularization term)
lambda = 0.1;

% scale inputs instead of handling scaling later
real = ActualGeneration / pre_scale_factor;
pred = HouraheadForecast / pre_scale_factor;
scale_factor = 1;



%% run algorithm 
% only do if necessary, takes long
%[ramps_real_up, ramps_real_down] = detect_ramps(ActualGeneration, scale_factor, lambda);
%% run algorithm
%[ramps_pred_up, ramps_pred_down] = detect_ramps(HouraheadForecast, scale_factor, lambda);

%% e.g. plot the extracted ramps
figure(1); hold on;
plot(real)
plot_ramps_simple(ramps_real_up , ramps_real_down)
legend ('Detected up (real)','Detected down (real)')

%% extract corresponding ?ramps? from other time series
r2p_up = compare_ramps(ramps_real_up,pred,scale_factor);
r2p_down = compare_ramps(ramps_real_down,pred,scale_factor);
%%
% p2r_up = compare_ramps(ramps_pred_up,real,scale_factor);
% p2r_down = compare_ramps(ramps_pred_down,real,scale_factor);

%% plot extracted ramps and corresponding time series ramps
figure; hold on;
% plot(real)
plot_ramps(r2p_up, r2p_down)
legend ('Detected up (real)','Detected down (real)','ts up','ts down')
%%
% figure(3); hold on;
% plot_ramps(p2r_up, p2r_down)
% legend ('Detected up (pred)','Detected down (pred)','ts up','ts down')

%%  calculate the difference between detected ramps and the corresponding forecast time series (detected - time series)
[r2p_diff_up, r2p_diff_down] = compare_diffs(r2p_up, r2p_down);
%%
% [p2r_diff_up, p2r_diff_down] = compare_diffs(p2r_up, p2r_down);

%% plot differences
figure; hold on;
plot_diffs(r2p_diff_up, r2p_diff_down, '(Real to Pred)')
%%
figure
plot_diffs_RR(r2p_diff_up, r2p_diff_down, '(Real to Pred)')
%%
% figure(5); hold on;
% plot_diffs(p2r_diff_up, p2r_diff_down, '(Pred to Real)')
% figure
% plot_diffs_RR(p2r_diff_up, p2r_diff_down, '(Pred to Real)')


%% Calculate RR
rr = @(x) (x(:,4) - x(:,3)) ./ (x(:,2) - x(:,1));
rr2 = @(x) (x(:,6) - x(:,5)) ./ (x(:,2) - x(:,1));
r2p_RR_up = [rr(r2p_up), rr2(r2p_up)];
r2p_RR_down = - [rr(r2p_down), rr2(r2p_down)];

%% plot RR
figure
plot_RR(r2p_RR_up, r2p_RR_down, 'Real','Pred')

%% calculate swing
swing_real_up = r2p_up(:,4)-r2p_up(:,3);
swing_pred_up = r2p_up(:,6)-r2p_up(:,5);

swing_real_down = r2p_down(:,3)-r2p_down(:,4);
swing_pred_down = r2p_down(:,5)-r2p_down(:,6);

swing_real_all = [swing_real_up;swing_real_down];
swing_pred_all = [swing_pred_up;swing_pred_down];

%% Swing Plots
scenarios = ['Real Ramps                 ';
             'Extrapolated Forecast Ramps'];
% scenarios_dif = 'Difference (Real - Pred)   ';
swing(:,1) = swing_real_all;
swing(:,2) = swing_pred_all;
swing_dif = swing_real_all - swing_pred_all;
%%
figure
boxplot(swing, scenarios);
ylabel('MW')
title('Swing Comparison')
%%
figure
% boxplot(swing_dif, scenarios_dif);
boxplot(swing_dif);
ylabel('MW')
title('Swing Magnitude Difference (Real - Pred)')

%% Save data

csvwrite('~/CEE272R/case_1/results/real.csv', real)
csvwrite('~/CEE272R/case_1/results/pred.csv', pred)
csvwrite('~/CEE272R/case_1/results/r2p_up.csv', r2p_up)
csvwrite('~/CEE272R/case_1/results/r2p_down.csv', r2p_down)
csvwrite('~/CEE272R/case_1/results/r2p_diff_up.csv', r2p_diff_up)
csvwrite('~/CEE272R/case_1/results/r2p_diff_down.csv', r2p_diff_down)
csvwrite('~/CEE272R/case_1/results/r2p_RR_up.csv', r2p_RR_up)
csvwrite('~/CEE272R/case_1/results/r2p_RR_down.csv', r2p_RR_down)


