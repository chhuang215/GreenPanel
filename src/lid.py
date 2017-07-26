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
        gc = controller.GPIOController
        pins = gc.PIN
        blue_led = gc.get_component(pins.BLUE_LED)
        yellow_led = gc.get_component(pins.YELLOW_LED)
        motr = gc.get_component(pins.MOTOR)
        print("Lid GPIO input: " + str(GPIO.input(self.pin)))

        if GPIO.input(self.pin) == GPIO.HIGH:
            print("LID closed")
            self.status = Lid.CLOSED
            blue_led.resume()
            yellow_led.resume()
            motr.timer.activate()
        else:
            print("LID is open")
            self.status = Lid.OPENED
            blue_led.turn_on_temporary()
            yellow_led.turn_off_temporary()
            motr.stop()
            motr.timer.deactivate()
