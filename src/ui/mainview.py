import os
import time
import controller

from PyQt5.QtCore import (QUrl, QThread, QCoreApplication ,pyqtSignal)
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView, QQuickItem
from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty, QQmlComponent 

class TemperatureDisplayThread(QThread):
    SIG_CHK_SHOW_TEMP = pyqtSignal(object)
    def __init__(self, txt_temp_display):
        super().__init__()
        self.txt_temp_display = txt_temp_display

        self.SIG_CHK_SHOW_TEMP.connect(self.display_temp)
    def display_temp(self, t):
        print(t)
        self.txt_temp_display.setProperty("text", t + " C")

    def run(self):
        while True:
            tem = controller.Temperature.get_temperature()
            self.SIG_CHK_SHOW_TEMP.emit(tem)
            time.sleep(5)


class MainWindow(QQuickView):
    def __init__(self):
        super().__init__()

        self.setSource(QUrl.fromLocalFile('ui/MainView.qml'))

        self.root = self.rootObject()
        self.text_temp = self.root.findChild(QQuickItem, "txtTemp")

        self.light_switch = self.root.findChild(QQuickItem, "swtLight")
        self.light_switch.clicked.connect(controller.LightController.switch_yellow_led)

        self.btn_quit = self.root.findChild(QQuickItem, "btnQuit")

        self.btn_quit.clicked.connect(QCoreApplication.instance().quit)
        # start temperature thread
        self.tsensor_thread = TemperatureDisplayThread(self.text_temp)

        self.tsensor_thread.start()
