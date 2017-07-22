
import datetime
import threading
import RPi.GPIO as GPIO
import controller

GPIOController = controller.GPIOController

class WaterPump:
    def __init__(self, gpio_pin):
 
        self.pin = gpio_pin

        self.timer = PumpTimer(self)

        self.timer.activate()
    
    def turn_on(self):
        GPIO.output(self.pin, GPIO.HIGH)

    def turn_off(self):
        GPIO.output(self.pin, GPIO.LOW)

class PumpTimer():

    def __init__(self, pump):
        self._timer = None
        self.pump = pump
        self.is_activated = False

    def check_timer(self):

        curr_dt = datetime.datetime.now()
        print("FOR pump", self.pump.pin, curr_dt)
        minute = curr_dt.minute
        if minute % 15 >= 0 and minute % 15 <= 5:
            wsensor = GPIOController.get_component(GPIOController.PIN.WATER_LEVEL_SENSOR)
            if wsensor.has_enough_water():
                self.pump.turn_on()
        else:
            self.pump.turn_off()

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        self.check_timer()
        now = datetime.datetime.now()
        print("PUMP TIMER loop", self.pump.pin, now)
        next_check_time = now.replace(second=0, microsecond=0)
        next_check_time += datetime.timedelta(minutes=1)
        interval = next_check_time - now
        print("PUMP check time", next_check_time)
        self._timer = threading.Timer(interval.total_seconds(), self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        print("PUMP TIMER ACTIVATED", self.pump.pin, datetime.datetime.now())
        if not self.is_activated:
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        print("PUMP TIMER DEACTIVATED", self.pump.pin, datetime.datetime.now())
        self._timer.cancel()
        self.is_activated = False
