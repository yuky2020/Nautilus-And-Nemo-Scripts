#!/bin/bash

# ====================================================================================
#
#           ┏━╸┏━┓┏━╸┏━┓   ┏━╸┏━┓┏━┓┏━┓╺┳╸╻ ╻╻  ┏━┓
#           ┃  ┣┳┛┣╸ ┣━┫ ━ ┃  ┣━┫┣┳┛┣━┫ ┃ ┃ ┃┃  ┣━┫
#           ┗━╸╹┗╸┗━╸╹ ╹   ┗━╸╹ ╹╹┗╸╹ ╹ ╹ ┗━┛┗━╸╹ ╹
#
# Dada una imagen se genera una caratula
#
# Para videos se han implementado los buscadores:
#      . imdb (version ES y EN)
#      . filmaffinity
#      . thetvdb (especial para series... por ahora obtiene banner)
#      . caratulasdecine (español)
#      . alpacine (español)
#      . freecovers
#      . movieposterdb
#      . amazon
#      . bluray
#      . index-dvd
#      . themoviedb
# y si no se encuentra dara la posibilidad de generar pantallazos.
#
# Ademas se implementa un servicio de traducción detectando el idioma del sistema
#
# Proporcion de imagen 2:3 (300x450)
#
# ====================================================================================

# ==========================================
# Implementamos traductor de mensajes:
# http://www.commandlinefu.com/commands/view/5034/google-translate#comment
# ==========================================
traducir () {
	local txt_in=""
	local txt_out=""

	if [ "$2" == "es" ] ; then
		txt_in="$1"
		txt_out="$txt_in"
	else
		txt_in=$(echo "$1" \
			| sed -e 's/ /\%20/g')
		txt_out=$(wget -U firefox -qO - "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair=es|$2&q=$txt_in" \
			| sed 's/.*{"translatedText":"\([^"]*\)".*/\1\n/')
	fi
#	zenity --warning \
#		--title "Traduccion" \
#		--text "idioma destino: $2\nin: $txt_in\nout: $txt_out"
	if [ -n "$txt_out" ] ; then
		echo "$txt_out"
	else
		echo "$txt_in"
	fi
}

# ==========================================
# Funcion para limpiar el nombre
# ==========================================
get_query () {
	local V=$1

	V=$(echo $V | sed -e 's/(/\[/g' -e 's/)/\]/g' \
		-e 's/([^(]*)//g' \
		-e 's/\[[^\[]*\]//g' \
		-e 's/[cC][dD][1-9]//' \
		-e 's/[\(][1-9][oO][fF][1-9][\)]//' \
		-e 's/[1-9][oO][fF][1-9]//' \
		-e 's/[_-\.]/ /g' \
		-e 's/....$//' \
		-e 's/(/%28/g' -e 's/)/%29/g' \
		)
	echo $V
}

# ==========================================
# Determinamos si es un video
# ==========================================
get_video () {
	local es_VIDEO=""
	local es_EXT=""
	es_VIDEO=$(file -i "$1" | grep ' video' | wc -l)
#especial mkv o iso por la extension
	if [ "$es_VIDEO" == "0" ] ; then
		es_EXT=${1##*.}
		es_EXT=$(echo "$es_EXT" | tr [:lower:] [:upper:])
		case "$es_EXT" in
			"MP4") 	es_VIDEO="1" ;;
			"MKV") 	es_VIDEO="1" ;;
			"ISO") 	es_VIDEO="1" ;;
		esac
	fi

	echo $es_VIDEO
}

