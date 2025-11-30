#!/bin/sh
exec magick mogrify -format jpg -alpha remove -background black "$@"
