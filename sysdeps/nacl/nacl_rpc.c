
#include <stdlib.h>

#include <nacl_rpc.h>


int (*imc_sendmsg)(int fd, const struct NaClImcMsgHdr *msg, int flags) = 
  NACL_SYSCALL_ADDR(NACL_sys_imc_sendmsg);

int (*imc_recvmsg)(int fd, struct NaClImcMsgHdr *msg, int flags) = 
  NACL_SYSCALL_ADDR(NACL_sys_imc_recvmsg);

hidden_def (imc_sendmsg);
hidden_def (imc_recvmsg);


static int is_initialised = 0;
static int use_rpc = 0;


int nacl_should_use_rpc(void)
{
  if(!is_initialised) {
    use_rpc = getenv("NACL_FD") != NULL;
    is_initialised = 1;
  }
  return use_rpc;
}

hidden_def (nacl_should_use_rpc);
