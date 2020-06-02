function [fi,psnr_value,runtime] = RDH_He(name_cover,secret,alpha,is_optimized)
t1 = clock;
%% Extract information
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
dct = jpg_obj.coef_arrays{1, 1};
qt = jpg_obj.quant_tables{1, 1};
qt = zigzag(qt);
[row, col] = size(dct);
n_blk = row * col / (8 * 8);	% the total number of 8*8 DCT blocks.

% Divide the quantized DCT matrix into 8*8 DCT blocks.
blk_dct = mat2cell(dct,ones(row/8,1)*8,ones(col/8,1)*8);

% Scan the AC coefficients in Zigzag order.
% Input: 8*8 double matrix.
% Output: 1*64 double vector.
blk_zigzag = cellfun(@(x) zigzag(x), blk_dct,'UniformOutput',false);

% Convert the AC coefficients into the form of ZRVs.
blk_zrv = cellfun(@(x) get_zrv(x), blk_zigzag,'UniformOutput',false);

% Get the Negative Influence Model.
% alpha is the weighted factor:
% - 0 means the PSNR value is optimized,
% - 1 means the File-size increment is optimized.
[L,s_Neg] = get_neg_model(n_blk, blk_zigzag, blk_zrv, alpha, qt);

% the number of zero-AC coefficients in each block.
n_zero_ac = cellfun(@(x) sum(sum(x(2:64)==0)), blk_dct);

% Sort the block in descending order according to the number of the zero AC coefficients.
s_zeroac(:,1) = 1:1:n_blk;
s_zeroac(:,2) = reshape(n_zero_ac,[n_blk 1]);
s_zeroac = sortrows(s_zeroac,-2); % the descending sorted DCT blocks.
s_zeroac = s_zeroac(:,1);
%% Data embedding
len_secret = numel(secret);
cur_capcity = 0;
fst_freq = 0; % the least frequency that can embed all the secret bits.
while cur_capcity < len_secret
    fst_freq = fst_freq + 1;
    cur_capcity = cur_capcity + L(s_Neg(fst_freq));
end
PSNR = zeros(63 - fst_freq + 1,1);
FI = zeros(63 - fst_freq + 1,1);
for k = fst_freq:63
    freq = s_Neg(1:k);
    % 计算前k个频率中，每个块的载荷
    blk_payload = cellfun(@(x) cal_blk_payload(x,s_Neg(1:k)), ...
        blk_zrv,'UniformOutput',false);
    tmp = [blk_payload{:}];
    tmp = tmp(s_zeroac);
    capacity = sum(tmp);
    lst_blk = n_blk;
    % lst_blk - the number of needed blocks.
    while capacity - len_secret >= 0
        capacity = capacity - tmp(lst_blk);
        lst_blk = lst_blk - 1;
    end
    if capacity - len_secret < 0
        lst_blk = lst_blk + 1;
    end
    [~,stego_DCT] = embed_He(freq,secret,blk_zigzag,lst_blk,s_zeroac,blk_zrv);
    jpg_obj_stego = jpg_obj;
    jpg_obj_stego.coef_arrays{1,1} = stego_DCT;
    name_stego = 'stego.jpg';
    jpeg_write(jpg_obj_stego,name_stego);
    cover = imread(name_cover);
    stego = imread(name_stego);
    cover_file = imfinfo(name_cover);
    stego_file = imfinfo(name_stego);
    FI(k - fst_freq + 1) = (stego_file.FileSize - cover_file.FileSize) * 8;
    PSNR(k - fst_freq + 1) = compute_psnr(cover,stego);
end
%% Record the outputs.
if alpha ~= 1
    [psnr_value,ind] = max(PSNR);
    fi = FI(ind);
else
    [fi,ind] = min(FI);
    psnr_value = PSNR(ind);
end
t2 = clock;
runtime = etime(t2,t1);
end

