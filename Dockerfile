FROM ubuntu:22.04

RUN sed -ri.bak -e 's/\/\/.*?(archive.ubuntu.com|mirrors.*?)\/ubuntu/\/\/mirrors.pku.edu.cn\/ubuntu/g' -e '/security.ubuntu.com\/ubuntu/d' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
# 常用环境和工具
    qemu-system  gdb \ 
    git xz-utils bzip2 wget file net-tools \
# 用于编译过程
    flex bison make bmake gcc g++ clang-14 lld-14\
    build-essential libncurses-dev libarchive-dev\
    libelf-dev bc libssl-dev \
# 用于源码阅读
	clangd bear

RUN mkdir /root/source && \
    mkdir /root/tools && \
    mkdir /root/temp

COPY asserts/* /root/temp

# 其实拷贝压缩包多了个 overlay, 但是影响很小，放在这还方便改
RUN tar xf /root/temp/linux-*.tar.xz -C /root/source/ && \
    tar xJf /root/temp/freebsd-*.txz -C /root/source/ && \
    tar xjf /root/temp/busybox-*.tar.bz2 -C /root/tools && \
    mv /root/temp/freebsd_make.sh /root/source/usr/ && \
    mv /root/temp/freebsd_run.sh /root/source/usr/ && \
    mv /root/temp/linux_make.sh /root/source/linux-6.4.12/ && \
    mv /root/source/usr /root/source/freebsd && \
    rm -rf /root/temp

WORKDIR /root/source