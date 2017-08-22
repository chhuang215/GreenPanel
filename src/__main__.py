"""main.py"""
# pylint: disable=E0611, C0111
import sys

import RPi.GPIO as GPIO
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import QApplication

import db

from controller import GPIOController, UIController

import water
import temperature
import pump
import motor
import notifier
from led import LED
from lid import Lid
import slots

db.init()

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

    # Lid
    lid = GPIOController.add_component(Lid, PIN.PUSH_BUTTON)

    # Lights
    main_light = GPIOController.add_component(LED, PIN.YELLOW_LED, LED.ON, enable_timer=True)
    GPIOController.add_component(LED, PIN.BLUE_LED, LED.OFF)

    # Temperature Sensor
    GPIOController.add_component(temperature.TemperatureSensor, PIN.TEMPERATURE_SENSOR)

    # Water Sensor
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
        font = QFont()
        font.setFamily("Ariel")

        app.setFont(font)
        # manually detect lid open close event from the start
        lid.open_close()

        slots.syncdb()

        ui_view = UIController.get_ui()
        ui_view.show()
        ui_view.showFullScreen()

        notifier.NOTIFIER.lst_functions.append(slots.check_slots)
        notifier.NOTIFIER.lst_functions.append(ui_view.refresh_slots_status)
        notifier.NOTIFIER.activate()

        ret = app.exec_()

        # Teminate
        sys.exit(ret)

    finally:
        # cleanup and deactive timers
        notifier.NOTIFIER.deactivate()
        wpump.timer.deactivate()
        main_light.timer.deactivate()
        motr.timer.deactivate()
        motr.pwm.stop()
        
        GPIO.cleanup()


if __name__ == '__main__':
    main()
