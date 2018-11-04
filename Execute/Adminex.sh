#!/bin/bash
# adminex - sudo with zenity password window
# run:	adminex command
zenity	--title="Adminex" --text="Enter password for Adminex:" \
	--entry --entry-text "****" --hide-text \
	|sudo -S "$@"
