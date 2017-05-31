
import RPi.GPIO as GPIO
import controller

class WaterSensor:
    def __init__(self, gpio_pin):
        self.pin = gpio_pin

    def water_level_detect(self, pin):
        print("Water is good: ", str(GPIO.input(self.pin) == GPIO.LOW))
        controller.UIController.get_ui().change_water_status(GPIO.input(self.pin) == GPIO.LOW)

    def has_enough_water(self):
        return GPIO.input(self.pin) == GPIO.LOW
