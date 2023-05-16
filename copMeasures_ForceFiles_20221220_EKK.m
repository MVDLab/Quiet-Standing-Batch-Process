function [ output_args ] = copMeasures_ForceFiles_20221220_EKK( time, input_args, SRate,names_index,heights, input_no_sync)
%copMEasures - takes the D Flow force plate data from FP1 and FP2 and creates the
%net (combined) COP of the subjects standing trials
%   first column of data is time vector followed by FP1: copXYZ forceXYZ momentXYZ and
%   then FP2: copXYZ forceXYZ momentXYZ
%
%updates:
%   20180924 - added all force channels, updated the required data
%   20170331 - changed if hertz condition
%   20160201 - changed to process inner most data; removes the first and
%   last five seconds of entire trial assuming the data is processed at
%   120Hz
%
%   20151204 - copy of copMeasures_ForceFiles_20140821
%
%   20140821 - modified to accept variable format from Cortex Force Files
%            - sample rate also modified to 120 Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = length(time(:,1)); %Number of frames
disp(strcat('Number of Frames: ',num2str(L)))
hertz = round(1/mean(diff(time))); %frame rate
disp(strcat('Frame Rate: ', num2str(hertz)))
time_seconds = round(L/hertz); %time in seconds
disp(strcat('Time (s): ', num2str(time_seconds)))
%if hertz = 120, then 5 seconds == 600 samples
%isequal(hertz,120)
if (99<=hertz)&&(hertz<=121)
   %do stuff
   if time_seconds<=25
       norm = 0;
   else
       norm = 1;
   end   
   switch norm
       case 1
           A = 601;
           B = 3000;
       case 0
           A = 601;
           B = L;
       otherwise
   end           
else
    disp('Not sampled at 100-121Hz! - subroutine copMeasures')
    output_args = 'NotProcessed';
    return
end

forY1 = input_args(A:B,5);
copX1 = input_args(A:B,1);
copZ1 = input_args(A:B,3);
forY2 = input_args(A:B,14);
copX2 = input_args(A:B,10);
copZ2 = input_args(A:B,12);

netX = copX1.*forY1./(forY1+forY2) + copX2.*forY2./(forY1+forY2);
netZ = copZ1.*forY1./(forY1+forY2) + copZ2.*forY2./(forY1+forY2);
%average
stats.meanLx = mean(copX1);
stats.meanLz = mean(copZ1);
stats.meanRx = mean(copX2);
stats.meanRz = mean(copZ2);
stats.meanNx = mean(netX);
stats.meanNz = mean(netZ);
%std
stats.stdevLx = std(copX1);
stats.stdevLz = std(copZ1);
stats.stdevRx = std(copX2);
stats.stdevRz = std(copZ2);
stats.stdevNx = std(netX);
stats.stdevNz = std(netZ);
%rms
stats.rmsLx = sqrt(sum(copX1.*copX1)/length(copX1));
stats.rmsLz = sqrt(sum(copZ1.*copZ1)/length(copZ1));
stats.rmsRx = sqrt(sum(copX2.*copX2)/length(copX2));
stats.rmsRz = sqrt(sum(copZ2.*copZ2)/length(copZ2));
stats.rmsNx = sqrt(sum(netX.*netX)/length(netX));
stats.rmsNz = sqrt(sum(netZ.*netZ)/length(netZ));
%copArea
stats.cAreaL = std(copX1)*3*std(copZ1)*3;
stats.cAreaR = std(copX2)*3*std(copZ2)*3;
stats.cAreaN = std(netX)*3*std(netZ)*3;


%additional Measures
%from Prieto et al 1996
%time series references to the mean COP
APn = netZ-mean(netZ); %net x/z is the same as APo/MLo
MLn = netX-mean(netX);
%resultant distance (RD) time series: vector distance from mean COP to
 %each pair of point in APo and MLo time series (o: original)
RDn = sqrt(APn.^2 + MLn.^2);
%mean distance (mDIST) mean if RD time series, represents average distance
 %from mean COP
stats.mDIST = mean(RDn);
mDISTap = mean(APn);
mDISTml = mean(MLn);
% stats.SwayIndex=sqrt(mean((APn.^2 + MLn.^2)));
%rms distance (rDIST) from the mean COP is th RMS value of the RD time
 %series
stats.rDIST = sqrt(sum(RDn.^2)/length(RDn));
rDISTap = sqrt(sum(APn.^2)/length(APn));
rDISTml = sqrt(sum(MLn.^2)/length(MLn));

%total excursions (TOTEX) is the trial length of the COP path,approximated
%by the sum of the consecutive points on the COP path
TOTEX = 0; TOTEXap = 0; TOTEXml = 0;
for i = 1:length(APn)-1
    TOTEX = TOTEX + sqrt((APn(i+1) - APn(i))^2 + (MLn(i + 1) -MLn(i))^2);
    TOTDIFF(i)=sqrt((APn(i+1) - APn(i))^2 + (MLn(i + 1) -MLn(i))^2);
    TOTEXap = TOTEXap + sqrt((APn(i + 1) - APn(i))^2);
    TOTEXml = TOTEXml + sqrt((MLn(i + 1) - MLn(i))^2);    
end
stats.pathN = TOTEX;
%%
%Ty added filter of data because path lengths were too long due to noisy
%data
% MLn2=interp1(linspace(0,1, size(MLn,1)), (MLn), linspace(0,1,400));
% APn2=interp1(linspace(0,1, size(APn,1)), (APn), linspace(0,1,400));

MLn3=MLn(1:6:end);
APn3=APn(1:6:end);

fc = 6;
fs = 120;
[b,a] = butter(4,fc/(fs/2));
MLn2=filter(b,a,MLn3);
APn2=filter(b,a,APn3);
TOTEX2 = 0; TOTEXap2 = 0; TOTEXml2 = 0;
for i = 1:length(APn2)-1
    TOTEX2 = TOTEX2 + sqrt((APn2(i+1) - APn2(i))^2 + (MLn2(i + 1) -MLn2(i))^2);
    TOTDIFF2(i)=sqrt((APn2(i+1) - APn2(i))^2 + (MLn2(i + 1) -MLn2(i))^2);
    TOTEXap2 = TOTEXap2 + sqrt((APn2(i + 1) - APn2(i))^2);
    TOTEXml2 = TOTEXml2 + sqrt((MLn2(i + 1) - MLn2(i))^2);
end

%%
%mean velocity (mVELO) is the average velocity of the COP; normaillzes
%total excursions to the analysis interval
%T = length(APn)/1200;
SRate;
T = length(APn)/SRate;
% if T< 18
%     a=1;
% end
mVELO = TOTEX/T;
mVELOap = TOTEXap/T;
mVELOml = TOTEXml/T;

stats.mvN = mVELO;
stats.mFN = mVELO/(2*pi*stats.mDIST);
%%
%applying filtering path length data to other params

mVELO2 = TOTEX2/T;
mVELOap2 = TOTEXap2/T;
mVELOml2 = TOTEXml2/T;

stats.pathN_filt = TOTEX2;
stats.mvN_filt = mVELO2;
stats.mFN_filt = mVELO2/(2*pi*stats.mDIST);
stats.dur = T;


output_args = stats;
end

