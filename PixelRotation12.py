import time
import random
import dxcam
from PIL import Image
import pyautogui
import keyboard

dx_camera = dxcam.create(device_idx=0, output_idx=0, output_color="RGB")

region = (0, 0, 32, 32)

dx_camera.start(region=region, video_mode=True, target_fps=120)

# 标志变量
continue_loop = True


def star_loop():
    print("开始")
    global continue_loop
    continue_loop = True


def stop_loop():
    print("停止")
    global continue_loop
    continue_loop = False


keyboard.add_hotkey('alt+q', star_loop)
keyboard.add_hotkey('alt+e', stop_loop)

while True:
    time.sleep(random.uniform(0.1, 0.3))
    if not continue_loop:

        continue
    frame = dx_camera.get_latest_frame()
    img = Image.fromarray(frame)
    pixel_color = img.getpixel((16, 16))

    if pixel_color == (255, 255, 255):
        print("闲置")
    elif pixel_color == (0, 0, 0):
        print("闲置")
    elif pixel_color == (0, 0, 128):
        print("正义盾击")
        pyautogui.press("num1")
    elif pixel_color == (0, 0, 255):
        print("祝福之锤")
        pyautogui.press("num2")
    elif pixel_color == (0, 128, 0):
        print("复仇者之盾")
        pyautogui.press("num3")
    elif pixel_color == (0, 128, 128):
        print("奉献")
        pyautogui.press("num4")
    elif pixel_color == (0, 128, 255):
        print("愤怒之锤")
        pyautogui.press("num5")
    elif pixel_color == (0, 255, 0):
        print("荣耀圣令")111
        pyautogui.press("num6")
    elif pixel_color == (0, 255, 128):
        print("审判")
        pyautogui.press("num7")
    # elif pixel_color == (0, 255, 255):
    #     print("吸血鬼之血")
    #     pyautogui.press("num8")
    # elif pixel_color == (255, 0, 0):
    #     print("吞噬")
    #     pyautogui.press("num9")
    # elif pixel_color == (255, 0, 128):
    #     print("墓石")
    #     pyautogui.press("add")
    # elif pixel_color == (255, 0, 255):
    #     print("枯萎凋零")
    #     pyautogui.press("subtract")

