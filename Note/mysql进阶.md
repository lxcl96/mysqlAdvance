# 1、MySQL简介

## 1.1、什么是mysql

见pdf

## 1.2、MySQL高手是怎么练成的

见pdf

## 1.3、Linux下安装MySQL

### 1.3.1、准备工作

#### 1.3.1.1、检查当前系统是否已经安装过 Mysql

```sh
# centos 7
rpm -qa|grep mariadb # 查看是否安装
rpm -e --nodeps mariadb-libs # 卸载
```

<img src='img\image-20221108131331081.png'>

默认 Linux（CentOS7）在安装的时候，自带了 mariadb(mysql 完全开源版本)相关的组件。 先卸载系统自带的 mariadb，执行卸载命令 `rpm -e --nodeps mariadb-libs`.

#### 1.3.1.2、给`/tmp`目录足够的权限

```sh
ll / # 查看根目录/tmp的读写权限 
# 如果不是全部权限 drwxrwxdrwx
chmod 777 /tmp
```

### 1.3.2、MySQL的安装

因为安装的为旧版本的MySQL，rpm包不好找，直接利用`wget`在线下载rpm安装包。

```sh
# 安装wget
yum install wget
# 下载MySQL5.5的服务端rpm
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-server-5.5.54-1.linux2.6.x86_64.rpm
# 下载MySQL5.5的客户端rpm
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-client-5.5.54-1.linux2.6.x86_64.rpm
```

+ 将下载好的`mysql-server`和`mysql-client`移动到`/opt`目录下

  > 第三方软件统一放在这个包下

+ 在`/opt`目录下安装 

  ```sh
  # -i 安装 -v显示详细信息(安装日志) -h hash进度条最好和-v一起
  rpm -ivh MySQL-server-5.5.54-1.linux2.6.x86_64.rpm 
  rpm -ivh MySQL-client-5.5.54-1.linux2.6.x86_64.rpm 
  ```

+ 查看mysql安装时创建的用户组

  > + **查看mysql创建的用户组来检验是否安装成功**
  >
  >   mysql安装时会在Linux上创建属于自己的用户和用户组
  >
  >   <img src='img\image-20221108134303599.png'>
  >
  > + **或者使用命令`mysqladmin -version`查看安装是否成功**
  >
  >   <img src='img\image-20221108134454268.png'>

+ 设置mysql的用户和密码(必须先启动mysql服务)

  ```
  mysqladmin -u root password 1024
  ```

### 1.3.3、MySQL服务

#### 1.3.3.1、mysql服务的启停

+ 使用`service`命令

  ```sh
  service mysql start
  service mysql stop
  ```

+ 使用`systemctl`命令

  ```sh
  systemctl start mysql
  systemctl stop mysql
  ```

#### 1.3.3.2、mysql的安装位置

可以通过命令`ps-ef|grep mysql`查看到数据库的存放位置

<img src='img\image-20221108141714747.png' style='zoom:100%'>

<img src='img\image-20221108141935515.png'>

<img src='img\image-20221108142123992.png'>

> **information_schema默认时看不到的，最底层的。里面存放mysql最底层的数据**
>
> windows下：
>
> <img src='img\image-20221108142258828.png'>

| 参数           | 路径                        | 解释                         | 备注                          |
| -------------- | --------------------------- | ---------------------------- | ----------------------------- |
| `--datadir`    | `/var/lib/mysql/`           | mysql中所有的数据库存放位置  | 还有进程pid，错误日志         |
| `--basedir`    | `/usr/bin`                  | mysql的所有命令              | 如`mysqladmin`，`mysqldump`等 |
| `--plugin-dir` | `/usr/lib64/mysql/plugin`   | mysql插件存放路径            |                               |
| `--log-error`  | `/var/lib/mysql/主机名.err` | mysql错误日志路径            |                               |
| `--pid-file`   | `/var/lib/mysql/主机名.pid` | 进程pid文件                  |                               |
| `--socket`     | `/var lib/mysql/mysql.sock` | 本地连接时用的unix套接字文件 |                               |
|                | `/usr/share/mysql`          | 配置文件目录                 | mysql脚本及配置文件           |
|                | `/etc/init.d/mysql`         | 服务启停相关脚本             |                               |



#### 1.3.3.3、mysql服务的自启动

<img src='img\image-20221108140754952.png'>

或者使用命令：`ntsysv`进行启停

<img src='img\image-20221108141135458.png'>

#### 1.3.3.1、mysql服务的重复启动

如果当前已经有mysql服务启动，再次去启动mysql则会一直卡死在启动中

<img src='img\image-20221108144729389.png'>

此时可以通过命令，查看到后台多了很多mysql服务的进程。

此时，尝试去登陆或者操作就会报错！

<img src='img\image-20221108144849713.png'>

***解决方法：杀死所有的mysql服务和mysqld的服务，然后重启***

<img src='img\image-20221108144957593.png'>

### 1.3.4、修改字符集

+ 5.5默认的mysql配置文件为：`/usr/share/mysql/my-huge.cnf`
+ 5.6默认的mysql配置文件为：`/usr/share/mysql/my-default.cnf`
+ 5.7默认的mysql配置文件为：`/etc/my.cnf`

