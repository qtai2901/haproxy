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
 read -p "IP số $((a+1)): " I_P
 config
  a=$((a+1))
done
}
config(){
cd /etc/haproxy
 cat >>haproxy.cfg <<EOF
    server             client$((a+1)) $I_P:80 check
EOF
}

case "${num}" in
1) apt -y install haproxy
cd /etc/haproxy
  cat >haproxy.cfg <<EOF
# add to the end
# define frontend ( any name is OK for [http-in] )
frontend http-in
        # listen 80 port
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
echo "đã xong"
;;
2) cd /etc/haproxy
  cat >haproxy.cfg <<EOF
# add to the end
# define frontend ( any name is OK for [http-in] )
frontend http-in
        # listen 80 port
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
echo "đã xong"
;;
esac
