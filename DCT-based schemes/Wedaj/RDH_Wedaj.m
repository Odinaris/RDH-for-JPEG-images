function [fi, psnr, runtime] = RDH_Wedaj(name_cover,secret,is_optimized)
t1 = clock;
%% Extract information
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
dct = jpg_obj.coef_arrays{1, 1};
stego_jpg_obj = jpg_obj;
payload = numel(secret);
qt = jpg_obj.quant_tables{1};
%% Embed
[row, col] = size(dct);

% Divide the quantized DCT matrix into 8*8 DCT blocks.
blk_dct = mat2cell(dct,ones(row/8,1)*8,ones(col/8,1)*8);
stego_blk_dct = blk_dct;

zeronum = get_zero_num(blk_dct);
num_ac = get_ac_num(blk_dct);
[R] = get_R(qt, num_ac);

rest = payload;
count=1;

while rest > 0
    positions(count)=R(count,1);
    rest=rest-num_ac(R(count,1),1);
    count=count+1;
end
positions=sort(positions,2);

pos=1;
count=1;
while pos<payload
    [stego_blk_dct,pos] = embed_Wedaj(stego_blk_dct,secret,pos,positions,zeronum(count,1),zeronum(count,2));
    count = count+1;
end

[side] = get_side(payload,positions);
[stego_blk_dct] = LSB_embed(stego_blk_dct,side);

stegodct = cell2mat(stego_blk_dct);%从hxBlockdct细胞矩阵获得hxdct矩阵
stego_jpg_obj.coef_arrays{1,1} = stegodct;%修改后的hxdct系数，写回JPEG信息

name_stego = 'stego.jpg';

jpeg_write(stego_jpg_obj, name_stego);%保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像
%% Perfomance analysis
stego = imread(name_stego);
cover = imread(name_cover);
cover_file = imfinfo(name_cover);
stego_file = imfinfo(name_stego);
fi = (stego_file.FileSize - cover_file.FileSize) * 8;
psnr = compute_psnr(stego, cover);
t2 = clock;
runtime = etime(t2,t1);
end

