import sys
import datetime
import unittest
from unittest.mock import patch, MagicMock, Mock

try:
    if(not isinstance(sys.modules["RPi"], MagicMock)):
        mock_RPi = MagicMock()
        sys.modules["RPi"] = mock_RPi

    if(not isinstance(sys.modules["RPi.GPIO"] , MagicMock)):
        mock_RPi_GPIO = MagicMock()
        sys.modules["RPi.GPIO"] = mock_RPi_GPIO
except KeyError:
    mock_RPi = MagicMock()
    sys.modules["RPi"] = mock_RPi
    mock_RPi_GPIO = MagicMock()
    sys.modules["RPi.GPIO"] = mock_RPi_GPIO

import led
import controller
import RPi.GPIO


class TestLight(unittest.TestCase):

    def setUp(self):
        pin = controller.GPIOController.PIN.YELLOW_LED
        self.led = led.LED(pin, led.LED.OFF)
        self.led.timer = led.LightTimer(self.led)
        self.assertEqual(self.led.status, self.led.OFF)
        RPi.GPIO.output.assert_called_once_with(self.led.pin, RPi.GPIO.LOW)

    def test_turn_light_on(self):
        
        self.led.turn_on()
        self.assertEqual(self.led.status, self.led.ON)
        RPi.GPIO.output.assert_called_with(self.led.pin, RPi.GPIO.HIGH)

    
    def test_turn_light_off(self):
        self.led.turn_off()
        self.assertEqual(self.led.status, self.led.OFF)
        RPi.GPIO.output.assert_called_with(self.led.pin, RPi.GPIO.LOW)


    def test_set_timer(self):
        b_hr = 12
        duration = 17
        self.led.timer.set_timer(b_hr, duration)
        self.assertEqual(self.led.timer.begin_hour, b_hr)
        self.assertEqual(self.led.timer.end_hour, 5)


    @patch("led.datetime")
    def test_check_timer(self, mock_datetime):
        mock_datetime.datetime.now = Mock()
        ## Suppose to be ON
        mock_datetime.datetime.now.return_value = datetime.datetime(2017, 5, 5, hour=7)
        self.led.timer.check_timer()
        self.assertEqual(self.led.status, led.LED.ON)
        RPi.GPIO.output.assert_called_with(self.led.pin, RPi.GPIO.HIGH)

        mock_datetime.datetime.now.return_value = datetime.datetime(2017, 5, 5, hour=23)
        self.led.timer.check_timer()
        self.assertEqual(self.led.status, led.LED.ON)
        RPi.GPIO.output.assert_called_with(self.led.pin, RPi.GPIO.HIGH)

        ## Suppose to be OFF
        mock_datetime.datetime.now.return_value = datetime.datetime(2017, 5, 5, hour=0)
        self.led.timer.check_timer()
        self.assertEqual(self.led.status, led.LED.OFF)
        RPi.GPIO.output.assert_called_with(self.led.pin, RPi.GPIO.LOW)

        mock_datetime.datetime.now.return_value = datetime.datetime(2017, 5, 5, hour=6)
        self.led.timer.check_timer()
        self.assertEqual(self.led.status, led.LED.OFF)
        RPi.GPIO.output.assert_called_with(self.led.pin, RPi.GPIO.LOW)
    
    def tearDown(self):
        RPi.GPIO.reset_mock()
