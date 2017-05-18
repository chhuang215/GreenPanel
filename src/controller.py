
from ui import MainUI
from led import LED as LEDModal
import pins as PINS

class Controller:
    MAIN_UI = None

    @staticmethod
    def init_ui():
        Controller.MAIN_UI = MainUI()

class Temperature:
    @staticmethod
    def update_temperature(temp):
        if(Controller.MAIN_UI is not None):
            homepanel = Controller.MAIN_UI.panels[0]
            homepanel.update_temperature_display(temp)

class LED:
    @staticmethod
    def switch():
        LEDModal.LED_LIST[str(PINS.PIN_YELLOW_LED)].switch()

def get_ui():
    if Controller.MAIN_UI is None:
        Controller.init_ui()

    return Controller.MAIN_UI
