import sys
import unittest
from unittest.mock import patch, MagicMock, Mock, call

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

import motor
import controller
import RPi.GPIO

class TestMotor(unittest.TestCase):

    def setUp(self):
        gc = controller.GPIOController
        self.motor = motor.Motor(*gc.PIN.MOTOR, timer=False)
        
    def test_rotate_right(self):
        self.motor.rotate()
        RPi.GPIO.output.has_calls(
            [call(self.motor.inp1, RPi.GPIO.HIGH),
             call(self.motor.inp2, RPi.GPIO.LOW)
            ])

    def test_rotate_left(self):
        self.motor.rotate(direction=self.motor.DIR_CCW)
        RPi.GPIO.output.has_calls(
            [call(self.motor.inp1, RPi.GPIO.LOW),
             call(self.motor.inp2, RPi.GPIO.HIGH)
            ])

    def test_stop(self):
        self.motor.stop()
        RPi.GPIO.output.has_calls(
            [call(self.motor.inp1, RPi.GPIO.LOW),
             call(self.motor.inp2, RPi.GPIO.LOW)
            ])

    def tearDown(self):
        RPi.GPIO.reset_mock()
