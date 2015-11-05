## Install runtime dependency

	> sudo apt-get install npm
	> sudo apt-get install nodejs-legacy
	> npm install
	> cd source/front-end
        > bower install

## Setup Serial port port config (TTY)

Make the file `source/back-end/GestureAnalyzer.js` point to the correct serial port to reach the Arduino.

Ex.

	DEFAULT_TTY_PORT = "/dev/ttyACM0";

## Gotchas. Default recording device need some config to work

```bash
> arecord -l
> export AUDIODEV=hw:1,0
> amixer cset numid=3 2
```

## Where to store ALSA custom configuration to identify playback device

A must read: [http://www.alsa-project.org/main/index.php/Asoundrc]

Then use file `~/.asoundrc` to store default playback card config

Example:

	> vi ~/.asoundrc
	> sudo /etc/init.d/alsa-utils reset


## Sample session with `arecord`

	> arecord -l
	**** List of CAPTURE Hardware Devices ****
	card 2: Microphone [Yeti Stereo Microphone], device 0: USB Audio [USB Audio]
	  Subdevices: 1/1
	  Subdevice #0: subdevice #0

	#
	# Use Device `hw:2` because of `card 2:`
	#

	> arecord -D hw:2 --dump-hw-params
	Recording WAVE 'stdin' : Unsigned 8 bit, Rate 8000 Hz, Mono
	HW Params of device "hw:2":
	--------------------
	ACCESS:  MMAP_INTERLEAVED RW_INTERLEAVED
	FORMAT:  S16_LE
	SUBFORMAT:  STD
	SAMPLE_BITS: 16
	FRAME_BITS: 32
	CHANNELS: 2
	RATE: [8000 48000]
	PERIOD_TIME: [1000 16384000]
	PERIOD_SIZE: [16 131072]
	PERIOD_BYTES: [64 524288]
	PERIODS: [2 1024]
	BUFFER_TIME: (666 32768000]
	BUFFER_SIZE: [32 262144]
	BUFFER_BYTES: [128 1048576]
	TICK_TIME: ALL
	--------------------
	arecord: set_params:1233: Sample format non available
	Available formats:
	- S16_LE

	#
	# Notice incompatibility:
	#   Recording WAVE 'stdin' : Unsigned 8 bit, Rate 8000 Hz, Mono
	# Using `Mono` but CHANNELS is 2

	> arecord abc.wav
	arecord: main:722: audio open error: No such file or directory

	#
	# Need to specify Device with -D
	#

	> arecord -D hw:2,0 abc.wav
	Recording WAVE 'abc.wav' : Unsigned 8 bit, Rate 8000 Hz, Mono
	arecord: set_params:1233: Sample format non available
	Available formats:
	- S16_LE

	#
	# Need to specify format with -f
	#

	> arecord -f S16_LE -D hw:2,0 abc.wav
	Recording WAVE 'abc.wav' : Signed 16 bit Little Endian, Rate 8000 Hz, Mono
	arecord: set_params:1239: Channels count non available

	#
	# Need to explicity specify the number of channel with -c
	#

	> arecord -c 2 -f S16_LE -D hw:2,0 abc.wav
	Recording WAVE 'abc.wav' : Signed 16 bit Little Endian, Rate 8000 Hz, Stereo
	^CAborted by signal Interrupt...

	# Got It! GOOD

User your `hw:2,0` string in source file `source/back-end/SoundRecorder.js` at line.

	ChildProcess.exec(command, {env: {AUDIODEV: "hw:2,0"}}, function(error, stdout, stderr) {


## Nuance Speach Setup

Edit `configuration.json` to provide your Nuance credential.

## Launching the app

Use the command `node bootstrap.js`
