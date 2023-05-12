#!/bin/bash
db=0
for i in `ls -al $1|tr -s " "|grep "^[-dl] [r-] [w-]x[r-] [w-]-[r-] [w-]-"`
{
    let "db += 1"
}
echo "Csak a tulaj által futtatható fájlok száma: $db"