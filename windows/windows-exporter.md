# 安裝windows_exporter
 
## 前提
1. 使用 windows_exporter 可以非常方便地給 prometheus 增加監控 windows server 的能力。
2. 通常情況下只需使用預設配置就可以監控 CPU，記憶體，網路，服務了。
3. 默認監聽埠是9182。
4. 默認採集指標：cpu、cpu_info、memory、process、tcp、cs、logical_disk、net、os、system、textfile、time。
5. windows_exporter supports  Windows Server versions 2008R2 and later, and desktop Windows version 7 and later.

## WINDOWS 主機安裝windows_exporter
1. 自行定義要收集的資訊
```yml
## filename: config.yml ##
collectors:
  enabled: defaults
collector:
  service:
    services-where: "Name='windows_exporter'"
log:
  level: warn
```

2.	設定windows_exporter 為windows 服務
- 移除windows 服務
```
sc delete "windows_exporter"
```

- 設定windows_exporter 為windows 服務
```
sc create windows_exporter binpath="D:\windows_exporter\windows_exporter-0.20.0-amd64.exe --config.file=D:\windows_exporter\config.yml"  type=own start=auto displayname=windows_exporter
```
服務可以檢視到有windows_exporter，請記得啟動。

- 確認Exporter是否正常工作。即執行命令curl localhost:{監聽埠}/metrics或者通過流覽器訪問localhost:{監聽埠}/metrics，觀察是否有正常的Prometheus Metric返回。如果有正常的Metric返回，說明Exporter已正常工作。 
http://127.0.0.1:9182/metrics
