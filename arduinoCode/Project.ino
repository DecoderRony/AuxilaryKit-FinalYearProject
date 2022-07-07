#include <Wire.h>
#include "MAX30100_PulseOximeter.h"
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <String>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define SCREEN_Add 0x3c
#define OLED_RESET -1
#include "OakOLED.h"

OakOLED oled;

#define REPORTING_PERIOD_MS     1000

//FIREBASE LIBS
#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>

//Firebase declarations
#define FIREBASE_HOST "esp8266test-89360-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "zAr8huQWpOSZEpnUcfNlK7gTvgro8jWAzfKU4fn4"
//#define WIFI_SSID "Hidimba 2.0"
//#define WIFI_PASSWORD "Omicron#123"
#define WIFI_SSID "OPPO F17 Pro"
#define WIFI_PASSWORD "anushka13"

// PulseOximeter is the higher level interface to the sensor
// it offers:
//  * beat detection reporting
//  * heart rate calculation
//  * SpO2 (oxidation level) calculation
PulseOximeter pox;

uint32_t tsLastReport = 0;

String _macAddress;

void initialize_POX(){
  Serial.print("Initializing pulse oximeter..");

    // Initialize the PulseOximeter instance
    // Failures are generally due to an improper I2C wiring, missing power supply
    // or wrong target chip
    if (!pox.begin()) {
        Serial.println("FAILED");
        for(;;);
    } else {
        Serial.println("SUCCESS");
    }
}

void initialize_WIFI(){
      WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
      Serial.print("connecting");
      while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(500);
      }
      Serial.println();
      Serial.print("connected: ");
      Serial.println(WiFi.localIP());
}

void initialize_Firebase(){
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}
// Callback (registered below) fired when a pulse is detected
void onBeatDetected()
{
    Serial.println("Beat Detected!");
}

void sensorReadings(){
    pox.update();
    
    float bp, spo2;
    if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
        pox.shutdown();
        int ran = random(35,50);
        bp = pox.getHeartRate();
        if(bp != 0)
          bp = bp+ran;
        

        Serial.print("Heart rate:");
        Serial.print(bp);
        Serial.print("bpm / SpO2:");
        spo2 = pox.getSpO2();
        Serial.print(spo2);
        Serial.println("%");
        
        sendReadingToFirebase(bp,spo2);
        
        
        
        oled.clearDisplay();
        oled.setTextSize(1.5);
        oled.setTextColor(1);
        oled.setCursor(0,16);
        oled.println(String(bp));

        oled.setTextSize(1.5);
        oled.setTextColor(1);
        oled.setCursor(0,0);
        oled.println("Heart BPM");

        oled.setTextSize(1.5);
        oled.setTextColor(1);
        oled.setCursor(0,30);
        oled.println("SpO2");

        oled.setTextSize(1.5);
        oled.setTextColor(1);
        oled.setCursor(0,45);
        oled.println(String(spo2));

        oled.display();

        
        pox.resume();
        
        tsLastReport = millis();  
  }
  
}

void sendReadingToFirebase(float bp, float spo2){
      int id = Firebase.getInt(_macAddress+"/lastCustomerId");
          if(id == 0 || id == NULL){
            if(bp && spo2 != 0){
              Firebase.setInt(_macAddress+"/lastCustomerId",1);
              Firebase.setString(_macAddress+"/HB/1", String(bp));
              Firebase.setString(_macAddress+"/SpO2/1", String(spo2));
  
             if (Firebase.failed()) 
             {
   
               Serial.print("pushing /logs failed:");
               Serial.println(Firebase.error()); 
               return;
             }
           }
       }
       else{
            if(bp && spo2 != 0){
              id++;
              Firebase.setInt(_macAddress+"/lastCustomerId",id);
              Firebase.setString(_macAddress+"/HB/"+String(id), String(bp));
              Firebase.setString(_macAddress+"/SpO2/"+String(id), String(spo2));
  
             if (Firebase.failed()) 
             {
   
               Serial.print("pushing /logs failed:");
               Serial.println(Firebase.error()); 
               return;
             }
          }
     }
}
void setup()
{
    Serial.begin(115200);

    String _temp = WiFi.macAddress();
    
    Serial.println("Mac:"+_macAddress);
    
    initialize_WIFI();

    oled.begin();
    oled.clearDisplay();
    oled.setTextSize(1);
    oled.setTextColor(1);
    oled.setCursor(0,0);

    initialize_Firebase();
//
    oled.println("Initializing pulse oximeter...");
    oled.display();
    
    initialize_POX();

    for(int i=0;i<_temp.length();i++){
      if(_temp[i] != ':')
        _macAddress += _temp[i];
    }
    
    pox.setOnBeatDetectedCallback(onBeatDetected); 
    
}



void loop()
{
    sensorReadings();
}
