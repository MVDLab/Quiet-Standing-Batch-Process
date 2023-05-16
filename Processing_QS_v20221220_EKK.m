%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Processing_QS_v20221220
%Originally written by Ty Templin
%Adapted by Emily Klinkman and Nicholas Fears
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear input_area
%%
%DFLOW Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the sampling rate
time = data_mc(:,1);
time_diff1 = diff(time);
rate_avg = mean(time_diff1);
rate_sampling = 1/rate_avg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
LOC_rnp = find(ismember(headers_mc,'Channel16_Anlg'));
LOC_rnp_start = find(data_mc(:,LOC_rnp)>1.4);
if isempty(LOC_rnp_start)
    LOC_rnp_start=1;
else
    LOC_rnp_start = LOC_rnp_start(1,1);
end
data_mc_syncd = data_mc(LOC_rnp_start:end,:);
time = data_mc(LOC_rnp_start:end,1);
LOC_FP1 = find(ismember(headers_mc,'FP1_CopX'));
data_mc_forces = data_mc_syncd(:,LOC_FP1:LOC_FP1+17);
data_mc_forces_no_sync = data_mc(:,LOC_FP1:LOC_FP1+17);
%Calculate measures from force plate; reference article: 1996, Prieto et al

%QUESTION: Is it worth leaving as struct? or do i change to table?
[ output_args ] = copMeasures_ForceFiles_20221220_EKK(time, data_mc_forces, rate_sampling, names_index, heights, data_mc_forces_no_sync);
temp_out = struct2cell(output_args);
temp_headers = fieldnames(output_args);
if first_time
    for i = 1:length(temp_out)
        data_cell{1,9+i} = temp_headers{i,1};
    end
    for i = 1:length(temp_out)
        data_cell{iSub,9+i} = temp_out{i,1};
    end
else
    for i = 1:length(temp_out)
        data_cell{iSub,9+i} = temp_out{i,1};
    end
end
%     table.(sub)(j,7) = {output_args.dur};
%     FPstats.(sub).(eye_con) = output_args;