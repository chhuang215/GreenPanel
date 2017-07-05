"""controller.py"""
from ui import MainWindow

class UIController:
    """Controller for UI"""

    MAIN_UI = None
    @staticmethod
    def init_ui():
        """Instantiate the UI"""
        print("UI inited")
        UIController.MAIN_UI = MainWindow()

    @staticmethod
    def get_ui():
        """Returns the main window, instantiate the UI if not instantiated yet"""
        if UIController.MAIN_UI is None:
            UIController.init_ui()

        return UIController.MAIN_UI

class HardwareController:
    '''Hardware Controller'''

    class PIN:
        '''Pin enum from representing hardware's corresponding GPIO pin number'''
        YELLOW_LED = 18
        BLUE_LED = 17
        PUSH_BUTTON = 23
        WATER_LEVEL_SENSOR = 25
        TEMPERATURE_SENSOR = 4

    GPIO_COMPONENTS = {}

    @staticmethod
    def add_gpio_component(component, pin, *argv, **kwargs):

        HardwareController.GPIO_COMPONENTS[str(pin)] = component(pin, *argv, **kwargs)

    @staticmethod
    def get_gpio_component(pin):
        if not isinstance(pin, str):
            pin = str(pin)
        return HardwareController.GPIO_COMPONENTS[pin]
    
    @staticmethod
    def deactive_timers():
        HardwareController.get_gpio_component(HardwareController.PIN.YELLOW_LED).timer.deactivate()

