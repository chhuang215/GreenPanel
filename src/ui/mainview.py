import os
import time
import controller

from PyQt5.QtCore import (QUrl, QThread, QCoreApplication, QTimer, pyqtSignal)
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView, QQuickItem
from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty, QQmlComponent 

class TemperatureDisplayThread(QThread):
    SIG_CHK_SHOW_TEMP = pyqtSignal(object)
    def __init__(self, txt_temp_display):
        super().__init__()
        self.txt_temp_display = txt_temp_display

        self.SIG_CHK_SHOW_TEMP.connect(self.display_temp)


        hwc = controller.HardwareController
        # a reference to the get_temperture method from TemperatureSensor Modal
        self.get_temperature = hwc.get_gpio_component(hwc.PIN.TEMPERATURE_SENSOR).get_temperature

    def display_temp(self, t):
        t = str(t)
        print(t)
        self.txt_temp_display.setProperty("text", t + " C")

    def run(self):
        while True:
            tem = self.get_temperature()
            self.SIG_CHK_SHOW_TEMP.emit(tem)
            time.sleep(5)

class MainWindow(QQuickView):
    def __init__(self):
        super().__init__()

#        self.setSource(QUrl('MainView.qml'))
        self.setSource(QUrl.fromLocalFile('ui/MainView.qml'))

        self.root = self.rootObject()
        self.text_temp = self.root.findChild(QQuickItem, "txtTemp")

        self.light_switch = self.root.findChild(QQuickItem, "swtLight")

        hwc = controller.HardwareController
        self.light_switch.clicked.connect(hwc.get_gpio_component(hwc.PIN.YELLOW_LED).switch)

        self.btn_quit = self.root.findChild(QQuickItem, "btnQuit")

        self.btn_quit.clicked.connect(QCoreApplication.instance().quit)

        self.btn_water = self.root.findChild(QQuickItem, "btnWater")

        # start temperature thread
        self.tsensor_thread = TemperatureDisplayThread(self.text_temp)
        self.tsensor_thread.start()

        #start water sensor timer
        self.water_update_timer = QTimer()
        self.water_update_timer.setInterval(1000)
        self.water_update_timer.timeout.connect(self.display_current_water_status)
        self.water_update_timer.start()

    def display_current_water_status(self):
        hwc = controller.HardwareController
        status = hwc.get_gpio_component(hwc.PIN.WATER_LEVEL_SENSOR).has_enough_water()
        msg = "Add water yo"
        if status:
            msg = "Water is good."
        self.btn_water.setProperty("text", msg)
