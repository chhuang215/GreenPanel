import sys
import threading

from flask import Flask


# from PyQt5.QtWidgets import *
# from PyQt5.QtWebKit import *
# from PyQt5.QtWebKitWidgets import *
from PyQt5.QtCore import QUrl, QT_VERSION_STR
from PyQt5.QtWidgets import QApplication, QWidget, QMainWindow



class FlaskServerThread(threading.Thread):

    def run(self):
        print("RUN!")
        app.run()

app = Flask(__name__)
@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    
    fserver = FlaskServerThread()
    fserver.setDaemon(True)
    fserver.start()
    
    qapp = QApplication(sys.argv)
    
    qv = [int(x) for x in QT_VERSION_STR.split('.')]
    print("QT Ver: %s" % QT_VERSION_STR)
    if qv[0] == 5 and qv[1] >= 6:
        from PyQt5.QtWebEngineWidgets import QWebEngineView
        view = QWebEngineView()
        view.load(QUrl("http://localhost:5000"))
        view.show()
    else:
        from PyQt5 import QtWebKit
        from PyQt5 import QtWebKitWidgets
        view = QtWebKitWidgets.QWebView()
        view.load(QUrl("http://localhost:5000"))
        view.show()

        print("oy")

    sys.exit(qapp.exec_())
