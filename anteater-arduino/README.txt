This is the Arduino code for 6MOB.  It is designed to run with the Red Bear Labs Blend Micro with a DHT11 sensor connected to Pin 8.

The code is in ble_temp_sensor/ble_temp_sensor.ino

To run, you will need to set up the Blend Micro and the DHT11 sensor.

To set up the Blend Micro, follow these instructions:

http://redbearlab.com/getting-started-blendmicro/

To set up DHT11, copy the DHT11 directory into your arduino/libraries directory, or follow the instructions here:

http://playground.arduino.cc/Main/DHT11Lib


In theory, these instructions should enable low power mode, but my experience suggests that they 1) make it difficult to re-program the device, and 2) cause the BLE connection to drop immediately after it starts.

http://redbearlab.com/blend-low-power-settings/
