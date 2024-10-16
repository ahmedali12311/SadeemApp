#include <WiFi.h>
#include <PubSubClient.h>
#include <WebServer.h>
#include <ArduinoJson.h> // Include the ArduinoJson library

const char* ssid = "Wokwi-GUEST"; // Use Wokwi guest WiFi
const char* password = ""; // No password needed
const char* mqtt_server = "broker.emqx.io"; // MQTT broker address

const int redPin = 12;
const int greenPin = 14;

WiFiClient espClient;
PubSubClient client(espClient);
WebServer server(80);

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  
  // Parse the JSON message
  StaticJsonDocument<200> doc;
  DeserializationError error = deserializeJson(doc, payload);

  if (error) {
    Serial.print("Failed to parse JSON: ");
    Serial.println(error.f_str());
    return;
  }

  // Check for the command in the JSON
  const char* command = doc["command"]; // Expecting a JSON key "command"
  if (command) {
    if (strcmp(command, "red") == 0) {
      digitalWrite(redPin, HIGH);
      digitalWrite(greenPin, LOW);
    } else if (strcmp(command, "green") == 0) {
      digitalWrite(redPin, LOW);
      digitalWrite(greenPin, HIGH);
    }
  }
}
void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "ESP32Client-" + String(random(0xffff), HEX); // Unique Client ID
    if (client.connect(clientId.c_str())) { // Connect using only the client ID
      Serial.println("connected");
      client.subscribe("esp32/commands");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  digitalWrite(redPin, LOW);
  digitalWrite(greenPin, LOW);

  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);

  reconnect(); // Attempt to connect on startup
  server.begin();
  Serial.println("Server started");
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  server.handleClient();
}
