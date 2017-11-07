clear;
sca;
close all;
clearvars;
clc;

% Experiment Parameters %
train_itr=50;
test_itr=50;
target_per_itr=3;
total_per_itr=50;
category='dollar_bill';
flipSecs =  0.15;

% other categories : 'Leopards','Motorbikes', 'airplanes','binocular', 'camera'
% 'brain', 'buddha','butterfly', 'ceiling_fan',  'cellphone', 'cup','dollar_bill'
%  'dolphin', 'umbrella', 'watch', 'scissors', 'rooster', 'pizza'

[train_images train_idx test_images test_idx]=getImages(train_itr,test_itr,target_per_itr,total_per_itr,category);


PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); 
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', [1]);
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber =max(screens); 
%screenNumber =1; 

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);



%%%%%%%%%%%%%%%%%%%%%   FIRST SCREEN    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Experiment-1 Training Phase', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Loading ...', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  


baseRect = [0 0 512 512];
%baseRect = [0 0 256 256];
[xCenter, yCenter] = RectCenter(windowRect);
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
ifi = Screen('GetFlipInterval', window);


fixCrossDimPix = 40;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;

imageTexture_train=[];
for i=1:total_per_itr*train_itr
     imageTexture_train = [imageTexture_train;Screen('MakeTexture', window,(train_images(:,:,i)))];
end


Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Experiment-1  Training Phase', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Press x to continue !!', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  

waitframes = round(flipSecs / ifi);

disp('Press X !!')
[s k d]=KbPressWait;
while find(k==1)~=88
    [s k d]=KbPressWait;
end



tic;
for itr=1:train_itr
system('PortWrite COM1 3');
%%%%%%%%%%%%%%%%%%%%%%%  Fixation Display  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect', window,[0 0 0]);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter yCenter], 2);
Screen('Flip', window);
WaitSecs(2);
%%%%%%%%%%%%%%%%%%%%%%         RSVP       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbl=Screen('Flip', window);

    
    for i=1:total_per_itr
        Screen('DrawTexture', window, imageTexture_train(total_per_itr*(itr-1)+i), [], [], 0);
        if(any(train_idx==(total_per_itr*(itr-1)+i))>0)
            %total_per_itr*(itr-1)+i
           system('PortWrite COM1 1');
        else
           system('PortWrite COM1 2');
        end
        vbl=Screen('Flip', window,vbl+(waitframes-0.5) * ifi);
    end


end
toc;
sca;
clear imageTexture_train;

disp('Press X !!')
[s k d]=KbPressWait;
while find(k==1)~=88
    [s k d]=KbPressWait;
end



%%%%%%%%%%%%%%% Collect Training Data %%%%%%%%%%%%%%%%%%%%%%%


PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); 
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', [1]);
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber =max(screens); 
%screenNumber =1; 

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);


%%%%%%%%%%%%%%%%%%%%%   FIRST SCREEN    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Experiment-1 Test Phase', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Loading ...', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  

baseRect = [0 0 512 512];

[xCenter, yCenter] = RectCenter(windowRect);
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
ifi = Screen('GetFlipInterval', window);

fixCrossDimPix = 40;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;

imageTexture_test=[];
for i=1:total_per_itr*test_itr
     imageTexture_test = [imageTexture_test;Screen('MakeTexture', window,(test_images(:,:,i)))];     
end

Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Experiment-1 Test Phase', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Press x to continue !!', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  

waitframes = round(flipSecs / ifi);

disp('Press X !!')
[s k d]=KbPressWait;
while find(k==1)~=88
    [s k d]=KbPressWait;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   TEST PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;
for itr=1:test_itr
system('PortWrite COM1 3');

%%%%%%%%%%%%%%%%%%%%%%%  Fixation Display  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect', window,[0 0 0]);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter yCenter], 2);
Screen('Flip', window);
WaitSecs(2);
%%%%%%%%%%%%%%%%%%%%%%         RSVP       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbl=Screen('Flip', window);

    for i=1:total_per_itr
        
        if(any(test_idx==(total_per_itr*(itr-1)+i))>0)
            %total_per_itr*(itr-1)+i
           system('PortWrite COM1 1');
        else
           system('PortWrite COM1 2');
        end
        Screen('DrawTexture', window, imageTexture_test(total_per_itr*(itr-1)+i), [], [], 0);
        vbl=Screen('Flip', window,vbl+(waitframes-0.5) * ifi);
    end


end

toc

Screen('FillRect', window,[1 1 1]);
Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Thank you for your participation', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Press any key to exit', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  
KbStrokeWait;
sca;

save 'D:\cccv_demo\data\experiment_data.mat' train_itr test_itr target_per_itr total_per_itr category train_images test_images train_idx test_idx





