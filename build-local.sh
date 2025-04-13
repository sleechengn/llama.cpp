#!/usr/bin/bash
set -e


mkdir -p /opt/tmp
rm -rf /opt/tmp/llama.cpp-build
cp -r . /opt/tmp/llama.cpp-build
pushd /opt/tmp/llama.cpp-build

sed -i '1i\# syntax=docker/dockerfile:1.3' Dockerfile

sed -i "/^#APT-PLACE-HOLDER.*/i\RUN apt update" Dockerfile
sed -i "/^#APT-PLACE-HOLDER.*/i\RUN apt install -y ca-certificates" Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN mv /etc/apt/sources.list /etc/apt/sources.list.back' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN apt update' Dockerfile

sed -i 's,git clone https\:\/\/github\.com\/[^\/]*,git clone http://192.168.13.80:3000/sleechengn,g' Dockerfile

sed -i '/.*echo\sinstall\ssource.*/d' Dockerfile
sed -i '/^#CUDA-INSTALL.*/i\run --mount=type=bind,target=/root/.source,rw,source=.source set -e && apt install -y aria2 gcc make && chmod +x /root/.source/cuda_12.6.3_560.35.05_linux.run && /root/.source/cuda_12.6.3_560.35.05_linux.run --silent --toolkit' Dockerfile

./build.sh 192.168.13.73:5000/sleechengn/llama.cpp:latest
docker push 192.168.13.73:5000/sleechengn/llama.cpp:latest

popd
