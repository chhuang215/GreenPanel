"""main.py"""
# pylint: disable=E0611, C0111
import sys

from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView

def main():


    # start QT UI
    sargv = sys.argv + ['--style', 'material']
    app = QApplication(sargv)
    font = QFont()
    font.setFamily("Ariel")

    app.setFont(font)
    # manually detect lid open close event from the start

    ui_view = QQuickView()
    
    ui_view.setSource(QUrl.fromLocalFile('RobotPanelSelect.qml'))
    ui_view.setWidth(800)
    ui_view.setHeight(480)
    ui_view.setMaximumHeight(480)
    ui_view.setMaximumWidth(800)
    ui_view.setMinimumHeight(480)
    ui_view.setMinimumWidth(800)
    # ui_view = UIController.get_ui()
    ui_view.show()

    ret = app.exec_()

    # Teminate
    sys.exit(ret)



if __name__ == '__main__':
    main()
