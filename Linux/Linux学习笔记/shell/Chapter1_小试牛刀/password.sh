#!/bin/bash
echo -e "Enter password:"
stty -echo
read Password
stty echo
echo
echo Password read.
