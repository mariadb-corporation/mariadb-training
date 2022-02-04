#!/bin/bash
PASSWORD="PASSWORD"
NODE1="NODE-ONE-IP-ADDRESS"
NODE2="NODE-TWO-IP-ADDRESS"
FAILURES=0

# Prepare a sysbench run
mariadb -e "CREATE DATABASE sbtest"
mariadb -e "SET GLOBAL max_connections = 1025"
sysbench oltp_common --db-driver=mysql --mysql-user=root --mysql-db=sbtest prepare

# Create some load with sysbench with some more writes than usual (background run)
sysbench oltp_read_write --time=100 --db-driver=mysql --mysql-user=root --mysql-db=sbtest --threads=16 --report-interval=1 --rate=1000 --point_selects=1 run > /dev/null 2>&1 &

# Run some causal reads
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

# Clean up
killall sysbench > /dev/null 2>&1
mariadb -e "DROP DATABASE sbtest"
