---
title: MQTT C Client实现消息推送（入门指南）
date: 2017-07-14 15:20:41
tags:
---
本篇文章主要介绍了"MQTT C Client实现消息推送（入门指南）"，主要涉及到MQTT C Client实现消息推送（入门指南）方面的内容，对于MQTT C Client实现消息推送（入门指南）感兴趣的同学可以参考一下。

MQTT（Message Queuing Telemetry Transport，消息队列遥测传输）是IBM开发的一个即时通讯协议，通过MQTT协议，目前已经扩展出了数十个MQTT服务器端程序，可以通过PHP，JAVA，Python，C，C#等系统语言来向MQTT发送相关消息。随着移动互联网的发展，MQTT由于开放源代码，耗电量小等特点，将会在移动消息推送领域会有更多的贡献，在物联网领域，传感器与服务器的通信，信息的收集，MQTT都可以作为考虑的方案之一。在未来MQTT会进入到我们生活的各各方面。The Paho MQTT C Client is a fully fledged MQTT client written in ANSI standard C. It avoids C++ in order to be as portable as possible. A C++ layer over this library is also available in Paho.

* * *

目录：

*   [何为MQTT](http://www.fx114.net/qa-170-148600.aspx#何为mqtt)
*   [生成dll库混合编程](http://www.fx114.net/qa-170-148600.aspx#生成dll库混合编程)
*   [MQTT C Client实战](http://www.fx114.net/qa-170-148600.aspx#mqtt-c-client实战)
    *   [Synchronous publication example](http://www.fx114.net/qa-170-148600.aspx#synchronous-publication-example)
    *   [Asynchronous publication example](http://www.fx114.net/qa-170-148600.aspx#asynchronous-publication-example)
    *   [Asynchronous subscription example](http://www.fx114.net/qa-170-148600.aspx#asynchronous-subscription-example)

# 何为MQTT？

MQTT主要用于服务端对客户端进行消息推送，根据这个具体要求，很容易知道它包括两个部分：客户端、服务端。

MQTT消息推送是基于主题`topic`模式的，可以分开来说：

*   客户端发布一条消息时，必须指定消息主题。（如，topic=”天气”,payload=”北京今天雾霾好大啊~~呜呜”），其中topic就是主题，payload是发送的具体内容。
*   服务端推送消息，也是基于主题的。当服务器发现有主题（如，topic=“天气”）时，就会给所有订阅该主题的客户端推送payload内容。

    *   这里需要个前提，就是有客户端订阅topic=”天气”这个主题；
    *   一旦客户端订阅该主题，服务端就会每收到该主题的消息，都会推送给订阅该主题的客户端。如果客户端不需要关注该主题了，也就是说不想接受到这样的推送消息了，只要取消otpic=”天气”的主题订阅即可。

MQTT协议是为大量计算能力有限，且工作在低带宽、不可靠的网络的远程传感器和控制设备通讯而设计的协议，它具有以下主要的几项特性：

1.  使用发布/订阅消息模式，提供一对多的消息发布，解除应用程序耦合；
2.  对负载内容屏蔽的消息传输；
3.  使用 TCP/IP 提供网络连接；
4.  有三种消息发布服务质量：

    *   “至多一次”，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
    *   “至少一次”，确保消息到达，但消息重复可能会发生。
    *   “只有一次”，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。（在实际编程中，只需要设置QoS值即可实现以上几种不同消息发布服务质量模式）
5.  小型传输，开销很小（固定长度的头部是 2 字节），协议交换最小化，以降低网络流量；
6.  使用 Last Will 和 Testament 特性通知有关各方客户端异常中断的机制；

# 生成dll库？混合编程？

在开始开发之前需要做一些准备工作，MQTT已经把所有的APIs封装好了，我们可以使用它的dll库，也可以直接导入源码进行混合编程，一般要求不高的话（因为不太懂得话，最好不要修改源码）可以直接将源码生成dll，然后使用即可，下文就是使用该方式：

> git clone [https://github.com/eclipse/paho.mqtt.c.git](https://github.com/eclipse/paho.mqtt.c.git)

从这里获得C Client源码之后，可以直接使用VS打开（我是VS2013）：

![这里写图片描述](http://img.blog.csdn.net/20170501145609146?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWluZ2R1anVu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

对于上图的说明，下载源码后，打开将是以上界面，包括十来个工程，这里讲解几个：

*   paho-mqtt3a ： 一般实际开发中就是使用这个，a表示的是异步消息推送（asynchronous）。
*   paho-mqtt3as ： as表示的是 异步+加密（asynchronous+OpenSSL）。
*   paho-mqtt3c ： c 表示的应该是同步（Synchronize），一般性能较差，是发送+等待模式。
*   paho-mqtt3cs ： 同上，增加了一个OpenSSL而已。

这里根据自身的需要选择不同的项目生成DLL即可，右击单个项目->生成。由于你电脑中可能没有OPenSSL环境，如果点击VS工具栏中的生成解决方案，十有八九会失败，因为它会生成所有项目的解决方案，其实你根本用不着这么多。

另外，上图中无法打开包括文件`VersionInfo.h`，你只需要在src文件夹中找到VersionInfo.h.in文件，去掉.in后缀->重新生成即可。

# MQTT C Client实战

了解更多可以阅读《[MQTT C Client for Posix and Windows](https://www.eclipse.org/paho/clients/c/)》一文，下面根据官网资料，摘录了几个C语言实现MQTT的小DEMO。

MQTT使用起来也十分容易，基本上就那四五个函数：MQTTClient_create（创建客户端）、MQTTClient_connect（连接服务端）、MQTTClient_publishMessage（客户端->服务端发送消息）、MQTTClient_subscribe（客户端订阅某个主题）等等。其中，很多异步回调函数，需要自己去实现，如，

```
MQTTAsync_setCallbacks(mqtt->_client, mqtt->_client, connlost, msgarrvd, NULL);
```

MQTTAsync_setCallbacks中，

*   connlost函数指针，是当MQTT意外断开链接时会回调的函数，由自己实现；
*   msgarrvd函数指针，是当服务器有消息推送回来时，客户端在此处接受服务端消息内容。

另外，就是一些函数执行是否成功的回调函数，C语言封装回调之后，就是这么写法，看起来有些变扭。有兴趣的可以看《[浅谈C/C++回调函数（Callback）& 函数指针](http://blog.csdn.net/qingdujun/article/details/69789300)》文章，再了解以下回调函数。

```
mqtt->_conn_opts.onSuccess = onConnect;
mqtt->_conn_opts.onFailure = onConnectFailure;
```

最后，不得不说的就是，MQTT有些发送或者是订阅的内容时（某些函数中），在编程最好将参数中传进来的值在内存中拷贝一份再操作，笔者当时开发时，就是因为这样的问题，折腾了较长时间，后来在wireshark中发现数据包中根本没有内容，才知道是由于函数参数是指针形式，直接在异步中使用可能会发生一些未知的错误。

## Synchronous publication example

```
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientPub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }
    pubmsg.payload = PAYLOAD;
    pubmsg.payloadlen = strlen(PAYLOAD);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    MQTTClient_publishMessage(client, TOPIC, &pubmsg, &token);
    printf("Waiting for up to %d seconds for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            (int)(TIMEOUT/1000), PAYLOAD, TOPIC, CLIENTID);
    rc = MQTTClient_waitForCompletion(client, token, TIMEOUT);
    printf("Message with delivery token %d delivered\n", token);
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```

## Asynchronous publication example

```
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientPub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L
volatile MQTTClient_deliveryToken deliveredtoken;
void delivered(void *context, MQTTClient_deliveryToken dt)
{
    printf("Message with token value %d delivery confirmed\n", dt);
    deliveredtoken = dt;
}
int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message)
{
    int i;
    char* payloadptr;
    printf("Message arrived\n");
    printf("     topic: %s\n", topicName);
    printf("   message: ");
    payloadptr = message->payload;
    for(i=0; i<message->payloadlen; i++)
    {
        putchar(*payloadptr++);
    }
    putchar('\n');
    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}
void connlost(void *context, char *cause)
{
    printf("\nConnection lost\n");
    printf("     cause: %s\n", cause);
}
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered);
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }
    pubmsg.payload = PAYLOAD;
    pubmsg.payloadlen = strlen(PAYLOAD);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    deliveredtoken = 0;
    MQTTClient_publishMessage(client, TOPIC, &pubmsg, &token);
    printf("Waiting for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            PAYLOAD, TOPIC, CLIENTID);
    while(deliveredtoken != token);
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```
## Asynchronous subscription example
```
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientSub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L
volatile MQTTClient_deliveryToken deliveredtoken;
void delivered(void *context, MQTTClient_deliveryToken dt)
{
    printf("Message with token value %d delivery confirmed\n", dt);
    deliveredtoken = dt;
}
int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message)
{
    int i;
    char* payloadptr;
    printf("Message arrived\n");
    printf("     topic: %s\n", topicName);
    printf("   message: ");
    payloadptr = message->payload;
    for(i=0; i<message->payloadlen; i++)
    {
        putchar(*payloadptr++);
    }
    putchar('\n');
    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}
void connlost(void *context, char *cause)
{
    printf("\nConnection lost\n");
    printf("     cause: %s\n", cause);
}
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    int rc;
    int ch;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered);
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }
    printf("Subscribing to topic %s\nfor client %s using QoS%d\n\n"
           "Press Q<Enter> to quit\n\n", TOPIC, CLIENTID, QOS);
    MQTTClient_subscribe(client, TOPIC, QOS);
    do 
    {
        ch = getchar();
    } while(ch!='Q' && ch != 'q');
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```