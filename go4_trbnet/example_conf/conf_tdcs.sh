#!/bin/bash


## this script is called by conf.sh ##

### all tdcs ###

for TDC in 0x0350 0x0351 0x0352 0x0353; do

	# invert the first 32 channels
	#trbcmd w $TDC 0xc805 0xFFFFFFFF

	# enable trigger windows +-1000 ns
	trbcmd w $TDC 0xc801 0x80c800c8

	# set channel ringbuffer size
	trbcmd w $TDC 0xc804 10

done
