"""main.py"""
# pylint: disable=E0611, C0111

import sys

import RPi.GPIO as GPIO

from PyQt5.QtCore import QTimer
from PyQt5.QtWidgets import QApplication

import controller

import pins as PINS
import controller
from lid import Lid
from led import LED



def start_app():

    controller.Temperature.init_sensors()

    Lid.open_close()

    app = QApplication(sys.argv)

    ui_view = controller.UIController.get_ui()

    temperature_display_timer = QTimer()
    temperature_display_timer.timeout.connect(ui_view.panel_home.update_temperature_display)
    # get_temperature_timer.setInterval(1000)
    temperature_display_timer.start(5000) # milliseconds

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
