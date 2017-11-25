function plot_diffs(diff_up, diff_down, direction_str)

diffs_label = [  'Start ';
                 'End   ';
                 'Height'];

p_up = subplot(1,2,1);
boxplot(diff_up(:, 3:5), diffs_label);
ylabel('MW');
title(strcat('Difference UP (', direction_str, ')'));

p_down = subplot(1,2,2);
boxplot(diff_down(:, 3:5), diffs_label);
ylabel('MW');
title(strcat('Difference DOWN (', direction_str, ')'));

% subplot(1,3,3);
% plot_diffs_RR(diff_up, diff_down, direction_str)

linkaxes([p_up, p_down],'y')

end