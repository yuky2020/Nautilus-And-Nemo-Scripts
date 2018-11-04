#!/usr/bin/env python
# -*- coding: latin-1 -*-
# ==============================================================================================
# Convierte las imagenes seleccionadas a imagenes apropiadas para salvapantallas del Kindle 3
# ==============================================================================================

import gtk
import os, sys
import string

sys.path.insert(0, os.path.join(os.path.abspath(os.path.dirname(sys.argv[0])),".."))
import Process

def alerta (cadena, tipo):
	dialogo = gtk.MessageDialog(None, gtk.DIALOG_MODAL, tipo, gtk.BUTTONS_CLOSE, cadena)
	dialogo.set_title("Imagenes Kindle 3")
	dialogo.run()
	dialogo.destroy()

def ClickAceptar(widget):
	archivos = os.environ['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'].split("\n")
	for archivo in archivos:
		if archivo != "":
			if os.path.isdir(archivo):
				ProcesarDirectorio(archivo)
			else:
				ProcesarImagen(archivo)

	alerta("El proceso ha finalizado satisfactoriamente.", gtk.MESSAGE_INFO)
	gtk.main_quit()

def ClickCancelar(widget):
	gtk.main_quit()

def ProcesarDirectorio(directorio):
	archivos = os.listdir(directorio)
	for archivo in archivos:
		archivo = directorio + "/" + archivo
		if os.path.isdir(archivo):
			ProcesarDirectorio(archivo)
		else:
			ProcesarImagen(archivo)

def ProcesarImagen(archivo):
	if Process.getExtension(archivo) == "JPG" or Process.getExtension(archivo) == "PNG" or Process.getExtension(archivo) == "BMP":

		# Construimos nombre de fichero resultado
		destino = Process.getPath(archivo) + "/kindle_" + Process.getName(archivo) + ".png"

		# rotamos si es necesario para mantener la mejor resolucion, ademas trabajamos con ficheros png
		pb=gtk.gdk.pixbuf_new_from_file(archivo)
		if pb.get_height()<pb.get_width():
			opcGiro = "-rotate -90"
		else:
			opcGiro = ""

		Process.ProcessFileByArgument("convert " + opcGiro + " " + archivo + " " + destino)
		
		# pasamos a grises y ajustamos tamaño
		Process.ProcessFileByArgument("convert -colorspace Gray -resize 550x750> -gravity center -background Gray -extent 550x750 " + destino + " " + destino)

		# añadimos borde en negro para completa 600x800
		Process.ProcessFileByArgument("convert -border 25x25 -bordercolor black " + destino + " " + destino)

		# añadimos texto centrado en la base y con espaciado entre letras
		titulo="Slide and release the power switch to wake"
		Process.ProcessFileByArgument("convert -kerning 2 -font Ubuntu-Regular -fill white -pointsize 20 -draw \"gravity south text 0,0 '" + titulo + "'\" \"" + destino + "\" \"" + destino  + "\"")

		# añadimos credito en vertical
		credito=entryName.get_text()
		Process.ProcessFileByArgument("convert -font Ubuntu-Regular -fill white -pointsize 12 -draw \"translate 590,150 rotate -90 text 0,0 '" + credito + "'\" \"" + destino + "\" \"" + destino + "\"")

		# añadimos titulo de imagen en vertical
		nombre=Process.getName(archivo)
		if cbNomFic.get_active()==True:
			Process.ProcessFileByArgument("convert -font Ubuntu-Regular -fill white -pointsize 15 -draw \"translate 20,775 rotate -90 text 0,0 '" + nombre + "'\" \"" + destino + "\" \"" + destino + "\"")
		else:
			nombre=""

	else:
		alerta(archivo + "\n\nTipo no soportado.", gtk.MESSAGE_WARNING)

# PROGRAMA

if Process.verifyCommands("convert%ImageMagick")==False:
	sys.exit()

w = gtk.Window(gtk.WINDOW_TOPLEVEL)
w.set_title("Imagenes Kindle 3")
w.set_border_width(20)

w.connect("destroy", gtk.main_quit) 

# tabla

tableMin = gtk.Table(3, 2, False)
tableMin.set_border_width(10)

tableMin.set_row_spacings(10)
tableMin.set_col_spacings(8)

lBegin = gtk.Label("Este proceso generara imagenes adecuadas\npara usar de salvapantallas en el Kindle 3.")
tableMin.attach(lBegin, 0, 2, 0, 1)

lName = gtk.Label("Nombre (margen derecho):")
tableMin.attach(lName, 0, 1, 1, 2)

entryName = gtk.Entry()
entryName.set_text("soymicmic")
tableMin.attach(entryName, 1, 3, 1, 2)

cbNomFic = gtk.CheckButton("Incluir nombre de fichero (margen izquierdo).")
cbNomFic.set_active(True);
tableMin.attach(cbNomFic, 0, 2, 2, 3)

# botones

aligBotones = gtk.Alignment(1.0, 0.0)
boxBotones = gtk.HBox(True, 4)

bAceptar = gtk.Button("Aceptar", gtk.STOCK_OK)
bAceptar.connect("clicked", ClickAceptar)
boxBotones.pack_start(bAceptar, False, False, 0)

bCancelar = gtk.Button("Cancelar", gtk.STOCK_CANCEL)
bCancelar.connect("clicked", ClickCancelar)
boxBotones.pack_start(bCancelar, False, False, 0)

aligBotones.add(boxBotones)

tableMin.attach(aligBotones, 1, 2, 4, 5)

w.add(tableMin)
w.show_all()
gtk.main()
