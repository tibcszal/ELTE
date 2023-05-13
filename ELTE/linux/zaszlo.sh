#2022/2023 ősz
# Ez a program egy zárthelyi dolgozaton szerepelt, kirajzol a terminálba egy argumentumban megadott méretű "zászlót" csillagokból.

#!/bin/bash

n=$1
for i in $(seq 1 $n)
{
    for j in $(seq 1 $i)
    {
        echo -n "*"
    }
    echo ""
}
let "n -= 1"
for i in $(seq $n -1 1)
{
    for j in $(seq 1 $i)
    {
        echo -n "*"
    }
    echo ""
}

echo "terulet = $(((2*$1-1)*$1/2))"