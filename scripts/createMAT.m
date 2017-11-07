clear all;
clc;
isize=256;

spath='D:\cccv_demo\101_ObjectCategories\airplanes';
imlist=[];
paths=dir(strcat(spath,'\*.jpg'));
imname={paths(:).name}';
imlist=[imlist;char(strcat(spath,'\',imname))];

images=[];
tic
for i=1:size(imlist,1)
    a=imread(imlist(i,:),'jpg');
    if(size(a,3)>1)
    a=rgb2gray(a);
    end
    if(size(a,2)>size(a,1))
        a=imresize(a,[isize/size(a,2)]);
    else
        a=imresize(a,[isize/size(a,1)]);
    end
    x=(isize-size(a,2))/2;
    y=(isize-size(a,1))/2;
    
    tform = maketform('affine',[1 0 0; 0 1 0;x y 1]);
    images(:,:,i)=imtransform(a,tform,'XData',[1 isize],'YData',[1 isize]);
    %figure;imshow(uint8(images(:,:,i)));
    
end 
toc
images=uint8(images);

