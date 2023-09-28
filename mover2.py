import pyautogui
import time
from pynput import keyboard, mouse

## CONFIG ##
RUN_TIME_MINS = 60*2 #mins
WAIT_TIME_MINS = 3 #mins
## /CONFIGS ##

PERIOD_OF_TIME = RUN_TIME_MINS * 60
WAIT_TIME = WAIT_TIME_MINS * 60
pyautogui.FAILSAFE = False

def on_action(x):
    global last_action_time
    last_action_time = time.time()

keyboard_listener = keyboard.Listener(on_press=on_action)
mouse_listener = mouse.Listener(on_press=on_action)
keyboard_listener.start()
mouse_listener.start()

def switch_screens() -> None:
    print("Switched Screens")
    num_switches = 2
    for _ in range(num_switches):
        pyautogui.keyDown("alt")
        pyautogui.press("tab")
        pyautogui.keyUp("alt")

if __name__ == "__main__":
    print("press ctrl-c to quit")
    start = time.time()
    last_action_time = time.time()
    while time.time() < start + PERIOD_OF_TIME:
        if time.time() - last_action_time > WAIT_TIME:
            switch_screens()
            time.sleep(0.1)
            last_action_time = time.time()
        time.sleep(1)


