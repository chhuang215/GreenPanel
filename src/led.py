"""
led.py
LED modal
"""
import RPi.GPIO as GPIO
import threading
import datetime
from controller import HardwareController
'''
    LED class
'''
class LED():
    """LED Modal class"""
    ON = 1
    OFF = 0

    def __init__(self, gpio_pin, status):
 
        self.status = status
        self.pin = gpio_pin

        self.resume()
        
    def switch(self):
        '''Switch light off if on, else switch it on'''

        lid = HardwareController.get_gpio_component(HardwareController.PIN.PUSH_BUTTON)
        if lid.STATUS == lid.OPENED:
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
    
    #Interval in seconds
    INTERVAL = 60

    def __init__(self, led, begin_hr=7, duration_hr=17):
        self._timer = None
        self.led = led
        self.set_timer(begin_hr, duration_hr)
        self.is_activated = False

    def check_timer(self):
        curr_dt = datetime.datetime.now()
        hour = curr_dt.hour
        if hour >= self.begin_hour or hour < self.end_hour:
            self.led.turn_on()

        elif hour < self.begin_hour and hour >= self.end_hour:
            self.led.turn_off()

    def set_timer(self, begin, duration):
        self.begin_hour = begin
        self.end_hour = (begin + duration) % 24
        self.duration = duration

    def activate(self):
        if not self.is_activated:
            self._timer = threading.Timer(self.INTERVAL, self.check_timer)
            self._timer.start()
            self.is_activated = True

    def deactivate(self):
        self._timer.cancel()
        self.is_activated = False
