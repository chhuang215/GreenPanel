import os
import glob
import time
import threading
from PyQt5.QtCore import QThread, pyqtSignal

class TemperatureSensor(QThread):
    UPDATED = pyqtSignal(object, object)
    
    def __init__(self, pin):
        super().__init__()
        self.__device_file = None
        self.temperature_c = self.temperature_f = 0
        if os.name == "posix" and os.uname().nodename.startswith("raspberrypi"):
            os.system('modprobe w1-gpio')
            os.system('modprobe w1-therm')
            base_dir = '/sys/bus/w1/devices/'
            device_folder = glob.glob(base_dir + '28*')[0]
            self.__device_file = device_folder + '/w1_slave'   

    def read_temp_raw(self):

        f = open(self.__device_file , 'r')
        lines = f.readlines()
        f.close()
        return lines

    def read_temp(self):

        if self.__device_file is None:
            raise Exception("Not running on Pi")

        lines = self.read_temp_raw()
        while lines[0].strip()[-3:] != 'YES':
            time.sleep(0.2)
            lines = self.read_temp_raw()

        equals_pos = lines[1].find('t=')
        if equals_pos != -1:
            temp_string = lines[1][equals_pos + 2:]
            temp_c = float(temp_string) / 1000.0
            temp_f = temp_c * (9 / 5) + 32
            return temp_c, temp_f

    def __update_temperature(self):
        print("Temperature updated")
        temp_c = temp_f = -100
        try:
            temp_c, temp_f = self.read_temp()
            temp_c = round(temp_c, 1)
            temp_f = round(temp_f, 1)
        except Exception:
            print("Temperature Sensor Not Found, value mocked")
            import random
            temp_c = round(random.choice([19.333, 20.444, 21.555, 22.666, 23.777, 24.111]), 1)
            temp_f = round(temp_c * (9/5) + 32, 1)
        self.temperature_c, self.temperature_f = temp_c, temp_f
        self.UPDATED.emit(self.temperature_c, self.temperature_f)

    def run(self):
        while True:
            self.__update_temperature()
            time.sleep(4)
        