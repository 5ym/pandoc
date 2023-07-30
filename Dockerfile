FROM pandoc/extra
LABEL org.opencontainers.image.source https://github.com/5ym/pandoc
RUN wget -O font.zip https://fonts.google.com/download?family=BIZ%20UDPMincho && mkdir -p /usr/share/fonts/BIZUDPMincho && \
    unzip font.zip -d /usr/share/fonts/BIZUDPMincho/ && rm font.zip && fc-cache -fv && \
    apk add --no-cache npm && npm i -g markdownlint-cli2
