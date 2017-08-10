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
    lid = GPIOController.add_component(Lid, PIN.PUSH_BUTTON)

    # Lights
    main_light = GPIOController.add_component(LED, PIN.YELLOW_LED, LED.ON, timer=True)
    GPIOController.add_component(LED, PIN.BLUE_LED, LED.OFF)

    # Sensors
    GPIOController.add_component(temperature.TemperatureSensor, PIN.TEMPERATURE_SENSOR)
    GPIOController.add_component(water.WaterSensor, PIN.WATER_LEVEL_SENSOR)

    # Pump
    wpump = GPIOController.add_component(pump.WaterPump, PIN.WATER_PUMP)

    # Motor
    motr = GPIOController.add_component(motor.Motor, PIN.MOTOR)

    # Lid open/close event listen
    GPIO.add_event_detect(lid.pin, GPIO.BOTH, callback=lid.open_close)

    try:
        # start QT UI
        sargv = sys.argv + ['--style', 'material']
        app = QApplication(sargv)

        # manually detect lid open close event from the start
        lid.open_close()

        ui_view = UIController.get_ui()
        ui_view.show()
        ui_view.showFullScreen()

        ret = app.exec_()
        ## CLEANUP on APP EXIT ##

        # cleanup and deactive timers
       
        # GPIOController.get_component(PIN.WATER_PUMP).timer.deactivate()
        # GPIOController.get_component(PIN.YELLOW_LED).timer.deactivate()
        # mo = GPIOController.get_component(PIN.MOTOR)
        wpump.timer.deactivate()
        main_light.timer.deactivate()
        motr.timer.deactivate()
        motr.pwm.stop()
        # Teminate
        sys.exit(ret)

    except KeyboardInterrupt:
        GPIO.cleanup()       # clean up GPIO on CTRL+C exit
        
    finally:
        GPIO.cleanup()
        sys.exit()

if __name__ == '__main__':
    main()
