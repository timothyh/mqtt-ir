#!/bin/bash --

# Transmits a string of IR commands
#
# Uses ir-ctl command which needs write access to IR transmit device
#
# Usage: $0 command|delay command|delay ....
#
# Command is of form device:command
# Delay is any numeric value representing delay in seconds
#
# All arguments must be valid, otherwise nothing is transmitted

MYDIR=$(dirname $0)
MYNAME=$(basename $0 .sh)

[ -z "$MYCONFIG" ] && MYCONFIG="$MYDIR/$MYNAME.conf"
source "$MYCONFIG"

_ir_test() {
	[ -s ${IR_SEND_DIR}/${REMOTE}/${REMOTE}-${COMMAND}.conf ]
	return $?
}

_ir_send() {
	$IR_CTL -s${IR_SEND_DIR}/${REMOTE}/${REMOTE}-${COMMAND}.conf
	return $?
}

_process_payload() {
	NEXT_DELAY=0
	for CMD in $PAYLOAD; do
	if [[ "$CMD" =~ ^[0-9.]+$ ]]; then
		NEXT_DELAY="$NEXT_DELAY $CMD"
	elif [[ "$CMD" =~ ^([[:alnum:]]+):([[:alnum:]]+)$ ]]; then
		REMOTE="${BASH_REMATCH[1]}"
		COMMAND="${BASH_REMATCH[2]}"
		if [ "$DOIT" == yes ] ; then

			[ -z "$NEXT_DELAY" ] && NEXT_DELAY="$DELAY_XMIT"
			if [ "$NEXT_DELAY" != '0' ] ; then
				[ "$VERBOSE" == yes ] &&  echo "Delay $NEXT_DELAY"
				sleep $NEXT_DELAY
			fi
			NEXT_DELAY=''

			# echo send "$REMOTE => $COMMAND"
			[ "$VERBOSE" == yes ] &&  echo "Send $REMOTE:$COMMAND"
			_ir_send $REMOTE $COMMAND
		else
			if ! _ir_test $REMOTE $COMMAND ; then
				echo "No such command: $REMOTE:$COMMAND" >&2
				ERR=yes
			fi
		fi
	else
		echo "Unidentified string: $CMD" >&2
		ERR=yes
	fi
	done
}

if [ "$1" == '-v' ] ; then
	VERBOSE=yes
	shift
fi

PAYLOAD="$@"
[ -z "$PAYLOAD" ] && exit 1
_process_payload
if [ "$ERR" == yes ] ; then
	echo "Invalid sequence: \"$PAYLOAD\""
	exit 1
fi
echo "Verified \"$PAYLOAD\""
DOIT=yes
_process_payload
exit 0
