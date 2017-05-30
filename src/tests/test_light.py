import sys
import unittest
from unittest.mock import patch, MagicMock

mock_RPi = MagicMock()
mock_RPi_GPIO = MagicMock()
sys.modules["RPi"] = mock_RPi
sys.modules["RPi.GPIO"] = mock_RPi_GPIO

import led
import pins

import RPi.GPIO

class TestLight(unittest.TestCase):

    @patch("RPi.GPIO.output", autospec=True)
    def setUp(self, mock_gpio_output):
        self.led = led.LED(led.LED.OFF, pins.PIN_YELLOW_LED)
        self.lighttimer = led.LightTimer(self.led)
        mock_gpio_output.assert_called_with(self.led.pin, RPi.GPIO.LOW)

    @patch("RPi.GPIO.output", autospec=True)
    def test_turn_light_on(self, mock_gpio_output):
        self.led.turn_on()
        self.assertEqual(self.led.status, 1)
        mock_gpio_output.assert_called_with(self.led.pin, RPi.GPIO.HIGH)
    
    @patch("RPi.GPIO.output", autospec=True)
    def test_turn_light_off(self, mock_gpio_output):
        self.led.turn_off()
        self.assertEqual(self.led.status, 0)
        mock_gpio_output.assert_called_with(self.led.pin, RPi.GPIO.LOW)

    def test_set_timer(self):
        b_hr = 12
        duration = 17
        self.lighttimer.set_timer(b_hr, duration)
        self.assertEqual(self.lighttimer.begin_hour, b_hr)
        self.assertEqual(self.lighttimer.end_hour, 5)

    def test_check_timer(self):
        pass
