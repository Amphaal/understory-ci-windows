FROM amphaal/base-docker-ci-mingw:latest
LABEL maintainer="guillaume.vara@gmail.com"

USER root
    #install requirements
    ADD https://raw.githubusercontent.com/Amphaal/understory/master/deps/msys2/pkglist_build.txt /
    RUN pacman -S --needed --noconfirm - < ./pkglist_build.txt

    RUN pacman -S --noconfirm --noprogressbar --needed imagemagick
    # RUN pacman -S --noconfirm --noprogressbar --needed protobuf 
    RUN pacman -U --noconfirm --noprogressbar --needed https://archive.archlinux.org/packages/p/protobuf/protobuf-3.12.3-1-x86_64.pkg.tar.zst

    CMD [ "/usr/bin/bash" ]
