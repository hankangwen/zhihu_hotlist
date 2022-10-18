python3 ./zhihu_crawler.py

year=`date +%Y `
month=`date +%m `
day=`date +%d `
hour=`date +%H`
now=$year-$month-$day-$hour


git config --global user.email "1397796710@qq.com"
git config --global user.name "hankangwen"

git add .
git commit -m "$now"