# ==========================================
# Buscadores
# ==========================================
get_img_imdb_es () {
	local nombre_peli=$1
	local ident=""
	local web=""
	local grabber_picture=""
	ident=$(wget -U firefox -qO - "http://www.google.com/search?hl=es&q=site%3Aimdb.es%2Ftitle+$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 '<a href="http://www.imdb.es/title')
	ident=${ident#*/title/}
	ident=${ident%%/*}
	web=$(wget -U firefox -qO - "http://www.imdb.es/title/$ident")
	grabber_picture=$(echo "$web" | grep -A1 -i '<div class="photo">' | sed -e 1d -e 's|.*src="||' -e 's/".*//')
	grabber_picture=${grabber_picture%@@*}@@._V1._SX280_SY280_.png
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$ident \n>>>$web \n>>>$grabber_picture"
	if [ "$grabber_picture" == "@@._V1._SX280_SY280_.png" ] ; then
		echo ""
	else
		echo "$grabber_picture"
	fi
}

get_img_imdb_en () {
	local nombre_peli=$1
	local ident=""
	local web=""
	local grabber_picture=""
	ident=$(wget -U firefox -qO - "http://www.google.com/search?hl=en&q=site%3Aimdb.com%2Ftitle+$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 '<a href="http://www.imdb.com/title')
	ident=${ident#*/title/}
	ident=${ident%%/*}
	web=$(wget -U firefox -qO - "http://www.imdb.com/title/$ident")
	grabber_picture=$(echo "$web" | grep -A1 -i '<div class="photo">' | sed -e 1d -e 's|.*src="||' -e 's/".*//')
	grabber_picture=${grabber_picture%@@*}@@._V1._SX280_SY280_.png
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$ident \n>>>$web \n>>>$grabber_picture"
	if [ "$grabber_picture" == "@@._V1._SX280_SY280_.png" ] ; then
		echo ""
	else
		echo "$grabber_picture"
	fi
}

get_img_filmaffinity () {
	local nombre_peli=$1
	local web=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://www.filmaffinity.com/es/advsearch.php?stext=$nombre_peli&stype[]=title")
	grabber_picture=$(echo "$web" \
		| sed 's/>/\n/g' \
		| grep -m 1 'http://pics.filmaffinity.com/' \
		| awk -F \src= '{print$2}' | awk -F ' ' '{print$1}' \
		| sed 's/\"//g;s/\-small/\-full/g' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

# Experimental: obtiene el banner y las dimensiones no son muy adecuadas :(
# Adecuado para series
get_img_thetvdb () {
	local nombre_peli=$1
	local web=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://thetvdb.com/api/GetSeries.php?seriesname=$nombre_peli&language=es")
	grabber_picture=$(echo "$web" \
		| sed 's/</\n/g' \
		| grep -m 1 'banner>' \
		| awk -F \> '{print$2}')
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "http://thetvdb.com/banners/$grabber_picture"
	else
		echo ""
	fi
}

get_img_caratulasdecine () {
	local nombre_peli=$1
	local web=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://www.google.es/search?hl=es&q=site%3Awww.caratulasdecine.com+$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 '<a href="http://www.caratulasdecine.com/caratula.php?pel=' \
		| awk -F \" '{print$2}' )
	grabber_picture=$(wget -U firefox -qO - "$web" \
		| sed 's/>/\n/g' \
		| grep -m 1 '<img src="' \
		| awk -F \" '{print$2}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "http://www.caratulasdecine.com/$grabber_picture"
	else
		echo ""
	fi
}

get_img_alpacine () {
	local nombre_peli=$1
	local web=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://alpacine.com/buscar/?buscar=$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 '<a href="/pelicula/' \
		| awk -F \" '{print$2}' )
	grabber_picture=$(wget -U firefox -qO - "http://alpacine.com$web" \
		| sed 's/>/\n/g' \
		| grep -m 1 'img src="http://img.alpacine.com/carteles/' \
		| awk -F \" '{print$2}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

get_img_freecovers () {
	local nombre_peli=$1
	local ident=""
	local grabber_picture=""
	ident=$(wget -U firefox -qO - "http://www.freecovers.net/search.php?search=$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 '<a class="versionName" href="javascript:toggleVersionListCovers(' \
		| awk -F \, '{print$2}' \
		| sed 's/^.//g' \
		| sed 's/\_/\//g' )
	if [ -n "$ident" ] ; then
		grabber_picture="http://www.freecovers.net/preview/$ident/big.jpg"
	fi
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$ident \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

get_img_movieposterdb () {
	local nombre_peli=$1
	local ident=""
	local grabber_picture=""
	ident=$(wget -U firefox -qO - "http://www.movieposterdb.com/browse/search?type=movies&query=$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 2 '<a class="bbg" href="' \
		| grep -v "/FAQ" \
		| awk -F 'href="' '{print$2}' | awk -F '"' '{print$1}' )
	grabber_picture=$(wget -U firefox -qO - "$ident" \
		| sed 's/>/\n/g' \
		|  grep -m 1 'http://www.movieposterdb.com/posters' \
		| awk -F '"' '{print$2}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$ident \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

get_img_amazon () {
	local nombre_peli=$1
	local web=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Ddvd&field-keywords=$nombre_peli" \
		| sed 's/\<div/\n\<div/g' \
		| grep -m 1 'alt="Product Details"' \
		| awk -F 'href="' '{print$2}' | awk -F '"' '{print$1}' )
	grabber_picture=$(wget -U firefox -qO - "$web" \
		| sed 's/>/\n/g' \
		|  grep -m 1 'registerImage("original_image", "' \
		| awk -F '"' '{print$4}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

get_img_bluray () {
	local nombre_peli=$1
	local web=""
	local ident=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://www.blu-ray.com/search/?quicksearch=1&section=movies&keyword=$nombre_peli" )
	ident=$(echo $web \
		| sed 's/>/\n/g' \
		| grep 'img width="70" height="88" border="0" src="' \
		| grep -m 1 '_small.jpg' \
		| awk -F 'src="' '{print$2}' \
		| awk -F '"' '{print$1}' )
	grabber_picture=$(echo "$ident" \
		| sed 's/small/front/g' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$ident \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

get_img_indexdvd () {
	local nombre_peli=$1
	local web=""
	local grabber_picture=""
	web=$(wget -U firefox -qO - "http://www.index-dvd.com/calendar_ult.php?tema=cine&order=tit&busqueda=$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 'caratula-delante' \
		| awk -F "=" '{print$2}' \
		| sed 's/^.//g' \
		| sed 's/.$//g' )
	grabber_picture=$(wget -U firefox -qO - "$web" \
		| sed 's/>/\n/g' \
		| grep 'http://www.index-dvd.com/covers/300' \
		| awk -F \' '{print$2}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

get_img_themoviedb () {
	local nombre_peli=$1
	local APIKEY="d0ce8e23daee98ade3812eecd72b23ae" # themoviedb.org api key given by Travis Bell for this script
	local grabber_picture=""
	grabber_picture=$(wget -U firefox -qO - "http://api.themoviedb.org/2.1/Movie.search/en/xml/$APIKEY/$nombre_peli" \
		| grep -m 1 'size="cover"' \
		| awk -F "url=" '{print$2}' \
		| awk -F '"' '{print$2}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$grabber_picture"
	if [ -n "$grabber_picture" ] ; then
		echo "$grabber_picture"
	else
		echo ""
	fi
}

# ==========================================
# Funciones para buscar sinopsis
# ==========================================

get_sinopsis_indexdvd () {
	local nombre_peli=$1
	local web=""
	local txt_sinopsis=""
	web=$(wget -U firefox -qO - "http://www.index-dvd.com/calendar_ult.php?tema=cine&order=tit&busqueda=$nombre_peli" \
		| sed 's/>/\n/g' \
		| grep -m 1 'caratula-delante' \
		| awk -F "=" '{print$2}' \
		| sed 's/^.//g' \
		| sed 's/.$//g' )
	txt_sinopsis=$(wget -U firefox -qO - "$web" \
		| sed 's/</\n/g' \
		| grep "font color='#2D2D2D'>" \
		| awk -F \> '{print$2}' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$web \n>>>$txt_sinopsis"
	if [ -n "$txt_sinopsis" ] ; then
		echo "$txt_sinopsis"
	else
		echo ""
	fi
}

get_sinopsis_themoviedb () {
	local nombre_peli=$1
	local APIKEY="d0ce8e23daee98ade3812eecd72b23ae" # themoviedb.org api key given by Travis Bell for this script
	local txt_sinopsis=""
	txt_sinopsis=$(wget -U firefox -qO - "http://api.themoviedb.org/2.1/Movie.search/en/xml/$APIKEY/$nombre_peli" \
		| grep -m 1 "<overview>" \
		| sed -e :a -e 's/<[^>]*>//g' )
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$txt_sinopsis"
	if [ -n "$txt_sinopsis" ] ; then
		echo "$txt_sinopsis"
	else
		echo ""
	fi
}

get_sinopsis_filmaffinity () {
	local nombre_peli=$1
	local web=""
	local web_sinopsis=""
	local sinopsis="sinopsis"
	local num_sinopsis=""
	local txt_sinopsis=""
	web=$(wget -U firefox -qO - "http://www.filmaffinity.com/es/advsearch.php?stext=$nombre_peli&stype[]=title" \
		| sed 's/>/\n/g' \
		| grep -m 1 'href="/es/film' \
		| awk -F '"' '{print$2}' )
	wget -U firefox -qO - "http://www.filmaffinity.com""$web" -O $sinopsis
	num_sinopsis=$(cat $sinopsis \
		| grep -i -n -m 1 sinopsis \
		| cut -d: -f1 )
	let "num_sinopsis+=1"
	txt_sinopsis=$(cat $sinopsis \
		| head --lines=$num_sinopsis \
		| tail -1 \
		| sed -e :a -e 's/<[^>]*>//g' \
		| sed 's/&quot;/\"/g' )
	rm $sinopsis
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$txt_sinopsis"
	if [ -n "$txt_sinopsis" ] ; then
		echo "$txt_sinopsis"
	else
		echo ""
	fi
}


# ==========================================
# Funcion para obtener propiedades
# ==========================================

get_propiedades () {
	local file_path=$1
	local file_name_ext=""
	local tmp="info"
	local inf=""
	local length=""
	local size=""
	local format=""
	local txt_propiedades=""

	size=`stat -c%s  "$file_path"`
	size=`echo $[$size/1024/1024]`

	file_name_ext=${file_path##*/}
	inf=`mplayer "$file_path" -identify -frames 1 -ao null -vo null 2>/dev/null | tee $tmp`
	format=`cat $tmp | grep VIDEO: | cut -d " " -f 5`
	length=`cat $tmp | grep LENGTH | sed -e 's/^.*=//' -e 's/[.].*//'`
	length=`echo $[$length/60]`
	rm $tmp

	txt_propiedades=$(echo -e "Archivo: $file_name_ext;Tamaño: $size Mb;Resolucion: $format;Duracion: $length min.")
#	zenity --warning \
#		--title "Generando caratulas" \
#		--text ">>>$txt_propiedades"

	echo "$txt_propiedades"
}

# ==========================================
# Proceso Principal
# ==========================================

# Dependencias
declare -a dependencias=( convert montage identify zenity mplayer wget sed awk )

declare -a datos_entrada
declare -a datos_in=$*

# =====================================================
# Proceso
# =====================================================

clear

# Detectamos idioma del sistema
dlang=$(echo $LANG | awk -F\_ '{print$2}' | awk -F\. '{print$1}' | tr [:upper:] [:lower:] )
#	dlang="fr"
#	nada=$(traducir "Hola esto es una prueba" $dlang)

# Comprobamos las dependencias
for pgm in ${dependencias[*]}
do
	if [ ! $(which $pgm) ] ; then
		echo ""
		echo "Es necesario tener instalado $pgm. Prueba con:"
		echo "    sudo apt-get install $pgm"
		echo ""
		exit 1
	fi
done

# Establecemos titulo de los mensajes con usuario
var_title=$(traducir "Generando caratulas" $dlang)

if [ $dlang != "es" ] ; then
	var_text=$(traducir "Traduccion por servicio web de Google." $dlang)
	zenity --warning \
		--title "$var_title" \
		--text "$var_text\n\n\tes --> $dlang"
fi

# Comprobamos seleccion
if [ -z "$datos_in" ] ; then
	
	var_text=$(traducir "Debe seleccionar alguna imagen para generar su caratula." $dlang)

	zenity --error \
		--title "$var_title" \
		--text "$var_text"
	exit 1
fi

# Establecemos prefijo
var_text=$(traducir "Introduce prefijo con el se creara la caratula" $dlang)

PREFIJO="caratula"
PREFIJO=$(zenity --entry \
	--title "$var_title" \
	--text "$var_text:\n" \
	--entry-text $PREFIJO)
if [ -z "$PREFIJO" ] ; then
	var_text=$(traducir "Por seguridad debe rellenar un prefijo." $dlang)

	zenity --error \
		--title "$var_title" \
		--text "$var_text"
	exit 1
fi

# Comprobamos si existe base personalizada en el directorio de la imagen
imagenBase="BaseSombra.png"
if [ -e $imagenBase ] ; then
	txt_base=$(traducir "Se ha encontrado imagen base personalizada." $dlang)"\n\n"$(traducir "Se usara esta imagen." $dlang)
else
	foo=`dirname "$0"`
	imagenBase=$foo"/"$imagenBase
	txt_base=$(traducir "Se utilizara imagen base por defecto" $dlang)":\n\n\t$imagenBase\n\n"$(traducir "Si no se encontrase, se generara caratula con sombra." $dlang)
fi

# Opciones
var_text="$txt_base\n\n\n\t"$(traducir "Opciones" $dlang)":"
var_column=$(traducir "Opciones" $dlang)
var_op01=$(traducir "Incluir nombre de la imagen en la base" $dlang)
var_op02=$(traducir "Salvar caratulas encontradas sin pedir confirmacion" $dlang)
var_op03=$(traducir "Generar imagen especial de sinopsis (WD TV)" $dlang)
opciones=$(zenity --list \
	--title "$var_title" \
	--text "$var_text" \
	--width 500 --height 350 \
	--checklist \
	--column " " --column "$var_column" \
	FALSE "$var_op01" \
	TRUE "$var_op02" \
	TRUE "$var_op03" \
	--separator=":")
incluir_nombre=$(echo $opciones | grep -v "$var_op01" | wc -l)
salvar_caratula_def=$(echo $opciones | grep -v "$var_op02" | wc -l)
montar_sinopsis=$(echo $opciones | grep -v "$var_op03" | wc -l)

# Establecemos el primer buscador en el que se intentara obtener la caratula
# Damos a elegir que buscadores activar
var_text=$(traducir "En el caso de videos" $dlang)"\n\n\t"$(traducir "¿Que buscadores quieres activar?" $dlang)
var_column=$(traducir "Buscador" $dlang)
buscador_def=$(zenity  --list \
	--title "$var_title" \
	--text "$var_text" \
	--height 425 \
	--checklist \
	--column " " --column "$var_column" \
	TRUE "ImdbES" \
	TRUE "ImdbEN" \
	TRUE "FilmAffinity" \
	FALSE "TheTVDB" \
	FALSE "CaratulasDeCine" \
	FALSE "Alpacine" \
	FALSE "FreeCovers" \
	FALSE "MoviePosterDB" \
	FALSE "Amazon" \
	FALSE "BluRay" \
	FALSE "IndexDVD" \
	FALSE "TheMovieDB" )
ImdbES=$(echo $buscador_def | grep -v "ImdbES" | wc -l)
ImdbEN=$(echo $buscador_def | grep -v "ImdbEN" | wc -l)
FilmAffinity=$(echo $buscador_def | grep -v "FilmAffinity" | wc -l)
TheTVDB=$(echo $buscador_def | grep -v "TheTVDB" | wc -l)
CaratulasDeCine=$(echo $buscador_def | grep -v "CaratulasDeCine" | wc -l)
Alpacine=$(echo $buscador_def | grep -v "Alpacine" | wc -l)
FreeCovers=$(echo $buscador_def | grep -v "FreeCovers" | wc -l)
MoviePosterDB=$(echo $buscador_def | grep -v "MoviePosterDB" | wc -l)
Amazon=$(echo $buscador_def | grep -v "Amazon" | wc -l)
BluRay=$(echo $buscador_def | grep -v "BluRay" | wc -l)
IndexDVD=$(echo $buscador_def | grep -v "IndexDVD" | wc -l)
TheMovieDB=$(echo $buscador_def | grep -v "TheMovieDB" | wc -l)

if [ "$montar_sinopsis" == "0" ] ; then
	var_text=$(traducir "En el caso de videos" $dlang)"\n\n\t"$(traducir "¿Que buscadores de sinopsis quieres activar?" $dlang)
	var_column=$(traducir "Buscador" $dlang)
	buscador_def=$(zenity  --list \
		--title "$var_title" \
		--text "$var_text" \
		--height 425 \
		--checklist \
		--column " " --column "$var_column" \
		TRUE "FilmAffinity" \
		TRUE "IndexDVD" \
		TRUE "TheMovieDB" )
	sin_FilmAffinity=$(echo $buscador_def | grep -v "FilmAffinity" | wc -l)
	sin_IndexDVD=$(echo $buscador_def | grep -v "IndexDVD" | wc -l)
	sin_TheMovieDB=$(echo $buscador_def | grep -v "TheMovieDB" | wc -l)
else
	sin_FilmAffinity=""
	sin_IndexDVD=""
	sin_TheMovieDB=""
fi

# Y ahora la resolucion de la imagen final
var_text=$(traducir "¿Que tamaño quieres para la imagen final?" $dlang)
w_x_h=$(zenity  --list \
	--title "$var_title" \
	--text "$var_text" \
	--height 350 \
	--radiolist \
	--column " " --column "w x h" \
	TRUE "300x450" \
	FALSE "300x400" \
	FALSE "300x300" \
	FALSE "400x300" \
	FALSE "450x300" )
if [ -z "$w_x_h" ] ; then
	w_x_h="300x450"
fi

# =====================================================

num_arg_tot=$#
num_arg_act=0

hora_ini=`date +%F-%T`
seg_ini=`date +%s`

(
var_echo=$(traducir "Procesando ..." $dlang)
echo -e "$var_echo\n"

# Hacemos bucle recorriendo todas las entradas
for parametro_in in $datos_in
do
	let "num_arg_act+=1"
	echo -e "\n[ $num_arg_act / $num_arg_tot ]"

	es_VIDEO=$(get_video "$parametro_in")
	if [ "$es_VIDEO" == "1" ] ; then
		nombre_peli=$(get_query "$parametro_in")
		grabber_picture=""
# Aqui se puede incorporar un buscador personalizado clonando una de las funciones "get_img_*"
# Comprobamos el predeterminado
#		case "$buscador_def" in
#			"ImdbES")	grabber_picture=$(get_img_imdb_es "$nombre_peli") ;;
#			"ImdbEN")	grabber_picture=$(get_img_imdb_en "$nombre_peli") ;;
#			"FilmAffinity")	grabber_picture=$(get_img_filmaffinity "$nombre_peli") ;;
#			"TheTVDB")	grabber_picture=$(get_img_thetvdb "$nombre_peli") ;;
#			"CaratulasDeCine")	grabber_picture=$(get_img_caratulasdecine "$nombre_peli") ;;
#			"Alpacine")	grabber_picture=$(get_img_alpacine "$nombre_peli") ;;
#			"FreeCovers")	grabber_picture=$(get_img_freecovers "$nombre_peli") ;;
#			"MoviePosterDB")	grabber_picture=$(get_img_movieposterdb "$nombre_peli") ;;
#			"Amazon")	grabber_picture=$(get_img_amazon "$nombre_peli") ;;
#			"BluRay")	grabber_picture=$(get_img_bluray "$nombre_peli") ;;
#		esac

# Si no hemos encontrado vamos buscando uno detras de otro comprobando resultados
		if [ -z $grabber_picture ] && [ "$ImdbES" == "0" ] ; then grabber_picture=$(get_img_imdb_en "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$ImdbEN" == "0" ] ; then grabber_picture=$(get_img_filmaffinity "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$FilmAffinity" == "0" ] ; then grabber_picture=$(get_img_imdb_es "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$TheTVDB" == "0" ] ; then grabber_picture=$(get_img_thetvdb "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$CaratulasDeCine" == "0" ] ; then grabber_picture=$(get_img_caratulasdecine "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$Alpacine" == "0" ] ; then grabber_picture=$(get_img_alpacine "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$FreeCovers" == "0" ] ; then grabber_picture=$(get_img_freecovers "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$MoviePosterDB" == "0" ] ; then grabber_picture=$(get_img_movieposterdb "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$Amazon" == "0" ] ; then grabber_picture=$(get_img_amazon "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$BluRay" == "0" ] ; then grabber_picture=$(get_img_bluray "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$IndexDVD" == "0" ] ; then grabber_picture=$(get_img_indexdvd "$nombre_peli"); fi
		if [ -z $grabber_picture ] && [ "$TheMovieDB" == "0" ] ; then grabber_picture=$(get_img_themoviedb "$nombre_peli"); fi

# Si no se obtiene ninguna caratula se pregunta si se quieren hacer pantallazos
		if [ -z $grabber_picture ] ; then
			var_echo=$(traducir "No se encontro imagen." $dlang)
			echo -e "\t[VID]" $parametro_in " --> $var_echo"
			var_text=$(traducir "Si lo deseas, se lanzara mplayer y podrás crear pantallazos pulsando" $dlang)
			crear_screenshot=$(zenity --question \
				--title "$var_title" \
				--text "$var_text [S]\n\n$nombre_peli"; echo $?)
			if [ "$crear_screenshot" == "0" ] ; then
				dir_act=`pwd`
				mkdir /tmp/shots
				cd /tmp/shots
				mplayer -ao null -vf screenshot -quiet "$dir_act/$parametro_in"
				montage -geometry +2+2 `ls *.png | sort -n` "$dir_act/$parametro_in""shot.jpg"
				rm /tmp/shots/*
				rm -r /tmp/shots
				cd "$dir_act"
				grabber_picture="$parametro_in""shot.jpg"
			fi
		fi

# Si se encuentra caratula preguntamos si la guardamos como imagen
		if [ -z $grabber_picture ] ; then
			var_echo=$(traducir "No se encontro imagen." $dlang)
			echo -e "\t[VID]" $parametro_in " --> $var_echo"
		else
			if [ "$salvar_caratula_def" == "0" ] ; then
				salvar_caratula="0"
			else
				var_text=$(traducir "¿Guardar la imagen encontrada?" $dlang)
				salvar_caratula=$(zenity --question \
					--title "$var_title" \
					--text "$var_text\n\n$nombre_peli:\t$grabber_picture"; echo $?)
			fi

			if [ "$salvar_caratula" == "0" ] ; then
				nombre_img=$( echo "$parametro_in" | sed -e 's/....$/.jpg/' )
				convert $grabber_picture -thumbnail 280x280 "$nombre_img"
				var_echo=$(traducir "Se guardo imagen" $dlang)
				echo -e "\t[VID]" $parametro_in " --> $var_echo: $nombre_img"

				# Ahora vemos si hay que generar imagen de sinopsis
				if [ "$montar_sinopsis" == "0" ] ; then
					echo -e "\t\tObteniendo datos..."
					txt_prop=""
					txt_sin=""
					echo -e "\t\t\tPropiedades fichero multimedia"
					if [ -z $txt_prop ] ; then txt_prop=$(get_propiedades "$parametro_in"); fi
					echo -e "\t\t\tSinopsis"
					if [ -z $txt_sin ] && [ "$sin_FilmAffinity" == "0" ] ; then txt_sin=$(get_sinopsis_filmaffinity "$nombre_peli"); fi
					if [ -z $txt_sin ] && [ "$sin_IndexDVD" == "0" ] ; then txt_sin=$(get_sinopsis_indexdvd "$nombre_peli"); fi
					if [ -z $txt_sin ] && [ "$sin_TheMovieDB" == "0" ] ; then txt_sin=$(get_sinopsis_themoviedb "$nombre_peli"); fi
					echo -e "\t\tDatos Obtenidos."
				fi

				#ahora lo cambiamos por el video seleccionado para que se genere la caratula con esta imagen
				parametro_in=$nombre_img
			fi
		fi
	fi

# La imagen debe ser de tipo permitido
	es_JPG=$(file "$parametro_in" | grep " JPEG ")
	es_PNG=$(file "$parametro_in" | grep " PNG ")
	if [ -z "$es_JPG" ] && [ -z "$es_PNG" ] ; then
		var_echo=$(traducir "No es una imagen soportada." $dlang)
		echo -e "\t[KO ]" $parametro_in " --> $var_echo"
	else
# Limpiamos de caracteres raros para incluir como texto
		if [ "$incluir_nombre" == "0" ] ; then
			nombre=$((get_query "$parametro_in") | tr [:lower:] [:upper:] | tr [:punct:] " " | sed -e 's/JPG$//g;s/PNG$//g' )
		fi

		if [ -z "$es_JPG" ] ; then
			SUFIJO=".jpg"
		else
			SUFIJO=""
		fi
		SALIDA=$PREFIJO$parametro_in$SUFIJO

		if [ -e $imagenBase ] ; then
			if [ "$incluir_nombre" == "0" ] ; then
				convert "$imagenBase" \
					\( -resize 220x280! -gravity center "$parametro_in" \) \
					-gravity center -compose DstOver -composite \
					-background YellowGreen label:"$nombre" -gravity Center -append \
					-resize "$w_x_h"! \
					"$SALIDA" \
					2> /dev/null
			else
				convert "$imagenBase" \
					\( -resize 220x280! -gravity center "$parametro_in" \) \
					-gravity center -compose DstOver -composite \
					-resize "$w_x_h"! \
					"$SALIDA" \
					2> /dev/null
			fi

			echo -e "\t[OK ]" $parametro_in " --> " $SALIDA
		else
# Si no existiera imagen, hacemos caratula con sombra
			if [ "$incluir_nombre" == "0" ] ; then
				convert  "$parametro_in" \
					-thumbnail 300x360 \
					\( +clone -background black -shadow 305x3+3+3 -channel A -evaluate multiply 2 +channel \) \
					+swap +repage \
					-gravity center -geometry -0-2 -composite \
					-background YellowGreen label:"$nombre" -gravity Center -append \
					-resize "$w_x_h"! \
					"$SALIDA" \
					2> /dev/null
			else
				convert  "$parametro_in" \
					-thumbnail 300x360 \
					\( +clone -background black -shadow 305x3+3+3 -channel A -evaluate multiply 2 +channel \) \
					+swap +repage \
					-gravity center -geometry -0-2 -composite \
					-resize "$w_x_h"! \
					"$SALIDA" \
					2> /dev/null
			fi

			echo -e "\t[Def]" $parametro_in " --> " $SALIDA
		fi
	fi

	if [ "$montar_sinopsis" == "0" ] ; then
		echo -e "\tGenerando imagen de sinopsis..."

		dir_act=`pwd`
		rm Temporal_??.png 2> /dev/null

		TEMPO_01="$dir_act/Temporal_01.png"
		TEMPO_02="$dir_act/Temporal_02.png"
		TEMPO_03="$dir_act/Temporal_03.png"
		TEMPO_04="$dir_act/Temporal_04.png"
		TEMPO_05="$dir_act/Temporal_05.png"
		TEMPO_06="$dir_act/Temporal_06.png"
		TEMPO_07="$dir_act/Temporal_07.png"
		TEMPO_08="$dir_act/Temporal_08.png"
		TEMPO_09="$dir_act/Temporal_09.png"
		TEMPO_10="$dir_act/Temporal_10.png"

		echo -e "\t\tAplicamos capa superior con transparencia"
		convert "$imagenBase" \
			\( -resize 220x280! -gravity center "$parametro_in" \) \
			-gravity center -compose DstOver -composite \
			-resize "$w_x_h"! \
			"$TEMPO_01" 2> /dev/null

		echo -e "\t\tAplicamos sombra"
		convert "$TEMPO_01" \
			\( +clone -background black -shadow 305x3+3+3 \) \
			+swap +repage\
			-background none \
			-layers merge \
			-resize 240x360! \
			"$TEMPO_02" 2> /dev/null

		echo -e "\t\tMontamos la sinopsis"
		echo -e $txt_sin \
			| convert -size 740x200! \
				-fill white \
				-background black \
				-pointsize 14 \
				-font Helvetica \
				caption:@- \
				-alpha set \
				-transparent black \
				"$TEMPO_03" 2> /dev/null

		echo -e "\t\tPropiedades de la pelicula"
		echo -e $txt_prop \
			| sed -e 's/\;/\n/g' \
			| convert -size 740x75! \
				-fill grey70 \
				-background black \
				-font Courier \
				-pointsize 14 \
				-stroke white \
				caption:@- \
				-alpha set \
				-transparent black \
				"$TEMPO_04" 2> /dev/null

		echo -e "\t\tEl titulo"
		echo $((get_query "$parametro_in") | sed -e 's/JPG$//g;s/PNG$//g' ) \
			| convert -size 1240x80! \
				-fill white \
				-background black \
				-pointsize 38 \
				-font Helvetica \
				-gravity Center \
				caption:@- \
				-alpha set \
				-transparent black \
				"$TEMPO_05" 2> /dev/null

		echo -e "\t\tFusionamos por orden"
		echo -e "\t\t\t1. Las sombras donde iran los textos + fondo"
		composite -gravity center -size 1280x720! "BaseTextos.png" "osdMod_background.jpg" "$TEMPO_06"
		echo -e "\t\t\t2. Caratula sombreada + (sombras textos + fondo)"
		composite -geometry +100+100 -size 1280x720! "$TEMPO_02" "$TEMPO_06" "$TEMPO_07"
		echo -e "\t\t\t3. Titulo + (Caratula sombreada + (sombras textos + fondo))"
		composite -geometry +20+12 "$TEMPO_05" "$TEMPO_07" "$TEMPO_08"
		echo -e "\t\t\t4. Sinopsis + (Titulo + (Caratula sombreada + (sombras textos + fondo)))"
		composite -geometry +405+258 "$TEMPO_03" "$TEMPO_08" "$TEMPO_09"
		echo -e "\t\t\t5. Datos tecnicos + (Sinopsis + (Titulo + (Caratula sombreada + (sombras textos + fondo))))"
		composite -gravity NorthWest -geometry +670+640 "$TEMPO_04" "$TEMPO_09" "$TEMPO_10"

		convert "$TEMPO_10" "$parametro_in""_sheet.jpg"

		rm Temporal_??.png 2> /dev/null
	fi

done

hora_fin=`date +%F-%T`
seg_fin=`date +%s`
let seg_elapsed=$seg_fin-$seg_ini

var_echo01=$(traducir "Inicio" $dlang)
var_echo02=$(traducir "Final" $dlang)
var_echo03=$(traducir "segundos" $dlang)
echo -e "\n\n$var_echo01: $hora_ini - $var_echo02: $hora_fin - [$seg_elapsed $var_echo03]"

) | zenity --text-info --width 500 --height 300 --title "$var_title"
