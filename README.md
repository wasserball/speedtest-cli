# Docker Speedtest with intervall
---

This Docker-Image runs the [speedtest-cli](https://github.com/sivel/speedtest-cli) every `n` seconds (environment var: `RUNEVERYNMINUTES`)

Default Vale ist set to 3600 seconds (= 1h) (`entrypoint.sh`)

Default Timezone is `Europe/Vienna` and can be overwritten with env variable `TIMEZONE` [List of timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

The speedtest-cli config is set to `--csv`, so it logs all data as csv-string with an `,` as delimiter.

The data is also stored at `/data/YYYY-mm.csv` (2018-03)

example usage:

```
version: '2'
services:
  speedtest:
    build: .
    environment:
      RUNEVERYNMINUTES: 3600
      TIMEZONE: Europe/Berlin
    volumes:
    - /data:/data
```
---


you can also use the automated build `wasserball/speedtest-cli`

```
version: '2'
services:
  speedtest:
    image: wasserball/speedtest-cli
    environment:
    ...
```


The Timestamp in the CSV-Logs will be converted from `ISO 8601` (UTC). [GitHub Issue](https://github.com/sivel/speedtest-cli/issues/387)
to the set Timezone (Default: `Europe/Vienna`)

example Log:

```
Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload
15172,Onstage Online GmbH,Vienna,2018-03-09T10:07:17,24.86830370112717,60.322,63943829.30772706,27338437.520875335
```

##Visualisation
After every Speedtest, a PDF is created witch you can found under `/data/YYYY-mm.pdf`

![visualisation.png](img/result.png "Speedtest")
