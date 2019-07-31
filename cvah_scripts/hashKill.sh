for list in `ps -ef |grep hashBack |grep -v color |cut -d" " -f6`; do
   kill -9 ${list}
done
for list in `ps -ef |grep md5sum |grep -v color |cut -d" " -f6`; do
   kill -9 ${list}
done
