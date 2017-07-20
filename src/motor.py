import RPi.GPIO as GPIO
import controller

class Motor:

    DIR_CW = RIGHT = 1
    DIR_CCW = LEFT = 2

    def __init__(self, inp1, inp2):
        self.inp1 = inp1
        self.inp2 = inp2
        self.rotating = False

    def rotate(self, direction=RIGHT):
        if(direction == Motor.RIGHT):
            GPIO.output(self.inp1, GPIO.HIGH)
            GPIO.output(self.inp2, GPIO.LOW)
        else
            GPIO.output(self.inp1, GPIO.LOW)
            GPIO.output(self.inp2, GPIO.HIGH)

    def stop(self):
        GPIO.output(self.inp1, GPIO.LOW)
        GPIO.output(self.inp2, GPIO.LOW)

class MotorRotateTimer:
    def __init__(self):
        pass
