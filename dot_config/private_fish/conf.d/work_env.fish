set -x GOPROXY https://proxy.golang.org
set -x GOPRIVATE '*.pnet.ch'
set -x http_proxy http://localhost:9999
set -x https_proxy http://localhost:9999
set -x no_proxy .pnet.ch,.pfin.ch,plabpf,localhost
