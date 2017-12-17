Open UDP port 28015 for Rust Dedicated Server

Open TCP port 28016 for the remote console (rcon) (for use with RustAdmin)

## Arch Linux

As user 'root', install a few dependencies and set up a normal user account:
  
```
vim /etc/pacman.conf
## Uncomment the 'multilib' repo and save
pacman -Scc
## Enter 'y' twice for yes
pacman -Syy
## Install reflector
pacman -S reflector
## Get faster repo sources
reflector --protocol https --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist
## Update the OS
pacman -Syyu
## Install dependencies
pacman -S lib32-libstdc++5 libstdc++5 lib32-glibc expect screen
## Create a 'rust' user
useradd -m -d /home/rust rust
```

Add keys to the new account:

```
mkdir /home/rust/.ssh
ssh-keygen
## Press return several times to generate a key
cat ~/.ssh/id_rsa.pub > /home/rust/.ssh/authorized_keys
chmod 700 /home/rust/.ssh
chmod 600 /home/rust/.ssh/authorized_keys
chown -R rust:rust /home/rust/.ssh
ssh rust@0
```

As user 'rust', obtain a copy of steamcmd:

```
mkdir ~/steamcmd && cd ~/steamcmd
curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -
./steamcmd.sh
```

Let it run for the first time, then type 'quit'.  Create a new file and insert the expect script to implement auto-updates:

```
vim ./updaterust.ex
```
  
Insert:
  
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
send "cd ~/Steam/steamapps/common/rust_dedicated/; wget "https://github.com/OxideMod/Oxide.Rust/releases/download/$(curl -sqI https://github.com/OxideMod/Oxide.Rust/releases/latest | awk -F\/ '/^Location/ {print $8}' | strings)/Oxide.Rust.zip" -O oxide.zip; unzip oxide.zip\r"
expect "ename:"
send "A\r"
expect "$ "
send "exit\r"
expect eof
```
  
And save.  Set permissions:
  
```
chmod 700 updaterust.ex
```
  
Install rust and oxide using the updater:  
  
```
./updaterust.ex
```
  
Set up the Rust Dedicated Server startup script:  
  
```
cd ~/Steam/steamapps/common/rust_dedicated/
vim start.sh
```
  
Insert:
  
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
  
And save. Set permissions:
  
```
chmod 700 ./start.sh
```
  
Run the server to populate oxide data directories:
  
```
./start.sh
```
  
Wait a moment, then press Ctrl-C to stop the server.  Set up symlinks to your server and oxide folders to save time:
  
```
ln -s ~/Steam/steamapps/common/rust_dedicated ~/server  
```

NOTE: Update the following path with your server identity name:

```
ln -s ~/Steam/steamapps/common/rust_dedicated/server/myrustservername/oxide ~/oxide  
```

Get into a screen session so the server runs after you close your terminal, and start Rust Dedicated Server:

```
screen
cd ~/server
./start.sh
```
  
Press Ctrl-A then press Ctrl-D to detach from a screen session.  Later, you can run 'screen -x' in bash to re-attach to the session.

Connect to rcon using RustAdmin on TCP port 28016 using the rcon pw and run 'server.writecfg' to populate the 'cfg' folder with config files to let you add admins/mods.

Seealso: http://oxidemod.org/threads/server-commands-for-rust.6404/
