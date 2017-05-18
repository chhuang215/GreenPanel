
from ui import MainUI
from led import LED as LEDModal
import pins as PINS

class UIController:
    MAIN_UI = None

    @staticmethod
    def init_ui():
        UIController.MAIN_UI = MainUI()

    @staticmethod
    def get_ui():
        if UIController.MAIN_UI is None:
            UIController.init_ui()

        return UIController.MAIN_UI

class Temperature:
    @staticmethod
    def update_temperature(temp):
        if(UIController.MAIN_UI is not None):
            UIController.MAIN_UI.panel_home.update_temperature_display(temp)

class LED:
    @staticmethod


    def switch_yellow_led():
        LEDModal.LED_LIST[str(PINS.PIN_YELLOW_LED)].switch()

