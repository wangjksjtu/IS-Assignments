#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX 100

struct map {	
	unsigned m_size;
	char* m_addr;
	struct map *next, *prior;
};

struct process {
	unsigned id;
	char* m_addr;
	unsigned m_size;
};

struct map *coremap;
struct map *pointer;
struct process p_manager[MAX];
int count_process = 0;
int current_id = 0; 

void print_choice(void) {
	printf("1:First Fit(FF); 2:Next Fit(NF); \
3:Best Fit(BF); 4:Worst Fit(WF); Others:Quit\n");
}

void print_line(int count, char c) {
	char line[MAX]; 
	for (int i = 0; i < count; ++i) {
		line[i] = c;
	}
	line[count] = '\0';
	printf("%s\n", line);
}

void print_map(struct map* coremap) {
	struct map *ptr = coremap;
	printf ("Free memory\n");
	print_line(28, '-');
	int cnt = 0;
	do {
		printf("%d\t%p\t%d\n", cnt, ptr->m_addr, ptr->m_size);
		ptr = ptr->next;
		++cnt;
	} while (ptr != coremap);
	print_line(28, '-');
};

void print_process(struct process* p_manager) {
	printf ("Process\n");
	print_line(28, '-');
	for (int i = 0; i < count_process; i++) {
		struct process proc = p_manager[i];
		printf("%d\t%p\t%d\n", proc.id, proc.m_addr, proc.m_size);
	}
	print_line(28, '-');
}

bool lmalloc(size_t size, struct map **pointer, int choice) {
	bool flag = false;
	struct map *ptr = *pointer;
	do {
		if ((*pointer)->m_size >= size) {
			struct process* new_proc = malloc(sizeof(struct process));
			new_proc->m_size = size;
			new_proc->m_addr = ptr->m_addr;
			new_proc->id = current_id;
			p_manager[count_process] = *new_proc;
			current_id++;
			count_process++;
			flag = true;
			(*pointer)->m_size -= size;
			(*pointer)->m_addr = (char*) ((unsigned)(*pointer)->m_addr + size);
			break;
		}
		else (*pointer) = (*pointer)->next;
	} while ((*pointer) != ptr);
	return flag;
}

struct process* search_process(int id) {
	for (int i = 0; i < count_process; i++) {
		if (p_manager[i].id == id)
			return &(p_manager[i]); 
	}
}

int get_index(int id) {
	for (int i = 0; i < count_process; i++) {
		if (p_manager[i].id == id)
			return i; 
	}
	return -1;
}

