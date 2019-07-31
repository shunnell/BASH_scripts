#!/bin/bash
 
#Declare a string array
LanguageArray=("PHP"  "Java"  "C#"  "C++"  "VB.Net"  "Python"  "Perl")
 
# Print array values in  lines
printf "\nPrint every element in new line\n"
for val1 in ${LanguageArray[*]}; do
     echo $val1
done
 
echo ""
 
# Print array values in one line
printf "\n\nPrint all elements in a single line\n"
for val2 in "${LanguageArray[*]}"; do
    echo $val2
done
echo ""
