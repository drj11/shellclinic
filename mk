#!/usr/bin/env python

import itertools
import sys

def yield_cards(inp):
    """Split file into set of cards, each card is yielded as a group of lines.
    """
    for hash,group in itertools.groupby(inp, lambda l: l.startswith('#')):
        if hash:
            header = list(group)
        else:
            yield header + list(group)

def svg(lines, out):
    # Width of height of the drawable area in millimetres
    # Moo adds 4mm to this on all sides (2mm tolerance for trimming, and 2mm bleed)
    W = 80
    H = 51
    out.write("""<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" height="%smm" width="%smm">
""" % (H+8, W+8))
    # Convert a (4mm,4mm) offset into pixels at an assumed default of 90dpi.
    o = 4.0*90/25.4
    out.write("""<g transform="translate(%.2f,%.2f)">\n""" % (o,o))
    y = 0
    linespace = 16
    for r in lines:
        y += linespace
        attr = {}
        if r.startswith('    '):
            attr['font-family'] = 'monospace'
        if r.startswith('#'):
            r = r[1:]
            attr['font-weight'] = 'bold'
        r = r.strip()
        attr['x'] = "0"
        attr['y'] = "%.2f" % y

        attr_text = ' '.join(('''%s="%s"''' % (k,v)) for k,v in attr.items())
        if attr_text:
          attr_text = ' ' + attr_text
        if r:
            out.write("""<text%s>%s</text>\n""" % (attr_text, r))
    out.write("</g>\n")
    out.write("</svg>\n")

def main():
    cards = list(yield_cards(open('cards')))
    svg(cards[0], sys.stdout)
      
if __name__ == '__main__':
    main()
