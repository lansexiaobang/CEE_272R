% x - sample instances.
% p - power level at sample moment.
% alpha - min |x(k) - x(i)|
% beta  - weighting for x_k - x_i
% delta - min |p(k) - x(i)|
% gamma - weighting for |p(k) - p(i)|
% zeta  - downramp detection percentage.

function [cost] = COST_1(x, p, i, k, params)

% disp(['i=',num2str(i),' j=', num2str(k)])
min_rmp_len      = params.min_rmp_len;        % x(k) - x(i) > a1
max_rmp_len      = params.max_rmp_len;        % x(k) - x(i) < a2
cost_int_len     = params.cost_int_len;       % b*( x(k) - x(i) )
cost_pwr_swng    = params.cost_pwr_swng;      % c*( p(k) - p(i) ).^2;

pwr_swing_thresh = params.pwr_swing_thresh;   % power swing threshold (change this)
dwn_rmp_thresh   = params.dwn_rmp_thresh;     % downramp detection percentage.

avg_t            = params.avg_t;              % avg_t p.c. of time slope > avg_slope
avg_slope        = params.avg_slope;                

start_t          = params.start_t;            % at least start_t 
start_slope      = params.start_slope;        % of time slope > start_slope       
end_t            = params.end_t;              % at least end_t 
end_slope        = params.end_slope ;         % of time slope > start_slope   

cost = 0;

% base case.
if i >= k
    return
end

%% condition 1 - detect out of band signal.
DWN_DET = 0;
for j = i:k
   p_max = max(p(i:j));
   if (p(j) - p_max + 1e-5)/(p(j)+1e-5) < - dwn_rmp_thresh
       DWN_DET = 1;
       break;
   end
end

%% check if f_t % of interval has slope beyond f_slope
dx        = diff( x(i:k) ); 
% disp(['i: ', num2str(i),' k: ', num2str(k)])
% dx
% p(i:k)
% diff( p(i:k) )

slope_vec = diff( p(i:k) )./dx;
cs        = cumsum(dx)/sum(dx);

AVG_SLOPE_FAIL = 0;
avg_slope_test = slope_vec > avg_slope;
if sum(dx(avg_slope_test))./sum(dx) < avg_t
   AVG_SLOPE_FAIL = 1;
end

%% check if initial h_t % if interval has slope beyond h_slope
START_SLOPE_FAIL = 0;
start_slope_test = slope_vec > start_slope;

idx_1 = max(find(cs<start_t));

if isempty(idx_1)
    idx_s = 1;
elseif start_t < cs(idx_1+1)
    idx_s = max(idx_1)+1;
end

if sum( start_slope_test(1:idx_s) ) < length(1:idx_s)
    START_SLOPE_FAIL = 1;
end


%% check if ending i_t % of interval has slope beyond 
END_SLOPE_FAIL = 0;
end_slope_test = slope_vec > end_slope;
idx_1          = min(find((1-end_t)<cs));

if (~isempty(idx_1)) & (idx_1>1) & ((1-end_t) > cs(idx_1-1))
    idx_e = idx_1 - 1;
else
    idx_e = 1;
end

if sum( end_slope_test(idx_e:end) ) < length(end_slope_test(idx_e:end))
    END_SLOPE_FAIL = 1;
end


%%
TEST_FAIL = DWN_DET || AVG_SLOPE_FAIL || START_SLOPE_FAIL || END_SLOPE_FAIL;

% disp(['DWN_DET=', num2str(DWN_DET)]);
% disp(['AVG_SLOPE_FAIL=', num2str(AVG_SLOPE_FAIL)]);
% disp(['START_SLOPE_FAIL=', num2str(START_SLOPE_FAIL)]);
% disp(['END_SLOPE_FAIL=', num2str(END_SLOPE_FAIL)]);

if ( TEST_FAIL )
    cost = 0;
else
    if ( (x(k) - x(i)) > min_rmp_len ) && ( (x(k) - x(i)) < max_rmp_len ) ...
            && ( p(k) - p(i) > pwr_swing_thresh ) 
        cost = cost_int_len*( x(k) - x(i) ).^2 + cost_pwr_swng*( p(k) - p(i) ).^2;
    else
        cost = 0;
    end
end
