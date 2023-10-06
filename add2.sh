#!/bin/bash

sudo insmod i2c-ch341-usb-master/i2c-ch341-usb.ko


while getopts c:r:v:h: flag
do
	case "${flag}" in
		c) channel=${OPTARG};;
		r) range=${OPTARG};;
		v) voltage=${OPTARG};;
		h) help=${OPTAGR};;
	esac
done

#echo "$channel, who"
if [ -n "$channel" ]; then
	if [ $channel -eq 0 ]; then
		if [[ "$voltage" =~ ^[0-9]+$ ]]; then
			if [ $voltage -lt 4096 ]; then
				sudo i2cset -y 9 0x5f 0x03 $((voltage>>4))
				echo "set V0 to $((voltage>>4)) [V]"

				voltage=$((voltage&15))
				sudo i2cset -y 9 0x5f 0x02 $((voltage<<4))
				echo "set V0 to $((voltage)) [mV]"
			else
				echo "OVER LIMIT VOLTAGE. LESS THAN 4096"
			fi
		else
			echo "Voltage must be number!"
		fi
	elif [ $channel -eq 1 ]; then
		if [[ "$voltage" =~ ^[0-9]+$ ]]; then
			if [ $voltage -lt 4096 ]; then
				sudo i2cset -y 9 0x5f 0x05 $((voltage>>4))
				echo "set V1 to $((voltage>>4)) [V]"

				voltage=$((voltage&15))
				sudo i2cset -y 9 0x5f 0x04 $((voltage<<4))
				echo "set V1 to $((voltage)) [mV]"
			else
				echo "OVER LIMIT VOLTAGE. LESS THAN 4096"
			fi
		else
			echo "Voltage must be number!"
		fi
	else
		echo "NOT EXISTED CHANNEL $channel"
	fi
else	
	if  [ $range -lt 6 ]; then
		sudo i2cset -y 9 0x5f 0x01 0x00
		echo "Set 5V OUT of V0, V1"
		echo "*1step of V0=0.0012256[V]"
		echo "*1step of V1=0.0012231[V]"
	elif [ $range -lt 11 ]; then	
		sudo i2cset -y 9 0x5f 0x01 0x11
		echo "Set 10V OUT of V0, V1"
		echo "*1step of V0=0.0024585[V]"
		echo "*1step of V1=0.0024536[V]"
	else
		echo "Command Error; -c:$channel, -r: $range, -v:$voltage.$"
	fi
fi


#echo "channel: $channel";
#echo "range: $range";

