function subtable = load_social_determinants()
    datatable = readtable("tigercensuscodes.csv");
    num_points = 500;
    subtable = zeros(num_points, 3);
    subtable(:, 1) = datatable.CENTLAT(1:num_points, :);
    subtable(:, 2) = datatable.CENTLON(1:num_points, :);
    subtable(:, 3) = datatable.PopulationValue(1:num_points, :);
    % lats = [40.0032; 36.9930; 36.9930; 40.0032; 40.0032];
    % lons = [-102.052; -102.052; -94.584; -94.584; -102.052];
    geoscatter(subtable(:, 1),  subtable(:,2), subtable(:,3))
end 

clear
clf
load_social_determinants()
%% 
function transportation()
    datatable = readtable('patients.csv');

end 