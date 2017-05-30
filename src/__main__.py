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

    #initially manually detect lid open close event
    Lid.open_close()

    app = QApplication(sys.argv)

    ui_view_qml = controller.UIController.get_ui()
    # ui_view.showFullScreen()
    # ui_view.show()
 
    ui_view_qml.show()
    ui_view_qml.showFullScreen()

    ret = app.exec_()
    # clean up
    # GPIO.cleanup()
    sys.exit(ret)

def main():
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

if __name__ == '__main__':
    main()
