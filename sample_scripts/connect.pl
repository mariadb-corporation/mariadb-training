#!/usr/bin/perl
	
	use DBI;
	
	# Connection settings - adjust as needed
	$host = "<HOST>";
	$db = "<DB>";
	$username = "<USER>";
	$password = "<PASSWORD>";
	
	# Declare connection
	# NB: enable exit on SQL error and autocommit of changes
	$dbn = "DBI:mysql:database=$db;host=$host";
	$dbh = DBI->connect($dbn, $username, $password, {'RaiseError' => 1, 'AutoCommit' => 1});
	
	# Prepare and execute a query
	$sth = $dbh->prepare("SELECT ci.Name AS CityName, co.Name AS CountryName, ci.Population FROM City ci JOIN Country co ON ci.CountryCode=co.Code ORDER BY ci.Population DESC LIMIT 10");
	$sth->execute();
	
	# Loop to retrieve results
	# NB: use hash reference as it can be passed cheaply to a function
	while ($ref = $sth->fetchrow_hashref()) {
		print $ref->{'CityName'} . "\t" . $ref->{'CountryName'} . "\t" . $ref->{'Population'} . "\n";
	}
	
	# Clean up query and close connection
	$sth->finish();
	$dbh->disconnect();
