function [numData2,stegoJpegInfo,extData] = extract_Huang(stegoJpegInfo,payload)
dct_coef = stegoJpegInfo.coef_arrays{1,1}; %��ȡ����ͼ���dctϵ��
[m,n] = size(dct_coef);
numData2 = 0;
extData = zeros();
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %ȥ��dcϵ�� 
            if dct_coef(i,j) ~= 0  %�ų�Ϊ 0 ��acϵ��
                %% ������ȡ����
                if numData2 == payload
                    break;
                end
                %% 
                if dct_coef(i,j) > 2  % ���� 2 ���� �ָ�ԭλ
                    dct_coef(i,j) = dct_coef(i,j) -1;
                elseif dct_coef(i,j) < -2  %С��-2 ���� �ָ�ԭλ
                    dct_coef(i,j) = dct_coef(i,j) +1;
                elseif dct_coef(i,j) == 2   % ���� 2 ���� �ָ�ԭλ ����ȡ���� 1
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = dct_coef(i,j) -1;
                    extData(numData2) = 1;
                elseif dct_coef(i,j) == -2  % ���� -2 ���� �ָ�ԭλ ����ȡ���� 1
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = dct_coef(i,j) +1;
                    extData(numData2) = 1;
                elseif dct_coef(i,j) == 1 || dct_coef(i,j) == -1  % ���� -2  ����һ�� ����ȡ���� 0
                    numData2 = numData2 + 1;
                    extData(numData2) = 0;
                end
            end
        end
    end
end
stegoJpegInfo.coef_arrays{1,1} = dct_coef; 

end