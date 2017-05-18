

from PyQt5.QtCore import (Qt, QCoreApplication)
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout)

import controller

class HomePanel(QWidget):
    def __init__(self):
        super().__init__()

        #self.window().setWindowFlags(Qt.FramelessWindowHint)

        self.init_ui()

    def init_ui(self):

        grid = QGridLayout()
        grid.setSpacing(20)

        btn_led_on_off = QPushButton("LED On/Off", parent=self)
        btn_led_on_off.setFixedSize(200, 180)
        btn_led_on_off.setObjectName("btnLed")
        btn_led_on_off.clicked.connect(controller.LED.switch)


        lbl_temperature_display = QLabel("0", parent=self)
        lbl_temperature_display.setObjectName("lblTemperature")

        grid.addWidget(btn_led_on_off, 0, 0)
        grid.addWidget(lbl_temperature_display, 0, 1)

        # for i in range(0, 2):
        #     for j in range(1, 4):
        #         button = QPushButton("Button" + str(i + j))
        #         button.setFixedSize(200, 180)
        #         grid.addWidget(button, i, j)

        self.setLayout(grid)

    def update_temperature_display(self, temp):
        lbl_temperature = self.findChild(QLabel, "lblTemperature")
        lbl_temperature.setText(str(temp))
        
