import os
import re
import subprocess
import platform
import pprint

from PyQt5.QtCore import QObject

import controller


pp = pprint.PrettyPrinter(indent=4)

cellNumberRe = re.compile(r"^Cell\s+(?P<cellnumber>.+)\s+-\s+Address:\s(?P<mac>.+)$")
regexps = [
    re.compile(r"^ESSID:\"(?P<essid>.*)\"$"),
    re.compile(r"^Protocol:(?P<protocol>.+)$"),
    re.compile(r"^Mode:(?P<mode>.+)$"),
    re.compile(r"^Frequency:(?P<frequency>[\d.]+) (?P<frequency_units>.+) \(Channel (?P<channel>\d+)\)$"),
    re.compile(r"^Encryption key:(?P<encryption>.+)$"),
    re.compile(r"^Quality=(?P<signal_quality>\d+)/(?P<signal_total>\d+)\s+Signal level=(?P<signal_level_dBm>.+) d.+$"),
    re.compile(r"^Signal level=(?P<signal_quality>\d+)/(?P<signal_total>\d+).*$"),
]

class QWifiList(QObject):
    def getList(self):
        return scan_wifi()



def scan_nt(wifilist):
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

def scan_wifi():
    wifilist = []
    if platform.system() == 'Windows':
        scan_nt(wifilist)
    elif platform.system() == 'Linux':

        # try:
        proc = subprocess.Popen(["iwlist", "wlan0", "scan"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        res = proc.communicate()
        # print(list(proc.communicate())[1].decode("utf-8"))
        print(res[1].decode("utf-8"))

        if "Interface doesn't support scanning" in res[1].decode("utf-8"):
            
            proc = subprocess.Popen(["iwlist", "wlp3s0", "scanning"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)    
            res = proc.communicate()

        # wifilist = res[0].decode("utf-8").split('\n')

        lines = res[0].decode("utf-8").split('\n')
        for line in lines:
            line = line.strip()
            cell_number = cellNumberRe.search(line)
            if cell_number is not None:
                wifilist.append(cell_number.groupdict())
                continue
            for expression in regexps:
                result = expression.search(line)
                if result is not None:
                    wifilist[-1].update(result.groupdict())
                    continue

    # controller.SIGNALER.WIFI_REFRESH.emit(wifilist)
    return wifilist

if __name__ == "__main__":
    wlist = scan_wifi()
    pp.pprint(wlist)
