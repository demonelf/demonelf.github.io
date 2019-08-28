---
title: ppp协议总结
categories:
  - VPN系列之五花八门
date: 2017-09-19 10:20:43
tags:
---





## 协议规范





## 实现原理



``` c	
struct ppp_info{
	int unit;			/**/
	int dev_fd;			/**/
	int lcp_fd;			/**/
	int ppp_fd;			/**/
	int remote_id;		/**/
	char	*user;		/* Username for authentication */
	char	*passwd;	/* Password for authentication */
	char *ifname;
	char attach_inter[16];
	unsigned char distance;
	unsigned char weight;
	unsigned char gateway;
	unsigned char dns;
	unsigned char auth;
	unsigned char auth_type;
	unsigned char down_flag;			//避免PPP主动down掉和手动清除冲突
	unsigned int unique;
	unsigned int dns_value;
	unsigned int wins_value;
	char usergrp[MAXNAMELEN];
	struct prefix_ipv4 localaddr;
	unsigned int peer_address;			//tunnip
	int lcp_detect_interval_time;		//for change interval time of lcp echo request
	int lcp_detect_lost_times;			//for change times of no respons lcp echo request
	struct thread * lcp_thread;
	struct thread * ipcp_rthread;
    void *conn;
    void *priv_data;
    int natid;
	int mtu;
	Ppp_if_type iftype;
	int (*manage_auto_down) (char *ifname);
	int (*ipcp_up_cb) (struct ppp_cb_info *cb_info);
	int (*ipcp_down_cb) (struct ppp_cb_info *cb_info);
	int (*lcp_auth) (char *name, char *group, char *password, unsigned char *challenge, int unit, int type);
	int (*check_rqci)(__u32 addr);
};
```





void LcpLinkFailure (f)

lcp_close(f->unit, "Peer not responding");