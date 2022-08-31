% SimEdgeBlur
clear
OrigI = zeros(800,1280);
for kk = 1:16
    OrigI(:,80*kk-39:80*kk) = 255*ones(800,40);
end
% OrigI = [zeros(800,160),255*ones(800,160),zeros(800,160),255*ones(800,160),zeros(800,160),255*ones(800,160),zeros(800,160),255*ones(800,160)];
OrigI = uint8(OrigI);

impath = 'NCCforSigma\';
 imwrite(OrigI,[impath,'OrigI.bmp']);
sig = 2;
gausFilter = fspecial('gaussian',round(6*sig),sig);
blurI=imfilter(OrigI,gausFilter,'conv');
% imwrite(blurI,[impath,'blurI.bmp']);
sig0 = 8;
gausFilter1 = fspecial('gaussian',round(6*sig0),sig0);
blurI1=imfilter(blurI,gausFilter1,'conv'); 
imwrite(blurI1,[impath,'blurI1.bmp']);
blurI = double(blurI);
blurI1 = double(blurI1);
[gradx,grady] = gradient(blurI);
[grad1x,grad1y] = gradient(blurI1);
BW =edge(OrigI,'canny');
BW_edge=find(BW==1);

 
Rmaxs = abs(gradx(BW_edge)./grad1x(BW_edge));
rmax = mean(Rmaxs(100:end-100));
sig_esti = 1/sqrt(rmax^2-1)*sig0
% imshow(normal_edge);