import datetime
import threading

import RPi.GPIO as GPIO
from controller import GPIOController

class Motor:
    '''Motor class'''
    
    PWM_FREQ = 75
    PWM_DC = 75
    PWM_DC_FAST = 75

    DIR_CW = RIGHT = 1
    DIR_CCW = LEFT = 2

    def __init__(self, inp1, inp2, inppwm, enable_timer=True):
        self.pin = (inp1, inp2, inppwm)
        self.inp1 = inp1
        self.inp2 = inp2
        self.pwm = GPIO.PWM(inppwm, self.PWM_FREQ)
        self.rotating = False
        self.timer = MotorRotateTimer(self)
        self.pwm.start(0)
        if enable_timer:
            self.timer.enabled = True

    def manual_rotate(self, direction):
        #lid = GPIOController.get_component(GPIOController.PIN.PUSH_BUTTON)
       # if lid.status == lid.OPENED:
        self.rotate(direction=direction, dutycycle=Motor.PWM_DC_FAST)

    def manual_stop(self):
        #lid = GPIOController.get_component(GPIOController.PIN.PUSH_BUTTON)
        #if lid.status == lid.OPENED:
        self.stop()

    def rotate(self, direction=RIGHT, dutycycle=PWM_DC):
        self.pwm.ChangeDutyCycle(dutycycle)
        if(direction == Motor.RIGHT):
            GPIO.output(self.inp1, GPIO.HIGH)
            GPIO.output(self.inp2, GPIO.LOW)
        else:
            GPIO.output(self.inp1, GPIO.LOW)
            GPIO.output(self.inp2, GPIO.HIGH)

    def stop(self):
        self.pwm.ChangeDutyCycle(0)
        GPIO.output(self.inp1, GPIO.LOW)
        GPIO.output(self.inp2, GPIO.LOW)

class MotorRotateTimer:
    def __init__(self, motor):
        self._timer = None
        self.motor = motor
        self.is_activated = False
        self.enabled = False

    # def check_timer(self):

    #     curr_dt = datetime.datetime.now()
    #     print("!MOTOR Check_Timer %s %s" % (self.motor.__class__.__name__, curr_dt), end='')
    #     minute = curr_dt.minute
    #     hour = curr_dt.hour
    #     #if minute % 30 >= 0 and minute % 30 < 15:
    #     if hour >= 7 and hour < 24 and (minute >= 0 and minute < 5):
            
    #     else:
            

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        # self.check_timer()
        now = datetime.datetime.now()
        print("!MOTOR Check_Timer %s %s" % (self.motor.__class__.__name__, now), end='')
        next_check_time = None
        hour = now.hour
        minute = now.minute
        if hour >= 0 and hour < 7:
            self.motor.stop()
            print(" ! MOTOR_STOPPED")
            next_check_time = now.replace(hour=7, minute=0, second=0, microsecond=0)
            
        elif minute >= 0 and minute < 5:
            self.motor.rotate(direction=Motor.DIR_CCW)
            print(" ! MOTOR_ROTATING")
            next_check_time = now.replace(minute=5, second=0, microsecond=0)
            # tt = 5 - (now.minute % 5)
            # next_check_time += datetime.timedelta(minutes=tt)
        else:
            self.motor.stop()
            print(" ! MOTOR_STOPPED")
            next_check_time = now.replace(minute=0, second=0, microsecond=0)
            next_check_time += datetime.timedelta(hours=1)
            
    
        interval = next_check_time - now
        print("MOTOR next check time", next_check_time)
        self._timer = threading.Timer(interval.total_seconds(), self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        if not self.is_activated and self.enabled:
            print("MOTOR TIMER ACTIVATED", datetime.datetime.now())
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        if self.enabled and self._timer is not None:
            print("MOTOR TIMER DEACTIVATED", datetime.datetime.now())
            self._timer.cancel()
        self.is_activated = False
