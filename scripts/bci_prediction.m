[FileName,PathName] = uigetfile('*.set','Select the TrainSet');
TrainDataPath=[PathName FileName]
[FileName,PathName] = uigetfile('*.set','Select the TestSet');
TestDataPath=[PathName FileName]

%bcilab;
trainset = io_loadset(TrainDataPath)
testset  = io_loadset(TestDataPath)
myapproach1 = {'Windowmeans' 'SignalProcessing', {'EpochExtraction',[0 1]}, ...
               'Prediction',{'FeatureExtraction',{'TimeWindows',[0 0.1;0.1 0.2;0.2 0.3;0.3 0.4;0.4 0.5;0.5 0.6;0.6 0.7;0.7 0.8;0.8 0.9;0.9 1]},'MachineLearning',{'Learner','lda'}}};
           
myapproach2 = {'DALERP', 'SignalProcessing',{'EpochExtraction',[0 0.8]}};


[loss,model,stats] = bci_train('Data',trainset, 'Approach',myapproach1, 'TargetMarkers',{'1','2'});

bci_visualize(model)

[predictions,testloss,teststats,targets] = bci_predict(model,testset);

% save 'D:\cccv_demo\data\prediction_data.mat' predictions testloss teststats targets loss model stats  




