clear;clc;dbstop if error;tic;
addpath(genpath('..\..\utils\'));
addpath(genpath(pwd));
name_cover = '..\..\utils\Baboon_70.jpg';
len_secret = 10000;
secret = round(rand(1,len_secret)*1);
[fi,psnr,runtime] = RDH_Ji(name_cover,secret);