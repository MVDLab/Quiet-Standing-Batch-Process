%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Importing_QS_v20221220
%Originally written by Ty Templin
%Adapted by Emily Klinkman and Nicholas Fears
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prompt for file inputs
%select trc, mc, and rd for one task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%assumptions
%filename assumptions:
%1. V study format VXXX_YYY_Z..Z, where X completes the study acronym, and YYY
%is subject number, and Z..Z is the rest of the file name in the trc
%filename that indicates the task
% function out= Importing_QS_v20190422_T(file_trc, path_trc,file_mc, path_mc,iSub)
home = pwd;

mc_table = readtable(fullfile(path_mc,file_mc)); %readtable creates one variable in T for each column in the file and reads variable names from the first row of the file.
headers_mc = mc_table.Properties.VariableNames;
data_mc = table2cell(mc_table);
data_mc = cell2mat(data_mc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mc=file_mc;
%%
%using assumption 1
LOC_Usc = regexp(mc, '_');
VMAD_14=mc(1:LOC_Usc(1)-1);%VMAD 14 has different file structure than the rest of VMAD
if strcmp(data_proj,'VMIB')|strcmp(VMAD_14,'VMAD')| strcmp(data_proj,'VMAK')
    file_proj = mc(1:LOC_Usc(1)-1);
    file_subj = mc(LOC_Usc(1)+1:LOC_Usc(2)-1);
    if j<=3
        file_task = mc(LOC_Usc(2)+1:LOC_Usc(3)-1);
        file_type = mc(LOC_Usc(3)+1:end-4);
    end
elseif strcmp(data_proj,'VMAD')
    LOC_Usc = regexp(trc, '_');
    file_proj = data_proj;
    file_subj = mc(1:LOC_Usc(1)-1);
    if j<=3
        file_task = mc(LOC_Usc(1)+1:LOC_Usc(2)-1);
        file_type = mc(LOC_Usc(2)+1:end-4);
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%create row entry format headers in 'data_cell' variable from 1-7
data_cell{1,1} = 'Project';
data_cell{1,2} = 'SubjNum';
data_cell{1,3} = 'Task';
data_cell{1,4} = 'Type';
data_cell{1,5} = 'McH';
data_cell{1,6} = 'Mc';
%%
%create row entry subject data in 'data_cell' columns 1-7
data_cell{iSub,1} = file_proj;
data_cell{iSub,2} = file_subj;
data_cell{iSub,3} = file_task;
data_cell{iSub,4} = file_type;
data_cell{iSub,5} = headers_mc;
data_cell{iSub,6} = data_mc;

%%% Will have to re-order list numbering
