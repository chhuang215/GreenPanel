import db

TYPES = []

class Plant:
    def __init__(self, plant_id, name="Plant", days_harvest=21):
        self.plant_id = plant_id
        self.name = name
        self.days_harvest = days_harvest
        self.description = "This is " + name

def get_plant_data(plant_id):
    plants = get_all_plants()
    data = plants[plant_id]
    return data["name"], data["days"]

def get_all_plants():
    '''
    returns list of all plants' data

    [ {"name", "days"} ]
    '''
    plants = db.get_plants_data()
    return plants
