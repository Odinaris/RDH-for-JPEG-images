function [n_Run] = get_run_num(ZRVs)
%GETRUNNUM 记录每个块中不同Run的ZRV数量， ZRVs:n*2
n_Run = zeros(16,1);
for i = 1:16
    n_Run(i) = sum(ZRVs(:,2)==(i-1));
end
end

