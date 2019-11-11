function [index,stego_jpg_obj,data] = extract(stego_jpg_obj, payload)
stego_dct = stego_jpg_obj.coef_arrays{1,1};
[m,n] = size(stego_dct);
index = 0;  % the index of extracted data.
data = zeros(1,payload);
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) % Remove the DC coefficient
            if stego_dct(i,j) ~= 0
                if index == payload
                    break;
                end
                v = stego_dct(i,j);
                if abs(v) > 2
                    stego_dct(i,j) = v - sign(v);
                elseif abs(v) == 2
                    index = index + 1;
                    stego_dct(i,j) = v - sign(v);
                    data(index) = 1;
                elseif abs(v) == 1
                    index = index + 1;
                    data(index) = 0;
                end
            end
        end
    end
end
stego_jpg_obj.coef_arrays{1,1} = stego_dct; 

end