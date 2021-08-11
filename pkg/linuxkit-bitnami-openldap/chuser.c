#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int uid = 0;
  if (argc < 2) {
    fprintf(stderr, "%s UID COMMAND...\n", argv[0]);
    return 1;
  }
  uid = strtol(argv[1], NULL, 10);
  setuid(uid);
  
  execvp(argv[2], &argv[2]);
  fprintf(stderr, "failed to execute\n");
  return 1;
}

