 function [S_stego] = jpeg_emdding(Data,S,x)
 %�������ܣ���������ϢData����xѡ�õĿ���Ƕ�뵽����S��
 %�������룺������ϢData������S��ԭʼDCT�飩��ÿ���Ƿ�Ƕ��ı��x
 %�������������������Ϣ��DCT��S_stego
 
 payload = length(Data);
 [M,N] = size(S);
 [m,n] = size(S{1,1});
%ѡ�����Щ����Ƕ��󣬿�ʼǶ���㷨
numData = 1;
for i = 1:M
    if numData > payload
        break;
    end
    for j = 1:N
        if numData > payload
            break;
        end
        if x(i,j) == 1
        for ii = 1:m
            if numData > payload
                break;
            end
            for jj = 1:n
                if numData > payload
                    break;
                end
                %% ֱ��ͼƽ��Ƕ��
                 if S{i,j}(ii,jj) > 1
                     S{i,j}(ii,jj) = S{i,j}(ii,jj) + 1;
                 elseif S{i,j}(ii,jj) < -1
                     S{i,j}(ii,jj) = S{i,j}(ii,jj) - 1;
                 elseif S{i,j}(ii,jj) == 1
                      S{i,j}(ii,jj) = S{i,j}(ii,jj)+Data(numData); %Ƕ������
                      numData = numData + 1;
                 elseif S{i,j}(ii,jj) == -1 
                      S{i,j}(ii,jj) = S{i,j}(ii,jj)-Data(numData);
                      numData = numData + 1;
                 end               
            end
        end
        end
    end
end
S_stego = S;

end