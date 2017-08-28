'''
slots.py

plant slots info and manipulation.

'''
import json
import datetime
from datetime import datetime, date, timedelta
import threading

import controller
import db
import plants

class Slot:
    '''
        stores basic information of a plant slot
    '''
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
        self.notify = True

    def insert_plant(self, plant_id, date_added=date.today()):
        """
        Insert Plant obj

        param:

        plant_id -- (int) ID of a plant
        """
        pname, pdays = plants.get_plant_data(plant_id)
        self.plant = plants.Plant(plant_id, name=pname, days_harvest=pdays)
        self.set_date_planted(date_added)
        self.status = Slot.OCCUPIED

    def remove_plant(self):
        """
        Remove plant from slot and reset every status
        """
        self.plant = None
        self.date_planted = None
        self.date_ready = None
        self.notify = True
        self.status = Slot.EMPTY

    def set_date_planted(self, date):
        """
        Set the date of when the plant is planted
        
        :param date: 
        """
        self.date_planted = date
        self.date_ready = self.date_planted + timedelta(days=self.plant.days_harvest)

    def check_and_update_status(self):
        """
        Check and return current slot status
        
        :returns: Slot.Ready=1 or Slot.Occupied=0 or Slot.Empty=-1
        """
        if self.plant is not None and self.days_passed >= self.plant.days_harvest:
            self.status = Slot.READY

        return self.status

    @property
    def days_passed(self):
        if self.date_planted is None:
            self.days = 0
            return 0

        now = date.today()
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
        check_nutrient()

        now = datetime.now()

        print("SLOTs timer loop", now)
        next_check_time = now.replace(hour=0, minute=0, second=0, microsecond=0)
        next_check_time += timedelta(days=1)
            
        interval = next_check_time - now
        print("SLOTs timer next check time", next_check_time)
        self._timer = threading.Timer(interval.total_seconds(), self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        print("SLOTs timer ACTIVATED", datetime.now())
        if not self.is_activated:
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        print("SLOTs timer DEACTIVATED", datetime.now())
        if self._timer is not None:
            self._timer.cancel()
        self.is_activated = False

REFRESH_TIMER = RefreshTimer()

SLOTS = None

NOTIFIED_SLOTS = []

def insert_plant(panel, slotnum, plantid, date_added=date.today()):
    s = SLOTS[panel][slotnum]
    if not isinstance(date_added, date):
        date_added = date_added.toPyDateTime().date()
    s.insert_plant(plantid, date_added)
    # db.execute_command("INSERT INTO SLOTS VALUES (?, ?, ?, ?)", panel, slotnum , plantid, s.date_planted)
    check_slots()
    db.store_slots_info({"slots": SLOTS})

def remove_plant(panel, slotnum):
    s = SLOTS[panel][slotnum]
    s.remove_plant()
    # db.execute_command("DELETE FROM SLOTS WHERE PANEL=? AND SLOT=?", panel, slotnum)
    check_slots()
    db.store_slots_info({"slots": SLOTS})

def syncdb():
    global SLOTS
    SLOTS = db.get_slots_info()["slots"]

def renew_nutrient_days(days):
    day_diff = 15 - days
    date_added = date.today()
    date_added -= timedelta(day_diff)
    db.store_slots_info({"nutrient_last_added":date_added})
    check_nutrient() #this will trigger nutrient days signal

def check_nutrient():
    last_added = db.get_slots_info()["nutrient_last_added"]
    days = 0
    if last_added is not None:
        delta = date.today() - last_added
        days = 15 - delta.days
        if days < 0:
            days = 0
    controller.SIGNALER.NUTRIENT_REFRESH.emit(days)

def check_slots():
    msg = ""
    ready_counter = 0
    for s_pane, s_row in SLOTS.items():
        for s in s_row:
            stat = s.check_and_update_status()
            if stat == Slot.READY and s.notify:
                ready_counter += 1
                msg += s_pane + str(s_row.index(s)+1) + " "
                if s not in NOTIFIED_SLOTS:
                    NOTIFIED_SLOTS.append(s)

    if ready_counter == 1:
        msg += "IS READY!"
    elif ready_counter > 1:
        msg += "ARE READY!"

    controller.SIGNALER.SLOTS_REFRESH.emit(get_slots_json_format(), msg)

def clear_notified():
    for s in NOTIFIED_SLOTS:
        s.notify = False

    NOTIFIED_SLOTS.clear()
    check_slots()

def json_seriel(obj):
    if isinstance(obj, (datetime, date)):
        return obj.strftime('%m/%d/%Y')
    return obj.__dict__

def get_slots_json_format():
    return json.loads(json.dumps(SLOTS, default=json_seriel))
