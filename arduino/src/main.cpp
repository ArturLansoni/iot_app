#include <Arduino.h>
#include <mqtt_service.h>

void setup()
{
  Serial.begin(115200);

  pinMode(pinPiezo, OUTPUT);

  setupWifi();
  setupMQTT();
}

void loop()
{
  if (!client.connected())
  {
    reconnect();
  }
  client.loop();
  delay(500);
}
