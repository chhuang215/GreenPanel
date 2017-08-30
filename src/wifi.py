import os
import subprocess
import platform
import pprint
pp = pprint.PrettyPrinter(indent=4)
def scan_wifi():
    
    wifilist = []
    if platform.system() == 'Windows':
        result = subprocess.check_output(["netsh", "wlan", "show", "all"])
        result = result.decode("ascii") # needed in python 3
        result = result.replace("\r","")
        result = result[result.index("SHOW NETWORKS MODE=BSSID"):]
        result = result[result.index("Interface name : Wi-Fi"):]
        
        result = result[:result.index("=")]
        # print(result)
        result = [x.strip() for x in result.split("\n") if x]
        
        
        networkfound = False
        for elem in result:
            if ("SSID" in elem and "BSSID" not in elem):
                wifilist.append({})
                networkfound = True
            if networkfound:
                key = elem.split(":")
                key = elem[:elem.index(":")].strip()
                val = elem[elem.index(":")+1:].strip()
                wifilist[-1][key] = val
        # pp.pprint(wifilist)
    elif platform.system() == 'Linux':
        subprocess.call("iwlist wlan0 scan")

    return wifilist

if __name__ == "__main__":
    wlist = scan_wifi()
    
    pp.pprint(wlist)