import sys

if (len(sys.argv) != 2):
    print "Incorrect number of arguments. \n Usage: csv2kml.py csvfile"
    exit(1)
file = sys.argv[1]

f = open(file,'r')

rows=[]
first = True
for line in f:
    if (first):
        fields = line.split(",")
        first = False
    else:
        els = line.split(",")
        row = {}
        i = 0
        for el in els:
            row[fields[i]] = el
            i = i + 1
        rows.append(row)


print '<?xml version="1.0" encoding="UTF-8"?> '
print '<kml xmlns="http://earth.google.com/kml/2.0">'
print '<Document>'

print '<Placemark> '
print ' <LineString>'
print '  <coordinates>'
for row in rows:
    print "%s,%s,0"%(row['Lon'],row['Lat'])
print '  </coordinates>'
print ' </LineString>'
print ' <Style> '
print '  <LineStyle>  '
print '   <color>#ff0000ff</color>'
print '   <width>5</width>'
print '  </LineStyle> '
print ' </Style>'
print '</Placemark>'

print '</Document> </kml>'
