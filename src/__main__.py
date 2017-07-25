"""main.py"""
# pylint: disable=E0611, C0111
import sys

import RPi.GPIO as GPIO
from PyQt5.QtWidgets import QApplication

from controller import GPIOController, UIController

import water
import temperature
import pump
import motor
from led import LED
from lid import Lid

PIN = GPIOController.PIN

def main():
    # Set up GPIO
    GPIO.setmode(GPIO.BCM)
    #GPIO.setwarnings(False)
    GPIO.setup(PIN.YELLOW_LED, GPIO.OUT)
    GPIO.setup(PIN.BLUE_LED, GPIO.OUT)
    GPIO.setup(PIN.MOTOR, GPIO.OUT)
    GPIO.setup(PIN.WATER_PUMP, GPIO.OUT)
    GPIO.setup(PIN.PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(PIN.WATER_LEVEL_SENSOR, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    
    

    ### initialize software modals of connected gpio hardwares ###


    GPIOController.add_component(Lid, PIN.PUSH_BUTTON)

    # Lights
    GPIOController.add_component(LED, PIN.YELLOW_LED, LED.ON, timer=True)
    GPIOController.add_component(LED, PIN.BLUE_LED, LED.OFF)

    # Sensors
    # GPIOController.add_component(Lid, PIN.PUSH_BUTTON)
    GPIOController.add_component(temperature.TemperatureSensor, PIN.TEMPERATURE_SENSOR)
    GPIOController.add_component(water.WaterSensor, PIN.WATER_LEVEL_SENSOR)

    # Lid open/close event listen
    lid = GPIOController.get_component(PIN.PUSH_BUTTON)
    GPIO.add_event_detect(lid.pin, GPIO.BOTH, callback=lid.open_close)

    GPIOController.add_component(pump.WaterPump, PIN.WATER_PUMP)
    GPIOController.add_component(motor.Motor, PIN.MOTOR)

    try:
        # start QT UI
        app = QApplication(sys.argv)

        # manually detect lid open close event from the start
        lid.open_close()

        ui_view = UIController.get_ui()
        ui_view.show()
        ui_view.showFullScreen()

        ret = app.exec_()
        ## CLEANUP on APP EXIT ##

        # deactive timers
        # GPIOController.deactive_timers()
        GPIOController.get_component(PIN.WATER_PUMP).timer.deactivate()
        GPIOController.get_component(PIN.YELLOW_LED).timer.deactivate()
        GPIOController.get_component(PIN.MOTOR[0]).timer.deactivate()
        # Teminate
        sys.exit(ret)

    except KeyboardInterrupt:
        GPIO.cleanup()       # clean up GPIO on CTRL+C exit
    finally:
        GPIO.cleanup()

if __name__ == '__main__':
    main()
