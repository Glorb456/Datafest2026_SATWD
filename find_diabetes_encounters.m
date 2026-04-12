function encounters_drug_related = find_diabetes_encounters(data, encounters)
    %returns all of the encounters in the dataset that are about type 2
    %diabetes


    data = readtable('diagnosis.csv');
    %getting specific columns in the data 
    diag_name = data.DiagnosisName;
    diag_key_data = data.DiagnosisKey;
    num_synth_diag = 0; 
    diag_key_array = []; 
    
    %getting keys for all synthetic narcotics diagnosis
    for i = 1:length(diag_name)
<<<<<<< HEAD
        if contains(diag_name(i), "diabetes mellitus", "IgnoreCase", true)
=======
        if contains(diag_name(i), "Asthma", "IgnoreCase", true)
>>>>>>> e1d2e2ad385a849647d94c5aadc61e8cbb597b21
            num_synth_diag = num_synth_diag + 1; 
            diag_key_array(end+1) = diag_key_data(i);
        end 
    end 
    diag_key_array = diag_key_array';
    
    primary_diag_key = encounters.PrimaryDiagnosisKey;
    encounter_key = encounters.EncounterKey; 
    encounters_drug_related = [];
    for i = 1:length(primary_diag_key)
        if ismember(primary_diag_key(i), diag_key_array) == 1
            encounters_drug_related(end+1) = encounter_key(i);
        end 
    end 
    
    encounters_drug_related = encounters_drug_related';
end 