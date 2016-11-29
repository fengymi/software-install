#!/bin/bash

#FastDFS安装
# FastDFS v5.08
# FastDFS_v5.08.tar.gz
# libfastcommon-master.zip（是从 FastDFS 和 FastDHT 中提取出来的公共 C 函数库）
                                                # 源 码 地址 ： https://github.com/happyfish100/
# fastdfs-nginx-module_v1.16.tar.gz				# 下载 地址： http://sourceforge.net/projects/fastdfs/files/
# nginx- - 1.6.2.tar.gz							# 官方论坛 ： http://bbs.chinaunix.net/forum
# fastdfs_client_java._v1.25.tar.gz
# 由跟踪器上传下载文件到存储器中
										
#(1) 安装编译环境
    yum install make cmake gcc gcc-c++ unzip
#(2) 安装libfastcommon
#        unzip libfastcommon-master.zip
#        编译 ./make.sh
#        安装 ./make.sh install
#        # libfastcommon 默认安装到了
#        # /usr/lib64/libfastcommon.so
#        # /usr/lib64/libfdfsclient.so
    unzip libfastcommon-master.zip
    cd libfastcommon-master
    ./make.sh && ./make.sh install
#(3) 在/usr/local/lib,usr/lib/libfastcommon(如果没有) 下创建和 /usr/lib64/libfastcommon.so 的软连接 (libfdfsclient.so一样操作)
#        ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
    ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
    ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so

#(4) 安装FastDFS v5.08
#        编译 ./make.sh
#        安装 ./make.sh install
#        # 可以看到安装目录
#        #
#        # 命令工具命令(/usr/bin/fdfs_*,stop.sh,restart.sh)
#        # 服务脚本 (/etc/init.d/fdfs_storage 和 /etc/init.d/fdfs_tracker)
#        # 配置文件的路径(/etc/fdfs/*.conf.sample)
#        注意 有的版本(该版本没问题)实际安装脚本在/usr/bin目录，但是服务脚本却是/usr/local/bin,所以我们需要修改 fdfs_storage和fdfs_tracker 服务脚本中的路径
#        批量替换命令 %s+/usr/local/bin+/usr/bin
    tar -zxvf FastDFS_v5.08.tar.gz
    cd FastDFS
    ./make.sh && ./make.sh install

#(5) 配置跟踪器(tracker) 默认端口 22122
#     # 官方配置说明 http://bbs.chinaunix.net/thread-1941456-1-1.html
#     cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
#     vim tracker.conf
#         disabled=false (false表示生效，true不生效)
#         port=22122 (端口)
#         base_path= (自己定义存储目录/tracker,如果不存在记得创建)
#     开启防火墙相应的端口
#     启动: /usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf
#     停止: /usr/bin/stop.sh /etc/fdfs/tracker.conf
#     设置开机启动 注册为服务或者直接在/etc/rc.local加执行命令
#     log 在相应的base_path目录

#(6) 配置存储器(storage) 默认端口 23000
#     cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
#     vim storage.conf
#         disabled=false (false表示生效，true不生效)
#         port=23000 (端口)
#         base_path= (自己定义存储目录/storage,如果不存在记得创建)  ====> 放置data和log的目录
#         store_path0= (自己定义存储目录/storage,如果不存在记得创建,如果不配置和base_path相同) ====> 放置文件的目录
#         tracker_server=192.168.68.142:22122 (跟踪器地址,多个直接加一行一样的)
#         http.server_port=8888 (http的服务端口，和nginx端口保持一致)
#     开启防火墙相应的端口
#     启动: /usr/bin/fdfs_storaged /etc/fdfs/storage.conf
#     停止: /usr/bin/stop.sh /etc/fdfs/storage.conf
#     设置开机启动 注册为服务或者直接在/etc/rc.local加执行命令
#     log 在相应的base_path目录

#(7) 配置跟踪器服务器上的客户端信息
#     cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf
#     vim client.conf
#     base_path=/fastdfs/tracker
#     tracker_server=192.168.68.142:22122

#(8) 测试使用fdfs_upload_file命令上传文件
#        fdfs_upload_file client.conf 要上传的文件
#        /usr/bin/fdfs_upload_file /etc/fdfs/client.conf /usr/local/src/FastDFS_v5.08.tar.gz
#        返回group1/M00/00/00/wKhEjFfGS1eAAU8aAAAFOpPo-ic397.tar.gz
#
