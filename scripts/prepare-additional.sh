#!/bin/bash
oc login -u system:admin

# Add admin privileges for admin and developer
oc adm policy add-role-to-user system:image-puller system:anonymous
oc adm policy add-cluster-role-to-user cluster-admin admin
oc adm policy add-cluster-role-to-user sudoer developer

# Import jenkins images and re-tag for 3.7
oc import-image jenkins:v3.7 --from='registry.access.redhat.com/openshift3/jenkins-2-rhel7:v3.7' --confirm -n openshift
oc export template jenkins-persistent -n openshift -o json | sed 's/jenkins:latest/jenkins:v3.7/g' | oc replace -f - -n openshift
oc export template jenkins-ephemeral -n openshift -o json | sed 's/jenkins:latest/jenkins:v3.7/g' | oc replace -f - -n openshift

# import Monolith templates and JBoss Imagestreams
oc create -n openshift -f https://raw.githubusercontent.com/RedHat-Middleware-Workshops/modernize-apps-labs/master/monolith/src/main/openshift/template-binary.json
oc create -n openshift -f https://raw.githubusercontent.com/RedHat-Middleware-Workshops/modernize-apps-labs/master/monolith/src/main/openshift/template-prod.json

# Disable namespace ownership for router
oc env dc/router ROUTER_DISABLE_NAMESPACE_OWNERSHIP_CHECK=true -n default

echo "Importing images" 
for is in {"registry.access.redhat.com/jboss-eap-7/eap70-openshift","registry.access.redhat.com/rhscl/postgresql-94-rhel7","registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift"}
do 
  oc import-image $is --all --confirm --as=system:admin 
done
