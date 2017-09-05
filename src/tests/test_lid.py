import sys
import unittest
from unittest.mock import call, patch, MagicMock, Mock

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
import lid
import motor
import controller
import RPi.GPIO

class TestLid(unittest.TestCase):

    def setUp(self):
        RPi.GPIO.input.return_value = RPi.GPIO.HIGH
        hwc = controller.GPIOController
        pins = hwc.PIN
        
        self.lid = lid.Lid(pins.PUSH_BUTTON)
        hwc.add_component(self.lid)
        self.assertEqual(self.lid.status, self.lid.CLOSED)        
        
        self.led_yellow = led.LED(pins.YELLOW_LED, led.LED.ON)
        hwc.add_component(self.led_yellow)
        RPi.GPIO.output.assert_called_with(self.led_yellow.pin, RPi.GPIO.HIGH)
        
        self.led_blue = led.LED(pins.BLUE_LED, led.LED.OFF)
        hwc.add_component(self.led_blue)
        RPi.GPIO.output.assert_called_with(self.led_blue.pin, RPi.GPIO.LOW)

        hwc.add_component(motor.Motor(*pins.MOTOR, enable_timer=False))
        # RPi.GPIO.output.assert_has_calls([call(self.led_yellow.pin, RPi.GPIO.HIGH), call(self.led_blue.pin, RPi.GPIO.LOW)])

    def test_trigger_open_lid(self):
        
        RPi.GPIO.input.return_value = RPi.GPIO.LOW

        led_y_status = self.led_yellow.status
        led_b_status = self.led_blue.status

        self.lid.open_close()

        self.assertEqual(led_y_status, self.led_yellow.status)
        self.assertEqual(led_b_status, self.led_blue.status)

        self.assertEqual(self.lid.status, self.lid.OPENED)

        RPi.GPIO.output.assert_has_calls([call(self.led_blue.pin, RPi.GPIO.HIGH), call(self.led_yellow.pin, RPi.GPIO.LOW)])
        
    def test_trigger_close_lid(self):
        
        RPi.GPIO.input.return_value = RPi.GPIO.HIGH
        self.lid.open_close()

        self.assertEqual(self.lid.status, self.lid.CLOSED)
        RPi.GPIO.output.assert_has_calls([call(self.led_blue.pin, RPi.GPIO.LOW), call(self.led_yellow.pin, RPi.GPIO.HIGH)])
       

    def tearDown(self):
        RPi.GPIO.reset_mock()
        self.lid.status = self.lid.CLOSED
