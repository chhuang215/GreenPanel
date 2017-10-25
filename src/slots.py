'''
slots.py

plant slots info and manipulation.

'''
import json
import datetime
from datetime import datetime, date, timedelta
import threading

from PyQt5.QtCore import QObject, QDateTime, QDate, pyqtProperty, pyqtSignal, pyqtSlot
from PyQt5.QtQuick import QQuickItem
from PyQt5.QtQml import QQmlListProperty

import controller
import db
import plants

# class AllPlantSlots(QObject):
#     plantSlotsChanged = pyqtSignal()
#     def __init__(self):
#         super().__init__(self)
#         self._slots = {}

        
#     @pyqtProperty(QQmlListProperty, notify=plantSlotsChanged)
#     def slots(self):
#         return self._slots

#     @slots.setter
#     def slots(self, s):
#         self._slots = s
#         self.plantSlotsChanged.emit()

#     def reset_selection(self):
#         pass

#     def modify_slot(self, p, n, data):
#         self._slots[p][n] = data
#         self.plantSlotsChanged.emit()
     


class PlantSlot(QObject):
    '''
        stores basic information of a plant slot
    '''
    EMPTY = -1
    OCCUPIED = 0
    READY = 1
    
    statusChanged = pyqtSignal()
    datePlantedChanged = pyqtSignal()
    daysPassedChanged = pyqtSignal()
    selectedChanged = pyqtSignal()
    plantChanged = pyqtSignal()
    
    def __init__(self, status=EMPTY):
        
        super().__init__()

        self._position = ('A', 0)
        self._status = status
        self._plant = None
        self._date_planted = QDate()
        self._days = 0
        self._selected = False
        self._noti = True
        

        # self.status = status
        # self.plant = None
        # self.date_planted = None
        # self.date_ready = None
        # self.days = self.days_passed
        # self.selected = False
        # self.notify = True

    @pyqtProperty(QObject, notify=plantChanged)
    def plant(self):
        return self._plant

    @pyqtProperty(int, notify=statusChanged)
    def status(self):
        return self._status
    
    @pyqtProperty(QDate, notify=datePlantedChanged)
    def datePlanted(self):
        
        return self._date_planted

    @datePlanted.setter
    def datePlanted(self, d):
        """
        Set the date of when the plant is planted

        :param date:
        """
        self._date_planted = d
        self.datePlantedChanged.emit()
        self.daysPassedChanged.emit()
        self.update_and_refresh_data()

    @pyqtProperty(QDate, notify=datePlantedChanged)
    def dateReady(self):
        # return self._date_planted + timedelta(days=self._plant.days_harvest)
        if self.plant is not None:
            return QDate(self._date_planted).addDays(self._plant.days_harvest)
        return self._date_planted

    @pyqtProperty(int, notify=daysPassedChanged)
    def daysPassed(self):
        if not self._date_planted.isValid():
            return 0
        return self._date_planted.daysTo(QDate.currentDate())

    @pyqtProperty(int, notify=selectedChanged)
    def selected(self):
        return self._selected

    @selected.setter
    def selected(self, is_selected):
        self._selected = is_selected
        self.selectedChanged.emit()

    @pyqtSlot(QDate)
    def editDatePlanted(self, d):
        self.datePlanted = d
        save()

    @pyqtSlot()
    def clearDatePlanted(self):
        self.datePlanted = QDate()

    def insert_plant(self, plant_id, date_planted):
        """
        Insert Plant obj

        param:

        plant_id -- (int) ID of a plant
        """
        pname, pdays = plants.get_plant_data(plant_id)
        self._plant = plants.Plant(plant_id, name=pname, days_harvest=pdays)
        self.plantChanged.emit()
        # self.datePlanted = date_planted
        self.datePlanted = date_planted
        self.update_and_refresh_data()
        # self.datePlantedChanged.emit()

    @pyqtSlot()
    def removePlant(self):
        self.remove_plant()

    def remove_plant(self):
        self._plant = None
        self.plantChanged.emit()
        self.clearDatePlanted()
        self._noti = True
        self.update_and_refresh_data()

    def update_and_refresh_data(self):
        if self._plant is None:
            self._status = PlantSlot.EMPTY
            if self in NOTIFIED_SLOTS:
                NOTIFIED_SLOTS.remove(self)
        elif self.daysPassed >= self._plant.days_harvest:
            self._status = PlantSlot.READY
        else:
            self._status = PlantSlot.OCCUPIED
            if self in NOTIFIED_SLOTS:
                NOTIFIED_SLOTS.remove(self)

        self.statusChanged.emit()

    def __getstate__(self):
        return self.__dict__

    def __setstate__(self, dic):
        super().__init__()
        self.__dict__ = dic

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

# TODO need to remove all selected when cancel adding/remove etc
PLANTSLOTS = {}
#     "A": [PlantSlot(), PlantSlot(), PlantSlot()],
#     "B": [PlantSlot(), PlantSlot()],
#     "C": [PlantSlot(), PlantSlot(), PlantSlot()],
#     "D": [PlantSlot(), PlantSlot()],
#     "E": [PlantSlot(), PlantSlot(), PlantSlot()],
#     "F": [PlantSlot(), PlantSlot()],
#     "G": [PlantSlot(), PlantSlot(), PlantSlot()],
#     "H": [PlantSlot(), PlantSlot()]

NOTIFIED_SLOTS = []

def syncdb():
    # global SLOTS
    global PLANTSLOTS
    # SLOTS = db.get_slots_info()["slots"]
    psdict = db.get_slots_info()["plant_slots"]
    print(psdict)
    PLANTSLOTS = psdict
    # for s_pane, s_row in psdict.items():
    #     # print(s_pane, s_row)
    #     for index, item in enumerate(s_row):

    #         PLANTSLOTS[s_pane][index].__dict__ = item.__dict__
    #         print(type(PLANTSLOTS[s_pane][index].plant))
    # print(PLANTSLOTS['A'][1].a_function())

def save():
    check_slots()
    # db.store_slots_info({"slots": SLOTS})
    db.store_slots_info({"plant_slots": PLANTSLOTS})
    print("[!SAVED!]PLANTSLOTS")
    
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
    print("[!CHECKING!]PLANTSLOTS")
    msg = ""
    ready_counter = len(NOTIFIED_SLOTS)

    for s_pane, s_row in PLANTSLOTS.items():
        for s in s_row:
            s.update_and_refresh_data()

            if s._status == PlantSlot.READY and s._noti:
                ready_counter += 1
                msg += s_pane + str(s_row.index(s)+1) + " "
                if s not in NOTIFIED_SLOTS:
                    NOTIFIED_SLOTS.append(s)

    if ready_counter == 1:
        msg += "IS READY!"
    elif ready_counter > 1:
        msg += "ARE READY!"

    controller.SIGNALER.SLOTS_REFRESH.emit(msg)

def clear_notified():
    for s in NOTIFIED_SLOTS:
        s._noti = False

    NOTIFIED_SLOTS.clear()
    check_slots()
