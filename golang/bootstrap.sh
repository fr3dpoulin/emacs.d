#!/bin/sh

go get -u golang.org/x/tools/cmd/goimports
go get -u github.com/rogpeppe/godef
go get -u github.com/golang/lint/golint
go get -u github.com/kisielk/errcheck
go get -u github.com/mdempsky/unconvert
go get -u golang.org/x/tools/cmd/guru
go get -u github.com/nsf/gocode
go get -u github.com/josharian/impl
go get -u golang.org/x/tools/cmd/godoc
go get -u github.com/godoctor/godoctor
go get -u github.com/jstemmer/gotags
go get -u github.com/golang/mock/gomock
go get -u github.com/golang/mock/mockgen
go get -u github.com/Masterminds/glide
go get -u github.com/motemen/gore
go get -u github.com/aarzilli/gdlv

case "$(uname -s)" in

    Darwin)
       brew install go-delve/delve/delve
       ;;

    *)
       go get -v github.com/derekparker/delve/cmd/dlv
       ;;
esac
