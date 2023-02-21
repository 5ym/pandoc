FROM pandoc/latex
LABEL org.opencontainers.image.source https://github.com/5ym/pandoc
RUN tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet && tlmgr update --self && \
    tlmgr install anysize beamer booktabs breqn caption cite cmap crop ctable eso-pic euenc euler etoolbox extsizes fancybox fancyref fancyvrb filehook float fontspec fp index jknapltx koma-script latexbug l3experimental l3kernel l3packages lineno listings lwarp mathspec mathtools mdwtools memoir metalogo microtype ms ntgclass parskip pdfpages polyglossia powerdot psfrag rcs sansmath section seminar sepnum setspace subfig textcase thumbpdf translator typehtml ucharcat underscore unicode-math xcolor xkeyval xltxtra xunicode \
    adjustbox babel-german background bidi collectbox csquotes everypage filehook footmisc footnotebackref framed fvextra letltxmacro ly1 mdframed mweights needspace pagecolor sourcecodepro sourcesanspro titling ucharcat ulem unicode-math upquote xecjk xurl zref && \
    wget -O font.zip https://fonts.google.com/download?family=BIZ%20UDPMincho && mkdir -p /usr/share/fonts/BIZUDPMincho && \
    unzip font.zip -d /usr/share/fonts/BIZUDPMincho/ && rm font.zip && fc-cache -fv && \
    mkdir -p /root/.local/share/pandoc/templates && \
    wget https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex -O /root/.local/share/pandoc/templates/eisvogel.latex && \
    apk add --no-cache yarn && yarn global add markdownlint-cli2
