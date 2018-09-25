Forked from:
https://github.com/RedHat-Middleware-Workshops/modernize-apps-labs

$ minishift profile set monolith2microservices
$ ./scripts/prepare.sh
$ minishift start
$ ./scripts/prepare-additional.sh


$ minishift console
login: admin
password: admin

Create a new project

$ cd monolith
$ mvn clean package -Popenshift
$ oc projects
$ oc project coolstore-dev
$ oc start-build coolstore --from-file=deployments/ROOT.war
