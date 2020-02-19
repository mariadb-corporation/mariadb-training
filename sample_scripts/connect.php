<?php
// Connection settings - adjust as needed
$host = '<HOST>'; 
$user = '<USER>'; 
$pw = '<PASSWORD>';
$db = '<DB>'; 

print "<html><body>";

// Print form if method was GET
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    print "<p>Please enter a city name:</p>";
    print "<form method=POST><input type=text name=city><input type=submit></form>";
}
// Process input of method was POST
else {
    // Connect MariaDB and process any error
    $connect = new mysqli($host, $user, $pw, $db);
    if (mysqli_connect_errno()) {
        printf("Connect failed: %s\n", 
        mysqli_connect_error()); 
        exit(); 
    }

    // Prepare search field from web request
    $search = "%" . $_REQUEST['city'] . "%";

    // Prepare and execute a statement with the search field as bound parameter
    $sql = "SELECT ci.Name AS CityName, co.Name AS CountryName, ci.Population FROM City ci JOIN Country co ON ci.CountryCode=co.Code WHERE ci.Name LIKE ?";
    $sth = $connect->prepare($sql); 
    $sth->bind_param('s', $search);
    $sth->execute();
    $sth->bind_result($city_name, $country_name, $population); 

    // Fetch results in a loop and print
    print "<table border=1><tr><td><b>City Name</b></td><td><b>Country Name</b></td><td><b>Population</b></td></tr>";
    while($sth->fetch()) { 
        print "<tr><td>$city_name</td><td>$country_name</td><td>$population</td></tr>";
    }
    print "</table>";

    // Close our handle and connection
    $sth->close(); 
    $connect->close(); 
}

print "</body></html>";
?>
