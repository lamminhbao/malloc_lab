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
    "BoLin",
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

#define chunk_size(size)   (size & ~0x7)

#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))

#define chunk_at_offset(p, offset)  ((chunkptr)((char *)p + offset))

#define chunk_to_mem(p)             ((char*)p + 2*sizeof(size_t))
#define mem_to_chunk(p)             ((chunkptr)((char*)p - 2*sizeof(size_t)))


#define remove_1stfrom_list(list, tmp){ \
    tmp = list; \
    list = list->next;  \
    tmp->next = NULL;    \
}

#define add_to_list(list, tmp){ \
    tmp->next = list;   \
    list = tmp; \
}

#define prev_inuse(p)       (p->size & 1)

#define inuse(p)            ((p->size & 2) >> 1)

#define SMALLMAX    512

struct chunk {
    size_t prev_size;
    size_t size;
    struct chunk *next;
};
typedef struct chunk* chunkptr;

chunkptr smalllist[((SMALLMAX-16)>>3)+1];
chunkptr largelist;
chunkptr top;

int expandtop();
chunkptr remainderfrom(chunkptr p, size_t size, char pinuse);
chunkptr find_bestbit(chunkptr list, size_t size, chunkptr *follow);
void consolidate();
void print(char* s, chunkptr p);
/* 
 * mm_init - initialize the malloc package.
 */
int mm_init(void)
{
    top = mem_sbrk(0x1000);
    top->size = 0x1000;
    top->size |= 1; /* prev inuse */
    top->size |= 2; /* this inuse */
    return 0;
}

/* 
 * mm_malloc - Allocate a block by incrementing the brk pointer.
 *     Always allocate a block whose size is a multiple of the alignment.
 */
void *mm_malloc(size_t size)
{
    int requestsize = ALIGN(size + SIZE_T_SIZE) + 2*sizeof(size_t);
    chunkptr victim;    /* chunk be used */
    chunkptr p;         /* pointer be used to return */

    if (requestsize <= SMALLMAX)
    {
        printf("size <= 512\n");
        size_t idx = (requestsize - 16)>>3;
        printf("small list %p ", smalllist[idx]);
        if (&smalllist[idx] == &largelist)
            printf("fuck!\n");
        if (smalllist[idx])
        {
            remove_1stfrom_list(smalllist[idx], p);
            p->size |= 2;
            chunkptr nextchunk = chunk_at_offset(p, chunk_size(p->size));
            nextchunk->prev_size = 0;
            print("after remove 1st smalllist", smalllist[idx]);
            print("malloc small",p);
            return chunk_to_mem(p);
        }
    }
    else if (largelist)
    {
        chunkptr prev;
        chunkptr remainder;
        p = find_bestbit(largelist, requestsize, &prev);
        print("prev",prev);
        print("bestfit", p);

        if (p)
        {
            /* remove p from list */
            if (prev)
            {
                prev->next = p->next;
                print("prev after remove",prev);
            }
            else
            {
                remove_1stfrom_list(largelist, prev);
                print("after remove 1st large", largelist);
            }
            
            /* process remainder chunk */
            remainder = remainderfrom(p, requestsize, 1);
            print("remainder",remainder);
            if (remainder)
            {
                if (chunk_size(remainder->size) <= SMALLMAX)
                {
                    size_t idx = (chunk_size(remainder->size) - 16)>>3;
                    if (&smalllist[idx] == &largelist)
                        printf("fuck!\n");
                    p->size &= ~2;
                    add_to_list(smalllist[idx], remainder);
                    print("add remainder to smalllist", remainder);
                    print("smalllist", smalllist[idx]);
                }
                else
                {
                    p->size &= ~2;
                    add_to_list(largelist, remainder);                
                    print("add remainder to largelist", remainder);
                    print("largelist", largelist);
                }
            }

            p->size |= 2;
            chunkptr nextchunk = chunk_at_offset(p, chunk_size(p->size));
            nextchunk->prev_size = 0;
            nextchunk->size |= 1;
            print("malloc large",p);
            return chunk_to_mem(p);
        }
    }

    /* use topchunk */
    victim = top;

    /* expand topchunk */
    while (chunk_size(victim->size) < (requestsize + 16))
        if (expandtop() == -1)
            return NULL;

    p = victim;
    top = remainderfrom(p,requestsize,1);
    p->size |= 2;
    chunkptr nextchunk = chunk_at_offset(p, chunk_size(p->size));
    nextchunk->prev_size = 0;
    nextchunk->size |= 1;
    print("malloc top",p);
    return chunk_to_mem(p);
}

