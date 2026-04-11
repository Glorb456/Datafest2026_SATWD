%% Test_code 

%% Look for patterns between physical abuse and visitations

%reading the social_determinants table
dataset = readtable("social_determinants.csv");

questions = dataset.DisplayName;
answers = dataset.AnswerText;

question1 = "Within the last year, have you been afraid of your partner or ex-partner?";
question2 = "Within the last year, have you been humiliated or emotionally abused in other ways by your partner or ex-partner?";
question3 = "Within the last year, have you been kicked, hit, slapped, or otherwise physically hurt by your partner or ex-partner?";
question4 = "Within the last year, have you been raped or forced to have any kind of sexual activity by your partner or ex-partner?";

indices_question1 = find(questions == question1);
indices_question2 = find(questions == question2);
indices_question3 = find(questions == question3);
indices_question4 = find(questions == question4);

% Extract answers corresponding to the identified questions
answers_question1 = answers(indices_question1);
answers_question2 = answers(indices_question2);
answers_question3 = answers(indices_question3);
answers_question4 = answers(indices_question4);

indices_yes1 = find(answers_question1 == "Yes");
%% Mapping the different areas where the different types of care are

departments_data = readtable("departments.csv");

departments_label = departments_data.DepartmentName;
census_data = departments_data.CensusTract;
zipcodes = departments_data.PostalCode;

