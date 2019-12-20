SELECT r.responsibility_name
  FROM fnd_responsibility_vl r, fnd_form_functions f
 WHERE f.function_name = '&function_short_name'
   AND r.menu_id IN (SELECT     me.menu_id
                           FROM fnd_menu_entries me
                     START WITH me.function_id = f.function_id
                     CONNECT BY PRIOR me.menu_id = me.sub_menu_id)
   AND r.menu_id NOT IN (
                       SELECT frf.action_id
                         FROM fnd_resp_functions frf
                        WHERE frf.action_id = r.menu_id
                              AND frf.rule_type = 'M')
   AND f.function_id NOT IN (
                   SELECT frf.action_id
                     FROM fnd_resp_functions frf
                    WHERE frf.action_id = f.function_id
                          AND frf.rule_type = 'F');
