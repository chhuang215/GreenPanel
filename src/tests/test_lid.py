import sys
import unittest
from unittest.mock import call, patch, MagicMock, Mock

mock_RPi = MagicMock()
mock_RPi_GPIO = MagicMock()
sys.modules["RPi"] = mock_RPi
sys.modules["RPi.GPIO"] = mock_RPi_GPIO

import led
import lid
import controller
import RPi.GPIO

# RPi.GPIO.HIGH = 1
# RPi.GPIO.LOW = 0

class TestLid(unittest.TestCase):

    # @patch("RPi.GPIO.input", autospec=True)
    # @patch("RPi.GPIO.output", autospec=True)
    def setUp(self):
    
        RPi.GPIO.input.return_value = RPi.GPIO.HIGH
        hwc = controller.HardwareController
        pins = hwc.PIN
        hwc.add_gpio_component(lid.Lid, pins.PUSH_BUTTON)
        hwc.add_gpio_component(led.LED, pins.YELLOW_LED, led.LED.ON)
        hwc.add_gpio_component(led.LED, pins.BLUE_LED, led.LED.OFF)

        self.lid = hwc.get_gpio_component(pins.PUSH_BUTTON)
        self.led_yellow = hwc.get_gpio_component(pins.YELLOW_LED)
        self.led_blue = hwc.get_gpio_component(pins.BLUE_LED)
        
        self.assertEqual(self.lid.STATUS, self.lid.CLOSED)        
        RPi.GPIO.output.assert_has_calls([call(self.led_yellow.pin, RPi.GPIO.HIGH), call(self.led_blue.pin, RPi.GPIO.LOW)])

    def test_trigger_open_lid(self):
        
        RPi.GPIO.input.return_value = RPi.GPIO.LOW

        led_y_status = self.led_yellow.status
        led_b_status = self.led_blue.status

        self.lid.open_close()

        self.assertEqual(led_y_status, self.led_yellow.status)
        self.assertEqual(led_b_status, self.led_blue.status)

        self.assertEqual(self.lid.STATUS, self.lid.OPENED)

        RPi.GPIO.output.assert_has_calls([call(self.led_blue.pin, RPi.GPIO.HIGH), call(self.led_yellow.pin, RPi.GPIO.LOW)])

    @patch("RPi.GPIO.output", autospec=True)
    def test_trigger_close_lid(self, mock_gpio_output):
        
        RPi.GPIO.input.return_value = RPi.GPIO.HIGH
        self.lid.open_close()

        self.assertEqual(self.lid.STATUS, self.lid.CLOSED)
        RPi.GPIO.output.assert_has_calls([call(self.led_blue.pin, RPi.GPIO.LOW), call(self.led_yellow.pin, RPi.GPIO.HIGH)])



