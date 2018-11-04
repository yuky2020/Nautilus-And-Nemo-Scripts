#!/usr/bin/env python
# -*- coding: latin-1 -*-

import gtk
import os
import string

commandHasError = False
command = ""
program = ""
readdirectory = True
typefiles = []
arguments = []

def alert (message):
	dialog = gtk.MessageDialog(None, gtk.DIALOG_MODAL, gtk.MESSAGE_INFO, gtk.BUTTONS_CLOSE, message)
	dialog.run()
	dialog.destroy()

def verifyCommands(com):

	table=[]
	for bin in string.split(os.getenv("PATH"),":"):
		if os.path.isdir(bin):
			for exe in os.listdir(os.path.expanduser(bin)):
				if exe not in table:
					table.append(exe)
	commands = com.split("|")

	strError = "Para ejecutar este script necesita los siguientes comandos:"

	err = False

	for c in commands:
		prog = c.split("%")
		if prog[0] not in table:
			err=True
			strError=strError+"\n    * " + prog[0]
			if len(prog)>1:
				strError=strError+" (del paquete \""+ prog[1]+"\")"

	if err==True:
		alert(strError)
		return False
	else:
		return True

def getExtension(f):
	pieces = f.split(".")
	return string.upper(pieces[len(pieces)-1])

def getName(f):
	pieces = f.split("/")
	namepieces = pieces[len(pieces)-1].split(".")
	namepieces = namepieces[0:len(namepieces)-1]
	name = ""
	i = 0
	for namepiece in namepieces:
		if namepiece != "":
			if i == 0:
				name = name + namepiece
			else:
				name = name + "." + namepiece
		i = i + 1
	
	return name

def getPath(f):
	pieces = f.split("/")
	path = ""
	piecespath = pieces[0:len(pieces)-1]
	for piece in piecespath:
		if piece != "":
			path = path + "/" + piece
	return path

def getFile(f):
	pieces = f.split("/")
	return pieces[len(pieces)-1]

def getCurrentDirectory():
	files = os.environ['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'].split("\n")
	for f in files:
		if f != "":
			return getPath(f)
	return ""

def ProcessFileByArgument(com):
	global commandHasError
	global arguments
	global command
	global program
	global typefiles
	global readdirectory

	fillParameters(com)

	sig = os.spawnvp(os.P_WAIT, program, (program,) +  tuple(arguments))

	cmdTXT = program
	for arg in arguments:
		cmdTXT = cmdTXT + " " + arg

	if sig > 0:
		commandHasError = True
		alert("Se ha producido un error al ejecutar el comando.\nCompruebe que está bien construido\n\nError en:\n\n"+cmdTXT)

def ProcessFile(f):
	global commandHasError
	global arguments
	global command
	global program
	global typefiles
	global readdirectory

	todo = False

	if len(typefiles)>0:
		for typefile in typefiles:
			if getExtension(f) == string.upper(typefile):
				todo = True
	else:
		todo = True

	if todo==True:

		newArguments = []
	
		for arg in arguments:
			pieces = arg.split("$")
			hasFILE = False
			for piece in pieces:
				if piece == "FILE" or piece == "NAME" or piece == "EXT":
					hasFILE = True

			argument = ""

			if hasFILE==True:
				argument = getPath(f) + "/"
				for piece in pieces:
					if piece == "FILE":
						argument = argument + getFile(f)
					elif piece == "NAME":
						argument = argument + getName(f)
					elif piece == "EXT":
						argument = argument + getExtension(f)
					else:
						if piece[0:2] == "@-":
							argument = piece[2:] + argument
						else:
							argument = argument + piece
			else:
				for piece in pieces:
					argument = argument + piece

			newArguments.append(argument)

		cmdTXT = program
		for arg in newArguments:
			cmdTXT = cmdTXT + " " + arg

		#alert(cmdTXT)

		sig = os.spawnvp(os.P_WAIT, program, (program,) +  tuple(newArguments))

		if sig > 0:
			commandHasError = True
			alert("Se ha producido un error al ejecutar el comando.\nCompruebe que está bien construido.\n\nError en:\n\n"+cmdTXT)


def ProcessDirectory(directory):
	files = os.listdir(directory)
	for f in files:
		f = directory + "/" + f
		if os.path.isdir(f):
			ProcessDirectory(f)
		else:
			ProcessFile(f)

# PROGRAM

def fillParameters(com):

	global arguments
	global commandd
	global program
	global typefiles
	global readdirectory

	del arguments[:]

	command = com

	sub = command.split("\"")

	if len(sub)>1:

		c = 1
		for s in sub:
			subcommand = s.split(" ")

			if c == 1:
				program = subcommand[0]
				for s in subcommand[1:]:
					if s != "":
						arguments.append(s)
			else:
				if c % 2 == 0:
					if s != "":
						arguments.append(s)
				else:
					for s in subcommand:
						if s != "":
							arguments.append(s)

			c = c + 1

	else:

		subcommand = command.split(" ")

		program = subcommand[0]
	
		arguments = subcommand[1:]


def ProcessFiles(com, tf, rd, exedir, message):
	global arguments
	global commandd
	global program
	global typefiles
	global readdirectory

	fillParameters(com)

	if tf != "":
		typefiles = tf.split("|")

	files = os.environ['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'].split("\n")

	for f in files:
		if f != "":
			if not os.path.isdir(f):
				ProcessFile(f)
				if commandHasError:
					return
			else:
				if exedir == True:
					ProcessFile(f)
				if rd == True:
					ProcessDirectory(f)
	if message != "":
		alert(message)


def ProcessTogetherFiles(com, tf, message):

	global arguments
	global commandd
	global program
	global typefiles
	global commandHasError

	fillParameters(com)

	if tf != "":
		typefiles = tf.split("|")

	files = os.environ['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'].split("\n")


	validfiles = []
	for f in files:
		if f != "":
			if not os.path.isdir(f):
				validfile = False
				if len(typefiles)>0:
					for typefile in typefiles:
						if getExtension(f) == string.upper(typefile):
							validfile = True
				else:
					validfile = True

				if validfile==True:
					validfiles.append(f)

	newArguments = []
	
	for arg in arguments:
		if arg == "$FILES$":
			for f in validfiles:
				newArguments.append(f)
		else:
			newArguments.append(arg)
	

	sig = os.spawnvp(os.P_WAIT, program, (program,) +  tuple(newArguments))

	cmdTXT = program
	for arg in newArguments:
		cmdTXT = cmdTXT + " " + arg

	if sig > 0:
		commandHasError = True
		alert("Se ha producido un error al ejecutar el comando.\nCompruebe que está bien construido\n\nError en:\n\n"+cmdTXT)

	if message != "":
		alert(message)
