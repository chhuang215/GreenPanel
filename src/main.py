"""main.py"""
# pylint: disable=E0611

import sys

from PyQt5.QtCore import (Qt, QCoreApplication)
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout)


class Example(QWidget):
    
    def __init__(self):
        super().__init__()
        
        #Borderless
        self.window().setWindowFlags(Qt.FramelessWindowHint)

        self.initUI()
        
        
    def initUI(self):
        
        # QToolTip.setFont(QFont('SansSerif', 10))
        
        # self.setToolTip('This is a <b>QWidget</b> widget')
        

        

        # btn = QPushButton('Button', self)
        # btn.setToolTip('This is a <b>QPushButton</b> widget')
        # btn.resize(btn.sizeHint())
        # btn.move(50, 50)       
        

        
        grid = QGridLayout()
        grid.setSpacing(20)


        for i in range(2):
            for j in range(4):
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

if __name__ == '__main__':

    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())
