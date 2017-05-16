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

LEDStatus = 1
LID_STATUS = 0
'''
    Main UI for the control
'''
class MainUI(QWidget):
    
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
        btnLedOnOff.clicked.connect(self.turn_led_on_off)    
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

    def turn_led_on_off(self):
        global LEDStatus
        global LID_STATUS
        if LEDStatus == 1 or LID_STATUS == 1:
            print('LED OFF')

            GPIO.output(PIN_YELLOW_LED, GPIO.LOW)
            LEDStatus = 0
            #GPIO.output(23, GPIO.HIGH)
        elif LEDStatus == 0 and LID_STATUS == 0:
            print('LED ON')
            GPIO.output(PIN_YELLOW_LED, GPIO.HIGH)
            LEDStatus = 1
            #GPIO.output(23, GPIO.LOW)
    
   
def push_button_callback(channel):
    global LID_STATUS

    if GPIO.input(channel):
       print("LID closed")
       LID_STATUS = 0
    else:
       print("LID is open")
       LID_STATUS = 1
       
if __name__ == '__main__':
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(PIN_YELLOW_LED, GPIO.OUT)
    GPIO.setup(PIN_BLUE_LED, GPIO.OUT)
    GPIO.setup(PIN_PUSH_BUTTON,GPIO.IN, pull_up_down=GPIO.PUD_UP)

    GPIO.add_event_detect(PIN_PUSH_BUTTON, GPIO.BOTH, callback=push_button_callback, bouncetime=1) 
#    GPIO.add_event_detect(PIN_PUSH_BUTTON, GPIO.FALLING, callback=push_button_down_callback, bouncetime=300) 

    try:  
        app = QApplication(sys.argv)
        ex = MainUI()
        RET = app.exec_()
        # clean up
        GPIO.cleanup()
        sys.exit(RET)
        sys.exit(app.exec_())

    except KeyboardInterrupt:  
        GPIO.cleanup()       # clean up GPIO on CTRL+C exit 
    
