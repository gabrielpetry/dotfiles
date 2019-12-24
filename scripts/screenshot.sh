#!/bin/sh

options="ScrotToGimp\nScrotToClipboard\nJustSave"
path="$HOME/Imagens/Print"

if [[ ! -d "$path" ]]; then
	mkdir -p "$path"
fi

filename=$(scrot -s -z "$path/%Y-%m-%d_temp_name.png" -e 'echo $f')

chosen=$(printf "%b" "$options" | dmenu -i )
# name=$(dmenu -p "Nome do arquivo")
# filename_rename=$(echo -e $filename | sed -e "s/\_temp\_name/\_$name/g")
# mv $filename $filename_rename
# gimp /tmp/print.png
case $chosen in
	ScrotToGimp)
		gimp $filename_rename
		;;
	ScrotToClipboard)
		xclip -selection clipboard -t image/png -i $filename
		notify-send "Salvo paro o xclip"
		# rm $filename_rename
		;;
	JustSave)
		notify-send "Salvo no arquivo $filename_rename"
	;;
esac

