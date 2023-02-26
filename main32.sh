# Add dependent repositories
sudo dpkg --add-architecture i386
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports

# Clone Upstream
git clone https://github.com/FFmpeg/FFmpeg -b release/5.1
cp -rvf ./debian ./FFmpeg
mv ./FFmpeg ./ffmpeg5
cd ./ffmpeg5

# Get build deps
apt-get install crossbuild-essential-i386 build-essential gcc-multilib g++-multilib lib32gcc-11-dev
apt-get build-dep ./ -y -a i386
apt-get install -y cleancss node-less

# Build package
LOGNAME=root dh_make --createorig -y -l -p ffmpeg5_5.1.3
dpkg-buildpackage -a i386

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
