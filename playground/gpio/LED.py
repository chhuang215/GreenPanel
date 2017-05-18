import RPi.GPIO as GPIO

import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(18, GPIO.OUT)
GPIO.setup(23, GPIO.OUT)
GPIO.setup(17,GPIO.IN, pull_up_down=GPIO.PUD_UP)


try:
	while True:
		input_state = GPIO.input(17)
		if(input_state == False):
			print('LED OFF')
			time.sleep(0.2)
			GPIO.output(18, GPIO.LOW)
			GPIO.output(23, GPIO.HIGH)
		else:
			print('LED ON')
			GPIO.output(18, GPIO.HIGH)
			GPIO.output(23, GPIO.LOW)

except KeyboardInterrupt:
	GPIO.cleanup()

finally:
	GPIO.cleanup()


#print("LED on")

#GPIO.output(18, GPIO.HIGH)

#time.sleep(5)

#GPIO.output(18, GPIO.LOW)
#print("LED OFF")

