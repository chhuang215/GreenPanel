"""mainwindow.py"""

from PyQt5.QtCore import (Qt, QCoreApplication, QTimer)
#from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import (QWidget, QToolTip, QPushButton, QLabel,
                             QApplication, QVBoxLayout, QGridLayout, QHBoxLayout)

from .home import HomePanel

class MainWindow(QWidget):
    '''
        Main UI for the control
    '''

    def __init__(self):
        super().__init__()

        self.window().setWindowFlags(Qt.FramelessWindowHint)
        self.init_ui()



    def init_ui(self):
        """Initialize the UI"""
        self.panel_home = HomePanel()
        self.panel_home.setParent(self)
        self.panel_home.setObjectName("panelHome")

        hbox = QHBoxLayout()
        lbl3 = QLabel('Huge Label')

        qbtn = QPushButton('Quit')
        qbtn.clicked.connect(QCoreApplication.instance().quit)

        hbox.addWidget(lbl3)
        hbox.addWidget(qbtn)

        vbox = QVBoxLayout()
        vbox.addWidget(self.panel_home)
        vbox.addLayout(hbox)
        self.setLayout(vbox)

        self.setGeometry(0, 0, 800, 480)
        self.setWindowTitle('Touch Panel')
