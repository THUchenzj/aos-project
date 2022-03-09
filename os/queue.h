#ifndef QUEUE_H
#define QUEUE_H
#define QUEUE_SIZE (1024)
#include "proc.h"
struct queue {
	int data[QUEUE_SIZE];
	int front;
	int tail;
	int empty;
};

void init_queue(struct queue *);
void push_queue(struct queue *, int);
int pop_queue(struct queue *);
struct proc;
int stride(struct queue *, struct proc *);
#endif // QUEUE_H
