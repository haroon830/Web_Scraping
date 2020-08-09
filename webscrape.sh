#!/bin/bash


#####GUI VARS##########3

HEIGHT=17
WIDTH=45
CHOICE_HEIGHT=8
BACKTITLE="WEB SCRAPER"
MENU="Choose one of the following "




#Doing Web Scraping  

#For checking parameters


outputfile="output.txt"
emailurl="https://marysvilledentalgroups.com/"
#var=$1
#dump webpage
dump_web(){
    url="http://quotes.toscrape.com/tag/$1/"
      curl -o $outputfile $url
}


#extracting the webpage
strip_html(){
    grep text $outputfile | sed 's/<[^>]*>//g' > temp.txt 
    echo "Authors" > author.txt
    grep -i author $outputfile | sed 's/<[^>]*>//g' >> author.txt
    sed -i 's/(about)//g' author.txt 
    sed -i '/^\s*$/d' author.txt

IFS=$'\r\n' GLOBIGNORE='*' command eval  'X=($(cat author.txt))'
IFS=$'\r\n' GLOBIGNORE='*' command eval  'Y=($(cat temp.txt))'
echo "Quotes and Authors" > temp1.txt
for ((i=0;i<${#X[@]};++i)); do
    printf "%s %s\n" "${Y[i]}" "${X[i]}" >> temp1.txt;
done

    }

#checking for errors
check_errors(){
    [ $? -ne 0 ] && echo "Error Downloading page..." && exit -1
}

#printing quotes
print_all_quotes(){
    echo "All quotes!"
    while read quote; do
        echo "${quote}"
    done < $outputfile
}
#################################



###################
##Email Crawling###
###################
#function Email getter
emailGet(){
wget -q -r -l1  $emailurl | grep -hrio "\b[a-z0-9.-]\+@[a-z0-9.-]\+\.[a-z]\{2,4\}\+\b"  > emails.txt

}


#####Email GUI#######

emailGui(){

dialog --clear\
   --backtitle "$BACKTITLE / Scrapped Emails" \
   --title "$TITLE"\
   --textbox emails.txt 20 150

}


#################

###########Hyper Links#####
###########################

function getHyperLinks(){

    mkdir -p crawl-data
    cd crawl-data
    wget -q -r -l5 -x 5  http://quotes.toscrape.com/
    cd ..
    grep -r -Po -h '(?<=href=")[^"]*' crawl-data/ > links_temp.csv
    
}
##########Hyper Links GUI#############

linksGui(){




dialog --clear\
   --backtitle "$BACKTITLE / Scrapped Links" \
   --title "$TITLE"\
   --textbox links_temp.csv 20 150


}



############################

#####GUI########

tag=""
quotes(){
while [[ 1 ]]
do
TITLE="Main Menu"
OPTIONS=(
1 "Love"     
2 "Inspirational"         
3 "Books"         
4 "Life") ##Main Menu

 CHOICE=$(dialog --clear \
--backtitle "$BACKTITLE" \
--title "$TITLE" \
--menu "$MENU" \
$HEIGHT $WIDTH $CHOICE_HEIGHT \
"${OPTIONS[@]}" \
2>&1 >/dev/tty)

if [ "$?" -eq 0 ]; then
case $CHOICE in
1) tag="love"
   dump_web $tag
   strip_html
   dialog --clear\
   --backtitle "$BACKTITLE / Love Quotes" \
   --title "$TITLE"\
   --textbox temp1.txt 20 150;	
;;
2) tag="inspirational"
   dump_web $tag
   strip_html
   dialog --clear\
   --backtitle "$BACKTITLE / Inspirational Quotes" \
   --title "$TITLE"\
   --textbox temp1.txt 20 150;    
;;
3) tag="books"
   dump_web $tag
   strip_html
   dialog --clear\
   --backtitle "$BACKTITLE / Books Quotes" \
   --title "$TITLE"\
   --textbox temp1.txt 20 150;     
;;
4) tag="life"
   dump_web $tag
   strip_html
   dialog --clear\
   --backtitle "$BACKTITLE / Life Quotes" \
   --title "$TITLE"\
   --textbox temp1.txt 20 150;   
;;
esac
elif [ "$?" -eq 1 ]; then

break;
fi
done  
}





############# Main ############
###############################




while [[ 1 ]]
do
TITLE="Main Menu"
OPTIONS=(
1 "Scrape Quotes"     
2 "Scrape Emails"         
3 "Scrape Links"         
4 "Scrape Some Random Things") ##Main Menu

 CHOICE=$(dialog --clear \
--backtitle "$BACKTITLE" \
--title "$TITLE" \
--menu "$MENU" \
$HEIGHT $WIDTH $CHOICE_HEIGHT \
"${OPTIONS[@]}" \
2>&1 >/dev/tty)
  
if [ "$?" -eq 0 ]; then 
case $CHOICE in     
1) quotes
;;
2) emailGui    
;;
3) linksGui    
;;
4)
    
;;
esac
elif [ "$?" -eq 1 ]; then 
          
dialog --title "Exit" \
--backtitle "$BACKTITLE / Exit" \
--infobox "Goodbye!" 3 20;
sleep 1.2;
clear;
exit 0;
fi
done  

gsetHyperLinks
emailGet

exit
