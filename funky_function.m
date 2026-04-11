function subtable = load_social_determinants()
    datatable = readtable("C:\Users\kulka\Documents\Datafest\2026-ASA-DataFest-Data-Files-20260410T234240Z-3-001\2026-ASA-DataFest-Data-Files\tigercensuscodes.csv");
    num_points = 1000;
    subtable = zeros(num_points, 2);
    subtable(:, 1) = datatable.CENTLAT(1:num_points, :);
    subtable(:, 2) = datatable.CENTLON(1:num_points, :);
    lats = [40.0032; 36.9930; 36.9930; 40.0032; 40.0032];
    lons = [-102.052; -102.052; -94.584; -94.584; -102.052];
    figure;
    hold on
    plot(subtable(:, 1), subtable(:,2), 'o')
    plot(lats, lons)
    hold off
end 

clear
clf
load_social_determinants()