"""main.py"""
# pylint: disable=E0611, C0111

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
        global YELLOW_LED
        
        grid = QGridLayout()
        grid.setSpacing(20)

        btn_led_on_off = QPushButton("LED Bro")
        btn_led_on_off.setFixedSize(200, 180)
        btn_led_on_off.clicked.connect(YELLOW_LED.switch())
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

'''
    LED class
'''
class LED():
    def __init__(self, status, gpio_pin):
        self.status = status
        self.pin = gpio_pin

    def switch(self):
        global LID_STATUS
        if self.status == 1 or LID_STATUS == 1:
            print('LED OFF')

            self.turn_off()
            
        elif self.status == 0 and LID_STATUS == 0:
            print('LED ON')

            self.turn_on()
    
    def turn_on(self):
        GPIO.output(self.pin, GPIO.HIGH)
        self.status = 1
    def turn_off(self):
        GPIO.output(self.pin, GPIO.LOW)
        self.status = 0
        

   
def push_button_callback(channel):
    global LID_STATUS

    if GPIO.input(channel):
        print("LID closed")
        LID_STATUS = 0
    else:
        print("LID is open")
        LID_STATUS = 1

YELLOW_LED = LED(1, PIN_YELLOW_LED)
BLUE_LED = LED(0, PIN_YELLOW_LED)


if __name__ == '__main__':
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(PIN_YELLOW_LED, GPIO.OUT)
    GPIO.setup(PIN_BLUE_LED, GPIO.OUT)
    GPIO.setup(PIN_PUSH_BUTTON, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    GPIO.add_event_detect(PIN_PUSH_BUTTON, GPIO.BOTH, callback=push_button_callback, bouncetime=1)

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
    
