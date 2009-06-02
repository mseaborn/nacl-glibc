
#ifndef _NACL_RPC_H
#define _NACL_RPC_H

#include <libc-symbols.h>

#include <nacl_syscalls.h>


#define NACL_COMMS_FD 3

int (*imc_sendmsg)(int fd, const struct NaClImcMsgHdr *msg, int flags);
int (*imc_recvmsg)(int fd, struct NaClImcMsgHdr *msg, int flags);
hidden_proto (imc_sendmsg);
hidden_proto (imc_recvmsg);


int nacl_should_use_rpc(void);
hidden_proto (nacl_should_use_rpc);


#endif
