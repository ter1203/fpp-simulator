%geometric rectification
% rectification the figure 
clc
clear
W = 912;H  = 1140;
cX = ones(H,W);cY = ones(H,W);
ImgPath = 'CaptureImg';
capimg = imread([ImgPath,'\image81.bmp']);
capimg =double(capimg);
cW = size(capimg,2);cH = size(capimg,1);
maskImgName = [ImgPath,'\0.bmp'];
firstImgName = [ImgPath,'\image01.bmp'];
I0 = imread(maskImgName);
I0 = double(I0)/255;
I01 = im2bw(I0,0.3);
Aidx = find(I01==1);
[Xnt,Ynt] = meshgrid(1:size(I01,2),1:size(I01,1));
xc(1,:) = Xnt(Aidx);
xc(2,:) = Ynt(Aidx);
Np = [20,1,20];
xp=mMatch3_rg(xc,cX,cY,Np,firstImgName,0);
rectImg = zeros(H,W);
[Up, Vp] = meshgrid(1:W,1:H);
xc_val = capimg(Aidx);
Maskimg  = zeros(size(I01));
Maskimg(Aidx) = 1;
rectImg = griddata(xp(1,:),xp(2,:),xc_val,Up,Vp);
%Ambient Image calculate
[Uc, Vc] = meshgrid(1:cW,1:cH);
capambiImg = imread([ImgPath,'\image82.bmp']);
capambiImg = double(capambiImg);
ambi_mean = mean(mean(capambiImg));
 ambiImg = ambi_mean*ones(H,W);
ambiImg = uint8(ambiImg);
ambiPath = [ImgPath,'\rectifyambiImg.bmp'];
imwrite(ambiImg,ambiPath);

IsNaN = isnan(rectImg);
rectImg(IsNaN==1) = ambi_mean;
% rectImg = rectImg +ambi_mean*IsNaN;
rectImg = uint8(rectImg);
rectPath = [ImgPath,'\rectifyImg.bmp'];
imwrite(rectImg,rectPath)
figure;
imshow(rectImg);

