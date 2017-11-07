
load im.mat
%load 'D:\cccv_demo\data\index_data.mat'
load 'D:\cccv_demo\data\prediction_data.mat'
rsvp_images=100;
red=zeros(256,256,3);
red(:,:,1)=255;
% 
% 
% Image=[];
% for k=1:rsvp_itr
% idx=reshape(testIdx(k,:),[rsvp_images,1])';
% for i=1:1
%     ti=[];
%     for j=1:rsvp_images
%       if(idx(i,j)==0)
%       ti=[ti imresize(red,0.1)];
%       else
%       ti=[ti imresize(theImage(1:256,(idx(i,j)-1)*256+1:idx(i,j)*256,:),0.1)];    
%       end
%        
%     end
%     Image=[Image;ti];
%    
% end
% 
% end
%  figure;imshow(Image);
%  


l=cell2mat(predictions(2));
m=l(:,1);

[targetval targetidx]=sort(m,'descend');

mtestIdx=testIdx';
mtestIdx=mtestIdx(:);

mtestIdx=mtestIdx(targetidx);
mtestIdx=reshape(mtestIdx,[rsvp_images,rsvp_itr]);
mtestIdx=mtestIdx';

red=zeros(256,256,3);
red(:,:,1)=255;

Image=[];
for k=1:rsvp_itr
idx=reshape(mtestIdx(k,:),[rsvp_images,1])';
for i=1:1
    ti=[];
    for j=1:rsvp_images
      if(idx(i,j)==0)
      ti=[ti imresize(red,0.1)];
      else
      ti=[ti imresize(theImage(1:256,(idx(i,j)-1)*256+1:idx(i,j)*256,:),0.1)];    
      end
       
    end
    Image=[Image;ti];
   
end

end
 figure;imshow(Image);
 