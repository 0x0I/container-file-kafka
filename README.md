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

License
-------

MIT

Author Information
------------------

This Containerfile was created in 2020 by O1.IO.
