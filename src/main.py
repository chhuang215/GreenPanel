"""main.py"""
# pylint: disable=E0611, C0111

import sys

import RPi.GPIO as GPIO

from PyQt5.QtWidgets import QApplication

import pins as PINS
from lid import Lid
from led import LED

from ui.main import MainUI

'''
    Main UI for the control
'''

if __name__ == '__main__':
    # Set up GPIO
    GPIO.setmode(GPIO.BCM)
    #GPIO.setwarnings(False)
    GPIO.setup(PINS.PIN_YELLOW_LED, GPIO.OUT)
    GPIO.setup(PINS.PIN_BLUE_LED, GPIO.OUT)
    GPIO.setup(PINS.PIN_PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    LED(1, PINS.PIN_YELLOW_LED)
    LED(0, PINS.PIN_BLUE_LED)

    GPIO.add_event_detect(PINS.PIN_PUSH_BUTTON, GPIO.BOTH,
                          callback=Lid.open_close)

    try:
        APP = QApplication(sys.argv)
        ex = MainUI()
        RET = APP.exec_()
        # clean up
        GPIO.cleanup()
        sys.exit(RET)

    except KeyboardInterrupt:
        GPIO.cleanup()       # clean up GPIO on CTRL+C exit

