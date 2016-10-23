### RustLinuxOxideSetup  
###   
### Setup guide for Rust Server on Linux with the Oxide plugin  
### Recommended for CentOS 6 or equivalent  
  
## As user 'root', install a few dependencies and set up a normal user account (we'll call it 'rust'):
  
  ```
yum install glibc.i686 libstdc++.i686 glibc libstdc++ expect screen  
useradd rust  
  ```
  
## NOTE: In order to use screen as user 'rust', ssh to rust@127.0.0.1 (localhost). You can set keys up to speed this up. If you try using 'su' or 'sudo' to change to the 'rust' user, the startup script will not function properly. Simply run 'ssh-keygen' as user 'root' to generate a fresh key, then copy the key into the 'rust' user at ~/.ssh/authorized_keys

## As user 'root':  

  ```
ssh-keygen
## Press return a few times for default options
mkdir ~rust/.ssh
chown rust: ~rust/.ssh
chmod 700 ~rust/.ssh
cat ~/.ssh/id_rsa.pub > ~rust/.ssh/authorized_keys
chown rust: ~rust/.ssh/authorized_keys
chmod 600 ~rust/.ssh/authorized_keys
ssh rust@0
## It should connect and use the key - you should now be logged in as user 'rust'
  ```
  
## As user 'rust':  
  
  ```
mkdir ~/steamcmd && cd ~/steamcmd  
curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -  
./steamcmd.sh  
  ```
  
### Let it run for the first time then type 'quit'. Begin editing a new file where we'll set up an auto updater:
  
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
send "\r\r"
spawn $env(SHELL)
expect "$ "
send "cd ~/Steam/steamapps/common/rust_dedicated/; curl -sqL 'https://github.com/OxideMod/Snapshots/raw/master/Oxide-Rust_Linux.zip' > oxide.zip; unzip oxide.zip\r"
expect "ename:"
send "A\r"
expect "$ "
send "exit\r"
expect eof
  ```
  
#### And save. Set permissions:
  
  ```
chmod 700 updaterust.ex  
  ```
  
### Install rust and oxide using the updater:  
  
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
    -rcon.password "hunter2" \
    -server.maxplayers 500 \
    -server.hostname "My Rust Server Name" \
    -server.identity "myrustservername" \
    -server.level "Procedural Map" \
    -server.seed 12345 \ ### Look up rust level seed maps on google to see the map first
    -server.worldsize 8000 \  ### Levelsize divided by 4 plus 500 = max distance the shore will be, ie 8000/4=2000+500=2500 so -2500 to 2500
    -server.saveinterval 300 \  ### Time in seconds to flush all ingame building/item/inventory adjustments to disk (bash 'sync' command does not do this)
    -server.globalchat true \
    -server.description "Powered by Oxide" \
    -server.headerimage "http://oxidemod.org/styles/oxide/logo.png" \
    -server.url "http://oxidemod.org"
    echo "\nRestarting server...\n"
done
  ```
  
#### And save. Set permissions:
  
  ```
chmod 700 ./start.sh  
  ```
  
### Run the server to populate oxide data directories:
  
  ```
./start.sh  
  ```
  
## Wait a moment... then... Ctrl-C to stop the server  
  
## Set up symlinks to your server and oxide folders to save time:  
  
  ```
ln -s ~/Steam/steamapps/common/rust_dedicated/ ~/server  
  ```
  
## NOTE: Update the following path with your server identity name:
  
  ```
ln -s ~/Steam/steamapps/common/rust_dedicated/server/myrustservername/oxide ~/oxide  
  ```
  
## Get into a screen session so the server runs after you close your terminal, and start rust server:  
  
  ```
screen  
cd server  
./start.sh  
  ```
  
## Press Ctrl-A then press Ctrl-D to detach from a screen session
## Later, you can run 'screen -x' in bash to re-attach to the session.
## Also check out 'screen --help' 'screen -wipe' and 'screen -list' in case you need to control multiple sessions

## You will need to open UDP for port 28015 as Rust uses UDP for game communication. You might also open up TCP/UDP for both 28015 and 28016. If you plan to run an nginx/haproxy server or host your map or a site on the same machine, open up 80/443.

## Connect to rcon using RustAdmin on port 28016 using the rcon pw and run 'server.writecfg' to populate the 'cfg' folder with config files to let you add admins/mods.


## See Also

http://oxidemod.org/threads/server-commands-for-rust.6404/  
