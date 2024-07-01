clear
echo "   1. Cài đặt HAPROXY"
echo "   2. Update config"
read -p "  Vui lòng chọn một số và nhấn Enter (Enter theo mặc định Cài đặt)  " num
[ -z "${num}" ] && num="1"
case "${num}" in
1)
