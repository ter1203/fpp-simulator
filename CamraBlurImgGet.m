distance='strp180mm'
obj = videoinput('gentl',1,'Mono8');
%(2) open the preview window of the video

% preview(obj);

vidRes = get(obj, 'VideoResolution');
nBands = get(obj, 'NumberOfBands');
frame = getsnapshot(obj);
imwrite(frame,['Image_',distance,'.bmp'],'bmp');
clear frame;
% num=num+1;

%% freeImage
 delete(obj);