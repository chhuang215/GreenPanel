OUT = "GPIO.OUT"
IN = "GPIO.IN"
HIGH = 1
LOW = 0
BCM = "BCM"
BOARD = "BOARD"
PUD_UP = "PUD_UP"
PUD_DOWN = "PUD_DOWN"
BOTH = "GPIO.BOTH"
def setmode(a):
    #print("\t[MOCKGPIO]: setmode(%s)" % a)
    pass

def setup(a, b, pull_up_down=PUD_UP):
    #print("\t[MOCKGPIO]: setup(%s, %s, %s)" % (a, b, pull_up_down))
    pass

def output(a, b):
    #print("\t[MOCKGPIO]: output(%s, %s)" % (a, b))
    pass

def input(*args):

    #print("\t[MOCKGPIO]: input(%s)" % args)
    return 1

def cleanup():
    #print("\t[MOCKGPIO]: cleanup()")
    pass
def setwarnings(flag):
    #print(flag)
    pass
def add_event_detect(pin, g, callback=None, bouncetime=0):
    #print("\t[MOCKGPIO]: add_event_detect(%s, %s)" % (pin, g))
    pass
class PWM:
    def __init__(self, *args):
        #print("\t[MOCKGPIO]: PWM()")
        pass

    def stop(self):
        #print("\t[MOCKGPIO]: PWM.stop()")
        pass
    def start(self, *args):
        #print("\t[MOCKGPIO]: PWM.start()")
        pass
    def ChangeDutyCycle(self, *args):
        #print("\t[MOCKGPIO: PWM.ChangeDutyCycle()]")
        pass