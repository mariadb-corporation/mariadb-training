import mariadb
 
config = {
   'host': '<HOST>',
   'user': '<USER>',
   'password': '<PASSWORD>',
   'database': '<DB>'
}
  
conn = mariadb.connect(**config)
 
cur = conn.cursor()
 
cur.execute(
   """
   SELECT
       ci.name AS CityName,
       co.Name AS CountryName,
       ci.Population
   FROM
       City ci JOIN
       Country co ON ci.CountryCode=co.Code
   ORDER BY
       ci.Population DESC
   LIMIT 10
   """
)
 
results = cur.fetchall()
 
for (CityName, CountryName, Population) in results:
   print(f"{CityName}\t{CountryName}\t{Population}")
 
conn.close()
