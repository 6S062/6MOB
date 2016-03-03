all: index.html

index.html: schedule.json build.py
	python3 build.py $< $@
