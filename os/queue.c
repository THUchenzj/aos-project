#include "queue.h"
#include "defs.h"
void init_queue(struct queue *q)
{
	q->front = q->tail = 0;
	q->empty = 1;
}

void push_queue(struct queue *q, int value)
{
	if (!q->empty && q->front == q->tail) {
		panic("queue shouldn't be overflow");
	}
	q->empty = 0;
	q->data[q->tail] = value;
	q->tail = (q->tail + 1) % NPROC;
}

int pop_queue(struct queue *q)
{
	if (q->empty)
		return -1;
	int value = q->data[q->front];
	q->front = (q->front + 1) % NPROC;
	if (q->front == q->tail)
		q->empty = 1;
	return value;
}

int stride(struct queue *q, struct proc *pool)
{
	if(q->empty)
		return -1;
	int val = INT_MAX;
	int ptr = -1;
	for(int i = q->front;i<q->tail;i = (i+1)%NPROC)
	{
		
		int v = (pool+q->data[i])->stride;
		//if(pid == 1)continue;
		if(v < val)
		{
			ptr = i;
			val = v;
		}
	}
	/*swap ptr and q->tail-1*/
	if(ptr!=(q->tail-1+NPROC)%NPROC)
	{
		int tmp = q->data[(q->tail-1+NPROC)%NPROC];
		q->data[(q->tail-1+NPROC)%NPROC] = q->data[ptr];
		q->data[ptr] = tmp;
	}
	return pop_queue(q);


}
