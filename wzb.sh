#!/usr/bin/env bash

version=1.0.0

gravity=Center
font=FiraCode-Nerd-Font-Mono-Reg
pointsize=300
col1=black
col2=white
col3="#555555"
col4="#33333355" 
logo=
depth=2



usage () {
    cat <<HELP

    Usage: $0 [-h|v|g <gravity>|f <font>|p <N>|1 <color>|2 <color>|3 <color>|4 <color>|l <logo>|d <N>] -i <input-file> -o <output-file>

    add a logo to an image

    -h     display this help and exit
    -v     output version information and exit
    -g     placement of logo - one of: NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast; default: Center
    -f     font containing the logo character; default: FiraCode-Nerd-Font-Mono-Reg
    -p     font size in points; default: 300
    -1     color; default: black
    -2     color; default: white
    -3     color; default: #555555
    -4     color; default: #33333355 
    -l     logo character; default:  (Linux penguin mascot)
    -d     depth/height of logo in pixels; default: 2
    -i     path to input image
    -o     output filename

HELP
}

#if [ ! $@ ]; then
#    usage
#    echo "    ERROR: missing arguments; call with either -h or -v, or with input and output files"
#    echo
#    exit 1
#fi


while getopts ":hvg:f:p:1:2:3:4:l:d:i:o:" opt; do
   case $opt in
       h) usage
          exit 0;;
       v) echo $version
          exit 0;;
       g) gravity=$OPTARG;;
       f) font=$OPTARG;;
       p) pointsize=$OPTARG;;
       1) col1=$OPTARG;;
       2) col2=$OPTARG;;
       3) col3=$OPTARG;;
       4) col4=$OPTARG;;
       l) logo=$OPTARG;;
       d) depth=$OPTARG;;
       i) input=$OPTARG;;
       o) output=$OPTARG;;

      \?) usage
          echo "    ERROR: invalid option: $OPTARG"
          echo
          exit 1;;
   esac
done



#if [ $1 ]; then
#    usage
#    echo "    ERROR: flag missing before argument $1"
#    echo
#    exit 1
#fi




mapfile -t res < <(identify -verbose "$input" | awk '/Geometry:/{split($2,a,"+")};/median:/{print ($2 ~ /\./) ? a[1] : $2}')

#echo ${res[0]}
#echo ${res[1]}
#echo ${res[2]}
#echo ${res[3]}


convert -size "${res[3]}" xc:transparent -gravity "$gravity" -font "$font" -pointsize "$pointsize" -fill "$col1" -annotate +"$depth"+"$depth" "$logo" -fill "$col2"  -annotate -"$depth"-"$depth" "$logo" -fill "$col3" -annotate +0+0 "$logo" transp.png


convert -size "${res[3]}" xc:black -gravity "$gravity" -font "$font" -pointsize "$pointsize" -fill white -annotate +"$depth"+"$depth" "$logo" -fill white -annotate -"$depth"-"$depth" "$logo" -fill "$col4" -annotate +0+0 "$logo" mask.jpg


composite transp.png "$input" mask.jpg "$output"

rm transp.png mask.jpg

