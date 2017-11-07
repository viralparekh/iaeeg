clear all;
clc;

load('feats.mat');
load('or.mat');

tsneY3 = tsne(feats,'Algorithm','exact','Distance','Cosine','Standardize',true,'Perplexity',20,'NumPCAComponents',50,'NumDimensions',3);
[pcaY3,score3,latent,tsquared,explained] = pca(feats','NumComponents',3);

[t,C,sumd,D] = kmeans(tsneY3,2);
[p,C,sumd,D] = kmeans(pcaY3,2);


if(size(find(t==2))<size(find(t==1)))
    t=3-t;
end
if(size(find(p==2))<size(find(p==1)))
    p=3-p;
end


color_1 = [1 0 0];
color_2 = [0 0 1];
cmap = [color_1; color_2;];


figure;
INDEX_color = cmap(labels,:);
scatter3(tsneY3(:,1),tsneY3(:,2),tsneY3(:,3),9,INDEX_color,'filled');
% title('tSNE with Original labels')
figure;
INDEX_color = cmap(t,:);
scatter3(tsneY3(:,1),tsneY3(:,2),tsneY3(:,3),9,INDEX_color,'filled');
% title('tSNE new labels')
figure;
INDEX_color = cmap(labels,:);
scatter3(pcaY3(:,1),pcaY3(:,2),pcaY3(:,3),9,INDEX_color,'filled');

figure;
INDEX_color = cmap(p,:);
scatter3(pcaY3(:,1),pcaY3(:,2),pcaY3(:,3),9,INDEX_color,'filled');
