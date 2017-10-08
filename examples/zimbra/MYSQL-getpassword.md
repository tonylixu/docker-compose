###How to Retrieve MySQL password
```bash
$ su - zimbra
$ zmlocalconfig -s | grep mysql | grep password
```
The output will look something like this:
```bash
mysql_logger_root_password = AWHZ60JYaBw8_hVkA9NDVGh0irmp7xVz
mysql_root_password = lkAd7vkYI.Q_VeWt8uyL9kj0
zimbra_logger_mysql_password = 2iiyAVj3GeH0akkCe6M1o_HvY
zimbra_mysql_password = uMv4EsNqPZdK5htERx97VY5m
```
