/*
 * mm-naive.c - The fastest, least memory-efficient malloc package.
 * 
 * In this naive approach, a block is allocated by simply incrementing
 * the brk pointer.  A block is pure payload. There are no headers or
 * footers.  Blocks are never coalesced or reused. Realloc is
 * implemented directly using mm_malloc and mm_free.
 *
 * NOTE TO STUDENTS: Replace this header comment with your own header
 * comment that gives a high level description of your solution.
 */
/*
 *	CHUNK STRUCT
 *
 * 			chunk ->	+---------------------------+
 * 						|prev_size (when prev freed)|
 * 						+---------------------------+
 * 						|		size			| P |
 * 		user data ->	+---------------------------+
 * 						|	fd (when this freed)	|
 * 						+---------------------------+
 * 						|	bk (when this freed)	|
 * 						+---------------------------+
 * 						|							|
 *						.							.
 *						.							.
 *						.							.
 * 						|							|
 * 		end chunk ->	+---------------------------+
 *
 *	SMALLBIN
 *		
 *		smallbin[0]
 *			|
 *			v
 *		+-----------+		+-----------+
 *		| size = 16	| <=> 	| size = 16 |
 *		+-----------+		+-----------+
 *			
 *		smallbin[1]
 *			|
 *			v
 *		+-----------+		+-----------+		+-----------+
 *		| size = 24	| <=> 	| size = 24 | <=> 	| size = 24 |
 *		+-----------+		+-----------+		+-----------+
 *			
 *	LARGEBIN
 *		largebin 																
 *			|
 *			v
 *		+----------------+		+----------------+		+----------------+
 *		| size = 640	 | <=>	|	size = 1024	 | <=>	|	size = 728   |
 *		+----------------+		+----------------+		+----------------+
 *			
 *	ADD FREE CHUNK TO LARGEBIN		
 *		largebin 																
 *			|
 *			v
 *		+------------------+		+----------------+		+----------------+		+----------------+
 *		| new, size = 1664 | <=> 	| size = 640	 | <=>	|	size = 1024	 | <=>	|	size = 728   |
 *		+------------------+		+----------------+		+----------------+		+----------------+
 *			
 *			
 *	TOPCHUNK
 *			
 *		when init
 *
 *		first byte of heap 
 *			|
 *			v		
 *			+----------------------------------------------------------
 *			|	topchunk
 *			+----------------------------------------------------------
 *
 *
 *	CONSOLIDATE
 *
 *			+-------------------+-------------------------+-----------------+
 *			|	prev is freed	|	we handle this chunk  |	next is freed	|
 *			|	size = 128		|			size = 1024	  |		size = 512	|
 *			+-------------------+-------------------------+-----------------+
 *										|
 *									become this
 *										|
 *										V
 *			+---------------------------------------------------------------+
 *			|				one big chunk, size = 1664						|
 *			+---------------------------------------------------------------+
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>

#include "mm.h"
#include "memlib.h"

/*********************************************************
 * NOTE TO STUDENTS: Before you do anything else, please
 * provide your team information in the following struct.
 ********************************************************/
team_t team = {
    /* Team name */
    "Bolin",
    /* First member's full name */
    "Lam Minh Bao",
    /* First member's email address */
    "14520052@gm.uit.edu.vn",
    /* Second member's full name (leave blank if none) */
    "Phan Gia Linh",
    /* Second member's email address (leave blank if none) */
    "14520470@gm.uit.edu.vn"
};

/* single word (4) or double word (8) alignment */
#define ALIGNMENT 8

/* rounds up to the nearest multiple of ALIGNMENT */
#define ALIGN(size) (((size) + (ALIGNMENT-1)) & ~0x7)

/* My macro */
#define INTERNAL_SIZE 		(sizeof(size_t))

#define request_to_size(n)	(ALIGN(n) + 2*INTERNAL_SIZE)

