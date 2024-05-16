# IoT App: MQTT and Flutter

This project is a study case that demonstrates the interaction between a Flutter app and an Arduino board using the MQTT protocol.

## Arduino Setup

The Arduino code is located in the `/arduino` directory. To run the code, you need to update the Wi-Fi credentials in `arduino/include/wifi_config.h`:

```cpp
const char *ssid = "your_wifi_ssid";
const char *password = "your_wifi_password";
```

Replace `your_wifi_ssid` and `your_wifi_password` with your actual Wi-Fi SSID and password.

An image of the circuit can be found at **`arduino/circuit.png`**. This will help you understand how to connect the components.

## Flutter App Setup

### Prerequisites

- Flutter SDK: Make sure you have Flutter installed on your machine. If not, you can download it from [here](https://flutter.dev/docs/get-started/install).

### Installation

1. Clone the repository:

```bash
git clone https://github.com/ArturLansoni/iot_app.git
```

2. Install Flutter packages:

```bash
flutter pub get
```

### Running the App

To run the app, use the following command:

```bash
flutter run
```
