"""main.py"""
# pylint: disable=E0611

import sys

import RPi.GPIO as GPIO

import time
from PyQt5.QtCore import (Qt, QCoreApplication)
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout)


PIN_YELLOW_LED = 18
PIN_BLUE_LED = 23
PIN_PUSH_BUTTON = 17

# Set up GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(PIN_YELLOW_LED, GPIO.OUT)
GPIO.setup(PIN_BLUE_LED, GPIO.OUT)
GPIO.setup(PIN_PUSH_BUTTON,GPIO.IN, pull_up_down=GPIO.PUD_UP)


LEDStatus = 1

class Example(QWidget):
    
    def __init__(self):
        super().__init__()
        
        #Borderless
        self.window().setWindowFlags(Qt.FramelessWindowHint)

        self.initUI()
        
        
    def initUI(self):
    
        
        grid = QGridLayout()
        grid.setSpacing(20)

        btnLedOnOff = QPushButton("LED Bro")
        btnLedOnOff.setFixedSize(200, 180)
        btnLedOnOff.clicked.connect(self.turnLedOnOff)    
        grid.addWidget(btnLedOnOff, 0, 0)


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

    def turnLedOnOff(self):
        global LEDStatus
        if LEDStatus == 1:
            print('LED OFF')

            GPIO.output(PIN_YELLOW_LED, GPIO.LOW)
            LEDStatus = 0
            #GPIO.output(23, GPIO.HIGH)
        else:
            print('LED ON')
            GPIO.output(PIN_YELLOW_LED, GPIO.HIGH)
            LEDStatus = 1
            #GPIO.output(23, GPIO.LOW)

if __name__ == '__main__':

    app = QApplication(sys.argv)
    ex = Example()
    RET = app.exec_()
    # clean up
    GPIO.cleanup()
    sys.exit(RET)
    sys.exit(app.exec_())
