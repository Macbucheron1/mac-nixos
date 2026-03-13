#!/usr/bin/env bash
set -euo pipefail
export PATH="@PATH@"

rt="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
cache="$rt/vibepods/status.json"

if [ ! -f "$cache" ]; then
  jq -nc '{ text: "", tooltip: "", class: "hidden" }'
  exit 0
fi

jq -rc '
  def pct(v): if v == null then "?" else (v | tostring) end;
  def styled_pct(v; in_ear):
    if in_ear == false then
      "<span foreground=\"#8a8a8a\">" + pct(v) + "</span>"
    else
      pct(v)
    end;
  def has_battery:
    (.left_battery != null) or (.right_battery != null) or (.headset_battery != null);
  def device_name: .name // "AirPods";
  def base_tooltip: device_name + "\nClick to refresh";
  if .daemon_running != true or .connected != true or .protocol_connected != true or (has_battery | not) then
    {
      text: "",
      tooltip: "",
      class: "hidden"
    }
  elif .headset_battery != null then
    {
      text: ("󰋎 " + pct(.headset_battery) + "%"),
      tooltip: (
        base_tooltip
        + "\nBattery: " + pct(.headset_battery) + "%"
      ),
      class: "connected"
    }
  else
    {
      text: ("󰋎 " + styled_pct(.left_battery; .left_in_ear) + "/" + styled_pct(.right_battery; .right_in_ear) + "%"),
      tooltip: (
        base_tooltip
        + "\nL: " + pct(.left_battery) + "%"
        + "\nR: " + pct(.right_battery) + "%"
        + (if .case_battery == null then "" else "\nCase: " + (.case_battery | tostring) + "%" end)
      ),
      class: "connected"
    }
  end
' "$cache"