修改配置文件之前一定要先备份一份，所以我们将要修改的配置文件拷贝一份放到`/etc/my.cnf`

```sh
cp /usr/share/mysql/my-huge.cnf /etc/my.cnf
```

#### 1.3.4.1、常用命令

<img src='img\image-20221108152248206.png'>

#### 1.3.4.2、字符集乱码原因

mysql默认的数据库字符集为latin1，是不包含中文字符的。所以建表时一定要指定字符集`charset=utf8`

<img src='img\image-20221108152446104.png'>

#### 1.3.4.3、修改默认字符集

mysql服务启动默认会去找`/etc/my.cnf`配置文件（windows下默认为my.ini），如果没有就会使用默认的`/usr/lib/mysql/my-huge.cnf`。

<img src='img\image-20221108152612355.png'>

***重启mysql服务，再次查看***

```sh
service mysql stop;
service mysql start;
```

<img src='img\image-20221108153221735.png'>

### 1.3.5、设置大小写不敏感

<img src='img\image-20221108153531935.png'>

<img src='img\image-20221108153553750.png'>

### 1.3.6、sql_mode 

**默认为null，运行一些非法数据**

见pdf

## 1.4、MySQL配置文件

就是`/etc/my.cnf`的内容，以下为主要配置文件。（详情百度）

+ **二进制日志log-bin**

  主要用于主从复制，复制主机内容到从机

  ```sh
  # my.cnf
  # Replication Master Server (default)
  # binary logging is required for replication
  log-bin=mysql-bin
  ```

+ **错误日志log-error**

  设置mysql的错误日志

+ **查询日志log**

  记录查询的sq语句，默认关闭

+ **数据文件**

  > + mysql中数据库默认存放位置
  >
  >   > + windows中：默认是和mysql/bin同级别的data目录下
  >   > + linux中：默认在 var/lib/mysql
  >
  > + **frm文件** <font color='red'> 为数据库中所有表的对应结构（INNODB/MyISAM引擎）</font>
  >
  > + **myd文件**  <font color='red'>为数据库中所以表的对应数据（MyISAM引擎）</font>
  >
  > + **myi文件**  <font color='red'>为数据库中所以表的对应数据索引（MyISAM引擎）</font>
  >
  > + **ibd文件** <font color='red'>表数据和索引的文件</font>
  >
  > <img src='img\image-20221108155652837.png'>

+ **如何配置**

  > * Linux下为**my.cnf**
  > * Windows下为**my.ini**

## 1.5、开放ip访问mysql

```sh
# *.* 表示所有数据库的所有表，给root用户，ip地址为任意 ，莫玛为1024
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '1024' WITH GRANT OPTION;
flush privileges;
```

# 2、MySQL的用户和权限管理

见pdf

<img src='img\image-20221109152202349.png'>

<img src='img\image-20221109152228028.png'>

# 3、MySQL逻辑架构简介

和其他数据库相比，MySQL有点与众不同，它的架构可以在多种不同场景中应用并发挥良好作用。主要体现在存储引擎的架构上，<font color='red'>**插件式的存储引擎架构将查询处理和其他的系统任务、数据的存储读取想分离**</font>。这架构可以根据业务的需求和实际需要选择合适的存储引擎。

## <img src='img\image-20221108162922024.png'>3.1、连接层

**即图中的Connector**

最上层是一些客户端和连接服务，包含本地sock通信和大多数基于客户端/服务器端工具实现的类似于tcp/ip的通信。主要完成一些类似于连接处理、授权认证及相关的安全方案。

在该层上引入了线程池的概念，为通过认证安全接入的客户端提供线程。同样在该层上可以实现基于SSL的安全链接。服务器也会为安全接入的每个客户端验证它所具有的操作权限。

## 3.2、服务层

+ **`Management Services & Utilities`** :系统管理和控制工具

  > 如备份、恢复、安全、复制、集群、迁移等等	

+ **`SQL Interface`** :SQL接口，接受用户的SQL命令，并返回用户需要的查询结果。

  > 如：`select * from xxx`就是调用的SQL Interface
  >
  > 主要为：DDL，DML，存储过程，触发器，视图等

+ **`Parser`** :解析器。SQL命令传递到解析器的时候会被解析器验证和解析

  > 如：查询语句的翻译，对象优先级等

+ **`Optimizer`** :查询优化器。SQL语句在查询之前会使用查询优化器对查询进行优化

  > 比如有where条件时，优化器会决定先投影还是先过滤

+ **`Cache and Buffer`** :查询缓存。如果查询缓存有命中的查询结果，查询语句就可以直接去查询缓存中取数据。这个缓存机制是由一系列小缓存组成的。

  > 比如：表缓存，记录缓存，key缓存，权限缓存等。

## 3.3、引擎层

存储引擎层，存储引擎真正的负责了MySQL中数据的存储和读取，服务通过API与存储引擎进行通信。不同的存储引擎具有的功能不同，这样我们可以根据自己的实际业务进行选择。

比较常用的存储引擎：INNODB和MYISAM

<img src='img\image-20221109152428324.png'>

## 3.4、存储层

数据存储层，主要是将数据存储在运行于裸设备的文件系统之上，并完成与存储引擎的交互。

4、