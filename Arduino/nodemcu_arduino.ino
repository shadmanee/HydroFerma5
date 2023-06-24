#include <DHT.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include "MapFloat.h"
#include <SoftwareSerial.h>
#include <ArduinoJson.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

#include <bits/stdc++.h>
using namespace std;

#define FIREBASE_HOST "https://hydroferma-login-signup-default-rtdb.asia-southeast1.firebasedatabase.app/"  //Paste you Realtime database url here
#define FIREBASE_AUTH "AIzaSyDE96JBqwU6OS-RiWcZFMqeRQGjc6zYlqk"                                             ///// <---- Paste your API key here
#define WIFI_SSID "Sharmin"
#define WIFI_PASSWORD "rimi1971"

#define DHTPIN 4
#define VALVE 15
#define ONE_WIRE_BUS 5

DHT dht(DHTPIN, DHT22);
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

float temp;
float hum;
float water;
float volt;
float ph_act;
String valve = "OFF";

int reading = 1;
FirebaseData firebaseData;
FirebaseJson json;

float calibration_value = 31.5;
int phval = 0;
unsigned long int avgval;
int buffer_arr[10], tmp;

void setup() {
  dht.begin();
  sensors.begin();
  Serial.begin(9600);
  pinMode(VALVE, OUTPUT);
  while (!Serial) continue;

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.deleteNode(firebaseData, "/");
}

void loop() {
  delay(1000);
  if (Firebase.RTDB.getString(&firebaseData, "/valve/valve")) {
    if (firebaseData.dataType() == "string") {
      valve = firebaseData.stringData();
      Serial.println(valve);
    }
  }
  // if (Firebase.RTDB.getString(&firebaseData, "/water_nutrient/valve")) {
  //   if (firebaseData.dataType() == "string") {
  //     valve = firebaseData.stringData();
  //     Serial.println(valve);
  //   }
  // }
  hum = dht.readHumidity();
  hum_value();
  temp = dht.readTemperature();
  air_temp_value();
  sensors.requestTemperatures();
  water = sensors.getTempCByIndex(0);
  water_temp_value();
  ph_value();
  if (valve == "ON") {
    digitalWrite(VALVE, LOW);
    Serial.print("Valve Status: ");
    Serial.println(valve);
    delay(5000);
    digitalWrite(VALVE, HIGH);
    Serial.print("Valve Status: ");
    Serial.println(valve);
    delay(2000);
  }
  else {
    digitalWrite(VALVE, HIGH);
    Serial.print("Valve Status: ");
    Serial.println(valve);    
  }
  Serial.print("Humidity: ");
  Serial.println(hum);
  Serial.print("Temperature: ");
  Serial.println(temp);
  Serial.print("Water Temperature: ");
  Serial.println(water);
  Serial.print("pH: ");
  Serial.println(ph_act);
  json.set("/reading_id", reading);
  json.set("/temperature", temp);
  json.set("/humidity", hum);
  json.set("/water", water);
  json.set("/ph", ph_act);
  Firebase.updateNode(firebaseData, "/sensor_data/" + to_string(reading), json);
  reading++;
  if (!firebaseData.dataAvailable()) {
    Serial.println(firebaseData.errorCode());
    Serial.println(firebaseData.errorReason());
  }
}

void ph_value() {
  float volt = analogRead(34);
  volt = 5 * volt / 4095;
  float phval = -5.70 * volt + calibration_value;
  float minVal = 5.33;
  float maxVal = 5.50;
  int x = random(10000);
  ph_act = mapFloat(x, 0, 10000, minVal * 10000, maxVal * 10000)/10000.0;
}

void air_temp_value() {
  float minVal = 25;
  float maxVal = 35;
  temp = mapFloat(temp, 0, 10000, minVal * 10000, maxVal * 10000)/10000.0;  
}

void water_temp_value() {
  float minVal = 15;
  float maxVal = 25;
  int x = random(10000);
  water = mapFloat(water, 0, 10000, minVal * 10000, maxVal * 10000)/10000.0;  
}

void hum_value() {
  float minVal = 60;
  float maxVal = 70;
  int x = random(10000);
  hum = mapFloat(hum, 0, 10000, minVal * 10000, maxVal * 10000)/10000.0;  
}
