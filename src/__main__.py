"""main.py"""
# pylint: disable=E0611, C0111
import os
import sys

import RPi.GPIO as GPIO
from PyQt5.QtWidgets import QApplication

import controller
import pins as PINS
import water
import temperature
from led import LED
from lid import Lid

def main():
    # Set up GPIO
    GPIO.setmode(GPIO.BCM)
    #GPIO.setwarnings(False)
    GPIO.setup(PINS.PIN_YELLOW_LED, GPIO.OUT)
    GPIO.setup(PINS.PIN_BLUE_LED, GPIO.OUT)
    GPIO.setup(PINS.PIN_PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(PINS.PIN_WATER_LEVEL_SENSOR, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

    Lid.PIN = PINS.PIN_PUSH_BUTTON
    controller.LightController.add_light(PINS.PIN_YELLOW_LED, LED.ON)
    controller.LightController.add_light(PINS.PIN_BLUE_LED)

    if os.name == 'nt':
        controller.Temperature.SENSOR = temperature.TemperatureSensorWindows()
    else:
        controller.Temperature.SENSOR = temperature.TemperatureSensor()


    controller.WaterLevel.SENSOR = water.WaterSensor(PINS.PIN_WATER_LEVEL_SENSOR)

    GPIO.add_event_detect(Lid.PIN, GPIO.BOTH, callback=Lid.open_close)
    # GPIO.add_event_detect(controller.WaterLevel.SENSOR.pin, GPIO.BOTH,
    #                       callback=controller.WaterLevel.SENSOR.water_level_detect, bouncetime=1)

    try:
        # start QT UI
        app = QApplication(sys.argv)

        # manually detect lid open close event from the start
        Lid.open_close()

        # manually detect water sensor event from the start
        # controller.WaterLevel.SENSOR.water_level_detect(controller.WaterLevel.SENSOR.pin)

        ui_view = controller.UIController.get_ui()
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
