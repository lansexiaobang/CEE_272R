function plot_RR(rr_up, rr_down, from, to)

label = [from; to];

p_up = subplot(1,2,1);
boxplot(rr_up, label);
ylabel('10GW/h');
title(strcat('RR UP (', from, ' to ', to, ')'));

p_down = subplot(1,2,2);
boxplot(rr_down, label);
ylabel('10GW/h');
title(strcat('RR DOWN (', from, ' to ', to, ')'));


linkaxes([p_up, p_down],'y')

end