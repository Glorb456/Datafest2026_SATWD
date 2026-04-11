encounters = readtable('encounters.csv');
providers = readtable('providers.csv');
patients = readtable('patients.csv');
census  = readtable("tigercensuscodes.csv");
%shp_file = readgeotable("shape_rural_urban.shp"); 

provider_specialty = providers.PrimarySpecialty;
patient_id = patients.DurableKey;
provider_match = encounters.ProviderDurableKey;
patient_match = encounters.PatientDurableKey;
provider_id = providers.DurableKey;
disp(providers(1:20, {'DurableKey', 'PrimarySpecialty'}))

%providers(strcmp(provider_specialty, 'NA'),:) = [];
%providers(strcmp(provider_specialty, '*Unspecified'),:) = [];
%providers(strcmp(provider_specialty, '*Deleted'),:) = [];
providers(strcmp(provider_specialty, '*Not Applicable'),:) = [];

pa_merge = innerjoin(encounters, patients, "LeftKeys","PatientDurableKey", "RightKeys", "DurableKey");

pa_filtered = pa_merge(:, ["PatientDurableKey", "ProviderDurableKey"]);
pr_merge = innerjoin(pa_filtered, providers, "LeftKeys","ProviderDurableKey", "RightKeys", "DurableKey");
pr_filtered = pr_merge(:,["ProviderDurableKey", "PatientDurableKey", "PrimarySpecialty"]);

%updated_census_and_demographic_table = class_as_urban_and_graph(census, patients, shp_file, 5)

