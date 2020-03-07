#!/bin/bash

# Print all commands executed if DEBUG mode enabled
[ -n "${DEBUG:-""}" ] && set -x

if [ -n "${SETUP_ZK+x}" ]; then
  # Render zookeeper properties configuration
  config_dir="${KAFKA_HOME}/config"
  config_path="${config_dir}/zookeeper.properties"

  mkdir -p $config_dir

  # Add provisioning header
  if env | grep ZKCONFIG_; then
    echo "# Managed by 0xO1.IO" > $config_path
    echo >> $config_path

    for VAR in `env | sort -h`; do
      if [[ "$VAR" =~ ^ZKCONFIG_ ]]; then
        property_key=`echo "$VAR" | sed -r "s/ZKCONFIG_(.*)=.*/\1/g" | tr _ .`
        # if section name contains a '.', obtain value from full ENV rather than parse
        if [[ $property_key == *.* ]] ; then
          echo "$property_key = $(echo $VAR | cut -d'=' -f2)" >> $config_path
        else
          property_value=`echo "ZKCONFIG_${property_key}"`
          echo "$property_key = ${!property_value}" >> $config_path
        fi

        echo >> $config_path
      fi
    done
  fi

  exec $KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties
else
  echo "Auto-setup of local Zookeeper not enabled."
fi
