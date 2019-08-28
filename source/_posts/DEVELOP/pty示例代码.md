---
title: pty示例代码
date: 2017-08-17 16:18:08
categories:
  - DEVELOP
---
``` c
#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pty.h>

int main()
{
        int fd_m, fd_s;
        int len;
        const char *pts_name;
        char send_buf[64] = "abc\ndefghijk\nlmn";
        char recv_buf[64] = {0};

        fd_m = open("/dev/ptmx", O_RDWR | O_NOCTTY);
        if (fd_m < 0) {
                printf("open /dev/ptmx fail1\n");
                return -1;
        }

        if (grantpt(fd_m) < 0 || unlockpt(fd_m) < 0) {
                printf("grantpt and unlockpt fail\n");
                goto err;
        }

        pts_name = (const char *)ptsname(fd_m);
        fd_s = open(pts_name, O_RDONLY | O_NOCTTY);
        if (fd_s < 0) {
                printf("open /dev/ptmx fail2\n");
                goto err;
        }

        len = write(fd_m, send_buf, strlen(send_buf));
        printf("write len=%d\n", len);

        len = read(fd_s, recv_buf, sizeof(recv_buf));
        printf("read len=%d, recv_buf=[%s]\n", len, recv_buf);

        len = read(fd_s, recv_buf, sizeof(recv_buf));
        printf("read len=%d, recv_buf=[%s]\n", len, recv_buf);

        close(fd_m);
        close(fd_s);
        return 0;

err:
        if (fd_m)
                close(fd_m);
        if (fd_s)
                close(fd_s);

        return -1;
}
```