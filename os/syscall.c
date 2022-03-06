#include "syscall.h"
#include "defs.h"
#include "loader.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

#include "task_info.h"

uint64 sys_write(int fd, char *str, uint len)
{
	debugf("sys_write fd = %d str = %x, len = %d", fd, str, len);
	if (fd != STDOUT)
		return -1;
	for (int i = 0; i < len; ++i) {
		console_putchar(str[i]);
	}
	return len;
}

__attribute__((noreturn)) void sys_exit(int code)
{
	exit(code);
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
	yield();
	return 0;
}

uint64 sys_gettimeofday(TimeVal *val, int _tz)
{
	uint64 cycle = get_cycle();
	val->sec = cycle / CPU_FREQ;
	val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	return 0;
}

uint64 sys_task_info(TaskInfo *ti)
{
	// 时间
	uint64 cycle = get_cycle();
	uint64 sec = cycle / CPU_FREQ;
	uint64 usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	uint64 cur_time = sec*1000+usec/1000;
	ti->time = cur_time-curr_proc()->start_time;
	// 任务状态
	ti->status = Running;//always running
	// 系统调用计数
	for(int i=0;i<MAX_SYSCALL_NUM;i++)
		ti->syscall_times[i] = curr_proc()->proc_syscall_times[i];
	return 0;
}
uint64 sys_getpid()
{
	return curr_proc()->pid;
}

extern char trap_page[];

void syscall()
{
	struct trapframe *trapframe = curr_proc()->trapframe;
	int id = trapframe->a7, ret;
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
	       args[1], args[2], args[3], args[4], args[5]);
	switch (id) {
	case SYS_write:
		curr_proc()->proc_syscall_times[SYS_write]++;
		ret = sys_write(args[0], (char *)args[1], args[2]);
		break;
	case SYS_exit:
		curr_proc()->proc_syscall_times[SYS_exit]++;
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		curr_proc()->proc_syscall_times[SYS_sched_yield]++;
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		curr_proc()->proc_syscall_times[SYS_gettimeofday]++;
		ret = sys_gettimeofday((TimeVal *)args[0], args[1]);
		break;
	// add sys_task_info syscall
	case SYS_task_info:
		curr_proc()->proc_syscall_times[SYS_task_info]++;
		ret = sys_task_info((TaskInfo *)args[0]);
		break;
	case SYS_getpid:
		curr_proc()->proc_syscall_times[SYS_getpid]++;
		ret = sys_getpid();
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}