bool lfree(int id, struct map **coremap, int choice) {
	struct process *free_proc;
	if (id > current_id || get_index(id) == -1) return false;
	else free_proc = search_process(id);

    // printf ("%d\n", free_proc->m_size);
	struct map *ptr = *coremap;

	struct map *upper = NULL;
	struct map *lower = NULL;
	unsigned addr_proc = free_proc->m_addr;
	
	
	do {
		unsigned addr_ptr =  ptr->m_addr;
		if (addr_ptr < addr_proc) lower = ptr;
		if (addr_ptr > addr_proc && upper == NULL) upper = ptr;
		ptr = ptr->next;
	} while (ptr != *coremap);
	
	// if (upper) printf("%d\n", upper->m_size);
	// if (lower) printf("%d\n", lower->m_size);

	if (upper == NULL || lower == NULL) {
		if (upper == NULL) {
			printf ("upper is empty\n");
			if ((unsigned) lower->m_addr + lower->m_size == addr_proc) {
				lower->m_size += free_proc->m_size;
                printf("here!");
			}
			else {
				struct map* newmap = malloc(sizeof(struct map));
				lower->next = newmap;
                if (lower->prior == lower) {printf("lower->prior==lower"); lower->prior == newmap;}
				newmap->prior = lower;
                // if (lower->next == lower) {printf("lower->next==lower");}
				newmap->next = lower->next;
				newmap->m_addr = addr_proc;
				newmap->m_size = free_proc->m_size;
                printf("here2!");
				printf ("%d\t%d\t%p\n", (lower)->m_size, (lower)->next->m_size, (lower)->m_addr);
				printf ("%p\t%p\n", (lower)->next->m_addr, (lower)->next->next->m_addr);
			}

		}
		else {
			printf ("lower is empty\n");
			if ((unsigned) upper->m_addr - free_proc->m_size == addr_proc) {
				upper->m_size += free_proc->m_size;
				upper->m_addr = (char*) ((unsigned)upper->m_addr - free_proc->m_size);
			}
			else {
				printf ("new map\n");
				struct map* newmap = malloc(sizeof(struct map));
				upper->prior = newmap;
				if (upper->next == upper) upper->next = newmap;
				newmap->next = upper;
				newmap->prior = upper->prior;
				newmap->m_addr = addr_proc;
				newmap->m_size = free_proc->m_size;
				*coremap = newmap;
				// printf ("%d\t%d\t%p\n", (*coremap)->m_size, (*coremap)->next->m_size, (*coremap)->m_addr);
				// printf ("%p\t%p\n", (*coremap)->next->m_addr, (*coremap)->next->next->m_addr);
			}
		}
	}
	else {
		printf ("both upper and lower are not empty\n");
		printf ("%p\t%p\t%p\t\n", lower->m_addr, addr_proc, upper->m_addr);
		if ((unsigned) lower->m_addr + lower->m_size == addr_proc) {
			if (addr_proc + free_proc->m_size == (unsigned) upper->m_addr) {
				printf ("merge!");
				lower->m_size += free_proc->m_size + upper->m_size;
				lower->next = upper->next;
				if (lower->prior == upper) lower->prior = lower;
				free(upper);
			}
			else lower->m_size += free_proc->m_size;
		}
		else {
			if ((unsigned)upper->m_addr - free_proc->m_size == addr_proc) {
				upper->m_size += free_proc->m_size;
				upper->m_addr = (char*) upper->m_addr - free_proc->m_size;
			}
			else {
				struct map* newmap = malloc(sizeof(struct map));
				newmap->m_addr = addr_proc;
				newmap->m_size = free_proc->m_size;
				newmap->next = upper;
				newmap->prior = lower;
				lower->next = newmap;
				upper->prior = newmap;
			}

		}
		// exit(0);
	}
	int free_id = get_index(id);
	for (int i = free_id; i < count_process - 1; i++) {
		p_manager[i] = p_manager[i+1];
	}
	count_process -= 1;
	return true;
}

void malloc_or_free(struct map **coremap, struct map **pointer) {
	printf("1->malloc(FF); 2->free\n");
	int choice, size, id;
	if (scanf("%d", &choice)) {
		if (choice == 1) {
			printf ("malloc memory size: ");
			scanf("%d", &size);
			if (!lmalloc(size, pointer, choice))
				printf ("No enough memory!\n");
		}
		else {
			printf ("free process id: ");
			scanf("%d", &id);
			if (!lfree(id, coremap, choice)) {
				printf ("The process is not existant!\n");
			}
		}
	}
	print_map(*coremap);
	// printf("%p\n", (*coremap)->m_addr);
	print_process(p_manager);
}

void control_switch(int choice, struct map **coremap, struct map **pointer) {
	while (true) {
		switch(choice) {
			case 1:
				printf("First Fit\n");
				// first_fit(sizeof(int), coremap);
				break;
			case 2:
				// printf("Next Fit\n");
				print_map(*coremap);
				malloc_or_free(coremap, pointer);
				// printf("%p\n", (*coremap)->m_addr);
				printf("\n");
				// print_choice();
				break;
			case 3:
				printf("Best Fit\n");
				break;
			case 4:
				printf("Worst Fit\n");
				break;
			default:
				printf("Byebye~\n");
				exit(0);
		}
		scanf("%d", &choice);
	}
}

void initialize(struct map **coremap_out) {
	// static struct map* coremap;
	coremap = malloc(sizeof(struct map));
	coremap->m_size = 1000;
	coremap->m_addr = (char*) malloc(sizeof(int) * 1000);
	coremap->prior = coremap;
	coremap->next = coremap;
	*coremap_out = coremap;
	pointer = coremap;
	// printf("%p\n", &coremap);
	printf("Hello, nice to meet you!\n");
	printf("malloc 1000: %p\n", coremap->m_addr);
}

void test(int* p) {
	printf("%p\n", &p);

}

int main() {
	printf("%p\n", &coremap);
	initialize(&coremap);
	print_choice();
	int choice;
	scanf("%d", &choice);
	control_switch(choice, &coremap, &pointer);
	return 0;
}
