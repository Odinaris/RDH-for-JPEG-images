function NACP = get_NACP(ZRV, R)
% R is the first R frequencies in a DCT block.
num_NACP = floor(numel(find(ZRV(:,1) <= R))/2);
NACP = reshape(ZRV(1:2*num_NACP,end), 2, [])';
end

