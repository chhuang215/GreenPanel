import json

class Slot:    
    def __init__(self, stat=-1):
        self.status = stat

SLOTS = {
    "A": [Slot(), Slot(stat=1), Slot(stat=0)],
    "B": [Slot(), Slot()],
    "C": [Slot(), Slot(), Slot()],
    "D": [Slot(), Slot()],
    "E": [Slot(), Slot(), Slot()],
    "F": [Slot(), Slot()],
    "G": [Slot(), Slot(), Slot()],
    "H": [Slot(), Slot()]
    }

def getSlotsJson():
    return json.loads(json.dumps(SLOTS, default=lambda o: o.__dict__))
