function [length_of_stay] = len_of_stay(Admit_day,Admit_hour, Admit_minute, Admit_month, Admit_year, Discharge_day, Discharge_hour, Discharge_minute, Discharge_month, Discharge_year )

%{
    Function gives the length of stay of the patients

    inputs: 
        Admit_day - Admit_year: info about the patients admitance
        Discharge_day - Discharge_year: info about the patients discharge

    outputs:
        length_of_stay: gives the legth of stay of patient (days)
    
%}
    % Finding the distance between discharge and admit
    admitDateTime = datetime(Admit_year, Admit_month, Admit_day, Admit_hour, Admit_minute, 0);
    dischargeDateTime = datetime(Discharge_year, Discharge_month, Discharge_day, Discharge_hour, Discharge_minute, 0);
    length_of_stay = days(dischargeDateTime - admitDateTime);
end