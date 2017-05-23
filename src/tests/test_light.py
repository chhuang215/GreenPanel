import unittest
import led
import pins

class TestLight(unittest.TestCase):

    def setUp(self):
        self.led = led.LED(led.LED.OFF, pins.PIN_YELLOW_LED)
        self.lighttimer = led.LightTimer(led)

    def test_turn_light_on(self):
        self.led.turn_on()
        self.assertEqual(self.led.status, 1)
    
    def test_turn_light_off(self):
        self.led.turn_off()
        self.assertEqual(self.led.status, 0)

    def test_set_timer(self):
        b_hr = 12
        duration = 17
        self.lighttimer.set_timer(b_hr, duration)
        self.assertEqual(self.lighttimer.begin_hour, b_hr)
        self.assertEqual(self.lighttimer.end_hour, 5)

    def test_check_timer(self):
        pass
