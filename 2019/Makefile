DOCS=index calendar notes 

HDOCS=$(addsuffix .html, $(DOCS))
PHDOCS=$(addprefix , $(HDOCS))

.PHONY : docs
docs : $(PHDOCS)

%.html : %.jemdoc MENU
	    ./jemdoc -o $@ $<

.PHONY : clean
clean :
	rm -f *.html
	rm -f *~

.PHONY : update
update : 
	rm -f *~
	rsync -avze ssh --delete --exclude '*.jemdoc' --exclude 'MENU' --exclude 'Makefile' ./private alizadeh@courses.csail.mit.edu:/afs/csail/proj/courses/6.888-s16/www

