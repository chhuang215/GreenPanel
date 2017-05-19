import sys
import threading
import random
import time
from PyQt5.QtCore import (QUrl, QObject, QThread, QTimer)
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import (QQuickView, QQuickItem)
from PyQt5.QtQml import QQmlApplicationEngine


class DisplayRandomNumber(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.daemon = True

    def run(self):
        
        while True:

            change_text()
            
            time.sleep(2)

def change_text():
    number = random.choice([1, 2, 3, 4, 5, 6])
    print(number)
    TEXT_DISPLAY.setProperty("text", number)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    # Create a label and set its properties
    appwindow = QQuickView()
    appwindow.setSource(QUrl('Hello.qml'))

    TEXT_DISPLAY = appwindow.rootObject().findChild(QQuickItem, name="textDisplay")
    

    _update_timer = QTimer()
    _update_timer.timeout.connect(change_text)
    _update_timer.setInterval(5000)
    _update_timer.start() # milliseconds
    DisplayRandomNumber().start()
    # Show the Label
    appwindow.show()


    sys.exit(app.exec_())
