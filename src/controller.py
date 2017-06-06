"""controller.py"""
# from ui import MainWindow
import RPi.GPIO as GPIO
from ui import MainWindow
from led import LED
from lid import Lid

import pins as PINS
import temperature
import water

class UIController:
    """Controller for UI"""

    MAIN_UI = None
    # MAIN_UI_QML = None
    @staticmethod
    def init_ui():
        """Instantiate the UI"""
        # UIController.MAIN_UI = MainWindow()
        print("UI inited")
        UIController.MAIN_UI = MainWindow()

    @staticmethod
    def get_ui():
        """Returns the main window, instantiate the UI if not instantiated yet"""
        if UIController.MAIN_UI is None:
            UIController.init_ui()

        # print(UIController.MAIN_UI, UIController.MAIN_UI_QML)
        return UIController.MAIN_UI

class GPIOController:
    pass
    #@staticmethod
    # def init_gpio_components():
    #     Lid.PIN = PINS.PIN_PUSH_BUTTON
    #     LED.add_led(PINS.PIN_YELLOW_LED, LED.ON)
    #     LED.add_led(PINS.PIN_BLUE_LED)

    #     import os
    #     if os.name == 'nt':
    #         Temperature.SENSOR = temperature.TemperatureSensorWindows()
    #     else:
    #         Temperature.SENSOR = temperature.TemperatureSensor()


    #     WaterLevel.SENSOR = water.WaterSensor(PINS.PIN_WATER_LEVEL_SENSOR)

    #     GPIO.add_event_detect(Lid.PIN, GPIO.BOTH, callback=Lid.open_close)
    #     GPIO.add_event_detect(WaterLevel.SENSOR.pin, GPIO.BOTH,
    #                           callback=WaterLevel.SENSOR.water_level_detect, bouncetime=1)

class Temperature:
    """Controller for Temperature modal"""
    SENSOR = None

    @staticmethod
    def get_temperature():
        """Update temperature display onto the UI"""
        return str(Temperature.SENSOR.get_temp_c())

class WaterLevel:
    SENSOR = None

class LightController:
    """Controller for LED modal"""
    @staticmethod
    def switch_yellow_led():
        """Turn switch of the yellow LED"""
        LED.LED_LIST[str(PINS.PIN_YELLOW_LED)].switch()
