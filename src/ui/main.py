

from PyQt5.QtCore import (Qt, QCoreApplication)
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout)

import pins as PINS

from led import LED


class MainUI(QWidget):

    def __init__(self):
        super().__init__()

        self.window().setWindowFlags(Qt.FramelessWindowHint)

        self.init_ui()

    def init_ui(self):

        grid = QGridLayout()
        grid.setSpacing(20)

        btn_led_on_off = QPushButton("LED Bro")
        btn_led_on_off.setFixedSize(200, 180)
        btn_led_on_off.clicked.connect(LED.LED_LIST[str(PINS.PIN_YELLOW_LED)].switch)
        grid.addWidget(btn_led_on_off, 0, 0)

        for i in range(0, 2):
            for j in range(1, 4):
                button = QPushButton("Button" + str(i + j))
                button.setFixedSize(200, 180)
                grid.addWidget(button, i, j)

        hbox = QHBoxLayout()
        lbl3 = QLabel('Huge Label')

        qbtn = QPushButton('Quit')
        qbtn.clicked.connect(QCoreApplication.instance().quit)
        # qbtn.resize(qbtn.sizeHint())
        # qbtn.move(200, 50)

        hbox.addWidget(lbl3)
        hbox.addWidget(qbtn)

        vbox = QVBoxLayout()
        vbox.addLayout(grid)
        vbox.addLayout(hbox)
        self.setLayout(vbox)

        self.setGeometry(0, 0, 800, 480)
        self.setWindowTitle('Touch Panel')
        self.showFullScreen()
        self.show()
