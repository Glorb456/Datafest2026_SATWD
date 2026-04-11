function person_list = encounter2person(encounter_list)
%takes in an inputted encounter key list and outputs a list of person IDS
    data = readtable('encounters.csv');
    rows_to_keep = ismember(data.EncounterKey, encounter_list);
    person_list = data.PatientDurableKey(rows_to_keep);
    person_list = unique(person_list);
end