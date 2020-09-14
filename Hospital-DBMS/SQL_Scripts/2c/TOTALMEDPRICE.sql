create or replace FUNCTION TotalMedPrice
(PatientID in CHAR) RETURN TableForFunction
is OutTable TableForFunction;
begin

if (exist(patientID) > 0) then
    select cast(
        Multiset(
            select trid, sum(mprice)
            from uses_treat join medication on uses_treat.mid = medication.mid
            where patientID = uses_treat.PID_IN
            group by trid)
            as TableForFunction)
        into outtable
    from dual;
else
    select cast(
        Multiset(
            select exid,sum(mprice)
            from uses_exam join medication on uses_exam.mid = medication.mid
            where patientID = uses_exam.PID_OUT
            group by exid)
            as TableForFunction)
        into outtable
    from dual;
end if;

return OutTable;
end TotalMedPrice;