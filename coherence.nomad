job "traditional-1-prod" {
  datacenters = [
    "dc1"
  ]

  group "storage" {
    // Need this group of storage members on the same machine, each machine
    // would have the same number of storage members
    count = 4

    task "storage-instance" {
      artifact {
        source = "${NOMAD_META_COHERENCE_ARTIFACT_SOURCE}"
      }

      artifact {
        source = "${NOMAD_META_CACHE_CONFIG_SOURCE}"
      }

      driver = "java"

      config {
        jar_path = "${NOMAD_TASK_DIR}/${NOMAD_META_COHERENCE_JAR}"
        jvm_options = [
          "-server",
          "-Xmx${NOMAD_META_STORAGE_MEMORY}",
          "-Xms${NOMAD_META_STORAGE_MEMORY}",
          "-Dcoherence.cluster=${NOMAD_META_CLUSTER_NAME}",
          "-Dcoherence.site=${NOMAD_META_SITE_NAME}",
          "-Dcoherence.rack=${NOMAD_META_RACK_NAME}",
          "-Dcoherence.machine=${attr.unique.hostname}",
          "-Dcoherence.ttl=${NOMAD_META_CLUSTER_TTL}",
          "-Dcoherence.log=${NOMAD_TASK_DIR}/${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_STORAGE_ROLE_NAME}-${NOMAD_ALLOC_INDEX}.log",
          "-Dcoherence.role=${NOMAD_META_STORAGE_ROLE_NAME}",
          "-Dcoherence.cacheconfig=${NOMAD_TASK_DIR}/${NOMAD_META_STORAGE_CACHE_CONFIG}",
          "-Dcoherence.management=all",
          "-Dcoherence.management.remote=true",
          "-Dcoherence.member=${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_STORAGE_ROLE_NAME}-${NOMAD_ALLOC_INDEX}"
        ]
        // Add GC log file and any other system properties
      }
    }
  }

  group "proxy" {
    // Need this group of storage members on the same machine, each machine
    // would have the same number of storage members
    count = 2

    task "proxy-instance" {
      artifact {
        source = "${NOMAD_META_COHERENCE_ARTIFACT_SOURCE}"
      }

      artifact {
        source = "${NOMAD_META_CACHE_CONFIG_SOURCE}"
      }

      driver = "java"

      config {
        jar_path = "${NOMAD_TASK_DIR}/${NOMAD_META_COHERENCE_JAR}"
        jvm_options = [
          "-server",
          "-Xmx${NOMAD_META_PROXY_MEMORY}",
          "-Xms${NOMAD_META_PROXY_MEMORY}",
          "-Dcoherence.cluster=${NOMAD_META_CLUSTER_NAME}",
          "-Dcoherence.site=${NOMAD_META_SITE_NAME}",
          "-Dcoherence.rack=${NOMAD_META_RACK_NAME}",
          "-Dcoherence.machine=${attr.unique.hostname}",
          "-Dcoherence.ttl=${NOMAD_META_CLUSTER_TTL}",
          "-Dcoherence.log=${NOMAD_TASK_DIR}/${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_PROXY_ROLE_NAME}-${NOMAD_ALLOC_INDEX}.log",
          "-Dcoherence.role=${NOMAD_META_PROXY_ROLE_NAME}",
          "-Dcoherence.cacheconfig=${NOMAD_TASK_DIR}/${NOMAD_META_PROXY_CACHE_CONFIG}",
          "-Dcoherence.management=all",
          "-Dcoherence.management.remote=true",
          "-Dcoherence.member=${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_PROXY_ROLE_NAME}-${NOMAD_ALLOC_INDEX}",
          "-Dcoherence.extend.enabled=true",
          "-Dcoherence.distributed.localstorage=false"
        ]
        // Add GC log file and any other system properties
      }
    }
  }

  group "jmx" {
    // Need this group of storage members on the same machine, each machine
    // would have the same number of storage members
    count = 1

    task "jmx-instance" {
      artifact {
        source = "${NOMAD_META_COHERENCE_ARTIFACT_SOURCE}"
      }

      artifact {
        source = "${NOMAD_META_CACHE_CONFIG_SOURCE}"
      }

      driver = "java"

      config {
        jar_path = "${NOMAD_TASK_DIR}/${NOMAD_META_COHERENCE_JAR}"
        jvm_options = [
          "-server",
          "-Xmx${NOMAD_META_JMX_MEMORY}",
          "-Xms${NOMAD_META_JMX_MEMORY}",
          "-Dcoherence.cluster=${NOMAD_META_CLUSTER_NAME}",
          "-Dcoherence.site=${NOMAD_META_SITE_NAME}",
          "-Dcoherence.rack=${NOMAD_META_RACK_NAME}",
          "-Dcoherence.machine=${attr.unique.hostname}",
          "-Dcoherence.ttl=${NOMAD_META_CLUSTER_TTL}",
          "-Dcoherence.log=${NOMAD_TASK_DIR}/${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_JMX_ROLE_NAME}-${NOMAD_ALLOC_INDEX}.log",
          "-Dcoherence.role=${NOMAD_META_JMX_ROLE_NAME}",
          "-Dcoherence.cacheconfig=${NOMAD_TASK_DIR}/${NOMAD_META_JMX_CACHE_CONFIG}",
          "-Dcoherence.management=all",
          "-Dcoherence.management.remote=true",
          "-Dcoherence.member=${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_JMX_ROLE_NAME}-${NOMAD_ALLOC_INDEX}",
          "-Dcoherence.extend.enabled=false",
          "-Dcoherence.distributed.localstorage=false",
          "-Dcom.sun.management.jmxremote",
          "-Dcom.sun.management.jmxremote.port=${NOMAD_META_JMX_PORT}",
          "-Dcom.sun.management.jmxremote.authenticate=false",
          "-Dcom.sun.management.jmxremote.ssl=false"
        ]
        // Add GC log file and any other system properties
      }
    }
  }

  meta {
    CLUSTER_NAME = "prod"
    CLUSTER_TTL = "1"

    SITE_NAME = "site-name"
    RACK_NAME = "rack-name"

    COHERENCE_ARTIFACT_SOURCE = "https://repo1.maven.org/maven2/com/oracle/coherence/ce/coherence/20.06.1/coherence-20.06.1.jar"
    CACHE_CONFIG_SOURCE = "https://raw.githubusercontent.com/halljon/nomad-coherence-test-1/main/sample-traditional-cache-config.xml"

    COHERENCE_JAR = "coherence-20.06.1.jar"

    // Using small amount of memory just for prototyping purposes
    STORAGE_MEMORY = "64m"
    STORAGE_ROLE_NAME = "storage"
    STORAGE_CACHE_CONFIG = "sample-traditional-cache-config.xml"
    STORAGE_OVERRIDE_CONFIG = ""
    STORAGE_LOG_LEVEL = 6

    PROXY_MEMORY = "64m"
    PROXY_ROLE_NAME = "proxy"
    PROXY_CACHE_CONFIG = "sample-traditional-cache-config.xml"
    PROXY_OVERRIDE_CONFIG = ""
    PROXY_LOG_LEVEL = 6

    JMX_MEMORY = "64m"
    JMX_ROLE_NAME = "jmx"
    JMX_CACHE_CONFIG = "sample-traditional-cache-config.xml"
    JMX_OVERRIDE_CONFIG = ""
    JMX_LOG_LEVEL = 6
    JMX_PORT = 31234

    // STORAGE_INSTANCE_COUNT = 4 - how can this be passed so it varies per environment, but job specification is same
  }
}
