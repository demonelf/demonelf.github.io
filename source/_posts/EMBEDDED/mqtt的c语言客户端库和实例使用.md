---
title: mqtt的c语言客户端库和实例使用
date: 2017-07-12 16:36:17
tags:
---
<script src="http://cdn.bootcss.com/highlight.js/9.1.0/languages/vbscript.min.js" ></script>

**C 客户端**

Eclipse Paho C

1. 支持 TCP/SSL Socket 连接
2. 支持自动重连
3. 支持 WebSocket
4. 代码样例

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
        exit(-1);
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
mqttc

1.支持消息发布、主题订阅以及取消订阅
2.代码样例

```
mqttc -h host -p port -u username -P password -k keepalive
```
Eclipse Paho Embedded C

1.支持 MQTT V3.1 以及 V3.1.1 协议
2.支持 TCP/SSL Socket 连接
3.代码样例
```
#define MQTTCLIENT_QOS2 1
#include "MQTTClient.h"
#define DEFAULT_STACK_SIZE -1
#include "linux.cpp"

int arrivedcount = 0;

void messageArrived(MQTT::MessageData& md)
{
    MQTT::Message &message = md.message;

    printf("Message %d arrived: qos %d, retained %d, dup %d, packetid %d\n",
        ++arrivedcount, message.qos, message.retained, message.dup, message.id);
    printf("Payload %.*s\n", (int)message.payloadlen, (char*)message.payload);
}

int main(int argc, char* argv[])
{
    IPStack ipstack = IPStack();
    float version = 0.3;
    const char* topic = "mbed-sample";

    printf("Version is %f\n", version);

    MQTT::Client client = MQTT::Client(ipstack);

    const char* hostname = "iot.eclipse.org";
    int port = 1883;
    printf("Connecting to %s:%d\n", hostname, port);
    int rc = ipstack.connect(hostname, port);
    if (rc != 0)
        printf("rc from TCP connect is %d\n", rc);

    printf("MQTT connecting\n");
    MQTTPacket_connectData data = MQTTPacket_connectData_initializer;
    data.MQTTVersion = 3;
    data.clientID.cstring = (char*)"mbed-icraggs";
    rc = client.connect(data);
    if (rc != 0)
        printf("rc from MQTT connect is %d\n", rc);
    printf("MQTT connected\n");

    rc = client.subscribe(topic, MQTT::QOS2, messageArrived);
    if (rc != 0)
        printf("rc from MQTT subscribe is %d\n", rc);

    MQTT::Message message;

    // QoS 0
    char buf[100];
    sprintf(buf, "Hello World!  QoS 0 message from app version %f", version);
    message.qos = MQTT::QOS0;
    message.retained = false;
    message.dup = false;
    message.payload = (void*)buf;
    message.payloadlen = strlen(buf)+1;
    rc = client.publish(topic, message);
    if (rc != 0)
        printf("Error %d from sending QoS 0 message\n", rc);
    else while (arrivedcount == 0)
        client.yield(100);

    rc = client.unsubscribe(topic);
    if (rc != 0)
        printf("rc from unsubscribe was %d\n", rc);

    rc = client.disconnect();
    if (rc != 0)
        printf("rc from disconnect was %d\n", rc);

    ipstack.disconnect();

    return 0;
}
```
libmosquitto

libmosquitto 是 C 语言共享库，可以创建 MQTT 客户端程序。所有的 API 函数都有 mosquitto_ 前缀。

```
// 获取库的版本信息，返回到三个参数中
int mosquitto_lib_version(int *major,int *minor,int *revision)

// 初始化和清除
int mosquitto_lib_init();    
int mosquitto_lib_cleanup(); 

// 新建一个 mosquitto 客户端对象，并返回 struct mosquitto
struct mosquitto *mosquitto_new(const char *id, bool clean_session, void *userdata);    

// 释放一个 mosquitto 客户端对象
void mosquitto_destroy(struct mosquitto *mosq);
```
libemqtt

1.Embedded C client library for the MQTT protocol. It also provides a binding for Python.
2.编译
```
// C Library
$ make

// Python binding
$ make python
```

wolfMQTT

This is an implementation of the MQTT Client written in C for embedded use, which supports SSL/TLS via the wolfSSL library. This library was built from the ground up to be multi-platform, space conscience and extensible. Integrates with wolfSSL to provide TLS support.

Example code

```
// This is where the top level application interfaces for the MQTT client reside.
int MqttClient_Init(MqttClient *client, MqttNet *net, MqttMsgCb msg_cb, byte *tx_buf, int tx_buf_len, byte *rx_buf, int rx_buf_len, int cmd_timeout_ms);

// These API's are blocking on MqttNet.read until error/timeout (cmd_timeout_ms):
int MqttClient_Connect(MqttClient *client, MqttConnect *connect);
int MqttClient_Publish(MqttClient *client, MqttPublish *publish);
int MqttClient_Subscribe(MqttClient *client, MqttSubscribe *subscribe);
int MqttClient_Unsubscribe(MqttClient *client, MqttUnsubscribe *unsubscribe);
int MqttClient_Ping(MqttClient *client);
int MqttClient_Disconnect(MqttClient *client);

// This function blocks waiting for a new publish message to arrive for a maximum duration of timeout_ms.
int MqttClient_WaitMessage(MqttClient *client, MqttMessage *message, int timeout_ms);

// These are the network connect / disconnect interfaces that wrap the MqttNet callbacks and handle WolfSSL TLS:
int MqttClient_NetConnect(MqttClient *client, const char* host, word16 port, int timeout_ms, int use_tls, MqttTlsCb cb);
int MqttClient_NetDisconnect(MqttClient *client);

// Helper functions:
const char* MqttClient_ReturnCodeToString(int return_code);
```
