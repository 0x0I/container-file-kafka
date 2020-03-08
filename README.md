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

**Kafka** supports specification of various options controlling aspects of a broker's behavior and operational profile. Each configuration can be expressed within a simple configuration file, `server.properties` by default, composed of **key=vaue** pairs representing configuration properties available. For a reference to the list of available configuration options, see [here](https://kafka.apache.org/documentation/#configuration).

_The following details the facilities provided by this role to manage the content of the aforementioned configuration file:_

Each of these configurations can be expressed using environment variables prefixed with `CONFIG_` or `ZKCONFIG_` (in the case of managing an instance of zookeeper launched from *Zookeeper* binaries included within each Kafka installation, organized according to the following:
* **broker operations** - various settings related to broker operational behavior within a cluster (e.g. advertisement of broker listening parameters/details, topic and partition/replica management, logging storage and retention policies, resource usage and limitation profiles)
* **default topic properties** - settings which manage per topic default specifications (capable of being overridden during topic creation)
* **local zookeeper instance properties** - settings which control the operational profile of Kafka's embedded `Zookeeper` provider (if activated) -- **note:** as previously mentioned, configuration environment variables should be prefixed with **ZKCONFIG_** rather than `CONFIG_`. Also note, configs are rendered within a *zookeeper.properties* file found within the same directory as *server.properties* dictated by the `KAFKA_HOME` env var.

`$[ZK]CONFIG_<config-property> = <property-value (string)>` **default**: *None*

* Any configuration setting/value key-pair supported by `kafka` **broker configs** or **zookeeper** should be expressible within each `CONFIG_` or `ZKCONFIG_` environment variable and properly rendered within the associated properties file. **Note:** `<config-property>` along with the `,property-value` specifications should be written as expected to be rendered within the associated *properties* config (**e.g.** `CONFIG_zookeeper.connect=zk1.cluster.net:2121`,  `CONFIG_advertised.listeners=PLAINTEXT://kafka1.cluster.net:9092` or `ZKCONFIG_dataDir=/mnt/data/zk`).

Furthermore, configuration is not constrained by hardcoded author defined defaults or limited by pre-baked templating. If the config section, setting and value are recognized by your `kafka` or `zookeeper` version, :thumbsup: to define within an environnment variable according to the following syntax.

  A list of configurable *Kafka* settings can be found [here](https://kafka.apache.org/documentation/#brokerconfigs).

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

#### Launch

Running a `kafka` broker is accomplished utilizing official **Kafka** binaries, obtained from Apache Kafka's official downloads [site](https://kafka.apache.org/downloads). The execution profile of a *Kafka* broker is primarily managed via its `server.properties` configuration though, due to its dependency on the *Zookeeper* key-value store service, _the following variable(s) can be customized to manage the launch of a local ZK instance to meet this dependency, provided a more dedicated and robust solution is not available._

`$SETUP_ZK: <true|undefined/false>` (**default**: *undefined/false*)
- whether to launch a local *Zookeeper* instance

Dependencies
------------

None

Example Run
----------------
default example:
```
podman run \
  --env NAME=value \
  0labs/0x01.<service>:<tag> \
```

License
-------

MIT

Author Information
------------------

This Containerfile was created in 2020 by O1.IO.