#define PAGE_SIZE			(mem_pagesize())

#define MIN_SIZE			(INTERNAL_SIZE*4)

#define SMALL_RANGE			512

#define NUM_SMALL_BIN		(((SMALL_RANGE - MIN_SIZE)>>3) + 1)

#define get_prev_size(p)		(*(size_t *)(p))
#define get_size(p)				(*(size_t *)((void*)p + INTERNAL_SIZE) & ~0x7)
#define get_prev_inuse(p)		(*(size_t *)((void*)p + INTERNAL_SIZE) & 0x1)

#define set_size(p, size)				\
		(*(size_t *)((void*)p + INTERNAL_SIZE) = (size | get_prev_inuse(p)))
#define set_prev_inuse(p, prev_inuse)	\
		(*(size_t *)((void*)p + INTERNAL_SIZE) = (get_size(p) | prev_inuse))
#define set_prev_size(p, size)			\
		(*(size_t *)((void*)p) = size)

#define set_head(p, size, prev_inuse)	{	\
	set_size(p, size);						\
	set_prev_inuse(p, prev_inuse);			\
}

#define chunk_at_offset(p, offset)		((void*)p + offset)

#define chunk_to_mem(p)					((void*)p + 2*INTERNAL_SIZE)

#define mem_to_chunk(p)					((void*)p - 2*INTERNAL_SIZE)

#define small_index(size)				((size-MIN_SIZE)>>3)

#define set_fd(p, fd)			(*(void **)((void*)p + 2*INTERNAL_SIZE) = fd)
#define get_fd(p)				(*(void **)((void*)p + 2*INTERNAL_SIZE))

#define set_bk(p, bk)			(*(void **)((void*)p + 3*INTERNAL_SIZE) = bk)
#define get_bk(p)				(*(void **)((void*)p + 3*INTERNAL_SIZE))

#define unlink(p, fd, bk)	{	\
	fd = get_fd(p);				\
	bk = get_bk(p);				\
	set_bk(fd, bk);				\
	set_fd(bk, fd);				\
}


/* Global variable */
size_t count_init = 0;
size_t count_action;
size_t my_verbose;
void* topchunk;
void* smallbin[NUM_SMALL_BIN];
void* largebin;

/* my define function */

void extend_heap();
void print(char* desc, void* p);
void print2(char* desc, void* p);
void dump_heap();
void add_to_corespond_bin(void* p);
void remove_from_corespond_bin(void* p);
void consolidate(void** p);
void consolidate_prev_and_copydata(void** p);

/* 
 * mm_init - initialize the malloc package.
 */
int mm_init(void)
{
	size_t i;

	/* set debug info */
	if (count_init == 0)
		my_verbose = 0;
	else
		my_verbose = 0;

	/* init global value */
	count_action = 0;
	topchunk = NULL;
	count_init++;

	for (i=0; i < NUM_SMALL_BIN; i++)
		smallbin[i] = NULL;

	largebin = NULL;

	/* init topchunk by extending heap*/
	extend_heap();

    return 0;
}

/* 
 * mm_malloc - Allocate a block by incrementing the brk pointer.
 *     Always allocate a block whose size is a multiple of the alignment.
 */
