clear;clc;dbstop if error;tic;
addpath(genpath('..\..\utils\'));
addpath(genpath(pwd));
name_cover = '..\..\utils\Baboon_70.jpg';
%% Generate the JPEG image with the optimized Huffman table.
is_optimized = 0;
if is_optimized
    jpg_obj = jpeg_read(name_cover);
    jpg_obj.optimize_coding = 1;
    name_cover = strcat('opt_', name_cover);
    jpeg_write(jpg_obj,name_cover);
end
%%
len_secret = 10000;
secret = round(rand(1,len_secret)*1);
alpha = 0;
[fi,psnr_value,runtime] = RDH_He(name_cover,secret,alpha,is_optimized);