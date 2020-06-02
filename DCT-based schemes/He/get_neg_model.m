function [L,s_Neg] = get_neg_model(N,blk_zigzag,blk_ZRV,alpha,jpeg_qt)
%GETNEGMODEL generate the negative influence model.
E = zeros(63,1);    % E - the mean square error for each frequency.
S = zeros(63,1);    % S - the file size change for each frequency.
L = zeros(63,1);    % L - the number of ¡À1-AC coefficients in each frequency.
for i = 1:N
    for j = 2:64 
        if blk_zigzag{i}(j) == 1 || blk_zigzag{i}(j) == -1
            L(j-1) = L(j-1) + 1;
        end
    end
    zrv = blk_ZRV{i};
    for j = 1:length(zrv(:,1))
        w = 0;
        if abs(zrv(j,4)) == 1
            w = 0.5;
        elseif abs(zrv(j,4)) > 1
            w = 1;
        end
        if(bitand(abs(zrv(j,4))+1,abs(zrv(j,4)))==0)
            S(zrv(j,1)) = S(zrv(j,1)) + w * (hcit(mod(zrv(j,2),16) + 1, zrv(j,3)) + 1);
        end
        E(zrv(j,1)) = E(zrv(j,1)) + w * (jpeg_qt(zrv(j,1)+1)^2); % N is a constant, so I obmit it.
    end
end
ud = E./L;
uf = S./L;
Neg = (1 - alpha)*((ud - min(ud)) / (max(ud) - min(ud))) + ...
        alpha * ((uf - min(uf)) / (max(uf) - min(uf)));
s_Neg = zeros(63,2);
s_Neg(:,1) = 1:1:63;
s_Neg(:,2) = Neg;
s_Neg = sortrows(s_Neg,2);  % the ascending sorted frequencies. 
s_Neg = s_Neg(:,1);
end

