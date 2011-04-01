#!/bin/bash

## full path to mcmap binary
MCMAP=/usr/local/bin/mcmap
## path to your world
WORLDDIR=$1
WORLDNAME=${2:-`basename $1`}
## path to write output image to
OUTPUT="/var/www/html"
## see below to change the area to render (lines that start with ##)
################################

FILE=$WORLDNAME-history-`date +%s`.png

OLD5=none
OLD6=none
if [ -e "$OUTPUT/$WORLDNAME.day.png" ]; then
    OLD5=`md5sum $OUTPUT/$WORLDNAME.day.png | cut -b 1-32`
fi
if [ -e "$OUTPUT/$WORLDNAME.night.png" ]; then
    OLD6=`md5sum $OUTPUT/$WORLDNAME.night.png | cut -b 1-32`
fi

CHECK=`date +%k`
if [ $CHECK -ge "7" ] && [ $CHECK -le "20" ]; then
    NIGHT="-skylight"
    NIGHTSTATUS="0"
else
#    NIGHT="-skylight -night"
#    NIGHTSTATUS="1"
    NIGHT="-skylight"
    NIGHTSTATUS="0"
fi

## change the values here to define the area to render
#$MCMAP -png $NIGHT -from -40 -60 -to 20 20 "$WORLD" > /dev/null
## if you want the whole world, use:
$MCMAP -png "$WORLDDIR/" $NIGHT > /dev/null
RET=$?
if [ "$RET" -ne "0" ]; then
    echo "Error creating image for $FILE"
    exit 1;
fi

NEW5=`md5sum output.png | cut -b 1-32`
if [ "$OLD5" != "$NEW5" ] && [ "$OLD6" != "$NEW5" ]; then
    mkdir -p $OUTPUT/history/
    if [ -n "$COMPRESS_IMAGES" ]; then
        pngcrush output.png $OUTPUT/history/$FILE > /dev/null
        convert -scale 600 -depth 5 output.png thumb.png
        pngcrush -brute thumb.png $OUTPUT/history/thumb.$FILE > /dev/null
    else
        cp output.png $OUTPUT/history/$FILE > /dev/null
    fi
    if [ "$NIGHTSTATUS" -eq "1" ]; then
        mv output.png $OUTPUT/$WORLDNAME.night.png
        [ -n "$COMPRESS_IMAGES" ] && mv thumb.png $OUTPUT/thumb.$WORLDNAME.night.png
    else
        mv output.png $OUTPUT/$WORLDNAME.day.png
        [ -n "$COMPRESS_IMAGES" ] && mv thumb.png $OUTPUT/thumb.$WORLDNAME.day.png
    fi
fi
