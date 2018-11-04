#!/bin/sh


# To use: must have the following installed: sudo apt-get install inotify-tools libnotify-bin googlecl # googlecl might not be in repos, so must get
# 1. Watch ~/Pictures/PicasaWeb folder.
# 2. Upload new file to Picasa using Google CLI.
# 3. Launch the browser to the direct Picasa URL.
# 4. GoogleCL needs the permission to upload images to your PicasaWeb account, so in the terminal, type: google picasa list # only need to do once per pc

#change the variable below with the folder you want this script to watch for new images:
WATCHED_DIR=~/Pictures/PicasaWeb

#change the variable below with exact name of the PicasaWeb album you want to upload the images to:
PICASA_ALBUM="Drop Box"

while [ 1 ]
do
  echo 'Watching directory: '$WATCHED_DIR 'for new files'
  while file=$(inotifywait -q -e create "$WATCHED_DIR" --format "%f")
  do
    echo 'New file to upload to PicasaWeb:' $file
    notify-send -i "gtk-go-up" "Picasa Web Monitor" "Uploading image $file"
    google picasa post --title $PICASA_ALBUM "$WATCHED_DIR/$file"
    url=$(google picasa list url-direct --title $PICASA_ALBUM | grep "$file" | sed -e "s/$file\,//g")
    echo 'Picasa url: ' $url
    notify-send -i "gtk-home" "Picasa Web Monitor" "Image uploaded. Launching browser."
    xdg-open $url
  done
done
