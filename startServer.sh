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