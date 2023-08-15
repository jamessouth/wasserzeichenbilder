#!/usr/bin/env bash

version=1.0.0
gravity=Center
font=FiraCode-Nerd-Font-Mono-Reg
pointsize=300




usage () {
    cat <<HELP

    Usage: $0 [-h|v|g <gravity>|f <font>|p <N>|c <colors>|l <logo>|d <N>] -i <input-file> -o <output-file>

    add a logo to an image

    -h     display this help and exit
    -v     output version information and exit
    -g     placement of logo - one of: NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast; default: Center
    -f     font containing the logo character; default: FiraCode-Nerd-Font-Mono-Reg
    -p     font size in points; default: 300
    -c     four colors; defaults: black white #555555 #33333355   
    -l     logo character; default:  (Linux penguin mascot)
    -d     depth/height of logo in pixels; default: 2
    -i     path to input image
    -o     output filename

HELP
}

if [ $# == 0 ]; then
    usage
    echo "    ERROR: missing arguments; call with either -h or -v, or with input and output files"
    echo
    exit 1
fi


while getopts ":hvg:f:p:" opt; do
   case $opt in
      h) usage
         exit 0;;
      v) echo $version
         exit 0;;
      g) gravity=$OPTARG;;
      f) font=$OPTARG;;
      p) pointsize=$OPTARG;;






      \?) usage
          echo "    ERROR: invalid option: $OPTARG"
          echo
          exit 1;;
   esac
done



if [ $1 ]; then
    usage
    echo "    ERROR: flag missing before argument $1"
    echo
    exit 1
fi




#mapfile -t res < <(identify -verbose "$1" | awk '/Geometry:/{split($2,a,"+")};/median:/{print ($2 ~ /\./) ? a[1] : $2}')

#echo ${res[0]}
#echo ${res[1]}
#echo ${res[2]}
#echo ${res[3]}






