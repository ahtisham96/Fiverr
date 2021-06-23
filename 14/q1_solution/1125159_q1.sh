#!/bin/bash
temp=1
total=0
# You can use python commands in bash in this fashion
# python -c 'print("TESTPRINT")'
echo "checking the existence of the files or directories and their emptiness" && sleep 1
# check the existence of Marks.txt file
if [[ -f "Marks.txt" ]] 
then 
    ((temp=temp+1))
else
     exit
fi
# check the existence of Students.txt file
if [[ -f "Students.txt" ]] 
then
    ((temp=temp+1))
else
    exit
fi
# check if the file is empty
if [[ -s Marks.txt ]] 
then
    ((temp=temp+1))
else
    exit
fi
# check the existence of the feedbackTemplate.tex file
if [[ -f "./OUTPUT/feedbackTemplate.tex" ]] 
then
    ((temp=temp+1))
else
    exit
fi
# check if OUTPUT directory exists
if [[ -d OUTPUT ]]
then
    ((temp=temp+1))
else
    exit
fi
# Clear the directory if already .tex files are exists
# check if the file is empty
if [[ -s *.txt ]] 
then
    rm *.tex
    rm ./OUTPUT/*.pdf
fi
# create .tex file for each student
echo "creating the .tex files against studentid's" && sleep 1
>track_user_id
track=0 
count=1
while read lineA
    do 
        lineB=`sed -n "$count"p Marks.txt`
        count=`expr $count + 1`
        ((track=count-1))
        if [[ $track > 1 ]]
        then
            echo $lineA > temp_stu
            echo $lineB > temp_mark
            #cat Students.txt |sed 's/\|/ /'|awk '{print $1}'
        
            std_id=`awk -F',' '{print $1}' temp_stu`
            echo $std_id >> track_user_id
            std_name=`awk -F',' '{print $2}' temp_stu`
            q1_grd=`awk -F',' '{print $2}' temp_mark` 
            q2_grd=`awk -F',' '{print $3}' temp_mark` 
            q3_grd=`awk -F',' '{print $4}' temp_mark` 
            comments=`awk -F',' '{print $5}' temp_mark`

            touch ${std_id}.tex
            > ${std_id}.tex
            
            ((total=q1_grd+q2_grd+q3_grd))
            echo "\documentclass{article}">> ${std_id}.tex
            echo "\usepackage[utf8]{inputenc}" >> ${std_id}.tex
            echo "">> ${std_id}.tex
            echo "\title{CSC3333 Software Engineering 3}" >> ${std_id}.tex
            echo "\author{Assignment 1 }" >>${std_id}.tex
            echo "\date{Student ID: $std_id}" >>${std_id}.tex
            echo "" >> ${std_id}.tex
            echo "\begin{document}" >> ${std_id}.tex
            echo "" >> ${std_id}.tex
            echo "\maketitle" >> ${std_id}.tex
            echo "    \begin{center}Student Name: $std_name\end{center}" >> ${std_id}.tex
            echo "\begin{center}" >> ${std_id}.tex
            echo "\begin{tabular}{ |c|c|c|}" >> ${std_id}.tex
            echo "\hline" >> ${std_id}.tex
            echo "Questions & Marks & Grade\\\\" >> ${std_id}.tex
            echo "\hline" >> ${std_id}.tex
            echo "Question1 & 10 & $q1_grd\\\\" >> ${std_id}.tex
            echo "\hline" >> ${std_id}.tex
            echo "Question2 & 10 & $q2_grd\\\\" >> ${std_id}.tex
            echo "\hline" >> ${std_id}.tex
            echo "Question3 & 10 & $q3_grd\\\\" >> ${std_id}.tex
            echo "\hline" >> ${std_id}.tex
            echo "Total & 30 & $total\\\\" >> ${std_id}.tex
            echo "\hline" >> ${std_id}.tex
            echo "\end{tabular}" >> ${std_id}.tex
            echo "\end{center}" >> ${std_id}.tex
            echo "Comments: $comments" >> ${std_id}.tex
            echo "\end{document}" >> ${std_id}.tex
        fi
done < Students.txt
rm temp_mark temp_stu

# Generate pdf using latex from studentid.tex files
echo "Creating the stdentid.pdf files from studentid.tex files" && sleep 1
while read lineA
do
    pdflatex ${lineA}.tex ./OUTPUT
done < track_user_id

# Move the output of pdf into OUTPUT directory
while read lineA
do
    mv ${lineA}.pdf ./OUTPUT/
done < track_user_id

# Delete unnecessary files
echo "Unncessary files are going to delete" && sleep 1
rm *.aux *.log track_user_id *.tex

#pdflatex -interaction=nonstopmode ${std_id}.tex