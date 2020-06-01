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

    #install requirements
    ADD https://raw.githubusercontent.com/Amphaal/understory/master/deps/msys2/pkglist_build.txt /
    ADD https://raw.githubusercontent.com/Amphaal/understory/master/deps/msys2/pkglist_dev.txt /
    RUN pacman -S --needed --noconfirm - < ./pkglist_build.txt
    RUN pacman -S --needed --noconfirm - < ./pkglist_dev.txt
  
    #rename header files
    RUN cd /mingw64/x86_64-w64-mingw32/include \ 
        && cp ntsecapi.h NTSecAPI.h
    
    CMD [ "/usr/bin/bash" ]
