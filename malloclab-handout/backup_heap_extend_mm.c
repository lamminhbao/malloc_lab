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

#define MIN_SIZE			(INTERNAL_SIZE*4)

#define request_to_size(n)	(ALIGN(n) + 2*INTERNAL_SIZE)

#define PAGE_SIZE	(mem_pagesize())


#define get_prev_size(p)		(*(size_t *)(p))
#define get_size(p)				(*(size_t *)((void*)p + INTERNAL_SIZE) & ~0x7)
#define get_prev_inuse(p)		(*(size_t *)((void*)p + INTERNAL_SIZE) & 0x1)

#define set_size(p, size)				(*(size_t *)((void*)p + INTERNAL_SIZE) = (size | get_prev_inuse(p)))
#define set_prev_inuse(p, prev_inuse)	(*(size_t *)((void*)p + INTERNAL_SIZE) = (get_size(p) | prev_inuse))


#define set_head(p, size, prev_inuse)	{	\
	set_size(p, size);						\
	set_prev_inuse(p, prev_inuse);			\
}

#define chunk_at_offset(p, offset)		((void*)p + offset)

#define chunk_to_mem(p)					((void*)p + 2*INTERNAL_SIZE)



/* Global variable */
size_t my_verbose;
void* topchunk;

void extend_heap();
void print(char* desc, void* p);

/* 
 * mm_init - initialize the malloc package.
 */
int mm_init(void)
{
	my_verbose = 1;
	topchunk = NULL;
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





	/* use topchunk */
	while (get_size(topchunk) < (n + MIN_SIZE))
		extend_heap();

	/* split topchunk */
	victim = topchunk;
	topchunk = chunk_at_offset(topchunk, n);
	set_head(topchunk, get_size(victim) - n, 1);
	set_head(victim, n, get_prev_inuse(victim));

	print("vicitm", victim);
	print("topchunk", topchunk);
	print("-----------------------------------------", NULL);

	return chunk_to_mem(victim);
}

/*
 * mm_free - Freeing a block does nothing.
 */
void mm_free(void *ptr)
{
}

/*
 * mm_realloc - Implemented simply in terms of mm_malloc and mm_free
 */
void *mm_realloc(void *ptr, size_t size)
{
/*    void *oldptr = ptr;
    void *newptr;
    size_t copySize;
    
    newptr = mm_malloc(size);
    if (newptr == NULL)
      return NULL;
    copySize = *(size_t *)((char *)oldptr - SIZE_T_SIZE);
    if (size < copySize)
      copySize = size;
    memcpy(newptr, oldptr, copySize);
    mm_free(oldptr);
    return newptr;
*/
}

void extend_heap() {
	if (!topchunk) {
		topchunk = mem_sbrk(PAGE_SIZE);
		/* prev_size = 0 */
		*(size_t *)topchunk = 0;
		set_head(topchunk, PAGE_SIZE, 1);
	}
	else {
		mem_sbrk(PAGE_SIZE);
		set_head(topchunk, get_size(topchunk) + PAGE_SIZE, 1);
	}
	print("extend topchunk", topchunk);
}

void print(char* desc, void* p) {
	if (my_verbose) {
		printf("%p - %s\n", p, desc);
		if (p) {

			printf("\tprev_size: %8d - size: %8d - prev_inuse: %1d\n", \
				get_prev_size(p), get_size(p), get_prev_inuse(p));
		}
	}
}











