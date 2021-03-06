FROM pandoc/latex
LABEL org.opencontainers.image.source https://github.com/5ym/pandoc
RUN tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet && tlmgr update --self && \
    tlmgr install ctex footnotebackref mdframed zref needspace sourcesanspro sourcecodepro titling pagecolor && \
    wget https://noto-website.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip && mkdir -p /usr/share/fonts/NotoSerifCJKjp && \
    unzip NotoSerifCJKjp-hinted.zip -d /usr/share/fonts/NotoSerifCJKjp/ && rm NotoSerifCJKjp-hinted.zip && fc-cache -fv && \
    mkdir -p /root/.local/share/pandoc/templates && \
    wget https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex -O /root/.local/share/pandoc/templates/eisvogel.latex && \
    apk add --no-cache yarn && yarn global add markdownlint-cli2
