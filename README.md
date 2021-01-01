# Script to subscribe to MQTT topic and transmit IR sequences

Designed for IR blaster type usage using the low-level ir-ctl command to learn
and transmit sequences.

This script has no understanding of individual command sequences making it
perfect for IR blaster type usage.

Intended for use on a small Linux device such as a Raspberry Pi Zero. It should
work on any Linux device supporting an IR transmitter and the ir-ctl and
mosquitto_sub commands.

Keep in mind that the IR transmitter may not be as powerful as commercial
IR blasters and will need to be close to the receiving device.

################################################################################

## Usage:

See below for installation instructions.

You'll also need to learn some sequences, again see below

Once configured, sequences can be transmitted by publisng on the configured
topic:
```
mosquitto_pub -h mqtt.example.com -t home/mqtt-ir/someroom/soundbar \
	-m 'sb123:power 4 sb123:tv 0.2 sb123:stereo'
```
The commands are formatted "device"command". In the above example, the device
is "sb123".

Any purely numeric values are delays in seconds. Decimal fractions may be used.
There is a (configurable) default delay between commands. If that delay is not
required, put a 0 (numeric zero) between commands.

################################################################################

## Learning Sequences

Transmit sequences are stored in the following directory structure

`${THISDIR}/remotes/${DEVICENAME}/${DEVICENAME}-{${COMMAND}.conf`

Use the ir-ctl command to learn sequences - example:

For single button presses
```
ir-ctl -1 -d /dev/lirc1 -r./fsr78/fsr78-power.conf
```

For longer sequences - Will be played back exactly as sent including delays
```
ir-ctl -d /dev/lirc1 -r./fsr78/fsr78-power.conf
```
Use Ctrl-C to stop

In both cases, there is no understanding of the actual sequence.
Note: Keep the remote close to the IR receiver when learning sequences

################################################################################

## Installation  On Raspberry Pi OS

This assumes an IR receiver/transmiter is connected, such as
http://raspberrypiwiki.com/Raspberry_Pi_IR_Control_Expansion_Board
https://smile.amazon.com/IR-Remote-Control-Transceiver-Raspberry/dp/B0713SK7RJ

Create/verify `mqtt-ir.conf` - At a minimum the MQTT broker options will need to
be set.

Verify hard coded paths and other information in mqtt-ir.service

Assuming use of Raspberry Pi GPIO, add to /boot/config.txt

################################################################################
```
dtoverlay=gpio-ir,gpio_pin=18
dtoverlay=gpio-ir-tx,gpio_pin=17
```
################################################################################
```
apt update
apt install mosquitto-clients v4l-utils

useradd -r -G video mqtt2ir
cp -p mqtt-ir.service /etc/systemd/system
systemctl daemon-reload
systemctl enable --now mqtt-ir
```
Reboot

Now learn some sequences
