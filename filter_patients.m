function [filtered_patientKeys] = filter_patients(patient_keys, Admit_days)
%UNTITLED4 Summary of this function goes here
%{
    This function filters the filtered_patientkeys
    Inputs: 
        - patient_keys: the column of patient keys in encounters.csv
        - Admit_days: the column of Admit_days in encounters.csv
    Outputs:
        - filtered_patientKeys - gives the list of patients who were
        admitted
%}
   
    Admit_days = Admit_days(indices_without_NA);
    indices_without_NA = Admit_days ~= "NA";
    filtered_patientKeys = patient_keys(indices_without_NA);
end
