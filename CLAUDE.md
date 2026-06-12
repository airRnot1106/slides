# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Typst スライド集を Nix flake で管理するリポジトリ。各スライドは `slides/<name>/main.typ`、共通テーマは `lib/`。ビルドは [typix](https://github.com/loqusion/typix) を利用。

## Commands

- `nix run .#build` — fzf でデッキを選び、`slides/<name>/dist/` に配布用 `<name>.pdf` と発表用 `<name>-presentation.pdf` を出力
- `nix run .#watch` — fzf でデッキを選び、変更監視して再コンパイル。**リポジトリルートから実行**すること（出力先が相対パス）
- `nix run .#present` — fzf でデッキを選び、発表用 PDF を pympress で表示（先に `build` で生成しておく）
- `nix build .#<deck>` — そのデッキの配布用 PDF を `./result`（store 上の単一ファイル）として生成。デッキの検証として利用する
- `nix flake check` — **全デッキのビルド + pre-commit フック一式を実行する主要ゲート**（CI と同じ）。「1デッキだけ確認」は `nix build .#<deck>`
- `nix fmt` — treefmt
