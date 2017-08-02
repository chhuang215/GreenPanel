
import datetime
import threading
import RPi.GPIO as GPIO
import controller

GPIOController = controller.GPIOController

class WaterPump:
    def __init__(self, gpio_pin, timer=True):
 
        self.pin = gpio_pin

        self.timer = PumpTimer(self)

        if timer: 
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
        print("!Check_Timer %s pin:%d %s" % (self.pump.__class__.__name__, self.pump.pin, curr_dt), end="")
        minute = curr_dt.minute
        if minute % 15 >= 0 and minute % 15 < 5:
            wsensor = GPIOController.get_component(GPIOController.PIN.WATER_LEVEL_SENSOR)

            if wsensor.has_enough_water():
                self.pump.turn_on()
                print(" ! PUMP_ON")
            else:
                self.pump.turn_off()
                print("! PUMP_OFF_NO_WATER")
        else:
            self.pump.turn_off()
            print(" ! PUMP_OFF")

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        self.check_timer()
        now = datetime.datetime.now()

        print("PUMP TIMER loop", self.pump.pin, now)
        next_check_time = now.replace(microsecond=0)
        next_check_time += datetime.timedelta(seconds=1)
        if now.minute % 15 < 0 or now.minute % 15 >= 5:
            next_check_time = now.replace(second=0, microsecond=0)
            tt = 15 - (now.minute % 15)
            next_check_time += datetime.timedelta(minutes=tt)
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
