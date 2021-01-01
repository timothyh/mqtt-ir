#!/bin/sh
#
# Common functions used by shell scripts
# Mainly used to simplify broker configuration and authentication
#
# Note that when running as systemd service some things don't work as expected
# In particular, hostname and dnsdomainname commands don't work making
# service lookups ineffective.
#

MQTT_OPTS=''

[ -n "$MQTT_CAFILE" ] && MQTT_OPTS="$MQTT_OPTS --cafile $MQTT_CAFILE"
[ -n "$MQTT_HOST" ] && MQTT_OPTS="$MQTT_OPTS --host $MQTT_HOST"
[ -n "$MQTT_PASSWORD" ] && MQTT_OPTS="$MQTT_OPTS --pw $MQTT_PASSWORD"
[ -n "$MQTT_PORT" ] && MQTT_OPTS="$MQTT_OPTS --port $MQTT_PORT"
[ -n "$MQTT_URL" ] && MQTT_OPTS="$MQTT_OPTS --url $MQTT_URL"
[ -n "$MQTT_USERNAME" ] && MQTT_OPTS="$MQTT_OPTS --username $MQTT_USERNAME"

_mqtt_pub() {
        mosquitto_pub $MQTT_OPTS "$@"
}

_mqtt_sub() {
        mosquitto_sub $MQTT_OPTS "$@"
}
