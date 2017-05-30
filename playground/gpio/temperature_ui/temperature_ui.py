import sys
import os
import glob
import time
import random
import RPi.GPIO as GPIO
from PyQt5.QtCore import (QUrl, QThread, pyqtSignal)
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView, QQuickItem
from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty, QQmlComponent 

class TemperatureSensor(QThread):
    mySignal = pyqtSignal(object)
    def __init__(self):
        super().__init__()
        if(os.name != 'nt'):
            os.system('modprobe w1-gpio')
            os.system('modprobe w1-therm')

            base_dir = '/sys/bus/w1/devices/'

            device_folder = glob.glob(base_dir + '28*')[0]

            self.device_file = device_folder + '/w1_slave'
        self.mySignal.connect(self.display_temp)
    def read_temp_raw(self):
        f = open(self.device_file, 'r')
        lines = f.readlines()
        f.close()
        return lines

    def read_temp(self):
        lines = self.read_temp_raw()
        if lines[0].strip()[-3:] != 'YES':
            return False

        equals_pos = lines[1].find('t=')
        if equals_pos != -1:
            temp_string = lines[1][equals_pos + 2:]
            temp_c = float(temp_string) / 1000.0

            return temp_c

    def display_temp(self, t):
        print(t)
        text_temp.setProperty("text", t + " C")

    def run(self):
        while True:
            tem = random.choice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            if(os.name != 'nt'):
                tem = str(self.read_temp())

            if tem != False:
                self.mySignal.emit(tem)
            time.sleep(2)



def light_switch_event():
    print("LIGHT: ", light_switch.property("checked"))
    
    GPIO.output(18, not GPIO.input(18))

if __name__ == "__main__":

    GPIO.setmode(GPIO.BCM)
    GPIO.setup(18, GPIO.OUT, initial=GPIO.LOW)
    
    try :

        app = QApplication(sys.argv)
    # Create a label and set its properties

    # engine = QQmlApplicationEngine()

    # # guifile = QUrl('TemperatureApp.qml')
    # # component = QQmlComponent(engine, guifile)
    # # rec = component.create()

    # # print(rec)
    # # rec.parentItem().show()
    # engine.load(QUrl('TemperatureApp.qml'))
    # rec = engine.rootObjects()[0]
    # rec.window().show()
    # # win = engine.rootObjects()[0]
    # # win.show()

        view = QQuickView()
        view.setSource(QUrl('TemperatureApp.qml'))

    # Show the Label
        view.show()

        root = view.rootObject()

        text_temp = root.findChild(QQuickItem, "txtTemp")

        light_switch = root.findChild(QQuickItem, "swtLight")
        light_switch.clicked.connect(light_switch_event)
    
        tsensor_thread = TemperatureSensor()


        tsensor_thread.start()
        ret = app.exec_()
        print("Hi")
        sys.exit(ret)

    finally:
        GPIO.cleanup()
    

    # tsensor = TemperatureSensor()
    # _update_timer = QTimer()
    # _update_timer.timeout.connect(tsensor.display_temp)
    # _update_timer.setInterval(1000)
    # _update_timer.start() # milliseconds
