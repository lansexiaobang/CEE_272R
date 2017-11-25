function [ramps] = ramp_extract(kvec, x, p, cost_fxn, params)

% use operation matrix to extract ramps.
i   = 1;
idx = [];

while (1)    
    k   = kvec(i);
    idx = [idx; i, k];
    % disp([i, k])
    if (k == length(kvec)) | (k == 1)
        break;
    end
    i = k;
end

ramps = [];
for n = 1:size(idx, 1)
      i  = idx(n, 1);
    k_ij = idx(n, 2); 
    if cost_fxn(x, p, i, k_ij, params) > 0
        ramps = [ramps; i, k_ij];
    end
end




