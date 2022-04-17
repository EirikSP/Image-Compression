
clear all;
pkg load image;
pkg load signal;


I = imread('Example2.jpg');

beforeavg = 0;
afteravg = 0;

FI = rgb2ycbcr(I);

[ROW, COL] = size(I(:,:,1));

row8 = ROW/8;

col8 = COL/8;

Q = [16 11 10 16 24 40 51 61 ;
     12 12 14 19 26 28 60 55 ;
     14 13 16 24 40 57 69 56 ;
     14 17 22 29 51 87 80 62 ;
     18 22 37 56 68 109 103 77 ;
     24 35 55 64 81 104 113 92 ;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];
     
Q = Q*input('How much do you want to save?');

FI = double(FI) - 128;


for k = 1:3
  
  for r = 0:(row8-1)
    for c = 0:(col8-1)
      FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8,k) = round(dct2(FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k)));
      beforeavg = beforeavg + nnz(FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k));
      FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k) = Q.*round(FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k)./Q);
      afteravg = afteravg + nnz(FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k));
      FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k) = idct2(FI((r*8)+1:(r+1)*8,(c*8)+1:(c+1)*8, k));
    endfor
  endfor
endfor

FI = uint8(FI + 128);


FinalImage = ycbcr2rgb(FI);

beforetotal = beforeavg
aftertotal = afteravg

Times = round(100*(1 -(aftertotal/beforetotal)))


subplot(1,2,1)
imshow(I)
title('Original')
subplot(1,2,2)
imshow(FinalImage);
title(['Saved', num2str(Times), '%'])



beforeavg = beforeavg/(row8*col8*3)
afteravg = afteravg/(row8*col8*3)
