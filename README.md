# RustLinuxOxideSetup  
##Setup guide for Rust Server on Linux with the Oxide plugin  
  
  sudo yum install glibc.i686 libstdc++.i686 glibc libstdc++ expect screen  
  useradd rust  
  
*** NOTE: In order to use screen as user rust, you must ssh into the user. it wont work right if you 'su' to your rust user. just run ssh-keygen as another user (like root) and then copy the key into the rust user then just ssh rust@0 or ssh rust@127.0.0.1  **
  
### As the rust user:  
  
  ```
  mkdir .ssh  
  chmod 700 .ssh  
  touch .ssh/authorized_keys  
  chmod 600 .ssh/authorized_keys  
  yum install glibc libstdc++  
  mkdir ~/steamcmd && cd ~/steamcmd  
  curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -  
  ./steamcmd.sh  
  ```
  
### Let it run for the first time then quit.  
  
  ```
  vim ./updaterust.ex  
  ```
  
#### Insert:  
  
  ```
  #!/usr/bin/expect  
    
  set timeout -1  
  spawn ./steamcmd.sh  
  expect "Steam>"  
  send "login anonymous\r"  
  expect "Steam>"  
  send "app_update 258550\r"  
  expect "Steam>"  
  send \003  
  send "\r"  
  expect eof  
  ```
  
#### And save.  
  
  ```
  chmod 700 updaterust.ex  
  ```
  
### Install rust using the updater:  
  
  ```
  ./updaterust.ex  
  ```
  
### Set up the start script:  
  
  ```
  cd ~/Steam/steamapps/common/rust_dedicated/  
  vim start.sh  
  ```
  
#### Insert:  
  
  ```
  #!/bin/sh  
  clear  
  while :  
  do  
      echo "Starting server...\n"  
      exec ./RustDedicated -batchmode -nographics \  
      -server.ip 0.0.0.0 \  
      -server.port 28015 \  
      -rcon.ip 0.0.0.0 \  
      -rcon.port 28016 \  
      -rcon.password "placeyourrconpasswordhere" \  
      -server.maxplayers 500 \  
      -server.hostname "Here is what I want my server to be in the list when people on rust look for it" \  
      -server.identity "myondiskarbitraryrustservername" \  
      -server.level "Procedural Map" \  
      -server.seed 12345 \ ### Look up rust level seed maps on google to see the map first  
      -server.worldsize 8000 \  ### Levelsize divided by 4 plus 500 = max distance the shore will be, ie 8000/4=2000+500=2500 so -2500 to 2500  
      -server.saveinterval 15 \  ### Time in seconds to flush all ingame building/item/inventory adjustments to disk. WARNING a sync in bash does NOT do this, set it low, 1 is not bad for only 2-5 players all building.  
      -server.globalchat true \  
      -server.description "Powered by Oxide" \  
      -server.headerimage "http://oxidemod.org/styles/oxide/logo.png" \  
      -server.url "http://oxidemod.org"  
      echo "\nRestarting server...\n"  
  done  
  ```
  
#### And save.  
  
  ```
  chmod 700 ./start.sh  
  ```
  
### Install oxide, too (do this every time rust server has to update):  
  
  ```
  curl -sqL 'https://github.com/OxideMod/Snapshots/raw/master/Oxide-Rust_Linux.zip' > zip.zip  
  unzip zip.zip  
  ```
  
### Run the server to populate oxide data  
  
  ```
  ./start.sh  
  ```
  
### Wait a moment...
### Then...
### Ctrl-C to stop the server  
  
### Set up symlinks to your server and oxide folders to save time:  
  
  ```
  ln -s ~/Steam/steamapps/common/rust_dedicated/ ~/server  
  ```
  
### Update this path with your server identity name  
  
  ```
  ln -s ~/Steam/steamapps/common/rust_dedicated/server/myondiskarbitraryrustservername/oxide ~/oxide  
  ```
  
### Get into a screen session so the server runs after you close your terminal, and start rust server:  
  
  ```
  screen  
  ```
### Opens up a terminal in a screen session, placing you into your home directory where you added the 'server' symlink  

  ```
  cd server  
  ./start.sh  
  ```
  
### Press ctrl-a then press ctrl-d to detach from screen  
### Run screen -x to re-attach to it later  
  
### Connect to rcon using RustAdmin on port 28016 using the rcon pw and run 'server.writecfg' to populate the 'cfg' folder with config files to let you add admins/mods. see also http://oxidemod.org/threads/server-commands-for-rust.6404/  
