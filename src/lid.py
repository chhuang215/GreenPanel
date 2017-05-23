"""
lid.py

Lid module
"""

import RPi.GPIO as GPIO

import led
import pins as PINS


class Lid:
    """
    Lid class
    """
    CLOSED = 0
    OPENED = 1

    STATUS = CLOSED
    PIN = PINS.PIN_PUSH_BUTTON

    @staticmethod
    def open_close(pin=PIN):
        """
        open_close method
        """
        led_list = led.LED.LED_LIST
        blue_led = led_list[str(PINS.PIN_BLUE_LED)]
        yellow_led = led_list[str(PINS.PIN_YELLOW_LED)]

        print("Lid GPIO input: " + str(GPIO.input(pin)))

        if GPIO.input(pin) == 1:
            print("LID closed")
            blue_led.resume()
            yellow_led.resume()
            Lid.STATUS = Lid.CLOSED
        else:
            print("LID is open")
            blue_led.turn_on_temporary()
            yellow_led.turn_off_temporary()
            Lid.STATUS = Lid.OPENED
