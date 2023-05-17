#include <SoftwareSerial.h>
#include <ArduinoJson.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

#include <bits/stdc++.h>
using namespace std;

#define FIREBASE_HOST "https://hydroferma-login-signup-default-rtdb.asia-southeast1.firebasedatabase.app/"  //Paste you Realtime database url here 
#define FIREBASE_AUTH "AIzaSyDE96JBqwU6OS-RiWcZFMqeRQGjc6zYlqk" ///// <---- Paste your API key here
#define WIFI_SSID "AI Lab"
#define WIFI_PASSWORD "ailab1004@mist"  

//D6 = Rx & D5 = Tx
SoftwareSerial nodemcu(4, 2);
int reading = 1;
FirebaseData firebaseData;
FirebaseJson json;


void setup() {
  // Initialize Serial port
  Serial.begin(9600);
  nodemcu.begin(9600);
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
  
  StaticJsonBuffer<1000> jsonBuffer;
  JsonObject& data = jsonBuffer.parseObject(nodemcu);

  if (data == JsonObject::invalid()) {
    //Serial.println("Invalid Json Object");
    jsonBuffer.clear();
    return;
  }

  Serial.println("JSON Object Recieved");
  Serial.print("Recieved Humidity:  ");
  float hum = data["humidity"];
  Serial.println(hum);
  Serial.print("Recieved Temperature:  ");
  float temp = data["temperature"];
  Serial.println(temp);
  Serial.print("Recieved Temperature:  ");
  float water = data["water"];
  Serial.println(water);
  Serial.println("-----------------------------------------");
  json.set("/reading_id", reading);  
  json.set("/temperature", temp);
  json.set("/humidity", hum);
  json.set("/water", water);
  Firebase.updateNode(firebaseData,"/sensor_data/" + to_string(reading), json);
  reading++;
  if (!firebaseData.dataAvailable()) {
    Serial.println(firebaseData.errorCode());
    Serial.println(firebaseData.errorReason());
  }

}