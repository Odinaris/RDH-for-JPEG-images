function cap = cal_capacity(ZRV, R)
%CALCAP calculate the estimated capacity in the first R frequency in a DCT block.
% R is the first R frequencies in a DCT block.
if nargin < 2
    R = 63;
end
NACP = get_NACP(ZRV, R);
cap = 0;
for i = 1:numel(NACP(:,1))
    if abs(NACP(i,1))==1 && abs(NACP(i,2))==1
        cap = cap + 1.5;
    elseif abs(NACP(i,1))==1 || abs(NACP(i,2))==1
        cap = cap + 1;
    elseif abs(NACP(i,1))==2 && abs(NACP(i,2))==2
        cap = cap + 1;
    end
end
end

