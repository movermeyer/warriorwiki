#!/bin/bash
set -e

#This script is designed so that it could be run on a completely fresh Ubuntu machine and result in the machine
#running all of The Warrior Wiki containers (a fully installed instance).

#Install Pre-requsites and create required directories
(./installation_configuration.sh ./machine_preparation.sh)
(./installation_configuration.sh ./s3fs_preparation.sh)
(./installation_configuration.sh ./prepare_mysql_server.sh)
(./installation_configuration.sh ./prepare_web_server.sh)

#Build the images
(./installation_configuration.sh ./build_web_server.sh)

#Run the images
#Start the MySQL Docker image
(./installation_configuration.sh ./start_mysql.sh)


#Start the Mediawiki
(./installation_configuration.sh ./start_web_server.sh)