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