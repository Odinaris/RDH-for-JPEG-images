clear;clc;
dbstop if error
addpath('D:\Odinaris\RDH for JPEG\utils\lib\jpeg_toolbox');
img_name = 'Baboon_70.jpg';
stego_name = strcat('Stego-', img_name);
opt_name = strcat('Opt-', img_name);
%% Read and parse JPEG image.
jpeg_obj = jpeg_read(img_name);
jpeg_obj.optimize_coding = 1;   % use the optimized Huffman table or not.
jpeg_write(jpeg_obj, opt_name);
jpeg_dct = jpeg_obj.coef_arrays{1, 1};
[row, col] = size(jpeg_dct);
blk_dct = mat2cell(jpeg_dct,ones(row/8,1)*8,ones(col/8,1)*8);  % divide the quantized DCT matrix into 8*8 DCT blocks.
N = row * col / (8 * 8);
num_zeroAC = cellfun(@(x) sum(sum(x(2:64)==0)), blk_dct); % the number of zero-AC coefficients in each block.
s_zeroac(:,1) = 1:1:N;
s_zeroac(:,2) = reshape(num_zeroAC,[N 1]);
s_zeroac = sortrows(s_zeroac,-2); % the descending sorted DCT blocks.
s_zeroac = s_zeroac(:,1);
%% Embed data and generate the stego JPEG image.
len_message = 7000;
len_message = len_message + 24 + 5; % embed the auxiliary information to restore the cover image.
rng(0,'twister');
secret = round(rand(1,len_message)*1);  % generate binary bits randomly.
stego_jpeg_obj = embed(secret, blk_dct, jpeg_obj, s_zeroac);
jpeg_write(stego_jpeg_obj,stego_name);
%% Compute the PSNR value and file size increments.
cover = imread(img_name);
stego = imread(stego_name);
PSNR = psnr(cover,stego);
cover_file = imfinfo(opt_name);
stego_file = imfinfo(stego_name);
IncSize = (stego_file.FileSize - cover_file.FileSize) * 8;
disp(PSNR);
disp(IncSize);

