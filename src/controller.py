"""controller.py"""
import collections
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

class GPIOController:
    '''Hardware Controller'''

    class PIN:
        '''Pin enum from representing hardware's corresponding GPIO pin number'''
        YELLOW_LED = 27
        BLUE_LED = 17
        PUSH_BUTTON = 23
        WATER_LEVEL_SENSOR = 25
        TEMPERATURE_SENSOR = 4
        WATER_PUMP = 12
        MOTOR = (16, 20, 18)

    GPIO_COMPONENTS = {}

    @staticmethod
    def add_component(component, pin, *argv, **kwargs):
        '''add gpio component to component list'''

        if not isinstance(pin, collections.Iterable):
            pin = (pin,)

        cmpont = component(*pin, *argv, **kwargs)

        for p in pin:
            GPIOController.GPIO_COMPONENTS[str(p)] = cmpont

        print("\t %s %s added to component list" % (component.__name__, pin))
 
    @staticmethod
    def get_component(pin):

        if isinstance(pin, collections.Iterable):
            pin = pin[0]

        if not isinstance(pin, str):
            pin = str(pin)
        return GPIOController.GPIO_COMPONENTS[pin]

    # @staticmethod
    # def deactive_timers():
    #     GPIOController.get_component(GPIOController.PIN.YELLOW_LED).timer.deactivate()

