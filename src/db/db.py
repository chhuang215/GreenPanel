'''db.py'''

import pickle


def get_plants_data():
    return get_file_obj('db/plants.pickle')

def store_slots_info(newinfo):
    info = get_slots_info()
    info.update(newinfo)
    store_file_obj('db/plantslots.pickle', info)

def get_slots_info():
    try:
        obj = get_file_obj('db/plantslots.pickle')
    except KeyError:
        reset_slots()
        obj = get_file_obj('db/plantslots.pickle')
    return obj

def store_setting(newsetting):
    '''newsetting: {'light_hour', 'light_duration', 'temperature_unit', 'language'})'''
    settings = get_setting()
    settings.update(newsetting)
    store_file_obj('db/setting.pickle', settings)

def get_setting():
    '''returns: {'light_hour' int, 'light_duration' int, 'temperature_unit' str, 'language' str}'''
    return get_file_obj('db/setting.pickle')

def store_file_obj(filepath, data):
    with open(filepath, 'wb') as f:
        pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)

def get_file_obj(filepath):
    with open(filepath, 'rb') as f:
        filedata = pickle.load(f)
    return filedata

def reset_setting():
    init_setting = {
        "light_hour" : 7,
        "light_duration": 17,
        "temperature_unit": "c",
        "language": "en",
        "year_offset": 0,
        "month_offset": 0,
        "day_offset": 0,
        "hour_offset": 0,
        "minute_offset": 0,
        "second_offset": 0,
    }
    with open('db/setting.pickle', 'w+b') as setting_file:
        pickle.dump(init_setting, setting_file, protocol=pickle.HIGHEST_PROTOCOL)

def reset_slots():
    import slots
    # Slot = slots.Slot
    PlantSlot = slots.PlantSlot
    plant_slots = {
        "nutrient_last_added": None,
        # "slots": {
        #     "A": [Slot(), Slot(), Slot()],
        #     "B": [Slot(), Slot()],
        #     "C": [Slot(), Slot(), Slot()],
        #     "D": [Slot(), Slot()],
        #     "E": [Slot(), Slot(), Slot()],
        #     "F": [Slot(), Slot()],
        #     "G": [Slot(), Slot(), Slot()],
        #     "H": [Slot(), Slot()]
        # },
        "plant_slots": {
            "A": [PlantSlot(), PlantSlot(), PlantSlot()],
            "B": [PlantSlot(), PlantSlot()],
            "C": [PlantSlot(), PlantSlot(), PlantSlot()],
            "D": [PlantSlot(), PlantSlot()],
            "E": [PlantSlot(), PlantSlot(), PlantSlot()],
            "F": [PlantSlot(), PlantSlot()],
            "G": [PlantSlot(), PlantSlot(), PlantSlot()],
            "H": [PlantSlot(), PlantSlot()]
        }
    }
    
    with open('db/plantslots.pickle', 'w+b') as ps_file:
        pickle.dump(plant_slots, ps_file, protocol=pickle.HIGHEST_PROTOCOL)

def reset_plants_data():
    plants_data = [
        {
            "id" : 1,
            "name" : "Romaine Lettuce",
            "img" : "icon_plant_1_romaine.png",
            "days" : 21
        },
        {
            "id" : 2,
            "name" : "Bok Choy",
            "img" : "icon_plant_2_bokchoy.png",
            "days" : 21
        },

    ]
    with open('db/plants.pickle', 'w+b') as plants_file:
        pickle.dump(plants_data, plants_file, protocol=pickle.HIGHEST_PROTOCOL)

def reset_all():
    '''Reset all db and setting'''
    reset_setting()
    reset_plants_data()
    reset_slots()
    
    with open('db/setting.pickle', 'rb') as setting_file, open('db/plantslots.pickle', 'rb') as ps_file, open('db/plants.pickle', 'rb') as plants_file:
        settings = pickle.load(setting_file)
        pslots = pickle.load(ps_file)
        plants = pickle.load(plants_file)
        print(settings)
        print(pslots)
        print(plants)
