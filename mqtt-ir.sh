#!/bin/bash --

MYDIR=$(dirname $0)
MYNAME=$(basename $0 .sh)

[ -z "$MYCONFIG" ] && export MYCONFIG=$MYDIR/$MYNAME.conf
source $MYCONFIG

source $MYDIR/mqtt-funcs.sh

[ "$1" == '-v' ] && VERBOSE='-v'

_mqtt_sub -R -t $MQTT_TOPIC | (
	echo "Listing to topic $MQTT_TOPIC"
	while read PAYLOAD; do
		[ "$VERBOSE" == '-v' ] && echo "Received: $PAYLOAD"
		$MYDIR/ir-xmit.sh $VERBOSE $PAYLOAD
	done
)
