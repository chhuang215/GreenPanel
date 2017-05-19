"""controller.py"""
from ui import MainWindow
from led import LED as LEDModal
import pins as PINS

class UIController:
    """Controller for UI"""

    MAIN_UI = None

    @staticmethod
    def init_ui():
        """Instantiate the UI"""
        UIController.MAIN_UI = MainWindow()

    @staticmethod
    def get_ui():
        """Returns the main window, instantiate the UI if not instantiated yet"""
        if UIController.MAIN_UI is None:
            UIController.init_ui()

        return UIController.MAIN_UI

class Temperature:
    """Controller for Temperature modal"""
    @staticmethod
    def update_temperature(temp):
        """Update temperature display onto the UI"""
        if UIController.MAIN_UI is not None:
            UIController.MAIN_UI.panel_home.update_temperature_display(temp)

class LED:
    """Controller for LED modal"""
    @staticmethod
    def switch_yellow_led():
        """Turn switch of the yellow LED"""
        LEDModal.LED_LIST[str(PINS.PIN_YELLOW_LED)].switch()
