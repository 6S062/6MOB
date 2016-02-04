from __future__ import print_function
import sys
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
        <p> [ Home | <a href="syllabus.html">Syllabus</a> | <a href="labs.html">Labs</a> | <a href="https://piazza.com/class/ijsinvo6sr44al">Piazza</a> ] </p>

      <p>We will post the schedule of lectures, readings, and assignments for the course on this page.</p>

      <p>The first day of class is Wednesday, February 3. <br>  Class meets Mondays and Wednesdays at 11:00-12:30 in 34-303.</p>

      <p>Please sign up for the course <a href="https://piazza.com/class/ijsinvo6sr44al">Piazza Site</a>, which we will use for discussions and announcements.</p>

      <h2> Staff </h2>
      <b>Lecturers:</b> <ul> <li> Hari Balakrishnan (hari@csail.mit.edu) <li> Sam Madden (madden@csail.mit.edu)<br> </ul>
      <b>TA:</b> <ul> <li> Peter Iannucci (iannucci@mit.edu)<br> </ul>
      <b>Support Staff:</b> <ul> <li> Albert Carter (arcarter@csail.mit.edu) <li> Justin Anderson (jander@mit.edu) <br> </ul>

      <h2> Labs and Software Development </h2>

      The class will involving programming for iPhones in XCode, which requires a Mac for development.  There are Macs the EECS lab 38-530 available for our use.  See <a href="https://www.eecs.mit.edu/resources/eecs-instructional-laboratories">here</a> for lab hours.  The W20 athena cluster also has Macs with XCode installed.  We will loan out iPhones for you use if you do not have a personal iPhone.
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

with open(sys.argv[1], 'r') as infile, open(sys.argv[2], 'w') as outfile:
	outfile.write(header)
	modules = json.load(infile)
	for module in modules:
		modname = module['module']
		if 'events' not in module:
			outfile.write("""<tr>\n<td></td>\n<td colspan="4">%s</td>\n</tr>\n\n""" % (modname,))
		else:
			numevents = len(module['events'])
			for i, event in enumerate(module['events']):
				date = event['date']
				title = event.get('title', None)
				readings = event.get('readings', [])
				assignments = event.get('assignments', [])
				outfile.write("""<tr>\n<td>%s</td>\n""" % (date,))
				if title is None and numevents == 1:
					outfile.write("""<td colspan="2">%s</td>\n""" % (modname,))
				elif i == 0:
					outfile.write("""<td rowspan="%d">%s</td>\n""" % (numevents, modname))
				if title is not None:
					outfile.write("""<td>%s</td>\n""" % (title,))
				outfile.write("""<td>""")
				for j, reading in enumerate(readings):
					if j:
						outfile.write("""<br>\n""")
					if 'href' in reading:
						outfile.write("""<a href="%s">%s</a>""" % (reading['href'], reading['title']))
					else:
						outfile.write("""%s""" % (reading['title'],))
				outfile.write("""</td>\n""")
				outfile.write("""<td>""")
				for j, assignment in enumerate(assignments):
					if j:
						outfile.write("""<br>\n""")
					if 'href' in assignment:
						outfile.write("""<a href="%s">%s</a>""" % (assignment['href'], assignment['title']))
					else:
						outfile.write("""%s""" % (assignment['title'],))
				outfile.write("""</td>\n""")
				outfile.write("""</tr>\n\n""")
	outfile.write(footer)
