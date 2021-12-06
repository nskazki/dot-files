#!/usr/bin/env python3
import subprocess

from pynput import keyboard

CAPS = keyboard.KeyCode(16777215)
SHIFT = keyboard.Key.shift

class Switcher:
    def __init__(self):
        self.caps = False
        self.shift = False

    def on_press(self, key):
        print(key)
        if key == CAPS:
            self.caps = True
            print('caps')
        elif key == SHIFT:
            self.shift = True
            print('shift')

    def on_release(self, key):
        if self.caps and self.shift:
            self.switch(1)
        elif self.caps:
            self.switch(0)

        self.caps = False
        self.shift = False

    def switch(self, layout):
        command = [
            "gsettings",
            "set",
            "org.gnome.desktop.input-sources",
            "current",
            str(layout),
        ]
        _exitcode = subprocess.call(
            command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def main():
    switcher = Switcher()

    with keyboard.Listener(
            on_press=switcher.on_press,
            on_release=switcher.on_release) as listener:
        listener.join()


if __name__ == '__main__':
    main()