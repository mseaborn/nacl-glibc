
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <string.h>
#include <sysdep.h>
#include <unistd.h>

#include <nacl_rpc.h>
#include <nacl_syscalls.h>


static int nacl_open_rpc(const char *filename)
{
  struct NaClImcMsgIoVec iov;
  struct NaClImcMsgHdr msg;
  int filename_len = strlen(filename);
  char *msg_data = alloca(4 + filename_len);
  memcpy(msg_data, "Open", 4);
  memcpy(msg_data + 4, filename, filename_len);
  iov.base = msg_data;
  iov.length = 4 + filename_len;
  msg.iov = &iov;
  msg.iov_length = 1;
  msg.descv = NULL;
  msg.desc_length = 0;
  if(imc_sendmsg(NACL_COMMS_FD, &msg, 0) < 0)
    return -1;

  char buf[4];
  int fd;
  iov.base = buf;
  iov.length = sizeof(buf);
  msg.descv = &fd;
  msg.desc_length = 1;
  int got = imc_recvmsg(NACL_COMMS_FD, &msg, 0);
  if(got >= 0 && msg.desc_length == 1)
    return fd;
  else {
    errno = ENOENT;
    return -1;
  }
}

int __open(const char *filename, int flags, ...)
{
  int (*nacl_open)(char const *pathname, int flags, int mode) = 
    NACL_SYSCALL_ADDR(NACL_sys_open);
  int mode = 0;
  if(flags & O_CREAT) {
    va_list arg;
    va_start(arg, flags);
    mode = va_arg(arg, int);
    va_end(arg);
  }

  if(nacl_should_use_rpc())
    return nacl_open_rpc(filename);

  int result = nacl_open(filename, flags, mode);
  if (result < 0) {
    errno = -result;
    return -1;
  }
  return result;
}
libc_hidden_def (__open)
weak_alias (__open, open)
strong_alias (__open, __libc_open)
strong_alias (__open, __open_nocancel)
