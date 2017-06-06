
import RPi.GPIO as GPIO

class WaterSensor:
    def __init__(self, gpio_pin):
        self.pin = gpio_pin

    # def water_level_detect(self, pin):
        
    #     print("Water is good: ", self.has_enough_water())
    #     #controller.UIController.get_ui().change_water_status(self.status)

    def has_enough_water(self):
        return GPIO.input(self.pin) == GPIO.LOW
