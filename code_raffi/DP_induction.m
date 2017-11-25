function [J, K, B] = DP_induction( x, p, cost_fxn, params )

% value function and operation mat.
J = zeros(length(x), length(x));
K = zeros(length(x), length(x));

% B = zeros(length(x), length(x));

% segments of length (n)
for n = 2:length(x)
    
    % for all start idx (i)
    for i = 1:(length(x) - n + 1)
        
        % end idx.
        j = i + n - 1;
        
        % if i == 4 && j == 7
        %    disp('stop')
        % end
        
        % disp([' i: ', num2str(i),' j: ', num2str(j)])
        
        % temp array to hold all k iterations.
        temp = zeros(1, length(x));
        for k = (i+1):j
            temp(k) = [cost_fxn(x, p, i, k, params) + J(k, j)];
        end
        
        % disp(temp')
        
        [max_val, max_idx] = max(temp);
        J(i, j) = max_val;
        K(i, j) = max_idx;
    end
end

% i    = 1; 
% jvec = 2:27;
% 
% for jidx = 1:length(jvec)
%     j=jvec(jidx);
%     [cost_fxn(x, p, i, K(i, j), params) + J(K(i, j), j), J(i, j)]
% end

% stop condition.
K(length(x), end) = length(x);

