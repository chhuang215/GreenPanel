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

    def __init__(self, pin):
        self.pin = pin
        self.status = Lid.CLOSED

    def open_close(self, pin=None):
        """
        open_close method
        """
        hwcontroller = controller.GPIOController
        blue_led = hwcontroller.get_gpio_component(hwcontroller.PIN.BLUE_LED)
        yellow_led = hwcontroller.get_gpio_component(hwcontroller.PIN.YELLOW_LED)

        print("Lid GPIO input: " + str(GPIO.input(self.pin)))

        if GPIO.input(self.pin) == GPIO.HIGH:
            print("LID closed")
            self.status = Lid.CLOSED
            blue_led.resume()
            yellow_led.resume()
  
        else:
            print("LID is open")
            self.status = Lid.OPENED
            blue_led.turn_on_temporary()
            yellow_led.turn_off_temporary()
      
