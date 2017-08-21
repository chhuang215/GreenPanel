import datetime
import threading

import RPi.GPIO as GPIO
import controller



class Motor:

    PWM_FREQ = 40
    PWM_DC = 28
    PWM_DC_FAST = 50

    DIR_CW = RIGHT = 1
    DIR_CCW = LEFT = 2

    def __init__(self, inp1, inp2, inppwm, enable_timer=True):
        self.inp1 = inp1
        self.inp2 = inp2
        self.pwm = GPIO.PWM(inppwm, self.PWM_FREQ)
        self.rotating = False
        self.timer = MotorRotateTimer(self)
        self.pwm.start(0)
        if enable_timer:
            self.timer.enabled = True
            self.timer.activate()

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

    def check_timer(self):

        curr_dt = datetime.datetime.now()
        print("!MOTOR Check_Timer %s %s" % (self.motor.__class__.__name__, curr_dt), end='')
        minute = curr_dt.minute
        if minute % 30 >= 0 and minute % 30 < 15:
            self.motor.rotate()
            print(" ! MOTOR_ROTATING")
        else:
            self.motor.stop()
            print(" ! MOTOR_STOPPED")

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        self.check_timer()
        now = datetime.datetime.now()
        print("MOTOR TIMER loop", now)
        next_check_time = now.replace(second=0, microsecond=0)
        tt = 15 - (now.minute % 15)
        next_check_time += datetime.timedelta(minutes=tt)
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
