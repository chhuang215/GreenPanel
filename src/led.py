"""
led.py
LED modal
"""
import threading
import datetime
import RPi.GPIO as GPIO
from controller import GPIOController
'''
    LED class
'''
class LED():
    """LED Modal class"""
    ON = 1
    OFF = 0

    def __init__(self, gpio_pin, status, timer=False):
 
        self.status = status
        self.pin = gpio_pin

        self.resume()
        self.timer = LightTimer(self)

        if timer:
            self.timer.activate()

    def switch(self):
        '''Switch light off if on, else switch it on'''

        lid = GPIOController.get_gpio_component(GPIOController.PIN.PUSH_BUTTON)
        if lid.status == lid.OPENED:
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
        self._timer = None
        self.led = led
        self.is_activated = False
        
        self.set_timer(begin_hr, duration_hr)
   
    def set_timer(self, begin, duration):

        self.begin_hour = begin
        self.end_hour = (begin + duration) % 24
        self.duration = duration

        if self.is_activated:
            self.deactivate()
            self.activate()

    def check_timer(self):

        curr_dt = datetime.datetime.now()
        print("FOR", self.led.pin, curr_dt)
        hour = curr_dt.hour
        if hour >= self.begin_hour or hour < self.end_hour:
            self.led.turn_on()

        elif hour < self.begin_hour and hour >= self.end_hour:
            self.led.turn_off()

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        self.check_timer()
        now = datetime.datetime.now()
        print("LED TIMER loop", self.led.pin, now)
        activate_time = now.replace(second=0, microsecond=0)
        activate_time += datetime.timedelta(minutes=1)
        timestamp = activate_time.timestamp() - now.timestamp()
        print("NEXT check time", timestamp)
        self._timer = threading.Timer(timestamp, self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        print("LED TIMER", self.led.pin, datetime.datetime.now(), "ACTIVATED")
        if not self.is_activated:
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        print("LED TIMER", self.led.pin, datetime.datetime.now(), "DEACTIVATED")
        self._timer.cancel()
        self.is_activated = False