/*
 * mm_free - Freeing a block does nothing.
 */
void mm_free(void *ptr)
{
    chunkptr p = mem_to_chunk(ptr);
    size_t psize = chunk_size(p->size);

    if (!inuse(p))
    {
        printf("double free %p!\n", p);
        return;
    }
    if (psize <= SMALLMAX)
    {
        size_t idx = (psize-16)>>3;
        if (&smalllist[idx] == &largelist)
            printf("fuck!\n");
        printf("idx %d ", idx);
        print("smalllist", smalllist[idx]);
        add_to_list(smalllist[idx], p);
        p->size &= ~2;
        print("add to smalllist", p);
    }
    else
    {
        print("largelist", largelist);
        add_to_list(largelist, p);
        p->size &= ~2;
        chunkptr nextchunk = chunk_at_offset(p,chunk_size(p->size));
        nextchunk->prev_size = chunk_size(p->size);
        nextchunk->size &= ~1;
        print("add to largelist", p);
    }
}

/*
 * mm_realloc - Implemented simply in terms of mm_malloc and mm_free
 */
void *mm_realloc(void *ptr, size_t size)
{
    void *oldptr = ptr;
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
}

int expandtop()
{
    void* tmp;
    if ((tmp = mem_sbrk(0x1000)) == (void *)-1)
        return -1;

    top->size += 0x1000;
    return 0;
}

chunkptr remainderfrom(chunkptr p, size_t size, char pinuse)
{
    size_t psize = chunk_size(p->size);
    if ((psize - size) >= 16)
    {
        chunkptr tmp = chunk_at_offset(p,chunk_size(size));

        tmp->size = (psize - size) | pinuse;
        p->size = (p->size & 0x7) + size;
        if (pinuse)
            tmp->prev_size = 0;
        else
            tmp->prev_size = chunk_size(p->size);

        return tmp;        
    }
    else
        return NULL;
}

chunkptr find_bestbit(chunkptr list, size_t size, chunkptr* follow)
{
    printf("in find %d\n", size);
    chunkptr i = list;
    chunkptr head = list;
    chunkptr result = NULL;
    chunkptr tmp = NULL;
    while(i)
    {
        print("check in find_bestbit ", i);
        if (chunk_size(i->size) >= size)
        {
            *follow = tmp;
            result = i;
            tmp = i;
            i = i->next;
            break;
        }
        tmp = i;
        if (i->next == head)
            i->next = NULL;
        i = i->next;
    }
    
/*    while (i)
    {
//        print("check in find_bestbit", i);
        if (chunk_size(i->size) >= size && chunk_size(i->size) < chunk_size(result->size))
        {
            *follow = tmp;
            result = i;
        }
        tmp = i;
        i = i->next;
    }
*/
    return result;
}

void consolidate()
{

}

void print(char* s, chunkptr p)
{
    if (p)
    {
        if (p != p->next)
            printf("%s %p: %d %d %d %d %p\n", s, p, p->prev_size, chunk_size(p->size), inuse(p), prev_inuse(p), p->next);
        else
            printf("fuck %s %p: %d %d %d %d %p\n", s, p, p->prev_size, chunk_size(p->size), inuse(p), prev_inuse(p), p->next);
    }
    else
    {
        printf("%s NULL\n", s);
    }
}





