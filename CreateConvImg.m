basepath = 'squarearraypattern\';
SquareArraypath = [basepath,'SquareArray2.bmp'];
AmbiImgpath = [basepath,'AmbiImg.bmp'];
clc;
W= 912;H = 1140;
%generate the 8X5 rectangle figures
SquareArray = zeros(H,W);patch = ones(160,160);
for ii = 1:5
    for jj= 1:4    
%         if ii==1
%             patch(25-jj+[2:2:2*jj],:) =0;
%              if jj==1
%                  patch(:,40-ii+[2:2:2*ii]);    
%              end
%          else
%               if jj==1
%             patch(:,40-ii+[2:2:2*ii]);
%              else
%              patch = ones(80,80);
%               end
%         end
%       
    
%         SquareArray(35+(ii-1)*228:89+(ii-1)*228,26+(jj-1)*114:89+(jj-1)*114) = patch;
         SquareArray(35+(ii-1)*228:194+(ii-1)*228,35+(jj-1)*228:194+(jj-1)*228) = patch;
    end
end
imwrite(SquareArray,SquareArraypath);
%%
for kk = 1:96
    fullimgpath =[basepath,'BlurCalibImg_912x1140\squarearrayimg',int2str(kk),'.bmp'];
    sig  = 1+(kk-1)*0.2;
    gausFilter = fspecial('gaussian',round(6*sig),sig);
    blur=imfilter(SquareArray,gausFilter,'conv');
    imwrite(blur,fullimgpath)
end

AmbiImg = zeros(H,W);
imwrite(AmbiImg,AmbiImgpath);

