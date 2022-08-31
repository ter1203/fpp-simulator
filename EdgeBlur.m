% this program is used to calibrate the defocus kernel of camera by reblurring 
clear
impath = 'NCCforSigma\';
blurI = imread('Image_strp180mm.bmp');
[I_H,I_W]=size(blurI);
bwimg =im2bw(blurI,0.4);
imshow(bwimg);
sig0 = 8;
gausFilter1 = fspecial('gaussian',round(6*sig0),sig0);
blurI1=imfilter(blurI,gausFilter1,'conv'); 
imwrite(blurI1,[impath,'blurI1.bmp']);
blurI = double(blurI);
blurI1 = double(blurI1);
[gradx,grady] = gradient(blurI);
[grad1x,grad1y] = gradient(blurI1);
BW =edge(blurI,'canny');
figure
imshow(BW);
%hough transform
[H,T,R] = hough(BW,'Theta',-90:0.5:89.5);
P = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));
Trg=[-90:-85,85:90];
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',100);
%
figure, imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
LINE = cell(1,length(lines));
LINEIDX=cell(1,length(lines));
for k=1:length(lines)
    point1= lines(k).point1;
    point2=lines(k).point2;
    if abs(point1(1)-point2(1))>abs(point1(2)-point2(2))
        LINE{k}=zeros(2,abs(point1(1)-point2(1))+1);
        for pts=point1(1):point2(1)
            xpt = pts;
            ypt=(point1(2)-point2(2))/(point1(1)-point2(1))*( pts-point1(1))+point1(2);
           ypt= round(ypt);
            idx=abs(pts-point1(1))+1;
            LINE{k}(1,idx)=xpt;
            LINE{k}(2,idx)=ypt;          
            LINEIDX{k}(idx)=(xpt-1)*I_H+ypt;
        end
    else
        %
        for pts=point1(2):point2(2)
           ypt = pts;
            xpt=(point1(1)-point2(1))/(point1(2)-point2(2))*( pts-point1(2))+point1(1);
            xpt = round(xpt);
            idx=abs(pts-point1(2))+1;
            LINE{k}(1,idx)=xpt;
            LINE{k}(2,idx)=ypt;    
             LINEIDX{k}(idx)=(xpt-1)*I_H+ypt;
        end  
    end
end

        Rmax=cell(1,length(lines));
         SIGMA= zeros(1,length(lines));
    for k=1:length(lines)
        grad = sqrt((gradx( LINEIDX{k}(:))).^2+(grady( LINEIDX{k}(:))).^2);
        grad1=sqrt((grad1x( LINEIDX{k}(:))).^2+(grad1y( LINEIDX{k}(:))).^2);
        Rmax{k}(:)=abs(grad./grad1);
       Rmean(k)=mean(Rmax{k}(:));
         SIGMA(k)=1./sqrt(Rmean(k)^2-1)*sig0; 
    end
 SIGMA
   mSIG=mean(SIGMA)
    
% edge_idx = find(normal_edge==1);
% imshow(F1);
% Rmax = abs(gradx(edge_idx)./grad1x(edge_idx));
% rmax = mean(Rmax(100:end-100));
% sig_esti = 1/sqrt(rmax^2-1)*sig0;
% imshow(normal_edge);