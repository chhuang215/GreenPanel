import os
import time
import datetime
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


        hwc = controller.GPIOController
        # a reference to the get_temperture method from TemperatureSensor Modal
        self.get_temperature = hwc.get_component(hwc.PIN.TEMPERATURE_SENSOR).get_temperature

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
        hwc = controller.GPIOController
#        self.setSource(QUrl('MainView.qml'))
        self.setSource(QUrl.fromLocalFile('ui/MainView.qml'))
        self.__nav_stack = []
        # Get root
        self.root = self.rootObject()

        # Get panels
        self.panel_home = self.root.findChild(QQuickItem, "panelHome")
        self.panel_light = self.root.findChild(QQuickItem, "panelLight")
        self.panel_setting = self.root.findChild(QQuickItem, "panelSetting")
        self.time_picker = self.root.findChild(QQuickItem, "timePicker")
        #self.panel_light.setVisible(False)

        # Get Home Panel's child elements
        self.text_temp = self.panel_home.findChild(QQuickItem, "txtTemp")
        self.txt_clock = self.panel_home.findChild(QQuickItem, "txtClock")
        self.light_switch = self.panel_light.findChild(QQuickItem, "swtLight")
        self.light_switch.clicked.connect(hwc.get_component(hwc.PIN.YELLOW_LED).switch)
        
        # When light button is clicked, nav to light panel
        self.btn_light = self.root.findChild(QQuickItem, "btnLight")
        self.btn_light.clicked.connect(lambda: self.__panel_nav(self.panel_light))

        # When settings button is clicked, nav to settings panel
        self.btn_setting = self.root.findChild(QQuickItem, "btnSetting")
        self.btn_setting.clicked.connect(lambda: self.__panel_nav(self.panel_setting))

        # When confirm button is clicked in settings, nav back to main panel
        self.btn_setting_confirm = self.root.findChild(QQuickItem, "btnConfirm")
        self.btn_setting_confirm.clicked.connect(self.settings_confirm)
        self.btn_setting_confirm.clicked.connect(self.__panel_nav_back)

        # Time picker
        self.btn_time_picker = self.root.findChild(QQuickItem, "btnSetTime")
        self.btn_time_picker.clicked.connect(lambda: self.__panel_nav(self.time_picker))

        # When confirm button is clicked in time picker
        self.btn_time_confirm = self.root.findChild(QQuickItem, "btnTimeConfirm")
        self.btn_time_confirm.clicked.connect(self.time_confirm)
        self.btn_time_confirm.clicked.connect(self.__panel_nav_back)

        # (Quit the app, for testing purpose)
        self.btn_quit = self.root.findChild(QQuickItem, "btnQuit")
        self.btn_quit.clicked.connect(QCoreApplication.instance().quit)

        self.btn_water = self.root.findChild(QQuickItem, "btnWater")

        # start temperature thread
        self.tsensor_thread = TemperatureDisplayThread(self.text_temp)
        self.tsensor_thread.start()

        #start water sensor timer to retreive current water level condition
        self.water_clock_update_timer = QTimer()
        self.water_clock_update_timer.setInterval(1000)
        self.water_clock_update_timer.timeout.connect(self.display_water_status)
        self.water_clock_update_timer.timeout.connect(self.display_update_clock)
        self.water_clock_update_timer.start()

        all_back_buttons = self.root.findChildren(QQuickItem, "btnBack")
        for btn in all_back_buttons:
            btn.clicked.connect(self.__panel_nav_back)

        self.__panel_nav(self.panel_home)


    def __panel_nav(self, panel):
        if self.__nav_stack:
            self.__nav_stack[-1].setVisible(False)

        self.__nav_stack.append(panel)
        panel.setVisible(True)
        # self.current_visible_panel = panel

    def __panel_nav_back(self):

        panel = self.__nav_stack.pop()
        panel.setVisible(False)

        self.__nav_stack[-1].setVisible(True)

    def display_water_status(self):
        gpioctrler = controller.GPIOController
        status = gpioctrler.get_component(gpioctrler.PIN.WATER_LEVEL_SENSOR).has_enough_water()
        msg = "Add water yo"
        if status:
            msg = "Water is good."
        self.btn_water.setProperty("text", msg)
        
    def display_update_clock(self):
        t = datetime.datetime.now().strftime('%I:%M %p')
        self.txt_clock.setProperty("text", t)

    def settings_confirm(self):
        self.language = self.root.findChild(QQuickItem, "chosenItemText")
        setting_language = str(self.language.property("text"))
        print("Language is: " + setting_language)

        self.time = self.root.findChild(QQuickItem, "timeField")
        setting_time = str(self.time.property("text"))
        print("Time is: " + setting_time)

        self.date = self.root.findChild(QQuickItem, "dateField")
        setting_date = str(self.date.property("text"))
        print("The date is: " + setting_date)
    
    def time_confirm(self):
        self.hour = self.root.findChild(QQuickItem, "hourText")
        hour = str(self.hour.property("text"))
        print("Hour is: " + hour)

        self.minute = self.root.findChild(QQuickItem, "minuteText")
        minute = str(self.minute.property("text"))
        print("minute is: " + minute)