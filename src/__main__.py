"""main.py"""
# pylint: disable=E0611, C0111
import sys
import os
import RPi.GPIO as GPIO
from PyQt5.QtGui import QFont, QGuiApplication
# from PyQt5.QtWidgets import QApplication

import db

from controller import GPIOController, UIController
import ui
import water
import temperature
import pump
import motor
from led import LED, LightTimer
from lid import Lid
import slots

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

    settings = db.get_setting() #user settings

    # Lid
    lid = Lid(PIN.PUSH_BUTTON)
    GPIOController.add_component(lid)

    # Lights
    main_light = LED(PIN.YELLOW_LED)
    main_light.timer = LightTimer(main_light, settings["light_hour"], settings["light_duration"])
    GPIOController.add_component(main_light)

    secondary_light = LED(PIN.BLUE_LED)
    GPIOController.add_component(secondary_light)

    # Temperature Sensor
    tsensor = temperature.TemperatureSensor(PIN.TEMPERATURE_SENSOR)
    GPIOController.add_component(tsensor)

    # Water Sensor
    wsensor = water.WaterSensor(PIN.WATER_LEVEL_SENSOR)
    GPIOController.add_component(wsensor)

    # Pump
    wpump = pump.WaterPump(PIN.WATER_PUMP)
    GPIOController.add_component(wpump)

    # Motor
    motr = motor.Motor(*PIN.MOTOR, enable_timer=True)
    GPIOController.add_component(motr)

    # Lid open/close event listen
    GPIO.add_event_detect(lid.pin, GPIO.BOTH, callback=lid.open_close)

    try:
        # start QT UI
        sargv = sys.argv + ['-style', 'material']
        app = QGuiApplication(sargv)
        font = QFont()
        font.setFamily("Ariel")

        app.setFont(font)
        # manually detect lid open close event from the start
        lid.open_close()

        slots.syncdb()

        # Instantiate the UI
        UIController.MAIN_UI = ui.MainWindow()
        print("UI inited")
        UIController.MAIN_UI.root.show()
        if os.name == "posix" and os.uname().nodename.startswith("raspberrypi"):
            UIController.MAIN_UI.root.showFullScreen()

        # Start threads and timers
        tsensor.start()
        slots.REFRESH_TIMER.activate()
        main_light.timer.activate()
        wpump.timer.activate()
        motr.timer.activate()

        ret = app.exec_()

        # Teminate
        sys.exit(ret)

    finally:
        # cleanup and deactive timers
        slots.REFRESH_TIMER.deactivate()
        wpump.timer.deactivate()
        main_light.timer.deactivate()
        motr.timer.deactivate()
        motr.pwm.stop()

        GPIO.cleanup()


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == "resetdb":
        db.reset_all()
    main()
