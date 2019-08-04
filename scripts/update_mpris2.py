#!/usr/bin/env python3
"""
 This is script is a little hack to get realtime information on mpris2
 (spotify current track, for exampel)
 and not creating tons of load for the system.
 fork of https://github.com/polybar/polybar-scripts/blob/master/polybar-scripts/player-mpris-tail/player-mpris-tail.py
"""

import sys
import dbus
from operator import itemgetter
import argparse
import re
from urllib.parse import unquote
import time
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import os


DBusGMainLoop(set_as_default=True)


class PlayerManager:
    def __init__(self, connect = True):
        self._connect = connect
        self._session_bus = dbus.SessionBus()
        self.players = {}
        self.refreshPlayerList()

        if self._connect:
            self.connect()
            loop = GLib.MainLoop()
            try:
                loop.run()
            except KeyboardInterrupt:
                print("interrupt received, stopping…")

    def connect(self):
        self._session_bus.add_signal_receiver(self.onOwnerChangedName, 'NameOwnerChanged')

    def busNameIsAPlayer(self, bus_name):
        return bus_name.startswith('org.mpris.MediaPlayer2') and bus_name.split('.')[-1]

    def onOwnerChangedName(self, bus_name, old_owner, new_owner):
        if self.busNameIsAPlayer(bus_name):
            if new_owner and not old_owner:
                self.addPlayer(bus_name, new_owner)
            elif old_owner and not new_owner:
                self.removePlayer(old_owner)
            else:
                self.changePlayerOwner(bus_name, old_owner, new_owner)

    def refreshPlayerList(self):
        player_bus_names = [ bus_name for bus_name in self._session_bus.list_names() if self.busNameIsAPlayer(bus_name) ]
        for player_bus_name in player_bus_names:
            self.addPlayer(player_bus_name)

    def addPlayer(self, bus_name, owner = None):
        player = Player(self._session_bus, bus_name, owner = owner, connect = self._connect)
        self.players[player.owner] = player

    def removePlayer(self, owner):
        self.players[owner].disconnect()
        del self.players[owner]


    def changePlayerOwner(self, bus_name, old_owner, new_owner):
        player = Player(self._session_bus, bus_name, owner = new_owner, connect = self._connect)
        self.players[new_owner] = player
        del self.players[old_owner]


class Player:
    def __init__(self, session_bus, bus_name, owner = None, connect = True):
        self._session_bus = session_bus
        self.bus_name = bus_name
        self._disconnecting = False

        if owner is not None:
            self.owner = owner
        else:
            self.owner = self._session_bus.get_name_owner(bus_name)
        self._obj = self._session_bus.get_object(self.bus_name, '/org/mpris/MediaPlayer2')
        self._properties_interface = dbus.Interface(self._obj, dbus_interface='org.freedesktop.DBus.Properties')
        self._introspect_interface = dbus.Interface(self._obj, dbus_interface='org.freedesktop.DBus.Introspectable')
        self._media_interface      = dbus.Interface(self._obj, dbus_interface='org.mpris.MediaPlayer2')
        self._player_interface     = dbus.Interface(self._obj, dbus_interface='org.mpris.MediaPlayer2.Player')
        self._introspect = self._introspect_interface.get_dbus_method('Introspect', dbus_interface=None)
        self._getProperty = self._properties_interface.get_dbus_method('Get', dbus_interface=None)
        self._playerPlay      = self._player_interface.get_dbus_method('Play', dbus_interface=None)
        self._playerPause     = self._player_interface.get_dbus_method('Pause', dbus_interface=None)
        self._playerPlayPause = self._player_interface.get_dbus_method('PlayPause', dbus_interface=None)
        self._playerStop      = self._player_interface.get_dbus_method('Stop', dbus_interface=None)
        self._playerPrevious  = self._player_interface.get_dbus_method('Previous', dbus_interface=None)
        self._playerNext      = self._player_interface.get_dbus_method('Next', dbus_interface=None)
        self._playerRaise     = self._media_interface.get_dbus_method('Raise', dbus_interface=None)
        self._signals = {}

        if connect:
            self.connect()

    def connect(self):
        if self._disconnecting is not True:
            introspect_xml = self._introspect(self.bus_name, '/')
            if 'TrackMetadataChanged' in introspect_xml:
                self._signals['track_metadata_changed'] = self._session_bus.add_signal_receiver(self.onMetadataChanged, 'TrackMetadataChanged', self.bus_name)
            self._signals['properties_changed'] = self._properties_interface.connect_to_signal('PropertiesChanged', self.onPropertiesChanged)

    def send_signal(self):
        os.system("pkill -RTMIN+10 i3blocks")
        # print()
        os.system("~/petryfiles/scripts/blocklets/playerctl_status.sh")

    def disconnect(self):
        self._disconnecting = True
        self.send_signal()

    def onMetadataChanged(self, track_id, metadata):
        self.send_signal()

    def onPropertiesChanged(self, interface, properties, signature):
        updated = False
        self.send_signal()


if __name__ == '__main__':
    PlayerManager()
