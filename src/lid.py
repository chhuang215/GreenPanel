import RPi.GPIO as GPIO

from led import LED
import pins as PINS

class Lid :
    STATUS = 0
    PIN = -1

    @staticmethod
    def push_button_callback(channel):
        blue_led = LED.LED_LIST[str(PINS.PIN_BLUE_LED)]
        yellow_led = LED.LED_LIST[str(PINS.PIN_BLUE_LED)]


        if GPIO.input(channel):
            print("LID closed")
            blue_led.resume()
            yellow_led.resume()
            STATUS = 0
        else:
            print("LID is open")
            blue_led.turn_on_temporary()
            yellow_led.turn_off_temporary()
            STATUS = 1