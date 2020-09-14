SELECT PID,PFNAME || ' ' || PLNAME AS PATIENT_NAME
FROM 

    (PATIENT 
        JOIN
    ((SELECT PID_OUT AS PID_IO,EID_DOC FROM OUTPATIENT)
        UNION
    (SELECT PID_IN AS PID_IO,EID_DOC FROM INPATIENT))
        ON
    PID = PID_IO)  
        JOIN   
    EMPLOYEE
        ON   
    EID = EID_DOC
WHERE 
    EFNAME || ' ' || ELNAME = 'Nguyen Van A'
;