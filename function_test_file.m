clear;
encounters_drug_related = find_diabetes_encounters(); 
person_ID = encounter2person(encounters_drug_related);

%% 

encounters_data = readtable("encounters.csv");


patient_ID = 
% testing filter patients function
