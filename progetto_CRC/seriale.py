import time
import serial

# Configura la comunicazione seriale
ser = serial.Serial('COM3', 9600)

print("------------------------------------------------")
time.sleep(1)
print("c")

while(True):
    
    print(ser.readline())
    time.sleep(0.5)

