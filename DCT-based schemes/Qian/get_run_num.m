function [n_Run] = get_run_num(ZRVs)
%GETRUNNUM ��¼ÿ�����в�ͬRun��ZRV������ ZRVs:n*2
n_Run = zeros(16,1);
for i = 1:16
    n_Run(i) = sum(ZRVs(:,2)==(i-1));
end
end

