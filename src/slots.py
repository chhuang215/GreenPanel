import json
import datetime
import threading
import controller

import plants

class Slot:    

    EMPTY = -1
    OCCUPIED = 0
    READY = 1

    def __init__(self, status=EMPTY):
        self.status = status
        self.plant = None
        self.date_planted = None
        self.date_ready = None
        self.days = self.days_passed
        self.selected = False

    def insert_plant(self, plant):
        self.plant = plant
        self.set_date_planted(datetime.date.today())
        self.status = Slot.OCCUPIED

    def remove_plant(self):
        self.plant = None
        self.date_planted = None
        self.date_ready = None
        self.status = Slot.EMPTY

    def set_date_planted(self, date):
        self.date_planted = date
        self.date_ready = self.date_planted + datetime.timedelta(days=self.plant.days_harvest)

    def check_status(self):
        if self.plant is not None and self.days_passed >= self.plant.days_harvest:
            self.status = Slot.READY

        return self.status

    @property
    def days_passed(self):
        if self.date_planted is None:
            self.days = 0
            return 0

        now = datetime.date.today()
        delta = now - self.date_planted
        self.days = delta.days
        return self.days 

SLOTS = {
    "A": [Slot(), Slot(), Slot()],
    "B": [Slot(), Slot()],
    "C": [Slot(), Slot(), Slot()],
    "D": [Slot(), Slot()],
    "E": [Slot(), Slot(), Slot()],
    "F": [Slot(), Slot()],
    "G": [Slot(), Slot(), Slot()],
    "H": [Slot(), Slot()]
    }

SLOTS["A"][1].insert_plant(plants.Plant(name="PlantA2"))
SLOTS["A"][1].set_date_planted(datetime.date(2017, 1, 1))
SLOTS["A"][1].check_status()
SLOTS["A"][2].insert_plant(plants.Lettuce())

def json_seriel(obj):
    if isinstance(obj, (datetime.datetime, datetime.date)):
        return obj.isoformat()
    return obj.__dict__

def getSlotsJson():
    return json.loads(json.dumps(SLOTS, default=json_seriel))

def check_slots():
    msg = ""
    ready_counter = 0
    for sp, sr in SLOTS.items():
        for s in sr:
            stat = s.check_status()
            if stat == Slot.READY:
                ready_counter += 1
                msg += sp + str(sr.index(s)+1) + " "
                
    if ready_counter == 1:
        msg += "IS READY!"
    elif ready_counter > 1:
        msg += "ARE READY!"
    
    return msg