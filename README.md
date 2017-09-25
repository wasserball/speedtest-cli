# Docker Speedtest with intervall
---

This Docker-Image runs the [speedtest-cli](https://github.com/sivel/speedtest-cli) every `n` seconds (environment var: `RUNEVERYNMINUTES`)

Default Vale ist set to 3600 seconds (= 1h) (`entrypoint.sh`)

The speedtest-cli config is set to `--csv`, so it logs all data as csv-string with an `,` as delimiter.


example usage:

```
version: '2'
services:
  speedtest:
    build: .
    environment:
      RUNEVERYNMINUTES: 3600
    volumes:
    - /etc/localtime:/etc/localtime:ro
```




---


you can also use the automated build `wasserball/speedtest-cli`

```
version: '2'
services:
  speedtest:
    image: wasserball/speedtest-cli
    environment:
      RUNEVERYNMINUTES: 3600
    volumes:
    - /etc/localtime:/etc/localtime:ro
```


