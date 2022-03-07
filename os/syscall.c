#include "syscall.h"
#include "console.h"
#include "defs.h"
#include "loader.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

uint64 sys_write(int fd, uint64 va, uint len)
{
	debugf("sys_write fd = %d str = %x, len = %d", fd, va, len);
	if (fd != STDOUT)
		return -1;
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}

uint64 sys_read(int fd, uint64 va, uint64 len)
{
	debugf("sys_read fd = %d str = %x, len = %d", fd, va, len);
	if (fd != STDIN)
		return -1;
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	for (int i = 0; i < len; ++i) {
		int c = consgetc();
		str[i] = c;
	}
	copyout(p->pagetable, va, str, len);
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

uint64 sys_gettimeofday(uint64 val, int _tz)
{
	struct proc *p = curr_proc();
	uint64 cycle = get_cycle();
	TimeVal t;
	t.sec = cycle / CPU_FREQ;
	t.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	copyout(p->pagetable, val, (char *)&t, sizeof(TimeVal));
	return 0;
}

uint64 sys_getpid()
{
	return curr_proc()->pid;
}

uint64 sys_getppid()
{
	struct proc *p = curr_proc();
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
}

uint64 sys_clone()
{
	debugf("fork!\n");
	return fork();
}

uint64 sys_exec(uint64 va)
{
	struct proc *p = curr_proc();
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
	debugf("sys_exec %s\n", name);
	return exec(name);
}

uint64 sys_wait(int pid, uint64 va)
{
	struct proc *p = curr_proc();
	int *code = (int *)useraddr(p->pagetable, va);
	return wait(pid, code);
}
uint64 check_remap(pagetable_t pagetable,uint64 va,uint64 size)
{
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
	last = PGROUNDDOWN(va + size - 1);
	for (;;) {
		if ((pte = walk(pagetable, a, 1)) == 0)
			return -1;
		if (*pte & PTE_V) {
			// remap
			return -1;
		}
		if (a == last)
			break;
		a += PGSIZE;
	}
	return 0;
}
/**
 * @brief alloc memory from virtuall address start, and length is len.
 * 
 * @param start 
 * @param len 
 * @param port _____xwr
 * @param flag no use
 * @param fd no use
 * @return uint64 
 */
uint64 sys_mmap(void* start, unsigned long long len, int port, int flag, int fd)
{
	/**
	 * @brief verify port
	 * 
	 */
	if((port & ~0x7) != 0 || (port & 0x7) == 0)
	{
		return -1;
	}	
	/**
	 * @brief verify len:[0,1G)
	 * 
	 */
	if(len == 0)
		return 0;
	else if(len > (1<<30))
	{
		return -1;
	}
	len = PGROUNDUP(len);
	/**
	 * @brief verify virtual address wheather aligned
	 * 
	 */
	uint64 va = (uint64)start;
	if(!PGALIGNED(va))
	{
		return -1;
	}	
	pagetable_t pg = curr_proc()->pagetable;
	int page_num = len/PGSIZE;
	int perm = 0;
	if(port&0x1)
		perm |= PTE_R;
	if(port&0x2)
		perm |= PTE_W;
	if(port&0x4)
		perm |= PTE_X;
	for(int i=0;i<page_num;i++)
	{
		uint64 pa = (uint64)kalloc();
		if(pa == 0)
		{
			return -1;
		}
		if(check_remap(pg,va,PGSIZE)==-1)
			return -1;
		int ret = mappages(pg,va,PGSIZE,pa,PTE_U | perm);
		if(ret != 0)
		{
			// Don't consider recover allocated pages
			return -1;
		}
		va += PGSIZE;
	}
	/*Attention !!! max_page!!!*/
	curr_proc()->max_page += page_num;
	
	return 0;
}
uint64 sys_munmap(void *start, unsigned long long len)
{
	/**
	 * @brief verify virtual address wheather aligned
	 * 
	 */
	uint64 va = (uint64)start;
	if(!PGALIGNED(va))
	{
		return -1;
	}
	/**
	 * @brief verify len:[0,1G)
	 * 
	 */
	if(len == 0)
		return 0;
	else if(len > (1<<30))
	{
		return -1;
	}
	len = PGROUNDUP(len);
	int page_num = len/PGSIZE;
	pagetable_t pg = curr_proc()->pagetable;
	for(int i=0;i<page_num;i++)
	{
		uint64 pa = useraddr(pg,va);
		if(!pa)
		{
			return -1;
		}
		/*SHM is impossible in the chapther*/
		int do_free = 1;
		uvmunmap(pg,va,1,do_free);
		va+=PGSIZE;
	}
	/*Attention !!! max_page!!!*/
	curr_proc()->max_page -= page_num;
	return 0;
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
		ret = sys_write(args[0], args[1], args[2]);
		break;
	case SYS_read:
		ret = sys_read(args[0], args[1], args[2]);
		break;
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		ret = sys_gettimeofday(args[0], args[1]);
		break;
	case SYS_getpid:
		ret = sys_getpid();
		break;
	case SYS_getppid:
		ret = sys_getppid();
		break;
	case SYS_clone: // SYS_fork
		ret = sys_clone();
		break;
	case SYS_execve:
		ret = sys_exec(args[0]);
		break;
	case SYS_wait4:
		ret = sys_wait(args[0], args[1]);
		break;
	case SYS_mmap:
		ret = sys_mmap((void *)args[0],
	       args[1], args[2], args[3], args[4]);
		break;
	case SYS_munmap:
		ret = sys_munmap((void *)args[0], args[1]);
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}
