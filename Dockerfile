FROM amphaal/rpgrpz-docker-ci:latest
LABEL maintainer="guillaume.vara@gmail.com"

USER root
    #add multilib mirrorlist (for wine)
    RUN echo "[multilib]" >> /etc/pacman.conf \
        && echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf \
        && echo "" >> /etc/pacman.conf
        
    #add msys2 mirrorlist
    RUN echo "[mingw64]"  >> /etc/pacman.conf \
        && echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf \
        && echo "Server = http://repo.msys2.org/mingw/x86_64/" >> /etc/pacman.conf \
        && echo "Server = https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/" >> /etc/pacman.conf \
        && echo "Server = http://www2.futureware.at/~nickoe/msys2-mirror/mingw/x86_64/" >> /etc/pacman.conf \
        && echo "Server = https://mirror.yandex.ru/mirrors/msys2/mingw/x86_64/" >> /etc/pacman.conf
    
    # update mirrorlist
    RUN pacman -Syyu --needed --noconfirm
    
    #install wine
    RUN pacman -S --noconfirm --noprogressbar --needed wine
    
    # setup wine
    ENV WINEDEBUG=fixme-all
    ENV WINEARCH=win64
    ENV WINEPATH=/mingw64/bin
    RUN winecfg

USER devel
    RUN winecfg

USER root
    RUN pacman -S --needed --noconfirm mingw64/mingw-w64-x86_64-crt
    RUN pacman -S --needed --noconfirm mingw64/mingw-w64-x86_64-gcc
    RUN pacman -S --needed --noconfirm mingw64/mingw-w64-x86_64-binutils
    
    RUN pacman -S --needed --noconfirm mingw64/mingw-w64-x86_64-qt-installer-framework

    #install requirements
    ADD https://raw.githubusercontent.com/Amphaal/understory/master/deps/msys2/pkglist_build.txt /
    RUN pacman -S --needed --noconfirm - < ./pkglist_build.txt

    RUN pacman -S --noconfirm --noprogressbar --needed imagemagick
    RUN pacman -U --noconfirm --noprogressbar --needed https://archive.archlinux.org/packages/p/protobuf/protobuf-3.11.4-1-x86_64.pkg.tar.zst
    
    # generate wrapper
    COPY wine-wrappers /wine-wrappers
    RUN cd wine-wrappers && cmake -GNinja -B_gen -H. && ninja -C_gen install

    CMD [ "/usr/bin/bash" ]
