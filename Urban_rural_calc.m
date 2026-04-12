% this thing takes a patient list and outputs data ab how many people are
% urban vs rural for it
updated_census_and_demographic_table = class_as_urban_and_graph(census, patients, shp_file, patientIDlist);
% 1. Use groupsummary to sum the 'GroupCount' column by 'Classification'
% This tells MATLAB: "Look at the GroupCount column and add the numbers together 
% for every row labeled Rural, then do the same for Urban."
final_counts = groupsummary(updated_census_and_demographic_table, ...
    'Classification', 'sum', 'GroupCount');

% 2. Rename the column for clarity
final_counts.Properties.VariableNames{'sum_GroupCount'} = 'TotalPatients';

% 3. Display the result
disp(final_counts)

% 4. To extract the numbers into variables for a report:
totalUrban = final_counts.TotalPatients(final_counts.Classification == "Urban");
totalRural = final_counts.TotalPatients(final_counts.Classification == "Rural");
totalUrban / (totalUrban + totalRural)

fprintf('Actual Urban Patient Count: %d\n', totalUrban);
fprintf('Actual Rural Patient Count: %d\n', totalRural);