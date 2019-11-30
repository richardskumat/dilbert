#!/usr/bin/env python3
# doesn't work reliably
# because dilbert script ignores timezones
import datetime

# based on
# http://stackoverflow.com/questions/10688006/generate-a-list-of-datetimes-between-an-interval
def perdelta(start, end, delta):
    curr = start
    while curr < end:
        yield curr
        curr += delta

# sometimes gets the wrong day, I don't know why
a = int(datetime.datetime.strftime(datetime.datetime.now(), '%Y'))
b = int(datetime.datetime.strftime(datetime.datetime.now(), '%m'))
c = int(datetime.datetime.strftime(datetime.datetime.now(), '%d')) + 1

# known error on 30th November:
#Traceback (most recent call last):
#  File "bin/date-generator.py", line 20, in <module>
#    for result in perdelta(datetime.date(1989,4,16), datetime.date(a, b, c), datetime.timedelta(days=1)):
#ValueError: day is out of range for month
for result in perdelta(datetime.date(1989,4,16), datetime.date(a, b, c), datetime.timedelta(days=1)):
    print(result)
