data = readtable('diagnosis.csv');
%getting specific columns in the data 
diag_name = data.DiagnosisName;
diag_key_data = data.DiagnosisKey;
num_synth_diag = 0; 
diag_key_array = []; 

%getting keys for all synthetic narcotics diagnosis
for i = 1:length(diag_name)
    if contains(diag_name(i), "synthetic narcotics")
        num_synth_diag = num_synth_diag + 1; 
        diag_key_array(end+1) = diag_key_data(i);
    end 
end 
diag_key_array = diag_key_array';

%%
encounters = readtable('encounters.csv');
prim_diag = encounters.PrimaryDiagnosisKey;
