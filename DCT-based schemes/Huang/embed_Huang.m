function [stego_jpg_obj] = embed_Huang(data, dct, jpg_obj, blk_order)
stego_jpg_obj = jpg_obj;
[M,N] = size(dct);
payload = length(data);
flag = 0;
for i = 1:M*N
    for j = 1:63
        v = dct{blk_order(i)}(j+1);
        if abs(v) == 1
            flag = flag + 1;
            dct{blk_order(i)}(j+1) = v + sign(v) * data(flag);        
            if flag == payload
                stego_dct = cell2mat(dct);
                stego_jpg_obj.coef_arrays{1,1} = stego_dct;
                return;
            end
        elseif abs(v) > 1
            dct{blk_order(i)}(j+1) = v + sign(v);
        end
    end
end
end

