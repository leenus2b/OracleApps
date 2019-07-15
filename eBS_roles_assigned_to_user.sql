select DISTINCT user_name,ASSIGNING_ROLE, b.display_name, a.end_date from APPLSYS.WF_USER_ROLE_ASSIGNMENTS a , apps.wf_roles b
where a.ROLE_ORIG_SYSTEM='UMX'
and a.ASSIGNING_ROLE=b.name
--and a.ASSIGNING_ROLE like '%'
--and DISPLAY_NAME like 'MG FTW Warehouse Manager%'
--and NVL(a.end_date, SYSDATE+1) < SYSDATE
and  a.user_name in 
('&USER_NAME'); 

--
-- Comparing responsibilities between 2 users
-- Also, identifying the roles one user has and other user hasn't
--

select DISTINCT ASSIGNING_ROLE, b.display_name from APPLSYS.WF_USER_ROLE_ASSIGNMENTS a , apps.wf_roles b
where a.user_name='&USER_1' and a.ROLE_ORIG_SYSTEM='UMX'
and a.ASSIGNING_ROLE=b.name
minus
select DISTINCT ASSIGNING_ROLE, b.display_name from APPLSYS.WF_USER_ROLE_ASSIGNMENTS a , apps.wf_roles b
where a.user_name='&USER_2' and a.ROLE_ORIG_SYSTEM='UMX'
and a.ASSIGNING_ROLE=b.name;
