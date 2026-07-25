#import "../../lib/theme.typ": *
#import "../../lib/templates.typ": *
#import "../../lib/config.typ": presentation-config
#import "@preview/fontawesome:0.6.1": *

#show: rose-pine-theme.with(
  aspect-ratio: "16-9",
  presentation-config,
)

#title-slide(
  title: [コンポーネント名には \ 何を含めるべきなのか？],
  author: [airRnot / \@airRnot1106],
  date: [2026/07/27],
  venue: [\#雑LT_study],
  notes: [それでは発表をはじめます。タイトルは「コンポーネント名には \ 何を含めるべきなのか？」です。よろしくお願いいたします。],
)

#self-intro-slide(
  name: "airRnot",
  items: (
    [24卒],
    [フロントエンドエンジニア],
    [Next.jsとNeovimとNixが好き],
    [#fa-x-twitter(): \@airRnot1106],
    [#fa-github(): \@airRnot1106],
  ),
  icon: "/assets/rabbirnot-v2-wave-bg-padding-1024.webp",
  notes: [airRnotと申します。24卒で、主にフロントエンドエンジニアをやっています。普段はNext.jsやNeovimやNixが好きでよく触っています。],
)

#focus-slide[
  #text(1.5em)[突然ですが……]
]

#centered-slide[
  #image("assets/gojuon_chart_missing_su.png", height: 80%)
  #text(
    1.2em,
  )[#alternatives[これは何でしょう？][（ヒント: 「す」が「ない」から……👍）]]
]

#centered-slide[
  #text(2.3em)[正解は……]
]

#centered-slide[
  #image("assets/gojuon_chart_missing_su.png", height: 75%)
  #text(fill: color-love, size: 1.5em)[「す」がない五十音表]
]

#centered-slide[
  #text(2.3em)[え、ナイス？？]
]

#centered-slide[
  #text(2.0em)[
    コンポーネント名を考えるとき、
    これを「ナイス」ではなく\
    「#h(0.15em)『す』がない五十音表」と\
    捉えられる感覚が重要！！
  ]
]

#focus-slide[
  #text(1.5em)[つまり……？]
]

#centered-slide[
  #text(2.0em)[
    命名に必要なのは、\
    連想する能力ではなく\
    物事のありのままの\
    #text(fill: color-love)[性質・依存関係を見抜く能力]
  ]
]

= 命名の話
== 命名とは？

コンテキストが持つ概念を明らかにし、一定の順序で並べること

コンポーネントだと……

#grid(
  columns: (1fr, auto),
  column-gutter: 0em,
  align: horizon,
  [
    #text(fill: color-love)[コメント]を #text(fill: color-love)[投稿する] #text(fill: color-love)[フォーム]

    - コメント: 関心
    - 投稿する: 状況
    - フォーム: 基礎

    3つの概念によって構成されている
  ],
  image("assets/comment-form-ui.png", height: 50%),
)

---

すべてのコンポーネントは、以下の4種類のいずれかに分類できる

#grid(
  columns: (auto, auto, auto),
  column-gutter: 0.5em,
  row-gutter: 1.2em,
  align: horizon,
  [• 基礎], [:], [アイコン],
  [• 状況 + 基礎], [:], [検索アイコン],
  [• 関心 + 基礎], [:], [ユーザーアイコン],
  [• 関心 + 状況 + 基礎], [:], [ユーザーを検索するアイコン],
)

---

特に重要なのは#text(fill: color-love)[基礎]

基礎とは、UIとしての型で、基礎的な機能そのものを指す

フォーム / ボタン / テキストボックス / ダイアログ / ドロップダウン / タブ / スライダー / カレンダー / チェックボックス / ラジオボタン / トグルスイッチ / プログレスバー / スピナー / ツールチップ / ポップオーバー / アコーディオン / カード / リスト / テーブル / サイドバー / フッター / etc...

---

曖昧なコンポーネント名には、基礎が含まれていないことが多い

～Info / ～Pickup / ～Result

#v(1em)

→ UIの型を捉えて、コンポーネント名に反映させよう

～InfoBar / ～PickupList / ～ResultCard

#v(2em)

「捉えて、反映させる」 ―― これが#text(fill: color-love)[命名の肝]！

---

関心と状況も同様

コンポーネントは、すでにそれらを持っている

コンポーネント名は#text(fill: color-love, size: 1.2em)[決めるもの]ではなく

その性質や依存によって勝手に#text(fill: color-love, size: 1.2em)[決まるもの]

我々はその#text(fill: color-love)[名前]を#text(fill: color-love)[明らか]にするだけ

#v(1em)

#text(fill: color-love, size: 1.2em)[命名]ではなく、#text(fill: color-love, size: 1.2em)[明名]しよう！

== 明名とは？

コンテキストが持つ概念を明らかにし、一定の順序で並べること

#v(1.5em)

#align(center)[
  #image("assets/bcd-design-ogp.jpg", height: 45%)

  より詳しい解説は、こちらの記事をご覧ください
]
