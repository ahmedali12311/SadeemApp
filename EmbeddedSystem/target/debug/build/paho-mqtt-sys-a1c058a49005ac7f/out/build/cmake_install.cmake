# Install script for directory: C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/m/target/debug/build/paho-mqtt-sys-a1c058a49005ac7f/out")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/doc/Eclipse Paho C/samples" TYPE FILE FILES
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/MQTTAsync_publish.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/MQTTAsync_publish_time.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/MQTTAsync_subscribe.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/MQTTClient_publish.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/MQTTClient_publish_async.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/MQTTClient_subscribe.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/paho_c_pub.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/paho_c_sub.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/paho_cs_pub.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/paho_cs_sub.c"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/src/samples/pubsub_opts.c"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/doc/Eclipse Paho C" TYPE FILE FILES
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/CONTRIBUTING.md"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/epl-v20"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/edl-v10"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/README.md"
    "C:/Users/oG_Ju/.cargo/registry/src/index.crates.io-6f17d22bba15001f/paho-mqtt-sys-0.9.0/paho.mqtt.c/notice.html"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/m/target/debug/build/paho-mqtt-sys-a1c058a49005ac7f/out/build/src/cmake_install.cmake")

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/m/target/debug/build/paho-mqtt-sys-a1c058a49005ac7f/out/build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/m/target/debug/build/paho-mqtt-sys-a1c058a49005ac7f/out/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
