function [fi, psnr_huang,runtime] = RDH_Huang(name_cover,secret,is_optimized)
t1 = clock;
%% Preprocessing
jpg_obj = jpeg_read(name_cover);
jpg_obj.optimize_coding = is_optimized;
dct = jpg_obj.coef_arrays{1,1};
%% Read JPEG Image and Parse Information.
[row, col] = size(dct);
blk_dct = mat2cell(dct,ones(row/8,1)*8,ones(col/8,1)*8);  % divide the quantized DCT matrix into 8*8 DCT blocks.
N = row * col / (8 * 8);
num_zeroAC = cellfun(@(x) sum(sum(x(2:64)==0)), blk_dct); % the number of zero-AC coefficients in each block.
s_zeroac(:,1) = 1:1:N;
s_zeroac(:,2) = reshape(num_zeroAC,[N 1]);
s_zeroac = sortrows(s_zeroac,-2); % the descending sorted DCT blocks.
s_zeroac = s_zeroac(:,1);
%% Embed
stego_jpg_obj = embed_Huang(secret, blk_dct, jpg_obj, s_zeroac);
%% Generate the marked JPEG bitstream
name_stego = strcat('stego.jpg');
jpeg_write(stego_jpg_obj, name_stego);
%% Perfomance analysis
file_stego = imfinfo(name_stego);
file_cover = imfinfo(name_cover);
fs_stego = file_stego.FileSize * 8;
fs_cover = file_cover.FileSize * 8;
fi = fs_stego - fs_cover;
stego = imread(name_stego);
cover = imread(name_cover);
psnr_huang = compute_psnr(stego, cover);
t2 = clock;
runtime = etime(t2,t1);
end