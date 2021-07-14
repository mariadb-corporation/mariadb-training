SET @start := (SELECT SUM(VARIABLE_VALUE/1024/1024) FROM information_schema.global_status WHERE VARIABLE_NAME LIKE 'WSREP%bytes'); 
DO sleep(60);
SET @end := (SELECT SUM(VARIABLE_VALUE/1024/1024) FROM information_schema.global_status WHERE VARIABLE_NAME like 'WSREP%bytes'); 
SET @gcache := (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@@GLOBAL.wsrep_provider_options, 'gcache.size = ',-1), ';', 1));
SET @gcache_size := @gcache * 1;
SET @gcache_size_factor := if(right(@gcache,1)="M",1,1024);
SET @difference := round((@end - @start),2);
SELECT
	@difference as `MB/min`, 
	@difference * 60 as `MB/hour`, 
	@gcache as `gcache Size`, 
	if(@difference = 0,0, round(@gcache_size*@gcache_size_factor/@difference)) 
	as `Time to full(minutes)`;
