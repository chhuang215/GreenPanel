"""main.py"""
# pylint: disable=E0611, C0111
import os
import sys

import RPi.GPIO as GPIO
from PyQt5.QtWidgets import QApplication

from controller import HardwareController, UIController

import water
import temperature
from led import LED
from lid import Lid

PINS = HardwareController.PIN

def main():
    # Set up GPIO
    GPIO.setmode(GPIO.BCM)
    #GPIO.setwarnings(False)
    GPIO.setup(PINS.YELLOW_LED, GPIO.OUT)
    GPIO.setup(PINS.BLUE_LED, GPIO.OUT)
    GPIO.setup(PINS.PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(PINS.WATER_LEVEL_SENSOR, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

    # initialize software modals of connected gpio hardwares
    HardwareController.add_gpio_component(Lid, PINS.PUSH_BUTTON)
    HardwareController.add_gpio_component(LED, PINS.YELLOW_LED, LED.ON)
    HardwareController.add_gpio_component(LED, PINS.BLUE_LED, LED.OFF)

    t_sensor_ref = temperature.TemperatureSensor
    if os.name == 'nt':
        t_sensor_ref = temperature.TemperatureSensorWindows

    HardwareController.add_gpio_component(t_sensor_ref, PINS.TEMPERATURE_SENSOR)
    HardwareController.add_gpio_component(water.WaterSensor, PINS.WATER_LEVEL_SENSOR)

    # controller.WaterLevel.SENSOR = water.WaterSensor(PINS.WATER_LEVEL_SENSOR)

    lid = HardwareController.get_gpio_component(PINS.PUSH_BUTTON)

    GPIO.add_event_detect(Lid.PIN, GPIO.BOTH, callback=lid.open_close)

    try:
        # start QT UI
        app = QApplication(sys.argv)

        # manually detect lid open close event from the start
        lid.open_close()

        ui_view = UIController.get_ui()
        ui_view.show()
        ui_view.showFullScreen()

        ret = app.exec_()
        sys.exit(ret)

    except KeyboardInterrupt:
        GPIO.cleanup()       # clean up GPIO on CTRL+C exit
    finally:
        GPIO.cleanup()

if __name__ == '__main__':
    main()
