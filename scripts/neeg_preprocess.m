
[File,Path] = uigetfile('*.edf','Select the Training EEG edf file');
EEG=pop_biosig([Path File],'channels',[3 4 5 6 7 8 9 10 11 12 13 14 15 16 36],'rmeventchan','on');
TrainFile=[File(1:end-4) '.set']
EEG = pop_saveset(EEG, 'filename',TrainFile, 'filepath', Path);
disp('Stored Training eeg data in EEGLAB set format..');

[File,Path] = uigetfile('*.edf','Select the Test EEG edf file');
EEG=pop_biosig([Path File],'channels',[3 4 5 6 7 8 9 10 11 12 13 14 15 16 36],'rmeventchan','on');
TestFile=[File(1:end-4) '.set']
EEG = pop_saveset(EEG, 'filename',TestFile, 'filepath', Path);
disp('Stored Training eeg data in EEGLAB set format..');