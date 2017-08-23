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
        self.notify_confirmed = False

    def insert_plant(self, plant_id):
        pname, pdays = plants.get_plant_data(plant_id)
        self.plant = plants.Plant(plant_id, name=pname, days_harvest=pdays)
        self.set_date_planted(datetime.date.today())
        self.status = Slot.OCCUPIED

    def remove_plant(self):
        self.plant = None
        self.date_planted = None
        self.date_ready = None
        self.notify_confirmed = False
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

class RefreshTimer():

    def __init__(self):
        self._timer = None
        self.is_activated = False

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        check_slots()

        now = datetime.datetime.now()

        print("SLOTs timer loop", now)
        next_check_time = now.replace(second=0, microsecond=0)
        next_check_time += datetime.timedelta(minutes=1)
            
        interval = next_check_time - now
        print("SLOTs timer next check time", next_check_time)
        self._timer = threading.Timer(interval.total_seconds(), self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        print("SLOTs timer ACTIVATED", datetime.datetime.now())
        if not self.is_activated:
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        print("SLOTs timer DEACTIVATED", datetime.datetime.now())
        if self._timer is not None:
            self._timer.cancel()
        self.is_activated = False

REFRESH_TIMER = RefreshTimer()

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

READY_NOT_CONFIRMED_SLOTS = []

def insert_plant(panel, slotnum, plantid):
    s = SLOTS[panel][slotnum]
    s.insert_plant(plantid)
    db.execute_command("INSERT INTO SLOTS VALUES (?, ?, ?, ?)", panel, slotnum , plantid, s.date_planted)
    check_slots()

def remove_plant(panel, slotnum):
    s = SLOTS[panel][slotnum]
    s.remove_plant()
    db.execute_command("DELETE FROM SLOTS WHERE PANEL=? AND SLOT=?", panel, slotnum)
    check_slots()

def syncdb():
    data = db.execute_command("SELECT PANEL, SLOT, PLANT, DATE_PLANTED from SLOTS")
    # print(data)
    for aslot in data:
        panel = aslot[0]
        slotnum = aslot[1]
        plantid = aslot[2]
        date_planted = aslot[3]

        SLOTS[panel][slotnum].insert_plant(plantid)
        SLOTS[panel][slotnum].set_date_planted(date_planted)

def check_slots():
    msg = ""
    ready_counter = 0
    for sp, sr in SLOTS.items():
        for s in sr:
            stat = s.check_status()
            if stat == Slot.READY and not s.notify_confirmed:
                ready_counter += 1
                msg += sp + str(sr.index(s)+1) + " "
                READY_NOT_CONFIRMED_SLOTS.append(s)
                
    if ready_counter == 1:
        msg += "IS READY!"
    elif ready_counter > 1:
        msg += "ARE READY!"

    controller.SIGNALER.SLOTS_REFRESH.emit(getSlotsJson(), msg)

def clear_notified():
    for s in READY_NOT_CONFIRMED_SLOTS:
        s.notify_confirmed = True

    READY_NOT_CONFIRMED_SLOTS.clear()
    check_slots()

def json_seriel(obj):
    if isinstance(obj, (datetime.datetime, datetime.date)):
        return obj.isoformat()
    return obj.__dict__

def getSlotsJson():
    return json.loads(json.dumps(SLOTS, default=json_seriel))
