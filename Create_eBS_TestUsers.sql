SET serveroutput ON;
DECLARE
 v_new_password VARCHAR2(30):= 'Welcome123';
  v_status       BOOLEAN;
  TYPE t_users IS VARRAY(60) OF VARCHAR2(20);
  t_list_users t_users := t_users('TEST250','TEST251','TEST252','TEST253');
BEGIN
FOR i IN t_list_users.FIRST .. t_list_users.LAST
LOOP
  v_status   := fnd_user_pkg.ChangePassword ( username => t_list_users(i), 
                                              newpassword => v_new_password 
                                            );
  IF v_status  THEN
    dbms_output.put_line ('The password reset successfully for the User:'||t_list_users(i));
    COMMIT;
  ELSE
    DBMS_OUTPUT.put_line ('Unable to reset password due to'||SQLCODE||' '||SUBSTR(SQLERRM, 1, 100));
    ROLLBACK;
  END IF;
  END LOOP;
END;
/
