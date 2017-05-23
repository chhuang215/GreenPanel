import sys
import threading

from flask import Flask, render_template

from PyQt5.QtCore import QUrl, QT_VERSION_STR
from PyQt5.QtWidgets import QApplication

QV = [int(x) for x in QT_VERSION_STR.split('.')]

if QV[0] == 5 and QV[1] >= 6:
    print("Using QtWebEngine")
    from PyQt5.QtWebEngineWidgets import QWebEngineView
else:
    print("Using QtWebKit")
    from PyQt5 import QtWebKitWidgets



class FlaskServerThread(threading.Thread):

    def run(self):
        print("Start Flask Server!")
        flask_app.run(host="0.0.0.0")

flask_app = Flask(__name__)
@flask_app.route("/")
def hello():
    return render_template("index.html")

if __name__ == "__main__":
    fserver = FlaskServerThread()
    fserver.setDaemon(True)
    fserver.start()

    qapp = QApplication(sys.argv)

    print("QT Ver: %s" % QT_VERSION_STR)
    if QV[0] == 5 and QV[1] >= 6:
        view = QWebEngineView()
    else:
        view = QtWebKitWidgets.QWebView()

    view.load(QUrl("http://localhost:5000"))
    view.show()
    sys.exit(qapp.exec_())
