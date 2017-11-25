function result = plot_ramps(ramps_up, ramps_down)
X_up = [ramps_up(:,1) ramps_up(:,2)]';
X_down = [ramps_down(:,1) ramps_down(:,2)]';

Y_up_detected = [ramps_up(:,3) ramps_up(:,4)]';
Y_down_detected = [ramps_down(:,3) ramps_down(:,4)]';
Y_up_time_series = [ramps_up(:,5) ramps_up(:,6)]';
Y_down_time_series = [ramps_down(:,5) ramps_down(:,6)]';

plot(X_up, Y_up_detected, 'bs-')
plot(X_down, Y_down_detected, 'bs-')
plot(X_up, Y_up_time_series, 'gs-')
plot(X_down, Y_down_time_series, 'gs-')
end