void *mm_malloc(size_t size)
{
	void* victim;		/* chunk use to return to user */
	size_t n = request_to_size(size);
	void* bck;			/* temp variable */
	void* fwd;
	void** bin = NULL;

	/* if in small range */
	if (MIN_SIZE <= n && n <= SMALL_RANGE) {

		bin = &smallbin[small_index(n)];

		/* if have chunk */
		if (*bin) {

			victim = *bin;
			remove_from_corespond_bin(victim);
			/* mark as used */
			set_prev_inuse(chunk_at_offset(victim, get_size(victim)), 1);

			return chunk_to_mem(victim);
		}
	}

	/* find in largebin */
	else {
		bin = &largebin;
		size_t founded = 0;

		/* find first fit */
		if (*bin) {
			victim = *bin;

			do {
				if (get_size(victim) >= n){
					founded = 1;
					break;
				}
				victim = get_fd(victim);
			} while (victim != *bin);
		}
		if (founded) {

			remove_from_corespond_bin(victim);

			if (get_size(victim) >= MIN_SIZE + n) {
				/* split and add to corespond bin. */
				/*
					+-----------------+--------------+
					| victim    | new |	  next	     |
					+-----------------+--------------+
				*/

				void* new = chunk_at_offset(victim, n);
				size_t new_size = get_size(victim) - n;
				void* next = chunk_at_offset(victim, get_size(victim));

				set_size(victim, n);
				set_size(new, new_size);

				/* new is freed chunk */
				set_prev_size(next, new_size);
				add_to_corespond_bin(new);
			}

			/* mark as used */
			set_prev_inuse(chunk_at_offset(victim, get_size(victim)), 1);
			return chunk_to_mem(victim);
		}
	}

	/* use topchunk */
	while (get_size(topchunk) < (n + MIN_SIZE))
		extend_heap();

	/* split topchunk */
	victim = topchunk;
	topchunk = chunk_at_offset(topchunk, n);
	set_head(topchunk, get_size(victim) - n, 1);
	set_head(victim, n, get_prev_inuse(victim));

	return chunk_to_mem(victim);
}

/*
 * mm_free - Freeing a block does nothing.
 */
void mm_free(void *ptr)
{
	if (ptr) {

		void* p = mem_to_chunk(ptr);
		consolidate(&p);

		if (p != topchunk) {
			size_t size = get_size(p);

			/* mark this chunk is freed */
			set_prev_inuse(chunk_at_offset(p, size), 0);
			set_prev_size(chunk_at_offset(p, size), size);

			add_to_corespond_bin(p);
		}
	}
}

/*
 * mm_realloc - Implemented simply in terms of mm_malloc and mm_free
 */
void *mm_realloc(void *ptr, size_t size)
{
	/* we just free and malloc a new chunk, then copy to it. 
		cause data just change a little bit
	*/

	void* p = mem_to_chunk(ptr);
	size_t old_size = get_size(p);
	char old_data[2*INTERNAL_SIZE];
	size_t copysize = 0;
	void* result = NULL;
	void* buf;

	memcpy(old_data, ptr, 2*INTERNAL_SIZE);

	consolidate_prev_and_copydata(&p);
	mm_free(chunk_to_mem(p));
	result = mm_malloc(size);

	memcpy(result, old_data, 2*INTERNAL_SIZE);

	copysize = old_size - 2*INTERNAL_SIZE;

	if (size < copysize)
		copysize = size;
	copysize -= 2*INTERNAL_SIZE;

	if (result != chunk_to_mem(p)) {
		memcpy(result + 2*INTERNAL_SIZE, chunk_to_mem(p) + 2*INTERNAL_SIZE, copysize);
	}

	return result;
}

void extend_heap() {
	if (!topchunk) {
		topchunk = mem_sbrk(PAGE_SIZE);
		/* prev_size = 0 */
		set_prev_size(topchunk, 0);
		set_head(topchunk, PAGE_SIZE, 1);
	}
	else {
		mem_sbrk(PAGE_SIZE);
		set_head(topchunk, get_size(topchunk) + PAGE_SIZE, 1);
	}
}

void print(char* desc, void* p) {
	if (my_verbose) {
		printf("%s - %p: ", desc, p);
		if (p) {
			printf("\tprev_size: %8d - size: %8d - prev_inuse: %1d - fd: %p - bk: %p", \
				get_prev_size(p), get_size(p), get_prev_inuse(p), get_fd(p), get_bk(p));
		}
		printf("\n");
	}
}

