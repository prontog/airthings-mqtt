# Get Readings from an Airthings Wave and publish to MQTT server

Fetch readings/measurements from [Airthings](http://airthings.com) air monitor devices
and publish them to an *MQTT* server so that *Home Assistant* or some other application
can consume them.

The project is inspired from [airthingswave-mqtt](https://github.com/hpeyerl/airthingswave-mqtt)
and supports the same configuration format.

It uses the [airthings](https://github.com/kotlarz/airthings) *Python* package to
communicate with the Airthings devices and [paho-mqtt](https://pypi.org/project/paho-mqtt/)
to access the *MQTT* server.

## Installation

The instructions below are for *Raspberry Pi OS* but could also run on other
*debian* based distros on computers that support Bluetooth:

```bash
git clone https://github.com/prontog/airthings-mqtt
make install-debian
```

## Integration with Home Assistant

TODO

## Configuration

TODO

## Developing

The instructions below are for *Raspberry Pi OS* but could also run on other
*debian* based distros on computers that support Bluetooth:

```bash
# Install dependencies from apt repo
sudo apt-get update
sudo apt-get install python3-pip libglib2.0-dev python3-virtualenv
# Create virtual .venv for development
make devel-env
```

Then try to scan for devices with:
```bash
source .venv/bin/activate
sudo --preserve-env=PATH .venv/bin/airthings-mqtt discover
```

Run `make help` for the available targets.
