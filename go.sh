#!/usr/bin/env bash

./scripts/openHomePage.sh &
./scripts/screenSaverOff.sh
./scripts/hideMouseCursor.sh

exec node bootstrap.js
