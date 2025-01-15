FROM pandoc/extra:latest-ubuntu
LABEL org.opencontainers.image.source=https://github.com/5ym/pandoc
COPY *.ttf /usr/share/fonts/BIZUDPMincho/
RUN fc-cache -fv && apt -y install npm && npm i -g markdownlint-cli2
