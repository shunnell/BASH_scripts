find . -maxdepth 1 -type d |while read dir; do 
     printf "%-45.45s : " "$dir"
     find "$dir" -type f |wc -l
done > tmp.txt
cat tmp.txt |sort -d > status.txt
rm -f tmp.txt


