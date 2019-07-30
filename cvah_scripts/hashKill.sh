for list in `ps -ef |grep hashBack |grep -v color |cut -d" " -f6`; do
   kill -9 ${list}
done
