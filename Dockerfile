from ubuntu:jammy

#APT-PLACE-HOLDER

run apt update \
	&& apt install -y curl aria2 \
	&& apt clean

run set -e \
	&& mkdir /opt/uv \
	&& cd /opt/uv \
	&& aria2c -x 10 -j 10 -k 1M "https://github.com/astral-sh/uv/releases/download/0.6.14/uv-x86_64-unknown-linux-gnu.tar.gz" -o "uv.tar.gz" \
	&& tar -zxvf uv.tar.gz \
	&& rm -rf uv.tar.gz \
	&& ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uv /usr/bin/uv \
	&& ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uvx /usr/bin/uvx

run set -e \
	&& apt install -y unzip libgomp1 \
	&& mkdir /opt/llamacpp \
	&& cd /opt/llamacpp \
	&& aria2c -x 10 -j 10 -k 1M "https://github.com/ggml-org/llama.cpp/releases/download/b5121/llama-b5121-bin-ubuntu-x64.zip" \
	&& unzip llama-b5121-bin-ubuntu-x64.zip \
	&& rm -rf llama-b5121-bin-ubuntu-x64.zip \
	&& ln -s /opt/llamacpp/build/bin/llama-cli /usr/bin/llama-cli \
	&& ln -s /opt/llamacpp/build/bin/llama-server /usr/bin/llama-server \
	&& ln -s /opt/llamacpp/build/bin/llama-run /usr/bin/llama-run \
	&& mv /opt/llamacpp/build/bin/*.so /usr/lib

run mkdir /opt/filebrowser \
	&& cd /opt/filebrowser	\
	&& aria2c -x 10 -j 10 -k 1M "https://github.com/filebrowser/filebrowser/releases/download/v2.32.0/linux-amd64-filebrowser.tar.gz" -o linux-amd64-filebrowser.tar.gz \
	&& tar -zxvf linux-amd64-filebrowser.tar.gz \
	&& rm -rf linux-amd64-filebrowser.tar.gz \
	&& ln -s /opt/filebrowser/filebrowser /usr/bin/filebrowser

RUN apt update
RUN apt install -y nginx ttyd
RUN rm -rf /etc/nginx/sites-enabled/default
ADD ./NGINX /etc/nginx/sites-enabled/

run set -e && echo install source \
        && echo install source && apt install -y aria2 gcc make \
        && echo install source && cd /opt \
        && echo install source && aria2c --max-connection-per-server=10 --min-split-size=1M --max-concurrent-downloads=8 https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda_12.6.3_560.35.05_linux.run  \
        && echo install source && chmod +x cuda_12.6.3_560.35.05_linux.run \
        && echo install source && ./cuda_12.6.3_560.35.05_linux.run --silent --toolkit \
        && echo install source && rm -rf cuda_12.6.3_560.35.05_linux.run
#CUDA-INSTALL
env CUDA_HOME=/usr/local/cuda-12.6


copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd ["/docker-entrypoint.sh"]
