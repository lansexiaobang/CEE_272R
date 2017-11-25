function  plot_ramps_simple(ramps_up, ramps_down)
X_up = [ramps_up(:,1) ramps_up(:,2)]';
X_down = [ramps_down(:,1) ramps_down(:,2)]';

Y_up_detected = [ramps_up(:,3) ramps_up(:,4)]';
Y_down_detected = [ramps_down(:,3) ramps_down(:,4)]';

plot(X_up, Y_up_detected, 'bs-')
plot(X_down, Y_down_detected, 'bs-')
end