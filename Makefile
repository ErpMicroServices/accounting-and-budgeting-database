.PHONY = clean clean-files clean-docker docker

all : docker node_modules database_up.sql
	sudo docker commit new-accounting-and-budgeting_database erpmicroservices/accounting-and-budgeting_database:latest

docker :
	sudo docker build --tag new-accounting-and-budgeting_database --rm .
	sudo docker run -d --publish 5432:5432 --name new-accounting-and-budgeting_database new-accounting-and-budgeting_database
	sleep 10

node_modules : package.json
	npm install

sql/us-cities.sql : data_massagers/cities.csv
	node data_massagers/create_us_cities_sql.js

sql/us-zip-codes.sql : data_massagers/us-zip-codes.csv
	node data_massagers/create_us_zip_codes.js

database_up.sql : sql/*.sql database_change_log.yml
	liquibase --changeLogFile=./database_change_log.yml --url='jdbc:postgresql://localhost/accounting-and-budgeting_database' --username=accounting-and-budgeting_database --password=accounting-and-budgeting_database --url=offline:postgresql --outputFile=database_up.sql updateSql

clean : clean-docker clean-files

clean-files :
	-$(RM) -rf node_modules
	-$(RM) database_up.sql
	-$(RM) databasechangelog.csv

clean-docker :
	if sudo docker ps | grep -q new-accounting-and-budgeting_database; then sudo docker stop new-accounting-and-budgeting_database; fi
	if sudo docker ps -a | grep -q new-accounting-and-budgeting_database; then sudo docker rm new-accounting-and-budgeting_database; fi
	if sudo docker images | grep -q new-accounting-and-budgeting_database; then sudo docker rmi new-accounting-and-budgeting_database; fi
	if sudo docker images | grep -q erpmicroservices/accounting-and-budgeting_database; then sudo docker rmi erpmicroservices/accounting-and-budgeting_database; fi
