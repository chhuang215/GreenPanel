import RPi.GPIO as GPIO

import led
import pins as PINS

class Lid :
    STATUS = 0

    @staticmethod
    def push_button_callback(channel):
        led_list = led.LED.LED_LIST
        blue_led = led_list[str(PINS.PIN_BLUE_LED)]
        yellow_led = led_list[str(PINS.PIN_BLUE_LED)]
        
        print(yellow_led)

        if GPIO.input(channel):
            print("LID closed")
            blue_led.resume()
            yellow_led.resume()
            Lid.STATUS = 0
        else:
            print("LID is open")
            blue_led.turn_on_temporary()
            yellow_led.turn_off_temporary()

            Lid.STATUS = 1

