create or replace PROCEDURE LIST_DOC
(
   STR_DATE IN DATE,
   END_DATE IN DATE,
   OUTPUT_LIST_DOC OUT DOC_TABLE
)
IS
BEGIN
        OUTPUT_LIST_DOC := DOC_TABLE();
        FOR OBJ IN  (
                                SELECT EID_DOC,EFNAME || ' ' || ELNAME AS EFNAME,NO_PATIENT FROM                 
                                    (
                                    SELECT B.EID_DOC,NVL(NO_PATIENT, 0) AS NO_PATIENT FROM
                              (SELECT EID_DOC,COUNT(PID) AS NO_PATIENT
                                FROM 
                                    ((SELECT EID_DOC,PID_OUT AS PID,NULL AS TRSTART,NULL AS TREND,EXDATE,EXSECONDEXAMINATIONDATE FROM EXAMINATION)
                                    UNION
                                    (SELECT EID_DOC,PID_IN AS PID,TRSTART,TREND,NULL AS EXDATE,NULL AS EXSECONDEXAMINATIONDATE FROM TREATMENT))
                                     WHERE 
                                    (
                                        ((TRSTART >= STR_DATE) AND (TRSTART <= END_DATE))
                                        OR  ((TREND >= STR_DATE) AND (TREND <= END_DATE))
                                        OR  ((EXDATE >= STR_DATE) AND (EXDATE <= END_DATE))
                                        OR  ((EXSECONDEXAMINATIONDATE >= STR_DATE) AND (EXSECONDEXAMINATIONDATE <= END_DATE))
                                    )
                                GROUP BY
                                    EID_DOC
                                 
                                    ) A
                                    RIGHT OUTER JOIN 
                                     (SELECT EID_DOC FROM DOCTOR) B 
                                     ON B.EID_DOC = A.EID_DOC
                                     ) C
                                     JOIN EMPLOYEE
                                     ON EID_DOC = EID
                                     ORDER BY
                                        NO_PATIENT ASC
                            )
        LOOP
            OUTPUT_LIST_DOC.extend;
            OUTPUT_LIST_DOC(OUTPUT_LIST_DOC.count) := DOC_TYPE(OBJ.EID_DOC,OBJ.EFNAME,OBJ.NO_PATIENT);
        END LOOP;
END;