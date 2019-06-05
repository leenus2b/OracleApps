DECLARE
	CURSOR lc_records
	IS
	SELECT fcr.request_id
	FROM apps.fnd_concurrent_requests fcr,
apps.fnd_concurrent_programs_tl fcp
	WHERE fcr.concurrent_program_id = fcp.concurrent_program_id
	AND fcp.user_concurrent_program_name like '%Check Event Alert%'
	AND fcr.phase_code='P';
	
	TYPE type_fcr_records IS TABLE OF lc_records%ROWTYPE INDEX BY BINARY_INTEGER;
	
	type_fcr_record_plt type_fcr_records;
	ln_count NUMBER :=0;

BEGIN

	OPEN lc_records;
	LOOP
		FETCH lc_records
		BULK COLLECT INTO type_fcr_record_plt
		LIMIT 10000;
		ln_count := ln_count +1;
		FOR rec in type_fcr_record_plt.FIRST..type_fcr_record_plt.LAST
		LOOP
			UPDATE fnd_concurrent_requests set phase_code ='X',status_code ='C' WHERE request_id =type_fcr_record_plt(rec).request_id;
		END LOOP;
		COMMIT;
		dbms_output.put_line('Commit SuccesFull -- '||ln_count);
		type_fcr_record_plt.DELETE;
		EXIT WHEN lc_records%NOTFOUND;
	END LOOP;
	CLOSE lc_records;
	COMMIT;

END;
/
