# zhihu_hotlist
原文地址 [zhuanlan.zhihu.com](https://zhuanlan.zhihu.com/p/463667802)

### （零）介绍

Github 之前就发布了 Actions，可以做非常多有意思的事情。笔者趁着过年放假简单尝试了一下，可以说是很好用，也很方便。

这个简单的尝试是定期保存知乎热榜列表。

![](https://pic2.zhimg.com/v2-10b7e7bf3803a1c5fb5a80aefdc20531_r.jpg)

源代码

[GitHub - AlainConnor/zhihu_hotlist](https://link.zhihu.com/?target=https%3A//github.com/AlainConnor/zhihu_hotlist)

### （一）热榜列表 API

通过浏览器抓包很容易得到这个热榜列表的 API

```
https://www.zhihu.com/api/v3/feed/topstory/hot-lists/total?limit=50&desktop=true

```

访问这个 url 可以得到当前时刻下热榜前 50 的内容，内容以 json 格式给出。

### （二）Python 解析热榜

利用 Python 可以方便的解析出热榜每个问题的标题和 id

```
import datetime
import requests

url = "https://www.zhihu.com/api/v3/feed/topstory/hot-lists/total?limit=50&desktop=true"
headers = {
        "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36",
}


now_time = datetime.datetime.now()
year = now_time.year
month = now_time.month
day = now_time.day
hour = now_time.hour


sess = requests.Session()
res = sess.get(url, headers=headers)
data = res.json()["data"]
#print(data)
hot_list = []
for item in data:
    item_id = item["target"]["id"]
    item_title = item["target"]["title"]
    hot_list.append("{}: {}".format(item_id, item_title))

output = "\n".join(hot_list)
with open("./hotlist/{}_{}_{}_{}.txt".format(year, month, day, hour), mode="w") as f:
    f.write(output)

```

保存下来的文件如下，当然也可以添加更多的格式，例如改为 Markdown 格式，可以将每个问题的 url 也加入进来。

![](https://pic2.zhimg.com/v2-3dbbbfbb66fbbaa2045c40e923160fb9_r.jpg)

### （三）Github Actions 代码

Github Actions 定义了一套执行流程，根据定义的流程，可以先启动 ubuntu 系统的 docker 镜像，拉取 github 仓库代码，执行抓取热榜列表的脚本，最后打包重新上传到 github 仓库。

1.  下载 github 仓库
2.  运行 start.sh 脚本
3.  把包含最新知乎热榜的文档作为仓库的一部分 push 到 github

```
name: 定时抓取

on:
  workflow_dispatch:
  schedule:
  - cron: '0 * * * *'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: run start.sh
        run: |
          bash ./start.sh
          
      - name: GitHub Push
        uses: ad-m/github-push-action@v0.6.0
        with:
          github_token: $\{{ secrets.GITHUB_TOKEN }}
          branch: main

```

### （四）start.sh 脚本

Github Actions 中的 start.sh 脚本的目的是不在 Github Actions 中编写过多的 shell 命令，把这些命令全都封装到一个 shel 脚本中。以后如果有修改的地方只需要修改 start.sh 就可以，不需要修改 Github Actions 脚本。

1.  运行 python 程序
2.  获取当前时间
3.  配置 git，name 和 email（随便配置一个就可以）
4.  提交当前的改动（就是 python 脚本的产物，当前小时的热榜 txt 文件）

```
python3 ./zhihu_crawler.py

year=`date +%Y `
month=`date +%m `
day=`date +%d `
hour=`date +%H`
now=$year-$month-$day-$hour


git config --global user.email ""
git config --global user.name "actioner"

git add .
git commit -m "$now"

```

### (五）视频演示

todo: 未来增加一下演示流程，主要是如何在 github 上进行操作。
