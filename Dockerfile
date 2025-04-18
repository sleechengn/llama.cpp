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

run mkdir /opt/filebrowser \
	&& cd /opt/filebrowser	\
	&& aria2c -x 10 -j 10 -k 1M "https://github.com/filebrowser/filebrowser/releases/download/v2.32.0/linux-amd64-filebrowser.tar.gz" -o linux-amd64-filebrowser.tar.gz \
	&& tar -zxvf linux-amd64-filebrowser.tar.gz \
	&& rm -rf linux-amd64-filebrowser.tar.gz \
	&& ln -s /opt/filebrowser/filebrowser /usr/bin/filebrowser

run apt update \
	&&  apt install -y nginx ttyd \
	&& rm -rf /etc/nginx/sites-enabled/default
add ./NGINX /etc/nginx/sites-enabled/

run set -e && echo install source \
        && echo install source && apt install -y aria2 gcc make \
        && echo install source && cd /opt \
        && echo install source && aria2c --max-connection-per-server=10 --min-split-size=1M --max-concurrent-downloads=8 https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda_12.6.3_560.35.05_linux.run  \
        && echo install source && chmod +x cuda_12.6.3_560.35.05_linux.run \
        && echo install source && ./cuda_12.6.3_560.35.05_linux.run --silent --toolkit \
        && echo install source && rm -rf cuda_12.6.3_560.35.05_linux.run

#CUDA-INSTALL

run set -e \
	&& ln -s /usr/local/cuda-12.6/bin/nvcc /usr/bin/nvcc


env CUDA_HOME=/usr/local/cuda-12.6

run set -e \
        && apt install -y unzip libgomp1 git gcc make cmake g++ \
        && cd /opt \
	&& git clone https://github.com/ggml-org/llama.cpp.git llamacpp \
	&& cd /opt/llamacpp \
	&& export PATH=/usr/local/cuda-12.6/bin:$PATH \
	&& export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64:$LD_LIBRARY_PATH \
	&& cmake -B build -DGGML_CUDA=ON \
	&& cmake --build build --config Release

copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd ["/docker-entrypoint.sh"]
