FROM pandoc/extra:latest-ubuntu
LABEL org.opencontainers.image.source=https://github.com/5ym/pandoc

# BIZ UD 明朝／ゴシック（Morisawa, SIL OFL 1.1）を Google Fonts から取得する
ARG GOOGLE_FONTS=https://raw.githubusercontent.com/google/fonts/main/ofl
RUN set -eux; \
    mkdir -p /usr/share/fonts/truetype/bizud; \
    for f in bizudpmincho/BIZUDPMincho-Regular.ttf \
             bizudpmincho/BIZUDPMincho-Bold.ttf \
             bizudpgothic/BIZUDPGothic-Regular.ttf \
             bizudpgothic/BIZUDPGothic-Bold.ttf \
             bizudpmincho/OFL.txt; do \
        wget -q -O "/usr/share/fonts/truetype/bizud/${f##*/}" "${GOOGLE_FONTS}/${f}"; \
    done; \
    fc-cache -f

# 日本語向けの既定値を常に読み込ませる。
# 利用者は --pdf-engine も -V CJKmainfont も渡さなくてよい。
COPY ja.yaml /usr/local/share/pandoc/defaults/ja.yaml
ENTRYPOINT ["/usr/local/bin/pandoc", "--defaults=ja"]
