import db

TYPES = []

class Plant:
    def __init__(self, plant_id, name="Plant", days_harvest=21):
        self.plant_id = plant_id
        self.name = name
        self.days_harvest = days_harvest
        self.description = "This is " + name

def get_plant_data(plant_id):
    data = db.execute_command("SELECT NAME, DAYS from PLANTS where ID=?", plant_id)[0]    
    return data[0], data[1]

def get_all_plants():
    data = db.execute_command("SELECT * from PLANTS")
    return data