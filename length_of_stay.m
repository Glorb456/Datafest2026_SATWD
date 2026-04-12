%% checking for length of stay for people who got admitted

encounter_data = readtable("encounters.csv");
diagnosis_data = readtable("diagnosis.csv");
%Getting PatientDurablekey
patient_key = encounter_data.PatientDurableKey;
encounter_key = encounter_data.EncounterKey;

% Get all the admit info
Admit_day = encounter_data.AdmitDay;
Admit_hour = encounter_data.AdmitHour;
Admit_minute = encounter_data.AdmitMinute;
Admit_month = encounter_data.AdmitMonth;
Admit_year = encounter_data.AdmitYear;

% Getting all the discharge info
Discharge_day = encounter_data.DischargeDay;
Discharge_hour = encounter_data.DischargeHour;
Discharge_minute = encounter_data.DischargeMinute;
Discharge_month = encounter_data.DischargeMonth;
Discharge_year = encounter_data.DischargeYear;

indices_wo_NA = find(Admit_day ~= "NA");

% Filter all the data


filtered_patient_keys = patient_key(indices_wo_NA);



encounters_diabetes = find_diabetes_encounters(diagnosis_data, encounter_data);

%Get index of diabetes
%%
patients = readtable("patients.csv");
census  = readtable("tigercensuscodes.csv");
shp_file = readgeotable("C:\Users\wbead\Downloads\masterlist\final\tl_2020_us_uac20.shp");

%%
index_of_diabetes = ismember(encounter_key, encounters_diabetes);
index_of_admit_days = ismember(Admit_day, "NA");

index_of_days_wo_na = ~index_of_admit_days;

index_wo_NA_and_diabetes = (index_of_days_wo_na & index_of_diabetes);

admitted_patient_key = patient_key(index_wo_NA_and_diabetes);


filtered_Admit_day = Admit_day(index_wo_NA_and_diabetes);
filtered_Admit_hour = Admit_hour(index_wo_NA_and_diabetes);
filtered_Admit_minute = Admit_minute(index_wo_NA_and_diabetes);
filtered_Admit_month = Admit_month(index_wo_NA_and_diabetes);
filtered_Admit_year = Admit_year(index_wo_NA_and_diabetes);

filtered_Discharge_day = Discharge_day(index_wo_NA_and_diabetes);
filtered_Discharge_hour = Discharge_hour(index_wo_NA_and_diabetes);
filtered_Discharge_minute = Discharge_minute(index_wo_NA_and_diabetes);
filtered_Discharge_month = Discharge_month(index_wo_NA_and_diabetes);
filtered_Discharge_year = Discharge_year(index_wo_NA_and_diabetes);

% Convert admission and discharge dates to datetime format
admitDates = datetime(filtered_Admit_year + "-" + filtered_Admit_month + "-" + filtered_Admit_day + " " + ...
    filtered_Admit_hour + ":" + filtered_Admit_minute, 'InputFormat', 'yyyy-MM-dd HH:mm');
dischargeDates = datetime(filtered_Discharge_year + "-" + filtered_Discharge_month + "-" + filtered_Discharge_day + " " + ...
    filtered_Discharge_hour + ":" + filtered_Discharge_minute, 'InputFormat', 'yyyy-MM-dd HH:mm');

% Calculate length of stay in days
lengthOfStay = days(dischargeDates - admitDates);

%%

table1 = readtable('encounter_zips.csv')

updated_census_and_demographic_table = class_as_urban_and_graph(census, patients, shp_file, table1.PatientDurableKey);


idColumn = updated_census_and_demographic_table.PatientIDsAtThisLoc;

% 2. Calculate how many IDs are in each row
numIdsPerRow = cellfun(@numel, idColumn);

% 3. Create a repeated index to "stretch" the table
% This repeats the row index for as many IDs as are in that row
expandedIdx = repelem(1:height(updated_census_and_demographic_table), numIdsPerRow);

% 4. Create the expanded table (Duplicate rows to match ID counts)
expanded_table = updated_census_and_demographic_table(expandedIdx, :);

% 5. Replace the cell array column with the actual individual IDs
% 'vertcat' flattens the cell array of IDs into a single column
expanded_table.Individual_PatientID = vertcat(idColumn{:});

% 6. Remove the old cell array column to keep it clean
expanded_table.PatientIDsAtThisLoc = []
% 1. Clean the Department/Zip table
zipRef.zip = string(zipRef.zip);
% We only need specific columns from zipRef to avoid cluttering the final table

deptCoords = innerjoin(final_combined_table, zipRef(:, {'zip', 'lat', 'lng'}), ...
    'LeftKeys', 'PostalCode', 'RightKeys', 'zip');

% 2. Match Department coordinates to the Patient table
% Use INNERJOIN to ensure we only have rows where both patient and dept exist.
% This keeps your vectors perfectly aligned row-by-row.
final_mapping = innerjoin(expanded_table, deptCoords, ...
    'LeftKeys', 'Individual_PatientID', 'RightKeys', 'DepartmentKey');

% 3. Extract columns from the NEW combined table (Guarantees same length)
lat_pat = final_mapping.CENTLAT;  % Patient Latitude
lon_pat = final_mapping.CENTLON;  % Patient Longitude
lat_dept = final_mapping.lat;   % Department Latitude
lon_dept = final_mapping.lng;     % Department Longitude

% 4. Distance calculation in MILES
if license('test', 'map_toolbox')
    % Vectorized distance calculation
    dist_deg = distance(lat_pat, lon_pat, lat_dept, lon_dept);
    dist_miles = deg2sm(dist_deg); 
else
    % Manual Haversine (Vectorized)
    R = 3958.8; % Earth radius in miles
    phi1 = deg2rad(lat_pat);
    phi2 = deg2rad(lat_dept);
    dLat = deg2rad(lat_dept - lat_pat);
    dLon = deg2rad(lon_dept - lon_pat);
    
    a = sin(dLat/2).^2 + cos(phi1) .* cos(phi2) .* sin(dLon/2).^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    dist_miles = R * c;
end

% 5. Assign back to the table
final_mapping.Distance_Miles = dist_miles;

% 6. Create the final results summary
results =table() ;
results.PatientID = final_mapping.Individual_PatientID; % Or your ID column
results.Department = final_mapping.DepartmentName;
results.Distance_Miles = final_mapping.Distance_Miles