"""
led.py
LED modal
"""
import RPi.GPIO as GPIO
import threading
import datetime
import lid
'''
    LED class
'''
class LED():
    """LED Modal class"""

    LED_LIST = {}

    ON = 1
    OFF = 0

    @staticmethod
    def add_light(gpio_pin, init_status=OFF):
        LED.LED_LIST[str(gpio_pin)] = LED(gpio_pin, init_status)

    def __init__(self, gpio_pin, status):
        self.status = status
        self.pin = gpio_pin

        self.resume()
#        if status == 1:
 #           self.turn_on()

    def switch(self):

        if lid.Lid.STATUS == lid.Lid.OPENED:
            return

        if self.status == LED.ON:
            print('Turned LED OFF')

            self.turn_off()

        elif self.status == LED.OFF:
            print('Turned LED ON')

            self.turn_on()

    def turn_on(self):
        GPIO.output(self.pin, GPIO.HIGH)
        self.status = LED.ON
    def turn_off(self):
        GPIO.output(self.pin, GPIO.LOW)
        self.status = LED.OFF

    def turn_on_temporary(self):
        GPIO.output(self.pin, GPIO.HIGH)

    def turn_off_temporary(self):
        GPIO.output(self.pin, GPIO.LOW)

    def resume(self):
        if self.status == LED.ON:
            self.turn_on()
        else:
            self.turn_off()

class LightTimer():
    def __init__(self, led, begin_hr=7, duration_hr=17):

        self.led = led
        self.set_timer(begin_hr, duration_hr)

    def check_timer(self):
        pass

    def set_timer(self, begin, duration):
        self.begin_hour = begin
        self.end_hour = (begin + duration) % 24

    def activate(self):
        pass

    def deactivate(self):
        pass
