function psnrvalue = psnr(cover, stego)
%PSNR Compute the PSNR value between the cover image and stego image.
cover = double(cover);
stego = double(stego);
E= cover - stego;
MSE = mean2(E.*E);
if MSE==0
    psnrvalue = -1;
else
    psnrvalue = 10*log10(255*255/MSE);
end