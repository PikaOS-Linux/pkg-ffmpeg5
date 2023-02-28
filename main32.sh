# Add dependent repositories
sudo dpkg --add-architecture i386
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports

# Clone Upstream
git clone https://github.com/FFmpeg/FFmpeg -b release/5.1
cp -rvf ./debian ./FFmpeg
mv ./FFmpeg ./ffmpeg
cd ./ffmpeg

# Get build deps
apt-get install build-essential -y
apt-get install crossbuild-essential-i386 lib32gcc-11-dev -y
apt-get build-dep ./ -y -a i386
apt-get install -y cleancss doxygen node-less tree

# Build package
#LOGNAME=root dh_make --createorig -y -l -p ffmpeg_5.1.3
CC=i686-linux-gnu-gcc
CXX=i686-linux-gnu-g++
PATH=$PATH:/opt/ffmpeg5/usr/bin
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ffmpeg5/usr/lib/x86_64-linux-gnu:/opt/ffmpeg5/usr/lib/i386-linux-gnu
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/ffmpeg5/usr/lib/x86_64-linux-gnu/pkgconfig:/opt/ffmpeg5/usr/lib/i386-linux-gnu/pkgconfig

./configure --prefix=/opt/ffmpeg5/usr --bindir=/opt/ffmpeg5/usr/bin --datadir=/opt/ffmpeg5/usr/share/ffmpeg --docdir=/opt/ffmpeg5/usr/share/doc/ffmpeg --libdir=/opt/ffmpeg5/usr/lib/i386-linux-gnu --incdir=/opt/ffmpeg5/usr/include/i386-linux-gnu --mandir=/opt/ffmpeg5/usr/share/man --pkgconfigdir=/opt/ffmpeg5/usr/lib/i386-linux-gnu/pkgconfig --enable-rpath --extra-version="" --toolchain=hardened --arch=i386 --disable-stripping --enable-chromaprint --enable-frei0r --enable-gmp --enable-gnutls --enable-gpl --enable-ladspa --enable-libaom --enable-libaribb24 --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libdav1d --enable-libdc1394 --enable-libdrm --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libglslang --enable-libgme --enable-libgsm --enable-libiec61883 --enable-libjack --enable-libmodplug --enable-libmp3lame --enable-libmysofa --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopencore_amrnb --enable-libopencore_amrwb --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librabbitmq --enable-librist --enable-librtmp --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --enable-libsvtav1 --enable-libtesseract --enable-libtheora --enable-libtwolame --enable-libv4l2 --enable-libvidstab --enable-libvo-amrwbenc --enable-libvo_amrwbenc --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzimg --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-small --enable-vaapi --enable-version3 --enable-vulkan --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared --enable-version3 --enable-libaribb24 --enable-libopencore_amrnb --enable-libopencore_amrwb --enable-libtesseract --enable-libvo_amrwbenc --enable-libsmbclient --enable-libplacebo --enable-librsvg --ignore-tests=hapenc-hap-none,hapenc-hapa-none,hapenc-hapq-none --cross-prefix=i686-linux-gnu- --target-os=linux --enable-cross-compile
DESTDIR=debian/tmp make install -j$(nproc)
dpkg-buildpackage -a i386

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
rm -rfv ./output/ffmpeg5-doc*.deb
