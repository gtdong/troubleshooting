#!/bin/sh

function CPU_plan () {
	CPU=$(top -b  -n 1 | sed '1,7c \ ' | awk '{print $9}')
	
	cpu_percent=0
	for cpu in $CPU
	do
		cpu_percent=$cpu+$cpu_percent
	done
	CPU_percent=$(echo "scale=1;$cpu_percent" | bc)
	CPU_line=$(printf %2.0f "$CPU_percent" )
}


function Mem_plan () {
	total=$(free -m | grep "Mem" | awk '{print $2}')
	used=$(free -m | grep "Mem" | awk '{print $3}')
	
	num=$(echo "scale=2;$used/$total" | bc)
	Mem_percent=$(echo $num | cut -d "." -f 2)
}

for ((;;))
do
	clear
	Mem_plan
	echo -e "\033[32;01m[Memory]\033[33;01m[$Mem_percent%]\033[0m\c"
	for ((i=0 ; i<=$Mem_percent ; i++))
	do
		if [ $i -lt 80 ]; then
			echo -e "\033[32;01m=\c\033[0m"
		else
			echo -e "\033[31;01m=\c\033[0m"
		fi
	done
	echo -e "\n"

	CPU_plan
	echo -e "\033[32;01m[CPU]\033[33;01m[$CPU_percent%]\033[0m\c"
	for ((i=0 ; i<=$CPU_line ; i++))
	do
		if [ $i -lt 70 ]; then
			echo -e "\033[32;01m=\c\033[0m"
		else
			echo -e "\033[31;01m=\c\033[0m"
		fi
	done
	sleep 1s
done
