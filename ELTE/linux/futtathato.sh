# 2022/2023 autumn
# This program receives files as arguments and decides how many of them are executable only by their owners.

# 2022/2023 ősz
# Ez a program fájlokat fogad argumentumként és eldönti hogy hány olyan van közöttük, amelyek csak a tulajdonosaik által futtathatóak.

#!/bin/bash
db=0
for i in `ls -al $1|tr -s " "|grep "^[-dl] [r-] [w-]x[r-] [w-]-[r-] [w-]-"`
{
    let "db += 1"
}
echo "Csak a tulaj által futtatható fájlok száma: $db"