#!/bin/bash


sudo yum install glibc.i686 libstdc++.i686 glibc libstdc++ expect screen  
useradd rust

ssh rust

mkdir .ssh  
chmod 700 .ssh  
touch .ssh/authorized_keys  
chmod 600 .ssh/authorized_keys  
yum install glibc libstdc++  
mkdir ~/steamcmd && cd ~/steamcmd  
curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -  
./steamcmd.sh 

chmod 700 updaterust.ex 

./updaterust.ex  

cp startServer.sh ~/Steam/steamapps/common/rust_dedicated/startServer.sh
cd ~/Steam/steamapps/common/rust_dedicated/  
chmod 700 ./startServer.sh

curl -sqL 'https://github.com/OxideMod/Snapshots/raw/master/Oxide-Rust_Linux.zip' > oxide.zip  
unzip oxide.zip

./start.sh