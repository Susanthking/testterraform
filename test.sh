#!/bin/bash

# Base directory
 BASE_DIR="your_base_directory"
#
# # Create base directories
 mkdir -p $BASE_DIR/modules/{vpc,subnets,security_groups,ec2,nat_gateway,load_balancer,rds}
#
# # Create main.tf, outputs.tf, and variables.tf in the base directory
 touch $BASE_DIR/{main.tf,outputs.tf,providers.tf,variables.tf}
#
# # Create main.tf, outputs.tf, and variables.tf in each module directory
 for module in vpc subnets security_groups ec2 nat_gateway load_balancer rds; do
   touch $BASE_DIR/modules/$module/{main.tf,outputs.tf,variables.tf}
   done
#
   echo "Folder structure created successfully."
#
