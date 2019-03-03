#!/bin/bash

## this script is called by conf.sh ##

### set addresses of FPGAs ###

trbcmd s 0x7100000390255228  0x00 0x0350
trbcmd s 0x8c0000039025fa28  0x01 0x0351
trbcmd s 0xb00000039053e328  0x02 0x0352
trbcmd s 0x790000039053dc28  0x03 0x0353
trbcmd s 0x920000039053d928  0x05 0xc035
echo "FPGAs after addressing"
trbcmd i 0xffff
