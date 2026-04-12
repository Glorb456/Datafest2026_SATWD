%this function combines and aligns given census and patient data based on

% FIPS census codes. after this it checks if the provided census points are

% within urban areas and graphs them accordingly





% inputs

% loaded census file as a table

% loaded patient file as a table

% loaded shp file loaded using readgeotable command, ts requires special packages

% array of patient ID list

%

% % outputs

% graph of selected people and their homes with rural / urban classification

% updated table with updated rural / urban classifications


function updated_census_and_demographic_table = class_as_urban_and_graph(census, patients, shp_file, patientIDlist)

    % 1. Prepare and Clean Data
    census.GEOID = string(census.GEOID);
    
    % Filter out unspecified FIPS codes
    isUnknown = strcmpi(patients.CensusBlockGroupFipsCode, '*Unspecified');
    filtered_patients = patients(~isUnknown, :);

    % Filter the patients based on the provided patientIDlist (assuming 'ID' column exists)
    % This ensures the graph only shows the people you actually care about.
    idFilter = ismember(filtered_patients.DurableKey, patientIDlist); 
    filtered_patients = filtered_patients(idFilter, :);

    % 2. Join the Tables
    % Link census geometry (Lat/Lon) to patient data via FIPS codes
    combined_data = innerjoin(census, filtered_patients, ...
        'LeftKeys', 'GEOID', 'RightKeys', 'CensusBlockGroupFipsCode');

    % 3. Summarize for Graphing
    % This aggregates the data so we have one row per unique location/race combo
    % Assuming varX/varY are CENTLAT and CENTLON
    % This adds a column 'GroupCount' and a column 'id_list' containing the IDs
summary_table = groupsummary(combined_data, {'CENTLAT', 'CENTLON'}, ...
    @(x) {x}, 'DurableKey'); 
summary_table.Properties.VariableNames{end} = 'PatientIDsAtThisLoc';

    % 4. Urban/Rural Classification
    % Filter Shapefile to Kansas only
    urbanAreas = shp_file; 
    keepRows = (endsWith(urbanAreas.NAME20, "KS") == true);
    urbanAreas = urbanAreas(keepRows, :);

    % Initialize classification columns
    summary_table.Classification = repmat("Rural", height(summary_table), 1);
    isUrban = false(height(summary_table), 1);

    % Create geographic points from summarized coordinates
    queryPoints = geopointshape(summary_table.CENTLAT, summary_table.CENTLON);

    % Loop through each Kansas urban polygon (Scalar check fix)
    for i = 1:numel(urbanAreas.Shape)
        inCurrent = isinterior(urbanAreas.Shape(i), queryPoints);
        isUrban = isUrban | inCurrent;
    end

    % Assign results

    summary_table.Classification(isUrban) = "Urban";

    % 5. Graphing
    figure
    urbanIdx = (summary_table.Classification == "Urban");

    % Scatter plot: Urban points in Red, Rural in Blue
    geoscatter(summary_table.CENTLAT(urbanIdx), summary_table.CENTLON(urbanIdx), ...
        'r', 'filled', 'DisplayName', 'Urban')
    hold on
    geoscatter(summary_table.CENTLAT(~urbanIdx), summary_table.CENTLON(~urbanIdx), ...
        'b', 'filled', 'DisplayName', 'Rural')

    geobasemap streets
    legend
    title('Kansas Patient Distribution: Urban vs Rural')

    % Output the final table
    updated_census_and_demographic_table = summary_table;

end

