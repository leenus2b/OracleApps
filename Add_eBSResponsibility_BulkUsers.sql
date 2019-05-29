SET serveroutput ON;
DECLARE
  CURSOR lc_users
  IS
    SELECT * FROM apps.fnd_user WHERE user_name BETWEEN 'TEST001' AND 'TEST240';
    /* If You need specific users, add them to TMP Table and call from proc */
  lc_resp_appl_short_name1 VARCHAR2(100) := 'SYSADMIN';
  lc_responsibility_key1   VARCHAR2(100) := 'SYSTEM_ADMINISTRATOR';
  lc_security_group_key1   VARCHAR2(100) := 'STANDARD';
/*lc_resp_appl_short_name2 VARCHAR2(100) := 'XXCUST';
  lc_responsibility_key2   VARCHAR2(100) := '<RESP_SHORT_NAME>';
  lc_security_group_key2   VARCHAR2(100) := '<RESP_SEC_GROUP>';
  lc_resp_appl_short_name3      VARCHAR2(100)      := 'SYSADMIN';
  lc_responsibility_key3          VARCHAR2(100)      := 'SYSTEM_ADMINISTRATOR';
  lc_security_group_key3          VARCHAR2(100)      := 'STANDARD'; */
  ld_resp_start_date DATE := sysdate;
  ld_resp_end_date   DATE := NULL;
BEGIN
  FOR REC IN lc_users
  LOOP
    DBMS_OUTPUT.PUT_LINE(' User : '||rec.user_name);
    fnd_user_pkg.addresp ( username => rec.user_name, resp_app => lc_resp_appl_short_name1, resp_key => lc_responsibility_key1, security_group => lc_security_group_key1, description => NULL, start_date => ld_resp_start_date, end_date => ld_resp_end_date );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Responsiblity : '|| lc_responsibility_key1||' is added for User : '||rec.user_name);
--    fnd_user_pkg.addresp ( username => rec.user_name, resp_app => lc_resp_appl_short_name2, resp_key => lc_responsibility_key2, security_group => lc_security_group_key2, description => NULL, start_date => ld_resp_start_date, end_date => ld_resp_end_date );
--    COMMIT;
--    DBMS_OUTPUT.PUT_LINE('Responsiblity : '|| lc_responsibility_key2||' is added for User : '||rec.user_name);
    /*fnd_user_pkg.addresp
    (   username             => rec.user_name,
    resp_app             => lc_resp_appl_short_name1,
    resp_key             => lc_responsibility_key1,
    security_group       => lc_security_group_key1,
    description          => NULL,
    start_date           => ld_resp_start_date,
    end_date             => ld_resp_end_date
    );
    COMMIT;*/
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE(SQLERRM ||' at '||dbms_utility.format_error_backtrace);
END;
/
SHOW ERROR;
