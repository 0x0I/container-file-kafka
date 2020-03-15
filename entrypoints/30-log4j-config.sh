#!/bin/bash

# Print all commands executed if DEBUG mode enabled
[ -n "${DEBUG:-""}" ] && set -x

config_dir="${KAFKA_HOME}/config"
config_path="${config_dir}/log4j.properties"

mkdir -p $config_dir

# Add provisioning header
echo "# Managed by 0xO1.IO" > $config_path
echo >> $config_path

# Render log4j logging properties configuration
if env | grep LOG4J_ &>/dev/null; then

  for VAR in `env | sort -h`
  do
    if [[ "$VAR" =~ ^LOG4J_ ]]; then
      property_key=`echo "$VAR" | sed -r "s/LOG4J_(.*)=.*/\1/g" | tr _ .`
      # if section name contains a '.', obtain value from full ENV rather than parse
      if [[ $property_key == *.* ]] ; then
        echo "$property_key = $(echo "$VAR" | cut -d'=' -f2)" >> $config_path
      else
        property_value=`echo "LOG4J_${property_key}"`
        echo "$property_key = ${!property_value}" >> $config_path
      fi
      echo >> $config_path
    fi
  done
fi

# Ensure general logging variables are set accordinglyV if not specified
if ! env | grep 'LOG4J_log4j.rootLogger' &>/dev/null; then
  echo "log4j.rootLogger = INFO, stdout" >> $config_path
  echo "log4j.appender.stdout = org.apache.log4j.ConsoleAppender" >> $config_path
  echo "log4j.appender.stdout.layout = org.apache.log4j.PatternLayout" >> $config_path
  echo >> $config_path
fi

# adjust the general broker logging level (output to server.log and stdout)
if ! env | grep 'LOG4J_log4j.logger.kafka' &>/dev/null; then
  echo "log4j.logger.kafka = INFO" >> $config_path
  echo >> $config_path
fi

# 
if ! env | grep 'LOG4J_log4j.logger.org.apache.kafka' &>/dev/null; then
  echo "log4j.logger.org.apache.kafka = INFO" >> $config_path
  echo >> $config_path
fi

# adjust ZK client logging
if ! env | grep 'LOG4J_log4j.logger.org.apache.zookeeper' &>/dev/null; then
  echo "log4j.logger.org.apache.zookeeper = INFO" >> $config_path
  echo >> $config_path
fi

# enable request logging
if ! env | grep 'LOG4J_log4j.logger.kafka.request.logger' &>/dev/null; then
  echo "log4j.logger.kafka.request.logger = WARN" >> $config_path
  echo >> $config_path
fi
