# 2022/2023 autumn
# This program receives a text file as an argument and answers the given questions.
# The text file contains data about workplace violence. Each line contains the name of the workplace, its address, the number of violent acts in a year, the number of security guards - separated by commas.
# e.g. Fűzfa fütyülő kft, 1111 Budapest Ökör utca 6, 5, 3
# a) Name of the workplace where there was no violence, if there was none, then write "NINCS".
# b) Count the total number of security guards according to the given data file!
# c) Where is the workplace with the most violence, give its name and address!

# 2022/2023 ősz
# Ez a program egy beadandó feladat volt, egy argumentumban megadott szöveges adatfájlt dolgoz fel és választ ad a megadott kérdésekre.
# A szöveges fájlban a munkahelyi erőszakkal kapcsolatban tárolunk adatokat. Soronként a munkahely neve, címe, az egy évben előforduló erőszakos cselekmények száma, biztonsági őrök száma - vesszővel elválasztva.
# pl. Fűzfa fütyülő kft, 1111 Budapest Ökör utca 6, 5, 3
# a) Munkahely neve ahol nem volt erőszak, ha ilyen nem volt akkor kiírjuk, hogy "NINCS".
# b) Számoljuk össze, hány biztonsági őr van összesen a megadott adatfájl szerint!
# c) Hol található a legtöbb erőszakot jelentő munkahely, adjuk meg a nevét/nevüket és címét/címüket!

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

