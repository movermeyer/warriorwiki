apt-get install build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool pkg-config
mkdir s3_compilation
cd s3_compilation
wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.78.tar.gz
tar xvfz *.tar.gz
cd s3fs-fuse*
./autogen.sh
./configure --prefix=/usr --with-openssl
make
sudo make install