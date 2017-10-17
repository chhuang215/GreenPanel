import os
import subprocess
import platform
import pprint

from PyQt5.QtCore import QObject

import controller


pp = pprint.PrettyPrinter(indent=4)

class QWifiList(QObject):
    def getList(self):
        return scan_wifi()


def scan_wifi():
    wifilist = []
    if platform.system() == 'Windows':
        with subprocess.Popen("netsh wlan show networks mode=BSSID",
                              shell=True,stdout=subprocess.PIPE, universal_newlines=True) as result:
            current_index = None
            for line in result.stdout:
                line = line.strip()
                kv = line.split(":", 1)
                if len(kv) < 2:
                    continue
                key, val = kv[0].strip(), kv[1].strip()
                
                if line.startswith("SSID"):
                    wifilist.append({"BSSID":[]})
                    current_index = wifilist[-1]
                if line.startswith("BSSID"):
                    wifilist[-1]["BSSID"].append({})
                    current_index = wifilist[-1]["BSSID"][-1]
                if current_index is not None:
                    current_index[key] = val
    elif platform.system() == 'Linux':
        subprocess.call("iwlist wlan0 scan")
    # controller.SIGNALER.WIFI_REFRESH.emit(wifilist)
    return wifilist

if __name__ == "__main__":
    wlist = scan_wifi()
    
    pp.pprint(wlist)
