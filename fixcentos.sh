cd /etc/yum.repos.d
mv CentOS-Base.repo CentOS-Base.repo.org
wget -q -N --no-check-certificate -O CentOS-Base.repo https://raw.githubusercontent.com/qtai2901/haproxy/main/CentOS-Base.repo
sudo yum clean all
echo "done Phí 5 chục"