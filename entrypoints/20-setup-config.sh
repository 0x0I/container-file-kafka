#!/bin/bash

# Print all commands executed if DEBUG mode enabled
[ -n "${DEBUG:-""}" ] && set -x

config_dir="${KAFKA_HOME}/config"
config_path="${config_dir}/server.properties"

mkdir -p $config_dir

# Render server properties configuration
if env | grep CONFIG_ &>/dev/null; then
  # Add provisioning header
  echo "# Managed by 0xO1.IO" > $config_path
  echo >> $config_path

  for VAR in `env | sort -h`
  do
    if [[ "$VAR" =~ ^CONFIG_ ]]; then
      property_key=`echo "$VAR" | sed -r "s/CONFIG_(.*)=.*/\1/g" | tr _ .`
      # if section name contains a '.', obtain value from full ENV rather than parse
      if [[ $property_key == *.* ]] ; then
        echo "$property_key = $(echo $VAR | cut -d'=' -f2)" >> $config_path
      else
        property_value=`echo "CONFIG_${property_key}"`
        echo "$property_key = ${!property_value}" >> $config_path
      fi
      echo >> $config_path
    fi
  done
fi

# Ensure required variables are set accordingly if not specified
if ! env | grep CONFIG_zookeeper.connect &>/dev/null; then
  echo "zookeeper.connect = 127.0.0.1:2181" >> $config_path
  echo >> $config_path
fi

if ! env | grep 'CONFIG_listeners\|CONFIG_advertised.listeners' &>/dev/null; then
  echo "advertised.listeners = PLAINTEXT://127.0.0.1:9092" >> $config_path
  echo >> $config_path
fi

# Auto allocate broker ID based on user defined command or default setting
if ! env | grep CONFIG_broker.id &>/dev/null; then
  if [[ -n "$BROKER_ID_COMMAND" ]]; then
    broker_id=$(eval $BROKER_ID_COMMAND)
    echo "broker.id = ${broker_id}" >> $config_path
  else
    echo "broker.id = 1" >> $config_path
  fi
  echo >> $config_path
fi

# Auto set broker log directory if undefined
if ! env | grep CONFIG_log.dirs &>/dev/null; then
  log_dirs="/var/log/kafka/$(hostname)"
  echo "log.dirs = ${log_dirs}" >> $config_path
fi
