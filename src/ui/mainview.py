import time
import datetime
import controller

import db
import slots
import plants

from PyQt5.QtCore import (Qt, QUrl, QCoreApplication, QVariant, QJsonValue,
                          QTimer, QMetaObject, Q_ARG, pyqtSlot, pyqtSignal)
# from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView, QQuickItem

from PyQt5.QtQml import QQmlApplicationEngine, QQmlProperty, QQmlComponent

GPIOCtrler = controller.GPIOController
PIN = GPIOCtrler.PIN

class MainWindow(QQuickView):

    def __init__(self):
        super().__init__()
 
#        self.setSource(QUrl('MainView.qml'))
        self.setSource(QUrl.fromLocalFile('ui/MainView.qml'))
        self.__nav_stack = []

        # Get root
        self.root = self.rootObject()

        # Root child
        self.txt_clock = self.root.findChild(QQuickItem, "txtClock")
        self.btn_setting = self.root.findChild(QQuickItem, "btnSetting")

        # Root signals
        motr = GPIOCtrler.get_component(PIN.MOTOR)
        self.root.rotateMotor.connect(motr.manual_rotate)
        self.root.stopMotor.connect(motr.manual_stop)
        self.root.quit.connect(QCoreApplication.instance().quit)
        self.root.navTo.connect(self.__panel_nav)
        self.root.navBack.connect(self.__panel_nav_back)

        # Get panels
        self.panel_home = self.root.findChild(QQuickItem, "panelHome")
        self.panel_home.setProperty("temperatureUnit", db.get_setting()["temperature_unit"])
        self.panel_light = self.root.findChild(QQuickItem, "panelLight")
        self.panel_water = self.root.findChild(QQuickItem, "panelWater")
        self.panel_nutrient = self.root.findChild(QQuickItem, "panelNutrient")
        self.panel_setting = self.root.findChild(QQuickItem, "panelSetting")
        self.time_picker = self.root.findChild(QQuickItem, "timePicker")
        self.date_picker = self.root.findChild(QQuickItem, "datePicker")
        
        self.panel_robot = self.root.findChild(QQuickItem, "panelRobot")
        self.panel_robot_select_plant = self.root.findChild(QQuickItem, "panelRobotSelectPlant")
        self.panel_robot_select_plant.setProperty('plantList', [list(p) for p in plants.get_all_plants()])

        self.panel_robot_select = self.root.findChild(QQuickItem, "panelRobotSelect")
        self.panel_robot_confirm = self.root.findChild(QQuickItem, "panelRobotConfirm")

        #### Home Panel's child elements ####
        
        self.btn_light = self.panel_home.findChild(QQuickItem, "btnLight")
        self.btn_water = self.panel_home.findChild(QQuickItem, "btnWater")
        self.btn_nutrient = self.panel_home.findChild(QQuickItem, "btnNutrient")
        self.btn_robot = self.panel_home.findChild(QQuickItem, "btnRobot")

        # Home Panel signals / events
        self.panel_home.unitChanged.connect(lambda unit: db.store_setting({"temperature_unit": unit}))
        self.panel_home.clearNotify.connect(slots.clear_notified)
        
        # When Home Panel's X button is clicked, nav to X panel
        self.btn_light.clicked.connect(lambda: self.__panel_nav(self.panel_light))
        self.btn_water.clicked.connect(lambda: self.__panel_nav(self.panel_water))
        self.btn_nutrient.clicked.connect(lambda: self.__panel_nav(self.panel_nutrient))
        self.btn_setting.clicked.connect(lambda: self.__panel_nav(self.panel_setting))

        #### Light Panel's child elements ####
        led = GPIOCtrler.get_component(PIN.YELLOW_LED)
        text_light_hr = self.panel_light.findChild(QQuickItem, "txtHour")
        text_light_hr.setProperty("text", led.timer.begin_hour)
        text_dur_hr = self.panel_light.findChild(QQuickItem, "txtDuration")
        text_dur_hr.setProperty("text", led.timer.duration)

        # light panel signals / events
        self.panel_light.lightTimerChanged.connect(led.timer.set_timer)
        self.panel_light.lightSwitched.connect(led.switch)

        # Nutrient Panel signals
        self.panel_nutrient.nutrientAdded.connect(self.renew_nutrient_days)

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

        ### Event listener for robot ###
        # When robot butten is clicked, navigate to robot panel
        self.btn_robot.clicked.connect(lambda: self.__panel_nav(self.panel_robot))

        # Refresh slots status whenever Robot panel is visible
        self.panel_robot.visibleChanged.connect(slots.check_slots)

        # Robot Plant Add / Remove
        self.panel_robot.addButtonClicked.connect(lambda: self.__panel_nav(self.panel_robot_select_plant))
        self.panel_robot.removeButtonClicked.connect(lambda: self.__panel_nav(self.panel_robot_select))
        self.panel_robot_select_plant.plantSelected.connect(lambda: self.__panel_nav(self.panel_robot_select))
        self.panel_robot_select.slotsSelectedDone.connect(lambda: self.__panel_nav(self.panel_robot_confirm))
        self.panel_robot_confirm.addConfirm.connect(self.add_plant_confirm)
        self.panel_robot_confirm.removeConfirm.connect(self.remove_plant_confirm)
        #refresh if change plant to add
        self.panel_robot_confirm.plantDataChanged.connect(slots.check_slots)

        # listen to updates outside qt
        controller.SIGNALER.SLOTS_REFRESH.connect(self.refresh_slots_status)
        controller.SIGNALER.NUTRIENT_REFRESH.connect(lambda days: self.root.setProperty("nutrientDays", days))
        controller.SIGNALER.TEMPERATURE_UPDATE.connect(self.display_update_temperature)

        # Display clock right away
        self.display_update_clock()

        #start water sensor timer to retreive current water level condition
        self.water_clock_update_timer = QTimer()
        self.water_clock_update_timer.setInterval(1000)
        self.water_clock_update_timer.timeout.connect(self.display_water_status)
        self.water_clock_update_timer.timeout.connect(self.display_update_clock)
        self.water_clock_update_timer.start()

        self.__panel_nav(self.panel_home)

    def __panel_nav(self, panel):
        if self.__nav_stack:
            self.__nav_stack[-1].setVisible(False)

        self.__nav_stack.append(panel)
        panel.setVisible(True)

    def __panel_nav_back(self, layers=1):
        
        for _ in range(0, layers):
            if len(self.__nav_stack) > 1:
                panel = self.__nav_stack.pop()
                panel.setVisible(False)
        
        self.__nav_stack[-1].setVisible(True)

    def renew_nutrient_days(self, days):
        day_diff = 15 - days
        date_added = datetime.date.today()
        date_added -= datetime.timedelta(day_diff)
        db.store_slots_info({"nutrient_last_added":date_added})
        slots.check_nutrient() #this will trigger nutrient days signal

    def refresh_slots_status(self, sjson, status_msg):
        if self.root.property("busySlots") is False:
            self.root.setProperty("plantSlots", sjson)
        QMetaObject.invokeMethod(self.panel_home, "notifyRobot", 
                                 Qt.QueuedConnection, Q_ARG(QVariant, status_msg))

    def add_plant_confirm(self, plant_id, s):
        selected_slots = s.toVariant()

        for pane, lst in selected_slots.items():
            for i in range(0, len(lst)):
                slotdata = lst[i]
                if slotdata["selected"]:
                    slots.insert_plant(pane, i, plant_id, date_added=slotdata["date_planted"])

        self.__panel_nav_back(layers=3)
    
    def remove_plant_confirm(self, s):
        
        selected_slots = s.toVariant()

        for pane, lst in selected_slots.items():
            for i in range(0, len(lst)):
                if lst[i]["selected"]:
                    slots.remove_plant(pane, i)
        
        self.__panel_nav_back(layers=2)

    @pyqtSlot()
    def display_water_status(self):
        status = GPIOCtrler.get_component(PIN.WATER_LEVEL_SENSOR).has_enough_water()
        self.root.setProperty("waterLevelIsGood", status)
        
    def display_update_clock(self):
        self.txt_clock.setProperty("text", datetime.datetime.now().strftime('%I:%M %p'))

    @pyqtSlot(float, float)
    def display_update_temperature(self, tc, tf):
        status = 0
        if tc > 40:
            status = 1
        elif tc < 1:
            status = -1
        QMetaObject.invokeMethod(self.panel_home, "updateTemperature", Qt.QueuedConnection,
                                 Q_ARG(QVariant, tc), Q_ARG(QVariant, tf), Q_ARG(QVariant, status))

    def settings_confirm(self):
        language = self.root.findChild(QQuickItem, "chosenItemText")
        setting_language = str(language.property("text"))
        print("Language is: " + setting_language)
    
    def time_confirm(self):
        hour = self.root.findChild(QQuickItem, "hourText")
        hour = str(hour.property("text"))
        print("Hour is: " + hour)

        minute = self.root.findChild(QQuickItem, "minuteText")
        minute = str(minute.property("text"))
        print("minute is: " + minute)

    def date_confirm(self):
        date = self.root.findChild(QQuickItem, "datePicker")
        year = str(date.property("selectedDate").year())
        month = str(date.property("selectedDate").month())
        day = str(date.property("selectedDate").day())
        print("Day:" + day + " Month:" + month + " Year:" + year)