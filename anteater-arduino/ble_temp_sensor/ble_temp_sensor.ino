
/*

Copyright (c) 2012-2014 RedBearLab

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

/*
 *    Chat
 *
 *    Simple chat sketch, work with the Chat iOS/Android App.
 *    Type something from the Arduino serial monitor to send
 *    to the Chat App or vice verse.
 *
 */

//"services.h/spi.h/boards.h" is needed in every new project
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>

#include <dht11.h>

dht11 DHT11;

#define DHT11PIN 8


void setup()
{  
  // Default pins set to 9 and 8 for REQN and RDYN
  // Set your REQN and RDYN here before ble_begin() if you need
  //ble_set_pins(3, 2);
  
  // Set your BLE Shield name here, max. length 10
  ble_set_name("HILL3");  
    Serial.print("I'm alive!");

// Call the function to enable low power consumption
//   ble_low_power();

  // Init. and start BLE library.
  ble_begin();
  
  // Enable serial debug
    Serial.begin(57600);

}

unsigned char buf[16] = {0};
unsigned char len = 0;

static byte buf_len = 0;

void ble_write_string(char *bytes)
{
  len = strlen(bytes);
  if (buf_len + len > 20)
  {
    for (int j = 0; j < 15000; j++)
      ble_do_events();
    
    buf_len = 0;
  }
  
  for (int j = 0; j < len; j++)
  {
    ble_write(bytes[j]);
    buf_len++;
  }
    
  if (buf_len == 20)
  {
    for (int j = 0; j < 15000; j++)
      ble_do_events();
    
    buf_len = 0;
  }  
}

//Celsius to Fahrenheit conversion
double Fahrenheit(double celsius)
{
	return 1.8 * celsius + 32;
}


void loop()
{

  if ( ble_connected() ) {
            Serial.println("Sensing");

        int chk = DHT11.read(DHT11PIN);
        delay(5);

       // ble_write_string("Read sensor: ");
       // ble_do_events();
        switch (chk) {
 
          case DHTLIB_OK: 
		//ble_write_string("OK"); 
                //ble_write_string("Humidity (%): ");
                ble_write_string("H");
                char buf[10];  
                dtostrf(DHT11.humidity,4,2,buf);
                ble_write_string(buf);
                ble_write_string("D");
                Serial.println(buf);
                
                ble_write_string("T");
                dtostrf(Fahrenheit(DHT11.temperature),4,2,buf);
                ble_write_string(buf);
                ble_write_string("D");

		break;
          case DHTLIB_ERROR_CHECKSUM: 
		ble_write_string("EC"); 
		break;
          case DHTLIB_ERROR_TIMEOUT: 
		ble_write_string("ET"); 
		break;
          default: 
		ble_write_string("EU"); 
		break;
        }

        
        delay(1000);  

  }
//
//  Serial.print("Temperature (¬∞C): ");
//  Serial.println((float)DHT11.temperature, 2);
//
//  Serial.print("Temperature (¬∞F): ");
//  Serial.println(Fahrenheit(DHT11.temperature), 2);
//
//  Serial.print("Temperature (¬∞K): ");
//  Serial.println(Kelvin(DHT11.temperature), 2);
//
//  Serial.print("Dew Point (¬∞C): ");
//  Serial.println(dewPoint(DHT11.temperature, DHT11.humidity));
//
//  Serial.print("Dew PointFast (¬∞C): ");
//  Serial.println(dewPointFast(DHT11.temperature, DHT11.humidity));

//  delay();
//  
//  if ( ble_available() )
//  {
//    while ( ble_available() )
//      Serial.write(ble_read());
//      
//    Serial.println();
//  }
//  
//  if ( Serial.available() )
//  {
//    delay(5);
//    
//    while ( Serial.available() )
//        ble_write( Serial.read() );
//  }
  ble_do_events();
}

  
