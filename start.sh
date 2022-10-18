python3 ./zhihu_crawler.py

year=`date +%Y `
month=`date +%m `
day=`date +%d `
hour=`date +%H`
min=`date +%M`
now=$year-$month-$day-$hour-$min


git config --global user.email "13538898378@163.com"
git config --global user.name "hankangwen"

git add .
git commit -m "$now"
