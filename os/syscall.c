#include "syscall.h"
#include "defs.h"
#include "loader.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

uint64 sys_write(int fd, uint64 va, uint len)
{
	debugf("sys_write fd = %d va = %x, len = %d", fd, va, len);
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
/**
 * @brief gettimeofday
 * 
 * @param val time
 * @param _tz no use
 * @return uint64 
 */
uint64 sys_gettimeofday(TimeVal *val, int _tz)
{
	// YOUR CODE
	TimeVal *src = (TimeVal *)kalloc();
	if(src == 0){
		return -1;
	}

	uint64 cycle = get_cycle();
	src->sec = cycle / CPU_FREQ;
	src->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	uint64 dstva = (uint64)val;

	struct proc *p = curr_proc();
	int ret = copyout(p->pagetable, dstva,(char *)src,sizeof(TimeVal));
	kfree(src);
	if(ret == -1)
	{
		return -1;
	}
	/* The code in `ch3` will leads to memory bugs*/

	// uint64 cycle = get_cycle();
	// val->sec = cycle / CPU_FREQ;
	// val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	return 0;
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
 * @brief alloc memory start from start, and length is len.
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
	if(va > curr_proc()->max_va)
	{
		curr_proc()->max_va = va; 
		curr_proc()->max_page = PGROUNDUP(curr_proc()->max_va)/PGSIZE;
	}

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
	uint64 init_va = (uint64)start;
	if( va >= curr_proc()->max_va)
		curr_proc()->max_page = PGROUNDUP(init_va) / PAGE_SIZE;
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
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		ret = sys_gettimeofday((TimeVal *)args[0], args[1]);
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
