#!/usr/bin/expect
spawn ./interactive.sh
expect "Enter a number:"
send "1\n"
expect "Enter your name:"
send "hello\n"
expect eof
