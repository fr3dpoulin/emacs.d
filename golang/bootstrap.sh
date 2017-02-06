#!/bin/sh

go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/golang/lint/golint
go get -u -v github.com/kisielk/errcheck
go get -u -v github.com/mdempsky/unconvert
go get -u -v golang.org/x/tools/cmd/guru
go get -u -v github.com/nsf/gocode
go get -u -v github.com/josharian/impl
go get -u -v golang.org/x/tools/cmd/godoc
go get -u -v github.com/godoctor/godoctor

case "$(uname -s)" in

    Darwin)
       brew install go-delve/delve/delve
       ;;

    *)
       go get -v github.com/derekparker/delve/cmd/dlv
       ;;
esac
