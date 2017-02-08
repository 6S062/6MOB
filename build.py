#!/usr/bin/env python3
from __future__ import print_function
import sys
import os
import json

if len(sys.argv) < 3:
    print('Usage: %s infile.json outfile.html' % sys.argv[0])
    exit(1)

header = """
<!DOCTYPE html>
<html>

  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="6.S062 : Mobile and Sensor Computing Course">

    <link rel="stylesheet" type="text/css" media="screen" href="stylesheets/stylesheet.css">

    <title>6.S062</title>
  </head>

  <body>

    <!-- HEADER -->
    <div id="header_wrap" class="outer">
        <header class="inner">

          <h1 id="project_title">6.S062</h1>
          <h2 id="project_tagline">Mobile and Sensor Computing </h2>

        </header>
    </div>

    <!-- MAIN CONTENT -->
    <div id="main_content_wrap" class="outer">
      <section id="main_content" class="inner">
        <p> [ Home | <a href="syllabus.html">Syllabus</a> | <a href="https://piazza.com/class/iywy20zjxgq6qe">Piazza</a> ] </p>

      <p>We will post the schedule of lectures, readings, and assignments for the course on this page.</p>

      <p>The first day of class is Wednesday, February 8. <br>  Class meets Mondays and Wednesdays at 11:00-12:30 in 34-304.</p>

      <p>Please sign up for the course <a href="https://piazza.com/class/iywy20zjxgq6qe">Piazza Site</a>, which we will use for discussions and announcements.</p>

      <h2> Staff </h2>
      <b>Lecturers:</b> <ul> <li>Hari Balakrishnan (hari@csail.mit.edu)</li> <li>Sam Madden (madden@csail.mit.edu)</li> <br/> </ul>
      <b>TA:</b> <ul> <li>Favyen Bastani (fbastani@mit.edu)</li> <li>Songtao He (songtao@mit.edu)</li> <br/> </ul>
      <b>Support Staff:</b> <ul> <li>Albert Carter (arcarter@csail.mit.edu)</li> <li>Justin Anderson (jander@mit.edu)</li> <br/> </ul>

      <h2> Labs and Software Development </h2>

      The class will involving programming for iPhones in XCode, which requires a Mac for development.  There are Macs the EECS lab 38-530 available for our use.  See <a href="https://www.eecs.mit.edu/resources/eecs-instructional-laboratories">here</a> for lab hours. The W20 athena cluster also has Macs with XCode installed (select XCode from Launchpad, and then enter your Athena username and password to accept the license agreement).  We will loan out iPhones for you use if you do not have a personal iPhone.
<h2>
<a id="readings-and-assignments" class="anchor" href="#readings-and-assignments" aria-hidden="true"><span class="octicon octicon-link"></span></a>Readings and Assignments</h2>

      <p>
      Many classes have <i>reading questions</i>.  Please send  your response to the questions to <a href="mailto:6s062-submit@mit.edu">6s062-submit@mit.edu</a> (please submit from an mit.edu email address.)
      </p>
<table>
<thead>
<tr>
<th>Day</th>
<th colspan="2">Topic</th>
<th>Reading</th>
<th>Assignment</th>
<th>Notes</th>
</tr>
</thead>
"""

footer = """
</tbody>
</table>
      </section>
    </div>

    <!-- FOOTER  -->
    <div id="footer_wrap" class="outer">
      <footer class="inner">
        <p class="copyright">6.S062 maintained by <a href="https://github.mit.edu/srmadden">srmadden</a></p>
        <p>Published with <a href="http://pages.github.com">GitHub Pages</a></p>
      </footer>
    </div>

  </body>
</html>
"""

def writeItems(outfile, items, colspan=1, newline=True, bullet=False, number=False):
    outfile.write("""<td%s>""" % ("" if colspan == 1 else ' colspan="%d"' % colspan,))
    j = 0
    if bullet:
        assert not number
        outfile.write("""<ul>""")
    elif number:
        outfile.write("""<ol>""")
    for item in items:
        if 'title' not in item:
            continue
        if not bullet and not number:
            if j:
                outfile.write("""<br>\n""" if newline else " \n")
        else:
            outfile.write("""\n<li>""")
        if 'href' in item:
            outfile.write("""<a href="%s">%s</a>""" % (item['href'], item['title']))
        else:
            outfile.write("""%s""" % (item['title'],))
        j += 1
    if bullet:
        outfile.write("""</ul>""")
    elif number:
        outfile.write("""</ol>""")
    outfile.write("""</td>\n""")

try:
    with open(sys.argv[1], 'r') as infile, open(sys.argv[2], 'w') as outfile:
        outfile.write(header)
        modules = json.load(infile)
        for module in modules:
            modname = module['module']
            if 'events' not in module:
                outfile.write("""<tr>\n<td></td>\n<td colspan="5">%s</td>\n</tr>\n\n""" % (modname,))
            else:
                numevents = len(module['events'])
                for i, event in enumerate(module['events']):
                    date = event['date']
                    title = event.get('title', None)
                    assignments = event.get('assignments', [])
                    outfile.write("""<tr>\n<td style="white-space:nowrap;">%s</td>\n""" % (date,))
                    if i == 0 and title is not None:
                        outfile.write("""<td rowspan="%d">%s</td>\n""" % (numevents, modname))
                    colspan = 1
                    if title is None and numevents == 1:
                        title = modname
                        colspan = 2
                    writeItems(outfile, [{'title':title}], colspan=colspan)
                    writeItems(outfile, event.get('readings', []), bullet=True)
                    writeItems(outfile, event.get('assignments', []))
                    writeItems(outfile, event.get('materials', []))
                    outfile.write("""</tr>\n\n""")
        outfile.write(footer)
except:
    os.remove(sys.argv[2])
    raise
