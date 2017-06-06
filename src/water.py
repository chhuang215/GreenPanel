
import RPi.GPIO as GPIO
import controller

class WaterSensor:
    def __init__(self, gpio_pin):
        self.pin = gpio_pin
        self.status = False

    def water_level_detect(self, pin):
        self.status = GPIO.input(pin) == GPIO.LOW
        print("Water is good: ", self.status)
        controller.UIController.get_ui().change_water_status(self.status)

    def has_enough_water(self):
        return GPIO.input(self.pin) == GPIO.LOW
