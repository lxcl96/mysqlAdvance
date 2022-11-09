### 1、显示当前数据库的所有配置（如引擎，日期格式等等）

```sql
show variables; #5.5版本共329个配置
```

<img src='img\image-20221109144513227.png'>



### 2、单独查询数据库配置信息

==*这里的列名就是上面329个系统配置中的*==

+ `show variables like '列名'` （可以模糊查询）
+ `select @@列名 `（不能模糊查询）

```sql
show variables like 'version'; -- 等同于 select @@version
show variables like 'auto_increment_increment'; -- 等同于 select @@auto_increment_increment
```



### 3、列出所有数据库

```sql
show databases;
use mysql;
```

### 4、mysql用户管理

```sql
-- 创建用户不设置密码
create user xxx;
-- 创建用户并给密码
create user xxx identified by xxxx;
-- 查询当前mysql用户 ,user表在mysql这个库中 (包括后续的密码修改，主机访问都是这个表)
select * from mysql.user;
-- 设置当前用户的密码
set password=password('xxxxx');
-- 删除用户 B不要通过delete from mysql.user where user='xx';这样会有残留信息（删的只是这一个表）
drop user xxx; # 用户信息不仅仅是user一张表

```

<img src='img\image-20221109150230635.png'>

### 5、权限管理

```sql
-- 给某个地址的用户授予某个库的某些表的xxx权限
grant select,insert,delete,drop ... 权限 on 数据库名.表名 to 用户名@'用户地址' identified by 密码;
-- 授予所有数据库，所有表的，所有权限 [with grant option]为权限传递，表示被授权的用户可以给别的用户授权（否则是不允许的）
grant all privileges on *.* to 用户@'%' identified by 密码 with grant option;

-- 查看当前用户的权限
show grants;
-- 查看所有用户的权限
select * from mysql.user;


-- 收回指定用户的指定库，表的的指定权限
revoke 权限1 [...] on 库名.表名 from 用户名@'用户地址';
-- 收回全库全表的权限
revoke all privileges on *.* from 用户@'用户地址';

-- 授权，收回授权 必须刷新才能生效
flush privileges;
```

### 6、union合并加上去重，union all 合并但是不去重
