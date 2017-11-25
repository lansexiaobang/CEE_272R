function RR_vec = calculate_RR(ramps)
    RR_vec = (ramps(:,4) - ramps(:,3)) ./ (ramps(:,2) - ramps(:,1));
end