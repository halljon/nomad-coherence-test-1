// NOTE: HACKING ABOUT TRYING IDEAS - POC ONLY
job "project-1-prod" {
  //  region = "europe"

  datacenters = [
    "dc1"
  ]

  group "storage" {
    count = 6

    task "storage-instance" {
      //      constraint {
      //        attribute = "${meta.jvm_placement}"
      //        value = "server1"
      //      }

      artifact {
        source = "${NOMAD_META_COHERENCE_ARTIFACT_SOURCE}"
      }

      artifact {
        source = "https://raw.githubusercontent.com/halljon/nomad-coherence-test-1/main/sample-cache-config.xml"
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
          "-Dcom.sun.management.jmxremote",
          "-Dcoherence.management=all",
          "-Dcoherence.management.remote=true",
          "-Dcoherence.member=${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_STORAGE_ROLE_NAME}-${NOMAD_ALLOC_INDEX}"
        ]
      }
    }
  }

  // Need access to log files and GC files.

//  group "proxy" {
//    count = 1
//
//    task "proxy-instance" {
//      //      constraint {
//      //        attribute = "${meta.jvm_placement}"
//      //        value = "server1"
//      //      }
//
//      driver = "java"
//
//      config {
//        jar_path = "${NOMAD_META_COHERENCE_HOME}/coherence.jar"
//        jvm_options = [
//          "-server",
//          "-Xmx${NOMAD_META_PROXY_MEMORY}",
//          "-Xms${NOMAD_META_PROXY_MEMORY}",
//          "-Dcoherence.cluster=${NOMAD_META_CLUSTER_NAME}",
//          "-Dcoherence.site=${NOMAD_META_SITE_NAME}",
//          "-Dcoherence.rack=${NOMAD_META_RACK_NAME}",
//          "-Dcoherence.machine=${NOMAD_META_MACHINE_NAME}",
//          "-Dcoherence.role=${NOMAD_META_PROXY_ROLE_NAME}",
//          "-Dcoherence.log=${NOMAD_META_MEMBER_NAME}.log",
//          "-Dcoherence.management=all",
//          "-Dcoherence.management.remote=true",
//          "-Dcom.sun.management.jmxremote",
//          "-Dcoherence.member=${NOMAD_META_MEMBER_NAME}"
//        ]
//      }
//
//      meta {
//        MACHINE_NAME = "${attr.unique.hostname}"
//        MEMBER_NAME = "${NOMAD_TASK_DIR}/${NOMAD_META_CLUSTER_NAME}-${attr.unique.hostname}-${NOMAD_META_PROXY_ROLE_NAME}-${NOMAD_ALLOC_INDEX}"
//      }
//      //
//      //      group "jmx-management" {
//      //      }
//      //
//      //      group "data-loading" {
//      //      }
//      //
//      //      group "house-keeping" {
//      //      }
//    }
//  }

  meta {
    CLUSTER_NAME = "prod"
    CLUSTER_TTL = "1"
    CLUSTER_DEFAULT_CACHE_CONFIG = "sample-cache-config.xml"
    CLUSTER_DEFAULT_OVERRIDE_CONFIG = ""

    SITE_NAME = "site-name"
    RACK_NAME = "rack-name"

    COHERENCE_JAR = "coherence-20.06.1.jar"
    COHERENCE_ARTIFACT_SOURCE = "https://repo1.maven.org/maven2/com/oracle/coherence/ce/coherence/20.06.1/coherence-20.06.1.jar"

    STORAGE_MEMORY = "64m"
    STORAGE_ROLE_NAME = "storage"
    STORAGE_CACHE_CONFIG = "sample-cache-config.xml"
    STORAGE_OVERRIDE_CONFIG = ""
    STORAGE_LOG_LEVEL = 6
    STORAGE_INSTANCE_COUNT = 4

    PROXY_MEMORY = "64m"
    PROXY_ROLE_NAME = "proxy"
    PROXY_CACHE_CONFIG = "${NOMAD_META_CLUSTER_DEFAULT_CACHE_CONFIG}"
    PROXY_OVERRIDE_CONFIG = ""
    PROXY_LOG_LEVEL = 7
    PROXY_INSTANCE_COUNT = 1

    JMX_MEMORY = "64m"
    JMX_ROLE_NAME = "jmx"
    JMX_CACHE_CONFIG = "${NOMAD_META_CLUSTER_DEFAULT_CACHE_CONFIG}"
    JMX_OVERRIDE_CONFIG = ""
    JMX_LOG_LEVEL = 5
    JMX_INSTANCE_COUNT = 1
  }
}
