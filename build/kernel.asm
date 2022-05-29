
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	0001a117          	auipc	sp,0x1a
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	599000ef          	jal	ra,80200da0 <main>

000000008020000c <init_queue>:
#include "defs.h"

int process_queue_data[QUEUE_SIZE];

void init_queue(struct queue *q, int size, int *data)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e422                	sd	s0,8(sp)
    80200010:	0800                	addi	s0,sp,16
	q->size = size;
    80200012:	c50c                	sw	a1,8(a0)
	q->data = data;
    80200014:	e110                	sd	a2,0(a0)
	q->front = q->tail = 0;
    80200016:	00052823          	sw	zero,16(a0)
    8020001a:	00052623          	sw	zero,12(a0)
	q->empty = 1;
    8020001e:	4785                	li	a5,1
    80200020:	c95c                	sw	a5,20(a0)
}
    80200022:	6422                	ld	s0,8(sp)
    80200024:	0141                	addi	sp,sp,16
    80200026:	8082                	ret

0000000080200028 <push_queue>:

void push_queue(struct queue *q, int value)
{
	if (!q->empty && q->front == q->tail) {
    80200028:	495c                	lw	a5,20(a0)
    8020002a:	e789                	bnez	a5,80200034 <push_queue+0xc>
    8020002c:	4558                	lw	a4,12(a0)
    8020002e:	491c                	lw	a5,16(a0)
    80200030:	02f70063          	beq	a4,a5,80200050 <push_queue+0x28>
		panic("queue shouldn't be overflow");
	}
	q->empty = 0;
    80200034:	00052a23          	sw	zero,20(a0)
	q->data[q->tail] = value;
    80200038:	4918                	lw	a4,16(a0)
    8020003a:	611c                	ld	a5,0(a0)
    8020003c:	070a                	slli	a4,a4,0x2
    8020003e:	97ba                	add	a5,a5,a4
    80200040:	c38c                	sw	a1,0(a5)
	q->tail = (q->tail + 1) % q->size;
    80200042:	491c                	lw	a5,16(a0)
    80200044:	2785                	addiw	a5,a5,1
    80200046:	4518                	lw	a4,8(a0)
    80200048:	02e7e7bb          	remw	a5,a5,a4
    8020004c:	c91c                	sw	a5,16(a0)
    8020004e:	8082                	ret
{
    80200050:	1101                	addi	sp,sp,-32
    80200052:	ec06                	sd	ra,24(sp)
    80200054:	e822                	sd	s0,16(sp)
    80200056:	e426                	sd	s1,8(sp)
    80200058:	1000                	addi	s0,sp,32
		panic("queue shouldn't be overflow");
    8020005a:	00004097          	auipc	ra,0x4
    8020005e:	344080e7          	jalr	836(ra) # 8020439e <procid>
    80200062:	84aa                	mv	s1,a0
    80200064:	00004097          	auipc	ra,0x4
    80200068:	354080e7          	jalr	852(ra) # 802043b8 <threadid>
    8020006c:	4845                	li	a6,17
    8020006e:	00008797          	auipc	a5,0x8
    80200072:	f9278793          	addi	a5,a5,-110 # 80208000 <e_text>
    80200076:	872a                	mv	a4,a0
    80200078:	86a6                	mv	a3,s1
    8020007a:	00008617          	auipc	a2,0x8
    8020007e:	f9660613          	addi	a2,a2,-106 # 80208010 <e_text+0x10>
    80200082:	45fd                	li	a1,31
    80200084:	00008517          	auipc	a0,0x8
    80200088:	f9450513          	addi	a0,a0,-108 # 80208018 <e_text+0x18>
    8020008c:	00003097          	auipc	ra,0x3
    80200090:	03a080e7          	jalr	58(ra) # 802030c6 <printf>
    80200094:	00003097          	auipc	ra,0x3
    80200098:	24a080e7          	jalr	586(ra) # 802032de <shutdown>

000000008020009c <pop_queue>:
}

int pop_queue(struct queue *q)
{
    8020009c:	1141                	addi	sp,sp,-16
    8020009e:	e422                	sd	s0,8(sp)
    802000a0:	0800                	addi	s0,sp,16
	if (q->empty)
    802000a2:	495c                	lw	a5,20(a0)
    802000a4:	eb85                	bnez	a5,802000d4 <pop_queue+0x38>
    802000a6:	872a                	mv	a4,a0
		return -1;
	int value = q->data[q->front];
    802000a8:	455c                	lw	a5,12(a0)
    802000aa:	6114                	ld	a3,0(a0)
    802000ac:	00279613          	slli	a2,a5,0x2
    802000b0:	96b2                	add	a3,a3,a2
    802000b2:	4288                	lw	a0,0(a3)
	q->front = (q->front + 1) % q->size;
    802000b4:	2785                	addiw	a5,a5,1
    802000b6:	4714                	lw	a3,8(a4)
    802000b8:	02d7e7bb          	remw	a5,a5,a3
    802000bc:	0007869b          	sext.w	a3,a5
    802000c0:	c75c                	sw	a5,12(a4)
	if (q->front == q->tail)
    802000c2:	4b1c                	lw	a5,16(a4)
    802000c4:	00d78563          	beq	a5,a3,802000ce <pop_queue+0x32>
		q->empty = 1;
	return value;
}
    802000c8:	6422                	ld	s0,8(sp)
    802000ca:	0141                	addi	sp,sp,16
    802000cc:	8082                	ret
		q->empty = 1;
    802000ce:	4785                	li	a5,1
    802000d0:	cb5c                	sw	a5,20(a4)
    802000d2:	bfdd                	j	802000c8 <pop_queue+0x2c>
		return -1;
    802000d4:	557d                	li	a0,-1
    802000d6:	bfcd                	j	802000c8 <pop_queue+0x2c>

00000000802000d8 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    802000d8:	1141                	addi	sp,sp,-16
    802000da:	e422                	sd	s0,8(sp)
    802000dc:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    802000de:	ce09                	beqz	a2,802000f8 <memset+0x20>
    802000e0:	87aa                	mv	a5,a0
    802000e2:	fff6071b          	addiw	a4,a2,-1
    802000e6:	1702                	slli	a4,a4,0x20
    802000e8:	9301                	srli	a4,a4,0x20
    802000ea:	0705                	addi	a4,a4,1
    802000ec:	972a                	add	a4,a4,a0
		cdst[i] = c;
    802000ee:	00b78023          	sb	a1,0(a5)
    802000f2:	0785                	addi	a5,a5,1
	for (i = 0; i < n; i++) {
    802000f4:	fee79de3          	bne	a5,a4,802000ee <memset+0x16>
	}
	return dst;
}
    802000f8:	6422                	ld	s0,8(sp)
    802000fa:	0141                	addi	sp,sp,16
    802000fc:	8082                	ret

00000000802000fe <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    802000fe:	1141                	addi	sp,sp,-16
    80200100:	e422                	sd	s0,8(sp)
    80200102:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    80200104:	ce15                	beqz	a2,80200140 <memcmp+0x42>
    80200106:	fff6069b          	addiw	a3,a2,-1
		if (*s1 != *s2)
    8020010a:	00054783          	lbu	a5,0(a0)
    8020010e:	0005c703          	lbu	a4,0(a1)
    80200112:	02e79063          	bne	a5,a4,80200132 <memcmp+0x34>
    80200116:	1682                	slli	a3,a3,0x20
    80200118:	9281                	srli	a3,a3,0x20
    8020011a:	0685                	addi	a3,a3,1
    8020011c:	96aa                	add	a3,a3,a0
			return *s1 - *s2;
		s1++, s2++;
    8020011e:	0505                	addi	a0,a0,1
    80200120:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    80200122:	00d50d63          	beq	a0,a3,8020013c <memcmp+0x3e>
		if (*s1 != *s2)
    80200126:	00054783          	lbu	a5,0(a0)
    8020012a:	0005c703          	lbu	a4,0(a1)
    8020012e:	fee788e3          	beq	a5,a4,8020011e <memcmp+0x20>
			return *s1 - *s2;
    80200132:	40e7853b          	subw	a0,a5,a4
	}

	return 0;
}
    80200136:	6422                	ld	s0,8(sp)
    80200138:	0141                	addi	sp,sp,16
    8020013a:	8082                	ret
	return 0;
    8020013c:	4501                	li	a0,0
    8020013e:	bfe5                	j	80200136 <memcmp+0x38>
    80200140:	4501                	li	a0,0
    80200142:	bfd5                	j	80200136 <memcmp+0x38>

0000000080200144 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    80200144:	1141                	addi	sp,sp,-16
    80200146:	e422                	sd	s0,8(sp)
    80200148:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    8020014a:	02a5e563          	bltu	a1,a0,80200174 <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    8020014e:	fff6069b          	addiw	a3,a2,-1
    80200152:	ce11                	beqz	a2,8020016e <memmove+0x2a>
    80200154:	1682                	slli	a3,a3,0x20
    80200156:	9281                	srli	a3,a3,0x20
    80200158:	0685                	addi	a3,a3,1
    8020015a:	96ae                	add	a3,a3,a1
    8020015c:	87aa                	mv	a5,a0
			*d++ = *s++;
    8020015e:	0585                	addi	a1,a1,1
    80200160:	0785                	addi	a5,a5,1
    80200162:	fff5c703          	lbu	a4,-1(a1)
    80200166:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    8020016a:	fed59ae3          	bne	a1,a3,8020015e <memmove+0x1a>

	return dst;
}
    8020016e:	6422                	ld	s0,8(sp)
    80200170:	0141                	addi	sp,sp,16
    80200172:	8082                	ret
	if (s < d && s + n > d) {
    80200174:	02061713          	slli	a4,a2,0x20
    80200178:	9301                	srli	a4,a4,0x20
    8020017a:	00e587b3          	add	a5,a1,a4
    8020017e:	fcf578e3          	bgeu	a0,a5,8020014e <memmove+0xa>
		d += n;
    80200182:	972a                	add	a4,a4,a0
		while (n-- > 0)
    80200184:	fff6069b          	addiw	a3,a2,-1
    80200188:	d27d                	beqz	a2,8020016e <memmove+0x2a>
    8020018a:	02069613          	slli	a2,a3,0x20
    8020018e:	9201                	srli	a2,a2,0x20
    80200190:	fff64613          	not	a2,a2
    80200194:	963e                	add	a2,a2,a5
			*--d = *--s;
    80200196:	17fd                	addi	a5,a5,-1
    80200198:	177d                	addi	a4,a4,-1
    8020019a:	0007c683          	lbu	a3,0(a5)
    8020019e:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    802001a2:	fef61ae3          	bne	a2,a5,80200196 <memmove+0x52>
    802001a6:	b7e1                	j	8020016e <memmove+0x2a>

00000000802001a8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    802001a8:	1141                	addi	sp,sp,-16
    802001aa:	e406                	sd	ra,8(sp)
    802001ac:	e022                	sd	s0,0(sp)
    802001ae:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    802001b0:	00000097          	auipc	ra,0x0
    802001b4:	f94080e7          	jalr	-108(ra) # 80200144 <memmove>
}
    802001b8:	60a2                	ld	ra,8(sp)
    802001ba:	6402                	ld	s0,0(sp)
    802001bc:	0141                	addi	sp,sp,16
    802001be:	8082                	ret

00000000802001c0 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    802001c0:	1141                	addi	sp,sp,-16
    802001c2:	e422                	sd	s0,8(sp)
    802001c4:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    802001c6:	c229                	beqz	a2,80200208 <strncmp+0x48>
    802001c8:	00054783          	lbu	a5,0(a0)
    802001cc:	c795                	beqz	a5,802001f8 <strncmp+0x38>
    802001ce:	0005c703          	lbu	a4,0(a1)
    802001d2:	02f71363          	bne	a4,a5,802001f8 <strncmp+0x38>
    802001d6:	fff6071b          	addiw	a4,a2,-1
    802001da:	1702                	slli	a4,a4,0x20
    802001dc:	9301                	srli	a4,a4,0x20
    802001de:	0705                	addi	a4,a4,1
    802001e0:	972a                	add	a4,a4,a0
		n--, p++, q++;
    802001e2:	0505                	addi	a0,a0,1
    802001e4:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    802001e6:	02e50363          	beq	a0,a4,8020020c <strncmp+0x4c>
    802001ea:	00054783          	lbu	a5,0(a0)
    802001ee:	c789                	beqz	a5,802001f8 <strncmp+0x38>
    802001f0:	0005c683          	lbu	a3,0(a1)
    802001f4:	fef687e3          	beq	a3,a5,802001e2 <strncmp+0x22>
	if (n == 0)
		return 0;
	return (uchar)*p - (uchar)*q;
    802001f8:	00054503          	lbu	a0,0(a0)
    802001fc:	0005c783          	lbu	a5,0(a1)
    80200200:	9d1d                	subw	a0,a0,a5
}
    80200202:	6422                	ld	s0,8(sp)
    80200204:	0141                	addi	sp,sp,16
    80200206:	8082                	ret
		return 0;
    80200208:	4501                	li	a0,0
    8020020a:	bfe5                	j	80200202 <strncmp+0x42>
    8020020c:	4501                	li	a0,0
    8020020e:	bfd5                	j	80200202 <strncmp+0x42>

0000000080200210 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    80200210:	1141                	addi	sp,sp,-16
    80200212:	e422                	sd	s0,8(sp)
    80200214:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    80200216:	872a                	mv	a4,a0
    80200218:	a011                	j	8020021c <strncpy+0xc>
    8020021a:	8642                	mv	a2,a6
    8020021c:	fff6081b          	addiw	a6,a2,-1
    80200220:	00c05963          	blez	a2,80200232 <strncpy+0x22>
    80200224:	0705                	addi	a4,a4,1
    80200226:	0005c783          	lbu	a5,0(a1)
    8020022a:	fef70fa3          	sb	a5,-1(a4)
    8020022e:	0585                	addi	a1,a1,1
    80200230:	f7ed                	bnez	a5,8020021a <strncpy+0xa>
		;
	while (n-- > 0)
    80200232:	86ba                	mv	a3,a4
    80200234:	01005b63          	blez	a6,8020024a <strncpy+0x3a>
		*s++ = 0;
    80200238:	0685                	addi	a3,a3,1
    8020023a:	fe068fa3          	sb	zero,-1(a3)
    8020023e:	fff6c793          	not	a5,a3
    80200242:	9fb9                	addw	a5,a5,a4
	while (n-- > 0)
    80200244:	9fb1                	addw	a5,a5,a2
    80200246:	fef049e3          	bgtz	a5,80200238 <strncpy+0x28>
	return os;
}
    8020024a:	6422                	ld	s0,8(sp)
    8020024c:	0141                	addi	sp,sp,16
    8020024e:	8082                	ret

0000000080200250 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    80200250:	1141                	addi	sp,sp,-16
    80200252:	e422                	sd	s0,8(sp)
    80200254:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    80200256:	02c05363          	blez	a2,8020027c <safestrcpy+0x2c>
    8020025a:	fff6069b          	addiw	a3,a2,-1
    8020025e:	1682                	slli	a3,a3,0x20
    80200260:	9281                	srli	a3,a3,0x20
    80200262:	96ae                	add	a3,a3,a1
    80200264:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    80200266:	00d58963          	beq	a1,a3,80200278 <safestrcpy+0x28>
    8020026a:	0585                	addi	a1,a1,1
    8020026c:	0785                	addi	a5,a5,1
    8020026e:	fff5c703          	lbu	a4,-1(a1)
    80200272:	fee78fa3          	sb	a4,-1(a5)
    80200276:	fb65                	bnez	a4,80200266 <safestrcpy+0x16>
		;
	*s = 0;
    80200278:	00078023          	sb	zero,0(a5)
	return os;
}
    8020027c:	6422                	ld	s0,8(sp)
    8020027e:	0141                	addi	sp,sp,16
    80200280:	8082                	ret

0000000080200282 <strlen>:

int strlen(const char *s)
{
    80200282:	1141                	addi	sp,sp,-16
    80200284:	e422                	sd	s0,8(sp)
    80200286:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    80200288:	00054783          	lbu	a5,0(a0)
    8020028c:	cf91                	beqz	a5,802002a8 <strlen+0x26>
    8020028e:	0505                	addi	a0,a0,1
    80200290:	87aa                	mv	a5,a0
    80200292:	4685                	li	a3,1
    80200294:	9e89                	subw	a3,a3,a0
		;
    80200296:	00f6853b          	addw	a0,a3,a5
    8020029a:	0785                	addi	a5,a5,1
	for (n = 0; s[n]; n++)
    8020029c:	fff7c703          	lbu	a4,-1(a5)
    802002a0:	fb7d                	bnez	a4,80200296 <strlen+0x14>
	return n;
}
    802002a2:	6422                	ld	s0,8(sp)
    802002a4:	0141                	addi	sp,sp,16
    802002a6:	8082                	ret
	for (n = 0; s[n]; n++)
    802002a8:	4501                	li	a0,0
    802002aa:	bfe5                	j	802002a2 <strlen+0x20>

00000000802002ac <dummy>:

void dummy(int _, ...)
{
    802002ac:	715d                	addi	sp,sp,-80
    802002ae:	e422                	sd	s0,8(sp)
    802002b0:	0800                	addi	s0,sp,16
    802002b2:	e40c                	sd	a1,8(s0)
    802002b4:	e810                	sd	a2,16(s0)
    802002b6:	ec14                	sd	a3,24(s0)
    802002b8:	f018                	sd	a4,32(s0)
    802002ba:	f41c                	sd	a5,40(s0)
    802002bc:	03043823          	sd	a6,48(s0)
    802002c0:	03143c23          	sd	a7,56(s0)
    802002c4:	6422                	ld	s0,8(sp)
    802002c6:	6161                	addi	sp,sp,80
    802002c8:	8082                	ret

00000000802002ca <set_usertrap>:

void kerneltrap();

// set up to take exceptions and traps while in the kernel.
void set_usertrap()
{
    802002ca:	1141                	addi	sp,sp,-16
    802002cc:	e422                	sd	s0,8(sp)
    802002ce:	0800                	addi	s0,sp,16
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    802002d0:	04000737          	lui	a4,0x4000
    802002d4:	00007797          	auipc	a5,0x7
    802002d8:	d2c78793          	addi	a5,a5,-724 # 80207000 <trampoline>
    802002dc:	00007697          	auipc	a3,0x7
    802002e0:	d2468693          	addi	a3,a3,-732 # 80207000 <trampoline>
    802002e4:	8f95                	sub	a5,a5,a3
    802002e6:	177d                	addi	a4,a4,-1
    802002e8:	0732                	slli	a4,a4,0xc
    802002ea:	97ba                	add	a5,a5,a4
    802002ec:	9bf1                	andi	a5,a5,-4

// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void w_stvec(uint64 x)
{
	asm volatile("csrw stvec, %0" : : "r"(x));
    802002ee:	10579073          	csrw	stvec,a5
}
    802002f2:	6422                	ld	s0,8(sp)
    802002f4:	0141                	addi	sp,sp,16
    802002f6:	8082                	ret

00000000802002f8 <set_kerneltrap>:

void set_kerneltrap()
{
    802002f8:	1141                	addi	sp,sp,-16
    802002fa:	e422                	sd	s0,8(sp)
    802002fc:	0800                	addi	s0,sp,16
	w_stvec((uint64)kernelvec & ~0x3); // DIRECT
    802002fe:	00006797          	auipc	a5,0x6
    80200302:	da278793          	addi	a5,a5,-606 # 802060a0 <kernelvec>
    80200306:	9bf1                	andi	a5,a5,-4
    80200308:	10579073          	csrw	stvec,a5
}
    8020030c:	6422                	ld	s0,8(sp)
    8020030e:	0141                	addi	sp,sp,16
    80200310:	8082                	ret

0000000080200312 <trap_init>:

// set up to take exceptions and traps while in the kernel.
void trap_init()
{
    80200312:	1141                	addi	sp,sp,-16
    80200314:	e422                	sd	s0,8(sp)
    80200316:	0800                	addi	s0,sp,16
	w_stvec((uint64)kernelvec & ~0x3); // DIRECT
    80200318:	00006797          	auipc	a5,0x6
    8020031c:	d8878793          	addi	a5,a5,-632 # 802060a0 <kernelvec>
    80200320:	9bf1                	andi	a5,a5,-4
    80200322:	10579073          	csrw	stvec,a5
	asm volatile("csrr %0, sie" : "=r"(x));
    80200326:	104027f3          	csrr	a5,sie
	// intr_on();
	set_kerneltrap();
	w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8020032a:	2227e793          	ori	a5,a5,546
	asm volatile("csrw sie, %0" : : "r"(x));
    8020032e:	10479073          	csrw	sie,a5
}
    80200332:	6422                	ld	s0,8(sp)
    80200334:	0141                	addi	sp,sp,16
    80200336:	8082                	ret

0000000080200338 <unknown_trap>:

void unknown_trap()
{
    80200338:	1101                	addi	sp,sp,-32
    8020033a:	ec06                	sd	ra,24(sp)
    8020033c:	e822                	sd	s0,16(sp)
    8020033e:	e426                	sd	s1,8(sp)
    80200340:	1000                	addi	s0,sp,32
	errorf("unknown trap: %p, stval = %p", r_scause(), r_stval());
    80200342:	00004097          	auipc	ra,0x4
    80200346:	05c080e7          	jalr	92(ra) # 8020439e <procid>
    8020034a:	84aa                	mv	s1,a0
    8020034c:	00004097          	auipc	ra,0x4
    80200350:	06c080e7          	jalr	108(ra) # 802043b8 <threadid>
    80200354:	872a                	mv	a4,a0

// Supervisor Trap Cause
static inline uint64 r_scause()
{
	uint64 x;
	asm volatile("csrr %0, scause" : "=r"(x));
    80200356:	142027f3          	csrr	a5,scause

// Supervisor Trap Value
static inline uint64 r_stval()
{
	uint64 x;
	asm volatile("csrr %0, stval" : "=r"(x));
    8020035a:	14302873          	csrr	a6,stval
    8020035e:	86a6                	mv	a3,s1
    80200360:	00008617          	auipc	a2,0x8
    80200364:	d3060613          	addi	a2,a2,-720 # 80208090 <e_text+0x90>
    80200368:	45fd                	li	a1,31
    8020036a:	00008517          	auipc	a0,0x8
    8020036e:	d2e50513          	addi	a0,a0,-722 # 80208098 <e_text+0x98>
    80200372:	00003097          	auipc	ra,0x3
    80200376:	d54080e7          	jalr	-684(ra) # 802030c6 <printf>
	exit(-1);
    8020037a:	557d                	li	a0,-1
    8020037c:	00005097          	auipc	ra,0x5
    80200380:	e28080e7          	jalr	-472(ra) # 802051a4 <exit>
}
    80200384:	60e2                	ld	ra,24(sp)
    80200386:	6442                	ld	s0,16(sp)
    80200388:	64a2                	ld	s1,8(sp)
    8020038a:	6105                	addi	sp,sp,32
    8020038c:	8082                	ret

000000008020038e <devintr>:

void devintr(uint64 cause)
{
    8020038e:	1101                	addi	sp,sp,-32
    80200390:	ec06                	sd	ra,24(sp)
    80200392:	e822                	sd	s0,16(sp)
    80200394:	e426                	sd	s1,8(sp)
    80200396:	1000                	addi	s0,sp,32
	int irq;
	switch (cause) {
    80200398:	4795                	li	a5,5
    8020039a:	00f50e63          	beq	a0,a5,802003b6 <devintr+0x28>
    8020039e:	47a5                	li	a5,9
    802003a0:	02f50963          	beq	a0,a5,802003d2 <devintr+0x44>
		}
		if (irq)
			plic_complete(irq);
		break;
	default:
		unknown_trap();
    802003a4:	00000097          	auipc	ra,0x0
    802003a8:	f94080e7          	jalr	-108(ra) # 80200338 <unknown_trap>
		break;
	}
}
    802003ac:	60e2                	ld	ra,24(sp)
    802003ae:	6442                	ld	s0,16(sp)
    802003b0:	64a2                	ld	s1,8(sp)
    802003b2:	6105                	addi	sp,sp,32
    802003b4:	8082                	ret
		set_next_timer();
    802003b6:	00005097          	auipc	ra,0x5
    802003ba:	f16080e7          	jalr	-234(ra) # 802052cc <set_next_timer>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    802003be:	100027f3          	csrr	a5,sstatus
		if ((r_sstatus() & SSTATUS_SPP) == 0) {
    802003c2:	1007f793          	andi	a5,a5,256
    802003c6:	f3fd                	bnez	a5,802003ac <devintr+0x1e>
			yield();
    802003c8:	00004097          	auipc	ra,0x4
    802003cc:	72c080e7          	jalr	1836(ra) # 80204af4 <yield>
    802003d0:	bff1                	j	802003ac <devintr+0x1e>
		irq = plic_claim();
    802003d2:	00004097          	auipc	ra,0x4
    802003d6:	f7e080e7          	jalr	-130(ra) # 80204350 <plic_claim>
    802003da:	84aa                	mv	s1,a0
		if (irq == UART0_IRQ) {
    802003dc:	47a9                	li	a5,10
    802003de:	00f50c63          	beq	a0,a5,802003f6 <devintr+0x68>
		} else if (irq == VIRTIO0_IRQ) {
    802003e2:	4785                	li	a5,1
    802003e4:	00f50f63          	beq	a0,a5,80200402 <devintr+0x74>
		} else if (irq) {
    802003e8:	d171                	beqz	a0,802003ac <devintr+0x1e>
			infof("unexpected interrupt irq=%d\n", irq);
    802003ea:	85aa                	mv	a1,a0
    802003ec:	4501                	li	a0,0
    802003ee:	00000097          	auipc	ra,0x0
    802003f2:	ebe080e7          	jalr	-322(ra) # 802002ac <dummy>
			plic_complete(irq);
    802003f6:	8526                	mv	a0,s1
    802003f8:	00004097          	auipc	ra,0x4
    802003fc:	f7c080e7          	jalr	-132(ra) # 80204374 <plic_complete>
    80200400:	b775                	j	802003ac <devintr+0x1e>
			virtio_disk_intr();
    80200402:	00001097          	auipc	ra,0x1
    80200406:	86c080e7          	jalr	-1940(ra) # 80200c6e <virtio_disk_intr>
    8020040a:	b7f5                	j	802003f6 <devintr+0x68>

000000008020040c <usertrapret>:

//
// return to user space
//
void usertrapret()
{
    8020040c:	7139                	addi	sp,sp,-64
    8020040e:	fc06                	sd	ra,56(sp)
    80200410:	f822                	sd	s0,48(sp)
    80200412:	f426                	sd	s1,40(sp)
    80200414:	f04a                	sd	s2,32(sp)
    80200416:	ec4e                	sd	s3,24(sp)
    80200418:	e852                	sd	s4,16(sp)
    8020041a:	e456                	sd	s5,8(sp)
    8020041c:	0080                	addi	s0,sp,64
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    8020041e:	00007a17          	auipc	s4,0x7
    80200422:	be2a0a13          	addi	s4,s4,-1054 # 80207000 <trampoline>
    80200426:	00007797          	auipc	a5,0x7
    8020042a:	bda78793          	addi	a5,a5,-1062 # 80207000 <trampoline>
    8020042e:	414787b3          	sub	a5,a5,s4
    80200432:	04000937          	lui	s2,0x4000
    80200436:	197d                	addi	s2,s2,-1
    80200438:	0932                	slli	s2,s2,0xc
    8020043a:	97ca                	add	a5,a5,s2
    8020043c:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    8020043e:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_thread()->trapframe;
    80200442:	00004097          	auipc	ra,0x4
    80200446:	fb4080e7          	jalr	-76(ra) # 802043f6 <curr_thread>
    8020044a:	7104                	ld	s1,32(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    8020044c:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80200450:	e09c                	sd	a5,0(s1)
	trapframe->kernel_sp =
		curr_thread()->kstack + KSTACK_SIZE; // process's kernel stack
    80200452:	00004097          	auipc	ra,0x4
    80200456:	fa4080e7          	jalr	-92(ra) # 802043f6 <curr_thread>
    8020045a:	6d1c                	ld	a5,24(a0)
    8020045c:	6705                	lui	a4,0x1
    8020045e:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    80200460:	e49c                	sd	a5,8(s1)
	trapframe->kernel_trap = (uint64)usertrap;
    80200462:	00000797          	auipc	a5,0x0
    80200466:	08478793          	addi	a5,a5,132 # 802004e6 <usertrap>
    8020046a:	e89c                	sd	a5,16(s1)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    8020046c:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // unuesd
    8020046e:	f09c                	sd	a5,32(s1)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80200470:	6c9c                	ld	a5,24(s1)
    80200472:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200476:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8020047a:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    8020047e:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80200482:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    80200486:	00004097          	auipc	ra,0x4
    8020048a:	f58080e7          	jalr	-168(ra) # 802043de <curr_proc>
    8020048e:	00853983          	ld	s3,8(a0)
    80200492:	00c9d993          	srli	s3,s3,0xc
    80200496:	57fd                	li	a5,-1
    80200498:	17fe                	slli	a5,a5,0x3f
    8020049a:	00f9e9b3          	or	s3,s3,a5
	uint64 fn = TRAMPOLINE + (userret - trampoline);
	uint64 trapframe_va = get_thread_trapframe_va(curr_thread()->tid);
    8020049e:	00004097          	auipc	ra,0x4
    802004a2:	f58080e7          	jalr	-168(ra) # 802043f6 <curr_thread>
    802004a6:	4148                	lw	a0,4(a0)
    802004a8:	00004097          	auipc	ra,0x4
    802004ac:	278080e7          	jalr	632(ra) # 80204720 <get_thread_trapframe_va>
    802004b0:	8aaa                	mv	s5,a0
	debugf("return to user @ %p, sp @ %p", trapframe->epc, trapframe->sp);
    802004b2:	7890                	ld	a2,48(s1)
    802004b4:	6c8c                	ld	a1,24(s1)
    802004b6:	4501                	li	a0,0
    802004b8:	00000097          	auipc	ra,0x0
    802004bc:	df4080e7          	jalr	-524(ra) # 802002ac <dummy>
	uint64 fn = TRAMPOLINE + (userret - trampoline);
    802004c0:	00007797          	auipc	a5,0x7
    802004c4:	bd878793          	addi	a5,a5,-1064 # 80207098 <userret>
    802004c8:	414787b3          	sub	a5,a5,s4
    802004cc:	993e                	add	s2,s2,a5
	((void (*)(uint64, uint64))fn)(trapframe_va, satp);
    802004ce:	85ce                	mv	a1,s3
    802004d0:	8556                	mv	a0,s5
    802004d2:	9902                	jalr	s2
}
    802004d4:	70e2                	ld	ra,56(sp)
    802004d6:	7442                	ld	s0,48(sp)
    802004d8:	74a2                	ld	s1,40(sp)
    802004da:	7902                	ld	s2,32(sp)
    802004dc:	69e2                	ld	s3,24(sp)
    802004de:	6a42                	ld	s4,16(sp)
    802004e0:	6aa2                	ld	s5,8(sp)
    802004e2:	6121                	addi	sp,sp,64
    802004e4:	8082                	ret

00000000802004e6 <usertrap>:
{
    802004e6:	7179                	addi	sp,sp,-48
    802004e8:	f406                	sd	ra,40(sp)
    802004ea:	f022                	sd	s0,32(sp)
    802004ec:	ec26                	sd	s1,24(sp)
    802004ee:	e84a                	sd	s2,16(sp)
    802004f0:	e44e                	sd	s3,8(sp)
    802004f2:	1800                	addi	s0,sp,48
	w_stvec((uint64)kernelvec & ~0x3); // DIRECT
    802004f4:	00006797          	auipc	a5,0x6
    802004f8:	bac78793          	addi	a5,a5,-1108 # 802060a0 <kernelvec>
    802004fc:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    802004fe:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_thread()->trapframe;
    80200502:	00004097          	auipc	ra,0x4
    80200506:	ef4080e7          	jalr	-268(ra) # 802043f6 <curr_thread>
    8020050a:	02053903          	ld	s2,32(a0)
	tracef("trap from user epc = %p", trapframe->epc);
    8020050e:	01893583          	ld	a1,24(s2) # 4000018 <BASE_ADDRESS-0x7c1fffe8>
    80200512:	4501                	li	a0,0
    80200514:	00000097          	auipc	ra,0x0
    80200518:	d98080e7          	jalr	-616(ra) # 802002ac <dummy>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    8020051c:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80200520:	1007f793          	andi	a5,a5,256
    80200524:	e395                	bnez	a5,80200548 <usertrap+0x62>
	asm volatile("csrr %0, scause" : "=r"(x));
    80200526:	142024f3          	csrr	s1,scause
	if (cause & (1ULL << 63)) {
    8020052a:	0604c163          	bltz	s1,8020058c <usertrap+0xa6>
		switch (cause) {
    8020052e:	47bd                	li	a5,15
    80200530:	1097ea63          	bltu	a5,s1,80200644 <usertrap+0x15e>
    80200534:	00249713          	slli	a4,s1,0x2
    80200538:	00008697          	auipc	a3,0x8
    8020053c:	b1868693          	addi	a3,a3,-1256 # 80208050 <e_text+0x50>
    80200540:	9736                	add	a4,a4,a3
    80200542:	431c                	lw	a5,0(a4)
    80200544:	97b6                	add	a5,a5,a3
    80200546:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80200548:	00004097          	auipc	ra,0x4
    8020054c:	e56080e7          	jalr	-426(ra) # 8020439e <procid>
    80200550:	84aa                	mv	s1,a0
    80200552:	00004097          	auipc	ra,0x4
    80200556:	e66080e7          	jalr	-410(ra) # 802043b8 <threadid>
    8020055a:	04f00813          	li	a6,79
    8020055e:	00008797          	auipc	a5,0x8
    80200562:	b7278793          	addi	a5,a5,-1166 # 802080d0 <e_text+0xd0>
    80200566:	872a                	mv	a4,a0
    80200568:	86a6                	mv	a3,s1
    8020056a:	00008617          	auipc	a2,0x8
    8020056e:	aa660613          	addi	a2,a2,-1370 # 80208010 <e_text+0x10>
    80200572:	45fd                	li	a1,31
    80200574:	00008517          	auipc	a0,0x8
    80200578:	b6c50513          	addi	a0,a0,-1172 # 802080e0 <e_text+0xe0>
    8020057c:	00003097          	auipc	ra,0x3
    80200580:	b4a080e7          	jalr	-1206(ra) # 802030c6 <printf>
    80200584:	00003097          	auipc	ra,0x3
    80200588:	d5a080e7          	jalr	-678(ra) # 802032de <shutdown>
		devintr(cause & 0xff);
    8020058c:	0ff4f513          	andi	a0,s1,255
    80200590:	00000097          	auipc	ra,0x0
    80200594:	dfe080e7          	jalr	-514(ra) # 8020038e <devintr>
	usertrapret();
    80200598:	00000097          	auipc	ra,0x0
    8020059c:	e74080e7          	jalr	-396(ra) # 8020040c <usertrapret>
}
    802005a0:	70a2                	ld	ra,40(sp)
    802005a2:	7402                	ld	s0,32(sp)
    802005a4:	64e2                	ld	s1,24(sp)
    802005a6:	6942                	ld	s2,16(sp)
    802005a8:	69a2                	ld	s3,8(sp)
    802005aa:	6145                	addi	sp,sp,48
    802005ac:	8082                	ret
			trapframe->epc += 4;
    802005ae:	01893783          	ld	a5,24(s2)
    802005b2:	0791                	addi	a5,a5,4
    802005b4:	00f93c23          	sd	a5,24(s2)
			syscall();
    802005b8:	00002097          	auipc	ra,0x2
    802005bc:	d2c080e7          	jalr	-724(ra) # 802022e4 <syscall>
			break;
    802005c0:	bfe1                	j	80200598 <usertrap+0xb2>
			errorf("%d in application, bad addr = %p, bad instruction = %p, "
    802005c2:	00004097          	auipc	ra,0x4
    802005c6:	ddc080e7          	jalr	-548(ra) # 8020439e <procid>
    802005ca:	89aa                	mv	s3,a0
    802005cc:	00004097          	auipc	ra,0x4
    802005d0:	dec080e7          	jalr	-532(ra) # 802043b8 <threadid>
    802005d4:	872a                	mv	a4,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    802005d6:	14302873          	csrr	a6,stval
    802005da:	01893883          	ld	a7,24(s2)
    802005de:	87a6                	mv	a5,s1
    802005e0:	86ce                	mv	a3,s3
    802005e2:	00008617          	auipc	a2,0x8
    802005e6:	aae60613          	addi	a2,a2,-1362 # 80208090 <e_text+0x90>
    802005ea:	45fd                	li	a1,31
    802005ec:	00008517          	auipc	a0,0x8
    802005f0:	b3450513          	addi	a0,a0,-1228 # 80208120 <e_text+0x120>
    802005f4:	00003097          	auipc	ra,0x3
    802005f8:	ad2080e7          	jalr	-1326(ra) # 802030c6 <printf>
			exit(-2);
    802005fc:	5579                	li	a0,-2
    802005fe:	00005097          	auipc	ra,0x5
    80200602:	ba6080e7          	jalr	-1114(ra) # 802051a4 <exit>
			break;
    80200606:	bf49                	j	80200598 <usertrap+0xb2>
			errorf("IllegalInstruction in application, core dumped.");
    80200608:	00004097          	auipc	ra,0x4
    8020060c:	d96080e7          	jalr	-618(ra) # 8020439e <procid>
    80200610:	84aa                	mv	s1,a0
    80200612:	00004097          	auipc	ra,0x4
    80200616:	da6080e7          	jalr	-602(ra) # 802043b8 <threadid>
    8020061a:	872a                	mv	a4,a0
    8020061c:	86a6                	mv	a3,s1
    8020061e:	00008617          	auipc	a2,0x8
    80200622:	a7260613          	addi	a2,a2,-1422 # 80208090 <e_text+0x90>
    80200626:	45fd                	li	a1,31
    80200628:	00008517          	auipc	a0,0x8
    8020062c:	b5850513          	addi	a0,a0,-1192 # 80208180 <e_text+0x180>
    80200630:	00003097          	auipc	ra,0x3
    80200634:	a96080e7          	jalr	-1386(ra) # 802030c6 <printf>
			exit(-3);
    80200638:	5575                	li	a0,-3
    8020063a:	00005097          	auipc	ra,0x5
    8020063e:	b6a080e7          	jalr	-1174(ra) # 802051a4 <exit>
			break;
    80200642:	bf99                	j	80200598 <usertrap+0xb2>
			unknown_trap();
    80200644:	00000097          	auipc	ra,0x0
    80200648:	cf4080e7          	jalr	-780(ra) # 80200338 <unknown_trap>
			break;
    8020064c:	b7b1                	j	80200598 <usertrap+0xb2>

000000008020064e <kerneltrap>:

void kerneltrap()
{
    8020064e:	7179                	addi	sp,sp,-48
    80200650:	f406                	sd	ra,40(sp)
    80200652:	f022                	sd	s0,32(sp)
    80200654:	ec26                	sd	s1,24(sp)
    80200656:	e84a                	sd	s2,16(sp)
    80200658:	e44e                	sd	s3,8(sp)
    8020065a:	e052                	sd	s4,0(sp)
    8020065c:	1800                	addi	s0,sp,48
	asm volatile("csrr %0, sepc" : "=r"(x));
    8020065e:	14102973          	csrr	s2,sepc
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200662:	100029f3          	csrr	s3,sstatus
	asm volatile("csrr %0, scause" : "=r"(x));
    80200666:	142024f3          	csrr	s1,scause
	uint64 sepc = r_sepc();
	uint64 sstatus = r_sstatus();
	uint64 scause = r_scause();

	debugf("kernel trap: epc = %p, cause = %d", sepc, scause);
    8020066a:	8626                	mv	a2,s1
    8020066c:	85ca                	mv	a1,s2
    8020066e:	4501                	li	a0,0
    80200670:	00000097          	auipc	ra,0x0
    80200674:	c3c080e7          	jalr	-964(ra) # 802002ac <dummy>

	if ((sstatus & SSTATUS_SPP) == 0)
    80200678:	1009f793          	andi	a5,s3,256
    8020067c:	c3a5                	beqz	a5,802006dc <kerneltrap+0x8e>
		panic("kerneltrap: not from supervisor mode");

	if (scause & (1ULL << 63)) {
    8020067e:	0a04c163          	bltz	s1,80200720 <kerneltrap+0xd2>
		devintr(scause & 0xff);
	} else {
		errorf("invalid trap from kernel: %p, stval = %p sepc = %p\n",
    80200682:	00004097          	auipc	ra,0x4
    80200686:	d1c080e7          	jalr	-740(ra) # 8020439e <procid>
    8020068a:	8a2a                	mv	s4,a0
    8020068c:	00004097          	auipc	ra,0x4
    80200690:	d2c080e7          	jalr	-724(ra) # 802043b8 <threadid>
    80200694:	872a                	mv	a4,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80200696:	14302873          	csrr	a6,stval
    8020069a:	88ca                	mv	a7,s2
    8020069c:	87a6                	mv	a5,s1
    8020069e:	86d2                	mv	a3,s4
    802006a0:	00008617          	auipc	a2,0x8
    802006a4:	9f060613          	addi	a2,a2,-1552 # 80208090 <e_text+0x90>
    802006a8:	45fd                	li	a1,31
    802006aa:	00008517          	auipc	a0,0x8
    802006ae:	b6650513          	addi	a0,a0,-1178 # 80208210 <e_text+0x210>
    802006b2:	00003097          	auipc	ra,0x3
    802006b6:	a14080e7          	jalr	-1516(ra) # 802030c6 <printf>
		       scause, r_stval(), sepc);
		exit(-1);
    802006ba:	557d                	li	a0,-1
    802006bc:	00005097          	auipc	ra,0x5
    802006c0:	ae8080e7          	jalr	-1304(ra) # 802051a4 <exit>
	asm volatile("csrw sepc, %0" : : "r"(x));
    802006c4:	14191073          	csrw	sepc,s2
	asm volatile("csrw sstatus, %0" : : "r"(x));
    802006c8:	10099073          	csrw	sstatus,s3
	}
	// the yield() may have caused some traps to occur,
	// so restore trap registers for use by kernelvec.S's sepc instruction.
	w_sepc(sepc);
	w_sstatus(sstatus);
}
    802006cc:	70a2                	ld	ra,40(sp)
    802006ce:	7402                	ld	s0,32(sp)
    802006d0:	64e2                	ld	s1,24(sp)
    802006d2:	6942                	ld	s2,16(sp)
    802006d4:	69a2                	ld	s3,8(sp)
    802006d6:	6a02                	ld	s4,0(sp)
    802006d8:	6145                	addi	sp,sp,48
    802006da:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    802006dc:	00004097          	auipc	ra,0x4
    802006e0:	cc2080e7          	jalr	-830(ra) # 8020439e <procid>
    802006e4:	84aa                	mv	s1,a0
    802006e6:	00004097          	auipc	ra,0x4
    802006ea:	cd2080e7          	jalr	-814(ra) # 802043b8 <threadid>
    802006ee:	09900813          	li	a6,153
    802006f2:	00008797          	auipc	a5,0x8
    802006f6:	9de78793          	addi	a5,a5,-1570 # 802080d0 <e_text+0xd0>
    802006fa:	872a                	mv	a4,a0
    802006fc:	86a6                	mv	a3,s1
    802006fe:	00008617          	auipc	a2,0x8
    80200702:	91260613          	addi	a2,a2,-1774 # 80208010 <e_text+0x10>
    80200706:	45fd                	li	a1,31
    80200708:	00008517          	auipc	a0,0x8
    8020070c:	ac050513          	addi	a0,a0,-1344 # 802081c8 <e_text+0x1c8>
    80200710:	00003097          	auipc	ra,0x3
    80200714:	9b6080e7          	jalr	-1610(ra) # 802030c6 <printf>
    80200718:	00003097          	auipc	ra,0x3
    8020071c:	bc6080e7          	jalr	-1082(ra) # 802032de <shutdown>
		devintr(scause & 0xff);
    80200720:	0ff4f513          	andi	a0,s1,255
    80200724:	00000097          	auipc	ra,0x0
    80200728:	c6a080e7          	jalr	-918(ra) # 8020038e <devintr>
    8020072c:	bf61                	j	802006c4 <kerneltrap+0x76>

000000008020072e <free_desc>:
	return -1;
}

// mark a descriptor as free.
static void free_desc(int i)
{
    8020072e:	1101                	addi	sp,sp,-32
    80200730:	ec06                	sd	ra,24(sp)
    80200732:	e822                	sd	s0,16(sp)
    80200734:	e426                	sd	s1,8(sp)
    80200736:	1000                	addi	s0,sp,32
	if (i >= NUM)
    80200738:	479d                	li	a5,7
    8020073a:	06a7c263          	blt	a5,a0,8020079e <free_desc+0x70>
		panic("free_desc 1");
	if (disk.free[i])
    8020073e:	0001b797          	auipc	a5,0x1b
    80200742:	8c278793          	addi	a5,a5,-1854 # 8021b000 <disk>
    80200746:	00a78733          	add	a4,a5,a0
    8020074a:	6789                	lui	a5,0x2
    8020074c:	97ba                	add	a5,a5,a4
    8020074e:	0187c783          	lbu	a5,24(a5) # 2018 <BASE_ADDRESS-0x801fdfe8>
    80200752:	ebc1                	bnez	a5,802007e2 <free_desc+0xb4>
		panic("free_desc 2");
	disk.desc[i].addr = 0;
    80200754:	00451793          	slli	a5,a0,0x4
    80200758:	0001d717          	auipc	a4,0x1d
    8020075c:	8a870713          	addi	a4,a4,-1880 # 8021d000 <disk+0x2000>
    80200760:	6314                	ld	a3,0(a4)
    80200762:	96be                	add	a3,a3,a5
    80200764:	0006b023          	sd	zero,0(a3)
	disk.desc[i].len = 0;
    80200768:	6314                	ld	a3,0(a4)
    8020076a:	96be                	add	a3,a3,a5
    8020076c:	0006a423          	sw	zero,8(a3)
	disk.desc[i].flags = 0;
    80200770:	6314                	ld	a3,0(a4)
    80200772:	96be                	add	a3,a3,a5
    80200774:	00069623          	sh	zero,12(a3)
	disk.desc[i].next = 0;
    80200778:	6318                	ld	a4,0(a4)
    8020077a:	97ba                	add	a5,a5,a4
    8020077c:	00079723          	sh	zero,14(a5)
	disk.free[i] = 1;
    80200780:	0001b797          	auipc	a5,0x1b
    80200784:	88078793          	addi	a5,a5,-1920 # 8021b000 <disk>
    80200788:	97aa                	add	a5,a5,a0
    8020078a:	6509                	lui	a0,0x2
    8020078c:	953e                	add	a0,a0,a5
    8020078e:	4785                	li	a5,1
    80200790:	00f50c23          	sb	a5,24(a0) # 2018 <BASE_ADDRESS-0x801fdfe8>
}
    80200794:	60e2                	ld	ra,24(sp)
    80200796:	6442                	ld	s0,16(sp)
    80200798:	64a2                	ld	s1,8(sp)
    8020079a:	6105                	addi	sp,sp,32
    8020079c:	8082                	ret
		panic("free_desc 1");
    8020079e:	00004097          	auipc	ra,0x4
    802007a2:	c00080e7          	jalr	-1024(ra) # 8020439e <procid>
    802007a6:	84aa                	mv	s1,a0
    802007a8:	00004097          	auipc	ra,0x4
    802007ac:	c10080e7          	jalr	-1008(ra) # 802043b8 <threadid>
    802007b0:	09800813          	li	a6,152
    802007b4:	00008797          	auipc	a5,0x8
    802007b8:	aa478793          	addi	a5,a5,-1372 # 80208258 <e_text+0x258>
    802007bc:	872a                	mv	a4,a0
    802007be:	86a6                	mv	a3,s1
    802007c0:	00008617          	auipc	a2,0x8
    802007c4:	85060613          	addi	a2,a2,-1968 # 80208010 <e_text+0x10>
    802007c8:	45fd                	li	a1,31
    802007ca:	00008517          	auipc	a0,0x8
    802007ce:	aa650513          	addi	a0,a0,-1370 # 80208270 <e_text+0x270>
    802007d2:	00003097          	auipc	ra,0x3
    802007d6:	8f4080e7          	jalr	-1804(ra) # 802030c6 <printf>
    802007da:	00003097          	auipc	ra,0x3
    802007de:	b04080e7          	jalr	-1276(ra) # 802032de <shutdown>
		panic("free_desc 2");
    802007e2:	00004097          	auipc	ra,0x4
    802007e6:	bbc080e7          	jalr	-1092(ra) # 8020439e <procid>
    802007ea:	84aa                	mv	s1,a0
    802007ec:	00004097          	auipc	ra,0x4
    802007f0:	bcc080e7          	jalr	-1076(ra) # 802043b8 <threadid>
    802007f4:	09a00813          	li	a6,154
    802007f8:	00008797          	auipc	a5,0x8
    802007fc:	a6078793          	addi	a5,a5,-1440 # 80208258 <e_text+0x258>
    80200800:	872a                	mv	a4,a0
    80200802:	86a6                	mv	a3,s1
    80200804:	00008617          	auipc	a2,0x8
    80200808:	80c60613          	addi	a2,a2,-2036 # 80208010 <e_text+0x10>
    8020080c:	45fd                	li	a1,31
    8020080e:	00008517          	auipc	a0,0x8
    80200812:	a8a50513          	addi	a0,a0,-1398 # 80208298 <e_text+0x298>
    80200816:	00003097          	auipc	ra,0x3
    8020081a:	8b0080e7          	jalr	-1872(ra) # 802030c6 <printf>
    8020081e:	00003097          	auipc	ra,0x3
    80200822:	ac0080e7          	jalr	-1344(ra) # 802032de <shutdown>

0000000080200826 <virtio_disk_init>:
{
    80200826:	1101                	addi	sp,sp,-32
    80200828:	ec06                	sd	ra,24(sp)
    8020082a:	e822                	sd	s0,16(sp)
    8020082c:	e426                	sd	s1,8(sp)
    8020082e:	1000                	addi	s0,sp,32
	if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80200830:	100017b7          	lui	a5,0x10001
    80200834:	4398                	lw	a4,0(a5)
    80200836:	2701                	sext.w	a4,a4
    80200838:	747277b7          	lui	a5,0x74727
    8020083c:	97678793          	addi	a5,a5,-1674 # 74726976 <BASE_ADDRESS-0xbad968a>
    80200840:	0ef71163          	bne	a4,a5,80200922 <virtio_disk_init+0xfc>
	    *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80200844:	100017b7          	lui	a5,0x10001
    80200848:	43dc                	lw	a5,4(a5)
    8020084a:	2781                	sext.w	a5,a5
	if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8020084c:	4705                	li	a4,1
    8020084e:	0ce79a63          	bne	a5,a4,80200922 <virtio_disk_init+0xfc>
	    *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80200852:	100017b7          	lui	a5,0x10001
    80200856:	479c                	lw	a5,8(a5)
    80200858:	2781                	sext.w	a5,a5
    8020085a:	4709                	li	a4,2
    8020085c:	0ce79363          	bne	a5,a4,80200922 <virtio_disk_init+0xfc>
	    *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80200860:	100017b7          	lui	a5,0x10001
    80200864:	47d8                	lw	a4,12(a5)
    80200866:	2701                	sext.w	a4,a4
	    *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80200868:	554d47b7          	lui	a5,0x554d4
    8020086c:	55178793          	addi	a5,a5,1361 # 554d4551 <BASE_ADDRESS-0x2ad2baaf>
    80200870:	0af71963          	bne	a4,a5,80200922 <virtio_disk_init+0xfc>
	*R(VIRTIO_MMIO_STATUS) = status;
    80200874:	100017b7          	lui	a5,0x10001
    80200878:	4705                	li	a4,1
    8020087a:	dbb8                	sw	a4,112(a5)
	*R(VIRTIO_MMIO_STATUS) = status;
    8020087c:	470d                	li	a4,3
    8020087e:	dbb8                	sw	a4,112(a5)
	uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80200880:	4b94                	lw	a3,16(a5)
	features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80200882:	c7ffe737          	lui	a4,0xc7ffe
    80200886:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <e_bss+0xffffffff46ce075f>
    8020088a:	8f75                	and	a4,a4,a3
	*R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8020088c:	2701                	sext.w	a4,a4
    8020088e:	d398                	sw	a4,32(a5)
	*R(VIRTIO_MMIO_STATUS) = status;
    80200890:	472d                	li	a4,11
    80200892:	dbb8                	sw	a4,112(a5)
	*R(VIRTIO_MMIO_STATUS) = status;
    80200894:	473d                	li	a4,15
    80200896:	dbb8                	sw	a4,112(a5)
	*R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80200898:	6705                	lui	a4,0x1
    8020089a:	d798                	sw	a4,40(a5)
	*R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8020089c:	0207a823          	sw	zero,48(a5) # 10001030 <BASE_ADDRESS-0x701fefd0>
	uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    802008a0:	5bdc                	lw	a5,52(a5)
    802008a2:	2781                	sext.w	a5,a5
	if (max == 0)
    802008a4:	c3e9                	beqz	a5,80200966 <virtio_disk_init+0x140>
	if (max < NUM)
    802008a6:	471d                	li	a4,7
    802008a8:	10f77163          	bgeu	a4,a5,802009aa <virtio_disk_init+0x184>
	*R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    802008ac:	100014b7          	lui	s1,0x10001
    802008b0:	47a1                	li	a5,8
    802008b2:	dc9c                	sw	a5,56(s1)
	memset(disk.pages, 0, sizeof(disk.pages));
    802008b4:	6609                	lui	a2,0x2
    802008b6:	4581                	li	a1,0
    802008b8:	0001a517          	auipc	a0,0x1a
    802008bc:	74850513          	addi	a0,a0,1864 # 8021b000 <disk>
    802008c0:	00000097          	auipc	ra,0x0
    802008c4:	818080e7          	jalr	-2024(ra) # 802000d8 <memset>
	*R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    802008c8:	0001a717          	auipc	a4,0x1a
    802008cc:	73870713          	addi	a4,a4,1848 # 8021b000 <disk>
    802008d0:	00c75793          	srli	a5,a4,0xc
    802008d4:	2781                	sext.w	a5,a5
    802008d6:	c0bc                	sw	a5,64(s1)
	disk.desc = (struct virtq_desc *)disk.pages;
    802008d8:	0001c797          	auipc	a5,0x1c
    802008dc:	72878793          	addi	a5,a5,1832 # 8021d000 <disk+0x2000>
    802008e0:	e398                	sd	a4,0(a5)
	disk.avail = (struct virtq_avail *)(disk.pages +
    802008e2:	0001a717          	auipc	a4,0x1a
    802008e6:	79e70713          	addi	a4,a4,1950 # 8021b080 <disk+0x80>
    802008ea:	e798                	sd	a4,8(a5)
	disk.used = (struct virtq_used *)(disk.pages + PGSIZE);
    802008ec:	0001b717          	auipc	a4,0x1b
    802008f0:	71470713          	addi	a4,a4,1812 # 8021c000 <disk+0x1000>
    802008f4:	eb98                	sd	a4,16(a5)
		disk.free[i] = 1;
    802008f6:	4705                	li	a4,1
    802008f8:	00e78c23          	sb	a4,24(a5)
    802008fc:	00e78ca3          	sb	a4,25(a5)
    80200900:	00e78d23          	sb	a4,26(a5)
    80200904:	00e78da3          	sb	a4,27(a5)
    80200908:	00e78e23          	sb	a4,28(a5)
    8020090c:	00e78ea3          	sb	a4,29(a5)
    80200910:	00e78f23          	sb	a4,30(a5)
    80200914:	00e78fa3          	sb	a4,31(a5)
}
    80200918:	60e2                	ld	ra,24(sp)
    8020091a:	6442                	ld	s0,16(sp)
    8020091c:	64a2                	ld	s1,8(sp)
    8020091e:	6105                	addi	sp,sp,32
    80200920:	8082                	ret
		panic("could not find virtio disk");
    80200922:	00004097          	auipc	ra,0x4
    80200926:	a7c080e7          	jalr	-1412(ra) # 8020439e <procid>
    8020092a:	84aa                	mv	s1,a0
    8020092c:	00004097          	auipc	ra,0x4
    80200930:	a8c080e7          	jalr	-1396(ra) # 802043b8 <threadid>
    80200934:	04f00813          	li	a6,79
    80200938:	00008797          	auipc	a5,0x8
    8020093c:	92078793          	addi	a5,a5,-1760 # 80208258 <e_text+0x258>
    80200940:	872a                	mv	a4,a0
    80200942:	86a6                	mv	a3,s1
    80200944:	00007617          	auipc	a2,0x7
    80200948:	6cc60613          	addi	a2,a2,1740 # 80208010 <e_text+0x10>
    8020094c:	45fd                	li	a1,31
    8020094e:	00008517          	auipc	a0,0x8
    80200952:	97250513          	addi	a0,a0,-1678 # 802082c0 <e_text+0x2c0>
    80200956:	00002097          	auipc	ra,0x2
    8020095a:	770080e7          	jalr	1904(ra) # 802030c6 <printf>
    8020095e:	00003097          	auipc	ra,0x3
    80200962:	980080e7          	jalr	-1664(ra) # 802032de <shutdown>
		panic("virtio disk has no queue 0");
    80200966:	00004097          	auipc	ra,0x4
    8020096a:	a38080e7          	jalr	-1480(ra) # 8020439e <procid>
    8020096e:	84aa                	mv	s1,a0
    80200970:	00004097          	auipc	ra,0x4
    80200974:	a48080e7          	jalr	-1464(ra) # 802043b8 <threadid>
    80200978:	07100813          	li	a6,113
    8020097c:	00008797          	auipc	a5,0x8
    80200980:	8dc78793          	addi	a5,a5,-1828 # 80208258 <e_text+0x258>
    80200984:	872a                	mv	a4,a0
    80200986:	86a6                	mv	a3,s1
    80200988:	00007617          	auipc	a2,0x7
    8020098c:	68860613          	addi	a2,a2,1672 # 80208010 <e_text+0x10>
    80200990:	45fd                	li	a1,31
    80200992:	00008517          	auipc	a0,0x8
    80200996:	96650513          	addi	a0,a0,-1690 # 802082f8 <e_text+0x2f8>
    8020099a:	00002097          	auipc	ra,0x2
    8020099e:	72c080e7          	jalr	1836(ra) # 802030c6 <printf>
    802009a2:	00003097          	auipc	ra,0x3
    802009a6:	93c080e7          	jalr	-1732(ra) # 802032de <shutdown>
		panic("virtio disk max queue too short");
    802009aa:	00004097          	auipc	ra,0x4
    802009ae:	9f4080e7          	jalr	-1548(ra) # 8020439e <procid>
    802009b2:	84aa                	mv	s1,a0
    802009b4:	00004097          	auipc	ra,0x4
    802009b8:	a04080e7          	jalr	-1532(ra) # 802043b8 <threadid>
    802009bc:	07300813          	li	a6,115
    802009c0:	00008797          	auipc	a5,0x8
    802009c4:	89878793          	addi	a5,a5,-1896 # 80208258 <e_text+0x258>
    802009c8:	872a                	mv	a4,a0
    802009ca:	86a6                	mv	a3,s1
    802009cc:	00007617          	auipc	a2,0x7
    802009d0:	64460613          	addi	a2,a2,1604 # 80208010 <e_text+0x10>
    802009d4:	45fd                	li	a1,31
    802009d6:	00008517          	auipc	a0,0x8
    802009da:	95a50513          	addi	a0,a0,-1702 # 80208330 <e_text+0x330>
    802009de:	00002097          	auipc	ra,0x2
    802009e2:	6e8080e7          	jalr	1768(ra) # 802030c6 <printf>
    802009e6:	00003097          	auipc	ra,0x3
    802009ea:	8f8080e7          	jalr	-1800(ra) # 802032de <shutdown>

00000000802009ee <virtio_disk_rw>:
}

extern int PID;

void virtio_disk_rw(struct buf *b, int write)
{
    802009ee:	711d                	addi	sp,sp,-96
    802009f0:	ec86                	sd	ra,88(sp)
    802009f2:	e8a2                	sd	s0,80(sp)
    802009f4:	e4a6                	sd	s1,72(sp)
    802009f6:	e0ca                	sd	s2,64(sp)
    802009f8:	fc4e                	sd	s3,56(sp)
    802009fa:	f852                	sd	s4,48(sp)
    802009fc:	f456                	sd	s5,40(sp)
    802009fe:	f05a                	sd	s6,32(sp)
    80200a00:	ec5e                	sd	s7,24(sp)
    80200a02:	e862                	sd	s8,16(sp)
    80200a04:	1080                	addi	s0,sp,96
    80200a06:	892a                	mv	s2,a0
    80200a08:	8c2e                	mv	s8,a1
	uint64 sector = b->blockno * (BSIZE / 512);
    80200a0a:	00c52b83          	lw	s7,12(a0)
    80200a0e:	001b9b9b          	slliw	s7,s7,0x1
    80200a12:	1b82                	slli	s7,s7,0x20
    80200a14:	020bdb93          	srli	s7,s7,0x20
		if (disk.free[i]) {
    80200a18:	0001c997          	auipc	s3,0x1c
    80200a1c:	5e898993          	addi	s3,s3,1512 # 8021d000 <disk+0x2000>
	for (int i = 0; i < NUM; i++) {
    80200a20:	4b21                	li	s6,8
			disk.free[i] = 0;
    80200a22:	0001aa97          	auipc	s5,0x1a
    80200a26:	5dea8a93          	addi	s5,s5,1502 # 8021b000 <disk>
	for (int i = 0; i < 3; i++) {
    80200a2a:	4a0d                	li	s4,3
    80200a2c:	a8bd                	j	80200aaa <virtio_disk_rw+0xbc>
			disk.free[i] = 0;
    80200a2e:	00fa86b3          	add	a3,s5,a5
    80200a32:	96ae                	add	a3,a3,a1
    80200a34:	00068c23          	sb	zero,24(a3)
		idx[i] = alloc_desc();
    80200a38:	c21c                	sw	a5,0(a2)
		if (idx[i] < 0) {
    80200a3a:	0207ca63          	bltz	a5,80200a6e <virtio_disk_rw+0x80>
	for (int i = 0; i < 3; i++) {
    80200a3e:	2485                	addiw	s1,s1,1
    80200a40:	0711                	addi	a4,a4,4
    80200a42:	19448c63          	beq	s1,s4,80200bda <virtio_disk_rw+0x1ec>
		idx[i] = alloc_desc();
    80200a46:	863a                	mv	a2,a4
		if (disk.free[i]) {
    80200a48:	0189c783          	lbu	a5,24(s3)
    80200a4c:	20079c63          	bnez	a5,80200c64 <virtio_disk_rw+0x276>
    80200a50:	0001c697          	auipc	a3,0x1c
    80200a54:	5c968693          	addi	a3,a3,1481 # 8021d019 <disk+0x2019>
	for (int i = 0; i < NUM; i++) {
    80200a58:	87aa                	mv	a5,a0
		if (disk.free[i]) {
    80200a5a:	0006c803          	lbu	a6,0(a3)
    80200a5e:	fc0818e3          	bnez	a6,80200a2e <virtio_disk_rw+0x40>
	for (int i = 0; i < NUM; i++) {
    80200a62:	2785                	addiw	a5,a5,1
    80200a64:	0685                	addi	a3,a3,1
    80200a66:	ff679ae3          	bne	a5,s6,80200a5a <virtio_disk_rw+0x6c>
		idx[i] = alloc_desc();
    80200a6a:	57fd                	li	a5,-1
    80200a6c:	c21c                	sw	a5,0(a2)
			for (int j = 0; j < i; j++)
    80200a6e:	02905a63          	blez	s1,80200aa2 <virtio_disk_rw+0xb4>
				free_desc(idx[j]);
    80200a72:	fa042503          	lw	a0,-96(s0)
    80200a76:	00000097          	auipc	ra,0x0
    80200a7a:	cb8080e7          	jalr	-840(ra) # 8020072e <free_desc>
			for (int j = 0; j < i; j++)
    80200a7e:	4785                	li	a5,1
    80200a80:	0297d163          	bge	a5,s1,80200aa2 <virtio_disk_rw+0xb4>
				free_desc(idx[j]);
    80200a84:	fa442503          	lw	a0,-92(s0)
    80200a88:	00000097          	auipc	ra,0x0
    80200a8c:	ca6080e7          	jalr	-858(ra) # 8020072e <free_desc>
			for (int j = 0; j < i; j++)
    80200a90:	4789                	li	a5,2
    80200a92:	0097d863          	bge	a5,s1,80200aa2 <virtio_disk_rw+0xb4>
				free_desc(idx[j]);
    80200a96:	fa842503          	lw	a0,-88(s0)
    80200a9a:	00000097          	auipc	ra,0x0
    80200a9e:	c94080e7          	jalr	-876(ra) # 8020072e <free_desc>
	int idx[3];
	while (1) {
		if (alloc3_desc(idx) == 0) {
			break;
		}
		yield();
    80200aa2:	00004097          	auipc	ra,0x4
    80200aa6:	052080e7          	jalr	82(ra) # 80204af4 <yield>
	for (int i = 0; i < 3; i++) {
    80200aaa:	fa040713          	addi	a4,s0,-96
    80200aae:	4481                	li	s1,0
	for (int i = 0; i < NUM; i++) {
    80200ab0:	4505                	li	a0,1
			disk.free[i] = 0;
    80200ab2:	6589                	lui	a1,0x2
    80200ab4:	bf49                	j	80200a46 <virtio_disk_rw+0x58>
	disk.desc[idx[0]].next = idx[1];

	disk.desc[idx[1]].addr = (uint64)b->data;
	disk.desc[idx[1]].len = BSIZE;
	if (write)
		disk.desc[idx[1]].flags = 0; // device reads b->data
    80200ab6:	0001c697          	auipc	a3,0x1c
    80200aba:	54a68693          	addi	a3,a3,1354 # 8021d000 <disk+0x2000>
    80200abe:	6294                	ld	a3,0(a3)
    80200ac0:	96ba                	add	a3,a3,a4
    80200ac2:	00069623          	sh	zero,12(a3)
	else
		disk.desc[idx[1]].flags =
			VRING_DESC_F_WRITE; // device writes b->data
	disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80200ac6:	0001a817          	auipc	a6,0x1a
    80200aca:	53a80813          	addi	a6,a6,1338 # 8021b000 <disk>
    80200ace:	0001c697          	auipc	a3,0x1c
    80200ad2:	53268693          	addi	a3,a3,1330 # 8021d000 <disk+0x2000>
    80200ad6:	6290                	ld	a2,0(a3)
    80200ad8:	963a                	add	a2,a2,a4
    80200ada:	00c65583          	lhu	a1,12(a2)
    80200ade:	0015e593          	ori	a1,a1,1
    80200ae2:	00b61623          	sh	a1,12(a2)
	disk.desc[idx[1]].next = idx[2];
    80200ae6:	fa842603          	lw	a2,-88(s0)
    80200aea:	628c                	ld	a1,0(a3)
    80200aec:	972e                	add	a4,a4,a1
    80200aee:	00c71723          	sh	a2,14(a4)

	disk.info[idx[0]].status = 0xfb; // device writes 0 on success
    80200af2:	20050593          	addi	a1,a0,512
    80200af6:	0592                	slli	a1,a1,0x4
    80200af8:	95c2                	add	a1,a1,a6
    80200afa:	576d                	li	a4,-5
    80200afc:	02e58823          	sb	a4,48(a1) # 2030 <BASE_ADDRESS-0x801fdfd0>
	disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80200b00:	00461713          	slli	a4,a2,0x4
    80200b04:	6290                	ld	a2,0(a3)
    80200b06:	963a                	add	a2,a2,a4
    80200b08:	03078793          	addi	a5,a5,48
    80200b0c:	97c2                	add	a5,a5,a6
    80200b0e:	e21c                	sd	a5,0(a2)
	disk.desc[idx[2]].len = 1;
    80200b10:	629c                	ld	a5,0(a3)
    80200b12:	97ba                	add	a5,a5,a4
    80200b14:	4605                	li	a2,1
    80200b16:	c790                	sw	a2,8(a5)
	disk.desc[idx[2]].flags =
    80200b18:	629c                	ld	a5,0(a3)
    80200b1a:	97ba                	add	a5,a5,a4
    80200b1c:	4809                	li	a6,2
    80200b1e:	01079623          	sh	a6,12(a5)
		VRING_DESC_F_WRITE; // device writes the status
	disk.desc[idx[2]].next = 0;
    80200b22:	629c                	ld	a5,0(a3)
    80200b24:	973e                	add	a4,a4,a5
    80200b26:	00071723          	sh	zero,14(a4)

	// record struct buf for virtio_disk_intr().
	b->disk = 1;
    80200b2a:	00c92223          	sw	a2,4(s2)
	disk.info[idx[0]].b = b;
    80200b2e:	0325b423          	sd	s2,40(a1)

	// tell the device the first index in our chain of descriptors.
	disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80200b32:	6698                	ld	a4,8(a3)
    80200b34:	00275783          	lhu	a5,2(a4)
    80200b38:	8b9d                	andi	a5,a5,7
    80200b3a:	0786                	slli	a5,a5,0x1
    80200b3c:	97ba                	add	a5,a5,a4
    80200b3e:	00a79223          	sh	a0,4(a5)

	__sync_synchronize();
    80200b42:	0ff0000f          	fence

	// tell the device another avail ring entry is available.
	disk.avail->idx += 1; // not % NUM ...
    80200b46:	6698                	ld	a4,8(a3)
    80200b48:	00275783          	lhu	a5,2(a4)
    80200b4c:	2785                	addiw	a5,a5,1
    80200b4e:	00f71123          	sh	a5,2(a4)

	__sync_synchronize();
    80200b52:	0ff0000f          	fence

	*R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80200b56:	100017b7          	lui	a5,0x10001
    80200b5a:	0407a823          	sw	zero,80(a5) # 10001050 <BASE_ADDRESS-0x701fefb0>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200b5e:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() | SSTATUS_SIE);
    80200b62:	0027e793          	ori	a5,a5,2
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80200b66:	10079073          	csrw	sstatus,a5

	// Wait for virtio_disk_intr() to say request has finished.
	// Make sure complier will load 'b' form memory
	struct buf volatile *_b = b;
	intr_on();
	while (_b->disk == 1) {
    80200b6a:	4705                	li	a4,1
    80200b6c:	00492783          	lw	a5,4(s2)
    80200b70:	2781                	sext.w	a5,a5
    80200b72:	fee78de3          	beq	a5,a4,80200b6c <virtio_disk_rw+0x17e>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200b76:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80200b7a:	9bf5                	andi	a5,a5,-3
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80200b7c:	10079073          	csrw	sstatus,a5
		// WARN: No kernel concurrent support, DO NOT allow kernel yield
		// yield();
	}
	intr_off();
	disk.info[idx[0]].b = 0;
    80200b80:	fa042503          	lw	a0,-96(s0)
    80200b84:	20050793          	addi	a5,a0,512
    80200b88:	00479713          	slli	a4,a5,0x4
    80200b8c:	0001a797          	auipc	a5,0x1a
    80200b90:	47478793          	addi	a5,a5,1140 # 8021b000 <disk>
    80200b94:	97ba                	add	a5,a5,a4
    80200b96:	0207b423          	sd	zero,40(a5)
		int flag = disk.desc[i].flags;
    80200b9a:	0001c997          	auipc	s3,0x1c
    80200b9e:	46698993          	addi	s3,s3,1126 # 8021d000 <disk+0x2000>
    80200ba2:	00451713          	slli	a4,a0,0x4
    80200ba6:	0009b783          	ld	a5,0(s3)
    80200baa:	97ba                	add	a5,a5,a4
    80200bac:	00c7d483          	lhu	s1,12(a5)
		int nxt = disk.desc[i].next;
    80200bb0:	00e7d903          	lhu	s2,14(a5)
		free_desc(i);
    80200bb4:	00000097          	auipc	ra,0x0
    80200bb8:	b7a080e7          	jalr	-1158(ra) # 8020072e <free_desc>
			i = nxt;
    80200bbc:	854a                	mv	a0,s2
		if (flag & VRING_DESC_F_NEXT)
    80200bbe:	8885                	andi	s1,s1,1
    80200bc0:	f0ed                	bnez	s1,80200ba2 <virtio_disk_rw+0x1b4>
	free_chain(idx[0]);
}
    80200bc2:	60e6                	ld	ra,88(sp)
    80200bc4:	6446                	ld	s0,80(sp)
    80200bc6:	64a6                	ld	s1,72(sp)
    80200bc8:	6906                	ld	s2,64(sp)
    80200bca:	79e2                	ld	s3,56(sp)
    80200bcc:	7a42                	ld	s4,48(sp)
    80200bce:	7aa2                	ld	s5,40(sp)
    80200bd0:	7b02                	ld	s6,32(sp)
    80200bd2:	6be2                	ld	s7,24(sp)
    80200bd4:	6c42                	ld	s8,16(sp)
    80200bd6:	6125                	addi	sp,sp,96
    80200bd8:	8082                	ret
	struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80200bda:	fa042503          	lw	a0,-96(s0)
    80200bde:	20050793          	addi	a5,a0,512
    80200be2:	0792                	slli	a5,a5,0x4
	if (write)
    80200be4:	0001a817          	auipc	a6,0x1a
    80200be8:	41c80813          	addi	a6,a6,1052 # 8021b000 <disk>
    80200bec:	00f80733          	add	a4,a6,a5
    80200bf0:	018036b3          	snez	a3,s8
    80200bf4:	0ad72423          	sw	a3,168(a4)
	buf0->reserved = 0;
    80200bf8:	0a072623          	sw	zero,172(a4)
	buf0->sector = sector;
    80200bfc:	0b773823          	sd	s7,176(a4)
	disk.desc[idx[0]].addr = (uint64)buf0;
    80200c00:	7679                	lui	a2,0xffffe
    80200c02:	963e                	add	a2,a2,a5
    80200c04:	0001c697          	auipc	a3,0x1c
    80200c08:	3fc68693          	addi	a3,a3,1020 # 8021d000 <disk+0x2000>
    80200c0c:	6298                	ld	a4,0(a3)
    80200c0e:	9732                	add	a4,a4,a2
	struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80200c10:	0a878593          	addi	a1,a5,168
    80200c14:	95c2                	add	a1,a1,a6
	disk.desc[idx[0]].addr = (uint64)buf0;
    80200c16:	e30c                	sd	a1,0(a4)
	disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80200c18:	6298                	ld	a4,0(a3)
    80200c1a:	9732                	add	a4,a4,a2
    80200c1c:	45c1                	li	a1,16
    80200c1e:	c70c                	sw	a1,8(a4)
	disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80200c20:	6298                	ld	a4,0(a3)
    80200c22:	9732                	add	a4,a4,a2
    80200c24:	4585                	li	a1,1
    80200c26:	00b71623          	sh	a1,12(a4)
	disk.desc[idx[0]].next = idx[1];
    80200c2a:	fa442703          	lw	a4,-92(s0)
    80200c2e:	628c                	ld	a1,0(a3)
    80200c30:	962e                	add	a2,a2,a1
    80200c32:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <e_bss+0xffffffff7ece000e>
	disk.desc[idx[1]].addr = (uint64)b->data;
    80200c36:	0712                	slli	a4,a4,0x4
    80200c38:	6290                	ld	a2,0(a3)
    80200c3a:	963a                	add	a2,a2,a4
    80200c3c:	02890593          	addi	a1,s2,40
    80200c40:	e20c                	sd	a1,0(a2)
	disk.desc[idx[1]].len = BSIZE;
    80200c42:	6294                	ld	a3,0(a3)
    80200c44:	96ba                	add	a3,a3,a4
    80200c46:	40000613          	li	a2,1024
    80200c4a:	c690                	sw	a2,8(a3)
	if (write)
    80200c4c:	e60c15e3          	bnez	s8,80200ab6 <virtio_disk_rw+0xc8>
		disk.desc[idx[1]].flags =
    80200c50:	0001c697          	auipc	a3,0x1c
    80200c54:	3b068693          	addi	a3,a3,944 # 8021d000 <disk+0x2000>
    80200c58:	6294                	ld	a3,0(a3)
    80200c5a:	96ba                	add	a3,a3,a4
    80200c5c:	4609                	li	a2,2
    80200c5e:	00c69623          	sh	a2,12(a3)
    80200c62:	b595                	j	80200ac6 <virtio_disk_rw+0xd8>
			disk.free[i] = 0;
    80200c64:	00098c23          	sb	zero,24(s3)
		idx[i] = alloc_desc();
    80200c68:	00072023          	sw	zero,0(a4)
		if (idx[i] < 0) {
    80200c6c:	bbc9                	j	80200a3e <virtio_disk_rw+0x50>

0000000080200c6e <virtio_disk_intr>:
	// we've seen this interrupt, which the following line does.
	// this may race with the device writing new entries to
	// the "used" ring, in which case we may process the new
	// completion entries in this interrupt, and have nothing to do
	// in the next interrupt, which is harmless.
	*R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80200c6e:	10001737          	lui	a4,0x10001
    80200c72:	533c                	lw	a5,96(a4)
    80200c74:	8b8d                	andi	a5,a5,3
    80200c76:	d37c                	sw	a5,100(a4)

	__sync_synchronize();
    80200c78:	0ff0000f          	fence

	// the device increments disk.used->idx when it
	// adds an entry to the used ring.

	while (disk.used_idx != disk.used->idx) {
    80200c7c:	0001c797          	auipc	a5,0x1c
    80200c80:	38478793          	addi	a5,a5,900 # 8021d000 <disk+0x2000>
    80200c84:	6b94                	ld	a3,16(a5)
    80200c86:	0207d703          	lhu	a4,32(a5)
    80200c8a:	0026d783          	lhu	a5,2(a3)
    80200c8e:	04f70d63          	beq	a4,a5,80200ce8 <virtio_disk_intr+0x7a>
		__sync_synchronize();
		int id = disk.used->ring[disk.used_idx % NUM].id;
    80200c92:	0001a617          	auipc	a2,0x1a
    80200c96:	36e60613          	addi	a2,a2,878 # 8021b000 <disk>
    80200c9a:	0001c697          	auipc	a3,0x1c
    80200c9e:	36668693          	addi	a3,a3,870 # 8021d000 <disk+0x2000>
		__sync_synchronize();
    80200ca2:	0ff0000f          	fence
		int id = disk.used->ring[disk.used_idx % NUM].id;
    80200ca6:	6a98                	ld	a4,16(a3)
    80200ca8:	0206d783          	lhu	a5,32(a3)
    80200cac:	8b9d                	andi	a5,a5,7
    80200cae:	078e                	slli	a5,a5,0x3
    80200cb0:	97ba                	add	a5,a5,a4
    80200cb2:	43dc                	lw	a5,4(a5)

		if (disk.info[id].status != 0)
    80200cb4:	20078713          	addi	a4,a5,512
    80200cb8:	0712                	slli	a4,a4,0x4
    80200cba:	9732                	add	a4,a4,a2
    80200cbc:	03074703          	lbu	a4,48(a4) # 10001030 <BASE_ADDRESS-0x701fefd0>
    80200cc0:	e70d                	bnez	a4,80200cea <virtio_disk_intr+0x7c>
			panic("virtio_disk_intr status");

		struct buf *b = disk.info[id].b;
    80200cc2:	20078793          	addi	a5,a5,512
    80200cc6:	0792                	slli	a5,a5,0x4
    80200cc8:	97b2                	add	a5,a5,a2
    80200cca:	779c                	ld	a5,40(a5)
		b->disk = 0; // disk is done with buf
    80200ccc:	0007a223          	sw	zero,4(a5)
		disk.used_idx += 1;
    80200cd0:	0206d783          	lhu	a5,32(a3)
    80200cd4:	2785                	addiw	a5,a5,1
    80200cd6:	17c2                	slli	a5,a5,0x30
    80200cd8:	93c1                	srli	a5,a5,0x30
    80200cda:	02f69023          	sh	a5,32(a3)
	while (disk.used_idx != disk.used->idx) {
    80200cde:	6a98                	ld	a4,16(a3)
    80200ce0:	00275703          	lhu	a4,2(a4)
    80200ce4:	faf71fe3          	bne	a4,a5,80200ca2 <virtio_disk_intr+0x34>
    80200ce8:	8082                	ret
{
    80200cea:	1101                	addi	sp,sp,-32
    80200cec:	ec06                	sd	ra,24(sp)
    80200cee:	e822                	sd	s0,16(sp)
    80200cf0:	e426                	sd	s1,8(sp)
    80200cf2:	1000                	addi	s0,sp,32
			panic("virtio_disk_intr status");
    80200cf4:	00003097          	auipc	ra,0x3
    80200cf8:	6aa080e7          	jalr	1706(ra) # 8020439e <procid>
    80200cfc:	84aa                	mv	s1,a0
    80200cfe:	00003097          	auipc	ra,0x3
    80200d02:	6ba080e7          	jalr	1722(ra) # 802043b8 <threadid>
    80200d06:	12100813          	li	a6,289
    80200d0a:	00007797          	auipc	a5,0x7
    80200d0e:	54e78793          	addi	a5,a5,1358 # 80208258 <e_text+0x258>
    80200d12:	872a                	mv	a4,a0
    80200d14:	86a6                	mv	a3,s1
    80200d16:	00007617          	auipc	a2,0x7
    80200d1a:	2fa60613          	addi	a2,a2,762 # 80208010 <e_text+0x10>
    80200d1e:	45fd                	li	a1,31
    80200d20:	00007517          	auipc	a0,0x7
    80200d24:	65050513          	addi	a0,a0,1616 # 80208370 <e_text+0x370>
    80200d28:	00002097          	auipc	ra,0x2
    80200d2c:	39e080e7          	jalr	926(ra) # 802030c6 <printf>
    80200d30:	00002097          	auipc	ra,0x2
    80200d34:	5ae080e7          	jalr	1454(ra) # 802032de <shutdown>

0000000080200d38 <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    80200d38:	1141                	addi	sp,sp,-16
    80200d3a:	e406                	sd	ra,8(sp)
    80200d3c:	e022                	sd	s0,0(sp)
    80200d3e:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200d40:	00002097          	auipc	ra,0x2
    80200d44:	56e080e7          	jalr	1390(ra) # 802032ae <console_putchar>
}
    80200d48:	60a2                	ld	ra,8(sp)
    80200d4a:	6402                	ld	s0,0(sp)
    80200d4c:	0141                	addi	sp,sp,16
    80200d4e:	8082                	ret

0000000080200d50 <console_init>:

void console_init()
{
    80200d50:	1141                	addi	sp,sp,-16
    80200d52:	e422                	sd	s0,8(sp)
    80200d54:	0800                	addi	s0,sp,16
	// DO NOTHING
}
    80200d56:	6422                	ld	s0,8(sp)
    80200d58:	0141                	addi	sp,sp,16
    80200d5a:	8082                	ret

0000000080200d5c <consgetc>:

int consgetc()
{
    80200d5c:	1141                	addi	sp,sp,-16
    80200d5e:	e406                	sd	ra,8(sp)
    80200d60:	e022                	sd	s0,0(sp)
    80200d62:	0800                	addi	s0,sp,16
	return console_getchar();
    80200d64:	00002097          	auipc	ra,0x2
    80200d68:	560080e7          	jalr	1376(ra) # 802032c4 <console_getchar>
    80200d6c:	60a2                	ld	ra,8(sp)
    80200d6e:	6402                	ld	s0,0(sp)
    80200d70:	0141                	addi	sp,sp,16
    80200d72:	8082                	ret

0000000080200d74 <clean_bss>:
#include "timer.h"
#include "trap.h"
#include "virtio.h"

void clean_bss()
{
    80200d74:	1141                	addi	sp,sp,-16
    80200d76:	e406                	sd	ra,8(sp)
    80200d78:	e022                	sd	s0,0(sp)
    80200d7a:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    80200d7c:	00019517          	auipc	a0,0x19
    80200d80:	28450513          	addi	a0,a0,644 # 8021a000 <process_queue_data>
    80200d84:	0111d617          	auipc	a2,0x111d
    80200d88:	27c60613          	addi	a2,a2,636 # 8131e000 <e_bss>
    80200d8c:	9e09                	subw	a2,a2,a0
    80200d8e:	4581                	li	a1,0
    80200d90:	fffff097          	auipc	ra,0xfffff
    80200d94:	348080e7          	jalr	840(ra) # 802000d8 <memset>
}
    80200d98:	60a2                	ld	ra,8(sp)
    80200d9a:	6402                	ld	s0,0(sp)
    80200d9c:	0141                	addi	sp,sp,16
    80200d9e:	8082                	ret

0000000080200da0 <main>:

void main()
{
    80200da0:	1141                	addi	sp,sp,-16
    80200da2:	e406                	sd	ra,8(sp)
    80200da4:	e022                	sd	s0,0(sp)
    80200da6:	0800                	addi	s0,sp,16
	clean_bss();
    80200da8:	00000097          	auipc	ra,0x0
    80200dac:	fcc080e7          	jalr	-52(ra) # 80200d74 <clean_bss>
	printf("hello world!\n");
    80200db0:	00007517          	auipc	a0,0x7
    80200db4:	5f850513          	addi	a0,a0,1528 # 802083a8 <e_text+0x3a8>
    80200db8:	00002097          	auipc	ra,0x2
    80200dbc:	30e080e7          	jalr	782(ra) # 802030c6 <printf>
	proc_init();
    80200dc0:	00003097          	auipc	ra,0x3
    80200dc4:	64c080e7          	jalr	1612(ra) # 8020440c <proc_init>
	kinit();
    80200dc8:	00003097          	auipc	ra,0x3
    80200dcc:	4ec080e7          	jalr	1260(ra) # 802042b4 <kinit>
	kvm_init();
    80200dd0:	00002097          	auipc	ra,0x2
    80200dd4:	bd0080e7          	jalr	-1072(ra) # 802029a0 <kvm_init>
	trap_init();
    80200dd8:	fffff097          	auipc	ra,0xfffff
    80200ddc:	53a080e7          	jalr	1338(ra) # 80200312 <trap_init>
	plicinit();
    80200de0:	00003097          	auipc	ra,0x3
    80200de4:	532080e7          	jalr	1330(ra) # 80204312 <plicinit>
	virtio_disk_init();
    80200de8:	00000097          	auipc	ra,0x0
    80200dec:	a3e080e7          	jalr	-1474(ra) # 80200826 <virtio_disk_init>
	binit();
    80200df0:	00000097          	auipc	ra,0x0
    80200df4:	03a080e7          	jalr	58(ra) # 80200e2a <binit>
	fsinit();
    80200df8:	00005097          	auipc	ra,0x5
    80200dfc:	8fe080e7          	jalr	-1794(ra) # 802056f6 <fsinit>
	timer_init();
    80200e00:	00004097          	auipc	ra,0x4
    80200e04:	4f0080e7          	jalr	1264(ra) # 802052f0 <timer_init>
	load_init_app();
    80200e08:	00003097          	auipc	ra,0x3
    80200e0c:	302080e7          	jalr	770(ra) # 8020410a <load_init_app>
	infof("start scheduler!");
    80200e10:	4501                	li	a0,0
    80200e12:	fffff097          	auipc	ra,0xfffff
    80200e16:	49a080e7          	jalr	1178(ra) # 802002ac <dummy>
	show_all_files();
    80200e1a:	00003097          	auipc	ra,0x3
    80200e1e:	ad0080e7          	jalr	-1328(ra) # 802038ea <show_all_files>
	scheduler();
    80200e22:	00004097          	auipc	ra,0x4
    80200e26:	ba8080e7          	jalr	-1112(ra) # 802049ca <scheduler>

0000000080200e2a <binit>:
	struct buf buf[NBUF];
	struct buf head;
} bcache;

void binit()
{
    80200e2a:	1141                	addi	sp,sp,-16
    80200e2c:	e422                	sd	s0,8(sp)
    80200e2e:	0800                	addi	s0,sp,16
	struct buf *b;
	// Create linked list of buffers
	bcache.head.prev = &bcache.head;
    80200e30:	00025797          	auipc	a5,0x25
    80200e34:	1d078793          	addi	a5,a5,464 # 80226000 <bcache+0x8000>
    80200e38:	00025717          	auipc	a4,0x25
    80200e3c:	e7870713          	addi	a4,a4,-392 # 80225cb0 <bcache+0x7cb0>
    80200e40:	cce7b423          	sd	a4,-824(a5)
	bcache.head.next = &bcache.head;
    80200e44:	cce7b823          	sd	a4,-816(a5)
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80200e48:	0001d797          	auipc	a5,0x1d
    80200e4c:	1b878793          	addi	a5,a5,440 # 8021e000 <bcache>
		b->next = bcache.head.next;
    80200e50:	00025717          	auipc	a4,0x25
    80200e54:	1b070713          	addi	a4,a4,432 # 80226000 <bcache+0x8000>
		b->prev = &bcache.head;
    80200e58:	00025697          	auipc	a3,0x25
    80200e5c:	e5868693          	addi	a3,a3,-424 # 80225cb0 <bcache+0x7cb0>
		b->next = bcache.head.next;
    80200e60:	cd073603          	ld	a2,-816(a4)
    80200e64:	f390                	sd	a2,32(a5)
		b->prev = &bcache.head;
    80200e66:	ef94                	sd	a3,24(a5)
		bcache.head.next->prev = b;
    80200e68:	cd073603          	ld	a2,-816(a4)
    80200e6c:	ee1c                	sd	a5,24(a2)
		bcache.head.next = b;
    80200e6e:	ccf73823          	sd	a5,-816(a4)
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80200e72:	42878793          	addi	a5,a5,1064
    80200e76:	fed795e3          	bne	a5,a3,80200e60 <binit+0x36>
	}
}
    80200e7a:	6422                	ld	s0,8(sp)
    80200e7c:	0141                	addi	sp,sp,16
    80200e7e:	8082                	ret

0000000080200e80 <bread>:
const int R = 0;
const int W = 1;

// Return a buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno)
{
    80200e80:	1101                	addi	sp,sp,-32
    80200e82:	ec06                	sd	ra,24(sp)
    80200e84:	e822                	sd	s0,16(sp)
    80200e86:	e426                	sd	s1,8(sp)
    80200e88:	1000                	addi	s0,sp,32
	for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80200e8a:	00025797          	auipc	a5,0x25
    80200e8e:	17678793          	addi	a5,a5,374 # 80226000 <bcache+0x8000>
    80200e92:	cd07b483          	ld	s1,-816(a5)
    80200e96:	00025797          	auipc	a5,0x25
    80200e9a:	e1a78793          	addi	a5,a5,-486 # 80225cb0 <bcache+0x7cb0>
    80200e9e:	02f48863          	beq	s1,a5,80200ece <bread+0x4e>
    80200ea2:	873e                	mv	a4,a5
    80200ea4:	a021                	j	80200eac <bread+0x2c>
    80200ea6:	7084                	ld	s1,32(s1)
    80200ea8:	02e48363          	beq	s1,a4,80200ece <bread+0x4e>
		if (b->dev == dev && b->blockno == blockno) {
    80200eac:	449c                	lw	a5,8(s1)
    80200eae:	fea79ce3          	bne	a5,a0,80200ea6 <bread+0x26>
    80200eb2:	44dc                	lw	a5,12(s1)
    80200eb4:	feb799e3          	bne	a5,a1,80200ea6 <bread+0x26>
			b->refcnt++;
    80200eb8:	489c                	lw	a5,16(s1)
    80200eba:	2785                	addiw	a5,a5,1
    80200ebc:	c89c                	sw	a5,16(s1)
	struct buf *b;
	b = bget(dev, blockno);
	if (!b->valid) {
    80200ebe:	409c                	lw	a5,0(s1)
    80200ec0:	c7a1                	beqz	a5,80200f08 <bread+0x88>
		virtio_disk_rw(b, R);
		b->valid = 1;
	}
	return b;
}
    80200ec2:	8526                	mv	a0,s1
    80200ec4:	60e2                	ld	ra,24(sp)
    80200ec6:	6442                	ld	s0,16(sp)
    80200ec8:	64a2                	ld	s1,8(sp)
    80200eca:	6105                	addi	sp,sp,32
    80200ecc:	8082                	ret
	for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80200ece:	00025797          	auipc	a5,0x25
    80200ed2:	13278793          	addi	a5,a5,306 # 80226000 <bcache+0x8000>
    80200ed6:	cc87b483          	ld	s1,-824(a5)
    80200eda:	00025797          	auipc	a5,0x25
    80200ede:	dd678793          	addi	a5,a5,-554 # 80225cb0 <bcache+0x7cb0>
    80200ee2:	02f48c63          	beq	s1,a5,80200f1a <bread+0x9a>
		if (b->refcnt == 0) {
    80200ee6:	489c                	lw	a5,16(s1)
    80200ee8:	cb91                	beqz	a5,80200efc <bread+0x7c>
	for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80200eea:	00025717          	auipc	a4,0x25
    80200eee:	dc670713          	addi	a4,a4,-570 # 80225cb0 <bcache+0x7cb0>
    80200ef2:	6c84                	ld	s1,24(s1)
    80200ef4:	02e48363          	beq	s1,a4,80200f1a <bread+0x9a>
		if (b->refcnt == 0) {
    80200ef8:	489c                	lw	a5,16(s1)
    80200efa:	ffe5                	bnez	a5,80200ef2 <bread+0x72>
			b->dev = dev;
    80200efc:	c488                	sw	a0,8(s1)
			b->blockno = blockno;
    80200efe:	c4cc                	sw	a1,12(s1)
			b->valid = 0;
    80200f00:	0004a023          	sw	zero,0(s1) # 10001000 <BASE_ADDRESS-0x701ff000>
			b->refcnt = 1;
    80200f04:	4785                	li	a5,1
    80200f06:	c89c                	sw	a5,16(s1)
		virtio_disk_rw(b, R);
    80200f08:	4581                	li	a1,0
    80200f0a:	8526                	mv	a0,s1
    80200f0c:	00000097          	auipc	ra,0x0
    80200f10:	ae2080e7          	jalr	-1310(ra) # 802009ee <virtio_disk_rw>
		b->valid = 1;
    80200f14:	4785                	li	a5,1
    80200f16:	c09c                	sw	a5,0(s1)
	return b;
    80200f18:	b76d                	j	80200ec2 <bread+0x42>
	panic("bget: no buffers");
    80200f1a:	00003097          	auipc	ra,0x3
    80200f1e:	484080e7          	jalr	1156(ra) # 8020439e <procid>
    80200f22:	84aa                	mv	s1,a0
    80200f24:	00003097          	auipc	ra,0x3
    80200f28:	494080e7          	jalr	1172(ra) # 802043b8 <threadid>
    80200f2c:	04100813          	li	a6,65
    80200f30:	00007797          	auipc	a5,0x7
    80200f34:	48878793          	addi	a5,a5,1160 # 802083b8 <e_text+0x3b8>
    80200f38:	872a                	mv	a4,a0
    80200f3a:	86a6                	mv	a3,s1
    80200f3c:	00007617          	auipc	a2,0x7
    80200f40:	0d460613          	addi	a2,a2,212 # 80208010 <e_text+0x10>
    80200f44:	45fd                	li	a1,31
    80200f46:	00007517          	auipc	a0,0x7
    80200f4a:	48250513          	addi	a0,a0,1154 # 802083c8 <e_text+0x3c8>
    80200f4e:	00002097          	auipc	ra,0x2
    80200f52:	178080e7          	jalr	376(ra) # 802030c6 <printf>
    80200f56:	00002097          	auipc	ra,0x2
    80200f5a:	388080e7          	jalr	904(ra) # 802032de <shutdown>

0000000080200f5e <bwrite>:

// Write b's contents to disk.
void bwrite(struct buf *b)
{
    80200f5e:	1141                	addi	sp,sp,-16
    80200f60:	e406                	sd	ra,8(sp)
    80200f62:	e022                	sd	s0,0(sp)
    80200f64:	0800                	addi	s0,sp,16
	virtio_disk_rw(b, W);
    80200f66:	4585                	li	a1,1
    80200f68:	00000097          	auipc	ra,0x0
    80200f6c:	a86080e7          	jalr	-1402(ra) # 802009ee <virtio_disk_rw>
}
    80200f70:	60a2                	ld	ra,8(sp)
    80200f72:	6402                	ld	s0,0(sp)
    80200f74:	0141                	addi	sp,sp,16
    80200f76:	8082                	ret

0000000080200f78 <brelse>:

// Release a buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    80200f78:	1141                	addi	sp,sp,-16
    80200f7a:	e422                	sd	s0,8(sp)
    80200f7c:	0800                	addi	s0,sp,16
	b->refcnt--;
    80200f7e:	491c                	lw	a5,16(a0)
    80200f80:	37fd                	addiw	a5,a5,-1
    80200f82:	0007871b          	sext.w	a4,a5
    80200f86:	c91c                	sw	a5,16(a0)
	if (b->refcnt == 0) {
    80200f88:	eb05                	bnez	a4,80200fb8 <brelse+0x40>
		// no one is waiting for it.
		b->next->prev = b->prev;
    80200f8a:	711c                	ld	a5,32(a0)
    80200f8c:	6d18                	ld	a4,24(a0)
    80200f8e:	ef98                	sd	a4,24(a5)
		b->prev->next = b->next;
    80200f90:	6d1c                	ld	a5,24(a0)
    80200f92:	7118                	ld	a4,32(a0)
    80200f94:	f398                	sd	a4,32(a5)
		b->next = bcache.head.next;
    80200f96:	00025797          	auipc	a5,0x25
    80200f9a:	06a78793          	addi	a5,a5,106 # 80226000 <bcache+0x8000>
    80200f9e:	cd07b703          	ld	a4,-816(a5)
    80200fa2:	f118                	sd	a4,32(a0)
		b->prev = &bcache.head;
    80200fa4:	00025717          	auipc	a4,0x25
    80200fa8:	d0c70713          	addi	a4,a4,-756 # 80225cb0 <bcache+0x7cb0>
    80200fac:	ed18                	sd	a4,24(a0)
		bcache.head.next->prev = b;
    80200fae:	cd07b703          	ld	a4,-816(a5)
    80200fb2:	ef08                	sd	a0,24(a4)
		bcache.head.next = b;
    80200fb4:	cca7b823          	sd	a0,-816(a5)
	}
}
    80200fb8:	6422                	ld	s0,8(sp)
    80200fba:	0141                	addi	sp,sp,16
    80200fbc:	8082                	ret

0000000080200fbe <bpin>:

void bpin(struct buf *b)
{
    80200fbe:	1141                	addi	sp,sp,-16
    80200fc0:	e422                	sd	s0,8(sp)
    80200fc2:	0800                	addi	s0,sp,16
	b->refcnt++;
    80200fc4:	491c                	lw	a5,16(a0)
    80200fc6:	2785                	addiw	a5,a5,1
    80200fc8:	c91c                	sw	a5,16(a0)
}
    80200fca:	6422                	ld	s0,8(sp)
    80200fcc:	0141                	addi	sp,sp,16
    80200fce:	8082                	ret

0000000080200fd0 <bunpin>:

void bunpin(struct buf *b)
{
    80200fd0:	1141                	addi	sp,sp,-16
    80200fd2:	e422                	sd	s0,8(sp)
    80200fd4:	0800                	addi	s0,sp,16
	b->refcnt--;
    80200fd6:	491c                	lw	a5,16(a0)
    80200fd8:	37fd                	addiw	a5,a5,-1
    80200fda:	c91c                	sw	a5,16(a0)
}
    80200fdc:	6422                	ld	s0,8(sp)
    80200fde:	0141                	addi	sp,sp,16
    80200fe0:	8082                	ret

0000000080200fe2 <console_write>:
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

uint64 console_write(uint64 va, uint64 len)
{
    80200fe2:	710d                	addi	sp,sp,-352
    80200fe4:	ee86                	sd	ra,344(sp)
    80200fe6:	eaa2                	sd	s0,336(sp)
    80200fe8:	e6a6                	sd	s1,328(sp)
    80200fea:	e2ca                	sd	s2,320(sp)
    80200fec:	fe4e                	sd	s3,312(sp)
    80200fee:	1280                	addi	s0,sp,352
    80200ff0:	84aa                	mv	s1,a0
    80200ff2:	89ae                	mv	s3,a1
	struct proc *p = curr_proc();
    80200ff4:	00003097          	auipc	ra,0x3
    80200ff8:	3ea080e7          	jalr	1002(ra) # 802043de <curr_proc>
	char str[MAX_STR_LEN];
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
    80200ffc:	86ce                	mv	a3,s3
    80200ffe:	12c00793          	li	a5,300
    80201002:	0137f463          	bgeu	a5,s3,8020100a <console_write+0x28>
    80201006:	12c00693          	li	a3,300
    8020100a:	8626                	mv	a2,s1
    8020100c:	ea040593          	addi	a1,s0,-352
    80201010:	6508                	ld	a0,8(a0)
    80201012:	00002097          	auipc	ra,0x2
    80201016:	ea4080e7          	jalr	-348(ra) # 80202eb6 <copyinstr>
    8020101a:	892a                	mv	s2,a0
	tracef("write size = %d", size);
    8020101c:	85aa                	mv	a1,a0
    8020101e:	4501                	li	a0,0
    80201020:	fffff097          	auipc	ra,0xfffff
    80201024:	28c080e7          	jalr	652(ra) # 802002ac <dummy>
	for (int i = 0; i < size; ++i) {
    80201028:	03205463          	blez	s2,80201050 <console_write+0x6e>
    8020102c:	ea040493          	addi	s1,s0,-352
    80201030:	397d                	addiw	s2,s2,-1
    80201032:	1902                	slli	s2,s2,0x20
    80201034:	02095913          	srli	s2,s2,0x20
    80201038:	ea140793          	addi	a5,s0,-351
    8020103c:	993e                	add	s2,s2,a5
		console_putchar(str[i]);
    8020103e:	0004c503          	lbu	a0,0(s1)
    80201042:	00002097          	auipc	ra,0x2
    80201046:	26c080e7          	jalr	620(ra) # 802032ae <console_putchar>
    8020104a:	0485                	addi	s1,s1,1
	for (int i = 0; i < size; ++i) {
    8020104c:	ff2499e3          	bne	s1,s2,8020103e <console_write+0x5c>
	}
	return len;
}
    80201050:	854e                	mv	a0,s3
    80201052:	60f6                	ld	ra,344(sp)
    80201054:	6456                	ld	s0,336(sp)
    80201056:	64b6                	ld	s1,328(sp)
    80201058:	6916                	ld	s2,320(sp)
    8020105a:	79f2                	ld	s3,312(sp)
    8020105c:	6135                	addi	sp,sp,352
    8020105e:	8082                	ret

0000000080201060 <console_read>:

uint64 console_read(uint64 va, uint64 len)
{
    80201060:	7149                	addi	sp,sp,-368
    80201062:	f686                	sd	ra,360(sp)
    80201064:	f2a2                	sd	s0,352(sp)
    80201066:	eea6                	sd	s1,344(sp)
    80201068:	eaca                	sd	s2,336(sp)
    8020106a:	e6ce                	sd	s3,328(sp)
    8020106c:	e2d2                	sd	s4,320(sp)
    8020106e:	fe56                	sd	s5,312(sp)
    80201070:	1a80                	addi	s0,sp,368
    80201072:	8aaa                	mv	s5,a0
    80201074:	89ae                	mv	s3,a1
	struct proc *p = curr_proc();
    80201076:	00003097          	auipc	ra,0x3
    8020107a:	368080e7          	jalr	872(ra) # 802043de <curr_proc>
    8020107e:	8a2a                	mv	s4,a0
	char str[MAX_STR_LEN];
	tracef("read size = %d", len);
    80201080:	85ce                	mv	a1,s3
    80201082:	4501                	li	a0,0
    80201084:	fffff097          	auipc	ra,0xfffff
    80201088:	228080e7          	jalr	552(ra) # 802002ac <dummy>
	for (int i = 0; i < len; ++i) {
    8020108c:	00098f63          	beqz	s3,802010aa <console_read+0x4a>
    80201090:	e9040493          	addi	s1,s0,-368
    80201094:	01348933          	add	s2,s1,s3
		int c = consgetc();
    80201098:	00000097          	auipc	ra,0x0
    8020109c:	cc4080e7          	jalr	-828(ra) # 80200d5c <consgetc>
		str[i] = c;
    802010a0:	00a48023          	sb	a0,0(s1)
    802010a4:	0485                	addi	s1,s1,1
	for (int i = 0; i < len; ++i) {
    802010a6:	ff2499e3          	bne	s1,s2,80201098 <console_read+0x38>
	}
	copyout(p->pagetable, va, str, len);
    802010aa:	86ce                	mv	a3,s3
    802010ac:	e9040613          	addi	a2,s0,-368
    802010b0:	85d6                	mv	a1,s5
    802010b2:	008a3503          	ld	a0,8(s4)
    802010b6:	00002097          	auipc	ra,0x2
    802010ba:	ce6080e7          	jalr	-794(ra) # 80202d9c <copyout>
	return len;
}
    802010be:	854e                	mv	a0,s3
    802010c0:	70b6                	ld	ra,360(sp)
    802010c2:	7416                	ld	s0,352(sp)
    802010c4:	64f6                	ld	s1,344(sp)
    802010c6:	6956                	ld	s2,336(sp)
    802010c8:	69b6                	ld	s3,328(sp)
    802010ca:	6a16                	ld	s4,320(sp)
    802010cc:	7af2                	ld	s5,312(sp)
    802010ce:	6175                	addi	sp,sp,368
    802010d0:	8082                	ret

00000000802010d2 <sys_write>:

uint64 sys_write(int fd, uint64 va, uint64 len)
{
	if (fd < 0 || fd > FD_BUFFER_SIZE)
    802010d2:	4741                	li	a4,16
    802010d4:	10a76363          	bltu	a4,a0,802011da <sys_write+0x108>
{
    802010d8:	7179                	addi	sp,sp,-48
    802010da:	f406                	sd	ra,40(sp)
    802010dc:	f022                	sd	s0,32(sp)
    802010de:	ec26                	sd	s1,24(sp)
    802010e0:	e84a                	sd	s2,16(sp)
    802010e2:	e44e                	sd	s3,8(sp)
    802010e4:	e052                	sd	s4,0(sp)
    802010e6:	1800                	addi	s0,sp,48
    802010e8:	84aa                	mv	s1,a0
    802010ea:	8a32                	mv	s4,a2
    802010ec:	892e                	mv	s2,a1
		return -1;
	struct proc *p = curr_proc();
    802010ee:	00003097          	auipc	ra,0x3
    802010f2:	2f0080e7          	jalr	752(ra) # 802043de <curr_proc>
	struct file *f = p->files[fd];
    802010f6:	00648793          	addi	a5,s1,6
    802010fa:	078e                	slli	a5,a5,0x3
    802010fc:	97aa                	add	a5,a5,a0
    802010fe:	0007b983          	ld	s3,0(a5)
	if (f == NULL) {
    80201102:	06098163          	beqz	s3,80201164 <sys_write+0x92>
		errorf("invalid fd %d\n", fd);
		return -1;
	}
	switch (f->type) {
    80201106:	0009a783          	lw	a5,0(s3)
    8020110a:	4709                	li	a4,2
    8020110c:	0ae78f63          	beq	a5,a4,802011ca <sys_write+0xf8>
    80201110:	470d                	li	a4,3
    80201112:	08e78463          	beq	a5,a4,8020119a <sys_write+0xc8>
    80201116:	4705                	li	a4,1
    80201118:	08e78f63          	beq	a5,a4,802011b6 <sys_write+0xe4>
	case FD_PIPE:
		return pipewrite(f->pipe, va, len);
	case FD_INODE:
		return inodewrite(f, va, len);
	default:
		panic("unknown file type %d\n", f->type);
    8020111c:	00003097          	auipc	ra,0x3
    80201120:	282080e7          	jalr	642(ra) # 8020439e <procid>
    80201124:	84aa                	mv	s1,a0
    80201126:	00003097          	auipc	ra,0x3
    8020112a:	292080e7          	jalr	658(ra) # 802043b8 <threadid>
    8020112e:	0009a883          	lw	a7,0(s3)
    80201132:	03500813          	li	a6,53
    80201136:	00007797          	auipc	a5,0x7
    8020113a:	2ea78793          	addi	a5,a5,746 # 80208420 <e_text+0x420>
    8020113e:	872a                	mv	a4,a0
    80201140:	86a6                	mv	a3,s1
    80201142:	00007617          	auipc	a2,0x7
    80201146:	ece60613          	addi	a2,a2,-306 # 80208010 <e_text+0x10>
    8020114a:	45fd                	li	a1,31
    8020114c:	00007517          	auipc	a0,0x7
    80201150:	2e450513          	addi	a0,a0,740 # 80208430 <e_text+0x430>
    80201154:	00002097          	auipc	ra,0x2
    80201158:	f72080e7          	jalr	-142(ra) # 802030c6 <printf>
    8020115c:	00002097          	auipc	ra,0x2
    80201160:	182080e7          	jalr	386(ra) # 802032de <shutdown>
		errorf("invalid fd %d\n", fd);
    80201164:	00003097          	auipc	ra,0x3
    80201168:	23a080e7          	jalr	570(ra) # 8020439e <procid>
    8020116c:	892a                	mv	s2,a0
    8020116e:	00003097          	auipc	ra,0x3
    80201172:	24a080e7          	jalr	586(ra) # 802043b8 <threadid>
    80201176:	87a6                	mv	a5,s1
    80201178:	872a                	mv	a4,a0
    8020117a:	86ca                	mv	a3,s2
    8020117c:	00007617          	auipc	a2,0x7
    80201180:	f1460613          	addi	a2,a2,-236 # 80208090 <e_text+0x90>
    80201184:	45fd                	li	a1,31
    80201186:	00007517          	auipc	a0,0x7
    8020118a:	27250513          	addi	a0,a0,626 # 802083f8 <e_text+0x3f8>
    8020118e:	00002097          	auipc	ra,0x2
    80201192:	f38080e7          	jalr	-200(ra) # 802030c6 <printf>
		return -1;
    80201196:	557d                	li	a0,-1
    80201198:	a039                	j	802011a6 <sys_write+0xd4>
		return console_write(va, len);
    8020119a:	85d2                	mv	a1,s4
    8020119c:	854a                	mv	a0,s2
    8020119e:	00000097          	auipc	ra,0x0
    802011a2:	e44080e7          	jalr	-444(ra) # 80200fe2 <console_write>
	}
}
    802011a6:	70a2                	ld	ra,40(sp)
    802011a8:	7402                	ld	s0,32(sp)
    802011aa:	64e2                	ld	s1,24(sp)
    802011ac:	6942                	ld	s2,16(sp)
    802011ae:	69a2                	ld	s3,8(sp)
    802011b0:	6a02                	ld	s4,0(sp)
    802011b2:	6145                	addi	sp,sp,48
    802011b4:	8082                	ret
		return pipewrite(f->pipe, va, len);
    802011b6:	000a061b          	sext.w	a2,s4
    802011ba:	85ca                	mv	a1,s2
    802011bc:	0109b503          	ld	a0,16(s3)
    802011c0:	00003097          	auipc	ra,0x3
    802011c4:	aa2080e7          	jalr	-1374(ra) # 80203c62 <pipewrite>
    802011c8:	bff9                	j	802011a6 <sys_write+0xd4>
		return inodewrite(f, va, len);
    802011ca:	8652                	mv	a2,s4
    802011cc:	85ca                	mv	a1,s2
    802011ce:	854e                	mv	a0,s3
    802011d0:	00003097          	auipc	ra,0x3
    802011d4:	974080e7          	jalr	-1676(ra) # 80203b44 <inodewrite>
    802011d8:	b7f9                	j	802011a6 <sys_write+0xd4>
		return -1;
    802011da:	557d                	li	a0,-1
}
    802011dc:	8082                	ret

00000000802011de <sys_read>:

uint64 sys_read(int fd, uint64 va, uint64 len)
{
	if (fd < 0 || fd > FD_BUFFER_SIZE)
    802011de:	4741                	li	a4,16
    802011e0:	10a76363          	bltu	a4,a0,802012e6 <sys_read+0x108>
{
    802011e4:	7179                	addi	sp,sp,-48
    802011e6:	f406                	sd	ra,40(sp)
    802011e8:	f022                	sd	s0,32(sp)
    802011ea:	ec26                	sd	s1,24(sp)
    802011ec:	e84a                	sd	s2,16(sp)
    802011ee:	e44e                	sd	s3,8(sp)
    802011f0:	e052                	sd	s4,0(sp)
    802011f2:	1800                	addi	s0,sp,48
    802011f4:	84aa                	mv	s1,a0
    802011f6:	8a32                	mv	s4,a2
    802011f8:	892e                	mv	s2,a1
		return -1;
	struct proc *p = curr_proc();
    802011fa:	00003097          	auipc	ra,0x3
    802011fe:	1e4080e7          	jalr	484(ra) # 802043de <curr_proc>
	struct file *f = p->files[fd];
    80201202:	00648793          	addi	a5,s1,6
    80201206:	078e                	slli	a5,a5,0x3
    80201208:	97aa                	add	a5,a5,a0
    8020120a:	0007b983          	ld	s3,0(a5)
	if (f == NULL) {
    8020120e:	06098163          	beqz	s3,80201270 <sys_read+0x92>
		errorf("invalid fd %d\n", fd);
		return -1;
	}
	switch (f->type) {
    80201212:	0009a783          	lw	a5,0(s3)
    80201216:	4709                	li	a4,2
    80201218:	0ae78f63          	beq	a5,a4,802012d6 <sys_read+0xf8>
    8020121c:	470d                	li	a4,3
    8020121e:	08e78463          	beq	a5,a4,802012a6 <sys_read+0xc8>
    80201222:	4705                	li	a4,1
    80201224:	08e78f63          	beq	a5,a4,802012c2 <sys_read+0xe4>
	case FD_PIPE:
		return piperead(f->pipe, va, len);
	case FD_INODE:
		return inoderead(f, va, len);
	default:
		panic("unknown file type %d\n", f->type);
    80201228:	00003097          	auipc	ra,0x3
    8020122c:	176080e7          	jalr	374(ra) # 8020439e <procid>
    80201230:	84aa                	mv	s1,a0
    80201232:	00003097          	auipc	ra,0x3
    80201236:	186080e7          	jalr	390(ra) # 802043b8 <threadid>
    8020123a:	0009a883          	lw	a7,0(s3)
    8020123e:	04b00813          	li	a6,75
    80201242:	00007797          	auipc	a5,0x7
    80201246:	1de78793          	addi	a5,a5,478 # 80208420 <e_text+0x420>
    8020124a:	872a                	mv	a4,a0
    8020124c:	86a6                	mv	a3,s1
    8020124e:	00007617          	auipc	a2,0x7
    80201252:	dc260613          	addi	a2,a2,-574 # 80208010 <e_text+0x10>
    80201256:	45fd                	li	a1,31
    80201258:	00007517          	auipc	a0,0x7
    8020125c:	1d850513          	addi	a0,a0,472 # 80208430 <e_text+0x430>
    80201260:	00002097          	auipc	ra,0x2
    80201264:	e66080e7          	jalr	-410(ra) # 802030c6 <printf>
    80201268:	00002097          	auipc	ra,0x2
    8020126c:	076080e7          	jalr	118(ra) # 802032de <shutdown>
		errorf("invalid fd %d\n", fd);
    80201270:	00003097          	auipc	ra,0x3
    80201274:	12e080e7          	jalr	302(ra) # 8020439e <procid>
    80201278:	892a                	mv	s2,a0
    8020127a:	00003097          	auipc	ra,0x3
    8020127e:	13e080e7          	jalr	318(ra) # 802043b8 <threadid>
    80201282:	87a6                	mv	a5,s1
    80201284:	872a                	mv	a4,a0
    80201286:	86ca                	mv	a3,s2
    80201288:	00007617          	auipc	a2,0x7
    8020128c:	e0860613          	addi	a2,a2,-504 # 80208090 <e_text+0x90>
    80201290:	45fd                	li	a1,31
    80201292:	00007517          	auipc	a0,0x7
    80201296:	16650513          	addi	a0,a0,358 # 802083f8 <e_text+0x3f8>
    8020129a:	00002097          	auipc	ra,0x2
    8020129e:	e2c080e7          	jalr	-468(ra) # 802030c6 <printf>
		return -1;
    802012a2:	557d                	li	a0,-1
    802012a4:	a039                	j	802012b2 <sys_read+0xd4>
		return console_read(va, len);
    802012a6:	85d2                	mv	a1,s4
    802012a8:	854a                	mv	a0,s2
    802012aa:	00000097          	auipc	ra,0x0
    802012ae:	db6080e7          	jalr	-586(ra) # 80201060 <console_read>
	}
}
    802012b2:	70a2                	ld	ra,40(sp)
    802012b4:	7402                	ld	s0,32(sp)
    802012b6:	64e2                	ld	s1,24(sp)
    802012b8:	6942                	ld	s2,16(sp)
    802012ba:	69a2                	ld	s3,8(sp)
    802012bc:	6a02                	ld	s4,0(sp)
    802012be:	6145                	addi	sp,sp,48
    802012c0:	8082                	ret
		return piperead(f->pipe, va, len);
    802012c2:	000a061b          	sext.w	a2,s4
    802012c6:	85ca                	mv	a1,s2
    802012c8:	0109b503          	ld	a0,16(s3)
    802012cc:	00003097          	auipc	ra,0x3
    802012d0:	af6080e7          	jalr	-1290(ra) # 80203dc2 <piperead>
    802012d4:	bff9                	j	802012b2 <sys_read+0xd4>
		return inoderead(f, va, len);
    802012d6:	8652                	mv	a2,s4
    802012d8:	85ca                	mv	a1,s2
    802012da:	854e                	mv	a0,s3
    802012dc:	00003097          	auipc	ra,0x3
    802012e0:	8b2080e7          	jalr	-1870(ra) # 80203b8e <inoderead>
    802012e4:	b7f9                	j	802012b2 <sys_read+0xd4>
		return -1;
    802012e6:	557d                	li	a0,-1
}
    802012e8:	8082                	ret

00000000802012ea <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    802012ea:	1141                	addi	sp,sp,-16
    802012ec:	e406                	sd	ra,8(sp)
    802012ee:	e022                	sd	s0,0(sp)
    802012f0:	0800                	addi	s0,sp,16
	exit(code);
    802012f2:	00004097          	auipc	ra,0x4
    802012f6:	eb2080e7          	jalr	-334(ra) # 802051a4 <exit>

00000000802012fa <sys_sched_yield>:
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
    802012fa:	1141                	addi	sp,sp,-16
    802012fc:	e406                	sd	ra,8(sp)
    802012fe:	e022                	sd	s0,0(sp)
    80201300:	0800                	addi	s0,sp,16
	yield();
    80201302:	00003097          	auipc	ra,0x3
    80201306:	7f2080e7          	jalr	2034(ra) # 80204af4 <yield>
	return 0;
}
    8020130a:	4501                	li	a0,0
    8020130c:	60a2                	ld	ra,8(sp)
    8020130e:	6402                	ld	s0,0(sp)
    80201310:	0141                	addi	sp,sp,16
    80201312:	8082                	ret

0000000080201314 <sys_gettimeofday>:

uint64 sys_gettimeofday(uint64 val, int _tz)
{
    80201314:	7179                	addi	sp,sp,-48
    80201316:	f406                	sd	ra,40(sp)
    80201318:	f022                	sd	s0,32(sp)
    8020131a:	ec26                	sd	s1,24(sp)
    8020131c:	e84a                	sd	s2,16(sp)
    8020131e:	1800                	addi	s0,sp,48
    80201320:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    80201322:	00003097          	auipc	ra,0x3
    80201326:	0bc080e7          	jalr	188(ra) # 802043de <curr_proc>
    8020132a:	84aa                	mv	s1,a0
	uint64 cycle = get_cycle();
    8020132c:	00004097          	auipc	ra,0x4
    80201330:	f90080e7          	jalr	-112(ra) # 802052bc <get_cycle>
	TimeVal t;
	t.sec = cycle / CPU_FREQ;
    80201334:	00bec7b7          	lui	a5,0xbec
    80201338:	c2078793          	addi	a5,a5,-992 # bebc20 <BASE_ADDRESS-0x7f6143e0>
    8020133c:	02f55733          	divu	a4,a0,a5
    80201340:	fce43823          	sd	a4,-48(s0)
	t.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    80201344:	02f57533          	remu	a0,a0,a5
    80201348:	000f4737          	lui	a4,0xf4
    8020134c:	24070713          	addi	a4,a4,576 # f4240 <BASE_ADDRESS-0x8010bdc0>
    80201350:	02e50533          	mul	a0,a0,a4
    80201354:	02f55533          	divu	a0,a0,a5
    80201358:	fca43c23          	sd	a0,-40(s0)
	copyout(p->pagetable, val, (char *)&t, sizeof(TimeVal));
    8020135c:	46c1                	li	a3,16
    8020135e:	fd040613          	addi	a2,s0,-48
    80201362:	85ca                	mv	a1,s2
    80201364:	6488                	ld	a0,8(s1)
    80201366:	00002097          	auipc	ra,0x2
    8020136a:	a36080e7          	jalr	-1482(ra) # 80202d9c <copyout>
	return 0;
}
    8020136e:	4501                	li	a0,0
    80201370:	70a2                	ld	ra,40(sp)
    80201372:	7402                	ld	s0,32(sp)
    80201374:	64e2                	ld	s1,24(sp)
    80201376:	6942                	ld	s2,16(sp)
    80201378:	6145                	addi	sp,sp,48
    8020137a:	8082                	ret

000000008020137c <sys_getpid>:

uint64 sys_getpid()
{
    8020137c:	1141                	addi	sp,sp,-16
    8020137e:	e406                	sd	ra,8(sp)
    80201380:	e022                	sd	s0,0(sp)
    80201382:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
    80201384:	00003097          	auipc	ra,0x3
    80201388:	05a080e7          	jalr	90(ra) # 802043de <curr_proc>
}
    8020138c:	4148                	lw	a0,4(a0)
    8020138e:	60a2                	ld	ra,8(sp)
    80201390:	6402                	ld	s0,0(sp)
    80201392:	0141                	addi	sp,sp,16
    80201394:	8082                	ret

0000000080201396 <sys_getppid>:

uint64 sys_getppid()
{
    80201396:	1141                	addi	sp,sp,-16
    80201398:	e406                	sd	ra,8(sp)
    8020139a:	e022                	sd	s0,0(sp)
    8020139c:	0800                	addi	s0,sp,16
	struct proc *p = curr_proc();
    8020139e:	00003097          	auipc	ra,0x3
    802013a2:	040080e7          	jalr	64(ra) # 802043de <curr_proc>
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
    802013a6:	711c                	ld	a5,32(a0)
    802013a8:	4501                	li	a0,0
    802013aa:	c391                	beqz	a5,802013ae <sys_getppid+0x18>
    802013ac:	43c8                	lw	a0,4(a5)
}
    802013ae:	60a2                	ld	ra,8(sp)
    802013b0:	6402                	ld	s0,0(sp)
    802013b2:	0141                	addi	sp,sp,16
    802013b4:	8082                	ret

00000000802013b6 <sys_clone>:

uint64 sys_clone()
{
    802013b6:	1141                	addi	sp,sp,-16
    802013b8:	e406                	sd	ra,8(sp)
    802013ba:	e022                	sd	s0,0(sp)
    802013bc:	0800                	addi	s0,sp,16
	debugf("fork!");
    802013be:	4501                	li	a0,0
    802013c0:	fffff097          	auipc	ra,0xfffff
    802013c4:	eec080e7          	jalr	-276(ra) # 802002ac <dummy>
	return fork();
    802013c8:	00004097          	auipc	ra,0x4
    802013cc:	88c080e7          	jalr	-1908(ra) # 80204c54 <fork>
}
    802013d0:	60a2                	ld	ra,8(sp)
    802013d2:	6402                	ld	s0,0(sp)
    802013d4:	0141                	addi	sp,sp,16
    802013d6:	8082                	ret

00000000802013d8 <sys_exec>:
	uint64 *addr = (uint64 *)useraddr(pagetable, va);
	return *addr;
}

uint64 sys_exec(uint64 path, uint64 uargv)
{
    802013d8:	d9010113          	addi	sp,sp,-624 # 80219d90 <boot_stack+0xfd90>
    802013dc:	26113423          	sd	ra,616(sp)
    802013e0:	26813023          	sd	s0,608(sp)
    802013e4:	24913c23          	sd	s1,600(sp)
    802013e8:	25213823          	sd	s2,592(sp)
    802013ec:	25313423          	sd	s3,584(sp)
    802013f0:	25413023          	sd	s4,576(sp)
    802013f4:	23513c23          	sd	s5,568(sp)
    802013f8:	1c80                	addi	s0,sp,624
    802013fa:	84aa                	mv	s1,a0
    802013fc:	8aae                	mv	s5,a1
	struct proc *p = curr_proc();
    802013fe:	00003097          	auipc	ra,0x3
    80201402:	fe0080e7          	jalr	-32(ra) # 802043de <curr_proc>
    80201406:	8a2a                	mv	s4,a0
	char name[MAX_STR_LEN];
	copyinstr(p->pagetable, name, path, MAX_STR_LEN);
    80201408:	12c00693          	li	a3,300
    8020140c:	8626                	mv	a2,s1
    8020140e:	e9040593          	addi	a1,s0,-368
    80201412:	6508                	ld	a0,8(a0)
    80201414:	00002097          	auipc	ra,0x2
    80201418:	aa2080e7          	jalr	-1374(ra) # 80202eb6 <copyinstr>
	uint64 arg;
	static char strpool[MAX_ARG_NUM][MAX_STR_LEN];
	char *argv[MAX_ARG_NUM];
	int i;
	for (i = 0; uargv && (arg = fetchaddr(p->pagetable, uargv));
    8020141c:	080a8563          	beqz	s5,802014a6 <sys_exec+0xce>
    80201420:	00025917          	auipc	s2,0x25
    80201424:	cb890913          	addi	s2,s2,-840 # 802260d8 <strpool.1656>
    80201428:	84d6                	mv	s1,s5
    8020142a:	4981                	li	s3,0
	uint64 *addr = (uint64 *)useraddr(pagetable, va);
    8020142c:	85a6                	mv	a1,s1
    8020142e:	008a3503          	ld	a0,8(s4)
    80201432:	00001097          	auipc	ra,0x1
    80201436:	344080e7          	jalr	836(ra) # 80202776 <useraddr>
	return *addr;
    8020143a:	6110                	ld	a2,0(a0)
	for (i = 0; uargv && (arg = fetchaddr(p->pagetable, uargv));
    8020143c:	c615                	beqz	a2,80201468 <sys_exec+0x90>
	     uargv += sizeof(char *), i++) {
		copyinstr(p->pagetable, (char *)strpool[i], arg, MAX_STR_LEN);
    8020143e:	12c00693          	li	a3,300
    80201442:	85ca                	mv	a1,s2
    80201444:	008a3503          	ld	a0,8(s4)
    80201448:	00002097          	auipc	ra,0x2
    8020144c:	a6e080e7          	jalr	-1426(ra) # 80202eb6 <copyinstr>
		argv[i] = (char *)strpool[i];
    80201450:	415487b3          	sub	a5,s1,s5
    80201454:	d9040713          	addi	a4,s0,-624
    80201458:	97ba                	add	a5,a5,a4
    8020145a:	0127b023          	sd	s2,0(a5)
	     uargv += sizeof(char *), i++) {
    8020145e:	04a1                	addi	s1,s1,8
    80201460:	2985                	addiw	s3,s3,1
    80201462:	12c90913          	addi	s2,s2,300
	for (i = 0; uargv && (arg = fetchaddr(p->pagetable, uargv));
    80201466:	f0f9                	bnez	s1,8020142c <sys_exec+0x54>
	}
	argv[i] = NULL;
    80201468:	098e                	slli	s3,s3,0x3
    8020146a:	fc040793          	addi	a5,s0,-64
    8020146e:	99be                	add	s3,s3,a5
    80201470:	dc09b823          	sd	zero,-560(s3)
	return exec(name, (char **)argv);
    80201474:	d9040593          	addi	a1,s0,-624
    80201478:	e9040513          	addi	a0,s0,-368
    8020147c:	00004097          	auipc	ra,0x4
    80201480:	b96080e7          	jalr	-1130(ra) # 80205012 <exec>
}
    80201484:	26813083          	ld	ra,616(sp)
    80201488:	26013403          	ld	s0,608(sp)
    8020148c:	25813483          	ld	s1,600(sp)
    80201490:	25013903          	ld	s2,592(sp)
    80201494:	24813983          	ld	s3,584(sp)
    80201498:	24013a03          	ld	s4,576(sp)
    8020149c:	23813a83          	ld	s5,568(sp)
    802014a0:	27010113          	addi	sp,sp,624
    802014a4:	8082                	ret
	for (i = 0; uargv && (arg = fetchaddr(p->pagetable, uargv));
    802014a6:	4981                	li	s3,0
    802014a8:	b7c1                	j	80201468 <sys_exec+0x90>

00000000802014aa <sys_wait>:

uint64 sys_wait(int pid, uint64 va)
{
    802014aa:	1101                	addi	sp,sp,-32
    802014ac:	ec06                	sd	ra,24(sp)
    802014ae:	e822                	sd	s0,16(sp)
    802014b0:	e426                	sd	s1,8(sp)
    802014b2:	e04a                	sd	s2,0(sp)
    802014b4:	1000                	addi	s0,sp,32
    802014b6:	84aa                	mv	s1,a0
    802014b8:	892e                	mv	s2,a1
	struct proc *p = curr_proc();
    802014ba:	00003097          	auipc	ra,0x3
    802014be:	f24080e7          	jalr	-220(ra) # 802043de <curr_proc>
	int *code = (int *)useraddr(p->pagetable, va);
    802014c2:	85ca                	mv	a1,s2
    802014c4:	6508                	ld	a0,8(a0)
    802014c6:	00001097          	auipc	ra,0x1
    802014ca:	2b0080e7          	jalr	688(ra) # 80202776 <useraddr>
	return wait(pid, code);
    802014ce:	85aa                	mv	a1,a0
    802014d0:	8526                	mv	a0,s1
    802014d2:	00004097          	auipc	ra,0x4
    802014d6:	c12080e7          	jalr	-1006(ra) # 802050e4 <wait>
}
    802014da:	60e2                	ld	ra,24(sp)
    802014dc:	6442                	ld	s0,16(sp)
    802014de:	64a2                	ld	s1,8(sp)
    802014e0:	6902                	ld	s2,0(sp)
    802014e2:	6105                	addi	sp,sp,32
    802014e4:	8082                	ret

00000000802014e6 <sys_pipe>:

uint64 sys_pipe(uint64 fdarray)
{
    802014e6:	7139                	addi	sp,sp,-64
    802014e8:	fc06                	sd	ra,56(sp)
    802014ea:	f822                	sd	s0,48(sp)
    802014ec:	f426                	sd	s1,40(sp)
    802014ee:	f04a                	sd	s2,32(sp)
    802014f0:	ec4e                	sd	s3,24(sp)
    802014f2:	e852                	sd	s4,16(sp)
    802014f4:	0080                	addi	s0,sp,64
    802014f6:	8a2a                	mv	s4,a0
	struct proc *p = curr_proc();
    802014f8:	00003097          	auipc	ra,0x3
    802014fc:	ee6080e7          	jalr	-282(ra) # 802043de <curr_proc>
    80201500:	84aa                	mv	s1,a0
	uint64 fd0, fd1;
	struct file *f0, *f1;
	if (f0 < 0 || f1 < 0) {
		return -1;
	}
	f0 = filealloc();
    80201502:	00002097          	auipc	ra,0x2
    80201506:	356080e7          	jalr	854(ra) # 80203858 <filealloc>
    8020150a:	89aa                	mv	s3,a0
	f1 = filealloc();
    8020150c:	00002097          	auipc	ra,0x2
    80201510:	34c080e7          	jalr	844(ra) # 80203858 <filealloc>
    80201514:	892a                	mv	s2,a0
	if (pipealloc(f0, f1) < 0)
    80201516:	85aa                	mv	a1,a0
    80201518:	854e                	mv	a0,s3
    8020151a:	00002097          	auipc	ra,0x2
    8020151e:	6be080e7          	jalr	1726(ra) # 80203bd8 <pipealloc>
    80201522:	06054663          	bltz	a0,8020158e <sys_pipe+0xa8>
		goto err0;
	fd0 = fdalloc(f0);
    80201526:	854e                	mv	a0,s3
    80201528:	00004097          	auipc	ra,0x4
    8020152c:	d26080e7          	jalr	-730(ra) # 8020524e <fdalloc>
    80201530:	fca43423          	sd	a0,-56(s0)
	fd1 = fdalloc(f1);
    80201534:	854a                	mv	a0,s2
    80201536:	00004097          	auipc	ra,0x4
    8020153a:	d18080e7          	jalr	-744(ra) # 8020524e <fdalloc>
    8020153e:	fca43023          	sd	a0,-64(s0)
	if (fd0 < 0 || fd1 < 0)
		goto err0;
	if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80201542:	46a1                	li	a3,8
    80201544:	fc840613          	addi	a2,s0,-56
    80201548:	85d2                	mv	a1,s4
    8020154a:	6488                	ld	a0,8(s1)
    8020154c:	00002097          	auipc	ra,0x2
    80201550:	850080e7          	jalr	-1968(ra) # 80202d9c <copyout>
    80201554:	00054f63          	bltz	a0,80201572 <sys_pipe+0x8c>
	    copyout(p->pagetable, fdarray + sizeof(uint64), (char *)&fd1,
    80201558:	46a1                	li	a3,8
    8020155a:	fc040613          	addi	a2,s0,-64
    8020155e:	008a0593          	addi	a1,s4,8
    80201562:	6488                	ld	a0,8(s1)
    80201564:	00002097          	auipc	ra,0x2
    80201568:	838080e7          	jalr	-1992(ra) # 80202d9c <copyout>
		    sizeof(fd1)) < 0) {
		goto err1;
	}
	return 0;
    8020156c:	4781                	li	a5,0
	if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8020156e:	02055b63          	bgez	a0,802015a4 <sys_pipe+0xbe>

err1:
	p->files[fd0] = 0;
    80201572:	fc843783          	ld	a5,-56(s0)
    80201576:	0799                	addi	a5,a5,6
    80201578:	078e                	slli	a5,a5,0x3
    8020157a:	97a6                	add	a5,a5,s1
    8020157c:	0007b023          	sd	zero,0(a5)
	p->files[fd1] = 0;
    80201580:	fc043783          	ld	a5,-64(s0)
    80201584:	0799                	addi	a5,a5,6
    80201586:	078e                	slli	a5,a5,0x3
    80201588:	94be                	add	s1,s1,a5
    8020158a:	0004b023          	sd	zero,0(s1)
err0:
	fileclose(f0);
    8020158e:	854e                	mv	a0,s3
    80201590:	00002097          	auipc	ra,0x2
    80201594:	1d0080e7          	jalr	464(ra) # 80203760 <fileclose>
	fileclose(f1);
    80201598:	854a                	mv	a0,s2
    8020159a:	00002097          	auipc	ra,0x2
    8020159e:	1c6080e7          	jalr	454(ra) # 80203760 <fileclose>
	return -1;
    802015a2:	57fd                	li	a5,-1
}
    802015a4:	853e                	mv	a0,a5
    802015a6:	70e2                	ld	ra,56(sp)
    802015a8:	7442                	ld	s0,48(sp)
    802015aa:	74a2                	ld	s1,40(sp)
    802015ac:	7902                	ld	s2,32(sp)
    802015ae:	69e2                	ld	s3,24(sp)
    802015b0:	6a42                	ld	s4,16(sp)
    802015b2:	6121                	addi	sp,sp,64
    802015b4:	8082                	ret

00000000802015b6 <sys_openat>:

uint64 sys_openat(uint64 va, uint64 omode, uint64 _flags)
{
    802015b6:	7151                	addi	sp,sp,-240
    802015b8:	f586                	sd	ra,232(sp)
    802015ba:	f1a2                	sd	s0,224(sp)
    802015bc:	eda6                	sd	s1,216(sp)
    802015be:	e9ca                	sd	s2,208(sp)
    802015c0:	1980                	addi	s0,sp,240
    802015c2:	892a                	mv	s2,a0
    802015c4:	84ae                	mv	s1,a1
	struct proc *p = curr_proc();
    802015c6:	00003097          	auipc	ra,0x3
    802015ca:	e18080e7          	jalr	-488(ra) # 802043de <curr_proc>
	char path[200];
	copyinstr(p->pagetable, path, va, 200);
    802015ce:	0c800693          	li	a3,200
    802015d2:	864a                	mv	a2,s2
    802015d4:	f1840593          	addi	a1,s0,-232
    802015d8:	6508                	ld	a0,8(a0)
    802015da:	00002097          	auipc	ra,0x2
    802015de:	8dc080e7          	jalr	-1828(ra) # 80202eb6 <copyinstr>
	return fileopen(path, omode);
    802015e2:	85a6                	mv	a1,s1
    802015e4:	f1840513          	addi	a0,s0,-232
    802015e8:	00002097          	auipc	ra,0x2
    802015ec:	322080e7          	jalr	802(ra) # 8020390a <fileopen>
}
    802015f0:	70ae                	ld	ra,232(sp)
    802015f2:	740e                	ld	s0,224(sp)
    802015f4:	64ee                	ld	s1,216(sp)
    802015f6:	694e                	ld	s2,208(sp)
    802015f8:	616d                	addi	sp,sp,240
    802015fa:	8082                	ret

00000000802015fc <sys_close>:

uint64 sys_close(int fd)
{
	if (fd < 0 || fd > FD_BUFFER_SIZE)
    802015fc:	4741                	li	a4,16
    802015fe:	06a76a63          	bltu	a4,a0,80201672 <sys_close+0x76>
{
    80201602:	1101                	addi	sp,sp,-32
    80201604:	ec06                	sd	ra,24(sp)
    80201606:	e822                	sd	s0,16(sp)
    80201608:	e426                	sd	s1,8(sp)
    8020160a:	e04a                	sd	s2,0(sp)
    8020160c:	1000                	addi	s0,sp,32
    8020160e:	892a                	mv	s2,a0
		return -1;
	struct proc *p = curr_proc();
    80201610:	00003097          	auipc	ra,0x3
    80201614:	dce080e7          	jalr	-562(ra) # 802043de <curr_proc>
	struct file *f = p->files[fd];
    80201618:	00391493          	slli	s1,s2,0x3
    8020161c:	94aa                	add	s1,s1,a0
    8020161e:	7888                	ld	a0,48(s1)
	if (f == NULL) {
    80201620:	cd11                	beqz	a0,8020163c <sys_close+0x40>
		errorf("invalid fd %d", fd);
		return -1;
	}
	fileclose(f);
    80201622:	00002097          	auipc	ra,0x2
    80201626:	13e080e7          	jalr	318(ra) # 80203760 <fileclose>
	p->files[fd] = 0;
    8020162a:	0204b823          	sd	zero,48(s1)
	return 0;
    8020162e:	4501                	li	a0,0
}
    80201630:	60e2                	ld	ra,24(sp)
    80201632:	6442                	ld	s0,16(sp)
    80201634:	64a2                	ld	s1,8(sp)
    80201636:	6902                	ld	s2,0(sp)
    80201638:	6105                	addi	sp,sp,32
    8020163a:	8082                	ret
		errorf("invalid fd %d", fd);
    8020163c:	00003097          	auipc	ra,0x3
    80201640:	d62080e7          	jalr	-670(ra) # 8020439e <procid>
    80201644:	84aa                	mv	s1,a0
    80201646:	00003097          	auipc	ra,0x3
    8020164a:	d72080e7          	jalr	-654(ra) # 802043b8 <threadid>
    8020164e:	87ca                	mv	a5,s2
    80201650:	872a                	mv	a4,a0
    80201652:	86a6                	mv	a3,s1
    80201654:	00007617          	auipc	a2,0x7
    80201658:	a3c60613          	addi	a2,a2,-1476 # 80208090 <e_text+0x90>
    8020165c:	45fd                	li	a1,31
    8020165e:	00007517          	auipc	a0,0x7
    80201662:	e0a50513          	addi	a0,a0,-502 # 80208468 <e_text+0x468>
    80201666:	00002097          	auipc	ra,0x2
    8020166a:	a60080e7          	jalr	-1440(ra) # 802030c6 <printf>
		return -1;
    8020166e:	557d                	li	a0,-1
    80201670:	b7c1                	j	80201630 <sys_close+0x34>
		return -1;
    80201672:	557d                	li	a0,-1
}
    80201674:	8082                	ret

0000000080201676 <sys_thread_create>:

int sys_thread_create(uint64 entry, uint64 arg)
{
    80201676:	7179                	addi	sp,sp,-48
    80201678:	f406                	sd	ra,40(sp)
    8020167a:	f022                	sd	s0,32(sp)
    8020167c:	ec26                	sd	s1,24(sp)
    8020167e:	e84a                	sd	s2,16(sp)
    80201680:	e44e                	sd	s3,8(sp)
    80201682:	1800                	addi	s0,sp,48
    80201684:	84aa                	mv	s1,a0
    80201686:	89ae                	mv	s3,a1
	struct proc *p = curr_proc();
    80201688:	00003097          	auipc	ra,0x3
    8020168c:	d56080e7          	jalr	-682(ra) # 802043de <curr_proc>
    80201690:	892a                	mv	s2,a0
	int tid = allocthread(p, entry, 1);
    80201692:	4605                	li	a2,1
    80201694:	85a6                	mv	a1,s1
    80201696:	00003097          	auipc	ra,0x3
    8020169a:	0a6080e7          	jalr	166(ra) # 8020473c <allocthread>
	if (tid < 0) {
    8020169e:	02054f63          	bltz	a0,802016dc <sys_thread_create+0x66>
    802016a2:	84aa                	mv	s1,a0
		errorf("fail to create thread");
		return -1;
	}
	struct thread *t = &p->threads[tid];
	t->trapframe->a0 = arg;
    802016a4:	050a                	slli	a0,a0,0x2
    802016a6:	009507b3          	add	a5,a0,s1
    802016aa:	0796                	slli	a5,a5,0x5
    802016ac:	97ca                	add	a5,a5,s2
    802016ae:	6bf8                	ld	a4,208(a5)
    802016b0:	07373823          	sd	s3,112(a4)
	t->state = RUNNABLE;
    802016b4:	470d                	li	a4,3
    802016b6:	0ae7a823          	sw	a4,176(a5)
	struct thread *t = &p->threads[tid];
    802016ba:	9526                	add	a0,a0,s1
    802016bc:	0516                	slli	a0,a0,0x5
    802016be:	0b050513          	addi	a0,a0,176
	add_task(t);
    802016c2:	954a                	add	a0,a0,s2
    802016c4:	00003097          	auipc	ra,0x3
    802016c8:	ef2080e7          	jalr	-270(ra) # 802045b6 <add_task>
	return tid;
}
    802016cc:	8526                	mv	a0,s1
    802016ce:	70a2                	ld	ra,40(sp)
    802016d0:	7402                	ld	s0,32(sp)
    802016d2:	64e2                	ld	s1,24(sp)
    802016d4:	6942                	ld	s2,16(sp)
    802016d6:	69a2                	ld	s3,8(sp)
    802016d8:	6145                	addi	sp,sp,48
    802016da:	8082                	ret
		errorf("fail to create thread");
    802016dc:	00003097          	auipc	ra,0x3
    802016e0:	cc2080e7          	jalr	-830(ra) # 8020439e <procid>
    802016e4:	84aa                	mv	s1,a0
    802016e6:	00003097          	auipc	ra,0x3
    802016ea:	cd2080e7          	jalr	-814(ra) # 802043b8 <threadid>
    802016ee:	872a                	mv	a4,a0
    802016f0:	86a6                	mv	a3,s1
    802016f2:	00007617          	auipc	a2,0x7
    802016f6:	99e60613          	addi	a2,a2,-1634 # 80208090 <e_text+0x90>
    802016fa:	45fd                	li	a1,31
    802016fc:	00007517          	auipc	a0,0x7
    80201700:	d9450513          	addi	a0,a0,-620 # 80208490 <e_text+0x490>
    80201704:	00002097          	auipc	ra,0x2
    80201708:	9c2080e7          	jalr	-1598(ra) # 802030c6 <printf>
		return -1;
    8020170c:	54fd                	li	s1,-1
    8020170e:	bf7d                	j	802016cc <sys_thread_create+0x56>

0000000080201710 <sys_gettid>:

int sys_gettid()
{
    80201710:	1141                	addi	sp,sp,-16
    80201712:	e406                	sd	ra,8(sp)
    80201714:	e022                	sd	s0,0(sp)
    80201716:	0800                	addi	s0,sp,16
	return curr_thread()->tid;
    80201718:	00003097          	auipc	ra,0x3
    8020171c:	cde080e7          	jalr	-802(ra) # 802043f6 <curr_thread>
}
    80201720:	4148                	lw	a0,4(a0)
    80201722:	60a2                	ld	ra,8(sp)
    80201724:	6402                	ld	s0,0(sp)
    80201726:	0141                	addi	sp,sp,16
    80201728:	8082                	ret

000000008020172a <sys_waittid>:

int sys_waittid(int tid)
{
    8020172a:	7179                	addi	sp,sp,-48
    8020172c:	f406                	sd	ra,40(sp)
    8020172e:	f022                	sd	s0,32(sp)
    80201730:	ec26                	sd	s1,24(sp)
    80201732:	e84a                	sd	s2,16(sp)
    80201734:	e44e                	sd	s3,8(sp)
    80201736:	e052                	sd	s4,0(sp)
    80201738:	1800                	addi	s0,sp,48
	if (tid < 0 || tid >= NTHREAD) {
    8020173a:	47bd                	li	a5,15
    8020173c:	06a7ee63          	bltu	a5,a0,802017b8 <sys_waittid+0x8e>
    80201740:	84aa                	mv	s1,a0
		errorf("unexpected tid %d", tid);
		return -1;
	}
	struct thread *t = &curr_proc()->threads[tid];
    80201742:	00003097          	auipc	ra,0x3
    80201746:	c9c080e7          	jalr	-868(ra) # 802043de <curr_proc>
    8020174a:	89aa                	mv	s3,a0
	if (t->state == T_UNUSED || tid == curr_thread()->tid) {
    8020174c:	00249793          	slli	a5,s1,0x2
    80201750:	97a6                	add	a5,a5,s1
    80201752:	0796                	slli	a5,a5,0x5
    80201754:	97aa                	add	a5,a5,a0
    80201756:	0b07a783          	lw	a5,176(a5)
    8020175a:	cbd1                	beqz	a5,802017ee <sys_waittid+0xc4>
    8020175c:	00003097          	auipc	ra,0x3
    80201760:	c9a080e7          	jalr	-870(ra) # 802043f6 <curr_thread>
    80201764:	415c                	lw	a5,4(a0)
    80201766:	08978663          	beq	a5,s1,802017f2 <sys_waittid+0xc8>
		return -1;
	}
	if (t->state != EXITED) {
    8020176a:	00249793          	slli	a5,s1,0x2
    8020176e:	97a6                	add	a5,a5,s1
    80201770:	0796                	slli	a5,a5,0x5
    80201772:	97ce                	add	a5,a5,s3
    80201774:	0b07a703          	lw	a4,176(a5)
    80201778:	4795                	li	a5,5
    8020177a:	06f71e63          	bne	a4,a5,802017f6 <sys_waittid+0xcc>
		return -2;
	}
	memset((void *)t->kstack, 7, KSTACK_SIZE);
    8020177e:	00249a13          	slli	s4,s1,0x2
    80201782:	009a0933          	add	s2,s4,s1
    80201786:	0916                	slli	s2,s2,0x5
    80201788:	994e                	add	s2,s2,s3
    8020178a:	6605                	lui	a2,0x1
    8020178c:	459d                	li	a1,7
    8020178e:	0c893503          	ld	a0,200(s2)
    80201792:	fffff097          	auipc	ra,0xfffff
    80201796:	946080e7          	jalr	-1722(ra) # 802000d8 <memset>
	t->tid = -1;
    8020179a:	57fd                	li	a5,-1
    8020179c:	0af92a23          	sw	a5,180(s2)
	t->state = T_UNUSED;
    802017a0:	0a092823          	sw	zero,176(s2)
	return t->exit_code;
    802017a4:	14892503          	lw	a0,328(s2)
}
    802017a8:	70a2                	ld	ra,40(sp)
    802017aa:	7402                	ld	s0,32(sp)
    802017ac:	64e2                	ld	s1,24(sp)
    802017ae:	6942                	ld	s2,16(sp)
    802017b0:	69a2                	ld	s3,8(sp)
    802017b2:	6a02                	ld	s4,0(sp)
    802017b4:	6145                	addi	sp,sp,48
    802017b6:	8082                	ret
		errorf("unexpected tid %d", tid);
    802017b8:	00003097          	auipc	ra,0x3
    802017bc:	be6080e7          	jalr	-1050(ra) # 8020439e <procid>
    802017c0:	84aa                	mv	s1,a0
    802017c2:	00003097          	auipc	ra,0x3
    802017c6:	bf6080e7          	jalr	-1034(ra) # 802043b8 <threadid>
    802017ca:	872a                	mv	a4,a0
    802017cc:	87aa                	mv	a5,a0
    802017ce:	86a6                	mv	a3,s1
    802017d0:	00007617          	auipc	a2,0x7
    802017d4:	8c060613          	addi	a2,a2,-1856 # 80208090 <e_text+0x90>
    802017d8:	45fd                	li	a1,31
    802017da:	00007517          	auipc	a0,0x7
    802017de:	ce650513          	addi	a0,a0,-794 # 802084c0 <e_text+0x4c0>
    802017e2:	00002097          	auipc	ra,0x2
    802017e6:	8e4080e7          	jalr	-1820(ra) # 802030c6 <printf>
		return -1;
    802017ea:	557d                	li	a0,-1
    802017ec:	bf75                	j	802017a8 <sys_waittid+0x7e>
		return -1;
    802017ee:	557d                	li	a0,-1
    802017f0:	bf65                	j	802017a8 <sys_waittid+0x7e>
    802017f2:	557d                	li	a0,-1
    802017f4:	bf55                	j	802017a8 <sys_waittid+0x7e>
		return -2;
    802017f6:	5579                	li	a0,-2
    802017f8:	bf45                	j	802017a8 <sys_waittid+0x7e>

00000000802017fa <satisfied>:
*				for both mutex and semaphore detect, you can also
*				use this idea or just ignore it.
*/
//Request[i,0~n-1] ≤ Work[0~n-1];
int satisfied(const int req[LOCK_POOL_SIZE], int work[LOCK_POOL_SIZE], int flag)
{
    802017fa:	1101                	addi	sp,sp,-32
    802017fc:	ec06                	sd	ra,24(sp)
    802017fe:	e822                	sd	s0,16(sp)
    80201800:	e426                	sd	s1,8(sp)
    80201802:	e04a                	sd	s2,0(sp)
    80201804:	1000                	addi	s0,sp,32
    80201806:	84aa                	mv	s1,a0
    80201808:	892e                	mv	s2,a1
	int limit;
	if(flag == 0)
    8020180a:	e239                	bnez	a2,80201850 <satisfied+0x56>
		limit = curr_proc()->next_mutex_id;
    8020180c:	00003097          	auipc	ra,0x3
    80201810:	bd2080e7          	jalr	-1070(ra) # 802043de <curr_proc>
    80201814:	6785                	lui	a5,0x1
    80201816:	953e                	add	a0,a0,a5
    80201818:	ab052783          	lw	a5,-1360(a0)
	else
		limit = curr_proc()->next_semaphore_id;
	for(int i=0;i<limit;i++)
    8020181c:	04f05a63          	blez	a5,80201870 <satisfied+0x76>
	{
		if(req[i] > work[i])
    80201820:	4094                	lw	a3,0(s1)
    80201822:	00092703          	lw	a4,0(s2)
    80201826:	04d74763          	blt	a4,a3,80201874 <satisfied+0x7a>
    8020182a:	00448513          	addi	a0,s1,4
    8020182e:	00490593          	addi	a1,s2,4
    80201832:	37fd                	addiw	a5,a5,-1
    80201834:	1782                	slli	a5,a5,0x20
    80201836:	9381                	srli	a5,a5,0x20
    80201838:	078a                	slli	a5,a5,0x2
    8020183a:	97aa                	add	a5,a5,a0
	for(int i=0;i<limit;i++)
    8020183c:	02f50363          	beq	a0,a5,80201862 <satisfied+0x68>
		if(req[i] > work[i])
    80201840:	4114                	lw	a3,0(a0)
    80201842:	4198                	lw	a4,0(a1)
    80201844:	0511                	addi	a0,a0,4
    80201846:	0591                	addi	a1,a1,4
    80201848:	fed75ae3          	bge	a4,a3,8020183c <satisfied+0x42>
			return 0;
    8020184c:	4501                	li	a0,0
    8020184e:	a819                	j	80201864 <satisfied+0x6a>
		limit = curr_proc()->next_semaphore_id;
    80201850:	00003097          	auipc	ra,0x3
    80201854:	b8e080e7          	jalr	-1138(ra) # 802043de <curr_proc>
    80201858:	6785                	lui	a5,0x1
    8020185a:	953e                	add	a0,a0,a5
    8020185c:	ab452783          	lw	a5,-1356(a0)
    80201860:	bf75                	j	8020181c <satisfied+0x22>
	}
		
	return 1;
    80201862:	4505                	li	a0,1
}
    80201864:	60e2                	ld	ra,24(sp)
    80201866:	6442                	ld	s0,16(sp)
    80201868:	64a2                	ld	s1,8(sp)
    8020186a:	6902                	ld	s2,0(sp)
    8020186c:	6105                	addi	sp,sp,32
    8020186e:	8082                	ret
	return 1;
    80201870:	4505                	li	a0,1
    80201872:	bfcd                	j	80201864 <satisfied+0x6a>
			return 0;
    80201874:	4501                	li	a0,0
    80201876:	b7fd                	j	80201864 <satisfied+0x6a>

0000000080201878 <check>:
int check(int finish[NTHREAD])
{
    80201878:	7179                	addi	sp,sp,-48
    8020187a:	f406                	sd	ra,40(sp)
    8020187c:	f022                	sd	s0,32(sp)
    8020187e:	ec26                	sd	s1,24(sp)
    80201880:	e84a                	sd	s2,16(sp)
    80201882:	e44e                	sd	s3,8(sp)
    80201884:	1800                	addi	s0,sp,48
    80201886:	892a                	mv	s2,a0
	for(int i=0;i<NTHREAD;i++)
    80201888:	4481                	li	s1,0
    8020188a:	49c1                	li	s3,16
    8020188c:	a029                	j	80201896 <check+0x1e>
    8020188e:	2485                	addiw	s1,s1,1
    80201890:	0911                	addi	s2,s2,4
    80201892:	03348263          	beq	s1,s3,802018b6 <check+0x3e>
	{
		if(curr_proc()->threads[i].state == T_UNUSED)continue;
    80201896:	00003097          	auipc	ra,0x3
    8020189a:	b48080e7          	jalr	-1208(ra) # 802043de <curr_proc>
    8020189e:	00249793          	slli	a5,s1,0x2
    802018a2:	97a6                	add	a5,a5,s1
    802018a4:	0796                	slli	a5,a5,0x5
    802018a6:	953e                	add	a0,a0,a5
    802018a8:	0b052783          	lw	a5,176(a0)
    802018ac:	d3ed                	beqz	a5,8020188e <check+0x16>
		if(finish[i] == 0)return 0;
    802018ae:	00092503          	lw	a0,0(s2)
    802018b2:	fd71                	bnez	a0,8020188e <check+0x16>
    802018b4:	a011                	j	802018b8 <check+0x40>
	}	
	return 1;
    802018b6:	4505                	li	a0,1
}
    802018b8:	70a2                	ld	ra,40(sp)
    802018ba:	7402                	ld	s0,32(sp)
    802018bc:	64e2                	ld	s1,24(sp)
    802018be:	6942                	ld	s2,16(sp)
    802018c0:	69a2                	ld	s3,8(sp)
    802018c2:	6145                	addi	sp,sp,48
    802018c4:	8082                	ret

00000000802018c6 <deadlock_detect>:

int deadlock_detect(const int available[LOCK_POOL_SIZE],
					const int allocation[NTHREAD][LOCK_POOL_SIZE],
					const int request[NTHREAD][LOCK_POOL_SIZE],
					int flag)
{
    802018c6:	7115                	addi	sp,sp,-224
    802018c8:	ed86                	sd	ra,216(sp)
    802018ca:	e9a2                	sd	s0,208(sp)
    802018cc:	e5a6                	sd	s1,200(sp)
    802018ce:	e1ca                	sd	s2,192(sp)
    802018d0:	fd4e                	sd	s3,184(sp)
    802018d2:	f952                	sd	s4,176(sp)
    802018d4:	f556                	sd	s5,168(sp)
    802018d6:	f15a                	sd	s6,160(sp)
    802018d8:	ed5e                	sd	s7,152(sp)
    802018da:	e962                	sd	s8,144(sp)
    802018dc:	e566                	sd	s9,136(sp)
    802018de:	e16a                	sd	s10,128(sp)
    802018e0:	fcee                	sd	s11,120(sp)
    802018e2:	1180                	addi	s0,sp,224
    802018e4:	84aa                	mv	s1,a0
    802018e6:	f2b43023          	sd	a1,-224(s0)
    802018ea:	8c32                	mv	s8,a2
    802018ec:	8bb6                	mv	s7,a3
	int limit;
	if(flag == 0)
    802018ee:	eeb9                	bnez	a3,8020194c <deadlock_detect+0x86>
		limit = curr_proc()->next_mutex_id;
    802018f0:	00003097          	auipc	ra,0x3
    802018f4:	aee080e7          	jalr	-1298(ra) # 802043de <curr_proc>
    802018f8:	6785                	lui	a5,0x1
    802018fa:	953e                	add	a0,a0,a5
    802018fc:	ab052d03          	lw	s10,-1360(a0)
	else
		limit = curr_proc()->next_semaphore_id;
	int work[LOCK_POOL_SIZE];
	for(int i=0;i<LOCK_POOL_SIZE;i++)
    80201900:	8526                	mv	a0,s1
    80201902:	f9040693          	addi	a3,s0,-112
{
    80201906:	f7040793          	addi	a5,s0,-144
		work[i] = available[i];
    8020190a:	4118                	lw	a4,0(a0)
    8020190c:	c398                	sw	a4,0(a5)
    8020190e:	0511                	addi	a0,a0,4
    80201910:	0791                	addi	a5,a5,4
	for(int i=0;i<LOCK_POOL_SIZE;i++)
    80201912:	fed79ce3          	bne	a5,a3,8020190a <deadlock_detect+0x44>
	int finish[NTHREAD];
	memset(finish,0,sizeof(finish));
    80201916:	04000613          	li	a2,64
    8020191a:	4581                	li	a1,0
    8020191c:	f3040513          	addi	a0,s0,-208
    80201920:	ffffe097          	auipc	ra,0xffffe
    80201924:	7b8080e7          	jalr	1976(ra) # 802000d8 <memset>
    80201928:	fffd0a9b          	addiw	s5,s10,-1
    8020192c:	1a82                	slli	s5,s5,0x20
    8020192e:	020ada93          	srli	s5,s5,0x20
    80201932:	0a8a                	slli	s5,s5,0x2
    80201934:	f7440793          	addi	a5,s0,-140
    80201938:	9abe                	add	s5,s5,a5
				found = 1;
				for(int j=0;j<limit;j++)
				{
					work[j] += allocation[i][j];
				}
				finish[i] = 1;
    8020193a:	4c85                	li	s9,1
		for(int i=0;i<NTHREAD;i++)
    8020193c:	4a41                	li	s4,16
				finish[i] = 1;
    8020193e:	f3943423          	sd	s9,-216(s0)
		for(int i=0;i<NTHREAD;i++)
    80201942:	f3040913          	addi	s2,s0,-208
{
    80201946:	4481                	li	s1,0
		int found = 0;
    80201948:	4d81                	li	s11,0
    8020194a:	a015                	j	8020196e <deadlock_detect+0xa8>
		limit = curr_proc()->next_semaphore_id;
    8020194c:	00003097          	auipc	ra,0x3
    80201950:	a92080e7          	jalr	-1390(ra) # 802043de <curr_proc>
    80201954:	6785                	lui	a5,0x1
    80201956:	953e                	add	a0,a0,a5
    80201958:	ab452d03          	lw	s10,-1356(a0)
    8020195c:	b755                	j	80201900 <deadlock_detect+0x3a>
				finish[i] = 1;
    8020195e:	019b2023          	sw	s9,0(s6)
				found = 1;
    80201962:	f2843d83          	ld	s11,-216(s0)
    80201966:	0485                	addi	s1,s1,1
    80201968:	0911                	addi	s2,s2,4
		for(int i=0;i<NTHREAD;i++)
    8020196a:	07448163          	beq	s1,s4,802019cc <deadlock_detect+0x106>
			if(curr_proc()->threads[i].state == T_UNUSED)continue;
    8020196e:	00003097          	auipc	ra,0x3
    80201972:	a70080e7          	jalr	-1424(ra) # 802043de <curr_proc>
    80201976:	0004871b          	sext.w	a4,s1
    8020197a:	00271793          	slli	a5,a4,0x2
    8020197e:	97ba                	add	a5,a5,a4
    80201980:	0796                	slli	a5,a5,0x5
    80201982:	953e                	add	a0,a0,a5
    80201984:	0b052783          	lw	a5,176(a0)
    80201988:	dff9                	beqz	a5,80201966 <deadlock_detect+0xa0>
			if(finish[i] == 0 && satisfied(request[i], work, flag))
    8020198a:	8b4a                	mv	s6,s2
    8020198c:	00092783          	lw	a5,0(s2)
    80201990:	fbf9                	bnez	a5,80201966 <deadlock_detect+0xa0>
    80201992:	00549993          	slli	s3,s1,0x5
    80201996:	865e                	mv	a2,s7
    80201998:	f7040593          	addi	a1,s0,-144
    8020199c:	013c0533          	add	a0,s8,s3
    802019a0:	00000097          	auipc	ra,0x0
    802019a4:	e5a080e7          	jalr	-422(ra) # 802017fa <satisfied>
    802019a8:	dd5d                	beqz	a0,80201966 <deadlock_detect+0xa0>
				for(int j=0;j<limit;j++)
    802019aa:	fba05ae3          	blez	s10,8020195e <deadlock_detect+0x98>
    802019ae:	f2043783          	ld	a5,-224(s0)
    802019b2:	99be                	add	s3,s3,a5
    802019b4:	f7040793          	addi	a5,s0,-144
					work[j] += allocation[i][j];
    802019b8:	4398                	lw	a4,0(a5)
    802019ba:	0009a683          	lw	a3,0(s3)
    802019be:	9f35                	addw	a4,a4,a3
    802019c0:	c398                	sw	a4,0(a5)
    802019c2:	0791                	addi	a5,a5,4
    802019c4:	0991                	addi	s3,s3,4
				for(int j=0;j<limit;j++)
    802019c6:	ff5799e3          	bne	a5,s5,802019b8 <deadlock_detect+0xf2>
    802019ca:	bf51                	j	8020195e <deadlock_detect+0x98>
			}
		}
		if(!found)
    802019cc:	f60d9be3          	bnez	s11,80201942 <deadlock_detect+0x7c>
			return check(finish);
    802019d0:	f3040513          	addi	a0,s0,-208
    802019d4:	00000097          	auipc	ra,0x0
    802019d8:	ea4080e7          	jalr	-348(ra) # 80201878 <check>
	}
	return check(finish);
}
    802019dc:	60ee                	ld	ra,216(sp)
    802019de:	644e                	ld	s0,208(sp)
    802019e0:	64ae                	ld	s1,200(sp)
    802019e2:	690e                	ld	s2,192(sp)
    802019e4:	79ea                	ld	s3,184(sp)
    802019e6:	7a4a                	ld	s4,176(sp)
    802019e8:	7aaa                	ld	s5,168(sp)
    802019ea:	7b0a                	ld	s6,160(sp)
    802019ec:	6bea                	ld	s7,152(sp)
    802019ee:	6c4a                	ld	s8,144(sp)
    802019f0:	6caa                	ld	s9,136(sp)
    802019f2:	6d0a                	ld	s10,128(sp)
    802019f4:	7de6                	ld	s11,120(sp)
    802019f6:	612d                	addi	sp,sp,224
    802019f8:	8082                	ret

00000000802019fa <sys_mutex_create>:

int sys_mutex_create(int blocking)
{
    802019fa:	1101                	addi	sp,sp,-32
    802019fc:	ec06                	sd	ra,24(sp)
    802019fe:	e822                	sd	s0,16(sp)
    80201a00:	e426                	sd	s1,8(sp)
    80201a02:	1000                	addi	s0,sp,32
	struct mutex *m = mutex_create(blocking);
    80201a04:	00002097          	auipc	ra,0x2
    80201a08:	908080e7          	jalr	-1784(ra) # 8020330c <mutex_create>
	if (m == NULL) {
    80201a0c:	c929                	beqz	a0,80201a5e <sys_mutex_create+0x64>
    80201a0e:	84aa                	mv	s1,a0
		errorf("fail to create mutex: out of resource");
		return -1;
	}
	// LAB5: (4-1) You may want to maintain some variables for detect here
	int mutex_id = m - curr_proc()->mutex_pool;
    80201a10:	00003097          	auipc	ra,0x3
    80201a14:	9ce080e7          	jalr	-1586(ra) # 802043de <curr_proc>
    80201a18:	6785                	lui	a5,0x1
    80201a1a:	ac078793          	addi	a5,a5,-1344 # ac0 <BASE_ADDRESS-0x801ff540>
    80201a1e:	953e                	add	a0,a0,a5
    80201a20:	8c89                	sub	s1,s1,a0
    80201a22:	8495                	srai	s1,s1,0x5
    80201a24:	00007797          	auipc	a5,0x7
    80201a28:	5bc78793          	addi	a5,a5,1468 # 80208fe0 <SBI_SET_TIMER+0x8>
    80201a2c:	6388                	ld	a0,0(a5)
    80201a2e:	02a484bb          	mulw	s1,s1,a0
	debugf("create mutex %d", mutex_id);
    80201a32:	85a6                	mv	a1,s1
    80201a34:	4501                	li	a0,0
    80201a36:	fffff097          	auipc	ra,0xfffff
    80201a3a:	876080e7          	jalr	-1930(ra) # 802002ac <dummy>

	curr_proc()->mutex_available[mutex_id] = 1;
    80201a3e:	00003097          	auipc	ra,0x3
    80201a42:	9a0080e7          	jalr	-1632(ra) # 802043de <curr_proc>
    80201a46:	4e048793          	addi	a5,s1,1248
    80201a4a:	078a                	slli	a5,a5,0x2
    80201a4c:	953e                	add	a0,a0,a5
    80201a4e:	4785                	li	a5,1
    80201a50:	c15c                	sw	a5,4(a0)

	return mutex_id;
}
    80201a52:	8526                	mv	a0,s1
    80201a54:	60e2                	ld	ra,24(sp)
    80201a56:	6442                	ld	s0,16(sp)
    80201a58:	64a2                	ld	s1,8(sp)
    80201a5a:	6105                	addi	sp,sp,32
    80201a5c:	8082                	ret
		errorf("fail to create mutex: out of resource");
    80201a5e:	00003097          	auipc	ra,0x3
    80201a62:	940080e7          	jalr	-1728(ra) # 8020439e <procid>
    80201a66:	84aa                	mv	s1,a0
    80201a68:	00003097          	auipc	ra,0x3
    80201a6c:	950080e7          	jalr	-1712(ra) # 802043b8 <threadid>
    80201a70:	872a                	mv	a4,a0
    80201a72:	86a6                	mv	a3,s1
    80201a74:	00006617          	auipc	a2,0x6
    80201a78:	61c60613          	addi	a2,a2,1564 # 80208090 <e_text+0x90>
    80201a7c:	45fd                	li	a1,31
    80201a7e:	00007517          	auipc	a0,0x7
    80201a82:	a6a50513          	addi	a0,a0,-1430 # 802084e8 <e_text+0x4e8>
    80201a86:	00001097          	auipc	ra,0x1
    80201a8a:	640080e7          	jalr	1600(ra) # 802030c6 <printf>
		return -1;
    80201a8e:	54fd                	li	s1,-1
    80201a90:	b7c9                	j	80201a52 <sys_mutex_create+0x58>

0000000080201a92 <sys_mutex_lock>:

int sys_mutex_lock(int mutex_id)
{
    80201a92:	7179                	addi	sp,sp,-48
    80201a94:	f406                	sd	ra,40(sp)
    80201a96:	f022                	sd	s0,32(sp)
    80201a98:	ec26                	sd	s1,24(sp)
    80201a9a:	e84a                	sd	s2,16(sp)
    80201a9c:	e44e                	sd	s3,8(sp)
    80201a9e:	e052                	sd	s4,0(sp)
    80201aa0:	1800                	addi	s0,sp,48
    80201aa2:	84aa                	mv	s1,a0
	if (mutex_id < 0 || mutex_id >= curr_proc()->next_mutex_id) {
    80201aa4:	0c054963          	bltz	a0,80201b76 <sys_mutex_lock+0xe4>
    80201aa8:	00003097          	auipc	ra,0x3
    80201aac:	936080e7          	jalr	-1738(ra) # 802043de <curr_proc>
    80201ab0:	6785                	lui	a5,0x1
    80201ab2:	953e                	add	a0,a0,a5
    80201ab4:	ab052783          	lw	a5,-1360(a0)
    80201ab8:	0af4ff63          	bgeu	s1,a5,80201b76 <sys_mutex_lock+0xe4>
		return -1;
	}
	// LAB5: (4-1) You may want to maintain some variables for detect
	//       or call your detect algorithm here

	if(curr_proc()->enable_DLD)
    80201abc:	00003097          	auipc	ra,0x3
    80201ac0:	922080e7          	jalr	-1758(ra) # 802043de <curr_proc>
    80201ac4:	6785                	lui	a5,0x1
    80201ac6:	953e                	add	a0,a0,a5
    80201ac8:	38052783          	lw	a5,896(a0)
    80201acc:	c7a5                	beqz	a5,80201b34 <sys_mutex_lock+0xa2>
	{
		curr_proc()->mutex_request[curr_thread()->tid][mutex_id]++;
    80201ace:	00003097          	auipc	ra,0x3
    80201ad2:	910080e7          	jalr	-1776(ra) # 802043de <curr_proc>
    80201ad6:	892a                	mv	s2,a0
    80201ad8:	00003097          	auipc	ra,0x3
    80201adc:	91e080e7          	jalr	-1762(ra) # 802043f6 <curr_thread>
    80201ae0:	4148                	lw	a0,4(a0)
    80201ae2:	050e                	slli	a0,a0,0x3
    80201ae4:	9526                	add	a0,a0,s1
    80201ae6:	050a                	slli	a0,a0,0x2
    80201ae8:	954a                	add	a0,a0,s2
    80201aea:	6905                	lui	s2,0x1
    80201aec:	954a                	add	a0,a0,s2
    80201aee:	5a452783          	lw	a5,1444(a0)
    80201af2:	2785                	addiw	a5,a5,1
    80201af4:	5af52223          	sw	a5,1444(a0)

		if(!deadlock_detect(curr_proc()->mutex_available,
    80201af8:	00003097          	auipc	ra,0x3
    80201afc:	8e6080e7          	jalr	-1818(ra) # 802043de <curr_proc>
    80201b00:	89aa                	mv	s3,a0
										curr_proc()->mutex_allocation,
    80201b02:	00003097          	auipc	ra,0x3
    80201b06:	8dc080e7          	jalr	-1828(ra) # 802043de <curr_proc>
    80201b0a:	8a2a                	mv	s4,a0
										curr_proc()->mutex_request, 
    80201b0c:	00003097          	auipc	ra,0x3
    80201b10:	8d2080e7          	jalr	-1838(ra) # 802043de <curr_proc>
    80201b14:	5a490613          	addi	a2,s2,1444 # 15a4 <BASE_ADDRESS-0x801fea5c>
										curr_proc()->mutex_allocation,
    80201b18:	3a490593          	addi	a1,s2,932
		if(!deadlock_detect(curr_proc()->mutex_available,
    80201b1c:	38490913          	addi	s2,s2,900
    80201b20:	4681                	li	a3,0
    80201b22:	962a                	add	a2,a2,a0
    80201b24:	95d2                	add	a1,a1,s4
    80201b26:	01298533          	add	a0,s3,s2
    80201b2a:	00000097          	auipc	ra,0x0
    80201b2e:	d9c080e7          	jalr	-612(ra) # 802018c6 <deadlock_detect>
    80201b32:	cd2d                	beqz	a0,80201bac <sys_mutex_lock+0x11a>
			curr_proc()->mutex_request[curr_thread()->tid][mutex_id]--;
			return -0xDEAD;
		}	
	}	
	// go on
	mutex_lock(&curr_proc()->mutex_pool[mutex_id]);
    80201b34:	00003097          	auipc	ra,0x3
    80201b38:	8aa080e7          	jalr	-1878(ra) # 802043de <curr_proc>
    80201b3c:	00149793          	slli	a5,s1,0x1
    80201b40:	97a6                	add	a5,a5,s1
    80201b42:	0796                	slli	a5,a5,0x5
    80201b44:	6905                	lui	s2,0x1
    80201b46:	ac090713          	addi	a4,s2,-1344 # ac0 <BASE_ADDRESS-0x801ff540>
    80201b4a:	97ba                	add	a5,a5,a4
    80201b4c:	953e                	add	a0,a0,a5
    80201b4e:	00002097          	auipc	ra,0x2
    80201b52:	848080e7          	jalr	-1976(ra) # 80203396 <mutex_lock>

	if(curr_proc()->enable_DLD)
    80201b56:	00003097          	auipc	ra,0x3
    80201b5a:	888080e7          	jalr	-1912(ra) # 802043de <curr_proc>
    80201b5e:	954a                	add	a0,a0,s2
    80201b60:	38052503          	lw	a0,896(a0)
    80201b64:	ed2d                	bnez	a0,80201bde <sys_mutex_lock+0x14c>
		curr_proc()->mutex_allocation[curr_thread()->tid][mutex_id]++;
		curr_proc()->mutex_request[curr_thread()->tid][mutex_id]--;
	}

	return 0;
}
    80201b66:	70a2                	ld	ra,40(sp)
    80201b68:	7402                	ld	s0,32(sp)
    80201b6a:	64e2                	ld	s1,24(sp)
    80201b6c:	6942                	ld	s2,16(sp)
    80201b6e:	69a2                	ld	s3,8(sp)
    80201b70:	6a02                	ld	s4,0(sp)
    80201b72:	6145                	addi	sp,sp,48
    80201b74:	8082                	ret
		errorf("Unexpected mutex id %d", mutex_id);
    80201b76:	00003097          	auipc	ra,0x3
    80201b7a:	828080e7          	jalr	-2008(ra) # 8020439e <procid>
    80201b7e:	892a                	mv	s2,a0
    80201b80:	00003097          	auipc	ra,0x3
    80201b84:	838080e7          	jalr	-1992(ra) # 802043b8 <threadid>
    80201b88:	87a6                	mv	a5,s1
    80201b8a:	872a                	mv	a4,a0
    80201b8c:	86ca                	mv	a3,s2
    80201b8e:	00006617          	auipc	a2,0x6
    80201b92:	50260613          	addi	a2,a2,1282 # 80208090 <e_text+0x90>
    80201b96:	45fd                	li	a1,31
    80201b98:	00007517          	auipc	a0,0x7
    80201b9c:	99050513          	addi	a0,a0,-1648 # 80208528 <e_text+0x528>
    80201ba0:	00001097          	auipc	ra,0x1
    80201ba4:	526080e7          	jalr	1318(ra) # 802030c6 <printf>
		return -1;
    80201ba8:	557d                	li	a0,-1
    80201baa:	bf75                	j	80201b66 <sys_mutex_lock+0xd4>
			curr_proc()->mutex_request[curr_thread()->tid][mutex_id]--;
    80201bac:	00003097          	auipc	ra,0x3
    80201bb0:	832080e7          	jalr	-1998(ra) # 802043de <curr_proc>
    80201bb4:	892a                	mv	s2,a0
    80201bb6:	00003097          	auipc	ra,0x3
    80201bba:	840080e7          	jalr	-1984(ra) # 802043f6 <curr_thread>
    80201bbe:	415c                	lw	a5,4(a0)
    80201bc0:	078e                	slli	a5,a5,0x3
    80201bc2:	97a6                	add	a5,a5,s1
    80201bc4:	078a                	slli	a5,a5,0x2
    80201bc6:	97ca                	add	a5,a5,s2
    80201bc8:	6705                	lui	a4,0x1
    80201bca:	97ba                	add	a5,a5,a4
    80201bcc:	5a47a703          	lw	a4,1444(a5) # 15a4 <BASE_ADDRESS-0x801fea5c>
    80201bd0:	377d                	addiw	a4,a4,-1
    80201bd2:	5ae7a223          	sw	a4,1444(a5)
			return -0xDEAD;
    80201bd6:	7549                	lui	a0,0xffff2
    80201bd8:	15350513          	addi	a0,a0,339 # ffffffffffff2153 <e_bss+0xffffffff7ecd4153>
    80201bdc:	b769                	j	80201b66 <sys_mutex_lock+0xd4>
		curr_proc()->mutex_available[mutex_id]--;
    80201bde:	00003097          	auipc	ra,0x3
    80201be2:	800080e7          	jalr	-2048(ra) # 802043de <curr_proc>
    80201be6:	00249793          	slli	a5,s1,0x2
    80201bea:	953e                	add	a0,a0,a5
    80201bec:	6985                	lui	s3,0x1
    80201bee:	954e                	add	a0,a0,s3
    80201bf0:	38452783          	lw	a5,900(a0)
    80201bf4:	37fd                	addiw	a5,a5,-1
    80201bf6:	38f52223          	sw	a5,900(a0)
		curr_proc()->mutex_allocation[curr_thread()->tid][mutex_id]++;
    80201bfa:	00002097          	auipc	ra,0x2
    80201bfe:	7e4080e7          	jalr	2020(ra) # 802043de <curr_proc>
    80201c02:	892a                	mv	s2,a0
    80201c04:	00002097          	auipc	ra,0x2
    80201c08:	7f2080e7          	jalr	2034(ra) # 802043f6 <curr_thread>
    80201c0c:	4148                	lw	a0,4(a0)
    80201c0e:	050e                	slli	a0,a0,0x3
    80201c10:	9526                	add	a0,a0,s1
    80201c12:	050a                	slli	a0,a0,0x2
    80201c14:	954a                	add	a0,a0,s2
    80201c16:	954e                	add	a0,a0,s3
    80201c18:	3a452783          	lw	a5,932(a0)
    80201c1c:	2785                	addiw	a5,a5,1
    80201c1e:	3af52223          	sw	a5,932(a0)
		curr_proc()->mutex_request[curr_thread()->tid][mutex_id]--;
    80201c22:	00002097          	auipc	ra,0x2
    80201c26:	7bc080e7          	jalr	1980(ra) # 802043de <curr_proc>
    80201c2a:	892a                	mv	s2,a0
    80201c2c:	00002097          	auipc	ra,0x2
    80201c30:	7ca080e7          	jalr	1994(ra) # 802043f6 <curr_thread>
    80201c34:	415c                	lw	a5,4(a0)
    80201c36:	078e                	slli	a5,a5,0x3
    80201c38:	94be                	add	s1,s1,a5
    80201c3a:	048a                	slli	s1,s1,0x2
    80201c3c:	94ca                	add	s1,s1,s2
    80201c3e:	94ce                	add	s1,s1,s3
    80201c40:	5a44a783          	lw	a5,1444(s1)
    80201c44:	37fd                	addiw	a5,a5,-1
    80201c46:	5af4a223          	sw	a5,1444(s1)
	return 0;
    80201c4a:	4501                	li	a0,0
    80201c4c:	bf29                	j	80201b66 <sys_mutex_lock+0xd4>

0000000080201c4e <sys_mutex_unlock>:

int sys_mutex_unlock(int mutex_id)
{
    80201c4e:	7179                	addi	sp,sp,-48
    80201c50:	f406                	sd	ra,40(sp)
    80201c52:	f022                	sd	s0,32(sp)
    80201c54:	ec26                	sd	s1,24(sp)
    80201c56:	e84a                	sd	s2,16(sp)
    80201c58:	e44e                	sd	s3,8(sp)
    80201c5a:	1800                	addi	s0,sp,48
    80201c5c:	84aa                	mv	s1,a0
	if (mutex_id < 0 || mutex_id >= curr_proc()->next_mutex_id) {
    80201c5e:	04054c63          	bltz	a0,80201cb6 <sys_mutex_unlock+0x68>
    80201c62:	00002097          	auipc	ra,0x2
    80201c66:	77c080e7          	jalr	1916(ra) # 802043de <curr_proc>
    80201c6a:	6785                	lui	a5,0x1
    80201c6c:	953e                	add	a0,a0,a5
    80201c6e:	ab052783          	lw	a5,-1360(a0)
    80201c72:	04f4f263          	bgeu	s1,a5,80201cb6 <sys_mutex_unlock+0x68>
		errorf("Unexpected mutex id %d", mutex_id);
		return -1;
	}
	// LAB5: (4-1) You may want to maintain some variables for detect here
	mutex_unlock(&curr_proc()->mutex_pool[mutex_id]);
    80201c76:	00002097          	auipc	ra,0x2
    80201c7a:	768080e7          	jalr	1896(ra) # 802043de <curr_proc>
    80201c7e:	00149793          	slli	a5,s1,0x1
    80201c82:	97a6                	add	a5,a5,s1
    80201c84:	0796                	slli	a5,a5,0x5
    80201c86:	6905                	lui	s2,0x1
    80201c88:	ac090713          	addi	a4,s2,-1344 # ac0 <BASE_ADDRESS-0x801ff540>
    80201c8c:	97ba                	add	a5,a5,a4
    80201c8e:	953e                	add	a0,a0,a5
    80201c90:	00001097          	auipc	ra,0x1
    80201c94:	7a0080e7          	jalr	1952(ra) # 80203430 <mutex_unlock>
	if(curr_proc()->enable_DLD)
    80201c98:	00002097          	auipc	ra,0x2
    80201c9c:	746080e7          	jalr	1862(ra) # 802043de <curr_proc>
    80201ca0:	954a                	add	a0,a0,s2
    80201ca2:	38052503          	lw	a0,896(a0)
    80201ca6:	e139                	bnez	a0,80201cec <sys_mutex_unlock+0x9e>
		curr_proc()->mutex_available[mutex_id]++;
		curr_proc()->mutex_allocation[curr_thread()->tid][mutex_id]--;
	}

	return 0;
}
    80201ca8:	70a2                	ld	ra,40(sp)
    80201caa:	7402                	ld	s0,32(sp)
    80201cac:	64e2                	ld	s1,24(sp)
    80201cae:	6942                	ld	s2,16(sp)
    80201cb0:	69a2                	ld	s3,8(sp)
    80201cb2:	6145                	addi	sp,sp,48
    80201cb4:	8082                	ret
		errorf("Unexpected mutex id %d", mutex_id);
    80201cb6:	00002097          	auipc	ra,0x2
    80201cba:	6e8080e7          	jalr	1768(ra) # 8020439e <procid>
    80201cbe:	892a                	mv	s2,a0
    80201cc0:	00002097          	auipc	ra,0x2
    80201cc4:	6f8080e7          	jalr	1784(ra) # 802043b8 <threadid>
    80201cc8:	87a6                	mv	a5,s1
    80201cca:	872a                	mv	a4,a0
    80201ccc:	86ca                	mv	a3,s2
    80201cce:	00006617          	auipc	a2,0x6
    80201cd2:	3c260613          	addi	a2,a2,962 # 80208090 <e_text+0x90>
    80201cd6:	45fd                	li	a1,31
    80201cd8:	00007517          	auipc	a0,0x7
    80201cdc:	85050513          	addi	a0,a0,-1968 # 80208528 <e_text+0x528>
    80201ce0:	00001097          	auipc	ra,0x1
    80201ce4:	3e6080e7          	jalr	998(ra) # 802030c6 <printf>
		return -1;
    80201ce8:	557d                	li	a0,-1
    80201cea:	bf7d                	j	80201ca8 <sys_mutex_unlock+0x5a>
		curr_proc()->mutex_available[mutex_id]++;
    80201cec:	00002097          	auipc	ra,0x2
    80201cf0:	6f2080e7          	jalr	1778(ra) # 802043de <curr_proc>
    80201cf4:	00249793          	slli	a5,s1,0x2
    80201cf8:	953e                	add	a0,a0,a5
    80201cfa:	6985                	lui	s3,0x1
    80201cfc:	954e                	add	a0,a0,s3
    80201cfe:	38452783          	lw	a5,900(a0)
    80201d02:	2785                	addiw	a5,a5,1
    80201d04:	38f52223          	sw	a5,900(a0)
		curr_proc()->mutex_allocation[curr_thread()->tid][mutex_id]--;
    80201d08:	00002097          	auipc	ra,0x2
    80201d0c:	6d6080e7          	jalr	1750(ra) # 802043de <curr_proc>
    80201d10:	892a                	mv	s2,a0
    80201d12:	00002097          	auipc	ra,0x2
    80201d16:	6e4080e7          	jalr	1764(ra) # 802043f6 <curr_thread>
    80201d1a:	415c                	lw	a5,4(a0)
    80201d1c:	078e                	slli	a5,a5,0x3
    80201d1e:	94be                	add	s1,s1,a5
    80201d20:	048a                	slli	s1,s1,0x2
    80201d22:	94ca                	add	s1,s1,s2
    80201d24:	94ce                	add	s1,s1,s3
    80201d26:	3a44a783          	lw	a5,932(s1)
    80201d2a:	37fd                	addiw	a5,a5,-1
    80201d2c:	3af4a223          	sw	a5,932(s1)
	return 0;
    80201d30:	4501                	li	a0,0
    80201d32:	bf9d                	j	80201ca8 <sys_mutex_unlock+0x5a>

0000000080201d34 <sys_semaphore_create>:

int sys_semaphore_create(int res_count)
{
    80201d34:	1101                	addi	sp,sp,-32
    80201d36:	ec06                	sd	ra,24(sp)
    80201d38:	e822                	sd	s0,16(sp)
    80201d3a:	e426                	sd	s1,8(sp)
    80201d3c:	e04a                	sd	s2,0(sp)
    80201d3e:	1000                	addi	s0,sp,32
    80201d40:	892a                	mv	s2,a0
	struct semaphore *s = semaphore_create(res_count);
    80201d42:	00001097          	auipc	ra,0x1
    80201d46:	75c080e7          	jalr	1884(ra) # 8020349e <semaphore_create>
	if (s == NULL) {
    80201d4a:	c931                	beqz	a0,80201d9e <sys_semaphore_create+0x6a>
    80201d4c:	84aa                	mv	s1,a0
		errorf("fail to create semaphore: out of resource");
		return -1;
	}
	// LAB5: (4-2) You may want to maintain some variables for detect here
	int sem_id = s - curr_proc()->semaphore_pool;
    80201d4e:	00002097          	auipc	ra,0x2
    80201d52:	690080e7          	jalr	1680(ra) # 802043de <curr_proc>
    80201d56:	6785                	lui	a5,0x1
    80201d58:	dc078793          	addi	a5,a5,-576 # dc0 <BASE_ADDRESS-0x801ff240>
    80201d5c:	953e                	add	a0,a0,a5
    80201d5e:	8c89                	sub	s1,s1,a0
    80201d60:	8495                	srai	s1,s1,0x5
    80201d62:	00007797          	auipc	a5,0x7
    80201d66:	27e78793          	addi	a5,a5,638 # 80208fe0 <SBI_SET_TIMER+0x8>
    80201d6a:	6388                	ld	a0,0(a5)
    80201d6c:	02a484bb          	mulw	s1,s1,a0
	debugf("create semaphore %d", sem_id);
    80201d70:	85a6                	mv	a1,s1
    80201d72:	4501                	li	a0,0
    80201d74:	ffffe097          	auipc	ra,0xffffe
    80201d78:	538080e7          	jalr	1336(ra) # 802002ac <dummy>

	curr_proc()->sem_available[sem_id] = res_count;
    80201d7c:	00002097          	auipc	ra,0x2
    80201d80:	662080e7          	jalr	1634(ra) # 802043de <curr_proc>
    80201d84:	5e848793          	addi	a5,s1,1512
    80201d88:	078a                	slli	a5,a5,0x2
    80201d8a:	953e                	add	a0,a0,a5
    80201d8c:	01252223          	sw	s2,4(a0)

	return sem_id;
}
    80201d90:	8526                	mv	a0,s1
    80201d92:	60e2                	ld	ra,24(sp)
    80201d94:	6442                	ld	s0,16(sp)
    80201d96:	64a2                	ld	s1,8(sp)
    80201d98:	6902                	ld	s2,0(sp)
    80201d9a:	6105                	addi	sp,sp,32
    80201d9c:	8082                	ret
		errorf("fail to create semaphore: out of resource");
    80201d9e:	00002097          	auipc	ra,0x2
    80201da2:	600080e7          	jalr	1536(ra) # 8020439e <procid>
    80201da6:	84aa                	mv	s1,a0
    80201da8:	00002097          	auipc	ra,0x2
    80201dac:	610080e7          	jalr	1552(ra) # 802043b8 <threadid>
    80201db0:	872a                	mv	a4,a0
    80201db2:	86a6                	mv	a3,s1
    80201db4:	00006617          	auipc	a2,0x6
    80201db8:	2dc60613          	addi	a2,a2,732 # 80208090 <e_text+0x90>
    80201dbc:	45fd                	li	a1,31
    80201dbe:	00006517          	auipc	a0,0x6
    80201dc2:	79a50513          	addi	a0,a0,1946 # 80208558 <e_text+0x558>
    80201dc6:	00001097          	auipc	ra,0x1
    80201dca:	300080e7          	jalr	768(ra) # 802030c6 <printf>
		return -1;
    80201dce:	54fd                	li	s1,-1
    80201dd0:	b7c1                	j	80201d90 <sys_semaphore_create+0x5c>

0000000080201dd2 <sys_semaphore_up>:

int sys_semaphore_up(int semaphore_id)
{
    80201dd2:	7179                	addi	sp,sp,-48
    80201dd4:	f406                	sd	ra,40(sp)
    80201dd6:	f022                	sd	s0,32(sp)
    80201dd8:	ec26                	sd	s1,24(sp)
    80201dda:	e84a                	sd	s2,16(sp)
    80201ddc:	e44e                	sd	s3,8(sp)
    80201dde:	1800                	addi	s0,sp,48
    80201de0:	84aa                	mv	s1,a0
	if (semaphore_id < 0 ||
    80201de2:	04054c63          	bltz	a0,80201e3a <sys_semaphore_up+0x68>
	    semaphore_id >= curr_proc()->next_semaphore_id) {
    80201de6:	00002097          	auipc	ra,0x2
    80201dea:	5f8080e7          	jalr	1528(ra) # 802043de <curr_proc>
    80201dee:	6785                	lui	a5,0x1
    80201df0:	953e                	add	a0,a0,a5
	if (semaphore_id < 0 ||
    80201df2:	ab452783          	lw	a5,-1356(a0)
    80201df6:	04f4f263          	bgeu	s1,a5,80201e3a <sys_semaphore_up+0x68>
		errorf("Unexpected semaphore id %d", semaphore_id);
		return -1;
	}
	// LAB5: (4-2) You may want to maintain some variables for detect here
	semaphore_up(&curr_proc()->semaphore_pool[semaphore_id]);
    80201dfa:	00002097          	auipc	ra,0x2
    80201dfe:	5e4080e7          	jalr	1508(ra) # 802043de <curr_proc>
    80201e02:	00149793          	slli	a5,s1,0x1
    80201e06:	97a6                	add	a5,a5,s1
    80201e08:	0796                	slli	a5,a5,0x5
    80201e0a:	6905                	lui	s2,0x1
    80201e0c:	dc090713          	addi	a4,s2,-576 # dc0 <BASE_ADDRESS-0x801ff240>
    80201e10:	97ba                	add	a5,a5,a4
    80201e12:	953e                	add	a0,a0,a5
    80201e14:	00001097          	auipc	ra,0x1
    80201e18:	706080e7          	jalr	1798(ra) # 8020351a <semaphore_up>
	if(curr_proc()->enable_DLD )
    80201e1c:	00002097          	auipc	ra,0x2
    80201e20:	5c2080e7          	jalr	1474(ra) # 802043de <curr_proc>
    80201e24:	954a                	add	a0,a0,s2
    80201e26:	38052503          	lw	a0,896(a0)
    80201e2a:	e139                	bnez	a0,80201e70 <sys_semaphore_up+0x9e>
	{
		curr_proc()->sem_available[semaphore_id]++;
		curr_proc()->sem_allocation[curr_thread()->tid][semaphore_id]--;
	}
	return 0;
}
    80201e2c:	70a2                	ld	ra,40(sp)
    80201e2e:	7402                	ld	s0,32(sp)
    80201e30:	64e2                	ld	s1,24(sp)
    80201e32:	6942                	ld	s2,16(sp)
    80201e34:	69a2                	ld	s3,8(sp)
    80201e36:	6145                	addi	sp,sp,48
    80201e38:	8082                	ret
		errorf("Unexpected semaphore id %d", semaphore_id);
    80201e3a:	00002097          	auipc	ra,0x2
    80201e3e:	564080e7          	jalr	1380(ra) # 8020439e <procid>
    80201e42:	892a                	mv	s2,a0
    80201e44:	00002097          	auipc	ra,0x2
    80201e48:	574080e7          	jalr	1396(ra) # 802043b8 <threadid>
    80201e4c:	87a6                	mv	a5,s1
    80201e4e:	872a                	mv	a4,a0
    80201e50:	86ca                	mv	a3,s2
    80201e52:	00006617          	auipc	a2,0x6
    80201e56:	23e60613          	addi	a2,a2,574 # 80208090 <e_text+0x90>
    80201e5a:	45fd                	li	a1,31
    80201e5c:	00006517          	auipc	a0,0x6
    80201e60:	73c50513          	addi	a0,a0,1852 # 80208598 <e_text+0x598>
    80201e64:	00001097          	auipc	ra,0x1
    80201e68:	262080e7          	jalr	610(ra) # 802030c6 <printf>
		return -1;
    80201e6c:	557d                	li	a0,-1
    80201e6e:	bf7d                	j	80201e2c <sys_semaphore_up+0x5a>
		curr_proc()->sem_available[semaphore_id]++;
    80201e70:	00002097          	auipc	ra,0x2
    80201e74:	56e080e7          	jalr	1390(ra) # 802043de <curr_proc>
    80201e78:	00249793          	slli	a5,s1,0x2
    80201e7c:	953e                	add	a0,a0,a5
    80201e7e:	6985                	lui	s3,0x1
    80201e80:	954e                	add	a0,a0,s3
    80201e82:	7a452783          	lw	a5,1956(a0)
    80201e86:	2785                	addiw	a5,a5,1
    80201e88:	7af52223          	sw	a5,1956(a0)
		curr_proc()->sem_allocation[curr_thread()->tid][semaphore_id]--;
    80201e8c:	00002097          	auipc	ra,0x2
    80201e90:	552080e7          	jalr	1362(ra) # 802043de <curr_proc>
    80201e94:	892a                	mv	s2,a0
    80201e96:	00002097          	auipc	ra,0x2
    80201e9a:	560080e7          	jalr	1376(ra) # 802043f6 <curr_thread>
    80201e9e:	415c                	lw	a5,4(a0)
    80201ea0:	078e                	slli	a5,a5,0x3
    80201ea2:	94be                	add	s1,s1,a5
    80201ea4:	048a                	slli	s1,s1,0x2
    80201ea6:	94ca                	add	s1,s1,s2
    80201ea8:	94ce                	add	s1,s1,s3
    80201eaa:	7c44a783          	lw	a5,1988(s1)
    80201eae:	37fd                	addiw	a5,a5,-1
    80201eb0:	7cf4a223          	sw	a5,1988(s1)
	return 0;
    80201eb4:	4501                	li	a0,0
    80201eb6:	bf9d                	j	80201e2c <sys_semaphore_up+0x5a>

0000000080201eb8 <sys_semaphore_down>:

int sys_semaphore_down(int semaphore_id)
{
    80201eb8:	7179                	addi	sp,sp,-48
    80201eba:	f406                	sd	ra,40(sp)
    80201ebc:	f022                	sd	s0,32(sp)
    80201ebe:	ec26                	sd	s1,24(sp)
    80201ec0:	e84a                	sd	s2,16(sp)
    80201ec2:	e44e                	sd	s3,8(sp)
    80201ec4:	e052                	sd	s4,0(sp)
    80201ec6:	1800                	addi	s0,sp,48
    80201ec8:	84aa                	mv	s1,a0
	if (semaphore_id < 0 ||
    80201eca:	0c054a63          	bltz	a0,80201f9e <sys_semaphore_down+0xe6>
	    semaphore_id >= curr_proc()->next_semaphore_id) {
    80201ece:	00002097          	auipc	ra,0x2
    80201ed2:	510080e7          	jalr	1296(ra) # 802043de <curr_proc>
    80201ed6:	6785                	lui	a5,0x1
    80201ed8:	953e                	add	a0,a0,a5
	if (semaphore_id < 0 ||
    80201eda:	ab452783          	lw	a5,-1356(a0)
    80201ede:	0cf4f063          	bgeu	s1,a5,80201f9e <sys_semaphore_down+0xe6>
		errorf("Unexpected semaphore id %d", semaphore_id);
		return -1;
	}
	// LAB5: (4-2) You may want to maintain some variables for detect
	//       or call your detect algorithm here
	if(curr_proc()->enable_DLD )
    80201ee2:	00002097          	auipc	ra,0x2
    80201ee6:	4fc080e7          	jalr	1276(ra) # 802043de <curr_proc>
    80201eea:	6785                	lui	a5,0x1
    80201eec:	953e                	add	a0,a0,a5
    80201eee:	38052783          	lw	a5,896(a0)
    80201ef2:	c7ad                	beqz	a5,80201f5c <sys_semaphore_down+0xa4>
	{
		curr_proc()->sem_request[curr_thread()->tid][semaphore_id]++;
    80201ef4:	00002097          	auipc	ra,0x2
    80201ef8:	4ea080e7          	jalr	1258(ra) # 802043de <curr_proc>
    80201efc:	892a                	mv	s2,a0
    80201efe:	00002097          	auipc	ra,0x2
    80201f02:	4f8080e7          	jalr	1272(ra) # 802043f6 <curr_thread>
    80201f06:	4148                	lw	a0,4(a0)
    80201f08:	050e                	slli	a0,a0,0x3
    80201f0a:	9526                	add	a0,a0,s1
    80201f0c:	050a                	slli	a0,a0,0x2
    80201f0e:	954a                	add	a0,a0,s2
    80201f10:	6909                	lui	s2,0x2
    80201f12:	954a                	add	a0,a0,s2
    80201f14:	9c452783          	lw	a5,-1596(a0)
    80201f18:	2785                	addiw	a5,a5,1
    80201f1a:	9cf52223          	sw	a5,-1596(a0)
		
		if(!deadlock_detect(curr_proc()->sem_available,
    80201f1e:	00002097          	auipc	ra,0x2
    80201f22:	4c0080e7          	jalr	1216(ra) # 802043de <curr_proc>
    80201f26:	89aa                	mv	s3,a0
										curr_proc()->sem_allocation,
    80201f28:	00002097          	auipc	ra,0x2
    80201f2c:	4b6080e7          	jalr	1206(ra) # 802043de <curr_proc>
    80201f30:	8a2a                	mv	s4,a0
										curr_proc()->sem_request, 
    80201f32:	00002097          	auipc	ra,0x2
    80201f36:	4ac080e7          	jalr	1196(ra) # 802043de <curr_proc>
    80201f3a:	9c490613          	addi	a2,s2,-1596 # 19c4 <BASE_ADDRESS-0x801fe63c>
										curr_proc()->sem_allocation,
    80201f3e:	6785                	lui	a5,0x1
    80201f40:	7c478593          	addi	a1,a5,1988 # 17c4 <BASE_ADDRESS-0x801fe83c>
		if(!deadlock_detect(curr_proc()->sem_available,
    80201f44:	7a478793          	addi	a5,a5,1956
    80201f48:	4685                	li	a3,1
    80201f4a:	962a                	add	a2,a2,a0
    80201f4c:	95d2                	add	a1,a1,s4
    80201f4e:	00f98533          	add	a0,s3,a5
    80201f52:	00000097          	auipc	ra,0x0
    80201f56:	974080e7          	jalr	-1676(ra) # 802018c6 <deadlock_detect>
    80201f5a:	cd2d                	beqz	a0,80201fd4 <sys_semaphore_down+0x11c>
			curr_proc()->sem_request[curr_thread()->tid][semaphore_id]--;
			return -0xDEAD;
		}
	}	
	// go on
	semaphore_down(&curr_proc()->semaphore_pool[semaphore_id]);
    80201f5c:	00002097          	auipc	ra,0x2
    80201f60:	482080e7          	jalr	1154(ra) # 802043de <curr_proc>
    80201f64:	00149793          	slli	a5,s1,0x1
    80201f68:	97a6                	add	a5,a5,s1
    80201f6a:	0796                	slli	a5,a5,0x5
    80201f6c:	6905                	lui	s2,0x1
    80201f6e:	dc090713          	addi	a4,s2,-576 # dc0 <BASE_ADDRESS-0x801ff240>
    80201f72:	97ba                	add	a5,a5,a4
    80201f74:	953e                	add	a0,a0,a5
    80201f76:	00001097          	auipc	ra,0x1
    80201f7a:	648080e7          	jalr	1608(ra) # 802035be <semaphore_down>
	if(curr_proc()->enable_DLD )
    80201f7e:	00002097          	auipc	ra,0x2
    80201f82:	460080e7          	jalr	1120(ra) # 802043de <curr_proc>
    80201f86:	954a                	add	a0,a0,s2
    80201f88:	38052503          	lw	a0,896(a0)
    80201f8c:	ed2d                	bnez	a0,80202006 <sys_semaphore_down+0x14e>
		curr_proc()->sem_allocation[curr_thread()->tid][semaphore_id]++;
		curr_proc()->sem_request[curr_thread()->tid][semaphore_id]--;
	}

	return 0;
}
    80201f8e:	70a2                	ld	ra,40(sp)
    80201f90:	7402                	ld	s0,32(sp)
    80201f92:	64e2                	ld	s1,24(sp)
    80201f94:	6942                	ld	s2,16(sp)
    80201f96:	69a2                	ld	s3,8(sp)
    80201f98:	6a02                	ld	s4,0(sp)
    80201f9a:	6145                	addi	sp,sp,48
    80201f9c:	8082                	ret
		errorf("Unexpected semaphore id %d", semaphore_id);
    80201f9e:	00002097          	auipc	ra,0x2
    80201fa2:	400080e7          	jalr	1024(ra) # 8020439e <procid>
    80201fa6:	892a                	mv	s2,a0
    80201fa8:	00002097          	auipc	ra,0x2
    80201fac:	410080e7          	jalr	1040(ra) # 802043b8 <threadid>
    80201fb0:	87a6                	mv	a5,s1
    80201fb2:	872a                	mv	a4,a0
    80201fb4:	86ca                	mv	a3,s2
    80201fb6:	00006617          	auipc	a2,0x6
    80201fba:	0da60613          	addi	a2,a2,218 # 80208090 <e_text+0x90>
    80201fbe:	45fd                	li	a1,31
    80201fc0:	00006517          	auipc	a0,0x6
    80201fc4:	5d850513          	addi	a0,a0,1496 # 80208598 <e_text+0x598>
    80201fc8:	00001097          	auipc	ra,0x1
    80201fcc:	0fe080e7          	jalr	254(ra) # 802030c6 <printf>
		return -1;
    80201fd0:	557d                	li	a0,-1
    80201fd2:	bf75                	j	80201f8e <sys_semaphore_down+0xd6>
			curr_proc()->sem_request[curr_thread()->tid][semaphore_id]--;
    80201fd4:	00002097          	auipc	ra,0x2
    80201fd8:	40a080e7          	jalr	1034(ra) # 802043de <curr_proc>
    80201fdc:	892a                	mv	s2,a0
    80201fde:	00002097          	auipc	ra,0x2
    80201fe2:	418080e7          	jalr	1048(ra) # 802043f6 <curr_thread>
    80201fe6:	415c                	lw	a5,4(a0)
    80201fe8:	078e                	slli	a5,a5,0x3
    80201fea:	97a6                	add	a5,a5,s1
    80201fec:	078a                	slli	a5,a5,0x2
    80201fee:	97ca                	add	a5,a5,s2
    80201ff0:	6709                	lui	a4,0x2
    80201ff2:	97ba                	add	a5,a5,a4
    80201ff4:	9c47a703          	lw	a4,-1596(a5)
    80201ff8:	377d                	addiw	a4,a4,-1
    80201ffa:	9ce7a223          	sw	a4,-1596(a5)
			return -0xDEAD;
    80201ffe:	7549                	lui	a0,0xffff2
    80202000:	15350513          	addi	a0,a0,339 # ffffffffffff2153 <e_bss+0xffffffff7ecd4153>
    80202004:	b769                	j	80201f8e <sys_semaphore_down+0xd6>
		curr_proc()->sem_available[semaphore_id]--;
    80202006:	00002097          	auipc	ra,0x2
    8020200a:	3d8080e7          	jalr	984(ra) # 802043de <curr_proc>
    8020200e:	00249793          	slli	a5,s1,0x2
    80202012:	953e                	add	a0,a0,a5
    80202014:	6985                	lui	s3,0x1
    80202016:	954e                	add	a0,a0,s3
    80202018:	7a452783          	lw	a5,1956(a0)
    8020201c:	37fd                	addiw	a5,a5,-1
    8020201e:	7af52223          	sw	a5,1956(a0)
		curr_proc()->sem_allocation[curr_thread()->tid][semaphore_id]++;
    80202022:	00002097          	auipc	ra,0x2
    80202026:	3bc080e7          	jalr	956(ra) # 802043de <curr_proc>
    8020202a:	892a                	mv	s2,a0
    8020202c:	00002097          	auipc	ra,0x2
    80202030:	3ca080e7          	jalr	970(ra) # 802043f6 <curr_thread>
    80202034:	4148                	lw	a0,4(a0)
    80202036:	050e                	slli	a0,a0,0x3
    80202038:	9526                	add	a0,a0,s1
    8020203a:	050a                	slli	a0,a0,0x2
    8020203c:	954a                	add	a0,a0,s2
    8020203e:	954e                	add	a0,a0,s3
    80202040:	7c452783          	lw	a5,1988(a0)
    80202044:	2785                	addiw	a5,a5,1
    80202046:	7cf52223          	sw	a5,1988(a0)
		curr_proc()->sem_request[curr_thread()->tid][semaphore_id]--;
    8020204a:	00002097          	auipc	ra,0x2
    8020204e:	394080e7          	jalr	916(ra) # 802043de <curr_proc>
    80202052:	892a                	mv	s2,a0
    80202054:	00002097          	auipc	ra,0x2
    80202058:	3a2080e7          	jalr	930(ra) # 802043f6 <curr_thread>
    8020205c:	415c                	lw	a5,4(a0)
    8020205e:	078e                	slli	a5,a5,0x3
    80202060:	94be                	add	s1,s1,a5
    80202062:	048a                	slli	s1,s1,0x2
    80202064:	94ca                	add	s1,s1,s2
    80202066:	6789                	lui	a5,0x2
    80202068:	94be                	add	s1,s1,a5
    8020206a:	9c44a783          	lw	a5,-1596(s1)
    8020206e:	37fd                	addiw	a5,a5,-1
    80202070:	9cf4a223          	sw	a5,-1596(s1)
	return 0;
    80202074:	4501                	li	a0,0
    80202076:	bf21                	j	80201f8e <sys_semaphore_down+0xd6>

0000000080202078 <sys_condvar_create>:

int sys_condvar_create()
{
    80202078:	1101                	addi	sp,sp,-32
    8020207a:	ec06                	sd	ra,24(sp)
    8020207c:	e822                	sd	s0,16(sp)
    8020207e:	e426                	sd	s1,8(sp)
    80202080:	1000                	addi	s0,sp,32
	struct condvar *c = condvar_create();
    80202082:	00001097          	auipc	ra,0x1
    80202086:	5b8080e7          	jalr	1464(ra) # 8020363a <condvar_create>
	if (c == NULL) {
    8020208a:	cd1d                	beqz	a0,802020c8 <sys_condvar_create+0x50>
    8020208c:	84aa                	mv	s1,a0
		errorf("fail to create condvar: out of resource");
		return -1;
	}
	int cond_id = c - curr_proc()->condvar_pool;
    8020208e:	00002097          	auipc	ra,0x2
    80202092:	350080e7          	jalr	848(ra) # 802043de <curr_proc>
    80202096:	6785                	lui	a5,0x1
    80202098:	0c078793          	addi	a5,a5,192 # 10c0 <BASE_ADDRESS-0x801fef40>
    8020209c:	953e                	add	a0,a0,a5
    8020209e:	8c89                	sub	s1,s1,a0
    802020a0:	848d                	srai	s1,s1,0x3
    802020a2:	00007797          	auipc	a5,0x7
    802020a6:	f4678793          	addi	a5,a5,-186 # 80208fe8 <SBI_SET_TIMER+0x10>
    802020aa:	6388                	ld	a0,0(a5)
    802020ac:	02a484bb          	mulw	s1,s1,a0
	debugf("create condvar %d", cond_id);
    802020b0:	85a6                	mv	a1,s1
    802020b2:	4501                	li	a0,0
    802020b4:	ffffe097          	auipc	ra,0xffffe
    802020b8:	1f8080e7          	jalr	504(ra) # 802002ac <dummy>
	return cond_id;
}
    802020bc:	8526                	mv	a0,s1
    802020be:	60e2                	ld	ra,24(sp)
    802020c0:	6442                	ld	s0,16(sp)
    802020c2:	64a2                	ld	s1,8(sp)
    802020c4:	6105                	addi	sp,sp,32
    802020c6:	8082                	ret
		errorf("fail to create condvar: out of resource");
    802020c8:	00002097          	auipc	ra,0x2
    802020cc:	2d6080e7          	jalr	726(ra) # 8020439e <procid>
    802020d0:	84aa                	mv	s1,a0
    802020d2:	00002097          	auipc	ra,0x2
    802020d6:	2e6080e7          	jalr	742(ra) # 802043b8 <threadid>
    802020da:	872a                	mv	a4,a0
    802020dc:	86a6                	mv	a3,s1
    802020de:	00006617          	auipc	a2,0x6
    802020e2:	fb260613          	addi	a2,a2,-78 # 80208090 <e_text+0x90>
    802020e6:	45fd                	li	a1,31
    802020e8:	00006517          	auipc	a0,0x6
    802020ec:	4e050513          	addi	a0,a0,1248 # 802085c8 <e_text+0x5c8>
    802020f0:	00001097          	auipc	ra,0x1
    802020f4:	fd6080e7          	jalr	-42(ra) # 802030c6 <printf>
		return -1;
    802020f8:	54fd                	li	s1,-1
    802020fa:	b7c9                	j	802020bc <sys_condvar_create+0x44>

00000000802020fc <sys_condvar_signal>:

int sys_condvar_signal(int cond_id)
{
    802020fc:	1101                	addi	sp,sp,-32
    802020fe:	ec06                	sd	ra,24(sp)
    80202100:	e822                	sd	s0,16(sp)
    80202102:	e426                	sd	s1,8(sp)
    80202104:	e04a                	sd	s2,0(sp)
    80202106:	1000                	addi	s0,sp,32
    80202108:	84aa                	mv	s1,a0
	if (cond_id < 0 || cond_id >= curr_proc()->next_condvar_id) {
    8020210a:	04054463          	bltz	a0,80202152 <sys_condvar_signal+0x56>
    8020210e:	00002097          	auipc	ra,0x2
    80202112:	2d0080e7          	jalr	720(ra) # 802043de <curr_proc>
    80202116:	6785                	lui	a5,0x1
    80202118:	953e                	add	a0,a0,a5
    8020211a:	ab852783          	lw	a5,-1352(a0)
    8020211e:	02f4fa63          	bgeu	s1,a5,80202152 <sys_condvar_signal+0x56>
		errorf("Unexpected condvar id %d", cond_id);
		return -1;
	}
	cond_signal(&curr_proc()->condvar_pool[cond_id]);
    80202122:	00002097          	auipc	ra,0x2
    80202126:	2bc080e7          	jalr	700(ra) # 802043de <curr_proc>
    8020212a:	05800793          	li	a5,88
    8020212e:	02f484b3          	mul	s1,s1,a5
    80202132:	6785                	lui	a5,0x1
    80202134:	0c078793          	addi	a5,a5,192 # 10c0 <BASE_ADDRESS-0x801fef40>
    80202138:	94be                	add	s1,s1,a5
    8020213a:	9526                	add	a0,a0,s1
    8020213c:	00001097          	auipc	ra,0x1
    80202140:	564080e7          	jalr	1380(ra) # 802036a0 <cond_signal>
	return 0;
    80202144:	4501                	li	a0,0
}
    80202146:	60e2                	ld	ra,24(sp)
    80202148:	6442                	ld	s0,16(sp)
    8020214a:	64a2                	ld	s1,8(sp)
    8020214c:	6902                	ld	s2,0(sp)
    8020214e:	6105                	addi	sp,sp,32
    80202150:	8082                	ret
		errorf("Unexpected condvar id %d", cond_id);
    80202152:	00002097          	auipc	ra,0x2
    80202156:	24c080e7          	jalr	588(ra) # 8020439e <procid>
    8020215a:	892a                	mv	s2,a0
    8020215c:	00002097          	auipc	ra,0x2
    80202160:	25c080e7          	jalr	604(ra) # 802043b8 <threadid>
    80202164:	87a6                	mv	a5,s1
    80202166:	872a                	mv	a4,a0
    80202168:	86ca                	mv	a3,s2
    8020216a:	00006617          	auipc	a2,0x6
    8020216e:	f2660613          	addi	a2,a2,-218 # 80208090 <e_text+0x90>
    80202172:	45fd                	li	a1,31
    80202174:	00006517          	auipc	a0,0x6
    80202178:	49450513          	addi	a0,a0,1172 # 80208608 <e_text+0x608>
    8020217c:	00001097          	auipc	ra,0x1
    80202180:	f4a080e7          	jalr	-182(ra) # 802030c6 <printf>
		return -1;
    80202184:	557d                	li	a0,-1
    80202186:	b7c1                	j	80202146 <sys_condvar_signal+0x4a>

0000000080202188 <sys_condvar_wait>:

int sys_condvar_wait(int cond_id, int mutex_id)
{
    80202188:	7179                	addi	sp,sp,-48
    8020218a:	f406                	sd	ra,40(sp)
    8020218c:	f022                	sd	s0,32(sp)
    8020218e:	ec26                	sd	s1,24(sp)
    80202190:	e84a                	sd	s2,16(sp)
    80202192:	e44e                	sd	s3,8(sp)
    80202194:	1800                	addi	s0,sp,48
    80202196:	84aa                	mv	s1,a0
	if (cond_id < 0 || cond_id >= curr_proc()->next_condvar_id) {
    80202198:	06054f63          	bltz	a0,80202216 <sys_condvar_wait+0x8e>
    8020219c:	892e                	mv	s2,a1
    8020219e:	00002097          	auipc	ra,0x2
    802021a2:	240080e7          	jalr	576(ra) # 802043de <curr_proc>
    802021a6:	6785                	lui	a5,0x1
    802021a8:	953e                	add	a0,a0,a5
    802021aa:	ab852783          	lw	a5,-1352(a0)
    802021ae:	06f4f463          	bgeu	s1,a5,80202216 <sys_condvar_wait+0x8e>
		errorf("Unexpected condvar id %d", cond_id);
		return -1;
	}
	if (mutex_id < 0 || mutex_id >= curr_proc()->next_mutex_id) {
    802021b2:	08094d63          	bltz	s2,8020224c <sys_condvar_wait+0xc4>
    802021b6:	00002097          	auipc	ra,0x2
    802021ba:	228080e7          	jalr	552(ra) # 802043de <curr_proc>
    802021be:	6785                	lui	a5,0x1
    802021c0:	953e                	add	a0,a0,a5
    802021c2:	ab052783          	lw	a5,-1360(a0)
    802021c6:	08f97363          	bgeu	s2,a5,8020224c <sys_condvar_wait+0xc4>
		errorf("Unexpected mutex id %d", mutex_id);
		return -1;
	}
	cond_wait(&curr_proc()->condvar_pool[cond_id],
    802021ca:	00002097          	auipc	ra,0x2
    802021ce:	214080e7          	jalr	532(ra) # 802043de <curr_proc>
    802021d2:	05800793          	li	a5,88
    802021d6:	02f484b3          	mul	s1,s1,a5
    802021da:	6985                	lui	s3,0x1
    802021dc:	0c098793          	addi	a5,s3,192 # 10c0 <BASE_ADDRESS-0x801fef40>
    802021e0:	94be                	add	s1,s1,a5
    802021e2:	94aa                	add	s1,s1,a0
		  &curr_proc()->mutex_pool[mutex_id]);
    802021e4:	00002097          	auipc	ra,0x2
    802021e8:	1fa080e7          	jalr	506(ra) # 802043de <curr_proc>
	cond_wait(&curr_proc()->condvar_pool[cond_id],
    802021ec:	00191593          	slli	a1,s2,0x1
    802021f0:	95ca                	add	a1,a1,s2
    802021f2:	0596                	slli	a1,a1,0x5
    802021f4:	ac098993          	addi	s3,s3,-1344
    802021f8:	95ce                	add	a1,a1,s3
    802021fa:	95aa                	add	a1,a1,a0
    802021fc:	8526                	mv	a0,s1
    802021fe:	00001097          	auipc	ra,0x1
    80202202:	4ee080e7          	jalr	1262(ra) # 802036ec <cond_wait>
	return 0;
    80202206:	4501                	li	a0,0
}
    80202208:	70a2                	ld	ra,40(sp)
    8020220a:	7402                	ld	s0,32(sp)
    8020220c:	64e2                	ld	s1,24(sp)
    8020220e:	6942                	ld	s2,16(sp)
    80202210:	69a2                	ld	s3,8(sp)
    80202212:	6145                	addi	sp,sp,48
    80202214:	8082                	ret
		errorf("Unexpected condvar id %d", cond_id);
    80202216:	00002097          	auipc	ra,0x2
    8020221a:	188080e7          	jalr	392(ra) # 8020439e <procid>
    8020221e:	892a                	mv	s2,a0
    80202220:	00002097          	auipc	ra,0x2
    80202224:	198080e7          	jalr	408(ra) # 802043b8 <threadid>
    80202228:	87a6                	mv	a5,s1
    8020222a:	872a                	mv	a4,a0
    8020222c:	86ca                	mv	a3,s2
    8020222e:	00006617          	auipc	a2,0x6
    80202232:	e6260613          	addi	a2,a2,-414 # 80208090 <e_text+0x90>
    80202236:	45fd                	li	a1,31
    80202238:	00006517          	auipc	a0,0x6
    8020223c:	3d050513          	addi	a0,a0,976 # 80208608 <e_text+0x608>
    80202240:	00001097          	auipc	ra,0x1
    80202244:	e86080e7          	jalr	-378(ra) # 802030c6 <printf>
		return -1;
    80202248:	557d                	li	a0,-1
    8020224a:	bf7d                	j	80202208 <sys_condvar_wait+0x80>
		errorf("Unexpected mutex id %d", mutex_id);
    8020224c:	00002097          	auipc	ra,0x2
    80202250:	152080e7          	jalr	338(ra) # 8020439e <procid>
    80202254:	84aa                	mv	s1,a0
    80202256:	00002097          	auipc	ra,0x2
    8020225a:	162080e7          	jalr	354(ra) # 802043b8 <threadid>
    8020225e:	87ca                	mv	a5,s2
    80202260:	872a                	mv	a4,a0
    80202262:	86a6                	mv	a3,s1
    80202264:	00006617          	auipc	a2,0x6
    80202268:	e2c60613          	addi	a2,a2,-468 # 80208090 <e_text+0x90>
    8020226c:	45fd                	li	a1,31
    8020226e:	00006517          	auipc	a0,0x6
    80202272:	2ba50513          	addi	a0,a0,698 # 80208528 <e_text+0x528>
    80202276:	00001097          	auipc	ra,0x1
    8020227a:	e50080e7          	jalr	-432(ra) # 802030c6 <printf>
		return -1;
    8020227e:	557d                	li	a0,-1
    80202280:	b761                	j	80202208 <sys_condvar_wait+0x80>

0000000080202282 <sys_enable_deadlock_detect>:

// LAB5: (2) you may need to define function enable_deadlock_detect here
int sys_enable_deadlock_detect(int is_enable)
{
    80202282:	1101                	addi	sp,sp,-32
    80202284:	ec06                	sd	ra,24(sp)
    80202286:	e822                	sd	s0,16(sp)
    80202288:	e426                	sd	s1,8(sp)
    8020228a:	1000                	addi	s0,sp,32
	if(is_enable != 1 && is_enable != 0){
    8020228c:	4785                	li	a5,1
    8020228e:	02a7e163          	bltu	a5,a0,802022b0 <sys_enable_deadlock_detect+0x2e>
    80202292:	84aa                	mv	s1,a0
		errorf("Unexpected parameter.\n");
		return -1;
	}
	struct proc *p = curr_proc();
    80202294:	00002097          	auipc	ra,0x2
    80202298:	14a080e7          	jalr	330(ra) # 802043de <curr_proc>
	p->enable_DLD = is_enable;
    8020229c:	6785                	lui	a5,0x1
    8020229e:	953e                	add	a0,a0,a5
    802022a0:	38952023          	sw	s1,896(a0)
	return 0;
    802022a4:	4501                	li	a0,0
}
    802022a6:	60e2                	ld	ra,24(sp)
    802022a8:	6442                	ld	s0,16(sp)
    802022aa:	64a2                	ld	s1,8(sp)
    802022ac:	6105                	addi	sp,sp,32
    802022ae:	8082                	ret
		errorf("Unexpected parameter.\n");
    802022b0:	00002097          	auipc	ra,0x2
    802022b4:	0ee080e7          	jalr	238(ra) # 8020439e <procid>
    802022b8:	84aa                	mv	s1,a0
    802022ba:	00002097          	auipc	ra,0x2
    802022be:	0fe080e7          	jalr	254(ra) # 802043b8 <threadid>
    802022c2:	872a                	mv	a4,a0
    802022c4:	86a6                	mv	a3,s1
    802022c6:	00006617          	auipc	a2,0x6
    802022ca:	dca60613          	addi	a2,a2,-566 # 80208090 <e_text+0x90>
    802022ce:	45fd                	li	a1,31
    802022d0:	00006517          	auipc	a0,0x6
    802022d4:	36850513          	addi	a0,a0,872 # 80208638 <e_text+0x638>
    802022d8:	00001097          	auipc	ra,0x1
    802022dc:	dee080e7          	jalr	-530(ra) # 802030c6 <printf>
		return -1;
    802022e0:	557d                	li	a0,-1
    802022e2:	b7d1                	j	802022a6 <sys_enable_deadlock_detect+0x24>

00000000802022e4 <syscall>:

extern char trap_page[];

void syscall()
{
    802022e4:	7139                	addi	sp,sp,-64
    802022e6:	fc06                	sd	ra,56(sp)
    802022e8:	f822                	sd	s0,48(sp)
    802022ea:	f426                	sd	s1,40(sp)
    802022ec:	f04a                	sd	s2,32(sp)
    802022ee:	ec4e                	sd	s3,24(sp)
    802022f0:	e852                	sd	s4,16(sp)
    802022f2:	e456                	sd	s5,8(sp)
    802022f4:	0080                	addi	s0,sp,64
	struct trapframe *trapframe = curr_thread()->trapframe;
    802022f6:	00002097          	auipc	ra,0x2
    802022fa:	100080e7          	jalr	256(ra) # 802043f6 <curr_thread>
    802022fe:	711c                	ld	a5,32(a0)
	int id = trapframe->a7, ret;
    80202300:	77d8                	ld	a4,168(a5)
    80202302:	0007049b          	sext.w	s1,a4
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80202306:	0707b983          	ld	s3,112(a5) # 1070 <BASE_ADDRESS-0x801fef90>
    8020230a:	0787ba03          	ld	s4,120(a5)
    8020230e:	0807ba83          	ld	s5,128(a5)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	if (id != SYS_write && id != SYS_read && id != SYS_sched_yield) {
    80202312:	fc17091b          	addiw	s2,a4,-63
    80202316:	4705                	li	a4,1
    80202318:	05277063          	bgeu	a4,s2,80202358 <syscall+0x74>
    8020231c:	07c00713          	li	a4,124
    80202320:	00e49e63          	bne	s1,a4,8020233c <syscall+0x58>
	yield();
    80202324:	00002097          	auipc	ra,0x2
    80202328:	7d0080e7          	jalr	2000(ra) # 80204af4 <yield>
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	curr_thread()->trapframe->a0 = ret;
    8020232c:	00002097          	auipc	ra,0x2
    80202330:	0ca080e7          	jalr	202(ra) # 802043f6 <curr_thread>
    80202334:	711c                	ld	a5,32(a0)
    80202336:	0607b823          	sd	zero,112(a5)
	if (id != SYS_write && id != SYS_read && id != SYS_sched_yield) {
    8020233a:	aa1d                	j	80202470 <syscall+0x18c>
		debugf("syscall %d args = [%x, %x, %x, %x, %x, %x]", id,
    8020233c:	0987b883          	ld	a7,152(a5)
    80202340:	0907b803          	ld	a6,144(a5)
    80202344:	67dc                	ld	a5,136(a5)
    80202346:	8756                	mv	a4,s5
    80202348:	86d2                	mv	a3,s4
    8020234a:	864e                	mv	a2,s3
    8020234c:	85a6                	mv	a1,s1
    8020234e:	4501                	li	a0,0
    80202350:	ffffe097          	auipc	ra,0xffffe
    80202354:	f5c080e7          	jalr	-164(ra) # 802002ac <dummy>
	switch (id) {
    80202358:	0dd00793          	li	a5,221
    8020235c:	24f48263          	beq	s1,a5,802025a0 <syscall+0x2bc>
    80202360:	0497d263          	bge	a5,s1,802023a4 <syscall+0xc0>
    80202364:	1d300793          	li	a5,467
    80202368:	2af48363          	beq	s1,a5,8020260e <syscall+0x32a>
    8020236c:	1297dd63          	bge	a5,s1,802024a6 <syscall+0x1c2>
    80202370:	1d600793          	li	a5,470
    80202374:	2af48d63          	beq	s1,a5,8020262e <syscall+0x34a>
    80202378:	1a97d463          	bge	a5,s1,80202520 <syscall+0x23c>
    8020237c:	1d800793          	li	a5,472
    80202380:	2cf48563          	beq	s1,a5,8020264a <syscall+0x366>
    80202384:	2af4cd63          	blt	s1,a5,8020263e <syscall+0x35a>
    80202388:	1d900793          	li	a5,473
    8020238c:	04f49463          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_condvar_wait(args[0], args[1]);
    80202390:	000a059b          	sext.w	a1,s4
    80202394:	0009851b          	sext.w	a0,s3
    80202398:	00000097          	auipc	ra,0x0
    8020239c:	df0080e7          	jalr	-528(ra) # 80202188 <sys_condvar_wait>
    802023a0:	89aa                	mv	s3,a0
		break;
    802023a2:	a86d                	j	8020245c <syscall+0x178>
	switch (id) {
    802023a4:	05d00793          	li	a5,93
    802023a8:	1cf48163          	beq	s1,a5,8020256a <syscall+0x286>
    802023ac:	0497df63          	bge	a5,s1,8020240a <syscall+0x126>
    802023b0:	0ac00793          	li	a5,172
    802023b4:	1cf48163          	beq	s1,a5,80202576 <syscall+0x292>
    802023b8:	0c97d563          	bge	a5,s1,80202482 <syscall+0x19e>
    802023bc:	0b200793          	li	a5,178
    802023c0:	20f48963          	beq	s1,a5,802025d2 <syscall+0x2ee>
    802023c4:	0dc00793          	li	a5,220
    802023c8:	1cf48563          	beq	s1,a5,80202592 <syscall+0x2ae>
    802023cc:	0ad00793          	li	a5,173
    802023d0:	1af48a63          	beq	s1,a5,80202584 <syscall+0x2a0>
		errorf("unknown syscall %d", id);
    802023d4:	00002097          	auipc	ra,0x2
    802023d8:	fca080e7          	jalr	-54(ra) # 8020439e <procid>
    802023dc:	89aa                	mv	s3,a0
    802023de:	00002097          	auipc	ra,0x2
    802023e2:	fda080e7          	jalr	-38(ra) # 802043b8 <threadid>
    802023e6:	87a6                	mv	a5,s1
    802023e8:	872a                	mv	a4,a0
    802023ea:	86ce                	mv	a3,s3
    802023ec:	00006617          	auipc	a2,0x6
    802023f0:	ca460613          	addi	a2,a2,-860 # 80208090 <e_text+0x90>
    802023f4:	45fd                	li	a1,31
    802023f6:	00006517          	auipc	a0,0x6
    802023fa:	27250513          	addi	a0,a0,626 # 80208668 <e_text+0x668>
    802023fe:	00001097          	auipc	ra,0x1
    80202402:	cc8080e7          	jalr	-824(ra) # 802030c6 <printf>
		ret = -1;
    80202406:	59fd                	li	s3,-1
    80202408:	a0f5                	j	802024f4 <syscall+0x210>
	switch (id) {
    8020240a:	03b00793          	li	a5,59
    8020240e:	1af48c63          	beq	s1,a5,802025c6 <syscall+0x2e2>
    80202412:	0297c363          	blt	a5,s1,80202438 <syscall+0x154>
    80202416:	03800793          	li	a5,56
    8020241a:	12f48e63          	beq	s1,a5,80202556 <syscall+0x272>
    8020241e:	03900793          	li	a5,57
    80202422:	faf499e3          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_close(args[0]);
    80202426:	0009851b          	sext.w	a0,s3
    8020242a:	fffff097          	auipc	ra,0xfffff
    8020242e:	1d2080e7          	jalr	466(ra) # 802015fc <sys_close>
    80202432:	0005099b          	sext.w	s3,a0
		break;
    80202436:	a01d                	j	8020245c <syscall+0x178>
	switch (id) {
    80202438:	03f00793          	li	a5,63
    8020243c:	10f48263          	beq	s1,a5,80202540 <syscall+0x25c>
    80202440:	04000793          	li	a5,64
    80202444:	f8f498e3          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_write(args[0], args[1], args[2]);
    80202448:	8656                	mv	a2,s5
    8020244a:	85d2                	mv	a1,s4
    8020244c:	0009851b          	sext.w	a0,s3
    80202450:	fffff097          	auipc	ra,0xfffff
    80202454:	c82080e7          	jalr	-894(ra) # 802010d2 <sys_write>
    80202458:	0005099b          	sext.w	s3,a0
	curr_thread()->trapframe->a0 = ret;
    8020245c:	00002097          	auipc	ra,0x2
    80202460:	f9a080e7          	jalr	-102(ra) # 802043f6 <curr_thread>
    80202464:	711c                	ld	a5,32(a0)
    80202466:	0737b823          	sd	s3,112(a5)
	if (id != SYS_write && id != SYS_read && id != SYS_sched_yield) {
    8020246a:	4785                	li	a5,1
    8020246c:	0b27e263          	bltu	a5,s2,80202510 <syscall+0x22c>
		debugf("syscall %d ret %d", id, ret);
	}
}
    80202470:	70e2                	ld	ra,56(sp)
    80202472:	7442                	ld	s0,48(sp)
    80202474:	74a2                	ld	s1,40(sp)
    80202476:	7902                	ld	s2,32(sp)
    80202478:	69e2                	ld	s3,24(sp)
    8020247a:	6a42                	ld	s4,16(sp)
    8020247c:	6aa2                	ld	s5,8(sp)
    8020247e:	6121                	addi	sp,sp,64
    80202480:	8082                	ret
	switch (id) {
    80202482:	07c00793          	li	a5,124
    80202486:	e8f48fe3          	beq	s1,a5,80202324 <syscall+0x40>
    8020248a:	0a900793          	li	a5,169
    8020248e:	f4f493e3          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_gettimeofday(args[0], args[1]);
    80202492:	000a059b          	sext.w	a1,s4
    80202496:	854e                	mv	a0,s3
    80202498:	fffff097          	auipc	ra,0xfffff
    8020249c:	e7c080e7          	jalr	-388(ra) # 80201314 <sys_gettimeofday>
    802024a0:	0005099b          	sext.w	s3,a0
		break;
    802024a4:	bf65                	j	8020245c <syscall+0x178>
	switch (id) {
    802024a6:	1ce00793          	li	a5,462
    802024aa:	12f48a63          	beq	s1,a5,802025de <syscall+0x2fa>
    802024ae:	0297d463          	bge	a5,s1,802024d6 <syscall+0x1f2>
    802024b2:	1d000793          	li	a5,464
    802024b6:	14f48463          	beq	s1,a5,802025fe <syscall+0x31a>
    802024ba:	12f4ca63          	blt	s1,a5,802025ee <syscall+0x30a>
    802024be:	1d200793          	li	a5,466
    802024c2:	f0f499e3          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_mutex_unlock(args[0]);
    802024c6:	0009851b          	sext.w	a0,s3
    802024ca:	fffff097          	auipc	ra,0xfffff
    802024ce:	784080e7          	jalr	1924(ra) # 80201c4e <sys_mutex_unlock>
    802024d2:	89aa                	mv	s3,a0
		break;
    802024d4:	b761                	j	8020245c <syscall+0x178>
	switch (id) {
    802024d6:	10400793          	li	a5,260
    802024da:	0cf48c63          	beq	s1,a5,802025b2 <syscall+0x2ce>
    802024de:	1cc00793          	li	a5,460
    802024e2:	eef499e3          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_thread_create(args[0], args[1]);
    802024e6:	85d2                	mv	a1,s4
    802024e8:	854e                	mv	a0,s3
    802024ea:	fffff097          	auipc	ra,0xfffff
    802024ee:	18c080e7          	jalr	396(ra) # 80201676 <sys_thread_create>
    802024f2:	89aa                	mv	s3,a0
	curr_thread()->trapframe->a0 = ret;
    802024f4:	00002097          	auipc	ra,0x2
    802024f8:	f02080e7          	jalr	-254(ra) # 802043f6 <curr_thread>
    802024fc:	711c                	ld	a5,32(a0)
    802024fe:	0737b823          	sd	s3,112(a5)
	if (id != SYS_write && id != SYS_read && id != SYS_sched_yield) {
    80202502:	4785                	li	a5,1
    80202504:	f727f6e3          	bgeu	a5,s2,80202470 <syscall+0x18c>
    80202508:	07c00793          	li	a5,124
    8020250c:	f6f482e3          	beq	s1,a5,80202470 <syscall+0x18c>
		debugf("syscall %d ret %d", id, ret);
    80202510:	864e                	mv	a2,s3
    80202512:	85a6                	mv	a1,s1
    80202514:	4501                	li	a0,0
    80202516:	ffffe097          	auipc	ra,0xffffe
    8020251a:	d96080e7          	jalr	-618(ra) # 802002ac <dummy>
}
    8020251e:	bf89                	j	80202470 <syscall+0x18c>
	switch (id) {
    80202520:	1d400793          	li	a5,468
    80202524:	0ef48d63          	beq	s1,a5,8020261e <syscall+0x33a>
    80202528:	1d500793          	li	a5,469
    8020252c:	eaf494e3          	bne	s1,a5,802023d4 <syscall+0xf0>
		ret = sys_enable_deadlock_detect(args[0]);
    80202530:	0009851b          	sext.w	a0,s3
    80202534:	00000097          	auipc	ra,0x0
    80202538:	d4e080e7          	jalr	-690(ra) # 80202282 <sys_enable_deadlock_detect>
    8020253c:	89aa                	mv	s3,a0
		break;
    8020253e:	bf39                	j	8020245c <syscall+0x178>
		ret = sys_read(args[0], args[1], args[2]);
    80202540:	8656                	mv	a2,s5
    80202542:	85d2                	mv	a1,s4
    80202544:	0009851b          	sext.w	a0,s3
    80202548:	fffff097          	auipc	ra,0xfffff
    8020254c:	c96080e7          	jalr	-874(ra) # 802011de <sys_read>
    80202550:	0005099b          	sext.w	s3,a0
		break;
    80202554:	b721                	j	8020245c <syscall+0x178>
		ret = sys_openat(args[0], args[1], args[2]);
    80202556:	8656                	mv	a2,s5
    80202558:	85d2                	mv	a1,s4
    8020255a:	854e                	mv	a0,s3
    8020255c:	fffff097          	auipc	ra,0xfffff
    80202560:	05a080e7          	jalr	90(ra) # 802015b6 <sys_openat>
    80202564:	0005099b          	sext.w	s3,a0
		break;
    80202568:	bdd5                	j	8020245c <syscall+0x178>
	exit(code);
    8020256a:	0009851b          	sext.w	a0,s3
    8020256e:	00003097          	auipc	ra,0x3
    80202572:	c36080e7          	jalr	-970(ra) # 802051a4 <exit>
		ret = sys_getpid();
    80202576:	fffff097          	auipc	ra,0xfffff
    8020257a:	e06080e7          	jalr	-506(ra) # 8020137c <sys_getpid>
    8020257e:	0005099b          	sext.w	s3,a0
		break;
    80202582:	bde9                	j	8020245c <syscall+0x178>
		ret = sys_getppid();
    80202584:	fffff097          	auipc	ra,0xfffff
    80202588:	e12080e7          	jalr	-494(ra) # 80201396 <sys_getppid>
    8020258c:	0005099b          	sext.w	s3,a0
		break;
    80202590:	b5f1                	j	8020245c <syscall+0x178>
		ret = sys_clone();
    80202592:	fffff097          	auipc	ra,0xfffff
    80202596:	e24080e7          	jalr	-476(ra) # 802013b6 <sys_clone>
    8020259a:	0005099b          	sext.w	s3,a0
		break;
    8020259e:	bd7d                	j	8020245c <syscall+0x178>
		ret = sys_exec(args[0], args[1]);
    802025a0:	85d2                	mv	a1,s4
    802025a2:	854e                	mv	a0,s3
    802025a4:	fffff097          	auipc	ra,0xfffff
    802025a8:	e34080e7          	jalr	-460(ra) # 802013d8 <sys_exec>
    802025ac:	0005099b          	sext.w	s3,a0
		break;
    802025b0:	b575                	j	8020245c <syscall+0x178>
		ret = sys_wait(args[0], args[1]);
    802025b2:	85d2                	mv	a1,s4
    802025b4:	0009851b          	sext.w	a0,s3
    802025b8:	fffff097          	auipc	ra,0xfffff
    802025bc:	ef2080e7          	jalr	-270(ra) # 802014aa <sys_wait>
    802025c0:	0005099b          	sext.w	s3,a0
		break;
    802025c4:	bd61                	j	8020245c <syscall+0x178>
		ret = sys_pipe(args[0]);
    802025c6:	854e                	mv	a0,s3
    802025c8:	fffff097          	auipc	ra,0xfffff
    802025cc:	f1e080e7          	jalr	-226(ra) # 802014e6 <sys_pipe>
    802025d0:	bf19                	j	802024e6 <syscall+0x202>
		ret = sys_gettid();
    802025d2:	fffff097          	auipc	ra,0xfffff
    802025d6:	13e080e7          	jalr	318(ra) # 80201710 <sys_gettid>
    802025da:	89aa                	mv	s3,a0
		break;
    802025dc:	b541                	j	8020245c <syscall+0x178>
		ret = sys_waittid(args[0]);
    802025de:	0009851b          	sext.w	a0,s3
    802025e2:	fffff097          	auipc	ra,0xfffff
    802025e6:	148080e7          	jalr	328(ra) # 8020172a <sys_waittid>
    802025ea:	89aa                	mv	s3,a0
		break;
    802025ec:	bd85                	j	8020245c <syscall+0x178>
		ret = sys_mutex_create(args[0]);
    802025ee:	0009851b          	sext.w	a0,s3
    802025f2:	fffff097          	auipc	ra,0xfffff
    802025f6:	408080e7          	jalr	1032(ra) # 802019fa <sys_mutex_create>
    802025fa:	89aa                	mv	s3,a0
		break;
    802025fc:	b585                	j	8020245c <syscall+0x178>
		ret = sys_mutex_lock(args[0]);
    802025fe:	0009851b          	sext.w	a0,s3
    80202602:	fffff097          	auipc	ra,0xfffff
    80202606:	490080e7          	jalr	1168(ra) # 80201a92 <sys_mutex_lock>
    8020260a:	89aa                	mv	s3,a0
		break;
    8020260c:	bd81                	j	8020245c <syscall+0x178>
		ret = sys_semaphore_create(args[0]);
    8020260e:	0009851b          	sext.w	a0,s3
    80202612:	fffff097          	auipc	ra,0xfffff
    80202616:	722080e7          	jalr	1826(ra) # 80201d34 <sys_semaphore_create>
    8020261a:	89aa                	mv	s3,a0
		break;
    8020261c:	b581                	j	8020245c <syscall+0x178>
		ret = sys_semaphore_up(args[0]);
    8020261e:	0009851b          	sext.w	a0,s3
    80202622:	fffff097          	auipc	ra,0xfffff
    80202626:	7b0080e7          	jalr	1968(ra) # 80201dd2 <sys_semaphore_up>
    8020262a:	89aa                	mv	s3,a0
		break;
    8020262c:	bd05                	j	8020245c <syscall+0x178>
		ret = sys_semaphore_down(args[0]);
    8020262e:	0009851b          	sext.w	a0,s3
    80202632:	00000097          	auipc	ra,0x0
    80202636:	886080e7          	jalr	-1914(ra) # 80201eb8 <sys_semaphore_down>
    8020263a:	89aa                	mv	s3,a0
		break;
    8020263c:	b505                	j	8020245c <syscall+0x178>
		ret = sys_condvar_create();
    8020263e:	00000097          	auipc	ra,0x0
    80202642:	a3a080e7          	jalr	-1478(ra) # 80202078 <sys_condvar_create>
    80202646:	89aa                	mv	s3,a0
		break;
    80202648:	bd11                	j	8020245c <syscall+0x178>
		ret = sys_condvar_signal(args[0]);
    8020264a:	0009851b          	sext.w	a0,s3
    8020264e:	00000097          	auipc	ra,0x0
    80202652:	aae080e7          	jalr	-1362(ra) # 802020fc <sys_condvar_signal>
    80202656:	89aa                	mv	s3,a0
		break;
    80202658:	b511                	j	8020245c <syscall+0x178>

000000008020265a <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8020265a:	7139                	addi	sp,sp,-64
    8020265c:	fc06                	sd	ra,56(sp)
    8020265e:	f822                	sd	s0,48(sp)
    80202660:	f426                	sd	s1,40(sp)
    80202662:	f04a                	sd	s2,32(sp)
    80202664:	ec4e                	sd	s3,24(sp)
    80202666:	e852                	sd	s4,16(sp)
    80202668:	e456                	sd	s5,8(sp)
    8020266a:	e05a                	sd	s6,0(sp)
    8020266c:	0080                	addi	s0,sp,64
    8020266e:	84aa                	mv	s1,a0
    80202670:	89ae                	mv	s3,a1
    80202672:	8b32                	mv	s6,a2
	if (va >= MAXVA)
    80202674:	57fd                	li	a5,-1
    80202676:	83e9                	srli	a5,a5,0x1a
    80202678:	4a79                	li	s4,30
		panic("walk");

	for (int level = 2; level > 0; level--) {
    8020267a:	4ab1                	li	s5,12
	if (va >= MAXVA)
    8020267c:	06b7fc63          	bgeu	a5,a1,802026f4 <walk+0x9a>
		panic("walk");
    80202680:	00002097          	auipc	ra,0x2
    80202684:	d1e080e7          	jalr	-738(ra) # 8020439e <procid>
    80202688:	84aa                	mv	s1,a0
    8020268a:	00002097          	auipc	ra,0x2
    8020268e:	d2e080e7          	jalr	-722(ra) # 802043b8 <threadid>
    80202692:	03900813          	li	a6,57
    80202696:	00006797          	auipc	a5,0x6
    8020269a:	ffa78793          	addi	a5,a5,-6 # 80208690 <e_text+0x690>
    8020269e:	872a                	mv	a4,a0
    802026a0:	86a6                	mv	a3,s1
    802026a2:	00006617          	auipc	a2,0x6
    802026a6:	96e60613          	addi	a2,a2,-1682 # 80208010 <e_text+0x10>
    802026aa:	45fd                	li	a1,31
    802026ac:	00006517          	auipc	a0,0x6
    802026b0:	fec50513          	addi	a0,a0,-20 # 80208698 <e_text+0x698>
    802026b4:	00001097          	auipc	ra,0x1
    802026b8:	a12080e7          	jalr	-1518(ra) # 802030c6 <printf>
    802026bc:	00001097          	auipc	ra,0x1
    802026c0:	c22080e7          	jalr	-990(ra) # 802032de <shutdown>
		pte_t *pte = &pagetable[PX(level, va)];
		if (*pte & PTE_V) {
			pagetable = (pagetable_t)PTE2PA(*pte);
		} else {
			if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    802026c4:	060b0663          	beqz	s6,80202730 <walk+0xd6>
    802026c8:	00002097          	auipc	ra,0x2
    802026cc:	c10080e7          	jalr	-1008(ra) # 802042d8 <kalloc>
    802026d0:	84aa                	mv	s1,a0
    802026d2:	c529                	beqz	a0,8020271c <walk+0xc2>
				return 0;
			memset(pagetable, 0, PGSIZE);
    802026d4:	6605                	lui	a2,0x1
    802026d6:	4581                	li	a1,0
    802026d8:	ffffe097          	auipc	ra,0xffffe
    802026dc:	a00080e7          	jalr	-1536(ra) # 802000d8 <memset>
			*pte = PA2PTE(pagetable) | PTE_V;
    802026e0:	00c4d793          	srli	a5,s1,0xc
    802026e4:	07aa                	slli	a5,a5,0xa
    802026e6:	0017e793          	ori	a5,a5,1
    802026ea:	00f93023          	sd	a5,0(s2)
    802026ee:	3a5d                	addiw	s4,s4,-9
	for (int level = 2; level > 0; level--) {
    802026f0:	035a0063          	beq	s4,s5,80202710 <walk+0xb6>
		pte_t *pte = &pagetable[PX(level, va)];
    802026f4:	0149d933          	srl	s2,s3,s4
    802026f8:	1ff97913          	andi	s2,s2,511
    802026fc:	090e                	slli	s2,s2,0x3
    802026fe:	9926                	add	s2,s2,s1
		if (*pte & PTE_V) {
    80202700:	00093483          	ld	s1,0(s2)
    80202704:	0014f793          	andi	a5,s1,1
    80202708:	dfd5                	beqz	a5,802026c4 <walk+0x6a>
			pagetable = (pagetable_t)PTE2PA(*pte);
    8020270a:	80a9                	srli	s1,s1,0xa
    8020270c:	04b2                	slli	s1,s1,0xc
    8020270e:	b7c5                	j	802026ee <walk+0x94>
		}
	}
	return &pagetable[PX(0, va)];
    80202710:	00c9d513          	srli	a0,s3,0xc
    80202714:	1ff57513          	andi	a0,a0,511
    80202718:	050e                	slli	a0,a0,0x3
    8020271a:	9526                	add	a0,a0,s1
}
    8020271c:	70e2                	ld	ra,56(sp)
    8020271e:	7442                	ld	s0,48(sp)
    80202720:	74a2                	ld	s1,40(sp)
    80202722:	7902                	ld	s2,32(sp)
    80202724:	69e2                	ld	s3,24(sp)
    80202726:	6a42                	ld	s4,16(sp)
    80202728:	6aa2                	ld	s5,8(sp)
    8020272a:	6b02                	ld	s6,0(sp)
    8020272c:	6121                	addi	sp,sp,64
    8020272e:	8082                	ret
				return 0;
    80202730:	4501                	li	a0,0
    80202732:	b7ed                	j	8020271c <walk+0xc2>

0000000080202734 <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
	pte_t *pte;
	uint64 pa;

	if (va >= MAXVA)
    80202734:	57fd                	li	a5,-1
    80202736:	83e9                	srli	a5,a5,0x1a
    80202738:	00b7f463          	bgeu	a5,a1,80202740 <walkaddr+0xc>
		return 0;
    8020273c:	4501                	li	a0,0
		return 0;
	if ((*pte & PTE_U) == 0)
		return 0;
	pa = PTE2PA(*pte);
	return pa;
}
    8020273e:	8082                	ret
{
    80202740:	1141                	addi	sp,sp,-16
    80202742:	e406                	sd	ra,8(sp)
    80202744:	e022                	sd	s0,0(sp)
    80202746:	0800                	addi	s0,sp,16
	pte = walk(pagetable, va, 0);
    80202748:	4601                	li	a2,0
    8020274a:	00000097          	auipc	ra,0x0
    8020274e:	f10080e7          	jalr	-240(ra) # 8020265a <walk>
	if (pte == 0)
    80202752:	c105                	beqz	a0,80202772 <walkaddr+0x3e>
	if ((*pte & PTE_V) == 0)
    80202754:	611c                	ld	a5,0(a0)
	if ((*pte & PTE_U) == 0)
    80202756:	0117f693          	andi	a3,a5,17
    8020275a:	4745                	li	a4,17
		return 0;
    8020275c:	4501                	li	a0,0
	if ((*pte & PTE_U) == 0)
    8020275e:	00e68663          	beq	a3,a4,8020276a <walkaddr+0x36>
}
    80202762:	60a2                	ld	ra,8(sp)
    80202764:	6402                	ld	s0,0(sp)
    80202766:	0141                	addi	sp,sp,16
    80202768:	8082                	ret
	pa = PTE2PA(*pte);
    8020276a:	00a7d513          	srli	a0,a5,0xa
    8020276e:	0532                	slli	a0,a0,0xc
	return pa;
    80202770:	bfcd                	j	80202762 <walkaddr+0x2e>
		return 0;
    80202772:	4501                	li	a0,0
    80202774:	b7fd                	j	80202762 <walkaddr+0x2e>

0000000080202776 <useraddr>:

// Look up a virtual address, return the physical address,
uint64 useraddr(pagetable_t pagetable, uint64 va)
{
    80202776:	1101                	addi	sp,sp,-32
    80202778:	ec06                	sd	ra,24(sp)
    8020277a:	e822                	sd	s0,16(sp)
    8020277c:	e426                	sd	s1,8(sp)
    8020277e:	1000                	addi	s0,sp,32
    80202780:	84ae                	mv	s1,a1
	uint64 page = walkaddr(pagetable, va);
    80202782:	00000097          	auipc	ra,0x0
    80202786:	fb2080e7          	jalr	-78(ra) # 80202734 <walkaddr>
	if (page == 0)
    8020278a:	c509                	beqz	a0,80202794 <useraddr+0x1e>
		return 0;
	return page | (va & 0xFFFULL);
    8020278c:	03449593          	slli	a1,s1,0x34
    80202790:	91d1                	srli	a1,a1,0x34
    80202792:	8d4d                	or	a0,a0,a1
}
    80202794:	60e2                	ld	ra,24(sp)
    80202796:	6442                	ld	s0,16(sp)
    80202798:	64a2                	ld	s1,8(sp)
    8020279a:	6105                	addi	sp,sp,32
    8020279c:	8082                	ret

000000008020279e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8020279e:	715d                	addi	sp,sp,-80
    802027a0:	e486                	sd	ra,72(sp)
    802027a2:	e0a2                	sd	s0,64(sp)
    802027a4:	fc26                	sd	s1,56(sp)
    802027a6:	f84a                	sd	s2,48(sp)
    802027a8:	f44e                	sd	s3,40(sp)
    802027aa:	f052                	sd	s4,32(sp)
    802027ac:	ec56                	sd	s5,24(sp)
    802027ae:	e85a                	sd	s6,16(sp)
    802027b0:	e45e                	sd	s7,8(sp)
    802027b2:	0880                	addi	s0,sp,80
    802027b4:	8aaa                	mv	s5,a0
    802027b6:	8b3a                	mv	s6,a4
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    802027b8:	79fd                	lui	s3,0xfffff
    802027ba:	0135fa33          	and	s4,a1,s3
	last = PGROUNDDOWN(va + size - 1);
    802027be:	167d                	addi	a2,a2,-1
    802027c0:	962e                	add	a2,a2,a1
    802027c2:	013679b3          	and	s3,a2,s3
	a = PGROUNDDOWN(va);
    802027c6:	8952                	mv	s2,s4
    802027c8:	41468a33          	sub	s4,a3,s4
			return -1;
		}
		*pte = PA2PTE(pa) | perm | PTE_V;
		if (a == last)
			break;
		a += PGSIZE;
    802027cc:	6b85                	lui	s7,0x1
    802027ce:	012a04b3          	add	s1,s4,s2
		if ((pte = walk(pagetable, a, 1)) == 0) {
    802027d2:	4605                	li	a2,1
    802027d4:	85ca                	mv	a1,s2
    802027d6:	8556                	mv	a0,s5
    802027d8:	00000097          	auipc	ra,0x0
    802027dc:	e82080e7          	jalr	-382(ra) # 8020265a <walk>
    802027e0:	cd19                	beqz	a0,802027fe <mappages+0x60>
		if (*pte & PTE_V) {
    802027e2:	611c                	ld	a5,0(a0)
    802027e4:	8b85                	andi	a5,a5,1
    802027e6:	e3ad                	bnez	a5,80202848 <mappages+0xaa>
		*pte = PA2PTE(pa) | perm | PTE_V;
    802027e8:	80b1                	srli	s1,s1,0xc
    802027ea:	04aa                	slli	s1,s1,0xa
    802027ec:	0164e4b3          	or	s1,s1,s6
    802027f0:	0014e493          	ori	s1,s1,1
    802027f4:	e104                	sd	s1,0(a0)
		if (a == last)
    802027f6:	09390363          	beq	s2,s3,8020287c <mappages+0xde>
		a += PGSIZE;
    802027fa:	995e                	add	s2,s2,s7
		if ((pte = walk(pagetable, a, 1)) == 0) {
    802027fc:	bfc9                	j	802027ce <mappages+0x30>
			errorf("pte invalid, va = %p", a);
    802027fe:	00002097          	auipc	ra,0x2
    80202802:	ba0080e7          	jalr	-1120(ra) # 8020439e <procid>
    80202806:	84aa                	mv	s1,a0
    80202808:	00002097          	auipc	ra,0x2
    8020280c:	bb0080e7          	jalr	-1104(ra) # 802043b8 <threadid>
    80202810:	87ca                	mv	a5,s2
    80202812:	872a                	mv	a4,a0
    80202814:	86a6                	mv	a3,s1
    80202816:	00006617          	auipc	a2,0x6
    8020281a:	87a60613          	addi	a2,a2,-1926 # 80208090 <e_text+0x90>
    8020281e:	45fd                	li	a1,31
    80202820:	00006517          	auipc	a0,0x6
    80202824:	ea050513          	addi	a0,a0,-352 # 802086c0 <e_text+0x6c0>
    80202828:	00001097          	auipc	ra,0x1
    8020282c:	89e080e7          	jalr	-1890(ra) # 802030c6 <printf>
			return -1;
    80202830:	557d                	li	a0,-1
		pa += PGSIZE;
	}
	return 0;
}
    80202832:	60a6                	ld	ra,72(sp)
    80202834:	6406                	ld	s0,64(sp)
    80202836:	74e2                	ld	s1,56(sp)
    80202838:	7942                	ld	s2,48(sp)
    8020283a:	79a2                	ld	s3,40(sp)
    8020283c:	7a02                	ld	s4,32(sp)
    8020283e:	6ae2                	ld	s5,24(sp)
    80202840:	6b42                	ld	s6,16(sp)
    80202842:	6ba2                	ld	s7,8(sp)
    80202844:	6161                	addi	sp,sp,80
    80202846:	8082                	ret
			errorf("remap");
    80202848:	00002097          	auipc	ra,0x2
    8020284c:	b56080e7          	jalr	-1194(ra) # 8020439e <procid>
    80202850:	84aa                	mv	s1,a0
    80202852:	00002097          	auipc	ra,0x2
    80202856:	b66080e7          	jalr	-1178(ra) # 802043b8 <threadid>
    8020285a:	872a                	mv	a4,a0
    8020285c:	86a6                	mv	a3,s1
    8020285e:	00006617          	auipc	a2,0x6
    80202862:	83260613          	addi	a2,a2,-1998 # 80208090 <e_text+0x90>
    80202866:	45fd                	li	a1,31
    80202868:	00006517          	auipc	a0,0x6
    8020286c:	e8850513          	addi	a0,a0,-376 # 802086f0 <e_text+0x6f0>
    80202870:	00001097          	auipc	ra,0x1
    80202874:	856080e7          	jalr	-1962(ra) # 802030c6 <printf>
			return -1;
    80202878:	557d                	li	a0,-1
    8020287a:	bf65                	j	80202832 <mappages+0x94>
	return 0;
    8020287c:	4501                	li	a0,0
    8020287e:	bf55                	j	80202832 <mappages+0x94>

0000000080202880 <kvmmap>:
{
    80202880:	1101                	addi	sp,sp,-32
    80202882:	ec06                	sd	ra,24(sp)
    80202884:	e822                	sd	s0,16(sp)
    80202886:	e426                	sd	s1,8(sp)
    80202888:	1000                	addi	s0,sp,32
    8020288a:	87b6                	mv	a5,a3
	if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8020288c:	86b2                	mv	a3,a2
    8020288e:	863e                	mv	a2,a5
    80202890:	00000097          	auipc	ra,0x0
    80202894:	f0e080e7          	jalr	-242(ra) # 8020279e <mappages>
    80202898:	e511                	bnez	a0,802028a4 <kvmmap+0x24>
}
    8020289a:	60e2                	ld	ra,24(sp)
    8020289c:	6442                	ld	s0,16(sp)
    8020289e:	64a2                	ld	s1,8(sp)
    802028a0:	6105                	addi	sp,sp,32
    802028a2:	8082                	ret
		panic("kvmmap");
    802028a4:	00002097          	auipc	ra,0x2
    802028a8:	afa080e7          	jalr	-1286(ra) # 8020439e <procid>
    802028ac:	84aa                	mv	s1,a0
    802028ae:	00002097          	auipc	ra,0x2
    802028b2:	b0a080e7          	jalr	-1270(ra) # 802043b8 <threadid>
    802028b6:	06e00813          	li	a6,110
    802028ba:	00006797          	auipc	a5,0x6
    802028be:	dd678793          	addi	a5,a5,-554 # 80208690 <e_text+0x690>
    802028c2:	872a                	mv	a4,a0
    802028c4:	86a6                	mv	a3,s1
    802028c6:	00005617          	auipc	a2,0x5
    802028ca:	74a60613          	addi	a2,a2,1866 # 80208010 <e_text+0x10>
    802028ce:	45fd                	li	a1,31
    802028d0:	00006517          	auipc	a0,0x6
    802028d4:	e4050513          	addi	a0,a0,-448 # 80208710 <e_text+0x710>
    802028d8:	00000097          	auipc	ra,0x0
    802028dc:	7ee080e7          	jalr	2030(ra) # 802030c6 <printf>
    802028e0:	00001097          	auipc	ra,0x1
    802028e4:	9fe080e7          	jalr	-1538(ra) # 802032de <shutdown>

00000000802028e8 <kvmmake>:
{
    802028e8:	1101                	addi	sp,sp,-32
    802028ea:	ec06                	sd	ra,24(sp)
    802028ec:	e822                	sd	s0,16(sp)
    802028ee:	e426                	sd	s1,8(sp)
    802028f0:	e04a                	sd	s2,0(sp)
    802028f2:	1000                	addi	s0,sp,32
	kpgtbl = (pagetable_t)kalloc();
    802028f4:	00002097          	auipc	ra,0x2
    802028f8:	9e4080e7          	jalr	-1564(ra) # 802042d8 <kalloc>
    802028fc:	84aa                	mv	s1,a0
	memset(kpgtbl, 0, PGSIZE);
    802028fe:	6605                	lui	a2,0x1
    80202900:	4581                	li	a1,0
    80202902:	ffffd097          	auipc	ra,0xffffd
    80202906:	7d6080e7          	jalr	2006(ra) # 802000d8 <memset>
	kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8020290a:	4719                	li	a4,6
    8020290c:	6685                	lui	a3,0x1
    8020290e:	10001637          	lui	a2,0x10001
    80202912:	100015b7          	lui	a1,0x10001
    80202916:	8526                	mv	a0,s1
    80202918:	00000097          	auipc	ra,0x0
    8020291c:	f68080e7          	jalr	-152(ra) # 80202880 <kvmmap>
	kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80202920:	4719                	li	a4,6
    80202922:	004006b7          	lui	a3,0x400
    80202926:	0c000637          	lui	a2,0xc000
    8020292a:	0c0005b7          	lui	a1,0xc000
    8020292e:	8526                	mv	a0,s1
    80202930:	00000097          	auipc	ra,0x0
    80202934:	f50080e7          	jalr	-176(ra) # 80202880 <kvmmap>
	kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)e_text - KERNBASE,
    80202938:	00005917          	auipc	s2,0x5
    8020293c:	6c890913          	addi	s2,s2,1736 # 80208000 <e_text>
    80202940:	4729                	li	a4,10
    80202942:	bff00693          	li	a3,-1025
    80202946:	06d6                	slli	a3,a3,0x15
    80202948:	96ca                	add	a3,a3,s2
    8020294a:	40100613          	li	a2,1025
    8020294e:	0656                	slli	a2,a2,0x15
    80202950:	85b2                	mv	a1,a2
    80202952:	8526                	mv	a0,s1
    80202954:	00000097          	auipc	ra,0x0
    80202958:	f2c080e7          	jalr	-212(ra) # 80202880 <kvmmap>
	kvmmap(kpgtbl, (uint64)e_text, (uint64)e_text, PHYSTOP - (uint64)e_text,
    8020295c:	4719                	li	a4,6
    8020295e:	46c5                	li	a3,17
    80202960:	06ee                	slli	a3,a3,0x1b
    80202962:	412686b3          	sub	a3,a3,s2
    80202966:	864a                	mv	a2,s2
    80202968:	85ca                	mv	a1,s2
    8020296a:	8526                	mv	a0,s1
    8020296c:	00000097          	auipc	ra,0x0
    80202970:	f14080e7          	jalr	-236(ra) # 80202880 <kvmmap>
	kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80202974:	4729                	li	a4,10
    80202976:	6685                	lui	a3,0x1
    80202978:	00004617          	auipc	a2,0x4
    8020297c:	68860613          	addi	a2,a2,1672 # 80207000 <trampoline>
    80202980:	040005b7          	lui	a1,0x4000
    80202984:	15fd                	addi	a1,a1,-1
    80202986:	05b2                	slli	a1,a1,0xc
    80202988:	8526                	mv	a0,s1
    8020298a:	00000097          	auipc	ra,0x0
    8020298e:	ef6080e7          	jalr	-266(ra) # 80202880 <kvmmap>
}
    80202992:	8526                	mv	a0,s1
    80202994:	60e2                	ld	ra,24(sp)
    80202996:	6442                	ld	s0,16(sp)
    80202998:	64a2                	ld	s1,8(sp)
    8020299a:	6902                	ld	s2,0(sp)
    8020299c:	6105                	addi	sp,sp,32
    8020299e:	8082                	ret

00000000802029a0 <kvm_init>:
{
    802029a0:	1141                	addi	sp,sp,-16
    802029a2:	e406                	sd	ra,8(sp)
    802029a4:	e022                	sd	s0,0(sp)
    802029a6:	0800                	addi	s0,sp,16
	kernel_pagetable = kvmmake();
    802029a8:	00000097          	auipc	ra,0x0
    802029ac:	f40080e7          	jalr	-192(ra) # 802028e8 <kvmmake>
    802029b0:	0111b797          	auipc	a5,0x111b
    802029b4:	94a7b023          	sd	a0,-1728(a5) # 8131d2f0 <kernel_pagetable>
	w_satp(MAKE_SATP(kernel_pagetable));
    802029b8:	8131                	srli	a0,a0,0xc
    802029ba:	57fd                	li	a5,-1
    802029bc:	17fe                	slli	a5,a5,0x3f
    802029be:	8d5d                	or	a0,a0,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    802029c0:	18051073          	csrw	satp,a0

// flush the TLB.
static inline void sfence_vma()
{
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    802029c4:	12000073          	sfence.vma
	asm volatile("csrr %0, satp" : "=r"(x));
    802029c8:	180025f3          	csrr	a1,satp
	infof("enable pageing at %p", r_satp());
    802029cc:	4501                	li	a0,0
    802029ce:	ffffe097          	auipc	ra,0xffffe
    802029d2:	8de080e7          	jalr	-1826(ra) # 802002ac <dummy>
}
    802029d6:	60a2                	ld	ra,8(sp)
    802029d8:	6402                	ld	s0,0(sp)
    802029da:	0141                	addi	sp,sp,16
    802029dc:	8082                	ret

00000000802029de <uvmmap>:

int uvmmap(pagetable_t pagetable, uint64 va, uint64 npages, int perm)
{
	for (int i = 0; i < npages; ++i) {
    802029de:	c239                	beqz	a2,80202a24 <uvmmap+0x46>
{
    802029e0:	7139                	addi	sp,sp,-64
    802029e2:	fc06                	sd	ra,56(sp)
    802029e4:	f822                	sd	s0,48(sp)
    802029e6:	f426                	sd	s1,40(sp)
    802029e8:	f04a                	sd	s2,32(sp)
    802029ea:	ec4e                	sd	s3,24(sp)
    802029ec:	e852                	sd	s4,16(sp)
    802029ee:	e456                	sd	s5,8(sp)
    802029f0:	0080                	addi	s0,sp,64
    802029f2:	8a2a                	mv	s4,a0
    802029f4:	84ae                	mv	s1,a1
    802029f6:	89b2                	mv	s3,a2
    802029f8:	8ab6                	mv	s5,a3
	for (int i = 0; i < npages; ++i) {
    802029fa:	4901                	li	s2,0
		if (mappages(pagetable, va + i * 0x1000, 0x1000,
			     (uint64)kalloc(), perm)) {
    802029fc:	00002097          	auipc	ra,0x2
    80202a00:	8dc080e7          	jalr	-1828(ra) # 802042d8 <kalloc>
		if (mappages(pagetable, va + i * 0x1000, 0x1000,
    80202a04:	8756                	mv	a4,s5
    80202a06:	86aa                	mv	a3,a0
    80202a08:	6605                	lui	a2,0x1
    80202a0a:	85a6                	mv	a1,s1
    80202a0c:	8552                	mv	a0,s4
    80202a0e:	00000097          	auipc	ra,0x0
    80202a12:	d90080e7          	jalr	-624(ra) # 8020279e <mappages>
    80202a16:	e909                	bnez	a0,80202a28 <uvmmap+0x4a>
    80202a18:	0905                	addi	s2,s2,1
    80202a1a:	6785                	lui	a5,0x1
    80202a1c:	94be                	add	s1,s1,a5
	for (int i = 0; i < npages; ++i) {
    80202a1e:	fd391fe3          	bne	s2,s3,802029fc <uvmmap+0x1e>
    80202a22:	a021                	j	80202a2a <uvmmap+0x4c>
			return -1;
		}
	}
	return 0;
    80202a24:	4501                	li	a0,0
}
    80202a26:	8082                	ret
			return -1;
    80202a28:	557d                	li	a0,-1
}
    80202a2a:	70e2                	ld	ra,56(sp)
    80202a2c:	7442                	ld	s0,48(sp)
    80202a2e:	74a2                	ld	s1,40(sp)
    80202a30:	7902                	ld	s2,32(sp)
    80202a32:	69e2                	ld	s3,24(sp)
    80202a34:	6a42                	ld	s4,16(sp)
    80202a36:	6aa2                	ld	s5,8(sp)
    80202a38:	6121                	addi	sp,sp,64
    80202a3a:	8082                	ret

0000000080202a3c <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80202a3c:	715d                	addi	sp,sp,-80
    80202a3e:	e486                	sd	ra,72(sp)
    80202a40:	e0a2                	sd	s0,64(sp)
    80202a42:	fc26                	sd	s1,56(sp)
    80202a44:	f84a                	sd	s2,48(sp)
    80202a46:	f44e                	sd	s3,40(sp)
    80202a48:	f052                	sd	s4,32(sp)
    80202a4a:	ec56                	sd	s5,24(sp)
    80202a4c:	e85a                	sd	s6,16(sp)
    80202a4e:	e45e                	sd	s7,8(sp)
    80202a50:	0880                	addi	s0,sp,80
	uint64 a;
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    80202a52:	03459793          	slli	a5,a1,0x34
    80202a56:	e795                	bnez	a5,80202a82 <uvmunmap+0x46>
    80202a58:	8a2a                	mv	s4,a0
    80202a5a:	84ae                	mv	s1,a1
    80202a5c:	8b36                	mv	s6,a3
		panic("uvmunmap: not aligned");

	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80202a5e:	0632                	slli	a2,a2,0xc
    80202a60:	00b609b3          	add	s3,a2,a1
		if ((pte = walk(pagetable, a, 0)) == 0)
			continue;
		if ((*pte & PTE_V) != 0) {
			if (PTE_FLAGS(*pte) == PTE_V)
    80202a64:	4b85                	li	s7,1
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80202a66:	6a85                	lui	s5,0x1
    80202a68:	0b35ec63          	bltu	a1,s3,80202b20 <uvmunmap+0xe4>
				kfree((void *)pa);
			}
		}
		*pte = 0;
	}
}
    80202a6c:	60a6                	ld	ra,72(sp)
    80202a6e:	6406                	ld	s0,64(sp)
    80202a70:	74e2                	ld	s1,56(sp)
    80202a72:	7942                	ld	s2,48(sp)
    80202a74:	79a2                	ld	s3,40(sp)
    80202a76:	7a02                	ld	s4,32(sp)
    80202a78:	6ae2                	ld	s5,24(sp)
    80202a7a:	6b42                	ld	s6,16(sp)
    80202a7c:	6ba2                	ld	s7,8(sp)
    80202a7e:	6161                	addi	sp,sp,80
    80202a80:	8082                	ret
		panic("uvmunmap: not aligned");
    80202a82:	00002097          	auipc	ra,0x2
    80202a86:	91c080e7          	jalr	-1764(ra) # 8020439e <procid>
    80202a8a:	84aa                	mv	s1,a0
    80202a8c:	00002097          	auipc	ra,0x2
    80202a90:	92c080e7          	jalr	-1748(ra) # 802043b8 <threadid>
    80202a94:	0a200813          	li	a6,162
    80202a98:	00006797          	auipc	a5,0x6
    80202a9c:	bf878793          	addi	a5,a5,-1032 # 80208690 <e_text+0x690>
    80202aa0:	872a                	mv	a4,a0
    80202aa2:	86a6                	mv	a3,s1
    80202aa4:	00005617          	auipc	a2,0x5
    80202aa8:	56c60613          	addi	a2,a2,1388 # 80208010 <e_text+0x10>
    80202aac:	45fd                	li	a1,31
    80202aae:	00006517          	auipc	a0,0x6
    80202ab2:	c8a50513          	addi	a0,a0,-886 # 80208738 <e_text+0x738>
    80202ab6:	00000097          	auipc	ra,0x0
    80202aba:	610080e7          	jalr	1552(ra) # 802030c6 <printf>
    80202abe:	00001097          	auipc	ra,0x1
    80202ac2:	820080e7          	jalr	-2016(ra) # 802032de <shutdown>
				panic("uvmunmap: not a leaf");
    80202ac6:	00002097          	auipc	ra,0x2
    80202aca:	8d8080e7          	jalr	-1832(ra) # 8020439e <procid>
    80202ace:	84aa                	mv	s1,a0
    80202ad0:	00002097          	auipc	ra,0x2
    80202ad4:	8e8080e7          	jalr	-1816(ra) # 802043b8 <threadid>
    80202ad8:	0a900813          	li	a6,169
    80202adc:	00006797          	auipc	a5,0x6
    80202ae0:	bb478793          	addi	a5,a5,-1100 # 80208690 <e_text+0x690>
    80202ae4:	872a                	mv	a4,a0
    80202ae6:	86a6                	mv	a3,s1
    80202ae8:	00005617          	auipc	a2,0x5
    80202aec:	52860613          	addi	a2,a2,1320 # 80208010 <e_text+0x10>
    80202af0:	45fd                	li	a1,31
    80202af2:	00006517          	auipc	a0,0x6
    80202af6:	c7e50513          	addi	a0,a0,-898 # 80208770 <e_text+0x770>
    80202afa:	00000097          	auipc	ra,0x0
    80202afe:	5cc080e7          	jalr	1484(ra) # 802030c6 <printf>
    80202b02:	00000097          	auipc	ra,0x0
    80202b06:	7dc080e7          	jalr	2012(ra) # 802032de <shutdown>
				uint64 pa = PTE2PA(*pte);
    80202b0a:	8129                	srli	a0,a0,0xa
				kfree((void *)pa);
    80202b0c:	0532                	slli	a0,a0,0xc
    80202b0e:	00001097          	auipc	ra,0x1
    80202b12:	6cc080e7          	jalr	1740(ra) # 802041da <kfree>
		*pte = 0;
    80202b16:	00093023          	sd	zero,0(s2)
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80202b1a:	94d6                	add	s1,s1,s5
    80202b1c:	f534f8e3          	bgeu	s1,s3,80202a6c <uvmunmap+0x30>
		if ((pte = walk(pagetable, a, 0)) == 0)
    80202b20:	4601                	li	a2,0
    80202b22:	85a6                	mv	a1,s1
    80202b24:	8552                	mv	a0,s4
    80202b26:	00000097          	auipc	ra,0x0
    80202b2a:	b34080e7          	jalr	-1228(ra) # 8020265a <walk>
    80202b2e:	892a                	mv	s2,a0
    80202b30:	d56d                	beqz	a0,80202b1a <uvmunmap+0xde>
		if ((*pte & PTE_V) != 0) {
    80202b32:	6108                	ld	a0,0(a0)
    80202b34:	00157793          	andi	a5,a0,1
    80202b38:	dff9                	beqz	a5,80202b16 <uvmunmap+0xda>
			if (PTE_FLAGS(*pte) == PTE_V)
    80202b3a:	3ff57793          	andi	a5,a0,1023
    80202b3e:	f97784e3          	beq	a5,s7,80202ac6 <uvmunmap+0x8a>
			if (do_free) {
    80202b42:	fc0b0ae3          	beqz	s6,80202b16 <uvmunmap+0xda>
    80202b46:	b7d1                	j	80202b0a <uvmunmap+0xce>

0000000080202b48 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate()
{
    80202b48:	1101                	addi	sp,sp,-32
    80202b4a:	ec06                	sd	ra,24(sp)
    80202b4c:	e822                	sd	s0,16(sp)
    80202b4e:	e426                	sd	s1,8(sp)
    80202b50:	e04a                	sd	s2,0(sp)
    80202b52:	1000                	addi	s0,sp,32
	pagetable_t pagetable;
	pagetable = (pagetable_t)kalloc();
    80202b54:	00001097          	auipc	ra,0x1
    80202b58:	784080e7          	jalr	1924(ra) # 802042d8 <kalloc>
    80202b5c:	84aa                	mv	s1,a0
	if (pagetable == 0) {
    80202b5e:	cd1d                	beqz	a0,80202b9c <uvmcreate+0x54>
		errorf("uvmcreate: kalloc error");
		return 0;
	}
	memset(pagetable, 0, PGSIZE);
    80202b60:	6605                	lui	a2,0x1
    80202b62:	4581                	li	a1,0
    80202b64:	ffffd097          	auipc	ra,0xffffd
    80202b68:	574080e7          	jalr	1396(ra) # 802000d8 <memset>
	if (mappages(pagetable, TRAMPOLINE, PAGE_SIZE, (uint64)trampoline,
    80202b6c:	4729                	li	a4,10
    80202b6e:	00004697          	auipc	a3,0x4
    80202b72:	49268693          	addi	a3,a3,1170 # 80207000 <trampoline>
    80202b76:	6605                	lui	a2,0x1
    80202b78:	040005b7          	lui	a1,0x4000
    80202b7c:	15fd                	addi	a1,a1,-1
    80202b7e:	05b2                	slli	a1,a1,0xc
    80202b80:	8526                	mv	a0,s1
    80202b82:	00000097          	auipc	ra,0x0
    80202b86:	c1c080e7          	jalr	-996(ra) # 8020279e <mappages>
    80202b8a:	04054263          	bltz	a0,80202bce <uvmcreate+0x86>
		     PTE_R | PTE_X) < 0) {
		panic("mappages fail");
	}
	return pagetable;
}
    80202b8e:	8526                	mv	a0,s1
    80202b90:	60e2                	ld	ra,24(sp)
    80202b92:	6442                	ld	s0,16(sp)
    80202b94:	64a2                	ld	s1,8(sp)
    80202b96:	6902                	ld	s2,0(sp)
    80202b98:	6105                	addi	sp,sp,32
    80202b9a:	8082                	ret
		errorf("uvmcreate: kalloc error");
    80202b9c:	00002097          	auipc	ra,0x2
    80202ba0:	802080e7          	jalr	-2046(ra) # 8020439e <procid>
    80202ba4:	892a                	mv	s2,a0
    80202ba6:	00002097          	auipc	ra,0x2
    80202baa:	812080e7          	jalr	-2030(ra) # 802043b8 <threadid>
    80202bae:	872a                	mv	a4,a0
    80202bb0:	86ca                	mv	a3,s2
    80202bb2:	00005617          	auipc	a2,0x5
    80202bb6:	4de60613          	addi	a2,a2,1246 # 80208090 <e_text+0x90>
    80202bba:	45fd                	li	a1,31
    80202bbc:	00006517          	auipc	a0,0x6
    80202bc0:	bec50513          	addi	a0,a0,-1044 # 802087a8 <e_text+0x7a8>
    80202bc4:	00000097          	auipc	ra,0x0
    80202bc8:	502080e7          	jalr	1282(ra) # 802030c6 <printf>
		return 0;
    80202bcc:	b7c9                	j	80202b8e <uvmcreate+0x46>
		panic("mappages fail");
    80202bce:	00001097          	auipc	ra,0x1
    80202bd2:	7d0080e7          	jalr	2000(ra) # 8020439e <procid>
    80202bd6:	84aa                	mv	s1,a0
    80202bd8:	00001097          	auipc	ra,0x1
    80202bdc:	7e0080e7          	jalr	2016(ra) # 802043b8 <threadid>
    80202be0:	0c000813          	li	a6,192
    80202be4:	00006797          	auipc	a5,0x6
    80202be8:	aac78793          	addi	a5,a5,-1364 # 80208690 <e_text+0x690>
    80202bec:	872a                	mv	a4,a0
    80202bee:	86a6                	mv	a3,s1
    80202bf0:	00005617          	auipc	a2,0x5
    80202bf4:	42060613          	addi	a2,a2,1056 # 80208010 <e_text+0x10>
    80202bf8:	45fd                	li	a1,31
    80202bfa:	00006517          	auipc	a0,0x6
    80202bfe:	bde50513          	addi	a0,a0,-1058 # 802087d8 <e_text+0x7d8>
    80202c02:	00000097          	auipc	ra,0x0
    80202c06:	4c4080e7          	jalr	1220(ra) # 802030c6 <printf>
    80202c0a:	00000097          	auipc	ra,0x0
    80202c0e:	6d4080e7          	jalr	1748(ra) # 802032de <shutdown>

0000000080202c12 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80202c12:	7179                	addi	sp,sp,-48
    80202c14:	f406                	sd	ra,40(sp)
    80202c16:	f022                	sd	s0,32(sp)
    80202c18:	ec26                	sd	s1,24(sp)
    80202c1a:	e84a                	sd	s2,16(sp)
    80202c1c:	e44e                	sd	s3,8(sp)
    80202c1e:	e052                	sd	s4,0(sp)
    80202c20:	1800                	addi	s0,sp,48
    80202c22:	8a2a                	mv	s4,a0
	// there are 2^9 = 512 PTEs in a page table.
	for (int i = 0; i < 512; i++) {
    80202c24:	84aa                	mv	s1,a0
    80202c26:	6905                	lui	s2,0x1
    80202c28:	992a                	add	s2,s2,a0
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80202c2a:	4985                	li	s3,1
    80202c2c:	a821                	j	80202c44 <freewalk+0x32>
			// this PTE points to a lower-level page table.
			uint64 child = PTE2PA(pte);
    80202c2e:	8129                	srli	a0,a0,0xa
			freewalk((pagetable_t)child);
    80202c30:	0532                	slli	a0,a0,0xc
    80202c32:	00000097          	auipc	ra,0x0
    80202c36:	fe0080e7          	jalr	-32(ra) # 80202c12 <freewalk>
			pagetable[i] = 0;
    80202c3a:	0004b023          	sd	zero,0(s1)
    80202c3e:	04a1                	addi	s1,s1,8
	for (int i = 0; i < 512; i++) {
    80202c40:	05248b63          	beq	s1,s2,80202c96 <freewalk+0x84>
		pte_t pte = pagetable[i];
    80202c44:	6088                	ld	a0,0(s1)
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80202c46:	00f57793          	andi	a5,a0,15
    80202c4a:	ff3782e3          	beq	a5,s3,80202c2e <freewalk+0x1c>
		} else if (pte & PTE_V) {
    80202c4e:	8905                	andi	a0,a0,1
    80202c50:	d57d                	beqz	a0,80202c3e <freewalk+0x2c>
			panic("freewalk: leaf");
    80202c52:	00001097          	auipc	ra,0x1
    80202c56:	74c080e7          	jalr	1868(ra) # 8020439e <procid>
    80202c5a:	84aa                	mv	s1,a0
    80202c5c:	00001097          	auipc	ra,0x1
    80202c60:	75c080e7          	jalr	1884(ra) # 802043b8 <threadid>
    80202c64:	0d200813          	li	a6,210
    80202c68:	00006797          	auipc	a5,0x6
    80202c6c:	a2878793          	addi	a5,a5,-1496 # 80208690 <e_text+0x690>
    80202c70:	872a                	mv	a4,a0
    80202c72:	86a6                	mv	a3,s1
    80202c74:	00005617          	auipc	a2,0x5
    80202c78:	39c60613          	addi	a2,a2,924 # 80208010 <e_text+0x10>
    80202c7c:	45fd                	li	a1,31
    80202c7e:	00006517          	auipc	a0,0x6
    80202c82:	b8a50513          	addi	a0,a0,-1142 # 80208808 <e_text+0x808>
    80202c86:	00000097          	auipc	ra,0x0
    80202c8a:	440080e7          	jalr	1088(ra) # 802030c6 <printf>
    80202c8e:	00000097          	auipc	ra,0x0
    80202c92:	650080e7          	jalr	1616(ra) # 802032de <shutdown>
		}
	}
	kfree((void *)pagetable);
    80202c96:	8552                	mv	a0,s4
    80202c98:	00001097          	auipc	ra,0x1
    80202c9c:	542080e7          	jalr	1346(ra) # 802041da <kfree>
}
    80202ca0:	70a2                	ld	ra,40(sp)
    80202ca2:	7402                	ld	s0,32(sp)
    80202ca4:	64e2                	ld	s1,24(sp)
    80202ca6:	6942                	ld	s2,16(sp)
    80202ca8:	69a2                	ld	s3,8(sp)
    80202caa:	6a02                	ld	s4,0(sp)
    80202cac:	6145                	addi	sp,sp,48
    80202cae:	8082                	ret

0000000080202cb0 <uvmfree>:
 * @brief Free user memory pages, then free page-table pages.
 *
 * @param max_page The max vaddr of user-space.
 */
void uvmfree(pagetable_t pagetable, uint64 max_page)
{
    80202cb0:	1101                	addi	sp,sp,-32
    80202cb2:	ec06                	sd	ra,24(sp)
    80202cb4:	e822                	sd	s0,16(sp)
    80202cb6:	e426                	sd	s1,8(sp)
    80202cb8:	1000                	addi	s0,sp,32
    80202cba:	84aa                	mv	s1,a0
	if (max_page > 0)
    80202cbc:	e999                	bnez	a1,80202cd2 <uvmfree+0x22>
		uvmunmap(pagetable, 0, max_page, 1);
	freewalk(pagetable);
    80202cbe:	8526                	mv	a0,s1
    80202cc0:	00000097          	auipc	ra,0x0
    80202cc4:	f52080e7          	jalr	-174(ra) # 80202c12 <freewalk>
}
    80202cc8:	60e2                	ld	ra,24(sp)
    80202cca:	6442                	ld	s0,16(sp)
    80202ccc:	64a2                	ld	s1,8(sp)
    80202cce:	6105                	addi	sp,sp,32
    80202cd0:	8082                	ret
		uvmunmap(pagetable, 0, max_page, 1);
    80202cd2:	4685                	li	a3,1
    80202cd4:	862e                	mv	a2,a1
    80202cd6:	4581                	li	a1,0
    80202cd8:	00000097          	auipc	ra,0x0
    80202cdc:	d64080e7          	jalr	-668(ra) # 80202a3c <uvmunmap>
    80202ce0:	bff9                	j	80202cbe <uvmfree+0xe>

0000000080202ce2 <uvmcopy>:

// Used in fork.
// Copy the pagetable page and all the user pages.
// Return 0 on success, -1 on error.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 max_page)
{
    80202ce2:	715d                	addi	sp,sp,-80
    80202ce4:	e486                	sd	ra,72(sp)
    80202ce6:	e0a2                	sd	s0,64(sp)
    80202ce8:	fc26                	sd	s1,56(sp)
    80202cea:	f84a                	sd	s2,48(sp)
    80202cec:	f44e                	sd	s3,40(sp)
    80202cee:	f052                	sd	s4,32(sp)
    80202cf0:	ec56                	sd	s5,24(sp)
    80202cf2:	e85a                	sd	s6,16(sp)
    80202cf4:	e45e                	sd	s7,8(sp)
    80202cf6:	0880                	addi	s0,sp,80
	pte_t *pte;
	uint64 pa, i;
	uint flags;
	char *mem;

	for (i = 0; i < max_page * PAGE_SIZE; i += PGSIZE) {
    80202cf8:	00c61a93          	slli	s5,a2,0xc
    80202cfc:	080a8e63          	beqz	s5,80202d98 <uvmcopy+0xb6>
    80202d00:	8b2e                	mv	s6,a1
    80202d02:	8a2a                	mv	s4,a0
    80202d04:	4481                	li	s1,0
    80202d06:	a029                	j	80202d10 <uvmcopy+0x2e>
    80202d08:	6785                	lui	a5,0x1
    80202d0a:	94be                	add	s1,s1,a5
    80202d0c:	0754fa63          	bgeu	s1,s5,80202d80 <uvmcopy+0x9e>
		if ((pte = walk(old, i, 0)) == 0)
    80202d10:	4601                	li	a2,0
    80202d12:	85a6                	mv	a1,s1
    80202d14:	8552                	mv	a0,s4
    80202d16:	00000097          	auipc	ra,0x0
    80202d1a:	944080e7          	jalr	-1724(ra) # 8020265a <walk>
    80202d1e:	d56d                	beqz	a0,80202d08 <uvmcopy+0x26>
			continue;
		if ((*pte & PTE_V) == 0)
    80202d20:	6118                	ld	a4,0(a0)
    80202d22:	00177793          	andi	a5,a4,1
    80202d26:	d3ed                	beqz	a5,80202d08 <uvmcopy+0x26>
			continue;
		pa = PTE2PA(*pte);
    80202d28:	00a75793          	srli	a5,a4,0xa
    80202d2c:	00c79b93          	slli	s7,a5,0xc
		flags = PTE_FLAGS(*pte);
    80202d30:	3ff77913          	andi	s2,a4,1023
		if ((mem = kalloc()) == 0)
    80202d34:	00001097          	auipc	ra,0x1
    80202d38:	5a4080e7          	jalr	1444(ra) # 802042d8 <kalloc>
    80202d3c:	89aa                	mv	s3,a0
    80202d3e:	c515                	beqz	a0,80202d6a <uvmcopy+0x88>
			goto err;
		memmove(mem, (char *)pa, PGSIZE);
    80202d40:	6605                	lui	a2,0x1
    80202d42:	85de                	mv	a1,s7
    80202d44:	ffffd097          	auipc	ra,0xffffd
    80202d48:	400080e7          	jalr	1024(ra) # 80200144 <memmove>
		if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80202d4c:	874a                	mv	a4,s2
    80202d4e:	86ce                	mv	a3,s3
    80202d50:	6605                	lui	a2,0x1
    80202d52:	85a6                	mv	a1,s1
    80202d54:	855a                	mv	a0,s6
    80202d56:	00000097          	auipc	ra,0x0
    80202d5a:	a48080e7          	jalr	-1464(ra) # 8020279e <mappages>
    80202d5e:	d54d                	beqz	a0,80202d08 <uvmcopy+0x26>
			kfree(mem);
    80202d60:	854e                	mv	a0,s3
    80202d62:	00001097          	auipc	ra,0x1
    80202d66:	478080e7          	jalr	1144(ra) # 802041da <kfree>
		}
	}
	return 0;

err:
	uvmunmap(new, 0, i / PGSIZE, 1);
    80202d6a:	4685                	li	a3,1
    80202d6c:	00c4d613          	srli	a2,s1,0xc
    80202d70:	4581                	li	a1,0
    80202d72:	855a                	mv	a0,s6
    80202d74:	00000097          	auipc	ra,0x0
    80202d78:	cc8080e7          	jalr	-824(ra) # 80202a3c <uvmunmap>
	return -1;
    80202d7c:	557d                	li	a0,-1
    80202d7e:	a011                	j	80202d82 <uvmcopy+0xa0>
	return 0;
    80202d80:	4501                	li	a0,0
}
    80202d82:	60a6                	ld	ra,72(sp)
    80202d84:	6406                	ld	s0,64(sp)
    80202d86:	74e2                	ld	s1,56(sp)
    80202d88:	7942                	ld	s2,48(sp)
    80202d8a:	79a2                	ld	s3,40(sp)
    80202d8c:	7a02                	ld	s4,32(sp)
    80202d8e:	6ae2                	ld	s5,24(sp)
    80202d90:	6b42                	ld	s6,16(sp)
    80202d92:	6ba2                	ld	s7,8(sp)
    80202d94:	6161                	addi	sp,sp,80
    80202d96:	8082                	ret
	return 0;
    80202d98:	4501                	li	a0,0
    80202d9a:	b7e5                	j	80202d82 <uvmcopy+0xa0>

0000000080202d9c <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80202d9c:	c6bd                	beqz	a3,80202e0a <copyout+0x6e>
{
    80202d9e:	715d                	addi	sp,sp,-80
    80202da0:	e486                	sd	ra,72(sp)
    80202da2:	e0a2                	sd	s0,64(sp)
    80202da4:	fc26                	sd	s1,56(sp)
    80202da6:	f84a                	sd	s2,48(sp)
    80202da8:	f44e                	sd	s3,40(sp)
    80202daa:	f052                	sd	s4,32(sp)
    80202dac:	ec56                	sd	s5,24(sp)
    80202dae:	e85a                	sd	s6,16(sp)
    80202db0:	e45e                	sd	s7,8(sp)
    80202db2:	e062                	sd	s8,0(sp)
    80202db4:	0880                	addi	s0,sp,80
    80202db6:	8baa                	mv	s7,a0
    80202db8:	8a2e                	mv	s4,a1
    80202dba:	8ab2                	mv	s5,a2
    80202dbc:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(dstva);
    80202dbe:	7c7d                	lui	s8,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (dstva - va0);
    80202dc0:	6b05                	lui	s6,0x1
    80202dc2:	a015                	j	80202de6 <copyout+0x4a>
		if (n > len)
			n = len;
		memmove((void *)(pa0 + (dstva - va0)), src, n);
    80202dc4:	9552                	add	a0,a0,s4
    80202dc6:	0004861b          	sext.w	a2,s1
    80202dca:	85d6                	mv	a1,s5
    80202dcc:	41250533          	sub	a0,a0,s2
    80202dd0:	ffffd097          	auipc	ra,0xffffd
    80202dd4:	374080e7          	jalr	884(ra) # 80200144 <memmove>

		len -= n;
    80202dd8:	409989b3          	sub	s3,s3,s1
		src += n;
    80202ddc:	9aa6                	add	s5,s5,s1
		dstva = va0 + PGSIZE;
    80202dde:	01690a33          	add	s4,s2,s6
	while (len > 0) {
    80202de2:	02098263          	beqz	s3,80202e06 <copyout+0x6a>
		va0 = PGROUNDDOWN(dstva);
    80202de6:	018a7933          	and	s2,s4,s8
		pa0 = walkaddr(pagetable, va0);
    80202dea:	85ca                	mv	a1,s2
    80202dec:	855e                	mv	a0,s7
    80202dee:	00000097          	auipc	ra,0x0
    80202df2:	946080e7          	jalr	-1722(ra) # 80202734 <walkaddr>
		if (pa0 == 0)
    80202df6:	cd01                	beqz	a0,80202e0e <copyout+0x72>
		n = PGSIZE - (dstva - va0);
    80202df8:	414904b3          	sub	s1,s2,s4
    80202dfc:	94da                	add	s1,s1,s6
		if (n > len)
    80202dfe:	fc99f3e3          	bgeu	s3,s1,80202dc4 <copyout+0x28>
    80202e02:	84ce                	mv	s1,s3
    80202e04:	b7c1                	j	80202dc4 <copyout+0x28>
	}
	return 0;
    80202e06:	4501                	li	a0,0
    80202e08:	a021                	j	80202e10 <copyout+0x74>
    80202e0a:	4501                	li	a0,0
}
    80202e0c:	8082                	ret
			return -1;
    80202e0e:	557d                	li	a0,-1
}
    80202e10:	60a6                	ld	ra,72(sp)
    80202e12:	6406                	ld	s0,64(sp)
    80202e14:	74e2                	ld	s1,56(sp)
    80202e16:	7942                	ld	s2,48(sp)
    80202e18:	79a2                	ld	s3,40(sp)
    80202e1a:	7a02                	ld	s4,32(sp)
    80202e1c:	6ae2                	ld	s5,24(sp)
    80202e1e:	6b42                	ld	s6,16(sp)
    80202e20:	6ba2                	ld	s7,8(sp)
    80202e22:	6c02                	ld	s8,0(sp)
    80202e24:	6161                	addi	sp,sp,80
    80202e26:	8082                	ret

0000000080202e28 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80202e28:	caa5                	beqz	a3,80202e98 <copyin+0x70>
{
    80202e2a:	715d                	addi	sp,sp,-80
    80202e2c:	e486                	sd	ra,72(sp)
    80202e2e:	e0a2                	sd	s0,64(sp)
    80202e30:	fc26                	sd	s1,56(sp)
    80202e32:	f84a                	sd	s2,48(sp)
    80202e34:	f44e                	sd	s3,40(sp)
    80202e36:	f052                	sd	s4,32(sp)
    80202e38:	ec56                	sd	s5,24(sp)
    80202e3a:	e85a                	sd	s6,16(sp)
    80202e3c:	e45e                	sd	s7,8(sp)
    80202e3e:	e062                	sd	s8,0(sp)
    80202e40:	0880                	addi	s0,sp,80
    80202e42:	8baa                	mv	s7,a0
    80202e44:	8aae                	mv	s5,a1
    80202e46:	8a32                	mv	s4,a2
    80202e48:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(srcva);
    80202e4a:	7c7d                	lui	s8,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80202e4c:	6b05                	lui	s6,0x1
    80202e4e:	a01d                	j	80202e74 <copyin+0x4c>
		if (n > len)
			n = len;
		memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80202e50:	014505b3          	add	a1,a0,s4
    80202e54:	0004861b          	sext.w	a2,s1
    80202e58:	412585b3          	sub	a1,a1,s2
    80202e5c:	8556                	mv	a0,s5
    80202e5e:	ffffd097          	auipc	ra,0xffffd
    80202e62:	2e6080e7          	jalr	742(ra) # 80200144 <memmove>

		len -= n;
    80202e66:	409989b3          	sub	s3,s3,s1
		dst += n;
    80202e6a:	9aa6                	add	s5,s5,s1
		srcva = va0 + PGSIZE;
    80202e6c:	01690a33          	add	s4,s2,s6
	while (len > 0) {
    80202e70:	02098263          	beqz	s3,80202e94 <copyin+0x6c>
		va0 = PGROUNDDOWN(srcva);
    80202e74:	018a7933          	and	s2,s4,s8
		pa0 = walkaddr(pagetable, va0);
    80202e78:	85ca                	mv	a1,s2
    80202e7a:	855e                	mv	a0,s7
    80202e7c:	00000097          	auipc	ra,0x0
    80202e80:	8b8080e7          	jalr	-1864(ra) # 80202734 <walkaddr>
		if (pa0 == 0)
    80202e84:	cd01                	beqz	a0,80202e9c <copyin+0x74>
		n = PGSIZE - (srcva - va0);
    80202e86:	414904b3          	sub	s1,s2,s4
    80202e8a:	94da                	add	s1,s1,s6
		if (n > len)
    80202e8c:	fc99f2e3          	bgeu	s3,s1,80202e50 <copyin+0x28>
    80202e90:	84ce                	mv	s1,s3
    80202e92:	bf7d                	j	80202e50 <copyin+0x28>
	}
	return 0;
    80202e94:	4501                	li	a0,0
    80202e96:	a021                	j	80202e9e <copyin+0x76>
    80202e98:	4501                	li	a0,0
}
    80202e9a:	8082                	ret
			return -1;
    80202e9c:	557d                	li	a0,-1
}
    80202e9e:	60a6                	ld	ra,72(sp)
    80202ea0:	6406                	ld	s0,64(sp)
    80202ea2:	74e2                	ld	s1,56(sp)
    80202ea4:	7942                	ld	s2,48(sp)
    80202ea6:	79a2                	ld	s3,40(sp)
    80202ea8:	7a02                	ld	s4,32(sp)
    80202eaa:	6ae2                	ld	s5,24(sp)
    80202eac:	6b42                	ld	s6,16(sp)
    80202eae:	6ba2                	ld	s7,8(sp)
    80202eb0:	6c02                	ld	s8,0(sp)
    80202eb2:	6161                	addi	sp,sp,80
    80202eb4:	8082                	ret

0000000080202eb6 <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80202eb6:	711d                	addi	sp,sp,-96
    80202eb8:	ec86                	sd	ra,88(sp)
    80202eba:	e8a2                	sd	s0,80(sp)
    80202ebc:	e4a6                	sd	s1,72(sp)
    80202ebe:	e0ca                	sd	s2,64(sp)
    80202ec0:	fc4e                	sd	s3,56(sp)
    80202ec2:	f852                	sd	s4,48(sp)
    80202ec4:	f456                	sd	s5,40(sp)
    80202ec6:	f05a                	sd	s6,32(sp)
    80202ec8:	ec5e                	sd	s7,24(sp)
    80202eca:	e862                	sd	s8,16(sp)
    80202ecc:	e466                	sd	s9,8(sp)
    80202ece:	1080                	addi	s0,sp,96
	uint64 n, va0, pa0;
	int got_null = 0, len = 0;

	while (got_null == 0 && max > 0) {
    80202ed0:	ced9                	beqz	a3,80202f6e <copyinstr+0xb8>
    80202ed2:	8b2a                	mv	s6,a0
    80202ed4:	84ae                	mv	s1,a1
    80202ed6:	8cb2                	mv	s9,a2
    80202ed8:	8936                	mv	s2,a3
	int got_null = 0, len = 0;
    80202eda:	4c01                	li	s8,0
		va0 = PGROUNDDOWN(srcva);
    80202edc:	7afd                	lui	s5,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80202ede:	6a05                	lui	s4,0x1
    80202ee0:	4b85                	li	s7,1
    80202ee2:	a801                	j	80202ef2 <copyinstr+0x3c>
		if (n > max)
			n = max;

		char *p = (char *)(pa0 + (srcva - va0));
		while (n > 0) {
			if (*p == '\0') {
    80202ee4:	87a6                	mv	a5,s1
    80202ee6:	a0a5                	j	80202f4e <copyinstr+0x98>
				*dst = *p;
			}
			--n;
			--max;
			p++;
			dst++;
    80202ee8:	84b2                	mv	s1,a2
			len++;
		}

		srcva = va0 + PGSIZE;
    80202eea:	01498cb3          	add	s9,s3,s4
	while (got_null == 0 && max > 0) {
    80202eee:	06090263          	beqz	s2,80202f52 <copyinstr+0x9c>
		va0 = PGROUNDDOWN(srcva);
    80202ef2:	015cf9b3          	and	s3,s9,s5
		pa0 = walkaddr(pagetable, va0);
    80202ef6:	85ce                	mv	a1,s3
    80202ef8:	855a                	mv	a0,s6
    80202efa:	00000097          	auipc	ra,0x0
    80202efe:	83a080e7          	jalr	-1990(ra) # 80202734 <walkaddr>
		if (pa0 == 0)
    80202f02:	c925                	beqz	a0,80202f72 <copyinstr+0xbc>
		n = PGSIZE - (srcva - va0);
    80202f04:	41998633          	sub	a2,s3,s9
    80202f08:	9652                	add	a2,a2,s4
		if (n > max)
    80202f0a:	00c97363          	bgeu	s2,a2,80202f10 <copyinstr+0x5a>
    80202f0e:	864a                	mv	a2,s2
		char *p = (char *)(pa0 + (srcva - va0));
    80202f10:	9566                	add	a0,a0,s9
    80202f12:	41350533          	sub	a0,a0,s3
		while (n > 0) {
    80202f16:	da71                	beqz	a2,80202eea <copyinstr+0x34>
			if (*p == '\0') {
    80202f18:	00054703          	lbu	a4,0(a0)
    80202f1c:	d761                	beqz	a4,80202ee4 <copyinstr+0x2e>
    80202f1e:	9626                	add	a2,a2,s1
    80202f20:	87a6                	mv	a5,s1
    80202f22:	197d                	addi	s2,s2,-1
    80202f24:	009905b3          	add	a1,s2,s1
    80202f28:	409b86b3          	sub	a3,s7,s1
    80202f2c:	96aa                	add	a3,a3,a0
    80202f2e:	409c04bb          	subw	s1,s8,s1
				*dst = *p;
    80202f32:	00e78023          	sb	a4,0(a5) # 1000 <BASE_ADDRESS-0x801ff000>
			--max;
    80202f36:	40f58933          	sub	s2,a1,a5
			p++;
    80202f3a:	00f68733          	add	a4,a3,a5
			dst++;
    80202f3e:	0785                	addi	a5,a5,1
			len++;
    80202f40:	00f48c3b          	addw	s8,s1,a5
		while (n > 0) {
    80202f44:	fac782e3          	beq	a5,a2,80202ee8 <copyinstr+0x32>
			if (*p == '\0') {
    80202f48:	00074703          	lbu	a4,0(a4) # 2000 <BASE_ADDRESS-0x801fe000>
    80202f4c:	f37d                	bnez	a4,80202f32 <copyinstr+0x7c>
				*dst = '\0';
    80202f4e:	00078023          	sb	zero,0(a5)
	}
	return len;
}
    80202f52:	8562                	mv	a0,s8
    80202f54:	60e6                	ld	ra,88(sp)
    80202f56:	6446                	ld	s0,80(sp)
    80202f58:	64a6                	ld	s1,72(sp)
    80202f5a:	6906                	ld	s2,64(sp)
    80202f5c:	79e2                	ld	s3,56(sp)
    80202f5e:	7a42                	ld	s4,48(sp)
    80202f60:	7aa2                	ld	s5,40(sp)
    80202f62:	7b02                	ld	s6,32(sp)
    80202f64:	6be2                	ld	s7,24(sp)
    80202f66:	6c42                	ld	s8,16(sp)
    80202f68:	6ca2                	ld	s9,8(sp)
    80202f6a:	6125                	addi	sp,sp,96
    80202f6c:	8082                	ret
	int got_null = 0, len = 0;
    80202f6e:	4c01                	li	s8,0
    80202f70:	b7cd                	j	80202f52 <copyinstr+0x9c>
			return -1;
    80202f72:	5c7d                	li	s8,-1
    80202f74:	bff9                	j	80202f52 <copyinstr+0x9c>

0000000080202f76 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, char *src, uint64 len)
{
    80202f76:	7179                	addi	sp,sp,-48
    80202f78:	f406                	sd	ra,40(sp)
    80202f7a:	f022                	sd	s0,32(sp)
    80202f7c:	ec26                	sd	s1,24(sp)
    80202f7e:	e84a                	sd	s2,16(sp)
    80202f80:	e44e                	sd	s3,8(sp)
    80202f82:	e052                	sd	s4,0(sp)
    80202f84:	1800                	addi	s0,sp,48
    80202f86:	84aa                	mv	s1,a0
    80202f88:	892e                	mv	s2,a1
    80202f8a:	89b2                	mv	s3,a2
    80202f8c:	8a36                	mv	s4,a3
	struct proc *p = curr_proc();
    80202f8e:	00001097          	auipc	ra,0x1
    80202f92:	450080e7          	jalr	1104(ra) # 802043de <curr_proc>
	if (user_dst) {
    80202f96:	c08d                	beqz	s1,80202fb8 <either_copyout+0x42>
		return copyout(p->pagetable, dst, src, len);
    80202f98:	86d2                	mv	a3,s4
    80202f9a:	864e                	mv	a2,s3
    80202f9c:	85ca                	mv	a1,s2
    80202f9e:	6508                	ld	a0,8(a0)
    80202fa0:	00000097          	auipc	ra,0x0
    80202fa4:	dfc080e7          	jalr	-516(ra) # 80202d9c <copyout>
	} else {
		memmove((void *)dst, src, len);
		return 0;
	}
}
    80202fa8:	70a2                	ld	ra,40(sp)
    80202faa:	7402                	ld	s0,32(sp)
    80202fac:	64e2                	ld	s1,24(sp)
    80202fae:	6942                	ld	s2,16(sp)
    80202fb0:	69a2                	ld	s3,8(sp)
    80202fb2:	6a02                	ld	s4,0(sp)
    80202fb4:	6145                	addi	sp,sp,48
    80202fb6:	8082                	ret
		memmove((void *)dst, src, len);
    80202fb8:	000a061b          	sext.w	a2,s4
    80202fbc:	85ce                	mv	a1,s3
    80202fbe:	854a                	mv	a0,s2
    80202fc0:	ffffd097          	auipc	ra,0xffffd
    80202fc4:	184080e7          	jalr	388(ra) # 80200144 <memmove>
		return 0;
    80202fc8:	8526                	mv	a0,s1
    80202fca:	bff9                	j	80202fa8 <either_copyout+0x32>

0000000080202fcc <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(int user_src, uint64 src, char *dst, uint64 len)
{
    80202fcc:	7179                	addi	sp,sp,-48
    80202fce:	f406                	sd	ra,40(sp)
    80202fd0:	f022                	sd	s0,32(sp)
    80202fd2:	ec26                	sd	s1,24(sp)
    80202fd4:	e84a                	sd	s2,16(sp)
    80202fd6:	e44e                	sd	s3,8(sp)
    80202fd8:	e052                	sd	s4,0(sp)
    80202fda:	1800                	addi	s0,sp,48
    80202fdc:	84aa                	mv	s1,a0
    80202fde:	89ae                	mv	s3,a1
    80202fe0:	8932                	mv	s2,a2
    80202fe2:	8a36                	mv	s4,a3
	struct proc *p = curr_proc();
    80202fe4:	00001097          	auipc	ra,0x1
    80202fe8:	3fa080e7          	jalr	1018(ra) # 802043de <curr_proc>
	if (user_src) {
    80202fec:	c08d                	beqz	s1,8020300e <either_copyin+0x42>
		return copyin(p->pagetable, dst, src, len);
    80202fee:	86d2                	mv	a3,s4
    80202ff0:	864e                	mv	a2,s3
    80202ff2:	85ca                	mv	a1,s2
    80202ff4:	6508                	ld	a0,8(a0)
    80202ff6:	00000097          	auipc	ra,0x0
    80202ffa:	e32080e7          	jalr	-462(ra) # 80202e28 <copyin>
	} else {
		memmove(dst, (char *)src, len);
		return 0;
	}
    80202ffe:	70a2                	ld	ra,40(sp)
    80203000:	7402                	ld	s0,32(sp)
    80203002:	64e2                	ld	s1,24(sp)
    80203004:	6942                	ld	s2,16(sp)
    80203006:	69a2                	ld	s3,8(sp)
    80203008:	6a02                	ld	s4,0(sp)
    8020300a:	6145                	addi	sp,sp,48
    8020300c:	8082                	ret
		memmove(dst, (char *)src, len);
    8020300e:	000a061b          	sext.w	a2,s4
    80203012:	85ce                	mv	a1,s3
    80203014:	854a                	mv	a0,s2
    80203016:	ffffd097          	auipc	ra,0xffffd
    8020301a:	12e080e7          	jalr	302(ra) # 80200144 <memmove>
		return 0;
    8020301e:	8526                	mv	a0,s1
    80203020:	bff9                	j	80202ffe <either_copyin+0x32>

0000000080203022 <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    80203022:	7179                	addi	sp,sp,-48
    80203024:	f406                	sd	ra,40(sp)
    80203026:	f022                	sd	s0,32(sp)
    80203028:	ec26                	sd	s1,24(sp)
    8020302a:	e84a                	sd	s2,16(sp)
    8020302c:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    8020302e:	c219                	beqz	a2,80203034 <printint+0x12>
    80203030:	00054d63          	bltz	a0,8020304a <printint+0x28>
		x = -xx;
	else
		x = xx;
    80203034:	2501                	sext.w	a0,a0
    80203036:	4881                	li	a7,0
    80203038:	fd040713          	addi	a4,s0,-48

	i = 0;
    8020303c:	4601                	li	a2,0
	do {
		buf[i++] = digits[x % base];
    8020303e:	2581                	sext.w	a1,a1
    80203040:	00005817          	auipc	a6,0x5
    80203044:	7f880813          	addi	a6,a6,2040 # 80208838 <digits>
    80203048:	a039                	j	80203056 <printint+0x34>
		x = -xx;
    8020304a:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    8020304e:	4885                	li	a7,1
		x = -xx;
    80203050:	b7e5                	j	80203038 <printint+0x16>
	} while ((x /= base) != 0);
    80203052:	853e                	mv	a0,a5
		buf[i++] = digits[x % base];
    80203054:	8636                	mv	a2,a3
    80203056:	0016069b          	addiw	a3,a2,1
    8020305a:	02b577bb          	remuw	a5,a0,a1
    8020305e:	1782                	slli	a5,a5,0x20
    80203060:	9381                	srli	a5,a5,0x20
    80203062:	97c2                	add	a5,a5,a6
    80203064:	0007c783          	lbu	a5,0(a5)
    80203068:	00f70023          	sb	a5,0(a4)
    8020306c:	0705                	addi	a4,a4,1
	} while ((x /= base) != 0);
    8020306e:	02b557bb          	divuw	a5,a0,a1
    80203072:	feb570e3          	bgeu	a0,a1,80203052 <printint+0x30>

	if (sign)
    80203076:	00088b63          	beqz	a7,8020308c <printint+0x6a>
		buf[i++] = '-';
    8020307a:	fe040793          	addi	a5,s0,-32
    8020307e:	96be                	add	a3,a3,a5
    80203080:	02d00793          	li	a5,45
    80203084:	fef68823          	sb	a5,-16(a3)
    80203088:	0026069b          	addiw	a3,a2,2

	while (--i >= 0)
    8020308c:	02d05763          	blez	a3,802030ba <printint+0x98>
    80203090:	fd040793          	addi	a5,s0,-48
    80203094:	00d784b3          	add	s1,a5,a3
    80203098:	fff78913          	addi	s2,a5,-1
    8020309c:	9936                	add	s2,s2,a3
    8020309e:	36fd                	addiw	a3,a3,-1
    802030a0:	1682                	slli	a3,a3,0x20
    802030a2:	9281                	srli	a3,a3,0x20
    802030a4:	40d90933          	sub	s2,s2,a3
		consputc(buf[i]);
    802030a8:	fff4c503          	lbu	a0,-1(s1)
    802030ac:	ffffe097          	auipc	ra,0xffffe
    802030b0:	c8c080e7          	jalr	-884(ra) # 80200d38 <consputc>
    802030b4:	14fd                	addi	s1,s1,-1
	while (--i >= 0)
    802030b6:	ff2499e3          	bne	s1,s2,802030a8 <printint+0x86>
}
    802030ba:	70a2                	ld	ra,40(sp)
    802030bc:	7402                	ld	s0,32(sp)
    802030be:	64e2                	ld	s1,24(sp)
    802030c0:	6942                	ld	s2,16(sp)
    802030c2:	6145                	addi	sp,sp,48
    802030c4:	8082                	ret

00000000802030c6 <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    802030c6:	7131                	addi	sp,sp,-192
    802030c8:	fc86                	sd	ra,120(sp)
    802030ca:	f8a2                	sd	s0,112(sp)
    802030cc:	f4a6                	sd	s1,104(sp)
    802030ce:	f0ca                	sd	s2,96(sp)
    802030d0:	ecce                	sd	s3,88(sp)
    802030d2:	e8d2                	sd	s4,80(sp)
    802030d4:	e4d6                	sd	s5,72(sp)
    802030d6:	e0da                	sd	s6,64(sp)
    802030d8:	fc5e                	sd	s7,56(sp)
    802030da:	f862                	sd	s8,48(sp)
    802030dc:	f466                	sd	s9,40(sp)
    802030de:	f06a                	sd	s10,32(sp)
    802030e0:	ec6e                	sd	s11,24(sp)
    802030e2:	0100                	addi	s0,sp,128
    802030e4:	e40c                	sd	a1,8(s0)
    802030e6:	e810                	sd	a2,16(s0)
    802030e8:	ec14                	sd	a3,24(s0)
    802030ea:	f018                	sd	a4,32(s0)
    802030ec:	f41c                	sd	a5,40(s0)
    802030ee:	03043823          	sd	a6,48(s0)
    802030f2:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    802030f6:	c91d                	beqz	a0,8020312c <printf+0x66>
    802030f8:	8a2a                	mv	s4,a0
		panic("null fmt");

	va_start(ap, fmt);
    802030fa:	00840793          	addi	a5,s0,8
    802030fe:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80203102:	00054503          	lbu	a0,0(a0)
    80203106:	18050563          	beqz	a0,80203290 <printf+0x1ca>
    8020310a:	4481                	li	s1,0
		if (c != '%') {
    8020310c:	02500993          	li	s3,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    80203110:	07000a93          	li	s5,112
	consputc('x');
    80203114:	4cc1                	li	s9,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80203116:	00005b17          	auipc	s6,0x5
    8020311a:	722b0b13          	addi	s6,s6,1826 # 80208838 <digits>
		switch (c) {
    8020311e:	07300c13          	li	s8,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    80203122:	02800d13          	li	s10,40
		switch (c) {
    80203126:	06400b93          	li	s7,100
    8020312a:	a8b1                	j	80203186 <printf+0xc0>
		panic("null fmt");
    8020312c:	00001097          	auipc	ra,0x1
    80203130:	272080e7          	jalr	626(ra) # 8020439e <procid>
    80203134:	84aa                	mv	s1,a0
    80203136:	00001097          	auipc	ra,0x1
    8020313a:	282080e7          	jalr	642(ra) # 802043b8 <threadid>
    8020313e:	02e00813          	li	a6,46
    80203142:	00005797          	auipc	a5,0x5
    80203146:	71678793          	addi	a5,a5,1814 # 80208858 <digits+0x20>
    8020314a:	872a                	mv	a4,a0
    8020314c:	86a6                	mv	a3,s1
    8020314e:	00005617          	auipc	a2,0x5
    80203152:	ec260613          	addi	a2,a2,-318 # 80208010 <e_text+0x10>
    80203156:	45fd                	li	a1,31
    80203158:	00005517          	auipc	a0,0x5
    8020315c:	71050513          	addi	a0,a0,1808 # 80208868 <digits+0x30>
    80203160:	00000097          	auipc	ra,0x0
    80203164:	f66080e7          	jalr	-154(ra) # 802030c6 <printf>
    80203168:	00000097          	auipc	ra,0x0
    8020316c:	176080e7          	jalr	374(ra) # 802032de <shutdown>
			consputc(c);
    80203170:	ffffe097          	auipc	ra,0xffffe
    80203174:	bc8080e7          	jalr	-1080(ra) # 80200d38 <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80203178:	2485                	addiw	s1,s1,1
    8020317a:	009a07b3          	add	a5,s4,s1
    8020317e:	0007c503          	lbu	a0,0(a5)
    80203182:	10050763          	beqz	a0,80203290 <printf+0x1ca>
		if (c != '%') {
    80203186:	ff3515e3          	bne	a0,s3,80203170 <printf+0xaa>
		c = fmt[++i] & 0xff;
    8020318a:	2485                	addiw	s1,s1,1
    8020318c:	009a07b3          	add	a5,s4,s1
    80203190:	0007c783          	lbu	a5,0(a5)
    80203194:	0007891b          	sext.w	s2,a5
		if (c == 0)
    80203198:	0e090c63          	beqz	s2,80203290 <printf+0x1ca>
		switch (c) {
    8020319c:	05578a63          	beq	a5,s5,802031f0 <printf+0x12a>
    802031a0:	02faf663          	bgeu	s5,a5,802031cc <printf+0x106>
    802031a4:	09878963          	beq	a5,s8,80203236 <printf+0x170>
    802031a8:	07800713          	li	a4,120
    802031ac:	0ce79763          	bne	a5,a4,8020327a <printf+0x1b4>
			printint(va_arg(ap, int), 16, 1);
    802031b0:	f8843783          	ld	a5,-120(s0)
    802031b4:	00878713          	addi	a4,a5,8
    802031b8:	f8e43423          	sd	a4,-120(s0)
    802031bc:	4605                	li	a2,1
    802031be:	85e6                	mv	a1,s9
    802031c0:	4388                	lw	a0,0(a5)
    802031c2:	00000097          	auipc	ra,0x0
    802031c6:	e60080e7          	jalr	-416(ra) # 80203022 <printint>
			break;
    802031ca:	b77d                	j	80203178 <printf+0xb2>
		switch (c) {
    802031cc:	0b378163          	beq	a5,s3,8020326e <printf+0x1a8>
    802031d0:	0b779563          	bne	a5,s7,8020327a <printf+0x1b4>
			printint(va_arg(ap, int), 10, 1);
    802031d4:	f8843783          	ld	a5,-120(s0)
    802031d8:	00878713          	addi	a4,a5,8
    802031dc:	f8e43423          	sd	a4,-120(s0)
    802031e0:	4605                	li	a2,1
    802031e2:	45a9                	li	a1,10
    802031e4:	4388                	lw	a0,0(a5)
    802031e6:	00000097          	auipc	ra,0x0
    802031ea:	e3c080e7          	jalr	-452(ra) # 80203022 <printint>
			break;
    802031ee:	b769                	j	80203178 <printf+0xb2>
			printptr(va_arg(ap, uint64));
    802031f0:	f8843783          	ld	a5,-120(s0)
    802031f4:	00878713          	addi	a4,a5,8
    802031f8:	f8e43423          	sd	a4,-120(s0)
    802031fc:	0007bd83          	ld	s11,0(a5)
	consputc('0');
    80203200:	03000513          	li	a0,48
    80203204:	ffffe097          	auipc	ra,0xffffe
    80203208:	b34080e7          	jalr	-1228(ra) # 80200d38 <consputc>
	consputc('x');
    8020320c:	07800513          	li	a0,120
    80203210:	ffffe097          	auipc	ra,0xffffe
    80203214:	b28080e7          	jalr	-1240(ra) # 80200d38 <consputc>
    80203218:	8966                	mv	s2,s9
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8020321a:	03cdd793          	srli	a5,s11,0x3c
    8020321e:	97da                	add	a5,a5,s6
    80203220:	0007c503          	lbu	a0,0(a5)
    80203224:	ffffe097          	auipc	ra,0xffffe
    80203228:	b14080e7          	jalr	-1260(ra) # 80200d38 <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8020322c:	0d92                	slli	s11,s11,0x4
    8020322e:	397d                	addiw	s2,s2,-1
    80203230:	fe0915e3          	bnez	s2,8020321a <printf+0x154>
    80203234:	b791                	j	80203178 <printf+0xb2>
			if ((s = va_arg(ap, char *)) == 0)
    80203236:	f8843783          	ld	a5,-120(s0)
    8020323a:	00878713          	addi	a4,a5,8
    8020323e:	f8e43423          	sd	a4,-120(s0)
    80203242:	0007b903          	ld	s2,0(a5)
    80203246:	00090e63          	beqz	s2,80203262 <printf+0x19c>
			for (; *s; s++)
    8020324a:	00094503          	lbu	a0,0(s2) # 1000 <BASE_ADDRESS-0x801ff000>
    8020324e:	d50d                	beqz	a0,80203178 <printf+0xb2>
				consputc(*s);
    80203250:	ffffe097          	auipc	ra,0xffffe
    80203254:	ae8080e7          	jalr	-1304(ra) # 80200d38 <consputc>
			for (; *s; s++)
    80203258:	0905                	addi	s2,s2,1
    8020325a:	00094503          	lbu	a0,0(s2)
    8020325e:	f96d                	bnez	a0,80203250 <printf+0x18a>
    80203260:	bf21                	j	80203178 <printf+0xb2>
				s = "(null)";
    80203262:	00005917          	auipc	s2,0x5
    80203266:	5ee90913          	addi	s2,s2,1518 # 80208850 <digits+0x18>
			for (; *s; s++)
    8020326a:	856a                	mv	a0,s10
    8020326c:	b7d5                	j	80203250 <printf+0x18a>
			break;
		case '%':
			consputc('%');
    8020326e:	854e                	mv	a0,s3
    80203270:	ffffe097          	auipc	ra,0xffffe
    80203274:	ac8080e7          	jalr	-1336(ra) # 80200d38 <consputc>
			break;
    80203278:	b701                	j	80203178 <printf+0xb2>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    8020327a:	854e                	mv	a0,s3
    8020327c:	ffffe097          	auipc	ra,0xffffe
    80203280:	abc080e7          	jalr	-1348(ra) # 80200d38 <consputc>
			consputc(c);
    80203284:	854a                	mv	a0,s2
    80203286:	ffffe097          	auipc	ra,0xffffe
    8020328a:	ab2080e7          	jalr	-1358(ra) # 80200d38 <consputc>
			break;
    8020328e:	b5ed                	j	80203178 <printf+0xb2>
		}
	}
    80203290:	70e6                	ld	ra,120(sp)
    80203292:	7446                	ld	s0,112(sp)
    80203294:	74a6                	ld	s1,104(sp)
    80203296:	7906                	ld	s2,96(sp)
    80203298:	69e6                	ld	s3,88(sp)
    8020329a:	6a46                	ld	s4,80(sp)
    8020329c:	6aa6                	ld	s5,72(sp)
    8020329e:	6b06                	ld	s6,64(sp)
    802032a0:	7be2                	ld	s7,56(sp)
    802032a2:	7c42                	ld	s8,48(sp)
    802032a4:	7ca2                	ld	s9,40(sp)
    802032a6:	7d02                	ld	s10,32(sp)
    802032a8:	6de2                	ld	s11,24(sp)
    802032aa:	6129                	addi	sp,sp,192
    802032ac:	8082                	ret

00000000802032ae <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    802032ae:	1141                	addi	sp,sp,-16
    802032b0:	e422                	sd	s0,8(sp)
    802032b2:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802032b4:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802032b6:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802032b8:	4885                	li	a7,1
	asm volatile("ecall"
    802032ba:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    802032be:	6422                	ld	s0,8(sp)
    802032c0:	0141                	addi	sp,sp,16
    802032c2:	8082                	ret

00000000802032c4 <console_getchar>:

int console_getchar()
{
    802032c4:	1141                	addi	sp,sp,-16
    802032c6:	e422                	sd	s0,8(sp)
    802032c8:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802032ca:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802032cc:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802032ce:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802032d0:	4889                	li	a7,2
	asm volatile("ecall"
    802032d2:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    802032d6:	2501                	sext.w	a0,a0
    802032d8:	6422                	ld	s0,8(sp)
    802032da:	0141                	addi	sp,sp,16
    802032dc:	8082                	ret

00000000802032de <shutdown>:

void shutdown()
{
    802032de:	1141                	addi	sp,sp,-16
    802032e0:	e422                	sd	s0,8(sp)
    802032e2:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802032e4:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802032e6:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802032e8:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802032ea:	48a1                	li	a7,8
	asm volatile("ecall"
    802032ec:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    802032f0:	6422                	ld	s0,8(sp)
    802032f2:	0141                	addi	sp,sp,16
    802032f4:	8082                	ret

00000000802032f6 <set_timer>:

void set_timer(uint64 stime)
{
    802032f6:	1141                	addi	sp,sp,-16
    802032f8:	e422                	sd	s0,8(sp)
    802032fa:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802032fc:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802032fe:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80203300:	4881                	li	a7,0
	asm volatile("ecall"
    80203302:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    80203306:	6422                	ld	s0,8(sp)
    80203308:	0141                	addi	sp,sp,16
    8020330a:	8082                	ret

000000008020330c <mutex_create>:
#include "defs.h"
#include "proc.h"
#include "sync.h"

struct mutex *mutex_create(int blocking)
{
    8020330c:	1101                	addi	sp,sp,-32
    8020330e:	ec06                	sd	ra,24(sp)
    80203310:	e822                	sd	s0,16(sp)
    80203312:	e426                	sd	s1,8(sp)
    80203314:	e04a                	sd	s2,0(sp)
    80203316:	1000                	addi	s0,sp,32
    80203318:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    8020331a:	00001097          	auipc	ra,0x1
    8020331e:	0c4080e7          	jalr	196(ra) # 802043de <curr_proc>
	if (p->next_mutex_id >= LOCK_POOL_SIZE) {
    80203322:	6785                	lui	a5,0x1
    80203324:	97aa                	add	a5,a5,a0
    80203326:	ab07a703          	lw	a4,-1360(a5) # ab0 <BASE_ADDRESS-0x801ff550>
    8020332a:	479d                	li	a5,7
    8020332c:	06e7e363          	bltu	a5,a4,80203392 <mutex_create+0x86>
		return NULL;
	}
	struct mutex *m = &p->mutex_pool[p->next_mutex_id];
    80203330:	02071613          	slli	a2,a4,0x20
    80203334:	9201                	srli	a2,a2,0x20
    80203336:	00161793          	slli	a5,a2,0x1
    8020333a:	00c785b3          	add	a1,a5,a2
    8020333e:	0596                	slli	a1,a1,0x5
    80203340:	6685                	lui	a3,0x1
    80203342:	ac068493          	addi	s1,a3,-1344 # ac0 <BASE_ADDRESS-0x801ff540>
    80203346:	94ae                	add	s1,s1,a1
    80203348:	94aa                	add	s1,s1,a0
	p->next_mutex_id++;
    8020334a:	00d50833          	add	a6,a0,a3
    8020334e:	2705                	addiw	a4,a4,1
    80203350:	aae82823          	sw	a4,-1360(a6)
	m->blocking = blocking;
    80203354:	00b50733          	add	a4,a0,a1
    80203358:	9736                	add	a4,a4,a3
    8020335a:	ad272023          	sw	s2,-1344(a4)
	m->locked = 0;
    8020335e:	ac072223          	sw	zero,-1340(a4)
	if (blocking) {
    80203362:	00091963          	bnez	s2,80203374 <mutex_create+0x68>
		// blocking mutex need wait queue but spinning mutex not
		init_queue(&m->wait_queue, WAIT_QUEUE_MAX_LENGTH,
			   m->_wait_queue_data);
	}
	return m;
}
    80203366:	8526                	mv	a0,s1
    80203368:	60e2                	ld	ra,24(sp)
    8020336a:	6442                	ld	s0,16(sp)
    8020336c:	64a2                	ld	s1,8(sp)
    8020336e:	6902                	ld	s2,0(sp)
    80203370:	6105                	addi	sp,sp,32
    80203372:	8082                	ret
			   m->_wait_queue_data);
    80203374:	6785                	lui	a5,0x1
    80203376:	ae078613          	addi	a2,a5,-1312 # ae0 <BASE_ADDRESS-0x801ff520>
    8020337a:	962e                	add	a2,a2,a1
		init_queue(&m->wait_queue, WAIT_QUEUE_MAX_LENGTH,
    8020337c:	ac878793          	addi	a5,a5,-1336
    80203380:	97ae                	add	a5,a5,a1
    80203382:	962a                	add	a2,a2,a0
    80203384:	45c1                	li	a1,16
    80203386:	953e                	add	a0,a0,a5
    80203388:	ffffd097          	auipc	ra,0xffffd
    8020338c:	c84080e7          	jalr	-892(ra) # 8020000c <init_queue>
    80203390:	bfd9                	j	80203366 <mutex_create+0x5a>
		return NULL;
    80203392:	4481                	li	s1,0
    80203394:	bfc9                	j	80203366 <mutex_create+0x5a>

0000000080203396 <mutex_lock>:

void mutex_lock(struct mutex *m)
{
    80203396:	1101                	addi	sp,sp,-32
    80203398:	ec06                	sd	ra,24(sp)
    8020339a:	e822                	sd	s0,16(sp)
    8020339c:	e426                	sd	s1,8(sp)
    8020339e:	e04a                	sd	s2,0(sp)
    802033a0:	1000                	addi	s0,sp,32
    802033a2:	84aa                	mv	s1,a0
	if (!m->locked) {
    802033a4:	415c                	lw	a5,4(a0)
    802033a6:	cbb1                	beqz	a5,802033fa <mutex_lock+0x64>
		m->locked = 1;
		debugf("lock a free mutex");
		return;
	}
	if (!m->blocking) {
    802033a8:	411c                	lw	a5,0(a0)
    802033aa:	c3a5                	beqz	a5,8020340a <mutex_lock+0x74>
		}
		debugf("lock spin mutex after some trials");
		return;
	}
	// blocking mutex will wait in the queue
	struct thread *t = curr_thread();
    802033ac:	00001097          	auipc	ra,0x1
    802033b0:	04a080e7          	jalr	74(ra) # 802043f6 <curr_thread>
    802033b4:	892a                	mv	s2,a0
	push_queue(&m->wait_queue, task_to_id(t));
    802033b6:	00001097          	auipc	ra,0x1
    802033ba:	178080e7          	jalr	376(ra) # 8020452e <task_to_id>
    802033be:	85aa                	mv	a1,a0
    802033c0:	00848513          	addi	a0,s1,8
    802033c4:	ffffd097          	auipc	ra,0xffffd
    802033c8:	c64080e7          	jalr	-924(ra) # 80200028 <push_queue>
	// don't forget to change thread state to SLEEPING
	t->state = SLEEPING;
    802033cc:	4789                	li	a5,2
    802033ce:	00f92023          	sw	a5,0(s2)
	debugf("block to wait for mutex");
    802033d2:	4501                	li	a0,0
    802033d4:	ffffd097          	auipc	ra,0xffffd
    802033d8:	ed8080e7          	jalr	-296(ra) # 802002ac <dummy>
	sched();
    802033dc:	00001097          	auipc	ra,0x1
    802033e0:	6a4080e7          	jalr	1700(ra) # 80204a80 <sched>
	debugf("blocking mutex passed to me");
    802033e4:	4501                	li	a0,0
    802033e6:	ffffd097          	auipc	ra,0xffffd
    802033ea:	ec6080e7          	jalr	-314(ra) # 802002ac <dummy>
	// here lock is released (with locked = 1) and passed to me, so just do nothing
}
    802033ee:	60e2                	ld	ra,24(sp)
    802033f0:	6442                	ld	s0,16(sp)
    802033f2:	64a2                	ld	s1,8(sp)
    802033f4:	6902                	ld	s2,0(sp)
    802033f6:	6105                	addi	sp,sp,32
    802033f8:	8082                	ret
		m->locked = 1;
    802033fa:	4785                	li	a5,1
    802033fc:	c15c                	sw	a5,4(a0)
		debugf("lock a free mutex");
    802033fe:	4501                	li	a0,0
    80203400:	ffffd097          	auipc	ra,0xffffd
    80203404:	eac080e7          	jalr	-340(ra) # 802002ac <dummy>
		return;
    80203408:	b7dd                	j	802033ee <mutex_lock+0x58>
		debugf("try to lock spin mutex");
    8020340a:	4501                	li	a0,0
    8020340c:	ffffd097          	auipc	ra,0xffffd
    80203410:	ea0080e7          	jalr	-352(ra) # 802002ac <dummy>
		while (m->locked) {
    80203414:	40dc                	lw	a5,4(s1)
    80203416:	c799                	beqz	a5,80203424 <mutex_lock+0x8e>
			yield();
    80203418:	00001097          	auipc	ra,0x1
    8020341c:	6dc080e7          	jalr	1756(ra) # 80204af4 <yield>
		while (m->locked) {
    80203420:	40dc                	lw	a5,4(s1)
    80203422:	fbfd                	bnez	a5,80203418 <mutex_lock+0x82>
		debugf("lock spin mutex after some trials");
    80203424:	4501                	li	a0,0
    80203426:	ffffd097          	auipc	ra,0xffffd
    8020342a:	e86080e7          	jalr	-378(ra) # 802002ac <dummy>
		return;
    8020342e:	b7c1                	j	802033ee <mutex_lock+0x58>

0000000080203430 <mutex_unlock>:

void mutex_unlock(struct mutex *m)
{
    80203430:	1101                	addi	sp,sp,-32
    80203432:	ec06                	sd	ra,24(sp)
    80203434:	e822                	sd	s0,16(sp)
    80203436:	e426                	sd	s1,8(sp)
    80203438:	e04a                	sd	s2,0(sp)
    8020343a:	1000                	addi	s0,sp,32
    8020343c:	84aa                	mv	s1,a0
	if (m->blocking) {
    8020343e:	411c                	lw	a5,0(a0)
    80203440:	c3b1                	beqz	a5,80203484 <mutex_unlock+0x54>
		struct thread *t = id_to_task(pop_queue(&m->wait_queue));
    80203442:	0521                	addi	a0,a0,8
    80203444:	ffffd097          	auipc	ra,0xffffd
    80203448:	c58080e7          	jalr	-936(ra) # 8020009c <pop_queue>
    8020344c:	00001097          	auipc	ra,0x1
    80203450:	09a080e7          	jalr	154(ra) # 802044e6 <id_to_task>
    80203454:	892a                	mv	s2,a0
		if (t == NULL) {
    80203456:	cd19                	beqz	a0,80203474 <mutex_unlock+0x44>
			// Without waiting thread, just release the lock
			m->locked = 0;
			debugf("blocking mutex released");
		} else {
			// Or we should give lock to next thread
			t->state = RUNNABLE;
    80203458:	478d                	li	a5,3
    8020345a:	c11c                	sw	a5,0(a0)
			add_task(t);
    8020345c:	00001097          	auipc	ra,0x1
    80203460:	15a080e7          	jalr	346(ra) # 802045b6 <add_task>
			debugf("blocking mutex passed to thread %d", t->tid);
    80203464:	00492583          	lw	a1,4(s2)
    80203468:	4501                	li	a0,0
    8020346a:	ffffd097          	auipc	ra,0xffffd
    8020346e:	e42080e7          	jalr	-446(ra) # 802002ac <dummy>
    80203472:	a005                	j	80203492 <mutex_unlock+0x62>
			m->locked = 0;
    80203474:	0004a223          	sw	zero,4(s1)
			debugf("blocking mutex released");
    80203478:	4501                	li	a0,0
    8020347a:	ffffd097          	auipc	ra,0xffffd
    8020347e:	e32080e7          	jalr	-462(ra) # 802002ac <dummy>
    80203482:	a801                	j	80203492 <mutex_unlock+0x62>
		}
	} else {
		m->locked = 0;
    80203484:	00052223          	sw	zero,4(a0)
		debugf("spin mutex unlocked");
    80203488:	4501                	li	a0,0
    8020348a:	ffffd097          	auipc	ra,0xffffd
    8020348e:	e22080e7          	jalr	-478(ra) # 802002ac <dummy>
	}
}
    80203492:	60e2                	ld	ra,24(sp)
    80203494:	6442                	ld	s0,16(sp)
    80203496:	64a2                	ld	s1,8(sp)
    80203498:	6902                	ld	s2,0(sp)
    8020349a:	6105                	addi	sp,sp,32
    8020349c:	8082                	ret

000000008020349e <semaphore_create>:

struct semaphore *semaphore_create(int count)
{
    8020349e:	1101                	addi	sp,sp,-32
    802034a0:	ec06                	sd	ra,24(sp)
    802034a2:	e822                	sd	s0,16(sp)
    802034a4:	e426                	sd	s1,8(sp)
    802034a6:	e04a                	sd	s2,0(sp)
    802034a8:	1000                	addi	s0,sp,32
    802034aa:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    802034ac:	00001097          	auipc	ra,0x1
    802034b0:	f32080e7          	jalr	-206(ra) # 802043de <curr_proc>
	if (p->next_semaphore_id >= LOCK_POOL_SIZE) {
    802034b4:	6785                	lui	a5,0x1
    802034b6:	97aa                	add	a5,a5,a0
    802034b8:	ab47a603          	lw	a2,-1356(a5) # ab4 <BASE_ADDRESS-0x801ff54c>
    802034bc:	479d                	li	a5,7
		return NULL;
    802034be:	4481                	li	s1,0
	if (p->next_semaphore_id >= LOCK_POOL_SIZE) {
    802034c0:	04c7e663          	bltu	a5,a2,8020350c <semaphore_create+0x6e>
	}
	struct semaphore *s = &p->semaphore_pool[p->next_semaphore_id];
    802034c4:	02061593          	slli	a1,a2,0x20
    802034c8:	9181                	srli	a1,a1,0x20
    802034ca:	00159793          	slli	a5,a1,0x1
    802034ce:	00b78733          	add	a4,a5,a1
    802034d2:	0716                	slli	a4,a4,0x5
    802034d4:	6685                	lui	a3,0x1
    802034d6:	dc068493          	addi	s1,a3,-576 # dc0 <BASE_ADDRESS-0x801ff240>
    802034da:	94ba                	add	s1,s1,a4
    802034dc:	94aa                	add	s1,s1,a0
	p->next_semaphore_id++;
    802034de:	00d50833          	add	a6,a0,a3
    802034e2:	2605                	addiw	a2,a2,1
    802034e4:	aac82a23          	sw	a2,-1356(a6)
	s->count = count;
    802034e8:	00e507b3          	add	a5,a0,a4
    802034ec:	97b6                	add	a5,a5,a3
    802034ee:	dd27a023          	sw	s2,-576(a5)
	init_queue(&s->wait_queue, WAIT_QUEUE_MAX_LENGTH, s->_wait_queue_data);
    802034f2:	de068613          	addi	a2,a3,-544
    802034f6:	963a                	add	a2,a2,a4
    802034f8:	dc868693          	addi	a3,a3,-568
    802034fc:	9736                	add	a4,a4,a3
    802034fe:	962a                	add	a2,a2,a0
    80203500:	45c1                	li	a1,16
    80203502:	953a                	add	a0,a0,a4
    80203504:	ffffd097          	auipc	ra,0xffffd
    80203508:	b08080e7          	jalr	-1272(ra) # 8020000c <init_queue>
	return s;
}
    8020350c:	8526                	mv	a0,s1
    8020350e:	60e2                	ld	ra,24(sp)
    80203510:	6442                	ld	s0,16(sp)
    80203512:	64a2                	ld	s1,8(sp)
    80203514:	6902                	ld	s2,0(sp)
    80203516:	6105                	addi	sp,sp,32
    80203518:	8082                	ret

000000008020351a <semaphore_up>:

void semaphore_up(struct semaphore *s)
{
    8020351a:	1101                	addi	sp,sp,-32
    8020351c:	ec06                	sd	ra,24(sp)
    8020351e:	e822                	sd	s0,16(sp)
    80203520:	e426                	sd	s1,8(sp)
    80203522:	1000                	addi	s0,sp,32
    80203524:	84aa                	mv	s1,a0
	s->count++;
    80203526:	411c                	lw	a5,0(a0)
    80203528:	2785                	addiw	a5,a5,1
    8020352a:	0007871b          	sext.w	a4,a5
    8020352e:	c11c                	sw	a5,0(a0)
	if (s->count <= 0) {
    80203530:	00e05f63          	blez	a4,8020354e <semaphore_up+0x34>
		}
		t->state = RUNNABLE;
		add_task(t);
		debugf("semaphore up and notify another task");
	}
	debugf("semaphore up from %d to %d", s->count - 1, s->count);
    80203534:	408c                	lw	a1,0(s1)
    80203536:	862e                	mv	a2,a1
    80203538:	35fd                	addiw	a1,a1,-1
    8020353a:	4501                	li	a0,0
    8020353c:	ffffd097          	auipc	ra,0xffffd
    80203540:	d70080e7          	jalr	-656(ra) # 802002ac <dummy>
}
    80203544:	60e2                	ld	ra,24(sp)
    80203546:	6442                	ld	s0,16(sp)
    80203548:	64a2                	ld	s1,8(sp)
    8020354a:	6105                	addi	sp,sp,32
    8020354c:	8082                	ret
		struct thread *t = id_to_task(pop_queue(&s->wait_queue));
    8020354e:	0521                	addi	a0,a0,8
    80203550:	ffffd097          	auipc	ra,0xffffd
    80203554:	b4c080e7          	jalr	-1204(ra) # 8020009c <pop_queue>
    80203558:	00001097          	auipc	ra,0x1
    8020355c:	f8e080e7          	jalr	-114(ra) # 802044e6 <id_to_task>
		if (t == NULL) {
    80203560:	cd09                	beqz	a0,8020357a <semaphore_up+0x60>
		t->state = RUNNABLE;
    80203562:	478d                	li	a5,3
    80203564:	c11c                	sw	a5,0(a0)
		add_task(t);
    80203566:	00001097          	auipc	ra,0x1
    8020356a:	050080e7          	jalr	80(ra) # 802045b6 <add_task>
		debugf("semaphore up and notify another task");
    8020356e:	4501                	li	a0,0
    80203570:	ffffd097          	auipc	ra,0xffffd
    80203574:	d3c080e7          	jalr	-708(ra) # 802002ac <dummy>
    80203578:	bf75                	j	80203534 <semaphore_up+0x1a>
			panic("count <= 0 after up but wait queue is empty?");
    8020357a:	00001097          	auipc	ra,0x1
    8020357e:	e24080e7          	jalr	-476(ra) # 8020439e <procid>
    80203582:	84aa                	mv	s1,a0
    80203584:	00001097          	auipc	ra,0x1
    80203588:	e34080e7          	jalr	-460(ra) # 802043b8 <threadid>
    8020358c:	05a00813          	li	a6,90
    80203590:	00005797          	auipc	a5,0x5
    80203594:	30078793          	addi	a5,a5,768 # 80208890 <digits+0x58>
    80203598:	872a                	mv	a4,a0
    8020359a:	86a6                	mv	a3,s1
    8020359c:	00005617          	auipc	a2,0x5
    802035a0:	a7460613          	addi	a2,a2,-1420 # 80208010 <e_text+0x10>
    802035a4:	45fd                	li	a1,31
    802035a6:	00005517          	auipc	a0,0x5
    802035aa:	2fa50513          	addi	a0,a0,762 # 802088a0 <digits+0x68>
    802035ae:	00000097          	auipc	ra,0x0
    802035b2:	b18080e7          	jalr	-1256(ra) # 802030c6 <printf>
    802035b6:	00000097          	auipc	ra,0x0
    802035ba:	d28080e7          	jalr	-728(ra) # 802032de <shutdown>

00000000802035be <semaphore_down>:

void semaphore_down(struct semaphore *s)
{
    802035be:	1101                	addi	sp,sp,-32
    802035c0:	ec06                	sd	ra,24(sp)
    802035c2:	e822                	sd	s0,16(sp)
    802035c4:	e426                	sd	s1,8(sp)
    802035c6:	e04a                	sd	s2,0(sp)
    802035c8:	1000                	addi	s0,sp,32
    802035ca:	84aa                	mv	s1,a0
	s->count--;
    802035cc:	411c                	lw	a5,0(a0)
    802035ce:	37fd                	addiw	a5,a5,-1
    802035d0:	c11c                	sw	a5,0(a0)
	if (s->count < 0) {
    802035d2:	02079713          	slli	a4,a5,0x20
    802035d6:	00074e63          	bltz	a4,802035f2 <semaphore_down+0x34>
		t->state = SLEEPING;
		debugf("semaphore down to %d and wait...", s->count);
		sched();
		debugf("semaphore up to %d and wake up", s->count);
	}
	debugf("finish semaphore_down with count = %d", s->count);
    802035da:	408c                	lw	a1,0(s1)
    802035dc:	4501                	li	a0,0
    802035de:	ffffd097          	auipc	ra,0xffffd
    802035e2:	cce080e7          	jalr	-818(ra) # 802002ac <dummy>
}
    802035e6:	60e2                	ld	ra,24(sp)
    802035e8:	6442                	ld	s0,16(sp)
    802035ea:	64a2                	ld	s1,8(sp)
    802035ec:	6902                	ld	s2,0(sp)
    802035ee:	6105                	addi	sp,sp,32
    802035f0:	8082                	ret
		struct thread *t = curr_thread();
    802035f2:	00001097          	auipc	ra,0x1
    802035f6:	e04080e7          	jalr	-508(ra) # 802043f6 <curr_thread>
    802035fa:	892a                	mv	s2,a0
		push_queue(&s->wait_queue, task_to_id(t));
    802035fc:	00001097          	auipc	ra,0x1
    80203600:	f32080e7          	jalr	-206(ra) # 8020452e <task_to_id>
    80203604:	85aa                	mv	a1,a0
    80203606:	00848513          	addi	a0,s1,8
    8020360a:	ffffd097          	auipc	ra,0xffffd
    8020360e:	a1e080e7          	jalr	-1506(ra) # 80200028 <push_queue>
		t->state = SLEEPING;
    80203612:	4789                	li	a5,2
    80203614:	00f92023          	sw	a5,0(s2)
		debugf("semaphore down to %d and wait...", s->count);
    80203618:	408c                	lw	a1,0(s1)
    8020361a:	4501                	li	a0,0
    8020361c:	ffffd097          	auipc	ra,0xffffd
    80203620:	c90080e7          	jalr	-880(ra) # 802002ac <dummy>
		sched();
    80203624:	00001097          	auipc	ra,0x1
    80203628:	45c080e7          	jalr	1116(ra) # 80204a80 <sched>
		debugf("semaphore up to %d and wake up", s->count);
    8020362c:	408c                	lw	a1,0(s1)
    8020362e:	4501                	li	a0,0
    80203630:	ffffd097          	auipc	ra,0xffffd
    80203634:	c7c080e7          	jalr	-900(ra) # 802002ac <dummy>
    80203638:	b74d                	j	802035da <semaphore_down+0x1c>

000000008020363a <condvar_create>:

struct condvar *condvar_create()
{
    8020363a:	1101                	addi	sp,sp,-32
    8020363c:	ec06                	sd	ra,24(sp)
    8020363e:	e822                	sd	s0,16(sp)
    80203640:	e426                	sd	s1,8(sp)
    80203642:	1000                	addi	s0,sp,32
	struct proc *p = curr_proc();
    80203644:	00001097          	auipc	ra,0x1
    80203648:	d9a080e7          	jalr	-614(ra) # 802043de <curr_proc>
	if (p->next_condvar_id >= LOCK_POOL_SIZE) {
    8020364c:	6785                	lui	a5,0x1
    8020364e:	97aa                	add	a5,a5,a0
    80203650:	ab87a703          	lw	a4,-1352(a5) # ab8 <BASE_ADDRESS-0x801ff548>
    80203654:	479d                	li	a5,7
		return NULL;
    80203656:	4481                	li	s1,0
	if (p->next_condvar_id >= LOCK_POOL_SIZE) {
    80203658:	02e7ee63          	bltu	a5,a4,80203694 <condvar_create+0x5a>
	}
	struct condvar *c = &p->condvar_pool[p->next_condvar_id];
    8020365c:	02071793          	slli	a5,a4,0x20
    80203660:	9381                	srli	a5,a5,0x20
    80203662:	05800613          	li	a2,88
    80203666:	02c787b3          	mul	a5,a5,a2
    8020366a:	6685                	lui	a3,0x1
    8020366c:	0c068493          	addi	s1,a3,192 # 10c0 <BASE_ADDRESS-0x801fef40>
    80203670:	94be                	add	s1,s1,a5
    80203672:	94aa                	add	s1,s1,a0
	p->next_condvar_id++;
    80203674:	00d50633          	add	a2,a0,a3
    80203678:	2705                	addiw	a4,a4,1
    8020367a:	aae62c23          	sw	a4,-1352(a2)
	init_queue(&c->wait_queue, WAIT_QUEUE_MAX_LENGTH, c->_wait_queue_data);
    8020367e:	0d868693          	addi	a3,a3,216
    80203682:	97b6                	add	a5,a5,a3
    80203684:	00f50633          	add	a2,a0,a5
    80203688:	45c1                	li	a1,16
    8020368a:	8526                	mv	a0,s1
    8020368c:	ffffd097          	auipc	ra,0xffffd
    80203690:	980080e7          	jalr	-1664(ra) # 8020000c <init_queue>
	return c;
}
    80203694:	8526                	mv	a0,s1
    80203696:	60e2                	ld	ra,24(sp)
    80203698:	6442                	ld	s0,16(sp)
    8020369a:	64a2                	ld	s1,8(sp)
    8020369c:	6105                	addi	sp,sp,32
    8020369e:	8082                	ret

00000000802036a0 <cond_signal>:

void cond_signal(struct condvar *cond)
{
    802036a0:	1101                	addi	sp,sp,-32
    802036a2:	ec06                	sd	ra,24(sp)
    802036a4:	e822                	sd	s0,16(sp)
    802036a6:	e426                	sd	s1,8(sp)
    802036a8:	1000                	addi	s0,sp,32
	struct thread *t = id_to_task(pop_queue(&cond->wait_queue));
    802036aa:	ffffd097          	auipc	ra,0xffffd
    802036ae:	9f2080e7          	jalr	-1550(ra) # 8020009c <pop_queue>
    802036b2:	00001097          	auipc	ra,0x1
    802036b6:	e34080e7          	jalr	-460(ra) # 802044e6 <id_to_task>
	if (t) {
    802036ba:	c11d                	beqz	a0,802036e0 <cond_signal+0x40>
    802036bc:	84aa                	mv	s1,a0
		t->state = RUNNABLE;
    802036be:	478d                	li	a5,3
    802036c0:	c11c                	sw	a5,0(a0)
		add_task(t);
    802036c2:	00001097          	auipc	ra,0x1
    802036c6:	ef4080e7          	jalr	-268(ra) # 802045b6 <add_task>
		debugf("signal wake up thread %d", t->tid);
    802036ca:	40cc                	lw	a1,4(s1)
    802036cc:	4501                	li	a0,0
    802036ce:	ffffd097          	auipc	ra,0xffffd
    802036d2:	bde080e7          	jalr	-1058(ra) # 802002ac <dummy>
	} else {
		debugf("dummpy signal");
	}
}
    802036d6:	60e2                	ld	ra,24(sp)
    802036d8:	6442                	ld	s0,16(sp)
    802036da:	64a2                	ld	s1,8(sp)
    802036dc:	6105                	addi	sp,sp,32
    802036de:	8082                	ret
		debugf("dummpy signal");
    802036e0:	4501                	li	a0,0
    802036e2:	ffffd097          	auipc	ra,0xffffd
    802036e6:	bca080e7          	jalr	-1078(ra) # 802002ac <dummy>
}
    802036ea:	b7f5                	j	802036d6 <cond_signal+0x36>

00000000802036ec <cond_wait>:

void cond_wait(struct condvar *cond, struct mutex *m)
{
    802036ec:	7179                	addi	sp,sp,-48
    802036ee:	f406                	sd	ra,40(sp)
    802036f0:	f022                	sd	s0,32(sp)
    802036f2:	ec26                	sd	s1,24(sp)
    802036f4:	e84a                	sd	s2,16(sp)
    802036f6:	e44e                	sd	s3,8(sp)
    802036f8:	1800                	addi	s0,sp,48
    802036fa:	89aa                	mv	s3,a0
    802036fc:	84ae                	mv	s1,a1
	// conditional variable will unlock the mutex first and lock it again on return
	mutex_unlock(m);
    802036fe:	852e                	mv	a0,a1
    80203700:	00000097          	auipc	ra,0x0
    80203704:	d30080e7          	jalr	-720(ra) # 80203430 <mutex_unlock>
	struct thread *t = curr_thread();
    80203708:	00001097          	auipc	ra,0x1
    8020370c:	cee080e7          	jalr	-786(ra) # 802043f6 <curr_thread>
    80203710:	892a                	mv	s2,a0
	// now just wait for cond
	push_queue(&cond->wait_queue, task_to_id(t));
    80203712:	00001097          	auipc	ra,0x1
    80203716:	e1c080e7          	jalr	-484(ra) # 8020452e <task_to_id>
    8020371a:	85aa                	mv	a1,a0
    8020371c:	854e                	mv	a0,s3
    8020371e:	ffffd097          	auipc	ra,0xffffd
    80203722:	90a080e7          	jalr	-1782(ra) # 80200028 <push_queue>
	t->state = SLEEPING;
    80203726:	4789                	li	a5,2
    80203728:	00f92023          	sw	a5,0(s2)
	debugf("wait for cond");
    8020372c:	4501                	li	a0,0
    8020372e:	ffffd097          	auipc	ra,0xffffd
    80203732:	b7e080e7          	jalr	-1154(ra) # 802002ac <dummy>
	sched();
    80203736:	00001097          	auipc	ra,0x1
    8020373a:	34a080e7          	jalr	842(ra) # 80204a80 <sched>
	debugf("wake up from cond");
    8020373e:	4501                	li	a0,0
    80203740:	ffffd097          	auipc	ra,0xffffd
    80203744:	b6c080e7          	jalr	-1172(ra) # 802002ac <dummy>
	mutex_lock(m);
    80203748:	8526                	mv	a0,s1
    8020374a:	00000097          	auipc	ra,0x0
    8020374e:	c4c080e7          	jalr	-948(ra) # 80203396 <mutex_lock>
}
    80203752:	70a2                	ld	ra,40(sp)
    80203754:	7402                	ld	s0,32(sp)
    80203756:	64e2                	ld	s1,24(sp)
    80203758:	6942                	ld	s2,16(sp)
    8020375a:	69a2                	ld	s3,8(sp)
    8020375c:	6145                	addi	sp,sp,48
    8020375e:	8082                	ret

0000000080203760 <fileclose>:
	return f;
}

//The operation performed on the system-level open file table entry after some process closes a file.
void fileclose(struct file *f)
{
    80203760:	1101                	addi	sp,sp,-32
    80203762:	ec06                	sd	ra,24(sp)
    80203764:	e822                	sd	s0,16(sp)
    80203766:	e426                	sd	s1,8(sp)
    80203768:	e04a                	sd	s2,0(sp)
    8020376a:	1000                	addi	s0,sp,32
	if (f->ref < 1)
    8020376c:	415c                	lw	a5,4(a0)
    8020376e:	06f05763          	blez	a5,802037dc <fileclose+0x7c>
    80203772:	84aa                	mv	s1,a0
		panic("fileclose");
	if (--f->ref > 0) {
    80203774:	37fd                	addiw	a5,a5,-1
    80203776:	0007871b          	sext.w	a4,a5
    8020377a:	c15c                	sw	a5,4(a0)
    8020377c:	0ce04263          	bgtz	a4,80203840 <fileclose+0xe0>
		return;
	}
	switch (f->type) {
    80203780:	411c                	lw	a5,0(a0)
    80203782:	4709                	li	a4,2
    80203784:	0ce78463          	beq	a5,a4,8020384c <fileclose+0xec>
    80203788:	470d                	li	a4,3
    8020378a:	0ae78163          	beq	a5,a4,8020382c <fileclose+0xcc>
    8020378e:	4705                	li	a4,1
    80203790:	08e78763          	beq	a5,a4,8020381e <fileclose+0xbe>
		break;
	case FD_INODE:
		iput(f->ip);
		break;
	default:
		panic("unknown file type %d\n", f->type);
    80203794:	00001097          	auipc	ra,0x1
    80203798:	c0a080e7          	jalr	-1014(ra) # 8020439e <procid>
    8020379c:	892a                	mv	s2,a0
    8020379e:	00001097          	auipc	ra,0x1
    802037a2:	c1a080e7          	jalr	-998(ra) # 802043b8 <threadid>
    802037a6:	0004a883          	lw	a7,0(s1)
    802037aa:	02800813          	li	a6,40
    802037ae:	00005797          	auipc	a5,0x5
    802037b2:	14278793          	addi	a5,a5,322 # 802088f0 <digits+0xb8>
    802037b6:	872a                	mv	a4,a0
    802037b8:	86ca                	mv	a3,s2
    802037ba:	00005617          	auipc	a2,0x5
    802037be:	85660613          	addi	a2,a2,-1962 # 80208010 <e_text+0x10>
    802037c2:	45fd                	li	a1,31
    802037c4:	00005517          	auipc	a0,0x5
    802037c8:	c6c50513          	addi	a0,a0,-916 # 80208430 <e_text+0x430>
    802037cc:	00000097          	auipc	ra,0x0
    802037d0:	8fa080e7          	jalr	-1798(ra) # 802030c6 <printf>
    802037d4:	00000097          	auipc	ra,0x0
    802037d8:	b0a080e7          	jalr	-1270(ra) # 802032de <shutdown>
		panic("fileclose");
    802037dc:	00001097          	auipc	ra,0x1
    802037e0:	bc2080e7          	jalr	-1086(ra) # 8020439e <procid>
    802037e4:	84aa                	mv	s1,a0
    802037e6:	00001097          	auipc	ra,0x1
    802037ea:	bd2080e7          	jalr	-1070(ra) # 802043b8 <threadid>
    802037ee:	4865                	li	a6,25
    802037f0:	00005797          	auipc	a5,0x5
    802037f4:	10078793          	addi	a5,a5,256 # 802088f0 <digits+0xb8>
    802037f8:	872a                	mv	a4,a0
    802037fa:	86a6                	mv	a3,s1
    802037fc:	00005617          	auipc	a2,0x5
    80203800:	81460613          	addi	a2,a2,-2028 # 80208010 <e_text+0x10>
    80203804:	45fd                	li	a1,31
    80203806:	00005517          	auipc	a0,0x5
    8020380a:	0fa50513          	addi	a0,a0,250 # 80208900 <digits+0xc8>
    8020380e:	00000097          	auipc	ra,0x0
    80203812:	8b8080e7          	jalr	-1864(ra) # 802030c6 <printf>
    80203816:	00000097          	auipc	ra,0x0
    8020381a:	ac8080e7          	jalr	-1336(ra) # 802032de <shutdown>
		pipeclose(f->pipe, f->writable);
    8020381e:	00954583          	lbu	a1,9(a0)
    80203822:	6908                	ld	a0,16(a0)
    80203824:	00000097          	auipc	ra,0x0
    80203828:	40e080e7          	jalr	1038(ra) # 80203c32 <pipeclose>
	}

	f->off = 0;
    8020382c:	0204a023          	sw	zero,32(s1)
	f->readable = 0;
    80203830:	00048423          	sb	zero,8(s1)
	f->writable = 0;
    80203834:	000484a3          	sb	zero,9(s1)
	f->ref = 0;
    80203838:	0004a223          	sw	zero,4(s1)
	f->type = FD_NONE;
    8020383c:	0004a023          	sw	zero,0(s1)
}
    80203840:	60e2                	ld	ra,24(sp)
    80203842:	6442                	ld	s0,16(sp)
    80203844:	64a2                	ld	s1,8(sp)
    80203846:	6902                	ld	s2,0(sp)
    80203848:	6105                	addi	sp,sp,32
    8020384a:	8082                	ret
		iput(f->ip);
    8020384c:	6d08                	ld	a0,24(a0)
    8020384e:	00002097          	auipc	ra,0x2
    80203852:	18e080e7          	jalr	398(ra) # 802059dc <iput>
		break;
    80203856:	bfd9                	j	8020382c <fileclose+0xcc>

0000000080203858 <filealloc>:

//Add a new system-level table entry for the open file table
struct file *filealloc()
{
    80203858:	1141                	addi	sp,sp,-16
    8020385a:	e422                	sd	s0,8(sp)
    8020385c:	0800                	addi	s0,sp,16
	for (int i = 0; i < FILEPOOLSIZE; ++i) {
		if (filepool[i].ref == 0) {
    8020385e:	00025797          	auipc	a5,0x25
    80203862:	dfa78793          	addi	a5,a5,-518 # 80228658 <filepool>
    80203866:	43d4                	lw	a3,4(a5)
    80203868:	c29d                	beqz	a3,8020388e <filealloc+0x36>
    8020386a:	00025717          	auipc	a4,0x25
    8020386e:	e1a70713          	addi	a4,a4,-486 # 80228684 <filepool+0x2c>
	for (int i = 0; i < FILEPOOLSIZE; ++i) {
    80203872:	4685                	li	a3,1
		if (filepool[i].ref == 0) {
    80203874:	431c                	lw	a5,0(a4)
    80203876:	cf81                	beqz	a5,8020388e <filealloc+0x36>
	for (int i = 0; i < FILEPOOLSIZE; ++i) {
    80203878:	0016879b          	addiw	a5,a3,1
    8020387c:	0007869b          	sext.w	a3,a5
    80203880:	02870713          	addi	a4,a4,40
    80203884:	8007879b          	addiw	a5,a5,-2048
    80203888:	f7f5                	bnez	a5,80203874 <filealloc+0x1c>
			filepool[i].ref = 1;
			return &filepool[i];
		}
	}
	return 0;
    8020388a:	4501                	li	a0,0
    8020388c:	a831                	j	802038a8 <filealloc+0x50>
			filepool[i].ref = 1;
    8020388e:	00025617          	auipc	a2,0x25
    80203892:	dca60613          	addi	a2,a2,-566 # 80228658 <filepool>
    80203896:	00269793          	slli	a5,a3,0x2
    8020389a:	00d78733          	add	a4,a5,a3
    8020389e:	070e                	slli	a4,a4,0x3
    802038a0:	9732                	add	a4,a4,a2
    802038a2:	4585                	li	a1,1
    802038a4:	c34c                	sw	a1,4(a4)
			return &filepool[i];
    802038a6:	853a                	mv	a0,a4
}
    802038a8:	6422                	ld	s0,8(sp)
    802038aa:	0141                	addi	sp,sp,16
    802038ac:	8082                	ret

00000000802038ae <stdio_init>:
{
    802038ae:	1101                	addi	sp,sp,-32
    802038b0:	ec06                	sd	ra,24(sp)
    802038b2:	e822                	sd	s0,16(sp)
    802038b4:	e426                	sd	s1,8(sp)
    802038b6:	1000                	addi	s0,sp,32
    802038b8:	84aa                	mv	s1,a0
	struct file *f = filealloc();
    802038ba:	00000097          	auipc	ra,0x0
    802038be:	f9e080e7          	jalr	-98(ra) # 80203858 <filealloc>
	f->type = FD_STDIO;
    802038c2:	470d                	li	a4,3
    802038c4:	c118                	sw	a4,0(a0)
	f->ref = 1;
    802038c6:	4705                	li	a4,1
    802038c8:	c158                	sw	a4,4(a0)
	f->readable = (fd == STDIN || fd == STDERR);
    802038ca:	ffd4f713          	andi	a4,s1,-3
    802038ce:	00173713          	seqz	a4,a4
    802038d2:	00e50423          	sb	a4,8(a0)
	f->writable = (fd == STDOUT || fd == STDERR);
    802038d6:	34fd                	addiw	s1,s1,-1
    802038d8:	0024b493          	sltiu	s1,s1,2
    802038dc:	009504a3          	sb	s1,9(a0)
}
    802038e0:	60e2                	ld	ra,24(sp)
    802038e2:	6442                	ld	s0,16(sp)
    802038e4:	64a2                	ld	s1,8(sp)
    802038e6:	6105                	addi	sp,sp,32
    802038e8:	8082                	ret

00000000802038ea <show_all_files>:

//Show names of all files in the root_dir.
int show_all_files()
{
    802038ea:	1141                	addi	sp,sp,-16
    802038ec:	e406                	sd	ra,8(sp)
    802038ee:	e022                	sd	s0,0(sp)
    802038f0:	0800                	addi	s0,sp,16
	return dirls(root_dir());
    802038f2:	00002097          	auipc	ra,0x2
    802038f6:	706080e7          	jalr	1798(ra) # 80205ff8 <root_dir>
    802038fa:	00002097          	auipc	ra,0x2
    802038fe:	4d0080e7          	jalr	1232(ra) # 80205dca <dirls>
}
    80203902:	60a2                	ld	ra,8(sp)
    80203904:	6402                	ld	s0,0(sp)
    80203906:	0141                	addi	sp,sp,16
    80203908:	8082                	ret

000000008020390a <fileopen>:

//A process creates or opens a file according to its path, returning the file descriptor of the created or opened file.
//If omode is O_CREATE, create a new file
//if omode if the others,open a created file.
int fileopen(char *path, uint64 omode)
{
    8020390a:	7179                	addi	sp,sp,-48
    8020390c:	f406                	sd	ra,40(sp)
    8020390e:	f022                	sd	s0,32(sp)
    80203910:	ec26                	sd	s1,24(sp)
    80203912:	e84a                	sd	s2,16(sp)
    80203914:	e44e                	sd	s3,8(sp)
    80203916:	e052                	sd	s4,0(sp)
    80203918:	1800                	addi	s0,sp,48
    8020391a:	84aa                	mv	s1,a0
    8020391c:	892e                	mv	s2,a1
	int fd;
	struct file *f;
	struct inode *ip;
	if (omode & O_CREATE) {
    8020391e:	2005f793          	andi	a5,a1,512
    80203922:	12078c63          	beqz	a5,80203a5a <fileopen+0x150>
	dp = root_dir();
    80203926:	00002097          	auipc	ra,0x2
    8020392a:	6d2080e7          	jalr	1746(ra) # 80205ff8 <root_dir>
    8020392e:	8a2a                	mv	s4,a0
	ivalid(dp);
    80203930:	00002097          	auipc	ra,0x2
    80203934:	fec080e7          	jalr	-20(ra) # 8020591c <ivalid>
	if ((ip = dirlookup(dp, path, 0)) != 0) {
    80203938:	4601                	li	a2,0
    8020393a:	85a6                	mv	a1,s1
    8020393c:	8552                	mv	a0,s4
    8020393e:	00002097          	auipc	ra,0x2
    80203942:	372080e7          	jalr	882(ra) # 80205cb0 <dirlookup>
    80203946:	89aa                	mv	s3,a0
    80203948:	cd05                	beqz	a0,80203980 <fileopen+0x76>
		warnf("create a exist file\n");
    8020394a:	4501                	li	a0,0
    8020394c:	ffffd097          	auipc	ra,0xffffd
    80203950:	960080e7          	jalr	-1696(ra) # 802002ac <dummy>
		iput(dp); //Close the root_inode
    80203954:	8552                	mv	a0,s4
    80203956:	00002097          	auipc	ra,0x2
    8020395a:	086080e7          	jalr	134(ra) # 802059dc <iput>
		ivalid(ip);
    8020395e:	854e                	mv	a0,s3
    80203960:	00002097          	auipc	ra,0x2
    80203964:	fbc080e7          	jalr	-68(ra) # 8020591c <ivalid>
		if (type == T_FILE && ip->type == T_FILE)
    80203968:	01099703          	lh	a4,16(s3) # fffffffffffff010 <e_bss+0xffffffff7ece1010>
    8020396c:	4789                	li	a5,2
    8020396e:	10f70563          	beq	a4,a5,80203a78 <fileopen+0x16e>
		iput(ip);
    80203972:	854e                	mv	a0,s3
    80203974:	00002097          	auipc	ra,0x2
    80203978:	068080e7          	jalr	104(ra) # 802059dc <iput>
		ip = create(path, T_FILE);
		if (ip == 0) {
			return -1;
    8020397c:	5a7d                	li	s4,-1
    8020397e:	a2a1                	j	80203ac6 <fileopen+0x1bc>
	if ((ip = ialloc(dp->dev, type)) == 0)
    80203980:	4589                	li	a1,2
    80203982:	000a2503          	lw	a0,0(s4) # 1000 <BASE_ADDRESS-0x801ff000>
    80203986:	00002097          	auipc	ra,0x2
    8020398a:	e0a080e7          	jalr	-502(ra) # 80205790 <ialloc>
    8020398e:	89aa                	mv	s3,a0
    80203990:	c129                	beqz	a0,802039d2 <fileopen+0xc8>
	tracef("create dinode and inode type = %d\n", type);
    80203992:	4589                	li	a1,2
    80203994:	4501                	li	a0,0
    80203996:	ffffd097          	auipc	ra,0xffffd
    8020399a:	916080e7          	jalr	-1770(ra) # 802002ac <dummy>
	ivalid(ip);
    8020399e:	854e                	mv	a0,s3
    802039a0:	00002097          	auipc	ra,0x2
    802039a4:	f7c080e7          	jalr	-132(ra) # 8020591c <ivalid>
	iupdate(ip);
    802039a8:	854e                	mv	a0,s3
    802039aa:	00002097          	auipc	ra,0x2
    802039ae:	eea080e7          	jalr	-278(ra) # 80205894 <iupdate>
	if (dirlink(dp, path, ip->inum) < 0)
    802039b2:	0049a603          	lw	a2,4(s3)
    802039b6:	85a6                	mv	a1,s1
    802039b8:	8552                	mv	a0,s4
    802039ba:	00002097          	auipc	ra,0x2
    802039be:	516080e7          	jalr	1302(ra) # 80205ed0 <dirlink>
    802039c2:	04054a63          	bltz	a0,80203a16 <fileopen+0x10c>
	iput(dp);
    802039c6:	8552                	mv	a0,s4
    802039c8:	00002097          	auipc	ra,0x2
    802039cc:	014080e7          	jalr	20(ra) # 802059dc <iput>
		if (ip == 0) {
    802039d0:	a879                	j	80203a6e <fileopen+0x164>
		panic("create: ialloc");
    802039d2:	00001097          	auipc	ra,0x1
    802039d6:	9cc080e7          	jalr	-1588(ra) # 8020439e <procid>
    802039da:	84aa                	mv	s1,a0
    802039dc:	00001097          	auipc	ra,0x1
    802039e0:	9dc080e7          	jalr	-1572(ra) # 802043b8 <threadid>
    802039e4:	05700813          	li	a6,87
    802039e8:	00005797          	auipc	a5,0x5
    802039ec:	f0878793          	addi	a5,a5,-248 # 802088f0 <digits+0xb8>
    802039f0:	872a                	mv	a4,a0
    802039f2:	86a6                	mv	a3,s1
    802039f4:	00004617          	auipc	a2,0x4
    802039f8:	61c60613          	addi	a2,a2,1564 # 80208010 <e_text+0x10>
    802039fc:	45fd                	li	a1,31
    802039fe:	00005517          	auipc	a0,0x5
    80203a02:	f2a50513          	addi	a0,a0,-214 # 80208928 <digits+0xf0>
    80203a06:	fffff097          	auipc	ra,0xfffff
    80203a0a:	6c0080e7          	jalr	1728(ra) # 802030c6 <printf>
    80203a0e:	00000097          	auipc	ra,0x0
    80203a12:	8d0080e7          	jalr	-1840(ra) # 802032de <shutdown>
		panic("create: dirlink");
    80203a16:	00001097          	auipc	ra,0x1
    80203a1a:	988080e7          	jalr	-1656(ra) # 8020439e <procid>
    80203a1e:	84aa                	mv	s1,a0
    80203a20:	00001097          	auipc	ra,0x1
    80203a24:	998080e7          	jalr	-1640(ra) # 802043b8 <threadid>
    80203a28:	05e00813          	li	a6,94
    80203a2c:	00005797          	auipc	a5,0x5
    80203a30:	ec478793          	addi	a5,a5,-316 # 802088f0 <digits+0xb8>
    80203a34:	872a                	mv	a4,a0
    80203a36:	86a6                	mv	a3,s1
    80203a38:	00004617          	auipc	a2,0x4
    80203a3c:	5d860613          	addi	a2,a2,1496 # 80208010 <e_text+0x10>
    80203a40:	45fd                	li	a1,31
    80203a42:	00005517          	auipc	a0,0x5
    80203a46:	f1650513          	addi	a0,a0,-234 # 80208958 <digits+0x120>
    80203a4a:	fffff097          	auipc	ra,0xfffff
    80203a4e:	67c080e7          	jalr	1660(ra) # 802030c6 <printf>
    80203a52:	00000097          	auipc	ra,0x0
    80203a56:	88c080e7          	jalr	-1908(ra) # 802032de <shutdown>
		}
	} else {
		if ((ip = namei(path)) == 0) {
    80203a5a:	00002097          	auipc	ra,0x2
    80203a5e:	5ca080e7          	jalr	1482(ra) # 80206024 <namei>
    80203a62:	89aa                	mv	s3,a0
    80203a64:	c171                	beqz	a0,80203b28 <fileopen+0x21e>
			return -1;
		}
		ivalid(ip);
    80203a66:	00002097          	auipc	ra,0x2
    80203a6a:	eb6080e7          	jalr	-330(ra) # 8020591c <ivalid>
	}
	if (ip->type != T_FILE)
    80203a6e:	01099703          	lh	a4,16(s3)
    80203a72:	4789                	li	a5,2
    80203a74:	06f71263          	bne	a4,a5,80203ad8 <fileopen+0x1ce>
		panic("unsupported file inode type\n");
	if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80203a78:	00000097          	auipc	ra,0x0
    80203a7c:	de0080e7          	jalr	-544(ra) # 80203858 <filealloc>
    80203a80:	84aa                	mv	s1,a0
    80203a82:	c955                	beqz	a0,80203b36 <fileopen+0x22c>
    80203a84:	00001097          	auipc	ra,0x1
    80203a88:	7ca080e7          	jalr	1994(ra) # 8020524e <fdalloc>
    80203a8c:	8a2a                	mv	s4,a0
    80203a8e:	08054f63          	bltz	a0,80203b2c <fileopen+0x222>
			fileclose(f);
		iput(ip);
		return -1;
	}
	// only support FD_INODE
	f->type = FD_INODE;
    80203a92:	4789                	li	a5,2
    80203a94:	c09c                	sw	a5,0(s1)
	f->off = 0;
    80203a96:	0204a023          	sw	zero,32(s1)
	f->ip = ip;
    80203a9a:	0134bc23          	sd	s3,24(s1)
	f->readable = !(omode & O_WRONLY);
    80203a9e:	00194793          	xori	a5,s2,1
    80203aa2:	8b85                	andi	a5,a5,1
    80203aa4:	00f48423          	sb	a5,8(s1)
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80203aa8:	00397793          	andi	a5,s2,3
    80203aac:	00f037b3          	snez	a5,a5
    80203ab0:	00f484a3          	sb	a5,9(s1)
	if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80203ab4:	40097913          	andi	s2,s2,1024
    80203ab8:	00090763          	beqz	s2,80203ac6 <fileopen+0x1bc>
    80203abc:	01099703          	lh	a4,16(s3)
    80203ac0:	4789                	li	a5,2
    80203ac2:	04f70d63          	beq	a4,a5,80203b1c <fileopen+0x212>
		itrunc(ip);
	}
	return fd;
}
    80203ac6:	8552                	mv	a0,s4
    80203ac8:	70a2                	ld	ra,40(sp)
    80203aca:	7402                	ld	s0,32(sp)
    80203acc:	64e2                	ld	s1,24(sp)
    80203ace:	6942                	ld	s2,16(sp)
    80203ad0:	69a2                	ld	s3,8(sp)
    80203ad2:	6a02                	ld	s4,0(sp)
    80203ad4:	6145                	addi	sp,sp,48
    80203ad6:	8082                	ret
		panic("unsupported file inode type\n");
    80203ad8:	00001097          	auipc	ra,0x1
    80203adc:	8c6080e7          	jalr	-1850(ra) # 8020439e <procid>
    80203ae0:	84aa                	mv	s1,a0
    80203ae2:	00001097          	auipc	ra,0x1
    80203ae6:	8d6080e7          	jalr	-1834(ra) # 802043b8 <threadid>
    80203aea:	07800813          	li	a6,120
    80203aee:	00005797          	auipc	a5,0x5
    80203af2:	e0278793          	addi	a5,a5,-510 # 802088f0 <digits+0xb8>
    80203af6:	872a                	mv	a4,a0
    80203af8:	86a6                	mv	a3,s1
    80203afa:	00004617          	auipc	a2,0x4
    80203afe:	51660613          	addi	a2,a2,1302 # 80208010 <e_text+0x10>
    80203b02:	45fd                	li	a1,31
    80203b04:	00005517          	auipc	a0,0x5
    80203b08:	e8450513          	addi	a0,a0,-380 # 80208988 <digits+0x150>
    80203b0c:	fffff097          	auipc	ra,0xfffff
    80203b10:	5ba080e7          	jalr	1466(ra) # 802030c6 <printf>
    80203b14:	fffff097          	auipc	ra,0xfffff
    80203b18:	7ca080e7          	jalr	1994(ra) # 802032de <shutdown>
		itrunc(ip);
    80203b1c:	854e                	mv	a0,s3
    80203b1e:	00002097          	auipc	ra,0x2
    80203b22:	ed0080e7          	jalr	-304(ra) # 802059ee <itrunc>
    80203b26:	b745                	j	80203ac6 <fileopen+0x1bc>
			return -1;
    80203b28:	5a7d                	li	s4,-1
    80203b2a:	bf71                	j	80203ac6 <fileopen+0x1bc>
			fileclose(f);
    80203b2c:	8526                	mv	a0,s1
    80203b2e:	00000097          	auipc	ra,0x0
    80203b32:	c32080e7          	jalr	-974(ra) # 80203760 <fileclose>
		iput(ip);
    80203b36:	854e                	mv	a0,s3
    80203b38:	00002097          	auipc	ra,0x2
    80203b3c:	ea4080e7          	jalr	-348(ra) # 802059dc <iput>
		return -1;
    80203b40:	5a7d                	li	s4,-1
    80203b42:	b751                	j	80203ac6 <fileopen+0x1bc>

0000000080203b44 <inodewrite>:

// Write data to inode.
uint64 inodewrite(struct file *f, uint64 va, uint64 len)
{
    80203b44:	7179                	addi	sp,sp,-48
    80203b46:	f406                	sd	ra,40(sp)
    80203b48:	f022                	sd	s0,32(sp)
    80203b4a:	ec26                	sd	s1,24(sp)
    80203b4c:	e84a                	sd	s2,16(sp)
    80203b4e:	e44e                	sd	s3,8(sp)
    80203b50:	1800                	addi	s0,sp,48
    80203b52:	84aa                	mv	s1,a0
    80203b54:	892e                	mv	s2,a1
    80203b56:	89b2                	mv	s3,a2
	int r;
	ivalid(f->ip);
    80203b58:	6d08                	ld	a0,24(a0)
    80203b5a:	00002097          	auipc	ra,0x2
    80203b5e:	dc2080e7          	jalr	-574(ra) # 8020591c <ivalid>
	if ((r = writei(f->ip, 1, va, f->off, len)) > 0)
    80203b62:	0009871b          	sext.w	a4,s3
    80203b66:	5094                	lw	a3,32(s1)
    80203b68:	864a                	mv	a2,s2
    80203b6a:	4585                	li	a1,1
    80203b6c:	6c88                	ld	a0,24(s1)
    80203b6e:	00002097          	auipc	ra,0x2
    80203b72:	024080e7          	jalr	36(ra) # 80205b92 <writei>
    80203b76:	00a05563          	blez	a0,80203b80 <inodewrite+0x3c>
		f->off += r;
    80203b7a:	509c                	lw	a5,32(s1)
    80203b7c:	9fa9                	addw	a5,a5,a0
    80203b7e:	d09c                	sw	a5,32(s1)
	return r;
}
    80203b80:	70a2                	ld	ra,40(sp)
    80203b82:	7402                	ld	s0,32(sp)
    80203b84:	64e2                	ld	s1,24(sp)
    80203b86:	6942                	ld	s2,16(sp)
    80203b88:	69a2                	ld	s3,8(sp)
    80203b8a:	6145                	addi	sp,sp,48
    80203b8c:	8082                	ret

0000000080203b8e <inoderead>:

//Read data from inode.
uint64 inoderead(struct file *f, uint64 va, uint64 len)
{
    80203b8e:	7179                	addi	sp,sp,-48
    80203b90:	f406                	sd	ra,40(sp)
    80203b92:	f022                	sd	s0,32(sp)
    80203b94:	ec26                	sd	s1,24(sp)
    80203b96:	e84a                	sd	s2,16(sp)
    80203b98:	e44e                	sd	s3,8(sp)
    80203b9a:	1800                	addi	s0,sp,48
    80203b9c:	84aa                	mv	s1,a0
    80203b9e:	892e                	mv	s2,a1
    80203ba0:	89b2                	mv	s3,a2
	int r;
	ivalid(f->ip);
    80203ba2:	6d08                	ld	a0,24(a0)
    80203ba4:	00002097          	auipc	ra,0x2
    80203ba8:	d78080e7          	jalr	-648(ra) # 8020591c <ivalid>
	if ((r = readi(f->ip, 1, va, f->off, len)) > 0)
    80203bac:	0009871b          	sext.w	a4,s3
    80203bb0:	5094                	lw	a3,32(s1)
    80203bb2:	864a                	mv	a2,s2
    80203bb4:	4585                	li	a1,1
    80203bb6:	6c88                	ld	a0,24(s1)
    80203bb8:	00002097          	auipc	ra,0x2
    80203bbc:	ee2080e7          	jalr	-286(ra) # 80205a9a <readi>
    80203bc0:	00a05563          	blez	a0,80203bca <inoderead+0x3c>
		f->off += r;
    80203bc4:	509c                	lw	a5,32(s1)
    80203bc6:	9fa9                	addw	a5,a5,a0
    80203bc8:	d09c                	sw	a5,32(s1)
	return r;
    80203bca:	70a2                	ld	ra,40(sp)
    80203bcc:	7402                	ld	s0,32(sp)
    80203bce:	64e2                	ld	s1,24(sp)
    80203bd0:	6942                	ld	s2,16(sp)
    80203bd2:	69a2                	ld	s3,8(sp)
    80203bd4:	6145                	addi	sp,sp,48
    80203bd6:	8082                	ret

0000000080203bd8 <pipealloc>:
#include "defs.h"
#include "proc.h"
#include "riscv.h"

int pipealloc(struct file *f0, struct file *f1)
{
    80203bd8:	1101                	addi	sp,sp,-32
    80203bda:	ec06                	sd	ra,24(sp)
    80203bdc:	e822                	sd	s0,16(sp)
    80203bde:	e426                	sd	s1,8(sp)
    80203be0:	e04a                	sd	s2,0(sp)
    80203be2:	1000                	addi	s0,sp,32
    80203be4:	892a                	mv	s2,a0
    80203be6:	84ae                	mv	s1,a1
	struct pipe *pi;
	pi = 0;
	if ((pi = (struct pipe *)kalloc()) == 0)
    80203be8:	00000097          	auipc	ra,0x0
    80203bec:	6f0080e7          	jalr	1776(ra) # 802042d8 <kalloc>
    80203bf0:	cd1d                	beqz	a0,80203c2e <pipealloc+0x56>
		goto bad;
	pi->readopen = 1;
    80203bf2:	4785                	li	a5,1
    80203bf4:	20f52423          	sw	a5,520(a0)
	pi->writeopen = 1;
    80203bf8:	20f52623          	sw	a5,524(a0)
	pi->nwrite = 0;
    80203bfc:	20052223          	sw	zero,516(a0)
	pi->nread = 0;
    80203c00:	20052023          	sw	zero,512(a0)
	f0->type = FD_PIPE;
    80203c04:	00f92023          	sw	a5,0(s2)
	f0->readable = 1;
    80203c08:	00f90423          	sb	a5,8(s2)
	f0->writable = 0;
    80203c0c:	000904a3          	sb	zero,9(s2)
	f0->pipe = pi;
    80203c10:	00a93823          	sd	a0,16(s2)
	f1->type = FD_PIPE;
    80203c14:	c09c                	sw	a5,0(s1)
	f1->readable = 0;
    80203c16:	00048423          	sb	zero,8(s1)
	f1->writable = 1;
    80203c1a:	00f484a3          	sb	a5,9(s1)
	f1->pipe = pi;
    80203c1e:	e888                	sd	a0,16(s1)
	return 0;
    80203c20:	4501                	li	a0,0
bad:
	if (pi)
		kfree((char *)pi);
	return -1;
}
    80203c22:	60e2                	ld	ra,24(sp)
    80203c24:	6442                	ld	s0,16(sp)
    80203c26:	64a2                	ld	s1,8(sp)
    80203c28:	6902                	ld	s2,0(sp)
    80203c2a:	6105                	addi	sp,sp,32
    80203c2c:	8082                	ret
	return -1;
    80203c2e:	557d                	li	a0,-1
    80203c30:	bfcd                	j	80203c22 <pipealloc+0x4a>

0000000080203c32 <pipeclose>:

void pipeclose(struct pipe *pi, int writable)
{
	if (writable) {
    80203c32:	c599                	beqz	a1,80203c40 <pipeclose+0xe>
		pi->writeopen = 0;
    80203c34:	20052623          	sw	zero,524(a0)
	} else {
		pi->readopen = 0;
	}
	if (pi->readopen == 0 && pi->writeopen == 0) {
    80203c38:	20852783          	lw	a5,520(a0)
    80203c3c:	c799                	beqz	a5,80203c4a <pipeclose+0x18>
    80203c3e:	8082                	ret
		pi->readopen = 0;
    80203c40:	20052423          	sw	zero,520(a0)
	if (pi->readopen == 0 && pi->writeopen == 0) {
    80203c44:	20c52783          	lw	a5,524(a0)
    80203c48:	fbfd                	bnez	a5,80203c3e <pipeclose+0xc>
{
    80203c4a:	1141                	addi	sp,sp,-16
    80203c4c:	e406                	sd	ra,8(sp)
    80203c4e:	e022                	sd	s0,0(sp)
    80203c50:	0800                	addi	s0,sp,16
		kfree((char *)pi);
    80203c52:	00000097          	auipc	ra,0x0
    80203c56:	588080e7          	jalr	1416(ra) # 802041da <kfree>
	}
}
    80203c5a:	60a2                	ld	ra,8(sp)
    80203c5c:	6402                	ld	s0,0(sp)
    80203c5e:	0141                	addi	sp,sp,16
    80203c60:	8082                	ret

0000000080203c62 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80203c62:	715d                	addi	sp,sp,-80
    80203c64:	e486                	sd	ra,72(sp)
    80203c66:	e0a2                	sd	s0,64(sp)
    80203c68:	fc26                	sd	s1,56(sp)
    80203c6a:	f84a                	sd	s2,48(sp)
    80203c6c:	f44e                	sd	s3,40(sp)
    80203c6e:	f052                	sd	s4,32(sp)
    80203c70:	ec56                	sd	s5,24(sp)
    80203c72:	e85a                	sd	s6,16(sp)
    80203c74:	e45e                	sd	s7,8(sp)
    80203c76:	0880                	addi	s0,sp,80
    80203c78:	84aa                	mv	s1,a0
    80203c7a:	8aae                	mv	s5,a1
    80203c7c:	89b2                	mv	s3,a2
	int w = 0;
	uint64 size;
	struct proc *p = curr_proc();
    80203c7e:	00000097          	auipc	ra,0x0
    80203c82:	760080e7          	jalr	1888(ra) # 802043de <curr_proc>
	if (n <= 0) {
    80203c86:	01305b63          	blez	s3,80203c9c <pipewrite+0x3a>
    80203c8a:	8a2a                	mv	s4,a0
		panic("invalid read num");
	}
	while (w < n) {
		if (pi->readopen == 0) {
    80203c8c:	2084a783          	lw	a5,520(s1)
    80203c90:	10078a63          	beqz	a5,80203da4 <pipewrite+0x142>
	int w = 0;
    80203c94:	4901                	li	s2,0
			return -1;
		}
		if (pi->nwrite == pi->nread + PIPESIZE) { // DOC: pipewrite-full
			yield();
		} else {
			size = MIN(MIN(n - w,
    80203c96:	20000b13          	li	s6,512
    80203c9a:	a059                	j	80203d20 <pipewrite+0xbe>
		panic("invalid read num");
    80203c9c:	00000097          	auipc	ra,0x0
    80203ca0:	702080e7          	jalr	1794(ra) # 8020439e <procid>
    80203ca4:	84aa                	mv	s1,a0
    80203ca6:	00000097          	auipc	ra,0x0
    80203caa:	712080e7          	jalr	1810(ra) # 802043b8 <threadid>
    80203cae:	03000813          	li	a6,48
    80203cb2:	00005797          	auipc	a5,0x5
    80203cb6:	d1678793          	addi	a5,a5,-746 # 802089c8 <digits+0x190>
    80203cba:	872a                	mv	a4,a0
    80203cbc:	86a6                	mv	a3,s1
    80203cbe:	00004617          	auipc	a2,0x4
    80203cc2:	35260613          	addi	a2,a2,850 # 80208010 <e_text+0x10>
    80203cc6:	45fd                	li	a1,31
    80203cc8:	00005517          	auipc	a0,0x5
    80203ccc:	d1050513          	addi	a0,a0,-752 # 802089d8 <digits+0x1a0>
    80203cd0:	fffff097          	auipc	ra,0xfffff
    80203cd4:	3f6080e7          	jalr	1014(ra) # 802030c6 <printf>
    80203cd8:	fffff097          	auipc	ra,0xfffff
    80203cdc:	606080e7          	jalr	1542(ra) # 802032de <shutdown>
			yield();
    80203ce0:	00001097          	auipc	ra,0x1
    80203ce4:	e14080e7          	jalr	-492(ra) # 80204af4 <yield>
    80203ce8:	a03d                	j	80203d16 <pipewrite+0xb4>
				       pi->nread + PIPESIZE - pi->nwrite),
				   PIPESIZE - (pi->nwrite % PIPESIZE));
			if (copyin(p->pagetable,
    80203cea:	020b9693          	slli	a3,s7,0x20
    80203cee:	9281                	srli	a3,a3,0x20
    80203cf0:	01590633          	add	a2,s2,s5
    80203cf4:	95a6                	add	a1,a1,s1
    80203cf6:	008a3503          	ld	a0,8(s4)
    80203cfa:	fffff097          	auipc	ra,0xfffff
    80203cfe:	12e080e7          	jalr	302(ra) # 80202e28 <copyin>
    80203d02:	04054f63          	bltz	a0,80203d60 <pipewrite+0xfe>
				   &pi->data[pi->nwrite % PIPESIZE], addr + w,
				   size) < 0) {
				panic("copyin");
			}
			pi->nwrite += size;
    80203d06:	2044a783          	lw	a5,516(s1)
    80203d0a:	017787bb          	addw	a5,a5,s7
    80203d0e:	20f4a223          	sw	a5,516(s1)
			w += size;
    80203d12:	012b893b          	addw	s2,s7,s2
	while (w < n) {
    80203d16:	09395a63          	bge	s2,s3,80203daa <pipewrite+0x148>
		if (pi->readopen == 0) {
    80203d1a:	2084a783          	lw	a5,520(s1)
    80203d1e:	c7c9                	beqz	a5,80203da8 <pipewrite+0x146>
		if (pi->nwrite == pi->nread + PIPESIZE) { // DOC: pipewrite-full
    80203d20:	2044a703          	lw	a4,516(s1)
    80203d24:	2004a783          	lw	a5,512(s1)
    80203d28:	2007879b          	addiw	a5,a5,512
    80203d2c:	0007869b          	sext.w	a3,a5
    80203d30:	fad708e3          	beq	a4,a3,80203ce0 <pipewrite+0x7e>
			size = MIN(MIN(n - w,
    80203d34:	1ff77593          	andi	a1,a4,511
    80203d38:	40bb06bb          	subw	a3,s6,a1
    80203d3c:	9f99                	subw	a5,a5,a4
    80203d3e:	8736                	mv	a4,a3
    80203d40:	2681                	sext.w	a3,a3
    80203d42:	0007861b          	sext.w	a2,a5
    80203d46:	00d67363          	bgeu	a2,a3,80203d4c <pipewrite+0xea>
    80203d4a:	873e                	mv	a4,a5
    80203d4c:	412987bb          	subw	a5,s3,s2
    80203d50:	8bba                	mv	s7,a4
    80203d52:	2701                	sext.w	a4,a4
    80203d54:	0007869b          	sext.w	a3,a5
    80203d58:	f8e6f9e3          	bgeu	a3,a4,80203cea <pipewrite+0x88>
    80203d5c:	8bbe                	mv	s7,a5
    80203d5e:	b771                	j	80203cea <pipewrite+0x88>
				panic("copyin");
    80203d60:	00000097          	auipc	ra,0x0
    80203d64:	63e080e7          	jalr	1598(ra) # 8020439e <procid>
    80203d68:	84aa                	mv	s1,a0
    80203d6a:	00000097          	auipc	ra,0x0
    80203d6e:	64e080e7          	jalr	1614(ra) # 802043b8 <threadid>
    80203d72:	03f00813          	li	a6,63
    80203d76:	00005797          	auipc	a5,0x5
    80203d7a:	c5278793          	addi	a5,a5,-942 # 802089c8 <digits+0x190>
    80203d7e:	872a                	mv	a4,a0
    80203d80:	86a6                	mv	a3,s1
    80203d82:	00004617          	auipc	a2,0x4
    80203d86:	28e60613          	addi	a2,a2,654 # 80208010 <e_text+0x10>
    80203d8a:	45fd                	li	a1,31
    80203d8c:	00005517          	auipc	a0,0x5
    80203d90:	c7c50513          	addi	a0,a0,-900 # 80208a08 <digits+0x1d0>
    80203d94:	fffff097          	auipc	ra,0xfffff
    80203d98:	332080e7          	jalr	818(ra) # 802030c6 <printf>
    80203d9c:	fffff097          	auipc	ra,0xfffff
    80203da0:	542080e7          	jalr	1346(ra) # 802032de <shutdown>
			return -1;
    80203da4:	597d                	li	s2,-1
    80203da6:	a011                	j	80203daa <pipewrite+0x148>
    80203da8:	597d                	li	s2,-1
		}
	}
	return w;
}
    80203daa:	854a                	mv	a0,s2
    80203dac:	60a6                	ld	ra,72(sp)
    80203dae:	6406                	ld	s0,64(sp)
    80203db0:	74e2                	ld	s1,56(sp)
    80203db2:	7942                	ld	s2,48(sp)
    80203db4:	79a2                	ld	s3,40(sp)
    80203db6:	7a02                	ld	s4,32(sp)
    80203db8:	6ae2                	ld	s5,24(sp)
    80203dba:	6b42                	ld	s6,16(sp)
    80203dbc:	6ba2                	ld	s7,8(sp)
    80203dbe:	6161                	addi	sp,sp,80
    80203dc0:	8082                	ret

0000000080203dc2 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n)
{
    80203dc2:	715d                	addi	sp,sp,-80
    80203dc4:	e486                	sd	ra,72(sp)
    80203dc6:	e0a2                	sd	s0,64(sp)
    80203dc8:	fc26                	sd	s1,56(sp)
    80203dca:	f84a                	sd	s2,48(sp)
    80203dcc:	f44e                	sd	s3,40(sp)
    80203dce:	f052                	sd	s4,32(sp)
    80203dd0:	ec56                	sd	s5,24(sp)
    80203dd2:	e85a                	sd	s6,16(sp)
    80203dd4:	e45e                	sd	s7,8(sp)
    80203dd6:	e062                	sd	s8,0(sp)
    80203dd8:	0880                	addi	s0,sp,80
    80203dda:	84aa                	mv	s1,a0
    80203ddc:	8aae                	mv	s5,a1
    80203dde:	89b2                	mv	s3,a2
	int r = 0;
	uint64 size = -1;
	struct proc *p = curr_proc();
    80203de0:	00000097          	auipc	ra,0x0
    80203de4:	5fe080e7          	jalr	1534(ra) # 802043de <curr_proc>
	if (n <= 0) {
    80203de8:	05305863          	blez	s3,80203e38 <piperead+0x76>
    80203dec:	8a2a                	mv	s4,a0
		panic("invalid read num");
	}
	while (pi->nread == pi->nwrite) {
    80203dee:	2004a703          	lw	a4,512(s1)
    80203df2:	2044a783          	lw	a5,516(s1)
    80203df6:	12f71d63          	bne	a4,a5,80203f30 <piperead+0x16e>
		if (pi->writeopen)
    80203dfa:	20c4a783          	lw	a5,524(s1)
			yield();
		else
			return -1;
    80203dfe:	597d                	li	s2,-1
		if (pi->writeopen)
    80203e00:	cf99                	beqz	a5,80203e1e <piperead+0x5c>
			yield();
    80203e02:	00001097          	auipc	ra,0x1
    80203e06:	cf2080e7          	jalr	-782(ra) # 80204af4 <yield>
	while (pi->nread == pi->nwrite) {
    80203e0a:	2004a703          	lw	a4,512(s1)
    80203e0e:	2044a783          	lw	a5,516(s1)
    80203e12:	10f71f63          	bne	a4,a5,80203f30 <piperead+0x16e>
		if (pi->writeopen)
    80203e16:	20c4a783          	lw	a5,524(s1)
    80203e1a:	f7e5                	bnez	a5,80203e02 <piperead+0x40>
			return -1;
    80203e1c:	597d                	li	s2,-1
		}
		pi->nread += size;
		r += size;
	}
	return r;
}
    80203e1e:	854a                	mv	a0,s2
    80203e20:	60a6                	ld	ra,72(sp)
    80203e22:	6406                	ld	s0,64(sp)
    80203e24:	74e2                	ld	s1,56(sp)
    80203e26:	7942                	ld	s2,48(sp)
    80203e28:	79a2                	ld	s3,40(sp)
    80203e2a:	7a02                	ld	s4,32(sp)
    80203e2c:	6ae2                	ld	s5,24(sp)
    80203e2e:	6b42                	ld	s6,16(sp)
    80203e30:	6ba2                	ld	s7,8(sp)
    80203e32:	6c02                	ld	s8,0(sp)
    80203e34:	6161                	addi	sp,sp,80
    80203e36:	8082                	ret
		panic("invalid read num");
    80203e38:	00000097          	auipc	ra,0x0
    80203e3c:	566080e7          	jalr	1382(ra) # 8020439e <procid>
    80203e40:	84aa                	mv	s1,a0
    80203e42:	00000097          	auipc	ra,0x0
    80203e46:	576080e7          	jalr	1398(ra) # 802043b8 <threadid>
    80203e4a:	04e00813          	li	a6,78
    80203e4e:	00005797          	auipc	a5,0x5
    80203e52:	b7a78793          	addi	a5,a5,-1158 # 802089c8 <digits+0x190>
    80203e56:	872a                	mv	a4,a0
    80203e58:	86a6                	mv	a3,s1
    80203e5a:	00004617          	auipc	a2,0x4
    80203e5e:	1b660613          	addi	a2,a2,438 # 80208010 <e_text+0x10>
    80203e62:	45fd                	li	a1,31
    80203e64:	00005517          	auipc	a0,0x5
    80203e68:	b7450513          	addi	a0,a0,-1164 # 802089d8 <digits+0x1a0>
    80203e6c:	fffff097          	auipc	ra,0xfffff
    80203e70:	25a080e7          	jalr	602(ra) # 802030c6 <printf>
    80203e74:	fffff097          	auipc	ra,0xfffff
    80203e78:	46a080e7          	jalr	1130(ra) # 802032de <shutdown>
		size = MIN(MIN(n - r, pi->nwrite - pi->nread),
    80203e7c:	020b9c13          	slli	s8,s7,0x20
    80203e80:	020c5c13          	srli	s8,s8,0x20
		if (copyout(p->pagetable, addr + r,
    80203e84:	86e2                	mv	a3,s8
    80203e86:	9626                	add	a2,a2,s1
    80203e88:	015905b3          	add	a1,s2,s5
    80203e8c:	008a3503          	ld	a0,8(s4)
    80203e90:	fffff097          	auipc	ra,0xfffff
    80203e94:	f0c080e7          	jalr	-244(ra) # 80202d9c <copyout>
    80203e98:	04054a63          	bltz	a0,80203eec <piperead+0x12a>
		pi->nread += size;
    80203e9c:	2004a783          	lw	a5,512(s1)
    80203ea0:	017787bb          	addw	a5,a5,s7
    80203ea4:	0007859b          	sext.w	a1,a5
    80203ea8:	20f4a023          	sw	a5,512(s1)
		r += size;
    80203eac:	012b893b          	addw	s2,s7,s2
	while (r < n && size != 0) { // DOC: piperead-copy
    80203eb0:	f73957e3          	bge	s2,s3,80203e1e <piperead+0x5c>
    80203eb4:	f60c05e3          	beqz	s8,80203e1e <piperead+0x5c>
		if (pi->nread == pi->nwrite)
    80203eb8:	2044a703          	lw	a4,516(s1)
    80203ebc:	f6b701e3          	beq	a4,a1,80203e1e <piperead+0x5c>
		size = MIN(MIN(n - r, pi->nwrite - pi->nread),
    80203ec0:	1ff5f613          	andi	a2,a1,511
    80203ec4:	40cb06bb          	subw	a3,s6,a2
    80203ec8:	4129853b          	subw	a0,s3,s2
    80203ecc:	87b6                	mv	a5,a3
    80203ece:	2681                	sext.w	a3,a3
    80203ed0:	0005081b          	sext.w	a6,a0
    80203ed4:	00d87363          	bgeu	a6,a3,80203eda <piperead+0x118>
    80203ed8:	87aa                	mv	a5,a0
    80203eda:	9f0d                	subw	a4,a4,a1
    80203edc:	8bbe                	mv	s7,a5
    80203ede:	2781                	sext.w	a5,a5
    80203ee0:	0007069b          	sext.w	a3,a4
    80203ee4:	f8f6fce3          	bgeu	a3,a5,80203e7c <piperead+0xba>
    80203ee8:	8bba                	mv	s7,a4
    80203eea:	bf49                	j	80203e7c <piperead+0xba>
			panic("copyout");
    80203eec:	00000097          	auipc	ra,0x0
    80203ef0:	4b2080e7          	jalr	1202(ra) # 8020439e <procid>
    80203ef4:	84aa                	mv	s1,a0
    80203ef6:	00000097          	auipc	ra,0x0
    80203efa:	4c2080e7          	jalr	1218(ra) # 802043b8 <threadid>
    80203efe:	05d00813          	li	a6,93
    80203f02:	00005797          	auipc	a5,0x5
    80203f06:	ac678793          	addi	a5,a5,-1338 # 802089c8 <digits+0x190>
    80203f0a:	872a                	mv	a4,a0
    80203f0c:	86a6                	mv	a3,s1
    80203f0e:	00004617          	auipc	a2,0x4
    80203f12:	10260613          	addi	a2,a2,258 # 80208010 <e_text+0x10>
    80203f16:	45fd                	li	a1,31
    80203f18:	00005517          	auipc	a0,0x5
    80203f1c:	b1850513          	addi	a0,a0,-1256 # 80208a30 <digits+0x1f8>
    80203f20:	fffff097          	auipc	ra,0xfffff
    80203f24:	1a6080e7          	jalr	422(ra) # 802030c6 <printf>
    80203f28:	fffff097          	auipc	ra,0xfffff
    80203f2c:	3b6080e7          	jalr	950(ra) # 802032de <shutdown>
		if (pi->nread == pi->nwrite)
    80203f30:	2004a583          	lw	a1,512(s1)
    80203f34:	2044a703          	lw	a4,516(s1)
	int r = 0;
    80203f38:	4901                	li	s2,0
		size = MIN(MIN(n - r, pi->nwrite - pi->nread),
    80203f3a:	20000b13          	li	s6,512
    80203f3e:	b749                	j	80203ec0 <piperead+0xfe>

0000000080203f40 <bin_loader>:
#include "trap.h"

extern char INIT_PROC[];

int bin_loader(struct inode *ip, struct proc *p)
{
    80203f40:	7119                	addi	sp,sp,-128
    80203f42:	fc86                	sd	ra,120(sp)
    80203f44:	f8a2                	sd	s0,112(sp)
    80203f46:	f4a6                	sd	s1,104(sp)
    80203f48:	f0ca                	sd	s2,96(sp)
    80203f4a:	ecce                	sd	s3,88(sp)
    80203f4c:	e8d2                	sd	s4,80(sp)
    80203f4e:	e4d6                	sd	s5,72(sp)
    80203f50:	e0da                	sd	s6,64(sp)
    80203f52:	fc5e                	sd	s7,56(sp)
    80203f54:	f862                	sd	s8,48(sp)
    80203f56:	f466                	sd	s9,40(sp)
    80203f58:	f06a                	sd	s10,32(sp)
    80203f5a:	ec6e                	sd	s11,24(sp)
    80203f5c:	0100                	addi	s0,sp,128
    80203f5e:	8c2a                	mv	s8,a0
    80203f60:	8b2e                	mv	s6,a1
	ivalid(ip);
    80203f62:	00002097          	auipc	ra,0x2
    80203f66:	9ba080e7          	jalr	-1606(ra) # 8020591c <ivalid>
	void *page;
	uint64 length = ip->size;
    80203f6a:	014c2d03          	lw	s10,20(s8) # fffffffffffff014 <e_bss+0xffffffff7ece1014>
    80203f6e:	020d1b93          	slli	s7,s10,0x20
    80203f72:	020bdb93          	srli	s7,s7,0x20
	uint64 va_start = BASE_ADDRESS;
	uint64 va_end = PGROUNDUP(BASE_ADDRESS + length);
    80203f76:	6789                	lui	a5,0x2
    80203f78:	17fd                	addi	a5,a5,-1
    80203f7a:	97de                	add	a5,a5,s7
    80203f7c:	f8f43423          	sd	a5,-120(s0)
    80203f80:	7afd                	lui	s5,0xfffff
    80203f82:	0157fab3          	and	s5,a5,s5
	for (uint64 va = va_start, off = 0; va < va_end;
    80203f86:	6785                	lui	a5,0x1
    80203f88:	0f57f763          	bgeu	a5,s5,80204076 <bin_loader+0x136>
    80203f8c:	6485                	lui	s1,0x1
	     va += PGSIZE, off += PAGE_SIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
		}
		readi(ip, 0, (uint64)page, off, PAGE_SIZE);
    80203f8e:	7cfd                	lui	s9,0xfffff
    80203f90:	6985                	lui	s3,0x1
		if (off + PAGE_SIZE > length) {
			memset(page + (length - off), 0,
    80203f92:	013b8db3          	add	s11,s7,s3
    80203f96:	a895                	j	8020400a <bin_loader+0xca>
			panic("...");
    80203f98:	00000097          	auipc	ra,0x0
    80203f9c:	406080e7          	jalr	1030(ra) # 8020439e <procid>
    80203fa0:	84aa                	mv	s1,a0
    80203fa2:	00000097          	auipc	ra,0x0
    80203fa6:	416080e7          	jalr	1046(ra) # 802043b8 <threadid>
    80203faa:	484d                	li	a6,19
    80203fac:	00005797          	auipc	a5,0x5
    80203fb0:	aac78793          	addi	a5,a5,-1364 # 80208a58 <digits+0x220>
    80203fb4:	872a                	mv	a4,a0
    80203fb6:	86a6                	mv	a3,s1
    80203fb8:	00004617          	auipc	a2,0x4
    80203fbc:	05860613          	addi	a2,a2,88 # 80208010 <e_text+0x10>
    80203fc0:	45fd                	li	a1,31
    80203fc2:	00005517          	auipc	a0,0x5
    80203fc6:	aa650513          	addi	a0,a0,-1370 # 80208a68 <digits+0x230>
    80203fca:	fffff097          	auipc	ra,0xfffff
    80203fce:	0fc080e7          	jalr	252(ra) # 802030c6 <printf>
    80203fd2:	fffff097          	auipc	ra,0xfffff
    80203fd6:	30c080e7          	jalr	780(ra) # 802032de <shutdown>
			memset(page + (length - off), 0,
    80203fda:	409d8533          	sub	a0,s11,s1
    80203fde:	41aa063b          	subw	a2,s4,s10
    80203fe2:	4581                	li	a1,0
    80203fe4:	954a                	add	a0,a0,s2
    80203fe6:	ffffc097          	auipc	ra,0xffffc
    80203fea:	0f2080e7          	jalr	242(ra) # 802000d8 <memset>
			       PAGE_SIZE - (length - off));
		}
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    80203fee:	4779                	li	a4,30
    80203ff0:	86ca                	mv	a3,s2
    80203ff2:	864e                	mv	a2,s3
    80203ff4:	85a6                	mv	a1,s1
    80203ff6:	008b3503          	ld	a0,8(s6)
    80203ffa:	ffffe097          	auipc	ra,0xffffe
    80203ffe:	7a4080e7          	jalr	1956(ra) # 8020279e <mappages>
    80204002:	e90d                	bnez	a0,80204034 <bin_loader+0xf4>
	     va += PGSIZE, off += PAGE_SIZE) {
    80204004:	94ce                	add	s1,s1,s3
	for (uint64 va = va_start, off = 0; va < va_end;
    80204006:	0754f863          	bgeu	s1,s5,80204076 <bin_loader+0x136>
		page = kalloc();
    8020400a:	00000097          	auipc	ra,0x0
    8020400e:	2ce080e7          	jalr	718(ra) # 802042d8 <kalloc>
    80204012:	892a                	mv	s2,a0
		if (page == 0) {
    80204014:	d151                	beqz	a0,80203f98 <bin_loader+0x58>
		readi(ip, 0, (uint64)page, off, PAGE_SIZE);
    80204016:	00048a1b          	sext.w	s4,s1
    8020401a:	874e                	mv	a4,s3
    8020401c:	014c86bb          	addw	a3,s9,s4
    80204020:	862a                	mv	a2,a0
    80204022:	4581                	li	a1,0
    80204024:	8562                	mv	a0,s8
    80204026:	00002097          	auipc	ra,0x2
    8020402a:	a74080e7          	jalr	-1420(ra) # 80205a9a <readi>
		if (off + PAGE_SIZE > length) {
    8020402e:	fc9bf0e3          	bgeu	s7,s1,80203fee <bin_loader+0xae>
    80204032:	b765                	j	80203fda <bin_loader+0x9a>
			     PTE_U | PTE_R | PTE_W | PTE_X) != 0)
			panic("...");
    80204034:	00000097          	auipc	ra,0x0
    80204038:	36a080e7          	jalr	874(ra) # 8020439e <procid>
    8020403c:	84aa                	mv	s1,a0
    8020403e:	00000097          	auipc	ra,0x0
    80204042:	37a080e7          	jalr	890(ra) # 802043b8 <threadid>
    80204046:	4871                	li	a6,28
    80204048:	00005797          	auipc	a5,0x5
    8020404c:	a1078793          	addi	a5,a5,-1520 # 80208a58 <digits+0x220>
    80204050:	872a                	mv	a4,a0
    80204052:	86a6                	mv	a3,s1
    80204054:	00004617          	auipc	a2,0x4
    80204058:	fbc60613          	addi	a2,a2,-68 # 80208010 <e_text+0x10>
    8020405c:	45fd                	li	a1,31
    8020405e:	00005517          	auipc	a0,0x5
    80204062:	a0a50513          	addi	a0,a0,-1526 # 80208a68 <digits+0x230>
    80204066:	fffff097          	auipc	ra,0xfffff
    8020406a:	060080e7          	jalr	96(ra) # 802030c6 <printf>
    8020406e:	fffff097          	auipc	ra,0xfffff
    80204072:	270080e7          	jalr	624(ra) # 802032de <shutdown>
	}

	p->max_page = va_end / PAGE_SIZE;
    80204076:	f8843783          	ld	a5,-120(s0)
    8020407a:	83b1                	srli	a5,a5,0xc
    8020407c:	00fb3823          	sd	a5,16(s6)
	p->ustack_base = va_end + PAGE_SIZE;
    80204080:	6785                	lui	a5,0x1
    80204082:	9abe                	add	s5,s5,a5
    80204084:	015b3c23          	sd	s5,24(s6)
	// alloc main thread
	if (allocthread(p, va_start, 1) != 0) {
    80204088:	4605                	li	a2,1
    8020408a:	6585                	lui	a1,0x1
    8020408c:	855a                	mv	a0,s6
    8020408e:	00000097          	auipc	ra,0x0
    80204092:	6ae080e7          	jalr	1710(ra) # 8020473c <allocthread>
    80204096:	e515                	bnez	a0,802040c2 <bin_loader+0x182>
		panic("proc %d alloc main thread failed!", p->pid);
	}
	debugf("bin loader fin");
    80204098:	4501                	li	a0,0
    8020409a:	ffffc097          	auipc	ra,0xffffc
    8020409e:	212080e7          	jalr	530(ra) # 802002ac <dummy>
	return 0;
}
    802040a2:	4501                	li	a0,0
    802040a4:	70e6                	ld	ra,120(sp)
    802040a6:	7446                	ld	s0,112(sp)
    802040a8:	74a6                	ld	s1,104(sp)
    802040aa:	7906                	ld	s2,96(sp)
    802040ac:	69e6                	ld	s3,88(sp)
    802040ae:	6a46                	ld	s4,80(sp)
    802040b0:	6aa6                	ld	s5,72(sp)
    802040b2:	6b06                	ld	s6,64(sp)
    802040b4:	7be2                	ld	s7,56(sp)
    802040b6:	7c42                	ld	s8,48(sp)
    802040b8:	7ca2                	ld	s9,40(sp)
    802040ba:	7d02                	ld	s10,32(sp)
    802040bc:	6de2                	ld	s11,24(sp)
    802040be:	6109                	addi	sp,sp,128
    802040c0:	8082                	ret
		panic("proc %d alloc main thread failed!", p->pid);
    802040c2:	00000097          	auipc	ra,0x0
    802040c6:	2dc080e7          	jalr	732(ra) # 8020439e <procid>
    802040ca:	84aa                	mv	s1,a0
    802040cc:	00000097          	auipc	ra,0x0
    802040d0:	2ec080e7          	jalr	748(ra) # 802043b8 <threadid>
    802040d4:	004b2883          	lw	a7,4(s6)
    802040d8:	02300813          	li	a6,35
    802040dc:	00005797          	auipc	a5,0x5
    802040e0:	97c78793          	addi	a5,a5,-1668 # 80208a58 <digits+0x220>
    802040e4:	872a                	mv	a4,a0
    802040e6:	86a6                	mv	a3,s1
    802040e8:	00004617          	auipc	a2,0x4
    802040ec:	f2860613          	addi	a2,a2,-216 # 80208010 <e_text+0x10>
    802040f0:	45fd                	li	a1,31
    802040f2:	00005517          	auipc	a0,0x5
    802040f6:	99650513          	addi	a0,a0,-1642 # 80208a88 <digits+0x250>
    802040fa:	fffff097          	auipc	ra,0xfffff
    802040fe:	fcc080e7          	jalr	-52(ra) # 802030c6 <printf>
    80204102:	fffff097          	auipc	ra,0xfffff
    80204106:	1dc080e7          	jalr	476(ra) # 802032de <shutdown>

000000008020410a <load_init_app>:

// load all apps and init the corresponding `proc` structure.
int load_init_app()
{
    8020410a:	7179                	addi	sp,sp,-48
    8020410c:	f406                	sd	ra,40(sp)
    8020410e:	f022                	sd	s0,32(sp)
    80204110:	ec26                	sd	s1,24(sp)
    80204112:	e84a                	sd	s2,16(sp)
    80204114:	1800                	addi	s0,sp,48
	struct inode *ip;
	struct proc *p = allocproc();
    80204116:	00000097          	auipc	ra,0x0
    8020411a:	4f2080e7          	jalr	1266(ra) # 80204608 <allocproc>
    8020411e:	84aa                	mv	s1,a0
	init_stdio(p);
    80204120:	00001097          	auipc	ra,0x1
    80204124:	856080e7          	jalr	-1962(ra) # 80204976 <init_stdio>
	if ((ip = namei(INIT_PROC)) == 0) {
    80204128:	00002517          	auipc	a0,0x2
    8020412c:	f6c50513          	addi	a0,a0,-148 # 80206094 <INIT_PROC>
    80204130:	00002097          	auipc	ra,0x2
    80204134:	ef4080e7          	jalr	-268(ra) # 80206024 <namei>
    80204138:	c53d                	beqz	a0,802041a6 <load_init_app+0x9c>
    8020413a:	892a                	mv	s2,a0
		errorf("invalid init proc name\n");
		return -1;
	}
	debugf("load init app %s", INIT_PROC);
    8020413c:	00002597          	auipc	a1,0x2
    80204140:	f5858593          	addi	a1,a1,-168 # 80206094 <INIT_PROC>
    80204144:	4501                	li	a0,0
    80204146:	ffffc097          	auipc	ra,0xffffc
    8020414a:	166080e7          	jalr	358(ra) # 802002ac <dummy>
	bin_loader(ip, p);
    8020414e:	85a6                	mv	a1,s1
    80204150:	854a                	mv	a0,s2
    80204152:	00000097          	auipc	ra,0x0
    80204156:	dee080e7          	jalr	-530(ra) # 80203f40 <bin_loader>
	iput(ip);
    8020415a:	854a                	mv	a0,s2
    8020415c:	00002097          	auipc	ra,0x2
    80204160:	880080e7          	jalr	-1920(ra) # 802059dc <iput>
	char *argv[2];
	argv[0] = INIT_PROC;
    80204164:	00002797          	auipc	a5,0x2
    80204168:	f3078793          	addi	a5,a5,-208 # 80206094 <INIT_PROC>
    8020416c:	fcf43823          	sd	a5,-48(s0)
	argv[1] = NULL;
    80204170:	fc043c23          	sd	zero,-40(s0)
	struct thread *t = &p->threads[0];
	t->trapframe->a0 = push_argv(p, argv);
    80204174:	fd040593          	addi	a1,s0,-48
    80204178:	8526                	mv	a0,s1
    8020417a:	00001097          	auipc	ra,0x1
    8020417e:	c54080e7          	jalr	-940(ra) # 80204dce <push_argv>
    80204182:	68fc                	ld	a5,208(s1)
    80204184:	fba8                	sd	a0,112(a5)
	t->state = RUNNABLE;
    80204186:	478d                	li	a5,3
    80204188:	0af4a823          	sw	a5,176(s1) # 10b0 <BASE_ADDRESS-0x801fef50>
	add_task(t);
    8020418c:	0b048513          	addi	a0,s1,176
    80204190:	00000097          	auipc	ra,0x0
    80204194:	426080e7          	jalr	1062(ra) # 802045b6 <add_task>
	return 0;
    80204198:	4501                	li	a0,0
    8020419a:	70a2                	ld	ra,40(sp)
    8020419c:	7402                	ld	s0,32(sp)
    8020419e:	64e2                	ld	s1,24(sp)
    802041a0:	6942                	ld	s2,16(sp)
    802041a2:	6145                	addi	sp,sp,48
    802041a4:	8082                	ret
		errorf("invalid init proc name\n");
    802041a6:	00000097          	auipc	ra,0x0
    802041aa:	1f8080e7          	jalr	504(ra) # 8020439e <procid>
    802041ae:	84aa                	mv	s1,a0
    802041b0:	00000097          	auipc	ra,0x0
    802041b4:	208080e7          	jalr	520(ra) # 802043b8 <threadid>
    802041b8:	872a                	mv	a4,a0
    802041ba:	86a6                	mv	a3,s1
    802041bc:	00004617          	auipc	a2,0x4
    802041c0:	ed460613          	addi	a2,a2,-300 # 80208090 <e_text+0x90>
    802041c4:	45fd                	li	a1,31
    802041c6:	00005517          	auipc	a0,0x5
    802041ca:	90250513          	addi	a0,a0,-1790 # 80208ac8 <digits+0x290>
    802041ce:	fffff097          	auipc	ra,0xfffff
    802041d2:	ef8080e7          	jalr	-264(ra) # 802030c6 <printf>
		return -1;
    802041d6:	557d                	li	a0,-1
    802041d8:	b7c9                	j	8020419a <load_init_app+0x90>

00000000802041da <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    802041da:	1101                	addi	sp,sp,-32
    802041dc:	ec06                	sd	ra,24(sp)
    802041de:	e822                	sd	s0,16(sp)
    802041e0:	e426                	sd	s1,8(sp)
    802041e2:	1000                	addi	s0,sp,32
	struct linklist *l;
	if (((uint64)pa % PGSIZE) != 0 || (char *)pa < ekernel ||
    802041e4:	03451793          	slli	a5,a0,0x34
    802041e8:	ef95                	bnez	a5,80204224 <kfree+0x4a>
    802041ea:	84aa                	mv	s1,a0
    802041ec:	0111a797          	auipc	a5,0x111a
    802041f0:	e1478793          	addi	a5,a5,-492 # 8131e000 <e_bss>
    802041f4:	02f56863          	bltu	a0,a5,80204224 <kfree+0x4a>
    802041f8:	47c5                	li	a5,17
    802041fa:	07ee                	slli	a5,a5,0x1b
    802041fc:	02f57463          	bgeu	a0,a5,80204224 <kfree+0x4a>
	    (uint64)pa >= PHYSTOP)
		panic("kfree");
	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);
    80204200:	6605                	lui	a2,0x1
    80204202:	4585                	li	a1,1
    80204204:	ffffc097          	auipc	ra,0xffffc
    80204208:	ed4080e7          	jalr	-300(ra) # 802000d8 <memset>
	l = (struct linklist *)pa;
	l->next = kmem.freelist;
    8020420c:	01119797          	auipc	a5,0x1119
    80204210:	0ec78793          	addi	a5,a5,236 # 8131d2f8 <kmem>
    80204214:	6398                	ld	a4,0(a5)
    80204216:	e098                	sd	a4,0(s1)
	kmem.freelist = l;
    80204218:	e384                	sd	s1,0(a5)
}
    8020421a:	60e2                	ld	ra,24(sp)
    8020421c:	6442                	ld	s0,16(sp)
    8020421e:	64a2                	ld	s1,8(sp)
    80204220:	6105                	addi	sp,sp,32
    80204222:	8082                	ret
		panic("kfree");
    80204224:	00000097          	auipc	ra,0x0
    80204228:	17a080e7          	jalr	378(ra) # 8020439e <procid>
    8020422c:	84aa                	mv	s1,a0
    8020422e:	00000097          	auipc	ra,0x0
    80204232:	18a080e7          	jalr	394(ra) # 802043b8 <threadid>
    80204236:	02500813          	li	a6,37
    8020423a:	00005797          	auipc	a5,0x5
    8020423e:	8be78793          	addi	a5,a5,-1858 # 80208af8 <digits+0x2c0>
    80204242:	872a                	mv	a4,a0
    80204244:	86a6                	mv	a3,s1
    80204246:	00004617          	auipc	a2,0x4
    8020424a:	dca60613          	addi	a2,a2,-566 # 80208010 <e_text+0x10>
    8020424e:	45fd                	li	a1,31
    80204250:	00005517          	auipc	a0,0x5
    80204254:	8b850513          	addi	a0,a0,-1864 # 80208b08 <digits+0x2d0>
    80204258:	fffff097          	auipc	ra,0xfffff
    8020425c:	e6e080e7          	jalr	-402(ra) # 802030c6 <printf>
    80204260:	fffff097          	auipc	ra,0xfffff
    80204264:	07e080e7          	jalr	126(ra) # 802032de <shutdown>

0000000080204268 <freerange>:
{
    80204268:	7179                	addi	sp,sp,-48
    8020426a:	f406                	sd	ra,40(sp)
    8020426c:	f022                	sd	s0,32(sp)
    8020426e:	ec26                	sd	s1,24(sp)
    80204270:	e84a                	sd	s2,16(sp)
    80204272:	e44e                	sd	s3,8(sp)
    80204274:	e052                	sd	s4,0(sp)
    80204276:	1800                	addi	s0,sp,48
	p = (char *)PGROUNDUP((uint64)pa_start);
    80204278:	6705                	lui	a4,0x1
    8020427a:	fff70793          	addi	a5,a4,-1 # fff <BASE_ADDRESS-0x801ff001>
    8020427e:	00f504b3          	add	s1,a0,a5
    80204282:	77fd                	lui	a5,0xfffff
    80204284:	8cfd                	and	s1,s1,a5
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80204286:	94ba                	add	s1,s1,a4
    80204288:	0095ee63          	bltu	a1,s1,802042a4 <freerange+0x3c>
    8020428c:	892e                	mv	s2,a1
		kfree(p);
    8020428e:	7a7d                	lui	s4,0xfffff
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80204290:	6985                	lui	s3,0x1
		kfree(p);
    80204292:	01448533          	add	a0,s1,s4
    80204296:	00000097          	auipc	ra,0x0
    8020429a:	f44080e7          	jalr	-188(ra) # 802041da <kfree>
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    8020429e:	94ce                	add	s1,s1,s3
    802042a0:	fe9979e3          	bgeu	s2,s1,80204292 <freerange+0x2a>
}
    802042a4:	70a2                	ld	ra,40(sp)
    802042a6:	7402                	ld	s0,32(sp)
    802042a8:	64e2                	ld	s1,24(sp)
    802042aa:	6942                	ld	s2,16(sp)
    802042ac:	69a2                	ld	s3,8(sp)
    802042ae:	6a02                	ld	s4,0(sp)
    802042b0:	6145                	addi	sp,sp,48
    802042b2:	8082                	ret

00000000802042b4 <kinit>:
{
    802042b4:	1141                	addi	sp,sp,-16
    802042b6:	e406                	sd	ra,8(sp)
    802042b8:	e022                	sd	s0,0(sp)
    802042ba:	0800                	addi	s0,sp,16
	freerange(ekernel, (void *)PHYSTOP);
    802042bc:	45c5                	li	a1,17
    802042be:	05ee                	slli	a1,a1,0x1b
    802042c0:	0111a517          	auipc	a0,0x111a
    802042c4:	d4050513          	addi	a0,a0,-704 # 8131e000 <e_bss>
    802042c8:	00000097          	auipc	ra,0x0
    802042cc:	fa0080e7          	jalr	-96(ra) # 80204268 <freerange>
}
    802042d0:	60a2                	ld	ra,8(sp)
    802042d2:	6402                	ld	s0,0(sp)
    802042d4:	0141                	addi	sp,sp,16
    802042d6:	8082                	ret

00000000802042d8 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc()
{
    802042d8:	1101                	addi	sp,sp,-32
    802042da:	ec06                	sd	ra,24(sp)
    802042dc:	e822                	sd	s0,16(sp)
    802042de:	e426                	sd	s1,8(sp)
    802042e0:	1000                	addi	s0,sp,32
	struct linklist *l;
	l = kmem.freelist;
    802042e2:	01119797          	auipc	a5,0x1119
    802042e6:	01678793          	addi	a5,a5,22 # 8131d2f8 <kmem>
    802042ea:	6384                	ld	s1,0(a5)
	if (l) {
    802042ec:	cc89                	beqz	s1,80204306 <kalloc+0x2e>
		kmem.freelist = l->next;
    802042ee:	609c                	ld	a5,0(s1)
    802042f0:	01119717          	auipc	a4,0x1119
    802042f4:	00f73423          	sd	a5,8(a4) # 8131d2f8 <kmem>
		memset((char *)l, 5, PGSIZE); // fill with junk
    802042f8:	6605                	lui	a2,0x1
    802042fa:	4595                	li	a1,5
    802042fc:	8526                	mv	a0,s1
    802042fe:	ffffc097          	auipc	ra,0xffffc
    80204302:	dda080e7          	jalr	-550(ra) # 802000d8 <memset>
	}
	return (void *)l;
    80204306:	8526                	mv	a0,s1
    80204308:	60e2                	ld	ra,24(sp)
    8020430a:	6442                	ld	s0,16(sp)
    8020430c:	64a2                	ld	s1,8(sp)
    8020430e:	6105                	addi	sp,sp,32
    80204310:	8082                	ret

0000000080204312 <plicinit>:
//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit()
{
    80204312:	1141                	addi	sp,sp,-16
    80204314:	e406                	sd	ra,8(sp)
    80204316:	e022                	sd	s0,0(sp)
    80204318:	0800                	addi	s0,sp,16
	// set desired IRQ priorities non-zero (otherwise disabled).
	int hart = cpuid();
    8020431a:	00000097          	auipc	ra,0x0
    8020431e:	0b6080e7          	jalr	182(ra) # 802043d0 <cpuid>
	*(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80204322:	0c0007b7          	lui	a5,0xc000
    80204326:	4705                	li	a4,1
    80204328:	c3d8                	sw	a4,4(a5)
	// set uart's enable bit for this hart's S-mode.
	*(uint32 *)PLIC_SENABLE(hart) = (1 << VIRTIO0_IRQ);
    8020432a:	0085171b          	slliw	a4,a0,0x8
    8020432e:	0c0027b7          	lui	a5,0xc002
    80204332:	97ba                	add	a5,a5,a4
    80204334:	4709                	li	a4,2
    80204336:	08e7a023          	sw	a4,128(a5) # c002080 <BASE_ADDRESS-0x741fdf80>
	// set this hart's S-mode priority threshold to 0.
	*(uint32 *)PLIC_SPRIORITY(hart) = 0;
    8020433a:	00d5151b          	slliw	a0,a0,0xd
    8020433e:	0c2017b7          	lui	a5,0xc201
    80204342:	953e                	add	a0,a0,a5
    80204344:	00052023          	sw	zero,0(a0)
}
    80204348:	60a2                	ld	ra,8(sp)
    8020434a:	6402                	ld	s0,0(sp)
    8020434c:	0141                	addi	sp,sp,16
    8020434e:	8082                	ret

0000000080204350 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim()
{
    80204350:	1141                	addi	sp,sp,-16
    80204352:	e406                	sd	ra,8(sp)
    80204354:	e022                	sd	s0,0(sp)
    80204356:	0800                	addi	s0,sp,16
	int hart = cpuid();
    80204358:	00000097          	auipc	ra,0x0
    8020435c:	078080e7          	jalr	120(ra) # 802043d0 <cpuid>
	int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80204360:	00d5151b          	slliw	a0,a0,0xd
    80204364:	0c2017b7          	lui	a5,0xc201
    80204368:	97aa                	add	a5,a5,a0
	return irq;
}
    8020436a:	43c8                	lw	a0,4(a5)
    8020436c:	60a2                	ld	ra,8(sp)
    8020436e:	6402                	ld	s0,0(sp)
    80204370:	0141                	addi	sp,sp,16
    80204372:	8082                	ret

0000000080204374 <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq)
{
    80204374:	1101                	addi	sp,sp,-32
    80204376:	ec06                	sd	ra,24(sp)
    80204378:	e822                	sd	s0,16(sp)
    8020437a:	e426                	sd	s1,8(sp)
    8020437c:	1000                	addi	s0,sp,32
    8020437e:	84aa                	mv	s1,a0
	int hart = cpuid();
    80204380:	00000097          	auipc	ra,0x0
    80204384:	050080e7          	jalr	80(ra) # 802043d0 <cpuid>
	*(uint32 *)PLIC_SCLAIM(hart) = irq;
    80204388:	00d5151b          	slliw	a0,a0,0xd
    8020438c:	0c2017b7          	lui	a5,0xc201
    80204390:	97aa                	add	a5,a5,a0
    80204392:	c3c4                	sw	s1,4(a5)
}
    80204394:	60e2                	ld	ra,24(sp)
    80204396:	6442                	ld	s0,16(sp)
    80204398:	64a2                	ld	s1,8(sp)
    8020439a:	6105                	addi	sp,sp,32
    8020439c:	8082                	ret

000000008020439e <procid>:
struct thread *current_thread;
struct thread idle;
struct queue task_queue;

int procid()
{
    8020439e:	1141                	addi	sp,sp,-16
    802043a0:	e422                	sd	s0,8(sp)
    802043a2:	0800                	addi	s0,sp,16
	return 0;
}

struct proc *curr_proc()
{
	return current_thread->process;
    802043a4:	01119797          	auipc	a5,0x1119
    802043a8:	f5c78793          	addi	a5,a5,-164 # 8131d300 <current_thread>
    802043ac:	639c                	ld	a5,0(a5)
	return curr_proc()->pid;
    802043ae:	679c                	ld	a5,8(a5)
}
    802043b0:	43c8                	lw	a0,4(a5)
    802043b2:	6422                	ld	s0,8(sp)
    802043b4:	0141                	addi	sp,sp,16
    802043b6:	8082                	ret

00000000802043b8 <threadid>:
{
    802043b8:	1141                	addi	sp,sp,-16
    802043ba:	e422                	sd	s0,8(sp)
    802043bc:	0800                	addi	s0,sp,16
	return curr_thread()->tid;
    802043be:	01119797          	auipc	a5,0x1119
    802043c2:	f4278793          	addi	a5,a5,-190 # 8131d300 <current_thread>
    802043c6:	639c                	ld	a5,0(a5)
}
    802043c8:	43c8                	lw	a0,4(a5)
    802043ca:	6422                	ld	s0,8(sp)
    802043cc:	0141                	addi	sp,sp,16
    802043ce:	8082                	ret

00000000802043d0 <cpuid>:
{
    802043d0:	1141                	addi	sp,sp,-16
    802043d2:	e422                	sd	s0,8(sp)
    802043d4:	0800                	addi	s0,sp,16
}
    802043d6:	4501                	li	a0,0
    802043d8:	6422                	ld	s0,8(sp)
    802043da:	0141                	addi	sp,sp,16
    802043dc:	8082                	ret

00000000802043de <curr_proc>:
{
    802043de:	1141                	addi	sp,sp,-16
    802043e0:	e422                	sd	s0,8(sp)
    802043e2:	0800                	addi	s0,sp,16
	return current_thread->process;
    802043e4:	01119797          	auipc	a5,0x1119
    802043e8:	f1c78793          	addi	a5,a5,-228 # 8131d300 <current_thread>
    802043ec:	639c                	ld	a5,0(a5)
}
    802043ee:	6788                	ld	a0,8(a5)
    802043f0:	6422                	ld	s0,8(sp)
    802043f2:	0141                	addi	sp,sp,16
    802043f4:	8082                	ret

00000000802043f6 <curr_thread>:

struct thread *curr_thread()
{
    802043f6:	1141                	addi	sp,sp,-16
    802043f8:	e422                	sd	s0,8(sp)
    802043fa:	0800                	addi	s0,sp,16
	return current_thread;
}
    802043fc:	01119797          	auipc	a5,0x1119
    80204400:	f0478793          	addi	a5,a5,-252 # 8131d300 <current_thread>
    80204404:	6388                	ld	a0,0(a5)
    80204406:	6422                	ld	s0,8(sp)
    80204408:	0141                	addi	sp,sp,16
    8020440a:	8082                	ret

000000008020440c <proc_init>:

// initialize the proc table at boot time.
void proc_init()
{
    8020440c:	1141                	addi	sp,sp,-16
    8020440e:	e406                	sd	ra,8(sp)
    80204410:	e022                	sd	s0,0(sp)
    80204412:	0800                	addi	s0,sp,16
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80204414:	0103a697          	auipc	a3,0x103a
    80204418:	c9c68693          	addi	a3,a3,-868 # 8123e0b0 <pool+0xb0>
    8020441c:	0103a717          	auipc	a4,0x103a
    80204420:	69470713          	addi	a4,a4,1684 # 8123eab0 <pool+0xab0>
    80204424:	01119597          	auipc	a1,0x1119
    80204428:	a8c58593          	addi	a1,a1,-1396 # 8131ceb0 <itable+0xa98>
    8020442c:	6609                	lui	a2,0x2
    8020442e:	bc860613          	addi	a2,a2,-1080 # 1bc8 <BASE_ADDRESS-0x801fe438>
    80204432:	a029                	j	8020443c <proc_init+0x30>
    80204434:	96b2                	add	a3,a3,a2
    80204436:	9732                	add	a4,a4,a2
    80204438:	00b70c63          	beq	a4,a1,80204450 <proc_init+0x44>
		p->state = P_UNUSED;
    8020443c:	f406a823          	sw	zero,-176(a3)
    80204440:	87b6                	mv	a5,a3
		for (int tid = 0; tid < NTHREAD; ++tid) {
			struct thread *t = &p->threads[tid];
			t->state = T_UNUSED;
    80204442:	0007a023          	sw	zero,0(a5)
    80204446:	0a078793          	addi	a5,a5,160
		for (int tid = 0; tid < NTHREAD; ++tid) {
    8020444a:	fee79ce3          	bne	a5,a4,80204442 <proc_init+0x36>
    8020444e:	b7dd                	j	80204434 <proc_init+0x28>
		}
	}
	idle.kstack = (uint64)boot_stack_top;
    80204450:	00039797          	auipc	a5,0x39
    80204454:	bb078793          	addi	a5,a5,-1104 # 8023d000 <idle>
    80204458:	00016717          	auipc	a4,0x16
    8020445c:	ba870713          	addi	a4,a4,-1112 # 8021a000 <process_queue_data>
    80204460:	ef98                	sd	a4,24(a5)
	current_thread = &idle;
    80204462:	01119717          	auipc	a4,0x1119
    80204466:	e8f73f23          	sd	a5,-354(a4) # 8131d300 <current_thread>
	// for procid() and threadid()
	idle.process = pool;
    8020446a:	0103a717          	auipc	a4,0x103a
    8020446e:	b9670713          	addi	a4,a4,-1130 # 8123e000 <pool>
    80204472:	e798                	sd	a4,8(a5)
	idle.tid = -1;
    80204474:	577d                	li	a4,-1
    80204476:	c3d8                	sw	a4,4(a5)
	init_queue(&task_queue, QUEUE_SIZE, process_queue_data);
    80204478:	00016617          	auipc	a2,0x16
    8020447c:	b8860613          	addi	a2,a2,-1144 # 8021a000 <process_queue_data>
    80204480:	40000593          	li	a1,1024
    80204484:	00039517          	auipc	a0,0x39
    80204488:	c1c50513          	addi	a0,a0,-996 # 8023d0a0 <task_queue>
    8020448c:	ffffc097          	auipc	ra,0xffffc
    80204490:	b80080e7          	jalr	-1152(ra) # 8020000c <init_queue>
}
    80204494:	60a2                	ld	ra,8(sp)
    80204496:	6402                	ld	s0,0(sp)
    80204498:	0141                	addi	sp,sp,16
    8020449a:	8082                	ret

000000008020449c <allocpid>:

int allocpid()
{
    8020449c:	1141                	addi	sp,sp,-16
    8020449e:	e422                	sd	s0,8(sp)
    802044a0:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    802044a2:	00005797          	auipc	a5,0x5
    802044a6:	b5e78793          	addi	a5,a5,-1186 # 80209000 <e_rodata>
    802044aa:	4388                	lw	a0,0(a5)
    802044ac:	0015071b          	addiw	a4,a0,1
    802044b0:	c398                	sw	a4,0(a5)
}
    802044b2:	6422                	ld	s0,8(sp)
    802044b4:	0141                	addi	sp,sp,16
    802044b6:	8082                	ret

00000000802044b8 <alloctid>:

int alloctid(const struct proc *process)
{
    802044b8:	1141                	addi	sp,sp,-16
    802044ba:	e422                	sd	s0,8(sp)
    802044bc:	0800                	addi	s0,sp,16
	for (int i = 0; i < NTHREAD; ++i) {
		if (process->threads[i].state == T_UNUSED)
    802044be:	0b052783          	lw	a5,176(a0)
    802044c2:	c385                	beqz	a5,802044e2 <alloctid+0x2a>
    802044c4:	15050793          	addi	a5,a0,336
	for (int i = 0; i < NTHREAD; ++i) {
    802044c8:	4505                	li	a0,1
    802044ca:	46c1                	li	a3,16
		if (process->threads[i].state == T_UNUSED)
    802044cc:	4398                	lw	a4,0(a5)
    802044ce:	c719                	beqz	a4,802044dc <alloctid+0x24>
	for (int i = 0; i < NTHREAD; ++i) {
    802044d0:	2505                	addiw	a0,a0,1
    802044d2:	0a078793          	addi	a5,a5,160
    802044d6:	fed51be3          	bne	a0,a3,802044cc <alloctid+0x14>
			return i;
	}
	return -1;
    802044da:	557d                	li	a0,-1
}
    802044dc:	6422                	ld	s0,8(sp)
    802044de:	0141                	addi	sp,sp,16
    802044e0:	8082                	ret
	for (int i = 0; i < NTHREAD; ++i) {
    802044e2:	4501                	li	a0,0
    802044e4:	bfe5                	j	802044dc <alloctid+0x24>

00000000802044e6 <id_to_task>:

// get task by unique task id
struct thread *id_to_task(int index)
{
    802044e6:	1141                	addi	sp,sp,-16
    802044e8:	e422                	sd	s0,8(sp)
    802044ea:	0800                	addi	s0,sp,16
	if (index < 0) {
    802044ec:	02054f63          	bltz	a0,8020452a <id_to_task+0x44>
		return NULL;
	}
	int pool_id = index / NTHREAD;
	int tid = index % NTHREAD;
    802044f0:	41f5571b          	sraiw	a4,a0,0x1f
    802044f4:	01c7571b          	srliw	a4,a4,0x1c
    802044f8:	9d39                	addw	a0,a0,a4
    802044fa:	00f57793          	andi	a5,a0,15
	struct thread *t = &pool[pool_id].threads[tid];
    802044fe:	40e7873b          	subw	a4,a5,a4
    80204502:	00271793          	slli	a5,a4,0x2
    80204506:	97ba                	add	a5,a5,a4
    80204508:	0796                	slli	a5,a5,0x5
    8020450a:	4045551b          	sraiw	a0,a0,0x4
    8020450e:	6709                	lui	a4,0x2
    80204510:	bc870713          	addi	a4,a4,-1080 # 1bc8 <BASE_ADDRESS-0x801fe438>
    80204514:	02e50533          	mul	a0,a0,a4
    80204518:	953e                	add	a0,a0,a5
    8020451a:	0103a797          	auipc	a5,0x103a
    8020451e:	b9678793          	addi	a5,a5,-1130 # 8123e0b0 <pool+0xb0>
    80204522:	953e                	add	a0,a0,a5
	return t;
}
    80204524:	6422                	ld	s0,8(sp)
    80204526:	0141                	addi	sp,sp,16
    80204528:	8082                	ret
		return NULL;
    8020452a:	4501                	li	a0,0
    8020452c:	bfe5                	j	80204524 <id_to_task+0x3e>

000000008020452e <task_to_id>:

// ncode unique task id for each thread
int task_to_id(struct thread *t)
{
    8020452e:	1141                	addi	sp,sp,-16
    80204530:	e422                	sd	s0,8(sp)
    80204532:	0800                	addi	s0,sp,16
	int pool_id = t->process - pool;
    80204534:	651c                	ld	a5,8(a0)
    80204536:	0103a717          	auipc	a4,0x103a
    8020453a:	aca70713          	addi	a4,a4,-1334 # 8123e000 <pool>
    8020453e:	8f99                	sub	a5,a5,a4
    80204540:	878d                	srai	a5,a5,0x3
    80204542:	00005717          	auipc	a4,0x5
    80204546:	aae70713          	addi	a4,a4,-1362 # 80208ff0 <SBI_SET_TIMER+0x18>
    8020454a:	6318                	ld	a4,0(a4)
    8020454c:	02e787b3          	mul	a5,a5,a4
	int task_id = pool_id * NTHREAD + t->tid;
    80204550:	0047979b          	slliw	a5,a5,0x4
    80204554:	4148                	lw	a0,4(a0)
	return task_id;
}
    80204556:	9d3d                	addw	a0,a0,a5
    80204558:	6422                	ld	s0,8(sp)
    8020455a:	0141                	addi	sp,sp,16
    8020455c:	8082                	ret

000000008020455e <fetch_task>:

struct thread *fetch_task()
{
    8020455e:	1101                	addi	sp,sp,-32
    80204560:	ec06                	sd	ra,24(sp)
    80204562:	e822                	sd	s0,16(sp)
    80204564:	e426                	sd	s1,8(sp)
    80204566:	e04a                	sd	s2,0(sp)
    80204568:	1000                	addi	s0,sp,32
	int index = pop_queue(&task_queue);
    8020456a:	00039517          	auipc	a0,0x39
    8020456e:	b3650513          	addi	a0,a0,-1226 # 8023d0a0 <task_queue>
    80204572:	ffffc097          	auipc	ra,0xffffc
    80204576:	b2a080e7          	jalr	-1238(ra) # 8020009c <pop_queue>
    8020457a:	892a                	mv	s2,a0
	struct thread *t = id_to_task(index);
    8020457c:	00000097          	auipc	ra,0x0
    80204580:	f6a080e7          	jalr	-150(ra) # 802044e6 <id_to_task>
    80204584:	84aa                	mv	s1,a0
	if (t == NULL) {
    80204586:	c115                	beqz	a0,802045aa <fetch_task+0x4c>
		debugf("No task to fetch\n");
		return t;
	}
	int tid = t->tid;
	int pid = t->process->pid;
    80204588:	651c                	ld	a5,8(a0)
	tracef("fetch index %d(pid=%d, tid=%d, addr=%p) from task queue", index,
    8020458a:	872a                	mv	a4,a0
    8020458c:	4154                	lw	a3,4(a0)
    8020458e:	43d0                	lw	a2,4(a5)
    80204590:	85ca                	mv	a1,s2
    80204592:	4501                	li	a0,0
    80204594:	ffffc097          	auipc	ra,0xffffc
    80204598:	d18080e7          	jalr	-744(ra) # 802002ac <dummy>
	       pid, tid, (uint64)t);
	return t;
}
    8020459c:	8526                	mv	a0,s1
    8020459e:	60e2                	ld	ra,24(sp)
    802045a0:	6442                	ld	s0,16(sp)
    802045a2:	64a2                	ld	s1,8(sp)
    802045a4:	6902                	ld	s2,0(sp)
    802045a6:	6105                	addi	sp,sp,32
    802045a8:	8082                	ret
		debugf("No task to fetch\n");
    802045aa:	4501                	li	a0,0
    802045ac:	ffffc097          	auipc	ra,0xffffc
    802045b0:	d00080e7          	jalr	-768(ra) # 802002ac <dummy>
		return t;
    802045b4:	b7e5                	j	8020459c <fetch_task+0x3e>

00000000802045b6 <add_task>:

void add_task(struct thread *t)
{
    802045b6:	7179                	addi	sp,sp,-48
    802045b8:	f406                	sd	ra,40(sp)
    802045ba:	f022                	sd	s0,32(sp)
    802045bc:	ec26                	sd	s1,24(sp)
    802045be:	e84a                	sd	s2,16(sp)
    802045c0:	e44e                	sd	s3,8(sp)
    802045c2:	1800                	addi	s0,sp,48
    802045c4:	84aa                	mv	s1,a0
	int task_id = task_to_id(t);
    802045c6:	00000097          	auipc	ra,0x0
    802045ca:	f68080e7          	jalr	-152(ra) # 8020452e <task_to_id>
    802045ce:	892a                	mv	s2,a0
	int pid = t->process->pid;
    802045d0:	649c                	ld	a5,8(s1)
    802045d2:	0047a983          	lw	s3,4(a5)
	push_queue(&task_queue, task_id);
    802045d6:	85aa                	mv	a1,a0
    802045d8:	00039517          	auipc	a0,0x39
    802045dc:	ac850513          	addi	a0,a0,-1336 # 8023d0a0 <task_queue>
    802045e0:	ffffc097          	auipc	ra,0xffffc
    802045e4:	a48080e7          	jalr	-1464(ra) # 80200028 <push_queue>
	tracef("add index %d(pid=%d, tid=%d, addr=%p) to task queue", task_id,
    802045e8:	8726                	mv	a4,s1
    802045ea:	40d4                	lw	a3,4(s1)
    802045ec:	864e                	mv	a2,s3
    802045ee:	85ca                	mv	a1,s2
    802045f0:	4501                	li	a0,0
    802045f2:	ffffc097          	auipc	ra,0xffffc
    802045f6:	cba080e7          	jalr	-838(ra) # 802002ac <dummy>
	       pid, t->tid, (uint64)t);
}
    802045fa:	70a2                	ld	ra,40(sp)
    802045fc:	7402                	ld	s0,32(sp)
    802045fe:	64e2                	ld	s1,24(sp)
    80204600:	6942                	ld	s2,16(sp)
    80204602:	69a2                	ld	s3,8(sp)
    80204604:	6145                	addi	sp,sp,48
    80204606:	8082                	ret

0000000080204608 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc()
{
    80204608:	1101                	addi	sp,sp,-32
    8020460a:	ec06                	sd	ra,24(sp)
    8020460c:	e822                	sd	s0,16(sp)
    8020460e:	e426                	sd	s1,8(sp)
    80204610:	e04a                	sd	s2,0(sp)
    80204612:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
		if (p->state == P_UNUSED) {
    80204614:	0103a797          	auipc	a5,0x103a
    80204618:	9ec78793          	addi	a5,a5,-1556 # 8123e000 <pool>
    8020461c:	439c                	lw	a5,0(a5)
    8020461e:	c39d                	beqz	a5,80204644 <allocproc+0x3c>
	for (p = pool; p < &pool[NPROC]; p++) {
    80204620:	0103b497          	auipc	s1,0x103b
    80204624:	5a848493          	addi	s1,s1,1448 # 8123fbc8 <pool+0x1bc8>
    80204628:	6709                	lui	a4,0x2
    8020462a:	bc870713          	addi	a4,a4,-1080 # 1bc8 <BASE_ADDRESS-0x801fe438>
    8020462e:	01118697          	auipc	a3,0x1118
    80204632:	dd268693          	addi	a3,a3,-558 # 8131c400 <sb>
		if (p->state == P_UNUSED) {
    80204636:	409c                	lw	a5,0(s1)
    80204638:	cb91                	beqz	a5,8020464c <allocproc+0x44>
	for (p = pool; p < &pool[NPROC]; p++) {
    8020463a:	94ba                	add	s1,s1,a4
    8020463c:	fed49de3          	bne	s1,a3,80204636 <allocproc+0x2e>
			goto found;
		}
	}
	return 0;
    80204640:	4481                	li	s1,0
    80204642:	a8c1                	j	80204712 <allocproc+0x10a>
	for (p = pool; p < &pool[NPROC]; p++) {
    80204644:	0103a497          	auipc	s1,0x103a
    80204648:	9bc48493          	addi	s1,s1,-1604 # 8123e000 <pool>

found:
	// init proc
	p->pid = allocpid();
    8020464c:	00000097          	auipc	ra,0x0
    80204650:	e50080e7          	jalr	-432(ra) # 8020449c <allocpid>
    80204654:	c0c8                	sw	a0,4(s1)
	p->state = P_USED;
    80204656:	4785                	li	a5,1
    80204658:	c09c                	sw	a5,0(s1)
	p->max_page = 0;
    8020465a:	0004b823          	sd	zero,16(s1)
	p->parent = NULL;
    8020465e:	0204b023          	sd	zero,32(s1)
	p->exit_code = 0;
    80204662:	0204b423          	sd	zero,40(s1)
	p->pagetable = uvmcreate();
    80204666:	ffffe097          	auipc	ra,0xffffe
    8020466a:	4e2080e7          	jalr	1250(ra) # 80202b48 <uvmcreate>
    8020466e:	e488                	sd	a0,8(s1)
	memset((void *)p->files, 0, sizeof(struct file *) * FD_BUFFER_SIZE);
    80204670:	08000613          	li	a2,128
    80204674:	4581                	li	a1,0
    80204676:	03048513          	addi	a0,s1,48
    8020467a:	ffffc097          	auipc	ra,0xffffc
    8020467e:	a5e080e7          	jalr	-1442(ra) # 802000d8 <memset>
	p->next_mutex_id = 0;
    80204682:	6905                	lui	s2,0x1
    80204684:	012487b3          	add	a5,s1,s2
    80204688:	aa07a823          	sw	zero,-1360(a5)
	p->next_semaphore_id = 0;
    8020468c:	aa07aa23          	sw	zero,-1356(a5)
	p->next_condvar_id = 0;
    80204690:	aa07ac23          	sw	zero,-1352(a5)
	// LAB5: (1) you may initialize your new proc variables here
	p->enable_DLD = 0;
    80204694:	3807a023          	sw	zero,896(a5)
	memset(p->mutex_available, 0, sizeof(p->mutex_available));
    80204698:	38490513          	addi	a0,s2,900 # 1384 <BASE_ADDRESS-0x801fec7c>
    8020469c:	02000613          	li	a2,32
    802046a0:	4581                	li	a1,0
    802046a2:	9526                	add	a0,a0,s1
    802046a4:	ffffc097          	auipc	ra,0xffffc
    802046a8:	a34080e7          	jalr	-1484(ra) # 802000d8 <memset>
	memset(p->mutex_allocation, 0, sizeof(p->mutex_allocation));
    802046ac:	3a490513          	addi	a0,s2,932
    802046b0:	20000613          	li	a2,512
    802046b4:	4581                	li	a1,0
    802046b6:	9526                	add	a0,a0,s1
    802046b8:	ffffc097          	auipc	ra,0xffffc
    802046bc:	a20080e7          	jalr	-1504(ra) # 802000d8 <memset>
	memset(p->mutex_request, 0, sizeof(p->mutex_request));
    802046c0:	5a490513          	addi	a0,s2,1444
    802046c4:	20000613          	li	a2,512
    802046c8:	4581                	li	a1,0
    802046ca:	9526                	add	a0,a0,s1
    802046cc:	ffffc097          	auipc	ra,0xffffc
    802046d0:	a0c080e7          	jalr	-1524(ra) # 802000d8 <memset>

	memset(p->sem_available, 0, sizeof(p->sem_available));
    802046d4:	7a490513          	addi	a0,s2,1956
    802046d8:	02000613          	li	a2,32
    802046dc:	4581                	li	a1,0
    802046de:	9526                	add	a0,a0,s1
    802046e0:	ffffc097          	auipc	ra,0xffffc
    802046e4:	9f8080e7          	jalr	-1544(ra) # 802000d8 <memset>
	memset(p->sem_allocation, 0, sizeof(p->sem_allocation));
    802046e8:	7c490513          	addi	a0,s2,1988
    802046ec:	20000613          	li	a2,512
    802046f0:	4581                	li	a1,0
    802046f2:	9526                	add	a0,a0,s1
    802046f4:	ffffc097          	auipc	ra,0xffffc
    802046f8:	9e4080e7          	jalr	-1564(ra) # 802000d8 <memset>
	memset(p->sem_request, 0, sizeof(p->sem_request));
    802046fc:	20000613          	li	a2,512
    80204700:	4581                	li	a1,0
    80204702:	6509                	lui	a0,0x2
    80204704:	9c450513          	addi	a0,a0,-1596 # 19c4 <BASE_ADDRESS-0x801fe63c>
    80204708:	9526                	add	a0,a0,s1
    8020470a:	ffffc097          	auipc	ra,0xffffc
    8020470e:	9ce080e7          	jalr	-1586(ra) # 802000d8 <memset>
	return p;
}
    80204712:	8526                	mv	a0,s1
    80204714:	60e2                	ld	ra,24(sp)
    80204716:	6442                	ld	s0,16(sp)
    80204718:	64a2                	ld	s1,8(sp)
    8020471a:	6902                	ld	s2,0(sp)
    8020471c:	6105                	addi	sp,sp,32
    8020471e:	8082                	ret

0000000080204720 <get_thread_trapframe_va>:

inline uint64 get_thread_trapframe_va(int tid)
{
    80204720:	1141                	addi	sp,sp,-16
    80204722:	e422                	sd	s0,8(sp)
    80204724:	0800                	addi	s0,sp,16
	return TRAPFRAME - tid * TRAP_PAGE_SIZE;
    80204726:	00c5151b          	slliw	a0,a0,0xc
    8020472a:	020007b7          	lui	a5,0x2000
}
    8020472e:	17fd                	addi	a5,a5,-1
    80204730:	07b6                	slli	a5,a5,0xd
    80204732:	40a78533          	sub	a0,a5,a0
    80204736:	6422                	ld	s0,8(sp)
    80204738:	0141                	addi	sp,sp,16
    8020473a:	8082                	ret

000000008020473c <allocthread>:
{
	return t->process->ustack_base + t->tid * USTACK_SIZE;
}

int allocthread(struct proc *p, uint64 entry, int alloc_user_res)
{
    8020473c:	715d                	addi	sp,sp,-80
    8020473e:	e486                	sd	ra,72(sp)
    80204740:	e0a2                	sd	s0,64(sp)
    80204742:	fc26                	sd	s1,56(sp)
    80204744:	f84a                	sd	s2,48(sp)
    80204746:	f44e                	sd	s3,40(sp)
    80204748:	f052                	sd	s4,32(sp)
    8020474a:	ec56                	sd	s5,24(sp)
    8020474c:	e85a                	sd	s6,16(sp)
    8020474e:	e45e                	sd	s7,8(sp)
    80204750:	0880                	addi	s0,sp,80
	int tid;
	struct thread *t;
	for (tid = 0; tid < NTHREAD; ++tid) {
		t = &p->threads[tid];
		if (t->state == T_UNUSED) {
    80204752:	0b052783          	lw	a5,176(a0)
    80204756:	cb8d                	beqz	a5,80204788 <allocthread+0x4c>
    80204758:	15050793          	addi	a5,a0,336
	for (tid = 0; tid < NTHREAD; ++tid) {
    8020475c:	4485                	li	s1,1
    8020475e:	4841                	li	a6,16
		if (t->state == T_UNUSED) {
    80204760:	4394                	lw	a3,0(a5)
    80204762:	c685                	beqz	a3,8020478a <allocthread+0x4e>
	for (tid = 0; tid < NTHREAD; ++tid) {
    80204764:	2485                	addiw	s1,s1,1
    80204766:	0a078793          	addi	a5,a5,160 # 20000a0 <BASE_ADDRESS-0x7e1fff60>
    8020476a:	ff049be3          	bne	s1,a6,80204760 <allocthread+0x24>
			goto found;
		}
	}
	return -1;
    8020476e:	54fd                	li	s1,-1
	// we do not add thread to scheduler immediately
	debugf("allocthread p: %d, o: %d, t: %d, e: %p, sp: %p, spp: %p",
	       p->pid, (p - pool), t->tid, entry, t->ustack,
	       useraddr(p->pagetable, t->ustack));
	return tid;
}
    80204770:	8526                	mv	a0,s1
    80204772:	60a6                	ld	ra,72(sp)
    80204774:	6406                	ld	s0,64(sp)
    80204776:	74e2                	ld	s1,56(sp)
    80204778:	7942                	ld	s2,48(sp)
    8020477a:	79a2                	ld	s3,40(sp)
    8020477c:	7a02                	ld	s4,32(sp)
    8020477e:	6ae2                	ld	s5,24(sp)
    80204780:	6b42                	ld	s6,16(sp)
    80204782:	6ba2                	ld	s7,8(sp)
    80204784:	6161                	addi	sp,sp,80
    80204786:	8082                	ret
	for (tid = 0; tid < NTHREAD; ++tid) {
    80204788:	4481                	li	s1,0
    8020478a:	8b2e                	mv	s6,a1
    8020478c:	892a                	mv	s2,a0
	t->tid = tid;
    8020478e:	00249793          	slli	a5,s1,0x2
    80204792:	97a6                	add	a5,a5,s1
    80204794:	0796                	slli	a5,a5,0x5
    80204796:	97aa                	add	a5,a5,a0
    80204798:	0a97aa23          	sw	s1,180(a5)
	t->state = T_USED;
    8020479c:	4705                	li	a4,1
    8020479e:	0ae7a823          	sw	a4,176(a5)
	t->process = p;
    802047a2:	ffc8                	sd	a0,184(a5)
	t->exit_code = 0;
    802047a4:	1407b423          	sd	zero,328(a5)
	t->kstack = (uint64)kstack[p - pool][tid];
    802047a8:	0103aa17          	auipc	s4,0x103a
    802047ac:	858a0a13          	addi	s4,s4,-1960 # 8123e000 <pool>
    802047b0:	41450a33          	sub	s4,a0,s4
    802047b4:	403a5a13          	srai	s4,s4,0x3
    802047b8:	00005717          	auipc	a4,0x5
    802047bc:	83870713          	addi	a4,a4,-1992 # 80208ff0 <SBI_SET_TIMER+0x18>
    802047c0:	6318                	ld	a4,0(a4)
    802047c2:	02ea0a33          	mul	s4,s4,a4
    802047c6:	8ba6                	mv	s7,s1
    802047c8:	004a1993          	slli	s3,s4,0x4
    802047cc:	99a6                	add	s3,s3,s1
    802047ce:	09b2                	slli	s3,s3,0xc
    802047d0:	0083a717          	auipc	a4,0x83a
    802047d4:	83070713          	addi	a4,a4,-2000 # 80a3e000 <kstack>
    802047d8:	974e                	add	a4,a4,s3
    802047da:	e7f8                	sd	a4,200(a5)
	return t->process->ustack_base + t->tid * USTACK_SIZE;
    802047dc:	00c4959b          	slliw	a1,s1,0xc
    802047e0:	6d18                	ld	a4,24(a0)
    802047e2:	95ba                	add	a1,a1,a4
	t->ustack = get_thread_ustack_base_va(t);
    802047e4:	e3ec                	sd	a1,192(a5)
	if (alloc_user_res != 0) {
    802047e6:	ea69                	bnez	a2,802048b8 <allocthread+0x17c>
	t->trapframe = (struct trapframe *)trapframe[p - pool][tid];
    802047e8:	0003a517          	auipc	a0,0x3a
    802047ec:	81850513          	addi	a0,a0,-2024 # 8023e000 <trapframe>
    802047f0:	954e                	add	a0,a0,s3
    802047f2:	00249a93          	slli	s5,s1,0x2
    802047f6:	9aa6                	add	s5,s5,s1
    802047f8:	0a96                	slli	s5,s5,0x5
    802047fa:	9aca                	add	s5,s5,s2
    802047fc:	0caab823          	sd	a0,208(s5) # fffffffffffff0d0 <e_bss+0xffffffff7ece10d0>
	memset((void *)t->trapframe, 0, TRAP_PAGE_SIZE);
    80204800:	6605                	lui	a2,0x1
    80204802:	4581                	li	a1,0
    80204804:	ffffc097          	auipc	ra,0xffffc
    80204808:	8d4080e7          	jalr	-1836(ra) # 802000d8 <memset>
	return TRAPFRAME - tid * TRAP_PAGE_SIZE;
    8020480c:	00c4959b          	slliw	a1,s1,0xc
    80204810:	020007b7          	lui	a5,0x2000
	if (mappages(p->pagetable, get_thread_trapframe_va(tid), TRAP_PAGE_SIZE,
    80204814:	4719                	li	a4,6
    80204816:	0d0ab683          	ld	a3,208(s5)
    8020481a:	6605                	lui	a2,0x1
    8020481c:	17fd                	addi	a5,a5,-1
    8020481e:	07b6                	slli	a5,a5,0xd
    80204820:	40b785b3          	sub	a1,a5,a1
    80204824:	00893503          	ld	a0,8(s2)
    80204828:	ffffe097          	auipc	ra,0xffffe
    8020482c:	f76080e7          	jalr	-138(ra) # 8020279e <mappages>
    80204830:	10054163          	bltz	a0,80204932 <allocthread+0x1f6>
	t->trapframe->sp = t->ustack + USTACK_SIZE;
    80204834:	00249993          	slli	s3,s1,0x2
    80204838:	99a6                	add	s3,s3,s1
    8020483a:	0996                	slli	s3,s3,0x5
    8020483c:	99ca                	add	s3,s3,s2
    8020483e:	0d09b703          	ld	a4,208(s3) # 10d0 <BASE_ADDRESS-0x801fef30>
    80204842:	6a85                	lui	s5,0x1
    80204844:	0c09b783          	ld	a5,192(s3)
    80204848:	97d6                	add	a5,a5,s5
    8020484a:	fb1c                	sd	a5,48(a4)
	t->trapframe->epc = entry;
    8020484c:	0d09b783          	ld	a5,208(s3)
    80204850:	0167bc23          	sd	s6,24(a5) # 2000018 <BASE_ADDRESS-0x7e1fffe8>
	memset(&t->context, 0, sizeof(t->context));
    80204854:	002b9513          	slli	a0,s7,0x2
    80204858:	955e                	add	a0,a0,s7
    8020485a:	0516                	slli	a0,a0,0x5
    8020485c:	0d850513          	addi	a0,a0,216
    80204860:	07000613          	li	a2,112
    80204864:	4581                	li	a1,0
    80204866:	954a                	add	a0,a0,s2
    80204868:	ffffc097          	auipc	ra,0xffffc
    8020486c:	870080e7          	jalr	-1936(ra) # 802000d8 <memset>
	t->context.ra = (uint64)usertrapret;
    80204870:	ffffc797          	auipc	a5,0xffffc
    80204874:	b9c78793          	addi	a5,a5,-1124 # 8020040c <usertrapret>
    80204878:	0cf9bc23          	sd	a5,216(s3)
	t->context.sp = t->kstack + KSTACK_SIZE;
    8020487c:	0c89b783          	ld	a5,200(s3)
    80204880:	97d6                	add	a5,a5,s5
    80204882:	0ef9b023          	sd	a5,224(s3)
	debugf("allocthread p: %d, o: %d, t: %d, e: %p, sp: %p, spp: %p",
    80204886:	00492a83          	lw	s5,4(s2)
    8020488a:	0b49ab83          	lw	s7,180(s3)
    8020488e:	0c09b983          	ld	s3,192(s3)
    80204892:	85ce                	mv	a1,s3
    80204894:	00893503          	ld	a0,8(s2)
    80204898:	ffffe097          	auipc	ra,0xffffe
    8020489c:	ede080e7          	jalr	-290(ra) # 80202776 <useraddr>
    802048a0:	882a                	mv	a6,a0
    802048a2:	87ce                	mv	a5,s3
    802048a4:	875a                	mv	a4,s6
    802048a6:	86de                	mv	a3,s7
    802048a8:	8652                	mv	a2,s4
    802048aa:	85d6                	mv	a1,s5
    802048ac:	4501                	li	a0,0
    802048ae:	ffffc097          	auipc	ra,0xffffc
    802048b2:	9fe080e7          	jalr	-1538(ra) # 802002ac <dummy>
	return tid;
    802048b6:	bd6d                	j	80204770 <allocthread+0x34>
		if (uvmmap(p->pagetable, t->ustack, USTACK_SIZE / PAGE_SIZE,
    802048b8:	46d9                	li	a3,22
    802048ba:	4605                	li	a2,1
    802048bc:	6508                	ld	a0,8(a0)
    802048be:	ffffe097          	auipc	ra,0xffffe
    802048c2:	120080e7          	jalr	288(ra) # 802029de <uvmmap>
    802048c6:	02054463          	bltz	a0,802048ee <allocthread+0x1b2>
			MAX(p->max_page,
    802048ca:	00249793          	slli	a5,s1,0x2
    802048ce:	97a6                	add	a5,a5,s1
    802048d0:	0796                	slli	a5,a5,0x5
    802048d2:	97ca                	add	a5,a5,s2
    802048d4:	63fc                	ld	a5,192(a5)
    802048d6:	6709                	lui	a4,0x2
    802048d8:	1779                	addi	a4,a4,-2
    802048da:	97ba                	add	a5,a5,a4
    802048dc:	01093703          	ld	a4,16(s2)
    802048e0:	83b1                	srli	a5,a5,0xc
    802048e2:	00e7f363          	bgeu	a5,a4,802048e8 <allocthread+0x1ac>
    802048e6:	87ba                	mv	a5,a4
		p->max_page =
    802048e8:	00f93823          	sd	a5,16(s2)
    802048ec:	bdf5                	j	802047e8 <allocthread+0xac>
			panic("map ustack fail");
    802048ee:	00000097          	auipc	ra,0x0
    802048f2:	ab0080e7          	jalr	-1360(ra) # 8020439e <procid>
	return curr_thread()->tid;
    802048f6:	01119797          	auipc	a5,0x1119
    802048fa:	a0a78793          	addi	a5,a5,-1526 # 8131d300 <current_thread>
    802048fe:	6398                	ld	a4,0(a5)
			panic("map ustack fail");
    80204900:	0c100813          	li	a6,193
    80204904:	00004797          	auipc	a5,0x4
    80204908:	22c78793          	addi	a5,a5,556 # 80208b30 <digits+0x2f8>
    8020490c:	4358                	lw	a4,4(a4)
    8020490e:	86aa                	mv	a3,a0
    80204910:	00003617          	auipc	a2,0x3
    80204914:	70060613          	addi	a2,a2,1792 # 80208010 <e_text+0x10>
    80204918:	45fd                	li	a1,31
    8020491a:	00004517          	auipc	a0,0x4
    8020491e:	22650513          	addi	a0,a0,550 # 80208b40 <digits+0x308>
    80204922:	ffffe097          	auipc	ra,0xffffe
    80204926:	7a4080e7          	jalr	1956(ra) # 802030c6 <printf>
    8020492a:	fffff097          	auipc	ra,0xfffff
    8020492e:	9b4080e7          	jalr	-1612(ra) # 802032de <shutdown>
		panic("map trapframe fail");
    80204932:	00000097          	auipc	ra,0x0
    80204936:	a6c080e7          	jalr	-1428(ra) # 8020439e <procid>
	return curr_thread()->tid;
    8020493a:	01119797          	auipc	a5,0x1119
    8020493e:	9c678793          	addi	a5,a5,-1594 # 8131d300 <current_thread>
    80204942:	6398                	ld	a4,0(a5)
		panic("map trapframe fail");
    80204944:	0cc00813          	li	a6,204
    80204948:	00004797          	auipc	a5,0x4
    8020494c:	1e878793          	addi	a5,a5,488 # 80208b30 <digits+0x2f8>
    80204950:	4358                	lw	a4,4(a4)
    80204952:	86aa                	mv	a3,a0
    80204954:	00003617          	auipc	a2,0x3
    80204958:	6bc60613          	addi	a2,a2,1724 # 80208010 <e_text+0x10>
    8020495c:	45fd                	li	a1,31
    8020495e:	00004517          	auipc	a0,0x4
    80204962:	21250513          	addi	a0,a0,530 # 80208b70 <digits+0x338>
    80204966:	ffffe097          	auipc	ra,0xffffe
    8020496a:	760080e7          	jalr	1888(ra) # 802030c6 <printf>
    8020496e:	fffff097          	auipc	ra,0xfffff
    80204972:	970080e7          	jalr	-1680(ra) # 802032de <shutdown>

0000000080204976 <init_stdio>:

int init_stdio(struct proc *p)
{
	for (int i = 0; i < 3; i++) {
		if (p->files[i] != NULL) {
    80204976:	791c                	ld	a5,48(a0)
    80204978:	e3b9                	bnez	a5,802049be <init_stdio+0x48>
{
    8020497a:	1101                	addi	sp,sp,-32
    8020497c:	ec06                	sd	ra,24(sp)
    8020497e:	e822                	sd	s0,16(sp)
    80204980:	e426                	sd	s1,8(sp)
    80204982:	1000                	addi	s0,sp,32
    80204984:	84aa                	mv	s1,a0
			return -1;
		}
		p->files[i] = stdio_init(i);
    80204986:	4501                	li	a0,0
    80204988:	fffff097          	auipc	ra,0xfffff
    8020498c:	f26080e7          	jalr	-218(ra) # 802038ae <stdio_init>
    80204990:	f888                	sd	a0,48(s1)
		if (p->files[i] != NULL) {
    80204992:	7c9c                	ld	a5,56(s1)
    80204994:	e79d                	bnez	a5,802049c2 <init_stdio+0x4c>
		p->files[i] = stdio_init(i);
    80204996:	4505                	li	a0,1
    80204998:	fffff097          	auipc	ra,0xfffff
    8020499c:	f16080e7          	jalr	-234(ra) # 802038ae <stdio_init>
    802049a0:	fc88                	sd	a0,56(s1)
		if (p->files[i] != NULL) {
    802049a2:	60bc                	ld	a5,64(s1)
    802049a4:	e38d                	bnez	a5,802049c6 <init_stdio+0x50>
		p->files[i] = stdio_init(i);
    802049a6:	4509                	li	a0,2
    802049a8:	fffff097          	auipc	ra,0xfffff
    802049ac:	f06080e7          	jalr	-250(ra) # 802038ae <stdio_init>
    802049b0:	e0a8                	sd	a0,64(s1)
	}
	return 0;
    802049b2:	4501                	li	a0,0
}
    802049b4:	60e2                	ld	ra,24(sp)
    802049b6:	6442                	ld	s0,16(sp)
    802049b8:	64a2                	ld	s1,8(sp)
    802049ba:	6105                	addi	sp,sp,32
    802049bc:	8082                	ret
			return -1;
    802049be:	557d                	li	a0,-1
}
    802049c0:	8082                	ret
			return -1;
    802049c2:	557d                	li	a0,-1
    802049c4:	bfc5                	j	802049b4 <init_stdio+0x3e>
    802049c6:	557d                	li	a0,-1
    802049c8:	b7f5                	j	802049b4 <init_stdio+0x3e>

00000000802049ca <scheduler>:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler()
{
    802049ca:	7139                	addi	sp,sp,-64
    802049cc:	fc06                	sd	ra,56(sp)
    802049ce:	f822                	sd	s0,48(sp)
    802049d0:	f426                	sd	s1,40(sp)
    802049d2:	f04a                	sd	s2,32(sp)
    802049d4:	ec4e                	sd	s3,24(sp)
    802049d6:	e852                	sd	s4,16(sp)
    802049d8:	e456                	sd	s5,8(sp)
    802049da:	0080                	addi	s0,sp,64
		t = fetch_task();
		if (t == NULL) {
			panic("all app are over!\n");
		}
		// throw out freed threads
		if (t->state != RUNNABLE) {
    802049dc:	490d                	li	s2,3
			warnf("not RUNNABLE", t->process->pid, t->tid);
			continue;
		}
		tracef("swtich to proc %d, thread %d", t->process->pid, t->tid);
		t->state = RUNNING;
    802049de:	4a91                	li	s5,4
		current_thread = t;
    802049e0:	01119a17          	auipc	s4,0x1119
    802049e4:	920a0a13          	addi	s4,s4,-1760 # 8131d300 <current_thread>
		swtch(&idle.context, &t->context);
    802049e8:	00038997          	auipc	s3,0x38
    802049ec:	64098993          	addi	s3,s3,1600 # 8023d028 <idle+0x28>
    802049f0:	a899                	j	80204a46 <scheduler+0x7c>
			panic("all app are over!\n");
    802049f2:	00000097          	auipc	ra,0x0
    802049f6:	9ac080e7          	jalr	-1620(ra) # 8020439e <procid>
	return curr_thread()->tid;
    802049fa:	01119797          	auipc	a5,0x1119
    802049fe:	90678793          	addi	a5,a5,-1786 # 8131d300 <current_thread>
    80204a02:	6398                	ld	a4,0(a5)
			panic("all app are over!\n");
    80204a04:	0f100813          	li	a6,241
    80204a08:	00004797          	auipc	a5,0x4
    80204a0c:	12878793          	addi	a5,a5,296 # 80208b30 <digits+0x2f8>
    80204a10:	4358                	lw	a4,4(a4)
    80204a12:	86aa                	mv	a3,a0
    80204a14:	00003617          	auipc	a2,0x3
    80204a18:	5fc60613          	addi	a2,a2,1532 # 80208010 <e_text+0x10>
    80204a1c:	45fd                	li	a1,31
    80204a1e:	00004517          	auipc	a0,0x4
    80204a22:	18250513          	addi	a0,a0,386 # 80208ba0 <digits+0x368>
    80204a26:	ffffe097          	auipc	ra,0xffffe
    80204a2a:	6a0080e7          	jalr	1696(ra) # 802030c6 <printf>
    80204a2e:	fffff097          	auipc	ra,0xfffff
    80204a32:	8b0080e7          	jalr	-1872(ra) # 802032de <shutdown>
			warnf("not RUNNABLE", t->process->pid, t->tid);
    80204a36:	651c                	ld	a5,8(a0)
    80204a38:	4150                	lw	a2,4(a0)
    80204a3a:	43cc                	lw	a1,4(a5)
    80204a3c:	4501                	li	a0,0
    80204a3e:	ffffc097          	auipc	ra,0xffffc
    80204a42:	86e080e7          	jalr	-1938(ra) # 802002ac <dummy>
		t = fetch_task();
    80204a46:	00000097          	auipc	ra,0x0
    80204a4a:	b18080e7          	jalr	-1256(ra) # 8020455e <fetch_task>
    80204a4e:	84aa                	mv	s1,a0
		if (t == NULL) {
    80204a50:	d14d                	beqz	a0,802049f2 <scheduler+0x28>
		if (t->state != RUNNABLE) {
    80204a52:	411c                	lw	a5,0(a0)
    80204a54:	ff2791e3          	bne	a5,s2,80204a36 <scheduler+0x6c>
		tracef("swtich to proc %d, thread %d", t->process->pid, t->tid);
    80204a58:	651c                	ld	a5,8(a0)
    80204a5a:	4150                	lw	a2,4(a0)
    80204a5c:	43cc                	lw	a1,4(a5)
    80204a5e:	4501                	li	a0,0
    80204a60:	ffffc097          	auipc	ra,0xffffc
    80204a64:	84c080e7          	jalr	-1972(ra) # 802002ac <dummy>
		t->state = RUNNING;
    80204a68:	0154a023          	sw	s5,0(s1)
		current_thread = t;
    80204a6c:	009a3023          	sd	s1,0(s4)
		swtch(&idle.context, &t->context);
    80204a70:	02848593          	addi	a1,s1,40
    80204a74:	854e                	mv	a0,s3
    80204a76:	00001097          	auipc	ra,0x1
    80204a7a:	6b8080e7          	jalr	1720(ra) # 8020612e <swtch>
    80204a7e:	b7e1                	j	80204a46 <scheduler+0x7c>

0000000080204a80 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched()
{
    80204a80:	1101                	addi	sp,sp,-32
    80204a82:	ec06                	sd	ra,24(sp)
    80204a84:	e822                	sd	s0,16(sp)
    80204a86:	e426                	sd	s1,8(sp)
    80204a88:	1000                	addi	s0,sp,32
	return current_thread;
    80204a8a:	01119797          	auipc	a5,0x1119
    80204a8e:	87678793          	addi	a5,a5,-1930 # 8131d300 <current_thread>
    80204a92:	6384                	ld	s1,0(a5)
	struct thread *t = curr_thread();
	if (t->state == RUNNING)
    80204a94:	4098                	lw	a4,0(s1)
    80204a96:	4791                	li	a5,4
    80204a98:	02f70163          	beq	a4,a5,80204aba <sched+0x3a>
		panic("sched running");
	swtch(&t->context, &idle.context);
    80204a9c:	00038597          	auipc	a1,0x38
    80204aa0:	58c58593          	addi	a1,a1,1420 # 8023d028 <idle+0x28>
    80204aa4:	02848513          	addi	a0,s1,40
    80204aa8:	00001097          	auipc	ra,0x1
    80204aac:	686080e7          	jalr	1670(ra) # 8020612e <swtch>
}
    80204ab0:	60e2                	ld	ra,24(sp)
    80204ab2:	6442                	ld	s0,16(sp)
    80204ab4:	64a2                	ld	s1,8(sp)
    80204ab6:	6105                	addi	sp,sp,32
    80204ab8:	8082                	ret
		panic("sched running");
    80204aba:	00000097          	auipc	ra,0x0
    80204abe:	8e4080e7          	jalr	-1820(ra) # 8020439e <procid>
    80204ac2:	10a00813          	li	a6,266
    80204ac6:	00004797          	auipc	a5,0x4
    80204aca:	06a78793          	addi	a5,a5,106 # 80208b30 <digits+0x2f8>
    80204ace:	40d8                	lw	a4,4(s1)
    80204ad0:	86aa                	mv	a3,a0
    80204ad2:	00003617          	auipc	a2,0x3
    80204ad6:	53e60613          	addi	a2,a2,1342 # 80208010 <e_text+0x10>
    80204ada:	45fd                	li	a1,31
    80204adc:	00004517          	auipc	a0,0x4
    80204ae0:	0f450513          	addi	a0,a0,244 # 80208bd0 <digits+0x398>
    80204ae4:	ffffe097          	auipc	ra,0xffffe
    80204ae8:	5e2080e7          	jalr	1506(ra) # 802030c6 <printf>
    80204aec:	ffffe097          	auipc	ra,0xffffe
    80204af0:	7f2080e7          	jalr	2034(ra) # 802032de <shutdown>

0000000080204af4 <yield>:

// Give up the CPU for one scheduling round.
void yield()
{
    80204af4:	1141                	addi	sp,sp,-16
    80204af6:	e406                	sd	ra,8(sp)
    80204af8:	e022                	sd	s0,0(sp)
    80204afa:	0800                	addi	s0,sp,16
	current_thread->state = RUNNABLE;
    80204afc:	01119797          	auipc	a5,0x1119
    80204b00:	80478793          	addi	a5,a5,-2044 # 8131d300 <current_thread>
    80204b04:	6398                	ld	a4,0(a5)
    80204b06:	468d                	li	a3,3
    80204b08:	c314                	sw	a3,0(a4)
	add_task(current_thread);
    80204b0a:	6388                	ld	a0,0(a5)
    80204b0c:	00000097          	auipc	ra,0x0
    80204b10:	aaa080e7          	jalr	-1366(ra) # 802045b6 <add_task>
	sched();
    80204b14:	00000097          	auipc	ra,0x0
    80204b18:	f6c080e7          	jalr	-148(ra) # 80204a80 <sched>
}
    80204b1c:	60a2                	ld	ra,8(sp)
    80204b1e:	6402                	ld	s0,0(sp)
    80204b20:	0141                	addi	sp,sp,16
    80204b22:	8082                	ret

0000000080204b24 <freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void freepagetable(pagetable_t pagetable, uint64 max_page)
{
    80204b24:	1101                	addi	sp,sp,-32
    80204b26:	ec06                	sd	ra,24(sp)
    80204b28:	e822                	sd	s0,16(sp)
    80204b2a:	e426                	sd	s1,8(sp)
    80204b2c:	e04a                	sd	s2,0(sp)
    80204b2e:	1000                	addi	s0,sp,32
    80204b30:	84aa                	mv	s1,a0
    80204b32:	892e                	mv	s2,a1
	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80204b34:	4681                	li	a3,0
    80204b36:	4605                	li	a2,1
    80204b38:	040005b7          	lui	a1,0x4000
    80204b3c:	15fd                	addi	a1,a1,-1
    80204b3e:	05b2                	slli	a1,a1,0xc
    80204b40:	ffffe097          	auipc	ra,0xffffe
    80204b44:	efc080e7          	jalr	-260(ra) # 80202a3c <uvmunmap>
	uvmfree(pagetable, max_page);
    80204b48:	85ca                	mv	a1,s2
    80204b4a:	8526                	mv	a0,s1
    80204b4c:	ffffe097          	auipc	ra,0xffffe
    80204b50:	164080e7          	jalr	356(ra) # 80202cb0 <uvmfree>
}
    80204b54:	60e2                	ld	ra,24(sp)
    80204b56:	6442                	ld	s0,16(sp)
    80204b58:	64a2                	ld	s1,8(sp)
    80204b5a:	6902                	ld	s2,0(sp)
    80204b5c:	6105                	addi	sp,sp,32
    80204b5e:	8082                	ret

0000000080204b60 <freethread>:

void freethread(struct thread *t)
{
    80204b60:	1101                	addi	sp,sp,-32
    80204b62:	ec06                	sd	ra,24(sp)
    80204b64:	e822                	sd	s0,16(sp)
    80204b66:	e426                	sd	s1,8(sp)
    80204b68:	e04a                	sd	s2,0(sp)
    80204b6a:	1000                	addi	s0,sp,32
    80204b6c:	84aa                	mv	s1,a0
	pagetable_t pt = t->process->pagetable;
    80204b6e:	651c                	ld	a5,8(a0)
    80204b70:	0087b903          	ld	s2,8(a5)
	// fill with junk
	memset((void *)t->trapframe, 6, TRAP_PAGE_SIZE);
    80204b74:	6605                	lui	a2,0x1
    80204b76:	4599                	li	a1,6
    80204b78:	7108                	ld	a0,32(a0)
    80204b7a:	ffffb097          	auipc	ra,0xffffb
    80204b7e:	55e080e7          	jalr	1374(ra) # 802000d8 <memset>
	memset(&t->context, 6, sizeof(t->context));
    80204b82:	07000613          	li	a2,112
    80204b86:	4599                	li	a1,6
    80204b88:	02848513          	addi	a0,s1,40
    80204b8c:	ffffb097          	auipc	ra,0xffffb
    80204b90:	54c080e7          	jalr	1356(ra) # 802000d8 <memset>
	return TRAPFRAME - tid * TRAP_PAGE_SIZE;
    80204b94:	40cc                	lw	a1,4(s1)
    80204b96:	00c5959b          	slliw	a1,a1,0xc
    80204b9a:	020007b7          	lui	a5,0x2000
	uvmunmap(pt, get_thread_trapframe_va(t->tid), 1, 0);
    80204b9e:	4681                	li	a3,0
    80204ba0:	4605                	li	a2,1
    80204ba2:	17fd                	addi	a5,a5,-1
    80204ba4:	07b6                	slli	a5,a5,0xd
    80204ba6:	40b785b3          	sub	a1,a5,a1
    80204baa:	854a                	mv	a0,s2
    80204bac:	ffffe097          	auipc	ra,0xffffe
    80204bb0:	e90080e7          	jalr	-368(ra) # 80202a3c <uvmunmap>
	return t->process->ustack_base + t->tid * USTACK_SIZE;
    80204bb4:	6498                	ld	a4,8(s1)
    80204bb6:	40dc                	lw	a5,4(s1)
    80204bb8:	00c7979b          	slliw	a5,a5,0xc
    80204bbc:	6f0c                	ld	a1,24(a4)
	uvmunmap(pt, get_thread_ustack_base_va(t), USTACK_SIZE / PAGE_SIZE, 1);
    80204bbe:	4685                	li	a3,1
    80204bc0:	4605                	li	a2,1
    80204bc2:	95be                	add	a1,a1,a5
    80204bc4:	854a                	mv	a0,s2
    80204bc6:	ffffe097          	auipc	ra,0xffffe
    80204bca:	e76080e7          	jalr	-394(ra) # 80202a3c <uvmunmap>
}
    80204bce:	60e2                	ld	ra,24(sp)
    80204bd0:	6442                	ld	s0,16(sp)
    80204bd2:	64a2                	ld	s1,8(sp)
    80204bd4:	6902                	ld	s2,0(sp)
    80204bd6:	6105                	addi	sp,sp,32
    80204bd8:	8082                	ret

0000000080204bda <freeproc>:

void freeproc(struct proc *p)
{
    80204bda:	7139                	addi	sp,sp,-64
    80204bdc:	fc06                	sd	ra,56(sp)
    80204bde:	f822                	sd	s0,48(sp)
    80204be0:	f426                	sd	s1,40(sp)
    80204be2:	f04a                	sd	s2,32(sp)
    80204be4:	ec4e                	sd	s3,24(sp)
    80204be6:	e852                	sd	s4,16(sp)
    80204be8:	e456                	sd	s5,8(sp)
    80204bea:	0080                	addi	s0,sp,64
    80204bec:	8aaa                	mv	s5,a0
	for (int tid = 0; tid < NTHREAD; ++tid) {
    80204bee:	0b050493          	addi	s1,a0,176
    80204bf2:	6985                	lui	s3,0x1
    80204bf4:	ab098993          	addi	s3,s3,-1360 # ab0 <BASE_ADDRESS-0x801ff550>
    80204bf8:	99aa                	add	s3,s3,a0
		struct thread *t = &p->threads[tid];
		if (t->state != T_UNUSED && t->state != EXITED) {
    80204bfa:	4a15                	li	s4,5
    80204bfc:	a821                	j	80204c14 <freeproc+0x3a>
			freethread(t);
    80204bfe:	8526                	mv	a0,s1
    80204c00:	00000097          	auipc	ra,0x0
    80204c04:	f60080e7          	jalr	-160(ra) # 80204b60 <freethread>
		}
		t->state = T_UNUSED;
    80204c08:	00092023          	sw	zero,0(s2)
    80204c0c:	0a048493          	addi	s1,s1,160
	for (int tid = 0; tid < NTHREAD; ++tid) {
    80204c10:	01348863          	beq	s1,s3,80204c20 <freeproc+0x46>
		if (t->state != T_UNUSED && t->state != EXITED) {
    80204c14:	8926                	mv	s2,s1
    80204c16:	409c                	lw	a5,0(s1)
    80204c18:	dbe5                	beqz	a5,80204c08 <freeproc+0x2e>
    80204c1a:	ff4787e3          	beq	a5,s4,80204c08 <freeproc+0x2e>
    80204c1e:	b7c5                	j	80204bfe <freeproc+0x24>
	}
	if (p->pagetable)
    80204c20:	008ab503          	ld	a0,8(s5) # 1008 <BASE_ADDRESS-0x801feff8>
    80204c24:	c519                	beqz	a0,80204c32 <freeproc+0x58>
		freepagetable(p->pagetable, p->max_page);
    80204c26:	010ab583          	ld	a1,16(s5)
    80204c2a:	00000097          	auipc	ra,0x0
    80204c2e:	efa080e7          	jalr	-262(ra) # 80204b24 <freepagetable>
	p->pagetable = 0;
    80204c32:	000ab423          	sd	zero,8(s5)
	p->max_page = 0;
    80204c36:	000ab823          	sd	zero,16(s5)
	p->ustack_base = 0;
    80204c3a:	000abc23          	sd	zero,24(s5)
	for (int i = 0; i > FD_BUFFER_SIZE; i++) {
		if (p->files[i] != NULL) {
			fileclose(p->files[i]);
		}
	}
	p->state = P_UNUSED;
    80204c3e:	000aa023          	sw	zero,0(s5)
}
    80204c42:	70e2                	ld	ra,56(sp)
    80204c44:	7442                	ld	s0,48(sp)
    80204c46:	74a2                	ld	s1,40(sp)
    80204c48:	7902                	ld	s2,32(sp)
    80204c4a:	69e2                	ld	s3,24(sp)
    80204c4c:	6a42                	ld	s4,16(sp)
    80204c4e:	6aa2                	ld	s5,8(sp)
    80204c50:	6121                	addi	sp,sp,64
    80204c52:	8082                	ret

0000000080204c54 <fork>:

int fork()
{
    80204c54:	1101                	addi	sp,sp,-32
    80204c56:	ec06                	sd	ra,24(sp)
    80204c58:	e822                	sd	s0,16(sp)
    80204c5a:	e426                	sd	s1,8(sp)
    80204c5c:	e04a                	sd	s2,0(sp)
    80204c5e:	1000                	addi	s0,sp,32
	return current_thread->process;
    80204c60:	01118797          	auipc	a5,0x1118
    80204c64:	6a078793          	addi	a5,a5,1696 # 8131d300 <current_thread>
    80204c68:	639c                	ld	a5,0(a5)
    80204c6a:	0087b903          	ld	s2,8(a5)
	struct proc *np;
	struct proc *p = curr_proc();
	int i;
	// Allocate process.
	if ((np = allocproc()) == 0) {
    80204c6e:	00000097          	auipc	ra,0x0
    80204c72:	99a080e7          	jalr	-1638(ra) # 80204608 <allocproc>
    80204c76:	c915                	beqz	a0,80204caa <fork+0x56>
    80204c78:	84aa                	mv	s1,a0
		panic("allocproc\n");
	}
	// Copy user memory from parent to child.
	if (uvmcopy(p->pagetable, np->pagetable, p->max_page) < 0) {
    80204c7a:	01093603          	ld	a2,16(s2)
    80204c7e:	650c                	ld	a1,8(a0)
    80204c80:	00893503          	ld	a0,8(s2)
    80204c84:	ffffe097          	auipc	ra,0xffffe
    80204c88:	05e080e7          	jalr	94(ra) # 80202ce2 <uvmcopy>
    80204c8c:	06054163          	bltz	a0,80204cee <fork+0x9a>
		panic("uvmcopy\n");
	}
	np->max_page = p->max_page;
    80204c90:	01093783          	ld	a5,16(s2)
    80204c94:	e89c                	sd	a5,16(s1)
	np->ustack_base = p->ustack_base;
    80204c96:	01893783          	ld	a5,24(s2)
    80204c9a:	ec9c                	sd	a5,24(s1)
	// Copy file table to new proc
	for (i = 0; i < FD_BUFFER_SIZE; i++) {
    80204c9c:	03090793          	addi	a5,s2,48
    80204ca0:	03048613          	addi	a2,s1,48
    80204ca4:	0b090593          	addi	a1,s2,176
    80204ca8:	a849                	j	80204d3a <fork+0xe6>
		panic("allocproc\n");
    80204caa:	fffff097          	auipc	ra,0xfffff
    80204cae:	6f4080e7          	jalr	1780(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204cb2:	01118797          	auipc	a5,0x1118
    80204cb6:	64e78793          	addi	a5,a5,1614 # 8131d300 <current_thread>
    80204cba:	6398                	ld	a4,0(a5)
		panic("allocproc\n");
    80204cbc:	14500813          	li	a6,325
    80204cc0:	00004797          	auipc	a5,0x4
    80204cc4:	e7078793          	addi	a5,a5,-400 # 80208b30 <digits+0x2f8>
    80204cc8:	4358                	lw	a4,4(a4)
    80204cca:	86aa                	mv	a3,a0
    80204ccc:	00003617          	auipc	a2,0x3
    80204cd0:	34460613          	addi	a2,a2,836 # 80208010 <e_text+0x10>
    80204cd4:	45fd                	li	a1,31
    80204cd6:	00004517          	auipc	a0,0x4
    80204cda:	f2a50513          	addi	a0,a0,-214 # 80208c00 <digits+0x3c8>
    80204cde:	ffffe097          	auipc	ra,0xffffe
    80204ce2:	3e8080e7          	jalr	1000(ra) # 802030c6 <printf>
    80204ce6:	ffffe097          	auipc	ra,0xffffe
    80204cea:	5f8080e7          	jalr	1528(ra) # 802032de <shutdown>
		panic("uvmcopy\n");
    80204cee:	fffff097          	auipc	ra,0xfffff
    80204cf2:	6b0080e7          	jalr	1712(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204cf6:	01118797          	auipc	a5,0x1118
    80204cfa:	60a78793          	addi	a5,a5,1546 # 8131d300 <current_thread>
    80204cfe:	6398                	ld	a4,0(a5)
		panic("uvmcopy\n");
    80204d00:	14900813          	li	a6,329
    80204d04:	00004797          	auipc	a5,0x4
    80204d08:	e2c78793          	addi	a5,a5,-468 # 80208b30 <digits+0x2f8>
    80204d0c:	4358                	lw	a4,4(a4)
    80204d0e:	86aa                	mv	a3,a0
    80204d10:	00003617          	auipc	a2,0x3
    80204d14:	30060613          	addi	a2,a2,768 # 80208010 <e_text+0x10>
    80204d18:	45fd                	li	a1,31
    80204d1a:	00004517          	auipc	a0,0x4
    80204d1e:	f0e50513          	addi	a0,a0,-242 # 80208c28 <digits+0x3f0>
    80204d22:	ffffe097          	auipc	ra,0xffffe
    80204d26:	3a4080e7          	jalr	932(ra) # 802030c6 <printf>
    80204d2a:	ffffe097          	auipc	ra,0xffffe
    80204d2e:	5b4080e7          	jalr	1460(ra) # 802032de <shutdown>
    80204d32:	07a1                	addi	a5,a5,8
    80204d34:	0621                	addi	a2,a2,8
	for (i = 0; i < FD_BUFFER_SIZE; i++) {
    80204d36:	00b78a63          	beq	a5,a1,80204d4a <fork+0xf6>
		if (p->files[i] != NULL) {
    80204d3a:	6398                	ld	a4,0(a5)
    80204d3c:	db7d                	beqz	a4,80204d32 <fork+0xde>
			// TODO: f->type == STDIO ?
			p->files[i]->ref++;
    80204d3e:	4354                	lw	a3,4(a4)
    80204d40:	2685                	addiw	a3,a3,1
    80204d42:	c354                	sw	a3,4(a4)
			np->files[i] = p->files[i];
    80204d44:	6398                	ld	a4,0(a5)
    80204d46:	e218                	sd	a4,0(a2)
    80204d48:	b7ed                	j	80204d32 <fork+0xde>
		}
	}

	np->parent = p;
    80204d4a:	0324b023          	sd	s2,32(s1)
	// currently only copy main thread
	struct thread *nt = &np->threads[allocthread(np, 0, 0)],
    80204d4e:	4601                	li	a2,0
    80204d50:	4581                	li	a1,0
    80204d52:	8526                	mv	a0,s1
    80204d54:	00000097          	auipc	ra,0x0
    80204d58:	9e8080e7          	jalr	-1560(ra) # 8020473c <allocthread>
		      *t = &p->threads[0];
	// copy saved user registers.
	*(nt->trapframe) = *(t->trapframe);
    80204d5c:	0d093683          	ld	a3,208(s2)
    80204d60:	00251713          	slli	a4,a0,0x2
    80204d64:	972a                	add	a4,a4,a0
    80204d66:	0716                	slli	a4,a4,0x5
    80204d68:	9726                	add	a4,a4,s1
    80204d6a:	87b6                	mv	a5,a3
    80204d6c:	6b78                	ld	a4,208(a4)
    80204d6e:	12068693          	addi	a3,a3,288
    80204d72:	0007b883          	ld	a7,0(a5)
    80204d76:	0087b803          	ld	a6,8(a5)
    80204d7a:	6b8c                	ld	a1,16(a5)
    80204d7c:	6f90                	ld	a2,24(a5)
    80204d7e:	01173023          	sd	a7,0(a4) # 2000 <BASE_ADDRESS-0x801fe000>
    80204d82:	01073423          	sd	a6,8(a4)
    80204d86:	eb0c                	sd	a1,16(a4)
    80204d88:	ef10                	sd	a2,24(a4)
    80204d8a:	02078793          	addi	a5,a5,32
    80204d8e:	02070713          	addi	a4,a4,32
    80204d92:	fed790e3          	bne	a5,a3,80204d72 <fork+0x11e>
	// Cause fork to return 0 in the child.
	nt->trapframe->a0 = 0;
    80204d96:	00251793          	slli	a5,a0,0x2
    80204d9a:	00a78733          	add	a4,a5,a0
    80204d9e:	0716                	slli	a4,a4,0x5
    80204da0:	9726                	add	a4,a4,s1
    80204da2:	6b74                	ld	a3,208(a4)
    80204da4:	0606b823          	sd	zero,112(a3)
	nt->state = RUNNABLE;
    80204da8:	468d                	li	a3,3
    80204daa:	0ad72823          	sw	a3,176(a4)
	struct thread *nt = &np->threads[allocthread(np, 0, 0)],
    80204dae:	953e                	add	a0,a0,a5
    80204db0:	0516                	slli	a0,a0,0x5
    80204db2:	0b050513          	addi	a0,a0,176
	add_task(nt);
    80204db6:	9526                	add	a0,a0,s1
    80204db8:	fffff097          	auipc	ra,0xfffff
    80204dbc:	7fe080e7          	jalr	2046(ra) # 802045b6 <add_task>
	return np->pid;
}
    80204dc0:	40c8                	lw	a0,4(s1)
    80204dc2:	60e2                	ld	ra,24(sp)
    80204dc4:	6442                	ld	s0,16(sp)
    80204dc6:	64a2                	ld	s1,8(sp)
    80204dc8:	6902                	ld	s2,0(sp)
    80204dca:	6105                	addi	sp,sp,32
    80204dcc:	8082                	ret

0000000080204dce <push_argv>:

int push_argv(struct proc *p, char **argv)
{
    80204dce:	7149                	addi	sp,sp,-368
    80204dd0:	f686                	sd	ra,360(sp)
    80204dd2:	f2a2                	sd	s0,352(sp)
    80204dd4:	eea6                	sd	s1,344(sp)
    80204dd6:	eaca                	sd	s2,336(sp)
    80204dd8:	e6ce                	sd	s3,328(sp)
    80204dda:	e2d2                	sd	s4,320(sp)
    80204ddc:	fe56                	sd	s5,312(sp)
    80204dde:	fa5a                	sd	s6,304(sp)
    80204de0:	f65e                	sd	s7,296(sp)
    80204de2:	f262                	sd	s8,288(sp)
    80204de4:	ee66                	sd	s9,280(sp)
    80204de6:	1a80                	addi	s0,sp,368
    80204de8:	8b2a                	mv	s6,a0
    80204dea:	892e                	mv	s2,a1
	uint64 argc, ustack[MAX_ARG_NUM + 1];
	// only push to main thread
	struct thread *t = &p->threads[0];
	uint64 sp = t->ustack + USTACK_SIZE, spb = t->ustack;
    80204dec:	0c053a83          	ld	s5,192(a0)
    80204df0:	6485                	lui	s1,0x1
    80204df2:	94d6                	add	s1,s1,s5
	debugf("[push] sp: %p, spb: %p", sp, spb);
    80204df4:	8656                	mv	a2,s5
    80204df6:	85a6                	mv	a1,s1
    80204df8:	4501                	li	a0,0
    80204dfa:	ffffb097          	auipc	ra,0xffffb
    80204dfe:	4b2080e7          	jalr	1202(ra) # 802002ac <dummy>
	// Push argument strings, prepare rest of stack in ustack.
	for (argc = 0; argv[argc]; argc++) {
    80204e02:	00093503          	ld	a0,0(s2)
    80204e06:	e9840993          	addi	s3,s0,-360
    80204e0a:	f9840c13          	addi	s8,s0,-104
    80204e0e:	4a01                	li	s4,0
    80204e10:	10050f63          	beqz	a0,80204f2e <push_argv+0x160>
		if (argc >= MAX_ARG_NUM)
			panic("too many args!");
		sp -= strlen(argv[argc]) + 1;
    80204e14:	ffffb097          	auipc	ra,0xffffb
    80204e18:	46e080e7          	jalr	1134(ra) # 80200282 <strlen>
    80204e1c:	2505                	addiw	a0,a0,1
    80204e1e:	8c89                	sub	s1,s1,a0
		sp -= sp % 16; // riscv sp must be 16-byte aligned
    80204e20:	98c1                	andi	s1,s1,-16
		if (sp < spb) {
    80204e22:	0954e263          	bltu	s1,s5,80204ea6 <push_argv+0xd8>
			panic("uset stack overflow!");
		}
		if (copyout(p->pagetable, sp, argv[argc],
    80204e26:	008b3c83          	ld	s9,8(s6)
    80204e2a:	00093b83          	ld	s7,0(s2)
			    strlen(argv[argc]) + 1) < 0) {
    80204e2e:	855e                	mv	a0,s7
    80204e30:	ffffb097          	auipc	ra,0xffffb
    80204e34:	452080e7          	jalr	1106(ra) # 80200282 <strlen>
		if (copyout(p->pagetable, sp, argv[argc],
    80204e38:	0015069b          	addiw	a3,a0,1
    80204e3c:	865e                	mv	a2,s7
    80204e3e:	85a6                	mv	a1,s1
    80204e40:	8566                	mv	a0,s9
    80204e42:	ffffe097          	auipc	ra,0xffffe
    80204e46:	f5a080e7          	jalr	-166(ra) # 80202d9c <copyout>
    80204e4a:	0a054063          	bltz	a0,80204eea <push_argv+0x11c>
			panic("copy argv failed!");
		}
		ustack[argc] = sp;
    80204e4e:	0099b023          	sd	s1,0(s3)
	for (argc = 0; argv[argc]; argc++) {
    80204e52:	0a05                	addi	s4,s4,1
    80204e54:	0921                	addi	s2,s2,8
    80204e56:	00093503          	ld	a0,0(s2)
    80204e5a:	c971                	beqz	a0,80204f2e <push_argv+0x160>
		if (argc >= MAX_ARG_NUM)
    80204e5c:	09a1                	addi	s3,s3,8
    80204e5e:	fb899be3          	bne	s3,s8,80204e14 <push_argv+0x46>
			panic("too many args!");
    80204e62:	fffff097          	auipc	ra,0xfffff
    80204e66:	53c080e7          	jalr	1340(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204e6a:	01118797          	auipc	a5,0x1118
    80204e6e:	49678793          	addi	a5,a5,1174 # 8131d300 <current_thread>
    80204e72:	6398                	ld	a4,0(a5)
			panic("too many args!");
    80204e74:	16d00813          	li	a6,365
    80204e78:	00004797          	auipc	a5,0x4
    80204e7c:	cb878793          	addi	a5,a5,-840 # 80208b30 <digits+0x2f8>
    80204e80:	4358                	lw	a4,4(a4)
    80204e82:	86aa                	mv	a3,a0
    80204e84:	00003617          	auipc	a2,0x3
    80204e88:	18c60613          	addi	a2,a2,396 # 80208010 <e_text+0x10>
    80204e8c:	45fd                	li	a1,31
    80204e8e:	00004517          	auipc	a0,0x4
    80204e92:	dc250513          	addi	a0,a0,-574 # 80208c50 <digits+0x418>
    80204e96:	ffffe097          	auipc	ra,0xffffe
    80204e9a:	230080e7          	jalr	560(ra) # 802030c6 <printf>
    80204e9e:	ffffe097          	auipc	ra,0xffffe
    80204ea2:	440080e7          	jalr	1088(ra) # 802032de <shutdown>
			panic("uset stack overflow!");
    80204ea6:	fffff097          	auipc	ra,0xfffff
    80204eaa:	4f8080e7          	jalr	1272(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204eae:	01118797          	auipc	a5,0x1118
    80204eb2:	45278793          	addi	a5,a5,1106 # 8131d300 <current_thread>
    80204eb6:	6398                	ld	a4,0(a5)
			panic("uset stack overflow!");
    80204eb8:	17100813          	li	a6,369
    80204ebc:	00004797          	auipc	a5,0x4
    80204ec0:	c7478793          	addi	a5,a5,-908 # 80208b30 <digits+0x2f8>
    80204ec4:	4358                	lw	a4,4(a4)
    80204ec6:	86aa                	mv	a3,a0
    80204ec8:	00003617          	auipc	a2,0x3
    80204ecc:	14860613          	addi	a2,a2,328 # 80208010 <e_text+0x10>
    80204ed0:	45fd                	li	a1,31
    80204ed2:	00004517          	auipc	a0,0x4
    80204ed6:	dae50513          	addi	a0,a0,-594 # 80208c80 <digits+0x448>
    80204eda:	ffffe097          	auipc	ra,0xffffe
    80204ede:	1ec080e7          	jalr	492(ra) # 802030c6 <printf>
    80204ee2:	ffffe097          	auipc	ra,0xffffe
    80204ee6:	3fc080e7          	jalr	1020(ra) # 802032de <shutdown>
			panic("copy argv failed!");
    80204eea:	fffff097          	auipc	ra,0xfffff
    80204eee:	4b4080e7          	jalr	1204(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204ef2:	01118797          	auipc	a5,0x1118
    80204ef6:	40e78793          	addi	a5,a5,1038 # 8131d300 <current_thread>
    80204efa:	6398                	ld	a4,0(a5)
			panic("copy argv failed!");
    80204efc:	17500813          	li	a6,373
    80204f00:	00004797          	auipc	a5,0x4
    80204f04:	c3078793          	addi	a5,a5,-976 # 80208b30 <digits+0x2f8>
    80204f08:	4358                	lw	a4,4(a4)
    80204f0a:	86aa                	mv	a3,a0
    80204f0c:	00003617          	auipc	a2,0x3
    80204f10:	10460613          	addi	a2,a2,260 # 80208010 <e_text+0x10>
    80204f14:	45fd                	li	a1,31
    80204f16:	00004517          	auipc	a0,0x4
    80204f1a:	da250513          	addi	a0,a0,-606 # 80208cb8 <digits+0x480>
    80204f1e:	ffffe097          	auipc	ra,0xffffe
    80204f22:	1a8080e7          	jalr	424(ra) # 802030c6 <printf>
    80204f26:	ffffe097          	auipc	ra,0xffffe
    80204f2a:	3b8080e7          	jalr	952(ra) # 802032de <shutdown>
	}
	ustack[argc] = 0;
    80204f2e:	003a1793          	slli	a5,s4,0x3
    80204f32:	fa040713          	addi	a4,s0,-96
    80204f36:	97ba                	add	a5,a5,a4
    80204f38:	ee07bc23          	sd	zero,-264(a5)
	// push the array of argv[] pointers.
	sp -= (argc + 1) * sizeof(uint64);
    80204f3c:	001a0693          	addi	a3,s4,1
    80204f40:	068e                	slli	a3,a3,0x3
    80204f42:	8c95                	sub	s1,s1,a3
	sp -= sp % 16;
    80204f44:	98c1                	andi	s1,s1,-16
	if (sp < spb) {
    80204f46:	0554e263          	bltu	s1,s5,80204f8a <push_argv+0x1bc>
		panic("uset stack overflow!");
	}
	if (copyout(p->pagetable, sp, (char *)ustack,
    80204f4a:	e9840613          	addi	a2,s0,-360
    80204f4e:	85a6                	mv	a1,s1
    80204f50:	008b3503          	ld	a0,8(s6)
    80204f54:	ffffe097          	auipc	ra,0xffffe
    80204f58:	e48080e7          	jalr	-440(ra) # 80202d9c <copyout>
    80204f5c:	06054963          	bltz	a0,80204fce <push_argv+0x200>
		    (argc + 1) * sizeof(uint64)) < 0) {
		panic("copy argc failed!");
	}
	t->trapframe->a1 = sp;
    80204f60:	0d0b3783          	ld	a5,208(s6)
    80204f64:	ffa4                	sd	s1,120(a5)
	t->trapframe->sp = sp;
    80204f66:	0d0b3783          	ld	a5,208(s6)
    80204f6a:	fb84                	sd	s1,48(a5)
	// clear files ?
	return argc; // this ends up in a0, the first argument to main(argc, argv)
}
    80204f6c:	000a051b          	sext.w	a0,s4
    80204f70:	70b6                	ld	ra,360(sp)
    80204f72:	7416                	ld	s0,352(sp)
    80204f74:	64f6                	ld	s1,344(sp)
    80204f76:	6956                	ld	s2,336(sp)
    80204f78:	69b6                	ld	s3,328(sp)
    80204f7a:	6a16                	ld	s4,320(sp)
    80204f7c:	7af2                	ld	s5,312(sp)
    80204f7e:	7b52                	ld	s6,304(sp)
    80204f80:	7bb2                	ld	s7,296(sp)
    80204f82:	7c12                	ld	s8,288(sp)
    80204f84:	6cf2                	ld	s9,280(sp)
    80204f86:	6175                	addi	sp,sp,368
    80204f88:	8082                	ret
		panic("uset stack overflow!");
    80204f8a:	fffff097          	auipc	ra,0xfffff
    80204f8e:	414080e7          	jalr	1044(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204f92:	01118797          	auipc	a5,0x1118
    80204f96:	36e78793          	addi	a5,a5,878 # 8131d300 <current_thread>
    80204f9a:	6398                	ld	a4,0(a5)
		panic("uset stack overflow!");
    80204f9c:	17e00813          	li	a6,382
    80204fa0:	00004797          	auipc	a5,0x4
    80204fa4:	b9078793          	addi	a5,a5,-1136 # 80208b30 <digits+0x2f8>
    80204fa8:	4358                	lw	a4,4(a4)
    80204faa:	86aa                	mv	a3,a0
    80204fac:	00003617          	auipc	a2,0x3
    80204fb0:	06460613          	addi	a2,a2,100 # 80208010 <e_text+0x10>
    80204fb4:	45fd                	li	a1,31
    80204fb6:	00004517          	auipc	a0,0x4
    80204fba:	cca50513          	addi	a0,a0,-822 # 80208c80 <digits+0x448>
    80204fbe:	ffffe097          	auipc	ra,0xffffe
    80204fc2:	108080e7          	jalr	264(ra) # 802030c6 <printf>
    80204fc6:	ffffe097          	auipc	ra,0xffffe
    80204fca:	318080e7          	jalr	792(ra) # 802032de <shutdown>
		panic("copy argc failed!");
    80204fce:	fffff097          	auipc	ra,0xfffff
    80204fd2:	3d0080e7          	jalr	976(ra) # 8020439e <procid>
	return curr_thread()->tid;
    80204fd6:	01118797          	auipc	a5,0x1118
    80204fda:	32a78793          	addi	a5,a5,810 # 8131d300 <current_thread>
    80204fde:	6398                	ld	a4,0(a5)
		panic("copy argc failed!");
    80204fe0:	18200813          	li	a6,386
    80204fe4:	00004797          	auipc	a5,0x4
    80204fe8:	b4c78793          	addi	a5,a5,-1204 # 80208b30 <digits+0x2f8>
    80204fec:	4358                	lw	a4,4(a4)
    80204fee:	86aa                	mv	a3,a0
    80204ff0:	00003617          	auipc	a2,0x3
    80204ff4:	02060613          	addi	a2,a2,32 # 80208010 <e_text+0x10>
    80204ff8:	45fd                	li	a1,31
    80204ffa:	00004517          	auipc	a0,0x4
    80204ffe:	cee50513          	addi	a0,a0,-786 # 80208ce8 <digits+0x4b0>
    80205002:	ffffe097          	auipc	ra,0xffffe
    80205006:	0c4080e7          	jalr	196(ra) # 802030c6 <printf>
    8020500a:	ffffe097          	auipc	ra,0xffffe
    8020500e:	2d4080e7          	jalr	724(ra) # 802032de <shutdown>

0000000080205012 <exec>:

int exec(char *path, char **argv)
{
    80205012:	7179                	addi	sp,sp,-48
    80205014:	f406                	sd	ra,40(sp)
    80205016:	f022                	sd	s0,32(sp)
    80205018:	ec26                	sd	s1,24(sp)
    8020501a:	e84a                	sd	s2,16(sp)
    8020501c:	e44e                	sd	s3,8(sp)
    8020501e:	e052                	sd	s4,0(sp)
    80205020:	1800                	addi	s0,sp,48
    80205022:	89aa                	mv	s3,a0
    80205024:	8a2e                	mv	s4,a1
	infof("exec : %s\n", path);
    80205026:	85aa                	mv	a1,a0
    80205028:	4501                	li	a0,0
    8020502a:	ffffb097          	auipc	ra,0xffffb
    8020502e:	282080e7          	jalr	642(ra) # 802002ac <dummy>
	return current_thread->process;
    80205032:	01118797          	auipc	a5,0x1118
    80205036:	2ce78793          	addi	a5,a5,718 # 8131d300 <current_thread>
    8020503a:	639c                	ld	a5,0(a5)
    8020503c:	6784                	ld	s1,8(a5)
	struct inode *ip;
	struct proc *p = curr_proc();
	if ((ip = namei(path)) == 0) {
    8020503e:	854e                	mv	a0,s3
    80205040:	00001097          	auipc	ra,0x1
    80205044:	fe4080e7          	jalr	-28(ra) # 80206024 <namei>
    80205048:	c13d                	beqz	a0,802050ae <exec+0x9c>
    8020504a:	892a                	mv	s2,a0
	return current_thread;
    8020504c:	01118797          	auipc	a5,0x1118
    80205050:	2b478793          	addi	a5,a5,692 # 8131d300 <current_thread>
    80205054:	0007b983          	ld	s3,0(a5)
		errorf("invalid file name %s\n", path);
		return -1;
	}
	// free current main thread's ustack and trapframe
	struct thread *t = curr_thread();
	freethread(t);
    80205058:	854e                	mv	a0,s3
    8020505a:	00000097          	auipc	ra,0x0
    8020505e:	b06080e7          	jalr	-1274(ra) # 80204b60 <freethread>
	t->state = T_UNUSED;
    80205062:	0009a023          	sw	zero,0(s3)
	uvmunmap(p->pagetable, 0, p->max_page, 1);
    80205066:	4685                	li	a3,1
    80205068:	6890                	ld	a2,16(s1)
    8020506a:	4581                	li	a1,0
    8020506c:	6488                	ld	a0,8(s1)
    8020506e:	ffffe097          	auipc	ra,0xffffe
    80205072:	9ce080e7          	jalr	-1586(ra) # 80202a3c <uvmunmap>
	bin_loader(ip, p);
    80205076:	85a6                	mv	a1,s1
    80205078:	854a                	mv	a0,s2
    8020507a:	fffff097          	auipc	ra,0xfffff
    8020507e:	ec6080e7          	jalr	-314(ra) # 80203f40 <bin_loader>
	iput(ip);
    80205082:	854a                	mv	a0,s2
    80205084:	00001097          	auipc	ra,0x1
    80205088:	958080e7          	jalr	-1704(ra) # 802059dc <iput>
	t->state = RUNNING;
    8020508c:	4791                	li	a5,4
    8020508e:	00f9a023          	sw	a5,0(s3)
	return push_argv(p, argv);
    80205092:	85d2                	mv	a1,s4
    80205094:	8526                	mv	a0,s1
    80205096:	00000097          	auipc	ra,0x0
    8020509a:	d38080e7          	jalr	-712(ra) # 80204dce <push_argv>
}
    8020509e:	70a2                	ld	ra,40(sp)
    802050a0:	7402                	ld	s0,32(sp)
    802050a2:	64e2                	ld	s1,24(sp)
    802050a4:	6942                	ld	s2,16(sp)
    802050a6:	69a2                	ld	s3,8(sp)
    802050a8:	6a02                	ld	s4,0(sp)
    802050aa:	6145                	addi	sp,sp,48
    802050ac:	8082                	ret
		errorf("invalid file name %s\n", path);
    802050ae:	fffff097          	auipc	ra,0xfffff
    802050b2:	2f0080e7          	jalr	752(ra) # 8020439e <procid>
	return curr_thread()->tid;
    802050b6:	01118797          	auipc	a5,0x1118
    802050ba:	24a78793          	addi	a5,a5,586 # 8131d300 <current_thread>
    802050be:	6398                	ld	a4,0(a5)
		errorf("invalid file name %s\n", path);
    802050c0:	87ce                	mv	a5,s3
    802050c2:	4358                	lw	a4,4(a4)
    802050c4:	86aa                	mv	a3,a0
    802050c6:	00003617          	auipc	a2,0x3
    802050ca:	fca60613          	addi	a2,a2,-54 # 80208090 <e_text+0x90>
    802050ce:	45fd                	li	a1,31
    802050d0:	00004517          	auipc	a0,0x4
    802050d4:	c4850513          	addi	a0,a0,-952 # 80208d18 <digits+0x4e0>
    802050d8:	ffffe097          	auipc	ra,0xffffe
    802050dc:	fee080e7          	jalr	-18(ra) # 802030c6 <printf>
		return -1;
    802050e0:	557d                	li	a0,-1
    802050e2:	bf75                	j	8020509e <exec+0x8c>

00000000802050e4 <wait>:

int wait(int pid, int *code)
{
    802050e4:	715d                	addi	sp,sp,-80
    802050e6:	e486                	sd	ra,72(sp)
    802050e8:	e0a2                	sd	s0,64(sp)
    802050ea:	fc26                	sd	s1,56(sp)
    802050ec:	f84a                	sd	s2,48(sp)
    802050ee:	f44e                	sd	s3,40(sp)
    802050f0:	f052                	sd	s4,32(sp)
    802050f2:	ec56                	sd	s5,24(sp)
    802050f4:	e85a                	sd	s6,16(sp)
    802050f6:	e45e                	sd	s7,8(sp)
    802050f8:	e062                	sd	s8,0(sp)
    802050fa:	0880                	addi	s0,sp,80
    802050fc:	8a2a                	mv	s4,a0
    802050fe:	8c2e                	mv	s8,a1
	return current_thread->process;
    80205100:	01118797          	auipc	a5,0x1118
    80205104:	20078793          	addi	a5,a5,512 # 8131d300 <current_thread>
    80205108:	0007bb83          	ld	s7,0(a5)
    8020510c:	008bb983          	ld	s3,8(s7) # 1008 <BASE_ADDRESS-0x801feff8>
		havekids = 0;
		for (np = pool; np < &pool[NPROC]; np++) {
			if (np->state != P_UNUSED && np->parent == p &&
			    (pid <= 0 || np->pid == pid)) {
				havekids = 1;
				if (np->state == ZOMBIE) {
    80205110:	4a89                	li	s5,2
		for (np = pool; np < &pool[NPROC]; np++) {
    80205112:	6489                	lui	s1,0x2
    80205114:	bc848493          	addi	s1,s1,-1080 # 1bc8 <BASE_ADDRESS-0x801fe438>
    80205118:	01117917          	auipc	s2,0x1117
    8020511c:	2e890913          	addi	s2,s2,744 # 8131c400 <sb>
				havekids = 1;
    80205120:	4b05                	li	s6,1
		havekids = 0;
    80205122:	4601                	li	a2,0
		for (np = pool; np < &pool[NPROC]; np++) {
    80205124:	01039797          	auipc	a5,0x1039
    80205128:	edc78793          	addi	a5,a5,-292 # 8123e000 <pool>
    8020512c:	a039                	j	8020513a <wait+0x56>
				if (np->state == ZOMBIE) {
    8020512e:	03570163          	beq	a4,s5,80205150 <wait+0x6c>
				havekids = 1;
    80205132:	865a                	mv	a2,s6
		for (np = pool; np < &pool[NPROC]; np++) {
    80205134:	97a6                	add	a5,a5,s1
    80205136:	03278b63          	beq	a5,s2,8020516c <wait+0x88>
			if (np->state != P_UNUSED && np->parent == p &&
    8020513a:	4398                	lw	a4,0(a5)
    8020513c:	df65                	beqz	a4,80205134 <wait+0x50>
    8020513e:	7394                	ld	a3,32(a5)
    80205140:	ff369ae3          	bne	a3,s3,80205134 <wait+0x50>
    80205144:	ff4055e3          	blez	s4,8020512e <wait+0x4a>
			    (pid <= 0 || np->pid == pid)) {
    80205148:	43d4                	lw	a3,4(a5)
    8020514a:	ff4695e3          	bne	a3,s4,80205134 <wait+0x50>
    8020514e:	b7c5                	j	8020512e <wait+0x4a>
					// Found one.
					np->state = P_UNUSED;
    80205150:	0007a023          	sw	zero,0(a5)
					pid = np->pid;
    80205154:	43c4                	lw	s1,4(a5)
					*code = np->exit_code;
    80205156:	7798                	ld	a4,40(a5)
    80205158:	00ec2023          	sw	a4,0(s8)
					memset((void *)np->threads[0].kstack, 9,
    8020515c:	6605                	lui	a2,0x1
    8020515e:	45a5                	li	a1,9
    80205160:	67e8                	ld	a0,200(a5)
    80205162:	ffffb097          	auipc	ra,0xffffb
    80205166:	f76080e7          	jalr	-138(ra) # 802000d8 <memset>
					       KSTACK_SIZE);
					return pid;
    8020516a:	a019                	j	80205170 <wait+0x8c>
				}
			}
		}
		if (!havekids) {
    8020516c:	ee19                	bnez	a2,8020518a <wait+0xa6>
			return -1;
    8020516e:	54fd                	li	s1,-1
		}
		t->state = RUNNABLE;
		add_task(t);
		sched();
	}
}
    80205170:	8526                	mv	a0,s1
    80205172:	60a6                	ld	ra,72(sp)
    80205174:	6406                	ld	s0,64(sp)
    80205176:	74e2                	ld	s1,56(sp)
    80205178:	7942                	ld	s2,48(sp)
    8020517a:	79a2                	ld	s3,40(sp)
    8020517c:	7a02                	ld	s4,32(sp)
    8020517e:	6ae2                	ld	s5,24(sp)
    80205180:	6b42                	ld	s6,16(sp)
    80205182:	6ba2                	ld	s7,8(sp)
    80205184:	6c02                	ld	s8,0(sp)
    80205186:	6161                	addi	sp,sp,80
    80205188:	8082                	ret
		t->state = RUNNABLE;
    8020518a:	478d                	li	a5,3
    8020518c:	00fba023          	sw	a5,0(s7)
		add_task(t);
    80205190:	855e                	mv	a0,s7
    80205192:	fffff097          	auipc	ra,0xfffff
    80205196:	424080e7          	jalr	1060(ra) # 802045b6 <add_task>
		sched();
    8020519a:	00000097          	auipc	ra,0x0
    8020519e:	8e6080e7          	jalr	-1818(ra) # 80204a80 <sched>
		havekids = 0;
    802051a2:	b741                	j	80205122 <wait+0x3e>

00000000802051a4 <exit>:

// Exit the current process.
void exit(int code)
{
    802051a4:	7179                	addi	sp,sp,-48
    802051a6:	f406                	sd	ra,40(sp)
    802051a8:	f022                	sd	s0,32(sp)
    802051aa:	ec26                	sd	s1,24(sp)
    802051ac:	e84a                	sd	s2,16(sp)
    802051ae:	e44e                	sd	s3,8(sp)
    802051b0:	e052                	sd	s4,0(sp)
    802051b2:	1800                	addi	s0,sp,48
    802051b4:	89aa                	mv	s3,a0
	return current_thread->process;
    802051b6:	01118797          	auipc	a5,0x1118
    802051ba:	14a78793          	addi	a5,a5,330 # 8131d300 <current_thread>
    802051be:	6384                	ld	s1,0(a5)
    802051c0:	0084b903          	ld	s2,8(s1)
	struct proc *p = curr_proc();
	struct thread *t = curr_thread();
	t->exit_code = code;
    802051c4:	ecc8                	sd	a0,152(s1)
	t->state = EXITED;
    802051c6:	4795                	li	a5,5
    802051c8:	c09c                	sw	a5,0(s1)
	int tid = t->tid;
    802051ca:	0044aa03          	lw	s4,4(s1)
	debugf("thread exit with %d", code);
    802051ce:	85aa                	mv	a1,a0
    802051d0:	4501                	li	a0,0
    802051d2:	ffffb097          	auipc	ra,0xffffb
    802051d6:	0da080e7          	jalr	218(ra) # 802002ac <dummy>
	freethread(t);
    802051da:	8526                	mv	a0,s1
    802051dc:	00000097          	auipc	ra,0x0
    802051e0:	984080e7          	jalr	-1660(ra) # 80204b60 <freethread>
	if (tid == 0) {
    802051e4:	000a0e63          	beqz	s4,80205200 <exit+0x5c>
			if (np->parent == p) {
				np->parent = NULL;
			}
		}
	}
	sched();
    802051e8:	00000097          	auipc	ra,0x0
    802051ec:	898080e7          	jalr	-1896(ra) # 80204a80 <sched>
}
    802051f0:	70a2                	ld	ra,40(sp)
    802051f2:	7402                	ld	s0,32(sp)
    802051f4:	64e2                	ld	s1,24(sp)
    802051f6:	6942                	ld	s2,16(sp)
    802051f8:	69a2                	ld	s3,8(sp)
    802051fa:	6a02                	ld	s4,0(sp)
    802051fc:	6145                	addi	sp,sp,48
    802051fe:	8082                	ret
		p->exit_code = code;
    80205200:	03393423          	sd	s3,40(s2)
		freeproc(p);
    80205204:	854a                	mv	a0,s2
    80205206:	00000097          	auipc	ra,0x0
    8020520a:	9d4080e7          	jalr	-1580(ra) # 80204bda <freeproc>
		debugf("proc exit");
    8020520e:	4501                	li	a0,0
    80205210:	ffffb097          	auipc	ra,0xffffb
    80205214:	09c080e7          	jalr	156(ra) # 802002ac <dummy>
		if (p->parent != NULL) {
    80205218:	02093783          	ld	a5,32(s2)
    8020521c:	c781                	beqz	a5,80205224 <exit+0x80>
			p->state = ZOMBIE;
    8020521e:	4789                	li	a5,2
    80205220:	00f92023          	sw	a5,0(s2)
{
    80205224:	01039797          	auipc	a5,0x1039
    80205228:	ddc78793          	addi	a5,a5,-548 # 8123e000 <pool>
		for (np = pool; np < &pool[NPROC]; np++) {
    8020522c:	6689                	lui	a3,0x2
    8020522e:	bc868693          	addi	a3,a3,-1080 # 1bc8 <BASE_ADDRESS-0x801fe438>
    80205232:	01117617          	auipc	a2,0x1117
    80205236:	1ce60613          	addi	a2,a2,462 # 8131c400 <sb>
    8020523a:	a031                	j	80205246 <exit+0xa2>
				np->parent = NULL;
    8020523c:	0207b023          	sd	zero,32(a5)
		for (np = pool; np < &pool[NPROC]; np++) {
    80205240:	97b6                	add	a5,a5,a3
    80205242:	fac783e3          	beq	a5,a2,802051e8 <exit+0x44>
			if (np->parent == p) {
    80205246:	7398                	ld	a4,32(a5)
    80205248:	ff271ce3          	bne	a4,s2,80205240 <exit+0x9c>
    8020524c:	bfc5                	j	8020523c <exit+0x98>

000000008020524e <fdalloc>:

int fdalloc(struct file *f)
{
    8020524e:	1101                	addi	sp,sp,-32
    80205250:	ec06                	sd	ra,24(sp)
    80205252:	e822                	sd	s0,16(sp)
    80205254:	e426                	sd	s1,8(sp)
    80205256:	e04a                	sd	s2,0(sp)
    80205258:	1000                	addi	s0,sp,32
    8020525a:	892a                	mv	s2,a0
	debugf("debugf f = %p, type = %d", f, f->type);
    8020525c:	4110                	lw	a2,0(a0)
    8020525e:	85aa                	mv	a1,a0
    80205260:	4501                	li	a0,0
    80205262:	ffffb097          	auipc	ra,0xffffb
    80205266:	04a080e7          	jalr	74(ra) # 802002ac <dummy>
	return current_thread->process;
    8020526a:	01118797          	auipc	a5,0x1118
    8020526e:	09678793          	addi	a5,a5,150 # 8131d300 <current_thread>
    80205272:	639c                	ld	a5,0(a5)
    80205274:	6790                	ld	a2,8(a5)
	struct proc *p = curr_proc();
	for (int i = 0; i < FD_BUFFER_SIZE; ++i) {
		if (p->files[i] == NULL) {
    80205276:	7a1c                	ld	a5,48(a2)
    80205278:	c39d                	beqz	a5,8020529e <fdalloc+0x50>
    8020527a:	03860793          	addi	a5,a2,56
	for (int i = 0; i < FD_BUFFER_SIZE; ++i) {
    8020527e:	4485                	li	s1,1
    80205280:	46c1                	li	a3,16
		if (p->files[i] == NULL) {
    80205282:	6398                	ld	a4,0(a5)
    80205284:	cf11                	beqz	a4,802052a0 <fdalloc+0x52>
	for (int i = 0; i < FD_BUFFER_SIZE; ++i) {
    80205286:	2485                	addiw	s1,s1,1
    80205288:	07a1                	addi	a5,a5,8
    8020528a:	fed49ce3          	bne	s1,a3,80205282 <fdalloc+0x34>
			p->files[i] = f;
			debugf("debugf fd = %d, f = %p", i, p->files[i]);
			return i;
		}
	}
	return -1;
    8020528e:	54fd                	li	s1,-1
    80205290:	8526                	mv	a0,s1
    80205292:	60e2                	ld	ra,24(sp)
    80205294:	6442                	ld	s0,16(sp)
    80205296:	64a2                	ld	s1,8(sp)
    80205298:	6902                	ld	s2,0(sp)
    8020529a:	6105                	addi	sp,sp,32
    8020529c:	8082                	ret
	for (int i = 0; i < FD_BUFFER_SIZE; ++i) {
    8020529e:	4481                	li	s1,0
			p->files[i] = f;
    802052a0:	00648793          	addi	a5,s1,6
    802052a4:	078e                	slli	a5,a5,0x3
    802052a6:	963e                	add	a2,a2,a5
    802052a8:	01263023          	sd	s2,0(a2)
			debugf("debugf fd = %d, f = %p", i, p->files[i]);
    802052ac:	864a                	mv	a2,s2
    802052ae:	85a6                	mv	a1,s1
    802052b0:	4501                	li	a0,0
    802052b2:	ffffb097          	auipc	ra,0xffffb
    802052b6:	ffa080e7          	jalr	-6(ra) # 802002ac <dummy>
			return i;
    802052ba:	bfd9                	j	80205290 <fdalloc+0x42>

00000000802052bc <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    802052bc:	1141                	addi	sp,sp,-16
    802052be:	e422                	sd	s0,8(sp)
    802052c0:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, time" : "=r"(x));
    802052c2:	c0102573          	rdtime	a0
	return r_time();
}
    802052c6:	6422                	ld	s0,8(sp)
    802052c8:	0141                	addi	sp,sp,16
    802052ca:	8082                	ret

00000000802052cc <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    802052cc:	1141                	addi	sp,sp,-16
    802052ce:	e406                	sd	ra,8(sp)
    802052d0:	e022                	sd	s0,0(sp)
    802052d2:	0800                	addi	s0,sp,16
    802052d4:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    802052d8:	67fd                	lui	a5,0x1f
    802052da:	84878793          	addi	a5,a5,-1976 # 1e848 <BASE_ADDRESS-0x801e17b8>
    802052de:	953e                	add	a0,a0,a5
    802052e0:	ffffe097          	auipc	ra,0xffffe
    802052e4:	016080e7          	jalr	22(ra) # 802032f6 <set_timer>
    802052e8:	60a2                	ld	ra,8(sp)
    802052ea:	6402                	ld	s0,0(sp)
    802052ec:	0141                	addi	sp,sp,16
    802052ee:	8082                	ret

00000000802052f0 <timer_init>:
{
    802052f0:	1141                	addi	sp,sp,-16
    802052f2:	e406                	sd	ra,8(sp)
    802052f4:	e022                	sd	s0,0(sp)
    802052f6:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    802052f8:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    802052fc:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80205300:	10479073          	csrw	sie,a5
	set_next_timer();
    80205304:	00000097          	auipc	ra,0x0
    80205308:	fc8080e7          	jalr	-56(ra) # 802052cc <set_next_timer>
}
    8020530c:	60a2                	ld	ra,8(sp)
    8020530e:	6402                	ld	s0,0(sp)
    80205310:	0141                	addi	sp,sp,16
    80205312:	8082                	ret

0000000080205314 <iget>:
// it from disk.
static struct inode *iget(uint dev, uint inum)
{
	struct inode *ip, *empty;
	// Is the inode already in the table?
	empty = 0;
    80205314:	4681                	li	a3,0
	for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80205316:	01117797          	auipc	a5,0x1117
    8020531a:	10278793          	addi	a5,a5,258 # 8131c418 <itable>
    8020531e:	01118817          	auipc	a6,0x1118
    80205322:	fd280813          	addi	a6,a6,-46 # 8131d2f0 <kernel_pagetable>
    80205326:	a031                	j	80205332 <iget+0x1e>
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
			ip->ref++;
			return ip;
		}
		if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80205328:	c295                	beqz	a3,8020534c <iget+0x38>
	for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8020532a:	04c78793          	addi	a5,a5,76
    8020532e:	03078263          	beq	a5,a6,80205352 <iget+0x3e>
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80205332:	4798                	lw	a4,8(a5)
    80205334:	fee05ae3          	blez	a4,80205328 <iget+0x14>
    80205338:	4390                	lw	a2,0(a5)
    8020533a:	fea617e3          	bne	a2,a0,80205328 <iget+0x14>
    8020533e:	43d0                	lw	a2,4(a5)
    80205340:	feb614e3          	bne	a2,a1,80205328 <iget+0x14>
			ip->ref++;
    80205344:	2705                	addiw	a4,a4,1
    80205346:	c798                	sw	a4,8(a5)
			return ip;
    80205348:	86be                	mv	a3,a5
    8020534a:	a819                	j	80205360 <iget+0x4c>
		if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8020534c:	ff79                	bnez	a4,8020532a <iget+0x16>
    8020534e:	86be                	mv	a3,a5
    80205350:	bfe9                	j	8020532a <iget+0x16>
			empty = ip;
	}

	// Recycle an inode entry.
	if (empty == 0)
    80205352:	ca89                	beqz	a3,80205364 <iget+0x50>
		panic("iget: no inodes");

	ip = empty;
	ip->dev = dev;
    80205354:	c288                	sw	a0,0(a3)
	ip->inum = inum;
    80205356:	c2cc                	sw	a1,4(a3)
	ip->ref = 1;
    80205358:	4785                	li	a5,1
    8020535a:	c69c                	sw	a5,8(a3)
	ip->valid = 0;
    8020535c:	0006a623          	sw	zero,12(a3)
	return ip;
}
    80205360:	8536                	mv	a0,a3
    80205362:	8082                	ret
{
    80205364:	1101                	addi	sp,sp,-32
    80205366:	ec06                	sd	ra,24(sp)
    80205368:	e822                	sd	s0,16(sp)
    8020536a:	e426                	sd	s1,8(sp)
    8020536c:	1000                	addi	s0,sp,32
		panic("iget: no inodes");
    8020536e:	fffff097          	auipc	ra,0xfffff
    80205372:	030080e7          	jalr	48(ra) # 8020439e <procid>
    80205376:	84aa                	mv	s1,a0
    80205378:	fffff097          	auipc	ra,0xfffff
    8020537c:	040080e7          	jalr	64(ra) # 802043b8 <threadid>
    80205380:	0a400813          	li	a6,164
    80205384:	00004797          	auipc	a5,0x4
    80205388:	9c478793          	addi	a5,a5,-1596 # 80208d48 <digits+0x510>
    8020538c:	872a                	mv	a4,a0
    8020538e:	86a6                	mv	a3,s1
    80205390:	00003617          	auipc	a2,0x3
    80205394:	c8060613          	addi	a2,a2,-896 # 80208010 <e_text+0x10>
    80205398:	45fd                	li	a1,31
    8020539a:	00004517          	auipc	a0,0x4
    8020539e:	9b650513          	addi	a0,a0,-1610 # 80208d50 <digits+0x518>
    802053a2:	ffffe097          	auipc	ra,0xffffe
    802053a6:	d24080e7          	jalr	-732(ra) # 802030c6 <printf>
    802053aa:	ffffe097          	auipc	ra,0xffffe
    802053ae:	f34080e7          	jalr	-204(ra) # 802032de <shutdown>

00000000802053b2 <bfree>:
{
    802053b2:	1101                	addi	sp,sp,-32
    802053b4:	ec06                	sd	ra,24(sp)
    802053b6:	e822                	sd	s0,16(sp)
    802053b8:	e426                	sd	s1,8(sp)
    802053ba:	e04a                	sd	s2,0(sp)
    802053bc:	1000                	addi	s0,sp,32
    802053be:	84ae                	mv	s1,a1
	bp = bread(dev, BBLOCK(b, sb));
    802053c0:	00d5d59b          	srliw	a1,a1,0xd
    802053c4:	01117797          	auipc	a5,0x1117
    802053c8:	03c78793          	addi	a5,a5,60 # 8131c400 <sb>
    802053cc:	4bdc                	lw	a5,20(a5)
    802053ce:	9dbd                	addw	a1,a1,a5
    802053d0:	ffffc097          	auipc	ra,0xffffc
    802053d4:	ab0080e7          	jalr	-1360(ra) # 80200e80 <bread>
	bi = b % BPB;
    802053d8:	2481                	sext.w	s1,s1
	m = 1 << (bi % 8);
    802053da:	0074f713          	andi	a4,s1,7
    802053de:	4785                	li	a5,1
    802053e0:	00e797bb          	sllw	a5,a5,a4
	if ((bp->data[bi / 8] & m) == 0)
    802053e4:	14ce                	slli	s1,s1,0x33
    802053e6:	90d9                	srli	s1,s1,0x36
    802053e8:	00950733          	add	a4,a0,s1
    802053ec:	02874703          	lbu	a4,40(a4)
    802053f0:	00e7f6b3          	and	a3,a5,a4
    802053f4:	c69d                	beqz	a3,80205422 <bfree+0x70>
    802053f6:	892a                	mv	s2,a0
	bp->data[bi / 8] &= ~m;
    802053f8:	94aa                	add	s1,s1,a0
    802053fa:	fff7c793          	not	a5,a5
    802053fe:	8ff9                	and	a5,a5,a4
    80205400:	02f48423          	sb	a5,40(s1)
	bwrite(bp);
    80205404:	ffffc097          	auipc	ra,0xffffc
    80205408:	b5a080e7          	jalr	-1190(ra) # 80200f5e <bwrite>
	brelse(bp);
    8020540c:	854a                	mv	a0,s2
    8020540e:	ffffc097          	auipc	ra,0xffffc
    80205412:	b6a080e7          	jalr	-1174(ra) # 80200f78 <brelse>
}
    80205416:	60e2                	ld	ra,24(sp)
    80205418:	6442                	ld	s0,16(sp)
    8020541a:	64a2                	ld	s1,8(sp)
    8020541c:	6902                	ld	s2,0(sp)
    8020541e:	6105                	addi	sp,sp,32
    80205420:	8082                	ret
		panic("freeing free block");
    80205422:	fffff097          	auipc	ra,0xfffff
    80205426:	f7c080e7          	jalr	-132(ra) # 8020439e <procid>
    8020542a:	84aa                	mv	s1,a0
    8020542c:	fffff097          	auipc	ra,0xfffff
    80205430:	f8c080e7          	jalr	-116(ra) # 802043b8 <threadid>
    80205434:	05900813          	li	a6,89
    80205438:	00004797          	auipc	a5,0x4
    8020543c:	91078793          	addi	a5,a5,-1776 # 80208d48 <digits+0x510>
    80205440:	872a                	mv	a4,a0
    80205442:	86a6                	mv	a3,s1
    80205444:	00003617          	auipc	a2,0x3
    80205448:	bcc60613          	addi	a2,a2,-1076 # 80208010 <e_text+0x10>
    8020544c:	45fd                	li	a1,31
    8020544e:	00004517          	auipc	a0,0x4
    80205452:	93250513          	addi	a0,a0,-1742 # 80208d80 <digits+0x548>
    80205456:	ffffe097          	auipc	ra,0xffffe
    8020545a:	c70080e7          	jalr	-912(ra) # 802030c6 <printf>
    8020545e:	ffffe097          	auipc	ra,0xffffe
    80205462:	e80080e7          	jalr	-384(ra) # 802032de <shutdown>

0000000080205466 <balloc>:
{
    80205466:	711d                	addi	sp,sp,-96
    80205468:	ec86                	sd	ra,88(sp)
    8020546a:	e8a2                	sd	s0,80(sp)
    8020546c:	e4a6                	sd	s1,72(sp)
    8020546e:	e0ca                	sd	s2,64(sp)
    80205470:	fc4e                	sd	s3,56(sp)
    80205472:	f852                	sd	s4,48(sp)
    80205474:	f456                	sd	s5,40(sp)
    80205476:	f05a                	sd	s6,32(sp)
    80205478:	ec5e                	sd	s7,24(sp)
    8020547a:	e862                	sd	s8,16(sp)
    8020547c:	e466                	sd	s9,8(sp)
    8020547e:	1080                	addi	s0,sp,96
	for (b = 0; b < sb.size; b += BPB) {
    80205480:	01117797          	auipc	a5,0x1117
    80205484:	f8078793          	addi	a5,a5,-128 # 8131c400 <sb>
    80205488:	43dc                	lw	a5,4(a5)
    8020548a:	10078e63          	beqz	a5,802055a6 <balloc+0x140>
    8020548e:	8baa                	mv	s7,a0
    80205490:	4a81                	li	s5,0
		bp = bread(dev, BBLOCK(b, sb));
    80205492:	01117b17          	auipc	s6,0x1117
    80205496:	f6eb0b13          	addi	s6,s6,-146 # 8131c400 <sb>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8020549a:	4c05                	li	s8,1
			m = 1 << (bi % 8);
    8020549c:	4985                	li	s3,1
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8020549e:	6a09                	lui	s4,0x2
	for (b = 0; b < sb.size; b += BPB) {
    802054a0:	6c89                	lui	s9,0x2
    802054a2:	a079                	j	80205530 <balloc+0xca>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    802054a4:	8942                	mv	s2,a6
			m = 1 << (bi % 8);
    802054a6:	4705                	li	a4,1
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    802054a8:	4681                	li	a3,0
				bp->data[bi / 8] |= m; // Mark block in use.
    802054aa:	96a6                	add	a3,a3,s1
    802054ac:	8f51                	or	a4,a4,a2
    802054ae:	02e68423          	sb	a4,40(a3)
				bwrite(bp);
    802054b2:	8526                	mv	a0,s1
    802054b4:	ffffc097          	auipc	ra,0xffffc
    802054b8:	aaa080e7          	jalr	-1366(ra) # 80200f5e <bwrite>
				brelse(bp);
    802054bc:	8526                	mv	a0,s1
    802054be:	ffffc097          	auipc	ra,0xffffc
    802054c2:	aba080e7          	jalr	-1350(ra) # 80200f78 <brelse>
	bp = bread(dev, bno);
    802054c6:	85ca                	mv	a1,s2
    802054c8:	855e                	mv	a0,s7
    802054ca:	ffffc097          	auipc	ra,0xffffc
    802054ce:	9b6080e7          	jalr	-1610(ra) # 80200e80 <bread>
    802054d2:	84aa                	mv	s1,a0
	memset(bp->data, 0, BSIZE);
    802054d4:	40000613          	li	a2,1024
    802054d8:	4581                	li	a1,0
    802054da:	02850513          	addi	a0,a0,40
    802054de:	ffffb097          	auipc	ra,0xffffb
    802054e2:	bfa080e7          	jalr	-1030(ra) # 802000d8 <memset>
	bwrite(bp);
    802054e6:	8526                	mv	a0,s1
    802054e8:	ffffc097          	auipc	ra,0xffffc
    802054ec:	a76080e7          	jalr	-1418(ra) # 80200f5e <bwrite>
	brelse(bp);
    802054f0:	8526                	mv	a0,s1
    802054f2:	ffffc097          	auipc	ra,0xffffc
    802054f6:	a86080e7          	jalr	-1402(ra) # 80200f78 <brelse>
}
    802054fa:	854a                	mv	a0,s2
    802054fc:	60e6                	ld	ra,88(sp)
    802054fe:	6446                	ld	s0,80(sp)
    80205500:	64a6                	ld	s1,72(sp)
    80205502:	6906                	ld	s2,64(sp)
    80205504:	79e2                	ld	s3,56(sp)
    80205506:	7a42                	ld	s4,48(sp)
    80205508:	7aa2                	ld	s5,40(sp)
    8020550a:	7b02                	ld	s6,32(sp)
    8020550c:	6be2                	ld	s7,24(sp)
    8020550e:	6c42                	ld	s8,16(sp)
    80205510:	6ca2                	ld	s9,8(sp)
    80205512:	6125                	addi	sp,sp,96
    80205514:	8082                	ret
		brelse(bp);
    80205516:	8526                	mv	a0,s1
    80205518:	ffffc097          	auipc	ra,0xffffc
    8020551c:	a60080e7          	jalr	-1440(ra) # 80200f78 <brelse>
	for (b = 0; b < sb.size; b += BPB) {
    80205520:	015c87bb          	addw	a5,s9,s5
    80205524:	00078a9b          	sext.w	s5,a5
    80205528:	004b2703          	lw	a4,4(s6)
    8020552c:	06eafd63          	bgeu	s5,a4,802055a6 <balloc+0x140>
		bp = bread(dev, BBLOCK(b, sb));
    80205530:	41fad79b          	sraiw	a5,s5,0x1f
    80205534:	0137d79b          	srliw	a5,a5,0x13
    80205538:	015787bb          	addw	a5,a5,s5
    8020553c:	40d7d79b          	sraiw	a5,a5,0xd
    80205540:	014b2583          	lw	a1,20(s6)
    80205544:	9dbd                	addw	a1,a1,a5
    80205546:	855e                	mv	a0,s7
    80205548:	ffffc097          	auipc	ra,0xffffc
    8020554c:	938080e7          	jalr	-1736(ra) # 80200e80 <bread>
    80205550:	84aa                	mv	s1,a0
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80205552:	000a881b          	sext.w	a6,s5
    80205556:	004b2503          	lw	a0,4(s6)
    8020555a:	faa87ee3          	bgeu	a6,a0,80205516 <balloc+0xb0>
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    8020555e:	0284c603          	lbu	a2,40(s1)
    80205562:	00167793          	andi	a5,a2,1
    80205566:	df9d                	beqz	a5,802054a4 <balloc+0x3e>
    80205568:	4105053b          	subw	a0,a0,a6
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8020556c:	87e2                	mv	a5,s8
    8020556e:	0107893b          	addw	s2,a5,a6
    80205572:	faa782e3          	beq	a5,a0,80205516 <balloc+0xb0>
			m = 1 << (bi % 8);
    80205576:	41f7d71b          	sraiw	a4,a5,0x1f
    8020557a:	01d7561b          	srliw	a2,a4,0x1d
    8020557e:	00f606bb          	addw	a3,a2,a5
    80205582:	0076f713          	andi	a4,a3,7
    80205586:	9f11                	subw	a4,a4,a2
    80205588:	00e9973b          	sllw	a4,s3,a4
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    8020558c:	4036d69b          	sraiw	a3,a3,0x3
    80205590:	00d48633          	add	a2,s1,a3
    80205594:	02864603          	lbu	a2,40(a2)
    80205598:	00c775b3          	and	a1,a4,a2
    8020559c:	d599                	beqz	a1,802054aa <balloc+0x44>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8020559e:	2785                	addiw	a5,a5,1
    802055a0:	fd4797e3          	bne	a5,s4,8020556e <balloc+0x108>
    802055a4:	bf8d                	j	80205516 <balloc+0xb0>
	panic("balloc: out of blocks");
    802055a6:	fffff097          	auipc	ra,0xfffff
    802055aa:	df8080e7          	jalr	-520(ra) # 8020439e <procid>
    802055ae:	84aa                	mv	s1,a0
    802055b0:	fffff097          	auipc	ra,0xfffff
    802055b4:	e08080e7          	jalr	-504(ra) # 802043b8 <threadid>
    802055b8:	04b00813          	li	a6,75
    802055bc:	00003797          	auipc	a5,0x3
    802055c0:	78c78793          	addi	a5,a5,1932 # 80208d48 <digits+0x510>
    802055c4:	872a                	mv	a4,a0
    802055c6:	86a6                	mv	a3,s1
    802055c8:	00003617          	auipc	a2,0x3
    802055cc:	a4860613          	addi	a2,a2,-1464 # 80208010 <e_text+0x10>
    802055d0:	45fd                	li	a1,31
    802055d2:	00003517          	auipc	a0,0x3
    802055d6:	7de50513          	addi	a0,a0,2014 # 80208db0 <digits+0x578>
    802055da:	ffffe097          	auipc	ra,0xffffe
    802055de:	aec080e7          	jalr	-1300(ra) # 802030c6 <printf>
    802055e2:	ffffe097          	auipc	ra,0xffffe
    802055e6:	cfc080e7          	jalr	-772(ra) # 802032de <shutdown>

00000000802055ea <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn)
{
    802055ea:	7179                	addi	sp,sp,-48
    802055ec:	f406                	sd	ra,40(sp)
    802055ee:	f022                	sd	s0,32(sp)
    802055f0:	ec26                	sd	s1,24(sp)
    802055f2:	e84a                	sd	s2,16(sp)
    802055f4:	e44e                	sd	s3,8(sp)
    802055f6:	e052                	sd	s4,0(sp)
    802055f8:	1800                	addi	s0,sp,48
    802055fa:	89aa                	mv	s3,a0
	uint addr, *a;
	struct buf *bp;

	if (bn < NDIRECT) {
    802055fc:	47ad                	li	a5,11
    802055fe:	04b7fd63          	bgeu	a5,a1,80205658 <bmap+0x6e>
		if ((addr = ip->addrs[bn]) == 0)
			ip->addrs[bn] = addr = balloc(ip->dev);
		return addr;
	}
	bn -= NDIRECT;
    80205602:	ff45849b          	addiw	s1,a1,-12
    80205606:	0004871b          	sext.w	a4,s1

	if (bn < NINDIRECT) {
    8020560a:	0ff00793          	li	a5,255
    8020560e:	0ae7e263          	bltu	a5,a4,802056b2 <bmap+0xc8>
		// Load indirect block, allocating if necessary.
		if ((addr = ip->addrs[NDIRECT]) == 0)
    80205612:	452c                	lw	a1,72(a0)
    80205614:	c5ad                	beqz	a1,8020567e <bmap+0x94>
			ip->addrs[NDIRECT] = addr = balloc(ip->dev);
		bp = bread(ip->dev, addr);
    80205616:	0009a503          	lw	a0,0(s3)
    8020561a:	ffffc097          	auipc	ra,0xffffc
    8020561e:	866080e7          	jalr	-1946(ra) # 80200e80 <bread>
    80205622:	8a2a                	mv	s4,a0
		a = (uint *)bp->data;
    80205624:	02850793          	addi	a5,a0,40
		if ((addr = a[bn]) == 0) {
    80205628:	02049593          	slli	a1,s1,0x20
    8020562c:	9181                	srli	a1,a1,0x20
    8020562e:	058a                	slli	a1,a1,0x2
    80205630:	00b784b3          	add	s1,a5,a1
    80205634:	0004a903          	lw	s2,0(s1)
    80205638:	04090d63          	beqz	s2,80205692 <bmap+0xa8>
			a[bn] = addr = balloc(ip->dev);
			bwrite(bp);
		}
		brelse(bp);
    8020563c:	8552                	mv	a0,s4
    8020563e:	ffffc097          	auipc	ra,0xffffc
    80205642:	93a080e7          	jalr	-1734(ra) # 80200f78 <brelse>
		return addr;
	}

	panic("bmap: out of range");
	return 0;
}
    80205646:	854a                	mv	a0,s2
    80205648:	70a2                	ld	ra,40(sp)
    8020564a:	7402                	ld	s0,32(sp)
    8020564c:	64e2                	ld	s1,24(sp)
    8020564e:	6942                	ld	s2,16(sp)
    80205650:	69a2                	ld	s3,8(sp)
    80205652:	6a02                	ld	s4,0(sp)
    80205654:	6145                	addi	sp,sp,48
    80205656:	8082                	ret
		if ((addr = ip->addrs[bn]) == 0)
    80205658:	02059493          	slli	s1,a1,0x20
    8020565c:	9081                	srli	s1,s1,0x20
    8020565e:	048a                	slli	s1,s1,0x2
    80205660:	94aa                	add	s1,s1,a0
    80205662:	0184a903          	lw	s2,24(s1)
    80205666:	fe0910e3          	bnez	s2,80205646 <bmap+0x5c>
			ip->addrs[bn] = addr = balloc(ip->dev);
    8020566a:	4108                	lw	a0,0(a0)
    8020566c:	00000097          	auipc	ra,0x0
    80205670:	dfa080e7          	jalr	-518(ra) # 80205466 <balloc>
    80205674:	0005091b          	sext.w	s2,a0
    80205678:	0124ac23          	sw	s2,24(s1)
    8020567c:	b7e9                	j	80205646 <bmap+0x5c>
			ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8020567e:	4108                	lw	a0,0(a0)
    80205680:	00000097          	auipc	ra,0x0
    80205684:	de6080e7          	jalr	-538(ra) # 80205466 <balloc>
    80205688:	0005059b          	sext.w	a1,a0
    8020568c:	04b9a423          	sw	a1,72(s3)
    80205690:	b759                	j	80205616 <bmap+0x2c>
			a[bn] = addr = balloc(ip->dev);
    80205692:	0009a503          	lw	a0,0(s3)
    80205696:	00000097          	auipc	ra,0x0
    8020569a:	dd0080e7          	jalr	-560(ra) # 80205466 <balloc>
    8020569e:	0005091b          	sext.w	s2,a0
    802056a2:	0124a023          	sw	s2,0(s1)
			bwrite(bp);
    802056a6:	8552                	mv	a0,s4
    802056a8:	ffffc097          	auipc	ra,0xffffc
    802056ac:	8b6080e7          	jalr	-1866(ra) # 80200f5e <bwrite>
    802056b0:	b771                	j	8020563c <bmap+0x52>
	panic("bmap: out of range");
    802056b2:	fffff097          	auipc	ra,0xfffff
    802056b6:	cec080e7          	jalr	-788(ra) # 8020439e <procid>
    802056ba:	84aa                	mv	s1,a0
    802056bc:	fffff097          	auipc	ra,0xfffff
    802056c0:	cfc080e7          	jalr	-772(ra) # 802043b8 <threadid>
    802056c4:	10000813          	li	a6,256
    802056c8:	00003797          	auipc	a5,0x3
    802056cc:	68078793          	addi	a5,a5,1664 # 80208d48 <digits+0x510>
    802056d0:	872a                	mv	a4,a0
    802056d2:	86a6                	mv	a3,s1
    802056d4:	00003617          	auipc	a2,0x3
    802056d8:	93c60613          	addi	a2,a2,-1732 # 80208010 <e_text+0x10>
    802056dc:	45fd                	li	a1,31
    802056de:	00003517          	auipc	a0,0x3
    802056e2:	70a50513          	addi	a0,a0,1802 # 80208de8 <digits+0x5b0>
    802056e6:	ffffe097          	auipc	ra,0xffffe
    802056ea:	9e0080e7          	jalr	-1568(ra) # 802030c6 <printf>
    802056ee:	ffffe097          	auipc	ra,0xffffe
    802056f2:	bf0080e7          	jalr	-1040(ra) # 802032de <shutdown>

00000000802056f6 <fsinit>:
{
    802056f6:	1101                	addi	sp,sp,-32
    802056f8:	ec06                	sd	ra,24(sp)
    802056fa:	e822                	sd	s0,16(sp)
    802056fc:	e426                	sd	s1,8(sp)
    802056fe:	e04a                	sd	s2,0(sp)
    80205700:	1000                	addi	s0,sp,32
	bp = bread(dev, 1);
    80205702:	4585                	li	a1,1
    80205704:	4505                	li	a0,1
    80205706:	ffffb097          	auipc	ra,0xffffb
    8020570a:	77a080e7          	jalr	1914(ra) # 80200e80 <bread>
    8020570e:	892a                	mv	s2,a0
	memmove(sb, bp->data, sizeof(*sb));
    80205710:	01117497          	auipc	s1,0x1117
    80205714:	cf048493          	addi	s1,s1,-784 # 8131c400 <sb>
    80205718:	4661                	li	a2,24
    8020571a:	02850593          	addi	a1,a0,40
    8020571e:	8526                	mv	a0,s1
    80205720:	ffffb097          	auipc	ra,0xffffb
    80205724:	a24080e7          	jalr	-1500(ra) # 80200144 <memmove>
	brelse(bp);
    80205728:	854a                	mv	a0,s2
    8020572a:	ffffc097          	auipc	ra,0xffffc
    8020572e:	84e080e7          	jalr	-1970(ra) # 80200f78 <brelse>
	if (sb.magic != FSMAGIC) {
    80205732:	4098                	lw	a4,0(s1)
    80205734:	102037b7          	lui	a5,0x10203
    80205738:	04078793          	addi	a5,a5,64 # 10203040 <BASE_ADDRESS-0x6fffcfc0>
    8020573c:	00f71863          	bne	a4,a5,8020574c <fsinit+0x56>
}
    80205740:	60e2                	ld	ra,24(sp)
    80205742:	6442                	ld	s0,16(sp)
    80205744:	64a2                	ld	s1,8(sp)
    80205746:	6902                	ld	s2,0(sp)
    80205748:	6105                	addi	sp,sp,32
    8020574a:	8082                	ret
		panic("invalid file system");
    8020574c:	fffff097          	auipc	ra,0xfffff
    80205750:	c52080e7          	jalr	-942(ra) # 8020439e <procid>
    80205754:	84aa                	mv	s1,a0
    80205756:	fffff097          	auipc	ra,0xfffff
    8020575a:	c62080e7          	jalr	-926(ra) # 802043b8 <threadid>
    8020575e:	02600813          	li	a6,38
    80205762:	00003797          	auipc	a5,0x3
    80205766:	5e678793          	addi	a5,a5,1510 # 80208d48 <digits+0x510>
    8020576a:	872a                	mv	a4,a0
    8020576c:	86a6                	mv	a3,s1
    8020576e:	00003617          	auipc	a2,0x3
    80205772:	8a260613          	addi	a2,a2,-1886 # 80208010 <e_text+0x10>
    80205776:	45fd                	li	a1,31
    80205778:	00003517          	auipc	a0,0x3
    8020577c:	6a050513          	addi	a0,a0,1696 # 80208e18 <digits+0x5e0>
    80205780:	ffffe097          	auipc	ra,0xffffe
    80205784:	946080e7          	jalr	-1722(ra) # 802030c6 <printf>
    80205788:	ffffe097          	auipc	ra,0xffffe
    8020578c:	b56080e7          	jalr	-1194(ra) # 802032de <shutdown>

0000000080205790 <ialloc>:
{
    80205790:	715d                	addi	sp,sp,-80
    80205792:	e486                	sd	ra,72(sp)
    80205794:	e0a2                	sd	s0,64(sp)
    80205796:	fc26                	sd	s1,56(sp)
    80205798:	f84a                	sd	s2,48(sp)
    8020579a:	f44e                	sd	s3,40(sp)
    8020579c:	f052                	sd	s4,32(sp)
    8020579e:	ec56                	sd	s5,24(sp)
    802057a0:	e85a                	sd	s6,16(sp)
    802057a2:	e45e                	sd	s7,8(sp)
    802057a4:	0880                	addi	s0,sp,80
	for (inum = 1; inum < sb.ninodes; inum++) {
    802057a6:	01117797          	auipc	a5,0x1117
    802057aa:	c5a78793          	addi	a5,a5,-934 # 8131c400 <sb>
    802057ae:	47d8                	lw	a4,12(a5)
    802057b0:	4785                	li	a5,1
    802057b2:	04e7fa63          	bgeu	a5,a4,80205806 <ialloc+0x76>
    802057b6:	8a2a                	mv	s4,a0
    802057b8:	8b2e                	mv	s6,a1
    802057ba:	4485                	li	s1,1
		bp = bread(dev, IBLOCK(inum, sb));
    802057bc:	01117997          	auipc	s3,0x1117
    802057c0:	c4498993          	addi	s3,s3,-956 # 8131c400 <sb>
    802057c4:	00048a9b          	sext.w	s5,s1
    802057c8:	0044d593          	srli	a1,s1,0x4
    802057cc:	0109a783          	lw	a5,16(s3)
    802057d0:	9dbd                	addw	a1,a1,a5
    802057d2:	8552                	mv	a0,s4
    802057d4:	ffffb097          	auipc	ra,0xffffb
    802057d8:	6ac080e7          	jalr	1708(ra) # 80200e80 <bread>
    802057dc:	8baa                	mv	s7,a0
		dip = (struct dinode *)bp->data + inum % IPB;
    802057de:	02850913          	addi	s2,a0,40
    802057e2:	00f4f793          	andi	a5,s1,15
    802057e6:	079a                	slli	a5,a5,0x6
    802057e8:	993e                	add	s2,s2,a5
		if (dip->type == 0) { // a free inode
    802057ea:	00091783          	lh	a5,0(s2)
    802057ee:	cfb1                	beqz	a5,8020584a <ialloc+0xba>
		brelse(bp);
    802057f0:	ffffb097          	auipc	ra,0xffffb
    802057f4:	788080e7          	jalr	1928(ra) # 80200f78 <brelse>
    802057f8:	0485                	addi	s1,s1,1
	for (inum = 1; inum < sb.ninodes; inum++) {
    802057fa:	00c9a703          	lw	a4,12(s3)
    802057fe:	0004879b          	sext.w	a5,s1
    80205802:	fce7e1e3          	bltu	a5,a4,802057c4 <ialloc+0x34>
	panic("ialloc: no inodes");
    80205806:	fffff097          	auipc	ra,0xfffff
    8020580a:	b98080e7          	jalr	-1128(ra) # 8020439e <procid>
    8020580e:	84aa                	mv	s1,a0
    80205810:	fffff097          	auipc	ra,0xfffff
    80205814:	ba8080e7          	jalr	-1112(ra) # 802043b8 <threadid>
    80205818:	07b00813          	li	a6,123
    8020581c:	00003797          	auipc	a5,0x3
    80205820:	52c78793          	addi	a5,a5,1324 # 80208d48 <digits+0x510>
    80205824:	872a                	mv	a4,a0
    80205826:	86a6                	mv	a3,s1
    80205828:	00002617          	auipc	a2,0x2
    8020582c:	7e860613          	addi	a2,a2,2024 # 80208010 <e_text+0x10>
    80205830:	45fd                	li	a1,31
    80205832:	00003517          	auipc	a0,0x3
    80205836:	61650513          	addi	a0,a0,1558 # 80208e48 <digits+0x610>
    8020583a:	ffffe097          	auipc	ra,0xffffe
    8020583e:	88c080e7          	jalr	-1908(ra) # 802030c6 <printf>
    80205842:	ffffe097          	auipc	ra,0xffffe
    80205846:	a9c080e7          	jalr	-1380(ra) # 802032de <shutdown>
			memset(dip, 0, sizeof(*dip));
    8020584a:	04000613          	li	a2,64
    8020584e:	4581                	li	a1,0
    80205850:	854a                	mv	a0,s2
    80205852:	ffffb097          	auipc	ra,0xffffb
    80205856:	886080e7          	jalr	-1914(ra) # 802000d8 <memset>
			dip->type = type;
    8020585a:	01691023          	sh	s6,0(s2)
			bwrite(bp);
    8020585e:	855e                	mv	a0,s7
    80205860:	ffffb097          	auipc	ra,0xffffb
    80205864:	6fe080e7          	jalr	1790(ra) # 80200f5e <bwrite>
			brelse(bp);
    80205868:	855e                	mv	a0,s7
    8020586a:	ffffb097          	auipc	ra,0xffffb
    8020586e:	70e080e7          	jalr	1806(ra) # 80200f78 <brelse>
			return iget(dev, inum);
    80205872:	85d6                	mv	a1,s5
    80205874:	8552                	mv	a0,s4
    80205876:	00000097          	auipc	ra,0x0
    8020587a:	a9e080e7          	jalr	-1378(ra) # 80205314 <iget>
}
    8020587e:	60a6                	ld	ra,72(sp)
    80205880:	6406                	ld	s0,64(sp)
    80205882:	74e2                	ld	s1,56(sp)
    80205884:	7942                	ld	s2,48(sp)
    80205886:	79a2                	ld	s3,40(sp)
    80205888:	7a02                	ld	s4,32(sp)
    8020588a:	6ae2                	ld	s5,24(sp)
    8020588c:	6b42                	ld	s6,16(sp)
    8020588e:	6ba2                	ld	s7,8(sp)
    80205890:	6161                	addi	sp,sp,80
    80205892:	8082                	ret

0000000080205894 <iupdate>:
{
    80205894:	1101                	addi	sp,sp,-32
    80205896:	ec06                	sd	ra,24(sp)
    80205898:	e822                	sd	s0,16(sp)
    8020589a:	e426                	sd	s1,8(sp)
    8020589c:	e04a                	sd	s2,0(sp)
    8020589e:	1000                	addi	s0,sp,32
    802058a0:	84aa                	mv	s1,a0
	bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    802058a2:	415c                	lw	a5,4(a0)
    802058a4:	0047d79b          	srliw	a5,a5,0x4
    802058a8:	01117717          	auipc	a4,0x1117
    802058ac:	b5870713          	addi	a4,a4,-1192 # 8131c400 <sb>
    802058b0:	4b0c                	lw	a1,16(a4)
    802058b2:	9dbd                	addw	a1,a1,a5
    802058b4:	4108                	lw	a0,0(a0)
    802058b6:	ffffb097          	auipc	ra,0xffffb
    802058ba:	5ca080e7          	jalr	1482(ra) # 80200e80 <bread>
    802058be:	892a                	mv	s2,a0
	dip = (struct dinode *)bp->data + ip->inum % IPB;
    802058c0:	02850513          	addi	a0,a0,40
    802058c4:	40dc                	lw	a5,4(s1)
    802058c6:	8bbd                	andi	a5,a5,15
    802058c8:	079a                	slli	a5,a5,0x6
    802058ca:	953e                	add	a0,a0,a5
	dip->type = ip->type;
    802058cc:	01049783          	lh	a5,16(s1)
    802058d0:	00f51023          	sh	a5,0(a0)
	dip->size = ip->size;
    802058d4:	48dc                	lw	a5,20(s1)
    802058d6:	c51c                	sw	a5,8(a0)
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    802058d8:	03400613          	li	a2,52
    802058dc:	01848593          	addi	a1,s1,24
    802058e0:	0531                	addi	a0,a0,12
    802058e2:	ffffb097          	auipc	ra,0xffffb
    802058e6:	862080e7          	jalr	-1950(ra) # 80200144 <memmove>
	bwrite(bp);
    802058ea:	854a                	mv	a0,s2
    802058ec:	ffffb097          	auipc	ra,0xffffb
    802058f0:	672080e7          	jalr	1650(ra) # 80200f5e <bwrite>
	brelse(bp);
    802058f4:	854a                	mv	a0,s2
    802058f6:	ffffb097          	auipc	ra,0xffffb
    802058fa:	682080e7          	jalr	1666(ra) # 80200f78 <brelse>
}
    802058fe:	60e2                	ld	ra,24(sp)
    80205900:	6442                	ld	s0,16(sp)
    80205902:	64a2                	ld	s1,8(sp)
    80205904:	6902                	ld	s2,0(sp)
    80205906:	6105                	addi	sp,sp,32
    80205908:	8082                	ret

000000008020590a <idup>:
{
    8020590a:	1141                	addi	sp,sp,-16
    8020590c:	e422                	sd	s0,8(sp)
    8020590e:	0800                	addi	s0,sp,16
	ip->ref++;
    80205910:	451c                	lw	a5,8(a0)
    80205912:	2785                	addiw	a5,a5,1
    80205914:	c51c                	sw	a5,8(a0)
}
    80205916:	6422                	ld	s0,8(sp)
    80205918:	0141                	addi	sp,sp,16
    8020591a:	8082                	ret

000000008020591c <ivalid>:
	if (ip->valid == 0) {
    8020591c:	455c                	lw	a5,12(a0)
    8020591e:	c391                	beqz	a5,80205922 <ivalid+0x6>
    80205920:	8082                	ret
{
    80205922:	1101                	addi	sp,sp,-32
    80205924:	ec06                	sd	ra,24(sp)
    80205926:	e822                	sd	s0,16(sp)
    80205928:	e426                	sd	s1,8(sp)
    8020592a:	e04a                	sd	s2,0(sp)
    8020592c:	1000                	addi	s0,sp,32
    8020592e:	84aa                	mv	s1,a0
		bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80205930:	415c                	lw	a5,4(a0)
    80205932:	0047d79b          	srliw	a5,a5,0x4
    80205936:	01117717          	auipc	a4,0x1117
    8020593a:	aca70713          	addi	a4,a4,-1334 # 8131c400 <sb>
    8020593e:	4b0c                	lw	a1,16(a4)
    80205940:	9dbd                	addw	a1,a1,a5
    80205942:	4108                	lw	a0,0(a0)
    80205944:	ffffb097          	auipc	ra,0xffffb
    80205948:	53c080e7          	jalr	1340(ra) # 80200e80 <bread>
    8020594c:	892a                	mv	s2,a0
		dip = (struct dinode *)bp->data + ip->inum % IPB;
    8020594e:	02850593          	addi	a1,a0,40
    80205952:	40dc                	lw	a5,4(s1)
    80205954:	8bbd                	andi	a5,a5,15
    80205956:	079a                	slli	a5,a5,0x6
    80205958:	95be                	add	a1,a1,a5
		ip->type = dip->type;
    8020595a:	00059783          	lh	a5,0(a1) # 4000000 <BASE_ADDRESS-0x7c200000>
    8020595e:	00f49823          	sh	a5,16(s1)
		ip->size = dip->size;
    80205962:	459c                	lw	a5,8(a1)
    80205964:	c8dc                	sw	a5,20(s1)
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80205966:	03400613          	li	a2,52
    8020596a:	05b1                	addi	a1,a1,12
    8020596c:	01848513          	addi	a0,s1,24
    80205970:	ffffa097          	auipc	ra,0xffffa
    80205974:	7d4080e7          	jalr	2004(ra) # 80200144 <memmove>
		brelse(bp);
    80205978:	854a                	mv	a0,s2
    8020597a:	ffffb097          	auipc	ra,0xffffb
    8020597e:	5fe080e7          	jalr	1534(ra) # 80200f78 <brelse>
		ip->valid = 1;
    80205982:	4785                	li	a5,1
    80205984:	c4dc                	sw	a5,12(s1)
		if (ip->type == 0)
    80205986:	01049783          	lh	a5,16(s1)
    8020598a:	c799                	beqz	a5,80205998 <ivalid+0x7c>
}
    8020598c:	60e2                	ld	ra,24(sp)
    8020598e:	6442                	ld	s0,16(sp)
    80205990:	64a2                	ld	s1,8(sp)
    80205992:	6902                	ld	s2,0(sp)
    80205994:	6105                	addi	sp,sp,32
    80205996:	8082                	ret
			panic("ivalid: no type");
    80205998:	fffff097          	auipc	ra,0xfffff
    8020599c:	a06080e7          	jalr	-1530(ra) # 8020439e <procid>
    802059a0:	84aa                	mv	s1,a0
    802059a2:	fffff097          	auipc	ra,0xfffff
    802059a6:	a16080e7          	jalr	-1514(ra) # 802043b8 <threadid>
    802059aa:	0c500813          	li	a6,197
    802059ae:	00003797          	auipc	a5,0x3
    802059b2:	39a78793          	addi	a5,a5,922 # 80208d48 <digits+0x510>
    802059b6:	872a                	mv	a4,a0
    802059b8:	86a6                	mv	a3,s1
    802059ba:	00002617          	auipc	a2,0x2
    802059be:	65660613          	addi	a2,a2,1622 # 80208010 <e_text+0x10>
    802059c2:	45fd                	li	a1,31
    802059c4:	00003517          	auipc	a0,0x3
    802059c8:	4b450513          	addi	a0,a0,1204 # 80208e78 <digits+0x640>
    802059cc:	ffffd097          	auipc	ra,0xffffd
    802059d0:	6fa080e7          	jalr	1786(ra) # 802030c6 <printf>
    802059d4:	ffffe097          	auipc	ra,0xffffe
    802059d8:	90a080e7          	jalr	-1782(ra) # 802032de <shutdown>

00000000802059dc <iput>:
{
    802059dc:	1141                	addi	sp,sp,-16
    802059de:	e422                	sd	s0,8(sp)
    802059e0:	0800                	addi	s0,sp,16
	ip->ref--;
    802059e2:	451c                	lw	a5,8(a0)
    802059e4:	37fd                	addiw	a5,a5,-1
    802059e6:	c51c                	sw	a5,8(a0)
}
    802059e8:	6422                	ld	s0,8(sp)
    802059ea:	0141                	addi	sp,sp,16
    802059ec:	8082                	ret

00000000802059ee <itrunc>:

// Truncate inode (discard contents).
void itrunc(struct inode *ip)
{
    802059ee:	7179                	addi	sp,sp,-48
    802059f0:	f406                	sd	ra,40(sp)
    802059f2:	f022                	sd	s0,32(sp)
    802059f4:	ec26                	sd	s1,24(sp)
    802059f6:	e84a                	sd	s2,16(sp)
    802059f8:	e44e                	sd	s3,8(sp)
    802059fa:	e052                	sd	s4,0(sp)
    802059fc:	1800                	addi	s0,sp,48
    802059fe:	89aa                	mv	s3,a0
	int i, j;
	struct buf *bp;
	uint *a;

	for (i = 0; i < NDIRECT; i++) {
    80205a00:	01850493          	addi	s1,a0,24
    80205a04:	04850913          	addi	s2,a0,72
    80205a08:	a821                	j	80205a20 <itrunc+0x32>
		if (ip->addrs[i]) {
			bfree(ip->dev, ip->addrs[i]);
    80205a0a:	0009a503          	lw	a0,0(s3)
    80205a0e:	00000097          	auipc	ra,0x0
    80205a12:	9a4080e7          	jalr	-1628(ra) # 802053b2 <bfree>
			ip->addrs[i] = 0;
    80205a16:	0004a023          	sw	zero,0(s1)
    80205a1a:	0491                	addi	s1,s1,4
	for (i = 0; i < NDIRECT; i++) {
    80205a1c:	01248563          	beq	s1,s2,80205a26 <itrunc+0x38>
		if (ip->addrs[i]) {
    80205a20:	408c                	lw	a1,0(s1)
    80205a22:	dde5                	beqz	a1,80205a1a <itrunc+0x2c>
    80205a24:	b7dd                	j	80205a0a <itrunc+0x1c>
		}
	}

	if (ip->addrs[NDIRECT]) {
    80205a26:	0489a583          	lw	a1,72(s3)
    80205a2a:	e185                	bnez	a1,80205a4a <itrunc+0x5c>
		brelse(bp);
		bfree(ip->dev, ip->addrs[NDIRECT]);
		ip->addrs[NDIRECT] = 0;
	}

	ip->size = 0;
    80205a2c:	0009aa23          	sw	zero,20(s3)
	iupdate(ip);
    80205a30:	854e                	mv	a0,s3
    80205a32:	00000097          	auipc	ra,0x0
    80205a36:	e62080e7          	jalr	-414(ra) # 80205894 <iupdate>
}
    80205a3a:	70a2                	ld	ra,40(sp)
    80205a3c:	7402                	ld	s0,32(sp)
    80205a3e:	64e2                	ld	s1,24(sp)
    80205a40:	6942                	ld	s2,16(sp)
    80205a42:	69a2                	ld	s3,8(sp)
    80205a44:	6a02                	ld	s4,0(sp)
    80205a46:	6145                	addi	sp,sp,48
    80205a48:	8082                	ret
		bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80205a4a:	0009a503          	lw	a0,0(s3)
    80205a4e:	ffffb097          	auipc	ra,0xffffb
    80205a52:	432080e7          	jalr	1074(ra) # 80200e80 <bread>
    80205a56:	8a2a                	mv	s4,a0
		for (j = 0; j < NINDIRECT; j++) {
    80205a58:	02850493          	addi	s1,a0,40
    80205a5c:	42850913          	addi	s2,a0,1064
    80205a60:	a811                	j	80205a74 <itrunc+0x86>
				bfree(ip->dev, a[j]);
    80205a62:	0009a503          	lw	a0,0(s3)
    80205a66:	00000097          	auipc	ra,0x0
    80205a6a:	94c080e7          	jalr	-1716(ra) # 802053b2 <bfree>
    80205a6e:	0491                	addi	s1,s1,4
		for (j = 0; j < NINDIRECT; j++) {
    80205a70:	01248563          	beq	s1,s2,80205a7a <itrunc+0x8c>
			if (a[j])
    80205a74:	408c                	lw	a1,0(s1)
    80205a76:	dde5                	beqz	a1,80205a6e <itrunc+0x80>
    80205a78:	b7ed                	j	80205a62 <itrunc+0x74>
		brelse(bp);
    80205a7a:	8552                	mv	a0,s4
    80205a7c:	ffffb097          	auipc	ra,0xffffb
    80205a80:	4fc080e7          	jalr	1276(ra) # 80200f78 <brelse>
		bfree(ip->dev, ip->addrs[NDIRECT]);
    80205a84:	0489a583          	lw	a1,72(s3)
    80205a88:	0009a503          	lw	a0,0(s3)
    80205a8c:	00000097          	auipc	ra,0x0
    80205a90:	926080e7          	jalr	-1754(ra) # 802053b2 <bfree>
		ip->addrs[NDIRECT] = 0;
    80205a94:	0409a423          	sw	zero,72(s3)
    80205a98:	bf51                	j	80205a2c <itrunc+0x3e>

0000000080205a9a <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
	uint tot, m;
	struct buf *bp;

	if (off > ip->size || off + n < off)
    80205a9a:	495c                	lw	a5,20(a0)
    80205a9c:	0ed7e963          	bltu	a5,a3,80205b8e <readi+0xf4>
{
    80205aa0:	7159                	addi	sp,sp,-112
    80205aa2:	f486                	sd	ra,104(sp)
    80205aa4:	f0a2                	sd	s0,96(sp)
    80205aa6:	eca6                	sd	s1,88(sp)
    80205aa8:	e8ca                	sd	s2,80(sp)
    80205aaa:	e4ce                	sd	s3,72(sp)
    80205aac:	e0d2                	sd	s4,64(sp)
    80205aae:	fc56                	sd	s5,56(sp)
    80205ab0:	f85a                	sd	s6,48(sp)
    80205ab2:	f45e                	sd	s7,40(sp)
    80205ab4:	f062                	sd	s8,32(sp)
    80205ab6:	ec66                	sd	s9,24(sp)
    80205ab8:	e86a                	sd	s10,16(sp)
    80205aba:	e46e                	sd	s11,8(sp)
    80205abc:	1880                	addi	s0,sp,112
    80205abe:	8baa                	mv	s7,a0
    80205ac0:	8c2e                	mv	s8,a1
    80205ac2:	8a32                	mv	s4,a2
    80205ac4:	84b6                	mv	s1,a3
    80205ac6:	8b3a                	mv	s6,a4
	if (off > ip->size || off + n < off)
    80205ac8:	9f35                	addw	a4,a4,a3
		return 0;
    80205aca:	4501                	li	a0,0
	if (off > ip->size || off + n < off)
    80205acc:	0ad76063          	bltu	a4,a3,80205b6c <readi+0xd2>
	if (off + n > ip->size)
    80205ad0:	00e7f463          	bgeu	a5,a4,80205ad8 <readi+0x3e>
		n = ip->size - off;
    80205ad4:	40d78b3b          	subw	s6,a5,a3

	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80205ad8:	0a0b0963          	beqz	s6,80205b8a <readi+0xf0>
    80205adc:	4901                	li	s2,0
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
		m = MIN(n - tot, BSIZE - off % BSIZE);
    80205ade:	40000d13          	li	s10,1024
		if (either_copyout(user_dst, dst,
    80205ae2:	5cfd                	li	s9,-1
    80205ae4:	a82d                	j	80205b1e <readi+0x84>
    80205ae6:	02099d93          	slli	s11,s3,0x20
    80205aea:	020ddd93          	srli	s11,s11,0x20
				   (char *)bp->data + (off % BSIZE), m) == -1) {
    80205aee:	028a8613          	addi	a2,s5,40
		if (either_copyout(user_dst, dst,
    80205af2:	86ee                	mv	a3,s11
    80205af4:	963a                	add	a2,a2,a4
    80205af6:	85d2                	mv	a1,s4
    80205af8:	8562                	mv	a0,s8
    80205afa:	ffffd097          	auipc	ra,0xffffd
    80205afe:	47c080e7          	jalr	1148(ra) # 80202f76 <either_copyout>
    80205b02:	05950d63          	beq	a0,s9,80205b5c <readi+0xc2>
			brelse(bp);
			tot = -1;
			break;
		}
		brelse(bp);
    80205b06:	8556                	mv	a0,s5
    80205b08:	ffffb097          	auipc	ra,0xffffb
    80205b0c:	470080e7          	jalr	1136(ra) # 80200f78 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80205b10:	0129893b          	addw	s2,s3,s2
    80205b14:	009984bb          	addw	s1,s3,s1
    80205b18:	9a6e                	add	s4,s4,s11
    80205b1a:	05697763          	bgeu	s2,s6,80205b68 <readi+0xce>
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80205b1e:	000ba983          	lw	s3,0(s7)
    80205b22:	00a4d59b          	srliw	a1,s1,0xa
    80205b26:	855e                	mv	a0,s7
    80205b28:	00000097          	auipc	ra,0x0
    80205b2c:	ac2080e7          	jalr	-1342(ra) # 802055ea <bmap>
    80205b30:	0005059b          	sext.w	a1,a0
    80205b34:	854e                	mv	a0,s3
    80205b36:	ffffb097          	auipc	ra,0xffffb
    80205b3a:	34a080e7          	jalr	842(ra) # 80200e80 <bread>
    80205b3e:	8aaa                	mv	s5,a0
		m = MIN(n - tot, BSIZE - off % BSIZE);
    80205b40:	3ff4f713          	andi	a4,s1,1023
    80205b44:	40ed07bb          	subw	a5,s10,a4
    80205b48:	412b06bb          	subw	a3,s6,s2
    80205b4c:	89be                	mv	s3,a5
    80205b4e:	2781                	sext.w	a5,a5
    80205b50:	0006861b          	sext.w	a2,a3
    80205b54:	f8f679e3          	bgeu	a2,a5,80205ae6 <readi+0x4c>
    80205b58:	89b6                	mv	s3,a3
    80205b5a:	b771                	j	80205ae6 <readi+0x4c>
			brelse(bp);
    80205b5c:	8556                	mv	a0,s5
    80205b5e:	ffffb097          	auipc	ra,0xffffb
    80205b62:	41a080e7          	jalr	1050(ra) # 80200f78 <brelse>
			tot = -1;
    80205b66:	597d                	li	s2,-1
	}
	return tot;
    80205b68:	0009051b          	sext.w	a0,s2
}
    80205b6c:	70a6                	ld	ra,104(sp)
    80205b6e:	7406                	ld	s0,96(sp)
    80205b70:	64e6                	ld	s1,88(sp)
    80205b72:	6946                	ld	s2,80(sp)
    80205b74:	69a6                	ld	s3,72(sp)
    80205b76:	6a06                	ld	s4,64(sp)
    80205b78:	7ae2                	ld	s5,56(sp)
    80205b7a:	7b42                	ld	s6,48(sp)
    80205b7c:	7ba2                	ld	s7,40(sp)
    80205b7e:	7c02                	ld	s8,32(sp)
    80205b80:	6ce2                	ld	s9,24(sp)
    80205b82:	6d42                	ld	s10,16(sp)
    80205b84:	6da2                	ld	s11,8(sp)
    80205b86:	6165                	addi	sp,sp,112
    80205b88:	8082                	ret
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80205b8a:	895a                	mv	s2,s6
    80205b8c:	bff1                	j	80205b68 <readi+0xce>
		return 0;
    80205b8e:	4501                	li	a0,0
}
    80205b90:	8082                	ret

0000000080205b92 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
	uint tot, m;
	struct buf *bp;

	if (off > ip->size || off + n < off)
    80205b92:	495c                	lw	a5,20(a0)
    80205b94:	10d7e863          	bltu	a5,a3,80205ca4 <writei+0x112>
{
    80205b98:	7159                	addi	sp,sp,-112
    80205b9a:	f486                	sd	ra,104(sp)
    80205b9c:	f0a2                	sd	s0,96(sp)
    80205b9e:	eca6                	sd	s1,88(sp)
    80205ba0:	e8ca                	sd	s2,80(sp)
    80205ba2:	e4ce                	sd	s3,72(sp)
    80205ba4:	e0d2                	sd	s4,64(sp)
    80205ba6:	fc56                	sd	s5,56(sp)
    80205ba8:	f85a                	sd	s6,48(sp)
    80205baa:	f45e                	sd	s7,40(sp)
    80205bac:	f062                	sd	s8,32(sp)
    80205bae:	ec66                	sd	s9,24(sp)
    80205bb0:	e86a                	sd	s10,16(sp)
    80205bb2:	e46e                	sd	s11,8(sp)
    80205bb4:	1880                	addi	s0,sp,112
    80205bb6:	8b2a                	mv	s6,a0
    80205bb8:	8c2e                	mv	s8,a1
    80205bba:	8ab2                	mv	s5,a2
    80205bbc:	84b6                	mv	s1,a3
    80205bbe:	8bba                	mv	s7,a4
	if (off > ip->size || off + n < off)
    80205bc0:	00e687bb          	addw	a5,a3,a4
    80205bc4:	0ed7e263          	bltu	a5,a3,80205ca8 <writei+0x116>
		return -1;
	if (off + n > MAXFILE * BSIZE)
    80205bc8:	00043737          	lui	a4,0x43
    80205bcc:	0ef76063          	bltu	a4,a5,80205cac <writei+0x11a>
		return -1;

	for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80205bd0:	0c0b8863          	beqz	s7,80205ca0 <writei+0x10e>
    80205bd4:	4981                	li	s3,0
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
		m = MIN(n - tot, BSIZE - off % BSIZE);
    80205bd6:	40000d13          	li	s10,1024
		if (either_copyin(user_src, src,
    80205bda:	5cfd                	li	s9,-1
    80205bdc:	a091                	j	80205c20 <writei+0x8e>
    80205bde:	02091d93          	slli	s11,s2,0x20
    80205be2:	020ddd93          	srli	s11,s11,0x20
				  (char *)bp->data + (off % BSIZE), m) == -1) {
    80205be6:	028a0613          	addi	a2,s4,40 # 2028 <BASE_ADDRESS-0x801fdfd8>
		if (either_copyin(user_src, src,
    80205bea:	86ee                	mv	a3,s11
    80205bec:	963a                	add	a2,a2,a4
    80205bee:	85d6                	mv	a1,s5
    80205bf0:	8562                	mv	a0,s8
    80205bf2:	ffffd097          	auipc	ra,0xffffd
    80205bf6:	3da080e7          	jalr	986(ra) # 80202fcc <either_copyin>
    80205bfa:	07950263          	beq	a0,s9,80205c5e <writei+0xcc>
			brelse(bp);
			break;
		}
		bwrite(bp);
    80205bfe:	8552                	mv	a0,s4
    80205c00:	ffffb097          	auipc	ra,0xffffb
    80205c04:	35e080e7          	jalr	862(ra) # 80200f5e <bwrite>
		brelse(bp);
    80205c08:	8552                	mv	a0,s4
    80205c0a:	ffffb097          	auipc	ra,0xffffb
    80205c0e:	36e080e7          	jalr	878(ra) # 80200f78 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80205c12:	013909bb          	addw	s3,s2,s3
    80205c16:	009904bb          	addw	s1,s2,s1
    80205c1a:	9aee                	add	s5,s5,s11
    80205c1c:	0579f663          	bgeu	s3,s7,80205c68 <writei+0xd6>
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80205c20:	000b2903          	lw	s2,0(s6)
    80205c24:	00a4d59b          	srliw	a1,s1,0xa
    80205c28:	855a                	mv	a0,s6
    80205c2a:	00000097          	auipc	ra,0x0
    80205c2e:	9c0080e7          	jalr	-1600(ra) # 802055ea <bmap>
    80205c32:	0005059b          	sext.w	a1,a0
    80205c36:	854a                	mv	a0,s2
    80205c38:	ffffb097          	auipc	ra,0xffffb
    80205c3c:	248080e7          	jalr	584(ra) # 80200e80 <bread>
    80205c40:	8a2a                	mv	s4,a0
		m = MIN(n - tot, BSIZE - off % BSIZE);
    80205c42:	3ff4f713          	andi	a4,s1,1023
    80205c46:	40ed07bb          	subw	a5,s10,a4
    80205c4a:	413b86bb          	subw	a3,s7,s3
    80205c4e:	893e                	mv	s2,a5
    80205c50:	2781                	sext.w	a5,a5
    80205c52:	0006861b          	sext.w	a2,a3
    80205c56:	f8f674e3          	bgeu	a2,a5,80205bde <writei+0x4c>
    80205c5a:	8936                	mv	s2,a3
    80205c5c:	b749                	j	80205bde <writei+0x4c>
			brelse(bp);
    80205c5e:	8552                	mv	a0,s4
    80205c60:	ffffb097          	auipc	ra,0xffffb
    80205c64:	318080e7          	jalr	792(ra) # 80200f78 <brelse>
	}

	if (off > ip->size)
    80205c68:	014b2783          	lw	a5,20(s6)
    80205c6c:	0097f463          	bgeu	a5,s1,80205c74 <writei+0xe2>
		ip->size = off;
    80205c70:	009b2a23          	sw	s1,20(s6)

	// write the i-node back to disk even if the size didn't change
	// because the loop above might have called bmap() and added a new
	// block to ip->addrs[].
	iupdate(ip);
    80205c74:	855a                	mv	a0,s6
    80205c76:	00000097          	auipc	ra,0x0
    80205c7a:	c1e080e7          	jalr	-994(ra) # 80205894 <iupdate>

	return tot;
    80205c7e:	0009851b          	sext.w	a0,s3
}
    80205c82:	70a6                	ld	ra,104(sp)
    80205c84:	7406                	ld	s0,96(sp)
    80205c86:	64e6                	ld	s1,88(sp)
    80205c88:	6946                	ld	s2,80(sp)
    80205c8a:	69a6                	ld	s3,72(sp)
    80205c8c:	6a06                	ld	s4,64(sp)
    80205c8e:	7ae2                	ld	s5,56(sp)
    80205c90:	7b42                	ld	s6,48(sp)
    80205c92:	7ba2                	ld	s7,40(sp)
    80205c94:	7c02                	ld	s8,32(sp)
    80205c96:	6ce2                	ld	s9,24(sp)
    80205c98:	6d42                	ld	s10,16(sp)
    80205c9a:	6da2                	ld	s11,8(sp)
    80205c9c:	6165                	addi	sp,sp,112
    80205c9e:	8082                	ret
	for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80205ca0:	89de                	mv	s3,s7
    80205ca2:	bfc9                	j	80205c74 <writei+0xe2>
		return -1;
    80205ca4:	557d                	li	a0,-1
}
    80205ca6:	8082                	ret
		return -1;
    80205ca8:	557d                	li	a0,-1
    80205caa:	bfe1                	j	80205c82 <writei+0xf0>
		return -1;
    80205cac:	557d                	li	a0,-1
    80205cae:	bfd1                	j	80205c82 <writei+0xf0>

0000000080205cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff)
{
    80205cb0:	7139                	addi	sp,sp,-64
    80205cb2:	fc06                	sd	ra,56(sp)
    80205cb4:	f822                	sd	s0,48(sp)
    80205cb6:	f426                	sd	s1,40(sp)
    80205cb8:	f04a                	sd	s2,32(sp)
    80205cba:	ec4e                	sd	s3,24(sp)
    80205cbc:	e852                	sd	s4,16(sp)
    80205cbe:	0080                	addi	s0,sp,64
	uint off, inum;
	struct dirent de;

	if (dp->type != T_DIR)
    80205cc0:	01051703          	lh	a4,16(a0)
    80205cc4:	4785                	li	a5,1
    80205cc6:	00f71a63          	bne	a4,a5,80205cda <dirlookup+0x2a>
    80205cca:	892a                	mv	s2,a0
    80205ccc:	89ae                	mv	s3,a1
    80205cce:	8a32                	mv	s4,a2
		panic("dirlookup not DIR");

	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205cd0:	495c                	lw	a5,20(a0)
    80205cd2:	4481                	li	s1,0
			inum = de.inum;
			return iget(dp->dev, inum);
		}
	}

	return 0;
    80205cd4:	4501                	li	a0,0
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205cd6:	ebd9                	bnez	a5,80205d6c <dirlookup+0xbc>
    80205cd8:	a0cd                	j	80205dba <dirlookup+0x10a>
		panic("dirlookup not DIR");
    80205cda:	ffffe097          	auipc	ra,0xffffe
    80205cde:	6c4080e7          	jalr	1732(ra) # 8020439e <procid>
    80205ce2:	84aa                	mv	s1,a0
    80205ce4:	ffffe097          	auipc	ra,0xffffe
    80205ce8:	6d4080e7          	jalr	1748(ra) # 802043b8 <threadid>
    80205cec:	16d00813          	li	a6,365
    80205cf0:	00003797          	auipc	a5,0x3
    80205cf4:	05878793          	addi	a5,a5,88 # 80208d48 <digits+0x510>
    80205cf8:	872a                	mv	a4,a0
    80205cfa:	86a6                	mv	a3,s1
    80205cfc:	00002617          	auipc	a2,0x2
    80205d00:	31460613          	addi	a2,a2,788 # 80208010 <e_text+0x10>
    80205d04:	45fd                	li	a1,31
    80205d06:	00003517          	auipc	a0,0x3
    80205d0a:	1a250513          	addi	a0,a0,418 # 80208ea8 <digits+0x670>
    80205d0e:	ffffd097          	auipc	ra,0xffffd
    80205d12:	3b8080e7          	jalr	952(ra) # 802030c6 <printf>
    80205d16:	ffffd097          	auipc	ra,0xffffd
    80205d1a:	5c8080e7          	jalr	1480(ra) # 802032de <shutdown>
			panic("dirlookup read");
    80205d1e:	ffffe097          	auipc	ra,0xffffe
    80205d22:	680080e7          	jalr	1664(ra) # 8020439e <procid>
    80205d26:	84aa                	mv	s1,a0
    80205d28:	ffffe097          	auipc	ra,0xffffe
    80205d2c:	690080e7          	jalr	1680(ra) # 802043b8 <threadid>
    80205d30:	17100813          	li	a6,369
    80205d34:	00003797          	auipc	a5,0x3
    80205d38:	01478793          	addi	a5,a5,20 # 80208d48 <digits+0x510>
    80205d3c:	872a                	mv	a4,a0
    80205d3e:	86a6                	mv	a3,s1
    80205d40:	00002617          	auipc	a2,0x2
    80205d44:	2d060613          	addi	a2,a2,720 # 80208010 <e_text+0x10>
    80205d48:	45fd                	li	a1,31
    80205d4a:	00003517          	auipc	a0,0x3
    80205d4e:	18e50513          	addi	a0,a0,398 # 80208ed8 <digits+0x6a0>
    80205d52:	ffffd097          	auipc	ra,0xffffd
    80205d56:	374080e7          	jalr	884(ra) # 802030c6 <printf>
    80205d5a:	ffffd097          	auipc	ra,0xffffd
    80205d5e:	584080e7          	jalr	1412(ra) # 802032de <shutdown>
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205d62:	24c1                	addiw	s1,s1,16
    80205d64:	01492783          	lw	a5,20(s2)
    80205d68:	04f4f863          	bgeu	s1,a5,80205db8 <dirlookup+0x108>
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80205d6c:	4741                	li	a4,16
    80205d6e:	86a6                	mv	a3,s1
    80205d70:	fc040613          	addi	a2,s0,-64
    80205d74:	4581                	li	a1,0
    80205d76:	854a                	mv	a0,s2
    80205d78:	00000097          	auipc	ra,0x0
    80205d7c:	d22080e7          	jalr	-734(ra) # 80205a9a <readi>
    80205d80:	47c1                	li	a5,16
    80205d82:	f8f51ee3          	bne	a0,a5,80205d1e <dirlookup+0x6e>
		if (de.inum == 0)
    80205d86:	fc045783          	lhu	a5,-64(s0)
    80205d8a:	dfe1                	beqz	a5,80205d62 <dirlookup+0xb2>
		if (strncmp(name, de.name, DIRSIZ) == 0) {
    80205d8c:	4639                	li	a2,14
    80205d8e:	fc240593          	addi	a1,s0,-62
    80205d92:	854e                	mv	a0,s3
    80205d94:	ffffa097          	auipc	ra,0xffffa
    80205d98:	42c080e7          	jalr	1068(ra) # 802001c0 <strncmp>
    80205d9c:	f179                	bnez	a0,80205d62 <dirlookup+0xb2>
			if (poff)
    80205d9e:	000a0463          	beqz	s4,80205da6 <dirlookup+0xf6>
				*poff = off;
    80205da2:	009a2023          	sw	s1,0(s4)
			return iget(dp->dev, inum);
    80205da6:	fc045583          	lhu	a1,-64(s0)
    80205daa:	00092503          	lw	a0,0(s2)
    80205dae:	fffff097          	auipc	ra,0xfffff
    80205db2:	566080e7          	jalr	1382(ra) # 80205314 <iget>
    80205db6:	a011                	j	80205dba <dirlookup+0x10a>
	return 0;
    80205db8:	4501                	li	a0,0
}
    80205dba:	70e2                	ld	ra,56(sp)
    80205dbc:	7442                	ld	s0,48(sp)
    80205dbe:	74a2                	ld	s1,40(sp)
    80205dc0:	7902                	ld	s2,32(sp)
    80205dc2:	69e2                	ld	s3,24(sp)
    80205dc4:	6a42                	ld	s4,16(sp)
    80205dc6:	6121                	addi	sp,sp,64
    80205dc8:	8082                	ret

0000000080205dca <dirls>:

//Show the filenames of all files in the directory
int dirls(struct inode *dp)
{
    80205dca:	7139                	addi	sp,sp,-64
    80205dcc:	fc06                	sd	ra,56(sp)
    80205dce:	f822                	sd	s0,48(sp)
    80205dd0:	f426                	sd	s1,40(sp)
    80205dd2:	f04a                	sd	s2,32(sp)
    80205dd4:	ec4e                	sd	s3,24(sp)
    80205dd6:	e852                	sd	s4,16(sp)
    80205dd8:	0080                	addi	s0,sp,64
	uint64 off, count;
	struct dirent de;

	if (dp->type != T_DIR)
    80205dda:	01051703          	lh	a4,16(a0)
    80205dde:	4785                	li	a5,1
    80205de0:	02f71563          	bne	a4,a5,80205e0a <dirls+0x40>
    80205de4:	892a                	mv	s2,a0
		panic("dirlookup not DIR");

	count = 0;
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205de6:	495c                	lw	a5,20(a0)
	count = 0;
    80205de8:	4981                	li	s3,0
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205dea:	4481                	li	s1,0
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
			panic("dirlookup read");
		if (de.inum == 0)
			continue;
		printf("%s\n", de.name);
    80205dec:	00003a17          	auipc	s4,0x3
    80205df0:	11ca0a13          	addi	s4,s4,284 # 80208f08 <digits+0x6d0>
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205df4:	e7c5                	bnez	a5,80205e9c <dirls+0xd2>
		count++;
	}
	return count;
}
    80205df6:	0009851b          	sext.w	a0,s3
    80205dfa:	70e2                	ld	ra,56(sp)
    80205dfc:	7442                	ld	s0,48(sp)
    80205dfe:	74a2                	ld	s1,40(sp)
    80205e00:	7902                	ld	s2,32(sp)
    80205e02:	69e2                	ld	s3,24(sp)
    80205e04:	6a42                	ld	s4,16(sp)
    80205e06:	6121                	addi	sp,sp,64
    80205e08:	8082                	ret
		panic("dirlookup not DIR");
    80205e0a:	ffffe097          	auipc	ra,0xffffe
    80205e0e:	594080e7          	jalr	1428(ra) # 8020439e <procid>
    80205e12:	84aa                	mv	s1,a0
    80205e14:	ffffe097          	auipc	ra,0xffffe
    80205e18:	5a4080e7          	jalr	1444(ra) # 802043b8 <threadid>
    80205e1c:	18700813          	li	a6,391
    80205e20:	00003797          	auipc	a5,0x3
    80205e24:	f2878793          	addi	a5,a5,-216 # 80208d48 <digits+0x510>
    80205e28:	872a                	mv	a4,a0
    80205e2a:	86a6                	mv	a3,s1
    80205e2c:	00002617          	auipc	a2,0x2
    80205e30:	1e460613          	addi	a2,a2,484 # 80208010 <e_text+0x10>
    80205e34:	45fd                	li	a1,31
    80205e36:	00003517          	auipc	a0,0x3
    80205e3a:	07250513          	addi	a0,a0,114 # 80208ea8 <digits+0x670>
    80205e3e:	ffffd097          	auipc	ra,0xffffd
    80205e42:	288080e7          	jalr	648(ra) # 802030c6 <printf>
    80205e46:	ffffd097          	auipc	ra,0xffffd
    80205e4a:	498080e7          	jalr	1176(ra) # 802032de <shutdown>
			panic("dirlookup read");
    80205e4e:	ffffe097          	auipc	ra,0xffffe
    80205e52:	550080e7          	jalr	1360(ra) # 8020439e <procid>
    80205e56:	84aa                	mv	s1,a0
    80205e58:	ffffe097          	auipc	ra,0xffffe
    80205e5c:	560080e7          	jalr	1376(ra) # 802043b8 <threadid>
    80205e60:	18c00813          	li	a6,396
    80205e64:	00003797          	auipc	a5,0x3
    80205e68:	ee478793          	addi	a5,a5,-284 # 80208d48 <digits+0x510>
    80205e6c:	872a                	mv	a4,a0
    80205e6e:	86a6                	mv	a3,s1
    80205e70:	00002617          	auipc	a2,0x2
    80205e74:	1a060613          	addi	a2,a2,416 # 80208010 <e_text+0x10>
    80205e78:	45fd                	li	a1,31
    80205e7a:	00003517          	auipc	a0,0x3
    80205e7e:	05e50513          	addi	a0,a0,94 # 80208ed8 <digits+0x6a0>
    80205e82:	ffffd097          	auipc	ra,0xffffd
    80205e86:	244080e7          	jalr	580(ra) # 802030c6 <printf>
    80205e8a:	ffffd097          	auipc	ra,0xffffd
    80205e8e:	454080e7          	jalr	1108(ra) # 802032de <shutdown>
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205e92:	04c1                	addi	s1,s1,16
    80205e94:	01496783          	lwu	a5,20(s2)
    80205e98:	f4f4ffe3          	bgeu	s1,a5,80205df6 <dirls+0x2c>
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80205e9c:	4741                	li	a4,16
    80205e9e:	0004869b          	sext.w	a3,s1
    80205ea2:	fc040613          	addi	a2,s0,-64
    80205ea6:	4581                	li	a1,0
    80205ea8:	854a                	mv	a0,s2
    80205eaa:	00000097          	auipc	ra,0x0
    80205eae:	bf0080e7          	jalr	-1040(ra) # 80205a9a <readi>
    80205eb2:	47c1                	li	a5,16
    80205eb4:	f8f51de3          	bne	a0,a5,80205e4e <dirls+0x84>
		if (de.inum == 0)
    80205eb8:	fc045783          	lhu	a5,-64(s0)
    80205ebc:	dbf9                	beqz	a5,80205e92 <dirls+0xc8>
		printf("%s\n", de.name);
    80205ebe:	fc240593          	addi	a1,s0,-62
    80205ec2:	8552                	mv	a0,s4
    80205ec4:	ffffd097          	auipc	ra,0xffffd
    80205ec8:	202080e7          	jalr	514(ra) # 802030c6 <printf>
		count++;
    80205ecc:	0985                	addi	s3,s3,1
    80205ece:	b7d1                	j	80205e92 <dirls+0xc8>

0000000080205ed0 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int dirlink(struct inode *dp, char *name, uint inum)
{
    80205ed0:	7139                	addi	sp,sp,-64
    80205ed2:	fc06                	sd	ra,56(sp)
    80205ed4:	f822                	sd	s0,48(sp)
    80205ed6:	f426                	sd	s1,40(sp)
    80205ed8:	f04a                	sd	s2,32(sp)
    80205eda:	ec4e                	sd	s3,24(sp)
    80205edc:	e852                	sd	s4,16(sp)
    80205ede:	0080                	addi	s0,sp,64
    80205ee0:	892a                	mv	s2,a0
    80205ee2:	8a2e                	mv	s4,a1
    80205ee4:	89b2                	mv	s3,a2
	int off;
	struct dirent de;
	struct inode *ip;
	// Check that name is not present.
	if ((ip = dirlookup(dp, name, 0)) != 0) {
    80205ee6:	4601                	li	a2,0
    80205ee8:	00000097          	auipc	ra,0x0
    80205eec:	dc8080e7          	jalr	-568(ra) # 80205cb0 <dirlookup>
    80205ef0:	e93d                	bnez	a0,80205f66 <dirlink+0x96>
		iput(ip);
		return -1;
	}

	// Look for an empty dirent.
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205ef2:	01492483          	lw	s1,20(s2)
    80205ef6:	c49d                	beqz	s1,80205f24 <dirlink+0x54>
    80205ef8:	4481                	li	s1,0
		if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80205efa:	4741                	li	a4,16
    80205efc:	86a6                	mv	a3,s1
    80205efe:	fc040613          	addi	a2,s0,-64
    80205f02:	4581                	li	a1,0
    80205f04:	854a                	mv	a0,s2
    80205f06:	00000097          	auipc	ra,0x0
    80205f0a:	b94080e7          	jalr	-1132(ra) # 80205a9a <readi>
    80205f0e:	47c1                	li	a5,16
    80205f10:	06f51063          	bne	a0,a5,80205f70 <dirlink+0xa0>
			panic("dirlink read");
		if (de.inum == 0)
    80205f14:	fc045783          	lhu	a5,-64(s0)
    80205f18:	c791                	beqz	a5,80205f24 <dirlink+0x54>
	for (off = 0; off < dp->size; off += sizeof(de)) {
    80205f1a:	24c1                	addiw	s1,s1,16
    80205f1c:	01492783          	lw	a5,20(s2)
    80205f20:	fcf4ede3          	bltu	s1,a5,80205efa <dirlink+0x2a>
			break;
	}
	strncpy(de.name, name, DIRSIZ);
    80205f24:	4639                	li	a2,14
    80205f26:	85d2                	mv	a1,s4
    80205f28:	fc240513          	addi	a0,s0,-62
    80205f2c:	ffffa097          	auipc	ra,0xffffa
    80205f30:	2e4080e7          	jalr	740(ra) # 80200210 <strncpy>
	de.inum = inum;
    80205f34:	fd341023          	sh	s3,-64(s0)
	if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80205f38:	4741                	li	a4,16
    80205f3a:	86a6                	mv	a3,s1
    80205f3c:	fc040613          	addi	a2,s0,-64
    80205f40:	4581                	li	a1,0
    80205f42:	854a                	mv	a0,s2
    80205f44:	00000097          	auipc	ra,0x0
    80205f48:	c4e080e7          	jalr	-946(ra) # 80205b92 <writei>
    80205f4c:	4741                	li	a4,16
		panic("dirlink");
	return 0;
    80205f4e:	4781                	li	a5,0
	if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80205f50:	06e51263          	bne	a0,a4,80205fb4 <dirlink+0xe4>
}
    80205f54:	853e                	mv	a0,a5
    80205f56:	70e2                	ld	ra,56(sp)
    80205f58:	7442                	ld	s0,48(sp)
    80205f5a:	74a2                	ld	s1,40(sp)
    80205f5c:	7902                	ld	s2,32(sp)
    80205f5e:	69e2                	ld	s3,24(sp)
    80205f60:	6a42                	ld	s4,16(sp)
    80205f62:	6121                	addi	sp,sp,64
    80205f64:	8082                	ret
	ip->ref--;
    80205f66:	451c                	lw	a5,8(a0)
    80205f68:	37fd                	addiw	a5,a5,-1
    80205f6a:	c51c                	sw	a5,8(a0)
		return -1;
    80205f6c:	57fd                	li	a5,-1
    80205f6e:	b7dd                	j	80205f54 <dirlink+0x84>
			panic("dirlink read");
    80205f70:	ffffe097          	auipc	ra,0xffffe
    80205f74:	42e080e7          	jalr	1070(ra) # 8020439e <procid>
    80205f78:	84aa                	mv	s1,a0
    80205f7a:	ffffe097          	auipc	ra,0xffffe
    80205f7e:	43e080e7          	jalr	1086(ra) # 802043b8 <threadid>
    80205f82:	1a400813          	li	a6,420
    80205f86:	00003797          	auipc	a5,0x3
    80205f8a:	dc278793          	addi	a5,a5,-574 # 80208d48 <digits+0x510>
    80205f8e:	872a                	mv	a4,a0
    80205f90:	86a6                	mv	a3,s1
    80205f92:	00002617          	auipc	a2,0x2
    80205f96:	07e60613          	addi	a2,a2,126 # 80208010 <e_text+0x10>
    80205f9a:	45fd                	li	a1,31
    80205f9c:	00003517          	auipc	a0,0x3
    80205fa0:	f7450513          	addi	a0,a0,-140 # 80208f10 <digits+0x6d8>
    80205fa4:	ffffd097          	auipc	ra,0xffffd
    80205fa8:	122080e7          	jalr	290(ra) # 802030c6 <printf>
    80205fac:	ffffd097          	auipc	ra,0xffffd
    80205fb0:	332080e7          	jalr	818(ra) # 802032de <shutdown>
		panic("dirlink");
    80205fb4:	ffffe097          	auipc	ra,0xffffe
    80205fb8:	3ea080e7          	jalr	1002(ra) # 8020439e <procid>
    80205fbc:	84aa                	mv	s1,a0
    80205fbe:	ffffe097          	auipc	ra,0xffffe
    80205fc2:	3fa080e7          	jalr	1018(ra) # 802043b8 <threadid>
    80205fc6:	1ab00813          	li	a6,427
    80205fca:	00003797          	auipc	a5,0x3
    80205fce:	d7e78793          	addi	a5,a5,-642 # 80208d48 <digits+0x510>
    80205fd2:	872a                	mv	a4,a0
    80205fd4:	86a6                	mv	a3,s1
    80205fd6:	00002617          	auipc	a2,0x2
    80205fda:	03a60613          	addi	a2,a2,58 # 80208010 <e_text+0x10>
    80205fde:	45fd                	li	a1,31
    80205fe0:	00003517          	auipc	a0,0x3
    80205fe4:	f6050513          	addi	a0,a0,-160 # 80208f40 <digits+0x708>
    80205fe8:	ffffd097          	auipc	ra,0xffffd
    80205fec:	0de080e7          	jalr	222(ra) # 802030c6 <printf>
    80205ff0:	ffffd097          	auipc	ra,0xffffd
    80205ff4:	2ee080e7          	jalr	750(ra) # 802032de <shutdown>

0000000080205ff8 <root_dir>:

// LAB4: You may want to add dirunlink here

//Return the inode of the root directory
struct inode *root_dir()
{
    80205ff8:	1101                	addi	sp,sp,-32
    80205ffa:	ec06                	sd	ra,24(sp)
    80205ffc:	e822                	sd	s0,16(sp)
    80205ffe:	e426                	sd	s1,8(sp)
    80206000:	1000                	addi	s0,sp,32
	struct inode *r = iget(ROOTDEV, ROOTINO);
    80206002:	4585                	li	a1,1
    80206004:	4505                	li	a0,1
    80206006:	fffff097          	auipc	ra,0xfffff
    8020600a:	30e080e7          	jalr	782(ra) # 80205314 <iget>
    8020600e:	84aa                	mv	s1,a0
	ivalid(r);
    80206010:	00000097          	auipc	ra,0x0
    80206014:	90c080e7          	jalr	-1780(ra) # 8020591c <ivalid>
	return r;
}
    80206018:	8526                	mv	a0,s1
    8020601a:	60e2                	ld	ra,24(sp)
    8020601c:	6442                	ld	s0,16(sp)
    8020601e:	64a2                	ld	s1,8(sp)
    80206020:	6105                	addi	sp,sp,32
    80206022:	8082                	ret

0000000080206024 <namei>:

//Find the corresponding inode according to the path
struct inode *namei(char *path)
{
    80206024:	1101                	addi	sp,sp,-32
    80206026:	ec06                	sd	ra,24(sp)
    80206028:	e822                	sd	s0,16(sp)
    8020602a:	e426                	sd	s1,8(sp)
    8020602c:	1000                	addi	s0,sp,32
    8020602e:	84aa                	mv	s1,a0
	// if(path[0] == '.' && path[1] == '/')
	//     skip = 2;
	// if (path[0] == '/') {
	//     skip = 1;
	// }
	struct inode *dp = root_dir();
    80206030:	00000097          	auipc	ra,0x0
    80206034:	fc8080e7          	jalr	-56(ra) # 80205ff8 <root_dir>
	if (dp == 0)
    80206038:	cd01                	beqz	a0,80206050 <namei+0x2c>
		panic("fs dumped.\n");
	return dirlookup(dp, path + skip, 0);
    8020603a:	4601                	li	a2,0
    8020603c:	85a6                	mv	a1,s1
    8020603e:	00000097          	auipc	ra,0x0
    80206042:	c72080e7          	jalr	-910(ra) # 80205cb0 <dirlookup>
}
    80206046:	60e2                	ld	ra,24(sp)
    80206048:	6442                	ld	s0,16(sp)
    8020604a:	64a2                	ld	s1,8(sp)
    8020604c:	6105                	addi	sp,sp,32
    8020604e:	8082                	ret
		panic("fs dumped.\n");
    80206050:	ffffe097          	auipc	ra,0xffffe
    80206054:	34e080e7          	jalr	846(ra) # 8020439e <procid>
    80206058:	84aa                	mv	s1,a0
    8020605a:	ffffe097          	auipc	ra,0xffffe
    8020605e:	35e080e7          	jalr	862(ra) # 802043b8 <threadid>
    80206062:	1c400813          	li	a6,452
    80206066:	00003797          	auipc	a5,0x3
    8020606a:	ce278793          	addi	a5,a5,-798 # 80208d48 <digits+0x510>
    8020606e:	872a                	mv	a4,a0
    80206070:	86a6                	mv	a3,s1
    80206072:	00002617          	auipc	a2,0x2
    80206076:	f9e60613          	addi	a2,a2,-98 # 80208010 <e_text+0x10>
    8020607a:	45fd                	li	a1,31
    8020607c:	00003517          	auipc	a0,0x3
    80206080:	eec50513          	addi	a0,a0,-276 # 80208f68 <digits+0x730>
    80206084:	ffffd097          	auipc	ra,0xffffd
    80206088:	042080e7          	jalr	66(ra) # 802030c6 <printf>
    8020608c:	ffffd097          	auipc	ra,0xffffd
    80206090:	252080e7          	jalr	594(ra) # 802032de <shutdown>

0000000080206094 <INIT_PROC>:
    80206094:	7375                	lui	t1,0xffffd
    80206096:	7265                	lui	tp,0xffff9
    80206098:	6c656873          	csrrsi	a6,0x6c6,10
    8020609c:	006c                	addi	a1,sp,12
	...

00000000802060a0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        // make room to save registers.
        addi sp, sp, -256
    802060a0:	7111                	addi	sp,sp,-256
        // save the registers.
        sd ra, 0(sp)
    802060a2:	e006                	sd	ra,0(sp)
        sd sp, 8(sp)
    802060a4:	e40a                	sd	sp,8(sp)
        sd gp, 16(sp)
    802060a6:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    802060a8:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    802060aa:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    802060ac:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    802060ae:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)
    802060b0:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)
    802060b2:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    802060b4:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    802060b6:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    802060b8:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    802060ba:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    802060bc:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    802060be:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    802060c0:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    802060c2:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)
    802060c4:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)
    802060c6:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)
    802060c8:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)
    802060ca:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)
    802060cc:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)
    802060ce:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)
    802060d0:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)
    802060d2:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)
    802060d4:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)
    802060d6:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    802060d8:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    802060da:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    802060dc:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    802060de:	f9fe                	sd	t6,240(sp)

	// call the C trap handler in trap.c
        call kerneltrap
    802060e0:	d6efa0ef          	jal	ra,8020064e <kerneltrap>

00000000802060e4 <kernelret>:

kernelret:
        // restore registers.
        ld ra, 0(sp)
    802060e4:	6082                	ld	ra,0(sp)
        ld sp, 8(sp)
    802060e6:	6122                	ld	sp,8(sp)
        ld gp, 16(sp)
    802060e8:	61c2                	ld	gp,16(sp)
        // not this, in case we moved CPUs: ld tp, 24(sp)
        ld t0, 32(sp)
    802060ea:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    802060ec:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    802060ee:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)
    802060f0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)
    802060f2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    802060f4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    802060f6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    802060f8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    802060fa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    802060fc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    802060fe:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80206100:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80206102:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)
    80206104:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)
    80206106:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)
    80206108:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)
    8020610a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)
    8020610c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)
    8020610e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)
    80206110:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)
    80206112:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)
    80206114:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)
    80206116:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80206118:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    8020611a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    8020611c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8020611e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80206120:	6111                	addi	sp,sp,256

        // return to whatever we were doing in the kernel.
    80206122:	10200073          	sret
	...

000000008020612e <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    8020612e:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80206132:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80206136:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80206138:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8020613a:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8020613e:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80206142:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80206146:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8020614a:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8020614e:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80206152:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80206156:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8020615a:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8020615e:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80206162:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80206166:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8020616a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8020616c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8020616e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80206172:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80206176:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8020617a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8020617e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80206182:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80206186:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8020618a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8020618e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80206192:	0685bd83          	ld	s11,104(a1)

    80206196:	8082                	ret
	...

0000000080207000 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80207000:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80207004:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80207008:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020700c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80207010:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80207014:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80207018:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020701c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80207020:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80207022:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80207024:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80207026:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80207028:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020702a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020702c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020702e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80207032:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80207036:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020703a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020703e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80207042:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80207046:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020704a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020704e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80207052:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80207056:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020705a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020705e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80207062:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80207066:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020706a:	11f53c23          	sd	t6,280(a0)

        csrr t0, sscratch
    8020706e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80207072:	06553823          	sd	t0,112(a0)
        csrr t1, sepc
    80207076:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020707a:	00653c23          	sd	t1,24(a0)
        ld sp, 8(a0)
    8020707e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80207082:	02053203          	ld	tp,32(a0)
        ld t0, 16(a0)
    80207086:	01053283          	ld	t0,16(a0)
        ld t1, 0(a0)
    8020708a:	00053303          	ld	t1,0(a0)
        csrw satp, t1
    8020708e:	18031073          	csrw	satp,t1
        sfence.vma zero, zero
    80207092:	12000073          	sfence.vma
        jr t0
    80207096:	8282                	jr	t0

0000000080207098 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    80207098:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020709c:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802070a0:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802070a4:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802070a8:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802070ac:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802070b0:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802070b4:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802070b8:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802070bc:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802070c0:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802070c4:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802070c6:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802070c8:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802070ca:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802070cc:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802070ce:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802070d0:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802070d2:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802070d6:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802070da:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802070de:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802070e2:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802070e6:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    802070ea:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    802070ee:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    802070f2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    802070f6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    802070fa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    802070fe:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80207102:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80207106:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    8020710a:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    8020710e:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80207112:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80207116:	10200073          	sret
	...
