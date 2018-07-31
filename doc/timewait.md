### TIME_WAIT连接超时的处理

根据TCP协议定义的3次握手断开连接规定,发起socket主动关闭的一方 socket将进入TIME_WAIT状态,TIME_WAIT状态将持续2个MSL(Max Segment Lifetime),在Windows下默认为4分钟,即240秒,TIME_WAIT状态下的socket不能被回收使用. 具体现象是对于一个处理大量短连接的服务器,如果是由服务器主动关闭客户端的连接,将导致服务器端存在大量的处于TIME_WAIT状态的socket, 甚至比处于Established状态下的socket多的多,严重影响服务器的处理能力,甚至耗尽可用的socket,停止服务. TIME_WAIT是TCP协议用以保证被重新分配的socket不会受到之前残留的延迟重发报文影响的机制,是必要的逻辑保证.

发现系统存在大量TIME_WAIT状态的连接，通过调整内核参数解决，</br>
```
vi /etc/sysctl.conf
```
编辑文件，加入以下内容：
```
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
````
 
然后执行 /sbin/sysctl -p 让参数生效。</br>

```
net.ipv4.tcp_syncookies = 1  
表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1 </br>
表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；</br>
net.ipv4.tcp_tw_recycle = 1 </br>
表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。<br>
net.ipv4.tcp_fin_timeout </br>
修改系統默认的 TIMEOUT 时间
```
