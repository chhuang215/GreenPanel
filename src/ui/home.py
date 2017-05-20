

import time
from PyQt5.QtCore import (Qt, QCoreApplication, QTimer, QThread, pyqtSignal, pyqtSlot)
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout)

import controller

class HomePanel(QWidget):
    """Home display of the system"""

    def __init__(self):
        super().__init__()
        self.init_ui()

    def init_ui(self):
        """Initialize the UI"""

        grid = QGridLayout()
        grid.setSpacing(20)

        btn_led_on_off = QPushButton("LED On/Off", parent=self)
        btn_led_on_off.setFixedSize(200, 180)
        btn_led_on_off.setObjectName("btnLed")
        btn_led_on_off.clicked.connect(controller.LED.switch_yellow_led)


        self.__lbl_temperature_display = QLabelTemperatureDisplay("0", parent=self)
        self.__lbl_temperature_display.setObjectName("lblTemperature")

        grid.addWidget(btn_led_on_off, 0, 0)
        grid.addWidget(self.__lbl_temperature_display, 0, 1)

        # for i in range(0, 2):
        #     for j in range(1, 4):
        #         button = QPushButton("Button" + str(i + j))
        #         button.setFixedSize(200, 180)
        #         grid.addWidget(button, i, j)
        self.setLayout(grid)


class QLabelTemperatureDisplay(QLabel):

    
    class TemperatureRetrieveThread(QThread):

        # get_temp_sig = pyqtSignal()

        def __init__(self, parent):
            super().__init__()
            self.parent_label = parent

        def run(self):
            while True:
                # print("Won't do stuff")
                # self.get_temp_sig.emit()
                temp = controller.Temperature.get_temperature()
                print("update temp: " + str(temp))
                self.parent_label.setText(str(temp))
                time.sleep(4)


    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # self.temperature_display_timer = QTimer()
        # self.temperature_display_timer.timeout.connect(self.update_text)
        # self.temperature_display_timer.setInterval(0)
        # self.temperature_display_timer.start(4000) # milliseconds
        self.t_thread = self.TemperatureRetrieveThread(self)
        # self.t_thread.get_temp_sig.connect(self.update_text)
        self.t_thread.start()

    # def update_text(self):
    #     temp = controller.Temperature.get_temperature()
    #     print("update temp: " + str(temp))
    #     QLabelTemperatureDisplay.setText(str(temp))
