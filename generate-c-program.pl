use common::sense;

use Algorithm::Networksort qw(:all);
use File::Slurp;
use Data::Dumper;
use Template;

my $height = 256;


my $network_size = 32;
my @network = nw_comparators($network_size, algorithm => 'batcher', );



mkdir('output/');


my $tmpl = <<'END';

// gcc -Wall -g -O3 output/measure.c -o output/a.out -lrt

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <time.h>



void timespec_subtract(struct timespec *result, struct timespec *end, struct timespec *start) {
	if ((end->tv_nsec - start->tv_nsec)<0) {
		result->tv_sec = end->tv_sec - start->tv_sec-1;
		result->tv_nsec = 1000000000 + end->tv_nsec - start->tv_nsec;
	} else {
		result->tv_sec = end->tv_sec - start->tv_sec;
		result->tv_nsec = end->tv_nsec - start->tv_nsec;
	}
}



void sort[% network_size %]_leaky(int *a) {
  int temp;

  [% FOREACH c IN network %]
    if (a[[% c.0 %]] < a[[% c.1 %]]) {
      temp = a[[% c.0 %]];
      a[[% c.0 %]] = a[[% c.1 %]];
      a[[% c.1 %]] = temp;
    }
  [% END %]
}

void sort[% network_size %]_constanttime(int *a) {
  int temp[2], diff;

  [% FOREACH c IN network %]
    diff = !(a[[% c.0 %]] < a[[% c.1 %]]);
    temp[0] = a[[% c.0 %]];
    temp[1] = a[[% c.1 %]];
    a[[% c.0 %]] = temp[!diff];
    a[[% c.1 %]] = temp[diff];
  [% END %]
}

#define min(x, y) (y ^ ((x ^ y) & -(x < y)))
#define max(x, y) (x ^ ((x ^ y) & -(x < y)))

void sort[% network_size %]_constanttime2(int *a) {
  int temp;

  [% FOREACH c IN network %]
    temp = max(a[[% c.0 %]], a[[% c.1 %]]);
    a[[% c.1 %]] = min(a[[% c.0 %]], a[[% c.1 %]]);
    a[[% c.0 %]] = temp;
  [% END %]
}

int compare(const void *p1, const void *p2) {
  return *((int*)p1) < *((int*)p2);
}

void sort[% network_size %]_qsort(int *a) {
  qsort(a, [% network_size %], sizeof(int), compare);
}


int main(int argc, char *argv[]) {
  int opt;
  int constanttime = 0;
  int constanttime2 = 0;
  int leaky = 0;
  int use_qsort = 0;
  int asc = 0;
  int iters = 10;
  int show_output = 0;
  void (*sort_fun)(int *);
  struct timespec start;
  struct timespec end;
  struct timespec diff;

  int base_array[[% network_size %]];
  int work_array[[% network_size %]];
  int i;

  while ((opt = getopt(argc, argv, "kslcdaqi:")) != -1) {
    switch(opt) {
      case 's': show_output = 1; break;
      case 'c': constanttime = 1; break;
      case 'k': constanttime2 = 1; break;
      case 'l': leaky = 1; break;
      case 'q': use_qsort = 1; break;
      case 'a': asc = 1; break;
      case 'd': asc = 0; break;
      case 'i': iters = atoi(optarg); break;
      default: fprintf(stderr, "unknown option\n"); exit(1);
    }
  }

  if (asc) {
    for(i=0; i<[% network_size %]; i++) {
      base_array[i] = i;
    }
  } else {
    for(i=0; i<[% network_size %]; i++) {
      base_array[[% network_size %] - i - 1] = i;
    }
  }

  if (constanttime) {
    sort_fun = sort[% network_size %]_constanttime;
  } else if (constanttime2) {
    sort_fun = sort[% network_size %]_constanttime2;
  } else if (leaky) {
    sort_fun = sort[% network_size %]_leaky;
  } else if (use_qsort) {
    sort_fun = sort[% network_size %]_qsort;
  } else {
    fprintf(stderr, "You forgot an algo\n");
    exit(1);
  }

  for(i=0; i<iters; i++) {
    memcpy(work_array, base_array, sizeof(work_array));

    // use CLOCK_HIGHRES on solaris
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
    sort_fun(work_array);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);

    timespec_subtract(&diff, &end, &start);
    printf("%ld\n", (long) diff.tv_nsec);
  }

  if (show_output) {
    for(i=0; i<[% network_size %]; i++) {
      fprintf(stdout, "a[%d] = %d\n", i, work_array[i]);
    }
  }

  return 0;
}


END



my $template = Template->new();

$template->process(\$tmpl, { network => \@network, network_size => $network_size }, 'output/measure.c') || die $template->error();
