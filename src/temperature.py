import os
import glob
import time
import threading

class TemperatureSensor():

    def __init__(self, pin):
        # threading.Thread.__init__(self)
        self.__device_file = None
        if os.name == "posix" and os.uname().nodename.startswith("raspberrypi"):
            os.system('modprobe w1-gpio')
            os.system('modprobe w1-therm')
            
            # self.daemon = True
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

    def get_temperature(self):
        '''returns current temperature'''
        temp_c = "NaN"
        temp_f = "NaN"

        try:
            temp_c, temp_f = self.read_temp()
            temp_c = round(temp_c, 1)
            temp_f = round(temp_f, 1)
        except Exception:
            print("Temperature Sensor Not Found, value mocked")
            import random
            temp_c = round(random.choice([19.333, 20.444, 21.555, 22.666, 23.777, 24.111]), 1)
         
            temp_f = round(temp_c * (9/5) + 32,1)

        return temp_c, temp_f
