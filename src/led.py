"""
led.py
LED modal
"""
import RPi.GPIO as GPIO
import lid

'''
    LED class
'''
class LED():
    """LED Modal class"""

    LED_LIST = {}
    ON = 1
    OFF = 0

    def __init__(self, status, gpio_pin):
        self.status = status
        self.pin = gpio_pin
        LED.LED_LIST[str(self.pin)] = self

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
        if self.status == 1:
            self.turn_on()
        else:
            self.turn_off()
