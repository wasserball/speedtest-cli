import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import csv
from matplotlib import dates
import datetime
import dateutil.parser
import time

x = []
download = []
upload = []
xlabels = []

counter = 0
DATE = datetime.date.today().strftime("%Y-%m")
with open('/data/' + DATE + '.csv','r') as csvfile:
    plots = csv.reader(csvfile, delimiter=',')
    next(plots, None) # skip the headers
    for idx, row in enumerate(plots):
        currentDate = dateutil.parser.parse(row[3])
        seconds = time.mktime(currentDate.timetuple())
        x.append(int(seconds))
        #x.append(int(idx))
        xlabels.append(currentDate.strftime('%d-%m-%Y_%H:%M'))
        download.append(float(row[6])/1000/1000)
        upload.append(float(row[7])/1000/1000)
        counter += 1


figSize = int(counter/2)

# set min size of plot
if figSize < 6:
    figSize = 6

fig = plt.figure(figsize=(figSize,10))

ax = fig.add_subplot(111)
ax.grid(True)

plt.plot(x,download, label='Download')
plt.xticks(x, xlabels, rotation=70)
for (X, Y) in zip(x, download):
    ax.annotate('{:.1f}'.format(Y), xy=(X,Y), xytext=(-10, 10), ha='right',
                textcoords='offset points', 
                arrowprops=dict(arrowstyle='->', shrinkA=0))
for (X, Y) in zip(x, upload):
    ax.annotate('{:.1f}'.format(Y), xy=(X,Y), xytext=(-10, 10), ha='right',
                textcoords='offset points', 
                arrowprops=dict(arrowstyle='->', shrinkA=0))

plt.plot(x,upload, label='Upload')
plt.xticks(x, xlabels, rotation=70)


plt.margins(0.015)
plt.subplots_adjust(bottom=0.25)

plt.xlabel('Timestamp d-m-Y_H:M')
plt.ylabel('Mbit/s')
plt.title('Speedtest - ' + DATE)
plt.legend()

#plt.show()
plt.savefig('/data/' + DATE + '.pdf')


