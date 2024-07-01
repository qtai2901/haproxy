clear
echo "   1. Cài đặt HAPROXY"
echo "   2. Update config"
read -p "  Vui lòng chọn một số và nhấn Enter (Enter theo mặc định Cài đặt)  " num
[ -z "${num}" ] && num="1"

install(){
  clear
  read -p "Nhập số ip cần cài và nhấn Enter: " n
[ -z "${n}" ] && n="1"
a=0
while [ $a -lt $n ]
do
#  echo " IP số $((a+1))"
 read -p "IP số $((a+1)):" I_P
 config
  a=$((a+1))
done
}
config(){
cd /etc/haproxy
 cat >>haproxy.cfg <<EOF
    server             client$((a+1)) I_P:80 check
EOF
}

case "${num}" in
1) yum -y install haproxy
cd /etc/haproxy
  cat >haproxy.cfg <<EOF
# create new
global
      # for logging section
    log         127.0.0.1 local2 info
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
      # max per-process number of connections
    maxconn     256
      # process' user and group
    user        haproxy
    group       haproxy
      # makes the process fork into background
    daemon

defaults
      # running mode
    mode               http
      # use global settings
    log                global
      # get HTTP request log
    option             httplog
      # timeout if backends do not reply
    timeout connect    10s
      # timeout on client side
    timeout client     30s
      # timeout on server side
    timeout server     30s

# define frontend ( set any name for "http-in" section )
frontend http-in
      # listen 80
    bind *:80
      # set default backend
    default_backend    backend_servers
      # send X-Forwarded-For header
    option             forwardfor

# define backend
backend backend_servers
      # balance with roundrobin
    balance            roundrobin
      # define backend servers
EOF
install
cd ~/
systemctl start haproxy
systemctl enable haproxy
;;
2) cd /etc/haproxy
  cat >haproxy.cfg <<EOF
# create new
global
      # for logging section
    log         127.0.0.1 local2 info
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
      # max per-process number of connections
    maxconn     256
      # process' user and group
    user        haproxy
    group       haproxy
      # makes the process fork into background
    daemon

defaults
      # running mode
    mode               http
      # use global settings
    log                global
      # get HTTP request log
    option             httplog
      # timeout if backends do not reply
    timeout connect    10s
      # timeout on client side
    timeout client     30s
      # timeout on server side
    timeout server     30s

# define frontend ( set any name for "http-in" section )
frontend http-in
      # listen 80
    bind *:80
      # set default backend
    default_backend    backend_servers
      # send X-Forwarded-For header
    option             forwardfor

# define backend
backend backend_servers
      # balance with roundrobin
    balance            roundrobin
      # define backend servers
EOF
install
cd ~/
systemctl restart haproxy
;;
esac
