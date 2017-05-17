import RPi.GPIO as GPIO
import lid
class LED():

    LED_LIST = {}

    def __init__(self, status, gpio_pin):
        self.status = status
        self.pin = gpio_pin
        LED.LED_LIST[str(self.pin)] = self
#        if status == 1:
 #           self.turn_on()

    def switch(self):

        lid_status = lid.Lid.STATUS

        if self.status == 1 or lid_status == 1:
            print('LED OFF')

            self.turn_off()

        elif self.status == 0 and lid_status == 0:
            print('LED ON')

            self.turn_on()

    def turn_on(self):
        GPIO.output(self.pin, GPIO.HIGH)
        self.status = 1
    def turn_off(self):
        GPIO.output(self.pin, GPIO.LOW)
        self.status = 0

    def turn_on_temporary(self):
        GPIO.output(self.pin, GPIO.HIGH)

    def turn_off_temporary(self):
        GPIO.output(self.pin, GPIO.LOW)

    def resume(self):
        if self.status == 1:
            self.turn_on()
        else:
            self.turn_off()
