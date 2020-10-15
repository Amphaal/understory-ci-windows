FROM amphaal/base-docker-ci-mingw:latest
LABEL maintainer="guillaume.vara@gmail.com"

USER root
    #install requirements
    ADD https://raw.githubusercontent.com/Amphaal/understory/master/deps/msys2/pkglist_build.txt /
    RUN pacman -S --needed --noconfirm - < ./pkglist_build.txt

    RUN pacman -S --noconfirm --noprogressbar --needed imagemagick
    # RUN pacman -S --noconfirm --noprogressbar --needed protobuf 
    RUN pacman -U --noconfirm --noprogressbar --needed https://archive.archlinux.org/packages/p/protobuf/protobuf-3.12.3-1-x86_64.pkg.tar.zst
    
    # add to wrappers
    RUN echo "/mingw64/bin/corrade-rc.exe" > ./wine-wrappers/wrappersList.txt
    RUN cd wine-wrappers && rm -rf _gen && cmake -GNinja -B_gen -H. && ninja -C_gen install && cd ..

    CMD [ "/usr/bin/bash" ]
