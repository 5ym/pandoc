# pandoc-ja

日本語ドキュメントを **オプション無しで** 変換できる Pandoc コンテナ。

公式の [`pandoc/extra`](https://github.com/pandoc/dockerfiles) に **BIZ UD 明朝／ゴシック**（Morisawa, OFL）を組み込み、
日本語向けの既定値をイメージ内に焼き込んであります。
`--pdf-engine` も `-V CJKmainfont` も渡す必要はありません。

```console
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 仕様書.docx -o 仕様書.pdf
```

## Markdown 以外もそのまま入力にできる

Pandoc の本領は形式間の相互変換です。以下はすべて **追加オプション無し** で日本語 PDF になります。

```console
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 報告書.docx  -o 報告書.pdf   # Word
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest manual.html  -o manual.pdf   # HTML
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest spec.rst     -o spec.pdf     # reStructuredText
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 議事録.org    -o 議事録.pdf   # Org
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest paper.tex    -o paper.pdf    # LaTeX
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 部品表.csv    -o 部品表.pdf   # CSV
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 報告.typ      -o 報告.pdf     # Typst
```

出力先も同様に選べます。拡張子から自動判別されます。

```console
# Word 原稿を Markdown に落とし、画像は media/ に取り出す
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 仕様書.docx -o 仕様書.md --extract-media=media

# Sphinx の reST をレビュー用に Word 化
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest spec.rst -o spec.docx

# 社内 Wiki の HTML を EPUB に
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest manual.html -o manual.epub

# Jupyter ノートブックを配布用 PDF に
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest 解析.ipynb -o 解析.pdf
```

入力側で使える主な形式:

`docx` `odt` `pptx` `xlsx` `csv` `tsv` `html` `latex` `rst` `org` `typst` `epub` `ipynb`
`asciidoc` `mediawiki` `dokuwiki` `textile` `jira` `docbook` `jats` `man` `bibtex` `json` ほか

全一覧は `docker run --rm ghcr.io/5ym/pandoc:latest --list-input-formats` で確認できます。

## 収録物

| 種類 | 内容 |
| --- | --- |
| Pandoc | 3.10（`+server` `+lua` / Lua 5.4） |
| PDF エンジン | `xelatex`（既定）/ `lualatex` / `pdflatex` / `tectonic` |
| 日本語フォント | **BIZ UDP明朝** / **BIZ UDPゴシック**（各 Regular・Bold） |
| テンプレート | [Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template)（`eisvogel` / `eisvogel.beamer`） |
| フィルタ | `pandoc-crossref`、Lua フィルタ 20 種以上 |
| ベース | Ubuntu 24.04 / `pandoc/extra:latest-ubuntu` |

イメージ: `ghcr.io/5ym/pandoc:latest`（`linux/amd64` / `linux/arm64`）。ベース追従のため毎日再ビルドしています。

## 使い方

ENTRYPOINT が `pandoc --defaults=ja`、WORKDIR が `/data` です。
カレントディレクトリを `/data` にマウントして、`pandoc` の引数をそのまま渡します。

```console
docker run --rm -v "$(pwd):/data" -u "$(id -u):$(id -g)" ghcr.io/5ym/pandoc:latest 入力.docx -o 出力.pdf
```

`-u "$(id -u):$(id -g)"` を付けると、生成ファイルが root 所有にならず自分の権限で作られます。
毎回打つのが面倒なら alias にしておくと快適です。

```fish
# fish
alias pandoc 'docker run --rm -v "$PWD:/data" -u (id -u):(id -g) ghcr.io/5ym/pandoc:latest'
```

```bash
# bash / zsh
alias pandoc='docker run --rm -v "$PWD:/data" -u "$(id -u):$(id -g)" ghcr.io/5ym/pandoc:latest'
```

## 既定値と、その上書き

イメージ内の `/usr/local/share/pandoc/defaults/ja.yaml` が常に読み込まれます。

```yaml
pdf-engine: xelatex
metadata:
  CJKmainfont: BIZ UDPMincho
  CJKsansfont: BIZ UDPGothic
  CJKmonofont: BIZ UDPGothic
```

変更したいときはコマンドラインで指定してください。後から渡した値が優先されます。

```console
# 本文をゴシックにする
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest doc.md -o doc.pdf -V CJKmainfont="BIZ UDPGothic"

# 余白やフォントサイズを足す
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest doc.md -o doc.pdf -V geometry=margin=25mm -V fontsize=11pt
```

> [!NOTE]
> フォントの指定は `-V`（コマンドライン）でのみ上書きできます。
> 文書側の YAML メタデータに `CJKmainfont:` と書いても、イメージ内の既定値が優先されるため効きません。

プロジェクト固有の設定をまとめたい場合は、自前の defaults ファイルを併用できます。

```yaml
# defaults.yaml
variables:
  geometry: margin=25mm
  fontsize: 11pt
  documentclass: report
```

```console
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest doc.rst -o doc.pdf -d defaults.yaml
```

## そのほか

### Eisvogel テンプレート

```console
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest doc.md -o doc.pdf --template eisvogel
```

### 相互参照・Lua フィルタ

同梱フィルタは `/usr/local/share/pandoc/filters/` にあります。

```console
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest doc.md -o doc.pdf --filter pandoc-crossref
docker run --rm -v "$(pwd):/data" ghcr.io/5ym/pandoc:latest doc.md -o doc.pdf --lua-filter pagebreak.lua
```

### Docker Compose

```yaml
# compose.yaml
services:
  pandoc:
    image: ghcr.io/5ym/pandoc:latest
    volumes:
      - .:/data
    user: "${UID:-1000}:${GID:-1000}"
```

```console
docker compose run --rm pandoc 仕様書.docx -o 仕様書.pdf
```

### GitHub Actions

`container:` で使う場合は ENTRYPOINT が効かないため、`--defaults=ja` を明示します。

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: ghcr.io/5ym/pandoc:latest
    steps:
      - uses: actions/checkout@v4
      - run: pandoc --defaults=ja 仕様書.docx -o 仕様書.pdf
      - uses: actions/upload-artifact@v4
        with:
          name: doc
          path: 仕様書.pdf
```

### `pandoc` 以外のコマンドを実行する

```console
docker run --rm --entrypoint sh ghcr.io/5ym/pandoc:latest -c 'fc-list : family | grep BIZ'
```

## ビルド

フォントは Google Fonts から取得するため、リポジトリにバイナリは含まれていません。

```console
git clone https://github.com/5ym/pandoc.git
cd pandoc
docker build -t pandoc-ja .
```

フォントを差し替えるときは `Dockerfile` の取得リストと `ja.yaml` のフォント名を変更してください。

## 既知の制限

`--pdf-engine=lualatex` は使えません。LuaTeX-ja の既定和文フォントである Harano Aji が
イメージに含まれておらず、`HaranoAjiMincho-Regular.otf not loadable` で失敗します。
既定の `xelatex` を使ってください。

## ライセンス

- BIZ UDPMincho / BIZ UDPGothic: SIL Open Font License 1.1 （© Morisawa Inc.）
- Pandoc / TeX Live 等の同梱物は各々のライセンスに従います。
