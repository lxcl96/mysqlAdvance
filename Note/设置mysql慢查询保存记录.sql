-- ��ѯmysql�Ƿ�������ѯ
show variables like 'slow_query_log';
-- �鿴��ǰ���ݿ⣬����ѯ��sql����
show status like '%Slow_queries%';
--  ��ѯmysql����ѯ��ʱ������
show VARIABLES like 'long_query_time';
-- ��������ѯ
set global slow_query_log=ON;
-- ��������ѯʱ�䣨��λ�룩,����������Ч����Ҫ�������ݿ�
set global long_query_time=1;
-- ��������ѯ��־����λ��
set global slow_query_log_file='Dmysql5.6querySlowLogslowQuery.log';

-- �鿴�Ƿ�ʹ���������������ļ���
explain select  from `slow_log` where start_time  '20221024 000000';

-- ������������ʧЧ����������Խ����еĲ�ѯ��������Ϊһ������
alter  table  ����  add  index  ������(index_name)  (����1������2.......);
