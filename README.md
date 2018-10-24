Forked from:
https://github.com/RedHat-Middleware-Workshops/modernize-apps-labs

~~~
minishift profile set monolith2microservices
./scripts/prepare.sh
minishift start
./scripts/prepare-additional.sh
~~~

~~~
minishift console
login: admin
password: admin
~~~

Create a new project
~~~
cd monolith
mvn clean package -Popenshift
oc projects
oc project coolstore-dev
oc start-build coolstore --from-file=deployments/ROOT.war
~~~

Create project inventory
~~~
oc new-app -e POSTGRESQL_USER=inventory -e POSTGRESQL_PASSWORD=mysecretpassword -e POSTGRESQL_DATABASE=inventory openshift/postgresql:latest --name=inventory-database
mvn clean fabric8:deploy -Popenshift
~~~

Create project catalog
~~~
oc new-app -e POSTGRESQL_USER=catalog -e POSTGRESQL_PASSWORD=mysecretpassword -e POSTGRESQL_DATABASE=catalog openshift/postgresql:latest --name=catalog-database
mvn package fabric8:deploy -Popenshift -DskipTests
~~~
