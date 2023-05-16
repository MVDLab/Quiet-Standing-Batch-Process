%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Batch QS Processing
%   Used on PROMT Study Data
%Subroutines
%   Importing_QS_v20221220_EKK, Processing_QS_v20221220_EKK,
%   copMeasures_ForceFiles_v20221220_EKK, Writing_Excel_v20221220_EKK
% Originally written by Ty Templin
% Adapted by Emily Klinkman and Nicholas Fears
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
clc %clears text from command window
%prompt user for project folder
%use as variable to save data, and to confirm assumptions %%%assume you
%have data on computer; might not necessarily pull from dropbox. TO get
%around this, replicate same but with Dropbox; get directories and
%subdirectories on dropbox within MATLAB
folder_proj = uigetdir; %opens modal dialog box that displays folders in current working directory & returns path that user selects
LOC_proj = regexp(folder_proj, '\'); %returns the starting index of each substring of str that matches the character patterns specified by the regular expression.
data_proj = folder_proj(LOC_proj(end)+1:end); 

repeat_loop = 'Yes';
iSub = 2;
first_time = 1;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder_data=strcat(folder_proj, '\Data'); %concatenate strings of text horizontally
folder_dflow=strcat(folder_data, '\Dflow'); %% this is file structure for V studies maybe not PROMT
subjectPattern_dflow=fullfile(folder_dflow,strcat(data_proj,'*')); %fullfile builds a full filename from specified directories and filename

dir_dflow=dir(subjectPattern_dflow); %lists & saves all generated files to directory?

dirFlags_Dflow = [dir_dflow.isdir]; %extract only those that are directories

names_dflow={dir_dflow.name};
names_dflow = names_dflow(dirFlags_Dflow);
%%
%new way
folder_return=pwd; %identifies current folder %%%%%%set actual Dropbox file path!!!!!!!!!!
cd (folder_proj) %sets current directory
cd Data\Clinical % navigate to demographics info
demfile=dir('V*Database*.xlsx'); % get correct demographics excel sheet
varsfile=dir('*variables*'); % get variables sheet
demofilepath=strcat(demfile.folder,'\',demfile.name); %get filepath to be used in import_demographics_readtable
sheetname='Clinical Data'; % name of sheet to be used in import_demographics_readtable
varsfilepath=strcat(varsfile.folder,'\',varsfile.name); %get filepath to be used in import_demographics_readtable

%% we only really need height from this sheet
heights=xlsread('VMAK_Database_Original_08.20.2021.xlsx','CH:CH');

cd (folder_return)
%%%%%
%Ty loop
for names_index=1:size(names_dflow,2)%change this to make general to dflow names_dflow
    subject_folder_dflow=char(strcat(folder_dflow,'\',names_dflow(1,names_index))); %char = character array
    subjdir = {dir(subject_folder_dflow).name};
    subjdir_phase=subjdir((contains(subjdir, 'Phase')));
    for phase_index=1:size(subjdir_phase,2) %shouldn't this produce 3, not 1?
        phase_folder_dflow=char(strcat(subject_folder_dflow,'\',subjdir_phase(1,phase_index))); %char = character array
        phasedir = {dir(phase_folder_dflow).name};
        phasedir_part=phasedir((contains(phasedir, 'Part')));
        for part_index=1:size(phasedir_part,2)
            part_label=string(phasedir_part(part_index));
            for j=1:3
                path_mc=char(strcat(phase_folder_dflow,'\',part_label,'\'));
                if j==1
                   dir_mc_file=dir([path_mc,'*closed*.txt']);
                elseif j==2
                    dir_mc_file=dir([path_mc,'*cross*.txt']);
                else
                    dir_mc_file=dir([path_mc,'*open*.txt']);
                end
                if strcmp(data_proj,'VMAD') && j==2 %VMAD does not have cross condition
               
                else
                    
                    if isempty(dir_mc_file)
                        disp('Warning: Missing a File so skipping this task') 
                    else
                        file_mc=dir_mc_file.name;
                        disp(file_mc)
                        Importing_QS_v20221220_EKK
                        Processing_QS_v20221220_EKK
                        iSub = iSub+1;
                    end
                end
            end
        end 
    end 
        
end
Writing_Excel_v20221220_EKK
save([data_proj ' ' date], 'data_cell');
