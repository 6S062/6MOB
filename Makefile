all: 2017/index.html

2017/index.html: 2017/schedule.json build.py
	./build.py $< $@
