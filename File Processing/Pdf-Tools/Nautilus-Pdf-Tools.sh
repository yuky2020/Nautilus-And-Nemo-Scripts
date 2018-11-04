#!/bin/bash
# Powered by Gustavo Moreno Baez
sub=`zenity --entry  --title="Action Selection" --text="1.-Merge PDF
2.- Section Off Pages
3.- Extract Pages
4.- Insert watermark (watermark above-stamp-) 
5.- Insert watermark (watermark below-background-)
6.- Protect PDF
7.- PDF Repair
8.- Convert to PDF (Any format supported by OpenOffice !!!!!!!)
9.- Removing passwords (Run from the console open to see: user (to open)/owner (for editing))-Requires pdfcrack (available in Ubuntu repos)- 3 characters faster, bruteforce laborious character"`
case $sub in

# Merge PDF
1)
clear
Selection=`zenity --title "Selection in order to want to join pdfs"  --file-selection --multiple|sed -e 's/|/\" \"/g'`
echo \"$Selection\"
echo "Has the following PDF Selected  \"$Selection\""
Output=$(zenity --file-selection --title "Route Selection and writes the name of the PDF you want to create " --save --confirm-overwrite)
echo pdftk \"$Selection\" cat output \"$Output\">/home/$USER/Desk/temporal_mixing
chmod +x /home/$USER/Desk/temporal_mixing
/home/$USER/Desk/temporal_mixing
rm /home/$USER/Desk/temporal_mixing
;;
# Section Off Pages
2)
FILE=`zenity --file-selection  --title="Selection pdf file which you want to extract each of the pages as separate files"`

        case $? in
                 0)
                        echo "\"$FILE\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "An unexpected error has occurred.";;
        esac
output=$(zenity --file-selection --save --confirm-overwrite);

	pdftk "$FILE" burst output "$output"_%02d.pdf
;;
# Extract Pages
3)
clear
FILE=`zenity --file-selection  --title="Selection pdf file which you want to extract pages"`

        case $? in
                 0)
                        echo "\"$FILE\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "An unexpected error has occurred.";;
        esac
FROM=`zenity --entry  --title="Selection of first page" --text="Number of the first page you want to extract"`
UP=`zenity --entry  --title="Selecting last page" --text="Number of the first page you want to extract"`
output=$(zenity --file-selection --save --confirm-overwrite);

	pdftk A="$FILE" cat 'A'$FROM-$UP output "$output"
echo "pdftk A="$FILE" cat "$FILE"$FROM-$UP "$FILE2" output "$output""
;;
# Insert watermark (stamp)-Requires a PDF with transparency
4)
clear
 FILE=`zenity --file-selection  --title="Select the pdf file to insert the watermark"`

        case $? in
                 0)
                        echo "\"$FILE\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "No fie selected.";;
        esac
zenity --info \
          --text="When you accept, this opens a dialog box to select the file that will watermark. The file you select as watermark should be pdf with a transparent image as this will be placed on top of your document, not worth a jpg."

	FILE2=`zenity --file-selection --title="Selection pdf file that will watermark"`

        case $? in
                 0)
                        echo "\"$FILE2\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "No file selected.";;
        esac


	output=$(zenity --file-selection --save --confirm-overwrite);echo $output

	pdftk "$FILE" stamp "$FILE2" output "$output"
;;
# Insert watermark (background)
5)
clear
 FILE=`zenity --file-selection  --title="Select the pdf file to insert the watermark"`

        case $? in
                 0)
                        echo "\"$FILE\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "No file selected.";;
        esac
zenity --info \
          --text="When you accept, this opens a dialog box to select the file that will watermark. The file you select as watermark should be pdf, not worth a jpg. With this program you can move the image to PDF."

	FILE2=`zenity --file-selection --title="Select the pdf file that will watermark"`

        case $? in
                 0)
                        echo "\"$FILE2\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "No file selected.";;
        esac


	output=$(zenity --file-selection --save --confirm-overwrite);echo $output

	pdftk "$FILE" background "$FILE2" output "$output"
;;
# Protect PDF
6)
clear
FILE=`zenity --file-selection  --title="Selection pdf file which you want to extract each of the pages as separate files"`

        case $? in
                 0)
                        echo "\"$FILE\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "An unexpected error has occurred.";;
        esac
output=$(zenity --file-selection --save --confirm-overwrite);
USER=`zenity --entry  --title="OWNER PASSWORD" --text="USER Enter a name without spaces (necessary to revoke / grant privileges in the future)"`
option=`zenity --entry  --title="KEY TO OPENING" --text="Do you require a password to open? Write s (yes) or n (no)"`
	if test $option = n
	then
   	PASSWORD=no
  	else
	PASSWORD=`zenity --entry  --title="--- OPENING PASSWORD without spaces and different from USER ---" --text="Enter a password (required to open the document)"`
	fi
zenity --info \
          --text="options: Printing = Print It allows high quality printing is allowed ; DegradedPrinting = low quality; ModifyContents = Edit content, even reassembled, Assembly = is to extract / join pages; CopyContents = content may be copied and screen readers; ScreenReaders = It allows screen readers; ModifyAnnotations = allowed to modify the annotations including form filling, Fillin = filling is allowed AllFeatures = form of the above are allowed "
PERMITS=`zenity --entry  --title="PERMITS" --text="Enter each option separated by spaces: Printing DegradedPrinting ModifyContents ScreenReaders ModifyAnnotations FillIn AllFeatures"`
	if test $option = n
	then
	pdftk "$FILE" output "$output" owner_pw $USER allow $PERMITS
	else
	pdftk "$FILE" output "$output" owner_pw $USER user_pw $PASSWORD allow $PERMITS
	fi
;;
# Repair PDF
7)
clear
FILE=`zenity --file-selection  --title="Selection of corrupt PDF file"`

        case $? in
                 0)
                        echo "\"$FILE\" Selected.";;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "An unexpected error has occurred.";;
        esac
output=$(zenity --file-selection --save --confirm-overwrite);

	pdftk "$FILE" output "$output"
;;
# Convert to PDF ::::: Convert any format supported by OpenOffice :::::: Requires PDF and OpenOffice Cups
8)
clear
FILE=`zenity --file-selection  --title="Select the document you want to convert to PDF (. Odt,. Doc, jpeg ... etc - All supported by OpenOffice ---)"`

        case $? in
                 0)
                        echo "\"$FILE\" selected.";;
                 1)
                        echo "You have not selected any files.";;
                -1)
                        echo "An unexpected error has occurred.";;
        esac
zenity --info \
          --text="Save the document is generated in \"$USER\"/Folder defined in CUPS-PDF (Vist http://www.guia-ubuntu.org/index.php?title=Instalar_impresora#Instalar_una_impresora_PDF or execute script http://www.atareao.es/ubuntu/conociendo-ubuntu/instalar-una-impresora-pdf-en-ubuntu-con-un-script)/ "
soffice  -pt PDF "$FILE"
;;
# Retrieve the user key (to open) / owner (for motification) a pdf
9)
clear
FILE=`zenity --file-selection  --title="Select the document for which you want to remove the key"`

        case $? in
                 0)
                        echo "\"$FILE\" selected.";;
                 1)
                        echo "You have not selected any files.";;
                -1)
                        echo "An unexpected error has occurred.";;
        esac
zenity --info \
          --text="To use this option, you must install the library pdfcrack (available in Ubuntu repos), if the key is-ej +3 digits takes 1 hour minimum 5 characters "
pdfcrack -o "$FILE"

esac
