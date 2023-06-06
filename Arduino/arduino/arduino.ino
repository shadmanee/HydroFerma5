//ThatsEngineering
//Sending Data from Arduino to NodeMCU Via Serial Communication
//Arduino code

//DHT11 Lib
#include <DHT.h>
#include <OneWire.h>
#include <DallasTemperature.h>

//Arduino to NodeMCU Lib
#include <SoftwareSerial.h>
#include <ArduinoJson.h>

//Initialise Arduino to NodeMCU (5=Rx & 6=Tx)
SoftwareSerial nodemcu(5, 6);

//Initialisation of DHT11 Sensor
#define DHTPIN 7
#define ONE_WIRE_BUS 2
#define PUMP 3
#define VALVE 4
DHT dht(DHTPIN, DHT22);
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
float temp;
float hum;
float water;
float ph_act;

float calibration_value = 28;
int phval = 0;
unsigned long int avgval;
int buffer_arr[10], tmp;

void setup() {
  Serial.begin(9600);

  dht.begin();
  sensors.begin();
  nodemcu.begin(9600);
  delay(1000);
  pinMode(PUMP, OUTPUT);
  Serial.println("Program started");
}

void loop() {

  // if (Serial.available() != 0) {
    String r = nodemcu.readString();
    Serial.println(r);
    if (r == "0") {
      digitalWrite(PUMP, LOW);
      Serial.println("pump on");
    }
    else if (r == "0") {
      digitalWrite(PUMP, HIGH);
      Serial.println("pump off");            
    }
    // else if (receivedChar == "2") {
    //   digitalWrite(VALVE, LOW);
    //   Serial.println("valve on");
    // }
    // else if (receivedChar == "3") {
    //   digitalWrite(VALVE, HIGH);
    //   Serial.println("valve off");
    // }
  // }

  StaticJsonBuffer<1000> jsonBuffer;
  JsonObject& data = jsonBuffer.createObject();

  //Obtain Temp and Hum data
  data_func();


  //Assign collected data to JSON Object
  data["humidity"] = hum;
  data["temperature"] = temp;
  data["water"] = water;
  data["ph"] = ph_act;

  //Send data to NodeMCU
  data.printTo(nodemcu);
  // jsonBuffer.clear();

  delay(2000);
}

void data_func() {

  for (int i = 0; i < 10; i++) {
    buffer_arr[i] = analogRead(A0);
    delay(30);
  }
  for (int i = 0; i < 9; i++) {
    for (int j = i + 1; j < 10; j++) {
      if (buffer_arr[i] > buffer_arr[j]) {
        tmp = buffer_arr[i];
        buffer_arr[i] = buffer_arr[j];
        buffer_arr[j] = tmp;
      }
    }
  }
  avgval = 0;
  for (int i = 2; i < 8; i++)
    avgval += buffer_arr[i];
  float volt = (float)avgval * 5.0 / 1024 / 6;
  ph_act = -5.70 * volt + calibration_value;

  hum = dht.readHumidity();
  temp = dht.readTemperature();
  sensors.requestTemperatures();
  water = sensors.getTempCByIndex(0);
  Serial.print("Humidity: ");
  Serial.println(hum);
  Serial.print("Temperature: ");
  Serial.println(temp);
  Serial.print("Water Temperature: ");
  Serial.println(water);
  Serial.print("pH: ");
  Serial.println(ph_act);
}