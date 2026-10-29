#!/usr/bin/env python3
"""Hide windows on a named workspace; restore the most recently hidden first."""
import json
import subprocess
import sys


def query(name):
    return json.loads(subprocess.check_output(["niri", "msg", "-j", name], text=True))


def action(*args):
    subprocess.run(["niri", "msg", "action", *map(str, args)], check=True)


workspaces = query("workspaces")
holding = next((w for w in workspaces if w["name"] == "__hidden"), None)
current = next((w for w in workspaces if w["is_focused"]), None)
if holding is None or current is None:
    sys.exit(0)
if current["id"] == holding["id"]:
    subprocess.run(["notify-send", "Hidden windows", "Switch to your working workspace first, then use Super + Shift + Minus to restore a window."])
    sys.exit(0)
# Keep the holding area after normal workspaces, out of the usual workspace 1 slot.
action("move-workspace-to-index", "--reference", "__hidden", len(workspaces))
# Indices may change when the hidden workspace moves.
current = next(w for w in query("workspaces") if w["id"] == current["id"])
windows = query("windows")
if sys.argv[1:] == ["hide"]:
    window = next((w for w in windows if w["is_focused"]), None)
    if window:
        action("move-window-to-workspace", "--window-id", window["id"], "--focus", "false", "__hidden")
elif sys.argv[1:] == ["restore"]:
    hidden = [w for w in windows if w["workspace_id"] == holding["id"]]
    if hidden:
        window = max(hidden, key=lambda w: ((w.get("focus_timestamp") or {}).get("secs", 0), (w.get("focus_timestamp") or {}).get("nanos", 0)))
        action("move-window-to-workspace", "--window-id", window["id"], "--focus", "false", current["idx"])
        action("focus-window", "--id", window["id"])
