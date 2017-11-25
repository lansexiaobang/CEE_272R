function plot_diffs_RR(diff_up, diff_down, direction_str)

dir_label = [  'UP  '; 'DOWN'];

% input = [diff_up(:,6), diff_down(:,6)].* 10000;
p_up = subplot(1,2,1);
boxplot(diff_up(:,6) .* 10000, 'Labels','Up Ramps');
ylabel('Ramp Rate Error (MW/hr)');
% title('Predicted Ramp Rate Bias');


p_down = subplot(1,2,2);
boxplot(diff_down(:,6) .* 10000, 'Labels','Down Ramps');
ylabel('Ramp Rate Error (MW/hr)');
% title('Predicted Ramp Rate Bias');

linkaxes([p_up, p_down],'y')
end