void print2(char* desc, void* p) {
	if (my_verbose) {
		printf("%s - %p: ", desc, p);
		if (p) {
			size_t size = get_size(p);
			size_t i;
			for (i=0; i<size; i+=4) {
				if (*(size_t*)(p + i)) {
					printf("%d: %p\t", i, *(size_t*)(p + i));
				}
			}
		}
		printf("\n");
	}
}

void dump_heap() {
	void* run = mem_heap_lo();
	do {
		print("\t", run);
		run = chunk_at_offset(run, get_size(run));
	} while (run <= topchunk);
	print("\ttopchunk", topchunk);
}

void add_to_corespond_bin(void* p) {
	void** bin = NULL;
	size_t size = get_size(p);
	/* temp variable */
	void* bck;
	void* fwd;


	/* if in small range add to smallbin */
	if (MIN_SIZE <= size && size <= SMALL_RANGE)
		/* bin is head of double linking-list */
		bin = &smallbin[small_index(size)];

	/* if in large range add to largebin */
	else 
		bin = &largebin;


	/* add to corespond bin */
	if (!*bin) {
		/* bin is empty */
		set_fd(p, p);
		set_bk(p, p);
		*bin = p;
	}
	else {
		/* bin is not empty */
		bck = get_bk(*bin);
		
		/* insert into list */
		set_fd(p, *bin);
		set_bk(*bin, p);
		set_fd(bck, p);
		set_bk(p, bck);
		*bin = p;
	}
}

void remove_from_corespond_bin(void* p) {

	void** bin = NULL;
	size_t n = get_size(p);
	void* fwd, *bck;

	/* if in small range */
	if (MIN_SIZE <= n && n <= SMALL_RANGE) {

		bin = &smallbin[small_index(n)];
	}
	else {
		bin = &largebin;
	}

	/* remove from bin */
	/* if victim is head of bin */
	if (p == *bin)
		/* bin just have one chunk */
		if (get_fd(*bin) == *bin) {
			*bin = NULL;
		}
		/* have more than one chunk */
		else {
			*bin = get_fd(*bin);
			unlink(p, fwd, bck);
		}
	/* victim is not head of bin */
	else
		unlink(p, fwd, bck);

	set_bk(p, NULL);
	set_fd(p, NULL);
}


void consolidate(void** p) {

	void* this = *p;
	void* prev = NULL;
	void* next = chunk_at_offset(this, get_size(this));

	/*
		+-----------------+-----------------+---------------------+
		|       prev      |       this      |	    next		  |
		+-----------------+-----------------+---------------------+

	*/
	/* consolidate next */
	if (next == topchunk) {
		set_size(this, get_size(this) + get_size(next));		
	}
	else if (!get_prev_inuse(chunk_at_offset(next, get_size(next)))) {
		set_size(this, get_size(this) + get_size(next));		
		remove_from_corespond_bin(next);
	}

	/* consolidate previous */
	if (!get_prev_inuse(this)) {
		prev = chunk_at_offset(this, -get_prev_size(this));
		remove_from_corespond_bin(prev);
		set_size(prev, get_size(prev) + get_size(this));
		*p = prev;
	}

	if (next == topchunk) {
		topchunk = *p;		
	}
}

void consolidate_prev_and_copydata(void** p) {
	void* this = *p;
	void* prev = NULL;
	void* next = chunk_at_offset(this, get_size(this));

	/*
		+-----------------+-----------------+---------------------+
		|       prev      |       this      |	    next		  |
		+-----------------+-----------------+---------------------+

	*/
	/* consolidate previous */
	if (!get_prev_inuse(this)) {
		prev = chunk_at_offset(this, -get_prev_size(this));
		remove_from_corespond_bin(prev);
		set_size(prev, get_size(prev) + get_size(this));

		/* copy data */
		memcpy(prev+2*INTERNAL_SIZE, this+2*INTERNAL_SIZE, get_size(this) - 2*INTERNAL_SIZE);

		*p = prev;
	}
}
