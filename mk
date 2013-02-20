#!/bin/sh

./md2svg
for f in build/*.svg
do
    base=${f%.svg}
    printf -- "--export-pdf=${base}.pdf ${base}.svg\n"
done |
  inkscape --shell
