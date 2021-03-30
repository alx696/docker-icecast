## 概要

https://icecast.org/

### 构建

```
$ docker build -t local/icecast .
```

### 运行

```
$ docker run -d --restart=always \
  --publish 8000:8000 \
  --name icecast local/icecast
```
> 访问 http://127.0.0.1:8000/admin/stats 查看是否能够打开.