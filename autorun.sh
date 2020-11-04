#!/usr/bin/env bash

function run {
    if ! pgrep -f $1;
    then
        $@&
    fi
}

run picom --config ~/.config/picom/conf
run mpd
