
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <sysdep.h>
#include <unistd.h>

#include <nacl_syscalls.h>


#define COMMS_FD 3

static int is_initialised = 0;
static int use_rpc = 0;

static int should_use_rpc(void)
{
  if(!is_initialised) {
    use_rpc = getenv("NACL_FD") != NULL;
    is_initialised = 1;
  }
  return use_rpc;
}

static int nacl_open_rpc(const char *filename)
{
  int (*imc_sendmsg)(int fd, const struct NaClImcMsgHdr *msg, int flags) = 
    NACL_SYSCALL_ADDR(NACL_sys_imc_sendmsg);
  int (*imc_recvmsg)(int fd, struct NaClImcMsgHdr *msg, int flags) = 
    NACL_SYSCALL_ADDR(NACL_sys_imc_recvmsg);

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
  if(imc_sendmsg(COMMS_FD, &msg, 0) < 0)
    return -1;

  char buf[4];
  int fd;
  iov.base = buf;
  iov.length = sizeof(buf);
  msg.descv = &fd;
  msg.desc_length = 1;
  int got = imc_recvmsg(COMMS_FD, &msg, 0);
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

  if(should_use_rpc())
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
