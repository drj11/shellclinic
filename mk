#!/usr/bin/env python

import itertools
import sys

def feed_one(inp):
    hashyet = False
    for hash,group in itertools.groupby(inp, lambda l: l.startswith('#')):
        if hash and hashyet:
            break
        if hash:
            hashyet = True
        if not hashyet:
            continue
        for l in group:
            yield l

def svg(lines, out):
    out.write("""<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" height="59mm" width="88mm">
""")
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
    out.write("</svg>\n")

def main():
    svg(feed_one(open('cards')), sys.stdout)
      
if __name__ == '__main__':
    main()
