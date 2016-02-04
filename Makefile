all: index.html

index.html: schedule.json build.py
	python build.py $< $@
