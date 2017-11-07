
cpath='D:\cccv_demo\EDFConverterConsole';
[train_input_file,train_path] = uigetfile('*.edf','Select the Train EEG edf file');
train_output_file=[train_input_file(1:end-4) '.CSV'];

[test_input_file,test_path] = uigetfile('*.edf','Select the Test EEG edf file');
test_output_file=[test_input_file(1:end-4) '.CSV'];


[a b]=system([cpath ' --inputfile ' train_path train_input_file ' --outputfile ' train_path train_output_file]);
[a b]=system([cpath ' --inputfile ' test_path test_input_file ' --outputfile ' test_path test_output_file]);
WaitSecs(2);

disp('edf files converted to CSV files..');


train_filepath=strcat(train_path,train_output_file);
test_filepath=strcat(test_path,test_output_file);

train_csv= importdata(train_filepath);
train_eegdata = train_csv.data;
train_eegdata(:,17:35) = [];
train_eegdata(:,1:2) = [];


test_csv = importdata(test_filepath);
test_eegdata = test_csv.data;
test_eegdata(:,17:35) = [];
test_eegdata(:,1:2) = [];


temp_eegdata=[];
for i=1:size(train_eegdata,1)-1
    temp_eegdata=[temp_eegdata;train_eegdata(i,:)];
    if(train_eegdata(i,15)~=0 &&train_eegdata(i+1,15)~=0 )
        k=train_eegdata(i,:);
        k(1,15)=0;
        temp_eegdata=[temp_eegdata;k];   
    end
end
train_eegdata=temp_eegdata';


temp_eegdata=[];
for i=1:size(test_eegdata,1)-1
    temp_eegdata=[temp_eegdata;test_eegdata(i,:)];
    if(test_eegdata(i,15)~=0 &&test_eegdata(i+1,15)~=0 )
        k=test_eegdata(i,:);
        k(1,15)=0;
        temp_eegdata=[temp_eegdata;k];   
    end
end
test_eegdata=temp_eegdata';

disp('Preprocessing done on csv data, now loading into eeglab..');
%eeglab;
train_EEG = pop_importdata('data',train_eegdata,'srate',128); % import data from MATLAB array
train_EEG = pop_chanevent(train_EEG, 15,'edge','leading','edgelen',0); % event channel
train_EEG = pop_chanedit(train_EEG, 'load',{'C:\Program Files\openvibe\share\openvibe-scenarios\P300New\emotiv.ced' 'filetype' 'autodetect'}); % channel locations
train_EEG = pop_saveset(train_EEG, 'filename', [train_input_file(1:end-4) '.set'], 'filepath', train_path);
disp('Stored Training eeg data in EEGLAB set format..');



test_EEG = pop_importdata('data',test_eegdata,'srate',128); % import data from MATLAB array
test_EEG = pop_chanevent(test_EEG, 15,'edge','leading','edgelen',0); % event channel
test_EEG = pop_chanedit(test_EEG, 'load',{'C:\Program Files\openvibe\share\openvibe-scenarios\P300New\emotiv.ced' 'filetype' 'autodetect'}); % channel locations
test_EEG = pop_saveset(test_EEG, 'filename', [test_input_file(1:end-4) '.set'], 'filepath', test_path);
disp('Stored Test eeg data in EEGLAB set format..');