all: index.html

index.html: schedule.json build.py
	./build.py $< $@
