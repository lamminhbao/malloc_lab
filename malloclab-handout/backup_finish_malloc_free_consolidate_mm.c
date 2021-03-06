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

#define request_to_size(n)	(ALIGN(n) + 2*INTERNAL_SIZE)

#define PAGE_SIZE			(mem_pagesize())

#define MIN_SIZE			(INTERNAL_SIZE*4)

#define SMALL_RANGE			512

#define NUM_SMALL_BIN		(((SMALL_RANGE - MIN_SIZE)>>3) + 1)

#define get_prev_size(p)		(*(size_t *)(p))
#define get_size(p)				(*(size_t *)((void*)p + INTERNAL_SIZE) & ~0x7)
#define get_prev_inuse(p)		(*(size_t *)((void*)p + INTERNAL_SIZE) & 0x1)

#define set_size(p, size)				(*(size_t *)((void*)p + INTERNAL_SIZE) = (size | get_prev_inuse(p)))
#define set_prev_inuse(p, prev_inuse)	(*(size_t *)((void*)p + INTERNAL_SIZE) = (get_size(p) | prev_inuse))
#define set_prev_size(p, size)			(*(size_t *)((void*)p) = size)

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
void dump_heap();
void add_to_corespond_bin(void* p);
void remove_from_corespond_bin(void* p);
void consolidate(void** p);

/* 
 * mm_init - initialize the malloc package.
 */
int mm_init(void)
{
	print("#########################################", NULL);
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
	/* ######################################################### */
	/*debug info */
	/*
	count_action++;
		if (count_action % 100 == 0) {
			print("dump_heap---------------------------------", NULL);
			dump_heap();		
			print("dump_heap_done----------------------------", NULL);
		}
	*/
	/* ######################################################### */

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

			/* ######################################################### */
			/* this debug info for checking using smallbin */
			/* 
				print("m-----------------------------------------", NULL);
				print("vicitm", victim);
				print("\tsmallbin------------------------------", NULL);
				size_t i;
				void* head;
				void* run;
				for (i=0; i<NUM_SMALL_BIN; i++) {
					if (smallbin[i]) {
						head = smallbin[i];
						run = smallbin[i];
						do {
							print("\t\t+ ", run);
							run = get_fd(run);
						} while (run != head);
						print("\t\t\t---------o0o---------", NULL);
					}
				}
			*/
			/* ######################################################### */

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

				/* ######################################################### */
				/* This debug info for checking split large chunk */
				/*
					print("split-large-chunk----------------------", NULL);
					print("\tvictim", victim);
					print("\tnext", next);
				*/				
				/* ######################################################### */

				set_size(victim, n);
				set_size(new, new_size);

				/* new is freed chunk */
				set_prev_size(next, new_size);
				add_to_corespond_bin(new);

				/* ######################################################### */
				/* This debug info for checking split large chunk */
				/*
					print("\tvictim", victim);
					print("\tnew", new);
					print("\tnext", next);
				*/				
				/* ######################################################### */
			}

			/* mark as used */
			set_prev_inuse(chunk_at_offset(victim, get_size(victim)), 1);

			/* ######################################################### */
			/* This debug info for using largebin */
			/*
				print("m-----------------------------------------", NULL);
				print("vicitm", victim);

				print("\tlarge---------------------------------", NULL);
				size_t i;
				void* head;
				void* run;
				if (largebin) {
					head = largebin;
					run = largebin;
					do {
						print("\t\t+ ", run);
						run = get_fd(run);
					} while (run != head);
					print("\t\t\t---------o0o---------", NULL);
				}			
			*/
			/* ######################################################### */

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

	/* ######################################################### */
	/* 	This debug info for expand heap */
	/*
		print("vicitm", victim);
		print("topchunk", topchunk);
		print("m-----------------------------------------", NULL);
		dump_heap();
	*/
	/* ######################################################### */

	return chunk_to_mem(victim);
}

/*
 * mm_free - Freeing a block does nothing.
 */
void mm_free(void *ptr)
{
	/* ######################################################### */
	/*debug info */
	/*
		count_action++;
		if (count_action % 100 == 0) {
			print("dump_heap---------------------------------", NULL);
			dump_heap();		
			print("dump_heap_done----------------------------", NULL);
		}
	*/
	/* ######################################################### */

	if (ptr) {

		void* p = mem_to_chunk(ptr);
		consolidate(&p);

		/* ######################################################### */
		/* This debug info for checking consolidate */
		/*
			size_t old_size = get_size(p);
			size_t new_size = get_size(p);
		*/
		/* ######################################################### */

		if (p != topchunk) {
			size_t size = get_size(p);

			/* mark this chunk is freed */
			set_prev_inuse(chunk_at_offset(p, size), 0);
			set_prev_size(chunk_at_offset(p, size), size);

			add_to_corespond_bin(p);
		}

		/* ######################################################### */
		/* This debug info for checking consolidate */
		/*
			if (new_size != old_size) {
				print("\tchanged", p);
			}

		*/
		/* ######################################################### */

				size_t i;
				void* head;
				void* run;
				if (smallbin[8]) {
					head = smallbin[8];
					run = smallbin[8];
					do {
						print("\t\t+ ", run);
						run = get_fd(run);
					} while (run != head);
					print("\t\t\t---------o0o---------", NULL);
				}			

		/* ######################################################### */
		/* This debug info for add free chunk into smallbin. */
		/*
			print("f-----------------------------------------", NULL);
			dump_heap();
			print("f-small-----------------------------------", NULL);
			size_t i;
			void* head;
			void* run;
			for (i=0; i<NUM_SMALL_BIN; i++) {
				if (smallbin[i]) {
					head = smallbin[i];
					run = smallbin[i];
					do {
						print("\t\t+ ", run);
						run = get_fd(run);
					} while (run != head);
					print("\t\t\t---------o0o---------", NULL);
				}
			}
		*/
		/* ######################################################### */

		/* ######################################################### */
		/* This debug info for add free chunk into largebin. */
		/*
			if (size > SMALL_RANGE) {
				print("f-large-----------------------------------", NULL);
				size_t i;
				void* head;
				void* run;
				if (largebin) {
					head = largebin;
					run = largebin;
					do {
						print("\t\t+ ", run);
						run = get_fd(run);
					} while (run != head);
					print("\t\t\t---------o0o---------", NULL);
				}			
			}
		*/
		/* ######################################################### */
		}
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

	/* ######################################################### */
	/* This debug info for add free chunk into largebin. */
	/*
		print("consolidate----------------------", NULL);
		print("\tthis", this);
	*/
	/* ######################################################### */

	if (next == topchunk) {
	/*	print("\ttopchunk", next);		*/
		set_size(this, get_size(this) + get_size(next));		
	/*	print("\tthis", *p);			*/
	}
	else if (!get_prev_inuse(chunk_at_offset(next, get_size(next)))) {
	/*	print("\tnext", next);			*/
		set_size(this, get_size(this) + get_size(next));		
		remove_from_corespond_bin(next);
	/*	print("\tthis", *p);			*/
	}

	/* consolidate previous */
	if (!get_prev_inuse(this)) {
		prev = chunk_at_offset(this, -get_prev_size(this));
	/*	print("\tprev", prev);			*/
		remove_from_corespond_bin(prev);
		set_size(prev, get_size(prev) + get_size(this));
		*p = prev;
	/*	print("\tthis", *p);			*/
	}

	if (next == topchunk) {
		topchunk = *p;		
	}
}