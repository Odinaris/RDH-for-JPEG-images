function [numData2,stegoJpegInfo,extData] = extract_Huang(stegoJpegInfo,payload)
dct_coef = stegoJpegInfo.coef_arrays{1,1}; %获取载密图像的dct系数
[m,n] = size(dct_coef);
numData2 = 0;
extData = zeros();
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数 
            if dct_coef(i,j) ~= 0  %排除为 0 的ac系数
                %% 控制提取容量
                if numData2 == payload
                    break;
                end
                %% 
                if dct_coef(i,j) > 2  % 大于 2 左移 恢复原位
                    dct_coef(i,j) = dct_coef(i,j) -1;
                elseif dct_coef(i,j) < -2  %小于-2 右移 恢复原位
                    dct_coef(i,j) = dct_coef(i,j) +1;
                elseif dct_coef(i,j) == 2   % 等于 2 左移 恢复原位 并提取数据 1
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = dct_coef(i,j) -1;
                    extData(numData2) = 1;
                elseif dct_coef(i,j) == -2  % 等于 -2 右移 恢复原位 并提取数据 1
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = dct_coef(i,j) +1;
                    extData(numData2) = 1;
                elseif dct_coef(i,j) == 1 || dct_coef(i,j) == -1  % 等于 -2  不需一定 并提取数据 0
                    numData2 = numData2 + 1;
                    extData(numData2) = 0;
                end
            end
        end
    end
end
stegoJpegInfo.coef_arrays{1,1} = dct_coef; 

end