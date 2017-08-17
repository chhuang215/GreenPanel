

TYPES = []

class Plant:
    def __init__(self, name="Plant", days_harvest=21):
        self.name = name
        self.days_harvest = days_harvest
        self.hold = None