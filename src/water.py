import RPi.GPIO as GPIO

class WaterSensor:
    def __init__(self, gpio_pin):
        self.pin = gpio_pin

    def has_enough_water(self):
        return GPIO.input(self.pin) == GPIO.LOW
