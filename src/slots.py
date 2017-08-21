import json
import datetime
import threading
import controller

import db
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

    def insert_plant(self, plant_id):
        pname, pdays = plants.get_plant_data(plant_id)
        self.plant = plants.Plant(plant_id, name=pname, days_harvest=pdays)
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


def insert_plant(panel, slotnum, plantid):
    s = SLOTS[panel][slotnum]
    s.insert_plant(plantid)
    db.exectute_command("INSERT INTO SLOTS VALUES (?, ?, ?, ?)", panel, slotnum , plantid, s.date_planted)

def remove_plant(panel, slotnum):
    s = SLOTS[panel][slotnum]
    s.remove_plant()
    db.exectute_command("DELETE FROM SLOTS WHERE PANEL=? AND SLOT=?", panel, slotnum)

def syncdb():
    data = db.exectute_command("SELECT PANEL, SLOT, PLANT, DATE_PLANTED from SLOTS")
    # print(data)
    for aslot in data:
        panel = aslot[0]
        slotnum = aslot[1]
        plantid = aslot[2]
        date_planted = aslot[3]

        SLOTS[panel][slotnum].insert_plant(plantid)
        SLOTS[panel][slotnum].set_date_planted(date_planted)

def check_slots():
    # syncdb()
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

def json_seriel(obj):
    if isinstance(obj, (datetime.datetime, datetime.date)):
        return obj.isoformat()
    return obj.__dict__

def getSlotsJson():
    return json.loads(json.dumps(SLOTS, default=json_seriel))
