#include <ctype.h>
#include <errno.h>
#include <libgen.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>

int cpu_intensive (void);
void usage(void);

int main (int argc, char **argv)
{
  int c, i, pid, children = 0;
  int nb_cpu=0;
  long timeout = 0;


   
 while ( ( c = getopt(argc,argv,"c:t:") ) != -1 ) {
    switch ( c ) {
      case 'c' : nb_cpu = atoi(optarg); printf("nbcpu= %d \n", nb_cpu);   break;
      case 't' : timeout = atoi(optarg); printf("timeout= %d \n", timeout);    break;
      default  :
        usage();
        exit(0);
        return 0;
    }
}


     
    while(nb_cpu)
	{
          switch (pid = fork ())
            {
            case 0:            /* child */
              alarm (timeout);
              exit (cpu_intensive());
            case -1:           /* error */
              err (stderr, "fork failed: %s\n", strerror (errno));
              break;
            default:           /* parent */
              ++children;
            }
            --nb_cpu;
	}


	/* Wait for our children to exit.  */
  while (children)
    {
      int status, ret;

      if ((pid = wait (&status)) > 0)
        {
          --children;

          if (WIFEXITED (status))
            {
              if ((ret = WEXITSTATUS (status)) == 0)
                {
                  printf("worker %i returned normally\n", pid);
                }
              else
                {
                  printf("worker %i returned error %i\n", pid, ret);
                  if (signal (SIGUSR1, SIG_IGN) == SIG_ERR)
                    printf("handler error: %s\n", strerror (errno));
                  if (kill (-1 * getpid (), SIGUSR1) == -1)
                    printf("kill error: %s\n", strerror (errno));
                }
            }
    }
}
}

int cpu_intensive (void)
{
  while (1)
  { };

  return 0;
}


void usage ( void ) {
  printf ( "Usage: cpu_intensive -c cpuNb -t timeout(sec) ");
}


