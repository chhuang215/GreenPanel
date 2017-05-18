import sys
import os
import glob
import time
import threading
from PyQt5.QtCore import (QUrl, QObject)
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView, QQuickItem
from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty

class TemperatureSensor(threading.Thread):
    def __init__(self):
        os.system('modprobe w1-gpio')
        os.system('modprobe w1-therm')
        threading.Thread.__init__(self)
        self.daemon = True
        self.text_temp = text_temp
        base_dir = '/sys/bus/w1/devices/'

        device_folder = glob.glob(base_dir + '28*')[0]

        self.device_file = device_folder + '/w1_slave'

    def read_temp_raw(self):
        f = open(self.device_file, 'r')
        lines = f.readlines()
        f.close()
        return lines

    def read_temp(self):
        lines = self.read_temp_raw()
        while lines[0].strip()[-3:] != 'YES':
            time.sleep(0.2)
            lines = self.read_temp_raw()

        equals_pos = lines[1].find('t=')
        if equals_pos != -1:
            temp_string = lines[1][equals_pos + 2:]
            temp_c = float(temp_string) / 1000.0

            return temp_c
    def run(self):

        time.sleep(4)
        text_property.write("are you ready")
        time.sleep(2)
        text_property.write("please")
        time.sleep(2)
        text_property.write("Change")
        time.sleep(2)


        while True:
            tem = str(self.read_temp())
            print(tem)
            text_property.write(tem)
            time.sleep(2)



if __name__ == "__main__":
    app = QApplication(sys.argv)
    # Create a label and set its properties
    appview = QQuickView()
    appview.setSource(QUrl('TemperatureApp.qml'))

    # Show the Label
    appview.show()
    root = appview.rootObject()


    text_temp = root.findChild(QObject, "txtTemp")
    
    text_property = QQmlProperty(text_temp, "text")

    tsensor = TemperatureSensor()

    tsensor.start()
    ret = app.exec_()
    print("Hi")
    sys.exit(ret)

