%dual interpolate the gray value along Up and Vp
max_val = 255;
min_val = 100;
X= [1,1280,1,1280];
Y = [1,1,800,800];
s1 = 800/sqrt(800^2+1280^2);
s2 = 1280/sqrt(800^2+1280^2);
v1 = min_val+0.5*s1*(max_val-min_val);
v2  = max_val;
v3 = min_val;
v4  = min_val+s2*(max_val-min_val);
V  = [v1,v2,v3,v4];
[Xp,Yp] = meshgrid(1:1280,1:800);
interp_val = griddata(X,Y,V,Xp,Yp);
surf(Xp,Yp,interp_val)
interp_val= uint8(interp_val);
impath = 'E:\structlight\pro_p20_T60_1920_1080\0.bmp';
imwrite(interp_val,impath);