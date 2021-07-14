#!/bin/bash
PASSWORD="mariadb"
NODE1="NODE-ONE-IP-ADDRESS"
NODE2="NODE-TWO-IP-ADDRESS"
FAILURES=0
for i in {1..1000}; do
echo -n -e "\nRound $i ";
mariadb -ulabtest -p$PASSWORD -h $NODE1 test -e"INSERT INTO t VALUES($i)";
ret=$(mariadb --batch -ulabtest -p$PASSWORD -h $NODE2 test -e"SELECT * FROM t WHERE id=$i");
if [ "$ret" = "" ]; then
echo -n "FAILED"
FAILURES=$((FAILURES +1))
fi
done
echo -e "\n${FAILURES} causal read failures per 1000 reads"
