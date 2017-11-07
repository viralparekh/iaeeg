clc;
clear all;
load('D:\cccv_demo\data\baseline-model.mat') ;
load('D:\cccv_demo\data\experiment_data.mat') ;

count=0;

for i=1:size(train_idx,2)
    disp(i);
    im=train_images(:,:,train_idx(i));
    label=model.classify(model, im);
    if(strcmp(label,category)~=1)
        disp(i);
        count=count+1;
        label
    end
end 