from __future__ import print_function
import argparse
import airthings
#import paho.mqtt.client as mqtt
#import yaml
from ._version import __version__

def main():
    parser = argparse.ArgumentParser(prog="airthings-mqtt", description="Fetch readings/measurements from the Wave device and publish them to an MQTT server so that Home Assistant or some other application can consume them.")
    parser.add_argument('--version', action='version',
                        version='%(prog)s {version}'.format(version=__version__),
                        help="print package version")
    parser.add_argument("--config", dest="config", action="store",
                        help="the configuration file with details for the")
    parser.add_argument("command", choices=["discover", "fetch", "publish"], nargs="?", default="")

    args = parser.parse_args()

    if args.command == "discover":
        airthings_devices = airthings.discover_devices()
        print("Found %s Airthings device(s):" % len(airthings_devices))
        for device in airthings_devices:
            print("=" * 36)
            print("\tMAC address:", device.mac_address)
            print("\tIdentifier:", device.identifier)
            print("\tModel:", device.label)
            print("\tModel number:", device.model_number)
            print("\tHas measurements:", device.has_measurements)
            print("\tHumidity:", device.humidity)
            print("\tSensor capabilities:")
            for sensor, supported in device.sensor_capabilities.items():
                print("\t", sensor, "=", "YES" if supported else "NO")
