
#include <errno.h>
#include <stddef.h>
#include <string.h>
#include <sys/stat.h>

#include <nacl_rpc.h>
#include <nacl_syscalls.h>


int __have_no_stat64; /* Needed by fxstatat.c */


int ___xstat64 (int vers, const char *filename, struct stat64 *buf)
{
  struct NaClImcMsgIoVec iov;
  struct NaClImcMsgHdr msg;
  int filename_len = strlen(filename);
  char *msg_data = alloca(4 + filename_len);
  memcpy(msg_data, "Stat", 4);
  memcpy(msg_data + 4, filename, filename_len);
  iov.base = msg_data;
  iov.length = 4 + filename_len;
  msg.iov = &iov;
  msg.iov_length = 1;
  msg.descv = NULL;
  msg.desc_length = 0;
  if(imc_sendmsg(NACL_COMMS_FD, &msg, 0) < 0)
    return -1;

  int no_fields = 16;
  char recv_data[4 + 4*no_fields + 10];
  iov.base = recv_data;
  iov.length = sizeof(recv_data);
  msg.descv = NULL;
  msg.desc_length = 0;
  int got = imc_recvmsg(NACL_COMMS_FD, &msg, 0);
  if(got == 4 + 4*no_fields && memcmp(recv_data, "Rsta", 4) == 0) {
    int *fields = (int *) (recv_data + 4);
    buf->st_dev = fields[0];
    buf->st_ino = fields[1];
    buf->st_mode = fields[2];
    buf->st_nlink = fields[3];
    buf->st_uid = fields[4];
    buf->st_gid = fields[5];
    buf->st_rdev = fields[6];
    buf->st_size = fields[7];
    buf->st_blksize = fields[8];
    buf->st_blocks = fields[9];
    buf->st_atim.tv_sec = fields[10];
    buf->st_atim.tv_nsec = fields[11];
    buf->st_mtim.tv_sec = fields[12];
    buf->st_mtim.tv_nsec = fields[13];
    buf->st_ctim.tv_sec = fields[14];
    buf->st_ctim.tv_nsec = fields[15];
    return 0;
  }
  else {
    errno = ENOENT;
    return -1;
  }
}

#include <shlib-compat.h>

#if SHLIB_COMPAT(libc, GLIBC_2_1, GLIBC_2_2)
versioned_symbol (libc, ___xstat64, __xstat64, GLIBC_2_2);
strong_alias (___xstat64, __old__xstat64)
compat_symbol (libc, __old__xstat64, __xstat64, GLIBC_2_1);
hidden_ver (___xstat64, __xstat64)
#else
strong_alias (___xstat64, __xstat64)
hidden_def (__xstat64)
#endif
