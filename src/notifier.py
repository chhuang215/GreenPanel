import datetime
import threading
import controller

import slots

Slot = slots.Slot
SLOTS = slots.SLOTS

class Notifier:

    def __init__(self):
        self._timer = None
        self.is_activated = False
        self.lst_functions = []

    def __check_timer_loop(self):
        if not self.is_activated:
            return

        slots.check_slots()

        now = datetime.datetime.now()

        print("NOTIFIER loop", now)


        next_check_time = now.replace(second=0, microsecond=0)
        next_check_time += datetime.timedelta(minutes=1)
            
        interval = next_check_time - now
        print("NOTIFIER next check time", next_check_time)
        self._timer = threading.Timer(interval.total_seconds(), self.__check_timer_loop)
        self._timer.start()

    def activate(self):
        print("NOTIFIER ACTIVATED", datetime.datetime.now())
        if not self.is_activated:
            ### Activate timerv ###
            self.is_activated = True
            self.__check_timer_loop()
            #######################

    def deactivate(self):
        print("NOTIFIER DEACTIVATED", datetime.datetime.now())
        self._timer.cancel()
        self.is_activated = False

NOTIFIER = Notifier()
