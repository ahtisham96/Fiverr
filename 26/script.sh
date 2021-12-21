#/bin/bash

str1="RewriteRule ^site_1/admin$ site_2/formula.php [NC,QSA,L]" # string pattern one
str2='Files ~ "\.(env|env.test|gitignore|gitattributes)|composer.json|composer.lock|composer.phar|docker-compose.yml|symfony.lock|azure-pipelines.yml|README.md|phinx.yml$">
    Order allow,deny
    Deny from all
</Files>' # string pattern two

var1=`cat htaccess_content.txt | grep -F "$str1" | wc -l` # check whether str1 exists in a file or not
var2=`cat htaccess_content.txt | grep -F "$str2" | wc -l`  # check whether str2 exists in a file or not

if (( var1>=1 && var2>=4 )) # check if both strings are exits in a file
then
    echo "1" # If both strings exists in a file then it will display 1
else
    echo "0" # If both strings not exists in a file then it will display 0
fi
