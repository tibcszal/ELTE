#!/bin/bash
eroszakos=0
sum=0
max=0
while IFS=$'\n' read -r line; do
    file[i]="${line}"
    ((++i))
done < <(tr -d '\r' < "$1")
for var in "${file[@]}"
do
	IFS=', ' read -r -a sor <<< "$var"
	if [ ${sor[8]} -eq 0 ]
	then
		echo "a) ${sor[@]:0:3}"
		eroszakos=1
	fi
	if [ ${sor[9]} -gt $max ]
    then
        max=${sor[9]}
    fi
	sum=$(($sum + ${sor[9]}))
done
if [ $eroszakos -eq 0 ]
then
	echo "a) NINCS"
fi
echo "b) $sum"
for var in "${file[@]}"
do
	IFS=', ' read -r -a sor <<< "$var"
	if [ ${sor[9]} -eq $max ]
	then
		echo "c) ${var:0:(-6)}"
	fi
done

