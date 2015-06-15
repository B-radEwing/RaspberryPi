#!/bin/bash

# Check if there are no opts arguments
NO_ARGS=0
if [ $# -eq "$NO_ARGS" ]
        then
	date '+%d/%m/%Y %H:%M:%S' >> /home/pi/projects/temp.txt
	/opt/vc/bin/vcgencmd measure_temp >> /home/pi/projects/temp.txt
fi

# If there are, check for proper invocation, otherwise post an error message.
P_FLAG=0
T_FLAG=0
FILE_NAME=
E_OPTERROR=85
while [ $# -ne 0 ]
	do
		if [ $1 = "-p" ]
			then
			shift
			P_FLAG=1
			FILE_NAME=$1
			shift
		elif [ $1 = "-t" ]
			then
			shift
			T_FLAG=1
			shift
		else
			echo "invalid argument: $1"
			echo "usage: temperature.sh {-p FILENAME} {-t}"
			exit $E_OPTERROR
		fi
done

#Argument Checking
if [[ $T_FLAG = 1 && $P_FLAG = 0 ]]; then
	echo "invoking -t requires -p arguments"
	echo "usage: temperature.sh {-p FILENAME} {-t}"
        exit $E_OPTERROR
fi

declare -a dates
declare -a times
declare -a temps
x=0
if [ $P_FLAG = 1 ]
then
	input=$(cat "temp.txt")
	str=($input)
	length=${#str[@]}
	for ((i=0;i<"$length";i++)); do
		dates[x]=${str[i]}
		((i++))
		times[x]=${str[i]}
		((i++))
		temp=${str[i]}
		temp=${temp#*=}
		temp=${temp%\'*}
		temps[x]=$temp
		((x++))
	done
	counter=${#temps[*]}
	for ((i=0;i<"$counter";i++)); do
		echo "${dates[i]} ${times[i]} ${temps[i]}" >> plot.dat
	done

	gnuplot << EOF
	set terminal png
	set xlabel "Time"
	set ylabel "Temperature (Celcius)"
	set output "$FILE_NAME"
	set xdata time
	set timefmt '%d/%m/%Y %H:%M:%S'
	plot "plot.dat" using 1:3 smooth csplines
EOF

if [ $T_FLAG = 1 ]
then
        echo "$FILE_NAME"
        ./tweetTemp.py $FILE_NAME
fi

rm -f plot.dat

fi
