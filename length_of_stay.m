%% checking for length of stay for people who got admitted

encounter_data = readtable("encounters.csv");

%Getting PatientDurablekey
patient_key = encounter_data.PatientDurableKey;

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
filtered_Admit_day = Admit_day(indices_wo_NA);
filtered_Admit_hour = Admit_hour(indices_wo_NA);
filtered_Admit_minute = Admit_minute(indices_wo_NA);
filtered_Admit_month = Admit_month(indices_wo_NA);
filtered_Admit_year = Admit_year(indices_wo_NA);

filtered_Discharge_day = Discharge_day(indices_wo_NA);
filtered_Discharge_hour = Discharge_hour(indices_wo_NA);
filtered_Discharge_minute = Discharge_minute(indices_wo_NA);
filtered_Discharge_month = Discharge_month(indices_wo_NA);
filtered_Discharge_year = Discharge_year(indices_wo_NA);

filtered_patient_keys = patient_key(indices_wo_NA);

% Convert admission and discharge dates to datetime format
admitDates = datetime(filtered_Admit_year + "-" + filtered_Admit_month + "-" + filtered_Admit_day + " " + ...
    filtered_Admit_hour + ":" + filtered_Admit_minute, 'InputFormat', 'yyyy-MM-dd HH:mm');
dischargeDates = datetime(filtered_Discharge_year + "-" + filtered_Discharge_month + "-" + filtered_Discharge_day + " " + ...
    filtered_Discharge_hour + ":" + filtered_Discharge_minute, 'InputFormat', 'yyyy-MM-dd HH:mm');

% Calculate length of stay in days
lengthOfStay = days(dischargeDates - admitDates);