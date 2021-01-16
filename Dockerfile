FROM amphaal/base-docker-ci-mingw:latest
LABEL maintainer="guillaume.vara@gmail.com"

USER root
    #install requirements
    ADD https://raw.githubusercontent.com/Amphaal/understory/master/prerequisites/msys2/pkglist_build.txt /
    RUN pacman -S --needed --noconfirm - < ./pkglist_build.txt

    RUN pacman -S --noconfirm --noprogressbar --needed imagemagick
    RUN pacman -S --noconfirm --noprogressbar --needed protobuf 
    
    # add to wrappers
    RUN echo "/mingw64/bin/corrade-rc.exe" > ./wine-wrappers/wrappersList.txt
    RUN cd wine-wrappers && rm -rf _gen && cmake -GNinja -B_gen -H. && ninja -C_gen install && cd ..
    
    #
    COPY ./CPackIFW.cmake /usr/share/cmake-3.19/Modules/CPackIFW.cmake
    
    #
    RUN pacman -S --noconfirm --noprogressbar --needed winetricks xorg-server-xvfb
    RUN rm -r -f ~/.wine

USER devel
    RUN WINEARCH=win32 WINEPREFIX=~/.wine wine wineboot
    RUN winetricks allfonts
    RUN export DISPLAY=:0.0 # Select screen 0.
    
    #
    CMD [ "/usr/bin/bash" ]
