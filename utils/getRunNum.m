function [num_run] = getRunNum(ZRVs)
%GETRUNNUM Record the numbers of different categories of RUN in each block.
num_run = zeros(16,1);
for i = 1:16
    num_run(i) = sum(ZRVs(:,2) == (i-1));
end
end

