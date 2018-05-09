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
go get -u -v github.com/jstemmer/gotags
go get -u -v github.com/golang/mock/gomock
go get -u -v github.com/golang/mock/mockgen
go get -u -v github.com/Masterminds/glide
go get -u -v github.com/motemen/gore
go get -u -v github.com/aarzilli/gdlv
go get -u -v github.com/ramya-rao-a/go-outline
go get -u -v github.com/acroca/go-symbols
go get -u -v github.com/zmb3/gogetdoc
go get -u -v github.com/fatih/gomodifytags
go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v sourcegraph.com/sqs/goreturns
go get -u -v github.com/cweill/gotests/...
go get -u -v github.com/haya14busa/goplay/cmd/goplay
go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct


case "$(uname -s)" in

    Darwin)
        brew install go-delve/delve/delve
        brew install glide
        ;;

    *)
        go get -v github.com/derekparker/delve/cmd/dlv
        curl https://glide.sh/get | sh
        ;;
esac
