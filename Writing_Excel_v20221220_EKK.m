%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Writing_Excel_v20221220
%Originally written by Ty Templin
%Adapted by Emily Klinkman and Nicholas Fears
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update project name
prompt = {'Verify name of output file'};
title = 'Update output file name';
definput = {data_proj};
answer = inputdlg(prompt,title,[1 60],definput);
data_proj = answer{1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp_cell = data_cell;
temp_cell1 = temp_cell(:,1:4);
temp_cell2 = temp_cell(:,7:end);
write_cell = [temp_cell1 temp_cell2];
 
[yea, nay] = xlswrite([data_proj ' ' date], write_cell);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%If anything looks wonky, look at index #s