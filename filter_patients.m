function [filtered_patientKeys, indices_without_NA] = filter_patients(patient_keys, Admit_days)
%UNTITLED4 Summary of this function goes here
%{
    This function filters the filtered_patientkeys
    Inputs: 
        - patient_keys: the column of patient keys in encounters.csv
        - Admit_days: the column of Admit_days in encounters.csv
    Outputs:
        - filtered_patientKeys - gives the list of patients who were
        admitted
        - indices_without_NA - gives all the indices where there is no NA
%}
   
    indices_without_NA = Admit_days ~= "NA";
    filtered_patientKeys = patient_keys(indices_without_NA);
end
