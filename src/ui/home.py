

import time
from PyQt5.QtCore import (Qt, QCoreApplication, QTimer, QThread, QTime,
                          pyqtSignal, pyqtSlot)
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel, QLCDNumber,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout, 
                             QSizePolicy)

import controller

class HomePanel(QWidget):
    """Home display of the system"""

    def __init__(self):
        super().__init__()
        self.init_ui()

        self.t_thread = TemperatureRetrieveThread()
        self.t_thread.get_temp_sig.connect(self.__lbl_temperature_display.setText)
        self.t_thread.start()


    def init_ui(self):
        """Initialize the UI"""

        grid = QGridLayout()
        grid.setSpacing(20)

        btn_led_on_off = QPushButton("LED On/Off", parent=self)
        btn_led_on_off.setFixedSize(200, 180)
        btn_led_on_off.setObjectName("btnLed")
        btn_led_on_off.clicked.connect(controller.LED.switch_yellow_led)


        self.__lbl_temperature_display = QLabel("0", parent=self)
        self.__lbl_temperature_display.setFixedSize(200, 180)

        self.__lcd_clock_display = DigitalClock(parent=self)
        self.__lcd_clock_display.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
        grid.addWidget(btn_led_on_off, 0, 0)
        grid.addWidget(self.__lbl_temperature_display, 0, 1, Qt.AlignCenter)
        grid.addWidget(self.__lcd_clock_display, 0, 2)


        # for i in range(0, 2):
        #     for j in range(1, 4):
        #         button = QPushButton("Button" + str(i + j))
        #         button.setFixedSize(200, 180)
        #         grid.addWidget(button, i, j)
        self.setLayout(grid)

class TemperatureRetrieveThread(QThread):

    get_temp_sig = pyqtSignal(object)

    def run(self):
        while True:
            temp = controller.Temperature.get_temperature()
            print("update temp: " + str(temp))
            temp_str = str(temp) + u"\xb0" + "C"
            self.get_temp_sig.emit(temp_str)
            time.sleep(3)

class DigitalClock(QLCDNumber):
    def __init__(self, parent=None):
        super().__init__(parent)

        self.setSegmentStyle(QLCDNumber.Filled)
        self.setDigitCount(8)
        timer = QTimer(self)
        timer.timeout.connect(self.showTime)
        timer.start(1000)

        self.showTime()

    def showTime(self):
        curr_time = QTime.currentTime()
        text = curr_time.toString('hh:mm:ss')
        # if (time.second() % 2) == 0:
        #     text = text[:2] + ' ' + text[3:]

        self.display(text)