create or replace function exist(PatientID in char)
return number is checkExist number;
begin
select count(*) into checkExist from Inpatient where patientID = inpatient.PID_IN;
return checkExist;
end exist;