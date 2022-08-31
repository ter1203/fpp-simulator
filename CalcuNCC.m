%calculate NCC: this program is used to calibrate the projector blur kernel
%by cross-correlation analysis the projector kernel
clc;
clear;
SumImgN = 96;
basepath = 'squarearraypattern\';
rectfyimgpath = [basepath 'CaptureImg\rectifyImg.bmp'];
rectifyimg = imread(rectfyimgpath);
rectifyimg = double(rectifyimg);
ambiImg = imread([basepath,'CaptureImg\rectifyambiImg.bmp']);
for imgN = 1:SumImgN
     imgpath =[basepath 'BlurCalibImg_912x1140\squarearrayimg' int2str(imgN) '.bmp'];
     convimg(:,:,imgN) = imread(imgpath);
%  convimg(:,:,imgN) = convimg(:,:,imgN)+ambiImg;
end
convimg=double(convimg);
Rncc = cell(5,4);
 for ii = 1:5
     for jj = 1:4
         %extrdue the (ii,jj) subfigure
         subrectifyimg  =rectifyimg(228*ii-227:228*ii,228*jj-227:228*jj);
        
        for kk=1:SumImgN
             subconvimg  =convimg(228*ii-227:228*ii,228*jj-227:228*jj,kk);
            %judge the correlationship of every sub figure
            sumxiyi = sum(sum(subrectifyimg.*subconvimg));
            xbar = sum(sum(subrectifyimg))./(size(subrectifyimg,1)*size(subrectifyimg,2));
            ybar = sum(sum(subconvimg))./(size(subrectifyimg,1)*size(subrectifyimg,2));
            sumxi_2 = sum(sum(subrectifyimg.^2));
            sumyi_2 = sum(sum(subconvimg.^2));
            nn = size(subrectifyimg,1)*size(subrectifyimg,2);
            Rncc{ii,jj}(kk) =abs((sumxiyi-nn*xbar*ybar)./(sqrt(sumxi_2-nn*xbar^2)*sqrt(sumyi_2-nn*ybar^2)));
%            Rncc(kk)  = (sum(sum(capimg-convimg(:,:,kk))))./(sqrt(sum(sum(capimg.^2)))*sqrt(sum(sum(convimg(:,:,kk).^2))));
       
        end
     end
   
 end
%     Rncc = abs(Rncc);
    sigma = zeros(5,4);
  for ii=1:5
      for jj = 1:4
          sortrncc = sort(Rncc{ii,jj});
          max1val = sortrncc(end);
          max2val = sortrncc(end-1);
          max1idx = find(Rncc{ii,jj}==max1val);
          max2idx = find(Rncc{ii,jj}==max2val);
%           sigma(ii,jj) = 1+((max1idx+max2idx)/2-1)*0.2;
            sigma(ii,jj) = 1+(max1idx-1)*0.2;
      end
  end
 
 
 
 