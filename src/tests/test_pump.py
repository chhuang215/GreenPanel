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

import pump
import water
import controller
import RPi.GPIO

class TestWaterPump(unittest.TestCase):

    @patch("water.WaterSensor")
    def setUp(self, mock_water_sensor):
        mock_water_sensor.has_enough_water.return_value = True
        gc = controller.GPIOController
        wsensor = mock_water_sensor(gc.PIN.WATER_LEVEL_SENSOR)
        gc.GPIO_COMPONENTS[str(gc.PIN.WATER_LEVEL_SENSOR)] = wsensor

        self.pump = pump.WaterPump(gc.PIN.WATER_PUMP, timer=False)

    def test_pump_on(self):
        self.pump.turn_on()
        RPi.GPIO.output.assert_called_with(self.pump.pin, RPi.GPIO.HIGH)

    
    def test_pump_off(self):
        self.pump.turn_off()
        RPi.GPIO.output.assert_called_with(self.pump.pin, RPi.GPIO.LOW)
    
    @patch("pump.datetime")
    def test_check_timer(self, mock_datetime):

        ## Suppose to be ON
        for hr in range(0, 24, 8):
            for mi in [0, 4]:
                mock_datetime.datetime.now.return_value = datetime.datetime(2017, 5, 5, hour=hr, minute=mi)
                self.pump.timer.check_timer()
                RPi.GPIO.output.assert_called_with(self.pump.pin, RPi.GPIO.HIGH)

        ## Suppose to be OFF
        for hr in range(0, 24, 8):
            for mi in [5, 14, 20, 29, 35, 44, 50, 59]:
                mock_datetime.datetime.now.return_value = datetime.datetime(2017, 5, 5, hour=hr, minute=mi)
                self.pump.timer.check_timer()
                RPi.GPIO.output.assert_called_with(self.pump.pin, RPi.GPIO.LOW)
    
    def tearDown(self):
        RPi.GPIO.reset_mock()
