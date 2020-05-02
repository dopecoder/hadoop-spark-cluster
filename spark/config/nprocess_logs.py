import sys
import numpy as np
import matplotlib.pyplot as plt


#if len(sys.argv) != 7:
#    print("Please provide all the arguments")
#    exit()

file_size = sys.argv[1]
threads = sys.argv[2]
pidstat_file_name = sys.argv[3]
io_file_name = sys.argv[4]
pid_plot_name = sys.argv[5]
io_plot_name = sys.argv[6]

pidstat_file = open(pidstat_file_name, 'r')

try:
    pid_lines = pidstat_file.readlines()
except:
    print("Error opening files")
    exit()

# print(len(io_lines))
# print(len(pid_lines))


cpu_usage_sum = 0
mem_usage_sum = 0
# cpu_mem_len = len(pid_lines)
cpu_usage = []
mem_usage = []
count=0
read_total = 0
write_total = 0
read_count = 0
write_count = 0

read_speeds = []
write_speeds = []


for line in pid_lines:
    values = line.split()
    #print(values[0])
    #print(values[1])
    #print(values)
    cpu = float(values[0])
    mem = float(values[1])
    read_val = float(values[2])
    write_val = float(values[3])

    cpu_usage.append(cpu)
    mem_usage.append(mem)
    read_speeds.append(read_val)
    write_speeds.append(write_val)

    cpu_usage_sum += cpu
    mem_usage_sum += mem
    read_total+=read_val
    write_total+=write_val

    count+=1

    if read_val != 0:
        read_count+=1

    if write_val != 0:
        write_count+=1

avg_cpu_usage =  cpu_usage_sum / count
avg_mem_usage =  mem_usage_sum / count
print("--------------------------------------------")

print("Stats For ", file_size, " GB File with ", threads, "Thread(s)")
print("")
print("Log lines : ", len(pid_lines))
print("Avergae CPU consuption (%) : ", avg_cpu_usage)
print("Avergae Memory consuption (MB) : ", avg_mem_usage)
print("")

if read_count == 0 or write_count == 0:
    print("--------------------------------------------")
    exit()

avg_read =  read_total / read_count
avg_write =  write_total / write_count
print("Avergae READ (MBps) : ", avg_read / 1024)
print("Avergae WRITE (MBps) : ", avg_write / 1024)
print("Total READ (MBps) : ", read_total)
print("Total WRITE (MBps) : ", write_total)
print("--------------------------------------------")

pidstat_file.close()

length = len(pid_lines)
t = np.arange(1, length + 1)

fig, ax1 = plt.subplots()

color = 'red'
ax1.set_xlabel('time (s)')
ax1.set_ylabel('CPU Util(%)', color=color)
ax1.plot(t, np.asarray(cpu_usage), color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'blue'
ax2.set_ylabel('Mem Util(MB)', color=color)  # we already handled the x-label with ax1
ax2.plot(t, np.asarray(mem_usage), color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
# plt.show()
plt.savefig(pid_plot_name)



fig, ax1 = plt.subplots()

color = 'red'
ax1.set_xlabel('time (s)')
ax1.set_ylabel('Read (MB/s)', color=color)
ax1.plot(t, np.asarray(read_speeds), color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis

color = 'blue'
ax2.set_ylabel('Write (MB/s)', color=color)  # we already handled the x-label with ax1
ax2.plot(t, np.asarray(write_speeds), color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()  # otherwise the right y-label is slightly clipped
# plt.show()
plt.savefig(io_plot_name)
