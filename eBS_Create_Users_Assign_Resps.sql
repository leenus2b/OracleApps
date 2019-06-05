set serveroutput on;
DECLARE
	
   CURSOR lc_users
   IS
   SELECT * FROM XXCUST.XXCUST_TEST_USERS;
   
   CURSOR lc_resp
   IS
   SELECT fa.application_short_name     lc_resp_appl_short_name
       ,fr.responsibility_key           lc_responsibility_key
	   ,'STANDARD'                      lc_security_group_key
   FROM apps.fnd_responsibility_tl      frt,
       apps.fnd_responsibility         fr,
       apps.fnd_application_tl         fat,
       apps.fnd_application            fa
   WHERE 1=1 
   AND fr.responsibility_id     =  frt.responsibility_id
   AND fa.application_id        =  fat.application_id
   AND fr.application_id        =  fat.application_id
   AND frt.language             =  USERENV('LANG')
   AND frt.responsibility_name in ('System Administrator','System Administration');
   
   lc_user_password                  VARCHAR2(100)   := 'welcome123';
   ld_user_start_date                DATE            := sysdate;
   ld_user_end_date                  VARCHAR2(100)   := NULL;
   ld_password_date                  VARCHAR2(100)   := sysdate;
   ld_password_lifespan_days         NUMBER          := 180;
   ln_person_id                      NUMBER          := 32979;
   lc_email_address                  VARCHAR2(100);
   ld_resp_start_date                DATE            :=  sysdate;
   ld_resp_end_date                  DATE            :=  NULL;

BEGIN
	FOR rec IN lc_users
	LOOP
		DBMS_OUTPUT.PUT_LINE(' User : '||rec.user_name ||' creation ');
		
		fnd_user_pkg.createuser
		(  x_user_name                            => rec.user_name,
			x_owner                               => NULL,
			x_unencrypted_password                => lc_user_password,
			x_start_date                          => ld_user_start_date,
			x_end_date                            => ld_user_end_date,
			x_password_date                       => ld_password_date,
			x_password_lifespan_days              => ld_password_lifespan_days,
			x_employee_id                         => ln_person_id,
			x_email_address                       => rec.user_name||'@averydennison.com'
		);
		
		
		COMMIT;
		
		DBMS_OUTPUT.PUT_LINE(' User : '||rec.user_name ||' is created');
		
		FOR tup IN lc_resp
		LOOP
			
			fnd_user_pkg.addresp
			(   username             => rec.user_name,
				resp_app             => tup.lc_resp_appl_short_name,
				resp_key             => tup.lc_responsibility_key,
				security_group       => tup.lc_security_group_key,
				description          => NULL,
				start_date           => ld_resp_start_date,
				end_date             => ld_resp_end_date
			);
	
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('Responsiblity : '|| tup.lc_responsibility_key||' is added for User : '||rec.user_name);
		
		END LOOP;
	END LOOP;


EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
