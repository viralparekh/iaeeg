clc;
clear all;
load 'D:\cccv_demo\data\experiment_data.mat'
tic
clear test_images
train_traige=[];
wc=zeros(256,256)+255;
bc=zeros(256,256);

c=[];
for i=1:train_itr
     ti=[];
    for j=1:total_per_itr
        if(any(train_idx==(total_per_itr*(i-1)+j))>0)
            c=[c total_per_itr*(i-1)+j];
            ti=[ti imresize(bc,0.1)];  
        else
            ti=[ti imresize(wc,0.1)];
            %ti=[ti imresize(train_images(:,:,total_per_itr*(i-1)+j),0.1)];    
        end
    end
    train_traige=[train_traige;ti];
end
toc
figure;imshow(train_traige);


clear all;
load 'D:\cccv_demo\data\experiment_data.mat'
clear train_images
test_triage=[];
wc=zeros(256,256)+255;
bc=zeros(256,256);
type=2;

if(type==1)
%%%%%%%%%%%%%%%%%%  Test Triage %%%%%%%%%%%%%%%%%%%%%%%%%%%%


test_triage=[]
for i=1:test_itr
     ti=[];
    for j=1:total_per_itr
        if(any(test_idx==(total_per_itr*(i-1)+j))>0)
            ti=[ti imresize(bc,0.1)];  
        else
            ti=[ti imresize(wc,0.1)];
            %ti=[ti imresize(train_images(:,:,total_per_itr*(i-1)+j),0.1)];    
        end
    end
    test_triage=[test_triage;ti];
end
toc
figure;imshow(test_triage);



else
    
test_triage=[]
for i=1:test_itr
     ti=[];
    for j=1:total_per_itr
        if(any(test_idx==(total_per_itr*(i-1)+j))>0)
            %ti=[ti imresize(bc,0.1)];
            ti=[ti imresize(test_images(:,:,total_per_itr*(i-1)+j),0.1)];
        else
            ti=[ti imresize(wc,0.1)];
            %ti=[ti imresize(test_images(:,:,total_per_itr*(i-1)+j),0.1)];    
        end
    end
    test_triage=[test_triage;ti];
end
toc
figure;imshow(test_triage);

    
    
end


