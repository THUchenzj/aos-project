#ifndef TASK_INFO_H
#define TASK_INFO_H
#define MAX_SYSCALL_NUM 500
typedef enum {
	UnInit,
	Ready,
	Running,
	Exited,
} TaskStatus;

typedef struct {
	TaskStatus status;
	unsigned int syscall_times[MAX_SYSCALL_NUM];
	int time;
} TaskInfo;
#endif