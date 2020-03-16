<p><img src="https://avatars1.githubusercontent.com/u/12563465?s=200&v=4" alt="OCI logo" title="oci" align="left" height="70" /></p>
<p><img src="https://pbs.twimg.com/profile_images/781633389577195521/kazUJooF_400x400.jpg" alt="kafka logo" title="kafka" align="right" height="80" /></p>

Container File :signal_strength: :sunrise: Kafka
=========
![GitHub release (latest by date)](https://img.shields.io/github/v/release/0x0I/container-file-kafka?color=yellow)
[![Build Status](https://travis-ci.org/0x0I/container-file-kafka.svg?branch=master)](https://travis-ci.org/0x0I/container-file-kafka)
[![Docker Pulls](https://img.shields.io/docker/pulls/0labs/0x01.kafka?style=flat)](https://hub.docker.com/repository/docker/0labs/0x01.kafka)
[![License: MIT](https://img.shields.io/badge/License-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Environment Variables](#environment-variables)
      - [Config](#config)
      - [Launch](#launch)
  - [Dependencies](#dependencies)
  - [Example Run](#example-run)
  - [License](#license)
  - [Author Information](#author-information)

Container file that installs, configures and launches Kafka: a distributed and fault tolerant stream-processing platform.

##### Supported Platforms:
```
* Redhat(CentOS/Fedora)
* Ubuntu
* Debian
```

Requirements
------------

None

Environment Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _config_
* _launch_

#### Config

**Kafka** supports specification of various options controlling aspects of a broker's behavior and operational profile. Each configuration can be expressed within a simple configuration file, `server.properties` by default, composed of **key=vaue** pairs representing configuration properties available.

_The following details the facilities provided by this image to manage the content of the aforementioned configuration file:_

Each of these configurations can be expressed using environment variables prefixed with `CONFIG_` organized according to the following:
* **broker operations** - various settings related to broker operational behavior within a cluster (e.g. advertisement of broker listening parameters/details, topic and partition/replica management, logging storage and retention policies, resource usage and limitation profiles)
* **default topic properties** - settings which manage per topic default specifications (capable of being overridden during topic creation)

`$CONFIG_<config-property> = <property-value (string)>` **default**: *None*

* Any configuration setting/value key-pair supported by `kafka` **broker configs** should be expressible within each `CONFIG_` environment variable and properly rendered within the associated properties file. **Note:** `<config-property>` along with the `property-value` specifications should be written as expected to be rendered within the associated *properties* config (**e.g.** `CONFIG_zookeeper.connect=zk1.cluster.net:2121` or  `CONFIG_advertised.listeners=PLAINTEXT://kafka1.cluster.net:9092`).

Furthermore, configuration is not constrained by hardcoded author defined defaults or limited by pre-baked templating. If the config section, setting and value are recognized by your `kafka` version, :thumbsup: to define within an environnment variable according to the following syntax.

  `<config-property>` -- represents a specific configuration property to set:

  ```bash
  # Property: broker.id (sets unique identifier for an individual Kafka broker within a cluster)
  CONFIG_broker.id=<property-value>
  ```

  `<property-value>` -- represents property value to configure:
  ```bash
  # Property: broker.id
  # Value: 10 (value of type INT)
  CONFIG_broker.id=10
  ```
  
  A list of configurable *Kafka* settings can be found [here](https://kafka.apache.org/documentation/#brokerconfigs).
  
`$BROKER_ID_COMMAND = <string>` (**default**: *None*)
- shell command to execute to determine unique broker id of provisioned Kafka broker. Used in place of application default if `CONFIG_broker.id` is not set.

##### Log4j Config

Kafka's logging facility is managed via [Log4j](https://logging.apache.org/log4j/2.x/),a logging service/framework built under the Apache project; with its configuration defined in a `log4j.properties` file located underneath Kafka's main `$KAFKA_HOME/config/` directory by default. As with other configuration mechanisms supported by this image, each configuration can be expressed as environment variables prefixed with `LOG4J_`.

`$LOG4J_<config-property> = <property-value (string)>` **default**: *none*

See [here](https://github.com/apache/kafka/blob/trunk/config/log4j.properties) for an example configuration file and list of supported settings.

##### JVM Options

Kafka uses the following environment variables to manage various aspects of its JVM environment:

`$KAFKA_HEAP_OPTS = <mem-heap-mgmt-settings (string)>` **default**: *None*

* Adjust general memory management options used during Kafka broker operation (e.g. `-Xmx256M -Xms256M`).

`$KAFKA_JVM_PERFORMANCE_OPTS = <jvm-performance-settings (string)>` **default**: *None*

* Modify Kafka JVM performance settings (e.g. `-server -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:MaxInlineLevel=15 -Djava.awt.headless=true.`)

`$KAFKA_GC_LOG_OPTS = <defined/true | undefined>` **default**: *None*

* Enable JVM garbage collection logging.

`$KAFKA_JMX_OPTS = <jmx-settings (string)>` **default**: *None*

* Manage Java Management Extensions(JMX) settings (e.g. `"-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false`)

See [here](https://github.com/apache/kafka/blob/trunk/bin/kafka-run-class.sh#L184) for more details.
 
##### Zookeeper Config

Use of this Containerfile and resultant image also enables management of a local instance of *Zookeeper* via embedded binaries included within each *Kafka* installation. Similar to *Kafka*, each configuration is rendered within a properties file, `zookeeper.properties` by default, and can be expressed as environment variables prefixed with `ZKCONFIG_`.

`$ZKCONFIG_<config-property> = <property-value (string)>` **default**: *None*

See [here](https://github.com/apache/zookeeper/blob/master/conf/zoo_sample.cfg) for an example configuration file and list of supported settings.
  
#### Launch

Running a `kafka` broker is accomplished utilizing official **Kafka** binaries, obtained from Apache Kafka's official downloads [site](https://kafka.apache.org/downloads). The execution profile of a *Kafka* broker is primarily managed via its `server.properties` configuration though, due to its dependency on the *Zookeeper* key-value store service, _the following variable(s) can be customized to manage the launch of a local ZK instance to meet this dependency, provided a more dedicated and robust solution is not available._

`$SETUP_ZK: <defined/true | undefined/empty-string>` (**default**: *undefined*)
- whether to launch a local *Zookeeper* instance. **note:** any setting of this variable registers as `true` to setup a local *Zookeeper* instance.

Dependencies
------------

None

Example Run
----------------
default example:
```
podman run --env SETUP_ZK=true 0labs/0x01.kafka:2.4.0_centos-7
```

adjust broker identification details:
```
podman run --env SETUP_ZK=true \
           --env CONFIG_broker.id=100 \
           --env CONFIG_advertised.host.name=kafka1.cluster.net \
           0labs/0x01.kafka:2.4.0_centos-7
```

launch Kafka broker connecting to existing remote Zookeeper cluster and customize connection parameters:
```
podman run --env CONFIG_zookeeper.connect=111.22.33.4:2181 \
           --env CONFIG_zookeeper.connection.timeout.ms=30000 \
           --env CONFIG_zookeeper.max.in.flight.requests=30 \
           0labs/0x01.kafka:2.4.0_centos-8
```

setup local zookeeper instance and modify its connection parameters:
```
podman run --env SETUP_ZK=true \
           --env ZKCONFIG_clientPort=2182 \
           --env ZKCONFIG_maxClientCnxns=10 \
           --env ZKCONFIG_admin.serverPort=8085 \
           --env CONFIG_zookeeper.connect=127.0.0.1:2182 \
           0labs/0x01.kafka:2.4.0_fedora-31
```

update Kafka commit log directory and parameters in addition to providing a named volume for storage persistence:
```
podman run --env CONFIG_log.dirs=/mnt/data/kafka \
           --env CONFIG_log.flush.interval.ms=3000 \
           --env CONFIG_log.retention.hours=168 \
           --env CONFIG_zookeeper.connect=zk1.cluster.net:2181 \
           --volume kafka_data:/mnt/data/kafka
           0labs/0x01.kafka:2.4.0_ubuntu:19.04
```

adjust logging and JVM settings for broker auditing:
```
podman run --env CONFIG_log.dirs=/mnt/data/kafka \
           --env CONFIG_log.flush.interval.ms=1000 \
           --env LOG4J_log4j.rootLogger=TRACE,stdout,kafkaAppender \
           --env LOG4J_log4j.appender.stdout=org.apache.log4j.ConsoleAppender \
           --env LOG4J_log4j.appender.stdout.layout=org.apache.log4j.PatternLayout \
           --env LOG4J_log4j.appender.kafkaAppender=org.apache.log4j.DailyRollingFileAppender \
           --env LOG4J_log4j.appender.kafkaAppender.File=${kafka.logs.dir}/server.log \
           --env LOG4J_log4j.appender.kafkaAppender.layout=org.apache.log4j.PatternLayout \
           --env LOG4J_log4j.logger.org.apache.zookeeper=TRACE \
           --env LOG4J_log4j.logger.kafka=TRACE \
           --env LOG4J_log4j.logger.org.apache.kafka=TRACE \
           --env KAFKA_HEAP_OPTS="-Xmx6g -Xms6g -XX:MetaspaceSize=96m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:G1HeapRegionSize=16M -XX:MinMetaspaceFreeRatio=50 -XX:MaxMetaspaceFreeRatio=80" \
           --env KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false" \
           --env KAFKA_JVM_PERFORMANCE_OPTS="-server -XX:InitiatingHeapOccupancyPercent=90 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true" \
           --volume kafka_data:/mnt/data/kafka \
           0labs/0x01.kafka:2.4.0_ubuntu-19.04
```

License
-------

MIT

Author Information
------------------

This Containerfile was created in 2020 by O1.IO.
