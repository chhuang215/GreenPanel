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

    def __init__(self, gpio_pin, status, enable_timer=False):
 
        self.status = status
        self.pin = gpio_pin

        self.resume()
        self.timer = None

        if enable_timer:
            self.timer = LightTimer(self)
            self.timer.activate()

    def switch(self):
        '''Switch light off if on, else switch it on'''

        if self.status == LED.ON:
            print('Turned LED OFF')

            self.turn_off()

        elif self.status == LED.OFF:
            print('Turned LED ON')

            self.turn_on()

    def turn_on(self):
        self.status = LED.ON

        lid = GPIOController.get_component(GPIOController.PIN.PUSH_BUTTON)
        if lid.status == lid.OPENED:
            return

        GPIO.output(self.pin, GPIO.HIGH)
        
    def turn_off(self):
        self.status = LED.OFF
        GPIO.output(self.pin, GPIO.LOW)

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
        begin = int(begin)
        duration = int(duration)

        if begin < 0:
            begin = 0
        if begin > 23:
            begin = 23

        if duration < 0:
            duration = 0
        if duration > 24:
            duration = 24

        self.begin_hour = begin
        self.end_hour = (begin + duration) % 24
        self.duration = duration

        if self.is_activated:
            self.deactivate()
            self.activate()

    def check_timer(self):

        curr_dt = datetime.datetime.now()
        print("!LED Check_Timer %s" % self.led.__class__.__name__, "pin:%d" % self.led.pin, curr_dt)
        hour = curr_dt.hour
        if (
                (self.begin_hour < self.end_hour and
                 hour >= self.begin_hour and hour < self.end_hour) or
                (self.begin_hour >= self.end_hour and
                 (hour >= self.begin_hour or hour < self.end_hour))
        ):
            print("ON")
            self.led.turn_on()

        else:
            print("OFF")
            self.led.turn_off()

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        self.check_timer()
        now = datetime.datetime.now()
        print("LED TIMER loop", self.led.pin, now)
        next_check_time = now.replace(minute=0, second=0, microsecond=0)
        next_check_time += datetime.timedelta(hours=1)
        interval = next_check_time - now
        print("LED NEXT check time", next_check_time)
        self._timer = threading.Timer(interval.total_seconds(), self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        print("LED TIMER ACTIVATED", self.led.pin, datetime.datetime.now())
        if not self.is_activated:
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        print("LED TIMER DEACTIVATED", self.led.pin, datetime.datetime.now())
        self._timer.cancel()
        self.is_activated = False
