import os
import time
import datetime
import controller

from PyQt5.QtCore import (Qt, QUrl, QThread, QCoreApplication, QVariant,
                          QTimer, QMetaObject, Q_ARG, pyqtSignal)
# from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView, QQuickItem

from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty, QQmlComponent 

GPIOCtrler = controller.GPIOController
PIN = GPIOCtrler.PIN

class TemperatureDisplayThread(QThread):
    SIG_CHK_SHOW_TEMP = pyqtSignal(object, object)
    def __init__(self, panel_home):
        super().__init__()
        self.panel_home = panel_home
        
        self.SIG_CHK_SHOW_TEMP.connect(self.display_temp)
        # a reference to the get_temperture method from TemperatureSensor Modal
        self.get_temperature = GPIOCtrler.get_component(PIN.TEMPERATURE_SENSOR).get_temperature

    def display_temp(self, tc, tf):
        # tc = str(tc)
        # tf = str(tf)
        QMetaObject.invokeMethod(self.panel_home, "updateTemperature", 
                                 Qt.QueuedConnection, Q_ARG(QVariant, tc), Q_ARG(QVariant, tf))

    def run(self):
        while True:
            tc, tf = self.get_temperature()
            self.SIG_CHK_SHOW_TEMP.emit(tc, tf)
            time.sleep(5)

class MainWindow(QQuickView):
    def __init__(self):
        super().__init__()

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
        self.date_picker = self.root.findChild(QQuickItem, "datePicker")
        self.panel_robot = self.root.findChild(QQuickItem, "panelRobot")
        #self.panel_light.setVisible(False)

        # Get Home Panel's child elements
        self.txt_clock = self.panel_home.findChild(QQuickItem, "txtClock")
        self.btn_rotate_left = self.panel_home.findChild(QQuickItem, "btnRotateLeft")
        self.btn_rotate_right = self.panel_home.findChild(QQuickItem, "btnRotateRight")

        # Get Light Panel's child elements
        led = GPIOCtrler.get_component(PIN.YELLOW_LED)
        self.text_light_hr = self.panel_light.findChild(QQuickItem, "txtHour")
        self.text_light_hr.setProperty("text", led.timer.begin_hour)
        self.text_dur_hr = self.panel_light.findChild(QQuickItem, "txtDuration")
        self.text_dur_hr.setProperty("text", led.timer.duration)

        self.light_switch = self.panel_light.findChild(QQuickItem, "swtLight")

        # Set event listeners for home panel's elements
        motr = GPIOCtrler.get_component(PIN.MOTOR)
        self.btn_rotate_left.pressed.connect(lambda: motr.rotate(motr.LEFT, motr.PWM_DC_FAST))
        self.btn_rotate_left.released.connect(motr.stop)
        self.btn_rotate_right.pressed.connect(lambda: motr.rotate(motr.RIGHT, motr.PWM_DC_FAST))
        self.btn_rotate_right.released.connect(motr.stop)

        # Set event listeners for light panel's elements
        self.panel_light.lightTimerChanged.connect(led.timer.set_timer)
        self.light_switch.clicked.connect(led.switch)

        # When light button is clicked, nav to light panel
        self.btn_light = self.panel_home.findChild(QQuickItem, "btnLight")
        self.btn_light.clicked.connect(lambda: self.__panel_nav(self.panel_light))

        # When settings button is clicked, nav to settings panel
        self.btn_setting = self.panel_home.findChild(QQuickItem, "btnSetting")
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

        # Date picker
        self.btn_date_picker = self.root.findChild(QQuickItem, "btnSetDate")
        self.btn_date_picker.clicked.connect(lambda: self.__panel_nav(self.date_picker))
        
        # When confirm button is clicked in date picker
        self.btn_date_confirm = self.root.findChild(QQuickItem, "btnDateConfirm")
        self.btn_date_confirm.clicked.connect(self.date_confirm)
        self.btn_date_confirm.clicked.connect(self.__panel_nav_back)

        # When robot butten is clicked, navigate to robot panel
        self.btn_robot = self.root.findChild(QQuickItem, "btnRobot")
        self.btn_robot.clicked.connect(lambda: self.__panel_nav(self.panel_robot))

        # (Quit the app, for testing purpose)
        self.btn_quit = self.root.findChild(QQuickItem, "btnQuit")
        self.btn_quit.clicked.connect(QCoreApplication.instance().quit)

        self.btn_water = self.panel_home.findChild(QQuickItem, "btnWater")

        # Instantiate temperature sensor thread
        self.tsensor_thread = TemperatureDisplayThread(self.panel_home)

        # start temperature thread
        self.tsensor_thread.start()

        # Display clock right away
        self.display_update_clock()

        #start water sensor timer to retreive current water level condition
        self.water_clock_update_timer = QTimer()
        self.water_clock_update_timer.setInterval(1000)
        self.water_clock_update_timer.timeout.connect(self.display_water_status)
        self.water_clock_update_timer.timeout.connect(self.display_update_clock)
        self.water_clock_update_timer.start()

        # Global back buttons
        all_back_buttons = self.root.findChildren(QQuickItem, "btnBack")
        for btn in all_back_buttons:
            btn.clicked.connect(self.__panel_nav_back)

        self.__panel_nav(self.panel_home)


    def __panel_nav(self, panel):
        if self.__nav_stack:
            self.__nav_stack[-1].setVisible(False)

        self.__nav_stack.append(panel)
        panel.setVisible(True)

    def __panel_nav_back(self):

        panel = self.__nav_stack.pop()
        panel.setVisible(False)

        self.__nav_stack[-1].setVisible(True)

    def display_water_status(self):
        status = GPIOCtrler.get_component(PIN.WATER_LEVEL_SENSOR).has_enough_water()
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
    
    def time_confirm(self):
        self.hour = self.root.findChild(QQuickItem, "hourText")
        hour = str(self.hour.property("text"))
        print("Hour is: " + hour)

        self.minute = self.root.findChild(QQuickItem, "minuteText")
        minute = str(self.minute.property("text"))
        print("minute is: " + minute)

    def date_confirm(self):
        print("123")
        self.date = self.root.findChild(QQuickItem, "datePicker")
        year = str(self.date.property("selectedDate").year())
        month = str(self.date.property("selectedDate").month())
        day = str(self.date.property("selectedDate").day())
        print("Day:" + day + " Month:" + month + " Year:" + year)