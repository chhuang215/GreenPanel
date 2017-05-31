"""main.py"""
# pylint: disable=E0611, C0111

import sys

import RPi.GPIO as GPIO
from PyQt5.QtWidgets import QApplication

import controller

import pins as PINS
from lid import Lid

def start_app():


    # manually detect lid open close event from the start
    Lid.open_close()

    # manually detect water sensor event from the start
    controller.WaterLevel.SENSOR.water_level_detect(controller.WaterLevel.SENSOR.pin)

    # start QT UI
    app = QApplication(sys.argv)

    ui_view = controller.UIController.get_ui()
    ui_view.show()
    ui_view.showFullScreen()

    ret = app.exec_()
    sys.exit(ret)

def main():
    # Set up GPIO
    GPIO.setmode(GPIO.BCM)
    #GPIO.setwarnings(False)
    GPIO.setup(PINS.PIN_YELLOW_LED, GPIO.OUT)
    GPIO.setup(PINS.PIN_BLUE_LED, GPIO.OUT)
    GPIO.setup(PINS.PIN_PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(PINS.PIN_WATER_LEVEL_SENSOR, GPIO.IN)

    # initialize gpio components
    controller.GPIOController.init_gpio_components()



    try:
        start_app()

    except KeyboardInterrupt:
        GPIO.cleanup()       # clean up GPIO on CTRL+C exit
    finally:
        GPIO.cleanup()

if __name__ == '__main__':
    main()
