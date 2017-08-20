

TYPES = []

class Plant:
    def __init__(self, name="Plant", days_harvest=21):
        self.name = name
        self.days_harvest = days_harvest
        self.description = "This is " + name

class Lettuce(Plant):
    def __init__(self):
        super().__init__(name="Lettuce", days_harvest=21)
