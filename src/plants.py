import db
from PyQt5.QtCore import QObject, QDateTime, pyqtProperty, pyqtSignal, pyqtSlot
PLANTS_LIST = db.get_plants_data()

class Plant(QObject):

    nameChanged = pyqtSignal()
    descriptionChanged = pyqtSignal()

    def __init__(self, plant_id, name="Plant", days_harvest=21):
        super().__init__()
        self._plant_id = plant_id
        self._name = name
        self._days_harvest = days_harvest
        self._description = "This is " + name \
                            + "\nShould be ready in " + str(days_harvest) + " days."
    
    @pyqtProperty(int)
    def plant_id(self):
        return self._plant_id

    @plant_id.setter
    def plant_id(self, pid):
        self._plant_id = pid
    
    @pyqtProperty(str, notify=nameChanged)
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @pyqtProperty(int)
    def days_harvest(self):
        return self._days_harvest

    @days_harvest.setter
    def days_harvest(self, val):
        self._days_harvest = val

    @pyqtProperty(str, notify=descriptionChanged)
    def description(self):
        return self._description

    @description.setter
    def description(self, des):
        self._description = des

    def __getstate__(self):
        return self.__dict__

    def __setstate__(self, d):
        super().__init__()
        self.__dict__ = d

# print("new plant test")
# aPlant = Plant(0)
# aPlant.__st
# aPlantDic = aPlant.__dict__

# print(aPlantDic)

# aPlant.plant_id = 1

# print(aPlantDic)

def get_plant_data(plant_id):
    data = PLANTS_LIST[plant_id]
    return data["name"], data["days"]
