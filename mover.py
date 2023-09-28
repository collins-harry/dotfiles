import pyautogui
import time
import random
import sys

RUN_TIME = 60*8 #mins
PERIOD_OF_TIME = RUN_TIME * 60

pyautogui.FAILSAFE = False

def switch_screens() -> None:
    max_switches = random.randint(1,5)
    pyautogui.keyDown('alt')
    for _ in range(1, max_switches):
        pyautogui.press("tab")
    pyautogui.keyUp('alt')


def wiggle_mouse_small() -> None:
    max_wiggles = random.randint(4,9)
    for _ in range(1, max_wiggles):
        x, y = pyautogui.position()
        pyautogui.moveTo(
                x=x+1,
                y=y+1,
                duration=0.01
                )
        print("moved")
        time.sleep(10)

def wiggle_mouse_big() -> None:
    max_wiggles = random.randint(4,9)
    for _ in range(1, max_wiggles):
        coords = get_random_coords()
        pyautogui.moveTo(
                x=coords[0],
                y=coords[1],
                duration=5
                )
        time.sleep(10)


def get_random_coords() -> []:
    screen = pyautogui.size()
    width = screen[0]
    height = screen[1]
    return [random.randint(100, width-200),
            random.randint(100, height-200)
            ]

if __name__ == "__main__":
    print("press Ctrl-C to quit")
    start = time.time()
    while time.time() < start + PERIOD_OF_TIME:
        wiggle_mouse_small()
        switch_screens()

