clc;
clear;
sca;
close all;
clearvars;

rsvp_itr=1;
total_images=410;
rsvp_images=50;
trainIdx=[];
testIdx=[];

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
DrawFormattedText(window, 'Experiment-1', 'center',screenYpixels * 0.25, [0 0 1]);
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

load im.mat
imageTexture=[];
for i=1:total_images
     imageTexture = [imageTexture;Screen('MakeTexture', window,imresize(theImage(1:256,(i-1)*256+1:i*256,:),2))];
    %imageTexture = [imageTexture;Screen('MakeTexture', window,theImage(1:256,(i-1)*256+1:i*256,:))];

end

%%%%%%%%%%%%%%%%%%%%%%   SECOND SCREEN   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Experiment-1', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Press any key to continue !!', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  


KbStrokeWait;


flipSecs =  0.10;
waitframes = round(flipSecs / ifi);

for itr=1:rsvp_itr
%%%%%%%%%%%%%%%%%%%%%%%  Fixation Display  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('FillRect', window,[0 0 0]);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter yCenter], 2);
Screen('Flip', window);
WaitSecs(2);

%%%%%%%%%%%%%%%%%%%%%%         RSVP       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbl=Screen('Flip', window);
[a b]=system('PortWrite COM1 3');
idx=randperm(total_images,rsvp_images);
target=randperm(rsvp_images,4);
tmpidx=idx;
tmpidx(target)=0;
trainIdx=[trainIdx;tmpidx];
tic
    for i=1:rsvp_images
        if(size(find(target==i),2)~=0)
            Screen('FillRect', window,[1 0 0],centeredRect);
            [a b]=system('PortWrite COM1 1');
        else
            Screen('DrawTexture', window, imageTexture(tmpidx(i)), [], [], 0);
            [a b]=system('PortWrite COM1 2');
        end

        vbl=Screen('Flip', window,vbl+(waitframes-0.5) * ifi);
    
    end
toc
end


%%%%%%%%%%%%%%% Collect Training Data %%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect', window,[1 1 1]);
Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Training is over. save the EEG data', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Press any key to exit', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  

KbStrokeWait;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   TEST PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Screen('TextSize', window, 35);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Test Phase', 'center',screenYpixels * 0.25, [0 0 1]);
Screen('TextSize', window, 15);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Take your time to relex and then press X to continue.', 'center',screenYpixels * 0.75, [0 0 0]);
Screen('Flip', window);  

disp('Press X !!')
[s k d]=KbPressWait;
while find(k==1)~=88
    [s k d]=KbPressWait;
end


for itr=1:rsvp_itr
%%%%%%%%%%%%%%%%%%%%%%%  Fixation Display  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect', window,[0 0 0]);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter yCenter], 2);
Screen('Flip', window);
WaitSecs(2);
%%%%%%%%%%%%%%%%%%%%%%         RSVP       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vbl=Screen('Flip', window);
[a b]=system('PortWrite COM1 3');
idx=randperm(total_images,rsvp_images);
target=randperm(rsvp_images,4);
tmpidx=idx;
tmpidx(target)=0;
testIdx=[testIdx;tmpidx];

tic
    for i=1:rsvp_images
        if(size(find(target==i),2)~=0)
            Screen('FillRect', window,[1 0 0],centeredRect);
            [a b]=system('PortWrite COM1 1');
        else
            Screen('DrawTexture', window, imageTexture(tmpidx(i)), [], [], 0);
            [a b]=system('PortWrite COM1 2');
        end

        vbl=Screen('Flip', window,vbl+(waitframes-0.5) * ifi);
       
    end
toc
end



save 'D:\cccv_demo\data\index_data.mat' rsvp_itr rsvp_images trainIdx testIdx

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
