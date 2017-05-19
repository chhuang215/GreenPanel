"""main.py"""
# pylint: disable=E0611, C0111

import sys

import RPi.GPIO as GPIO

from PyQt5.QtWidgets import QApplication

import controller

import pins as PINS
import temperature
from temperature import Temperature
from lid import Lid
from led import LED


def start_app():
    import os
    
    if os.name == 'nt':
        temperature_module = temperature.TemperatureWindows()
    else:
        temperature_module = Temperature()

    temperature_module.start()

    Lid.open_close()

    app = QApplication(sys.argv)
    ui_view = controller.UIController.get_ui()
    ui_view.showFullScreen()
    ui_view.show()
    ret = app.exec_()
    # clean up
    # GPIO.cleanup()
    sys.exit(ret)


# Set up GPIO
GPIO.setmode(GPIO.BCM)
#GPIO.setwarnings(False)
GPIO.setup(PINS.PIN_YELLOW_LED, GPIO.OUT)
GPIO.setup(PINS.PIN_BLUE_LED, GPIO.OUT)
GPIO.setup(PINS.PIN_PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)

LED(LED.ON, PINS.PIN_YELLOW_LED)
LED(LED.OFF, PINS.PIN_BLUE_LED)

GPIO.add_event_detect(PINS.PIN_PUSH_BUTTON, GPIO.BOTH,
                      callback=Lid.open_close)

try:
    start_app()

except KeyboardInterrupt:
    GPIO.cleanup()       # clean up GPIO on CTRL+C exit
finally:
    GPIO.cleanup()
