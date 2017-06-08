"""
lid.py

Lid module
"""

import RPi.GPIO as GPIO

import controller

class Lid:
    """
    Lid class
    """
    CLOSED = 0
    OPENED = 1

    STATUS = CLOSED
    PIN = controller.HardwareController.PIN.PUSH_BUTTON

    def __init__(self, pin):
        self.pin = pin

    def open_close(self, pin=PIN):
        """
        open_close method
        """
        hwcontroller = controller.HardwareController
        blue_led = hwcontroller.get_gpio_component(hwcontroller.PIN.BLUE_LED)
        yellow_led = hwcontroller.get_gpio_component(hwcontroller.PIN.YELLOW_LED)

        print("Lid GPIO input: " + str(GPIO.input(self.pin)))
        
        if GPIO.input(self.pin) == GPIO.HIGH:
            print("LID closed")
            blue_led.resume()
            yellow_led.resume()
            self.STATUS = self.CLOSED
        else:
            print("LID is open")
            blue_led.turn_on_temporary()
            yellow_led.turn_off_temporary()
            self.STATUS = self.OPENED
