#import "../../lib/theme.typ": *
#import "../../lib/templates.typ": *
#import "../../lib/config.typ": presentation-config
#import "@preview/fontawesome:0.6.1": *

#show: rose-pine-theme.with(
  aspect-ratio: "16-9",
  presentation-config,
)

#title-slide(
  title: [コンポーネント命名入門],
  author: [airRnot / \@airRnot1106],
  date: [2026/09/04],
  venue: [新卒N年目のLT交流会 \#5],
  notes: [それでは発表をはじめます。タイトルは「コンポーネント命名入門」です。よろしくお願いいたします。],
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

#focus-slide(notes: [早速ですが、皆さん命名はお好きでしょうか？])[
  #text(1.5em)[命名、好きですか？]
]

#focus-slide(
  notes: [ちなみに私は大好きで、フロントエンドで一番楽しいのは命名だと言っても差し支えないかもしれません。],
)[
  #text(1.5em)[わたしは大好きです]
]

== 今日持ち帰れるもの

- 命名に必要な考え方
  - 一貫性と対称性
- 実際に命名するためのテクニック
  - 「何の何をどうするUI」のフレーズ

#speaker-note[
  ということで、今日持ち帰れるものは、大きく2つあります。1つ目は命名に必要な考え方で、命名の一貫性と対称性についての話をします。2つ目は実際に命名するためのテクニックで、「何の何をどうするUI」というフレーズを使った命名の方法について話します。
]

= 命名に必要な考え方
== 一貫性

*名前を構成している概念が、一定の順序で並んでいること*

関心 -> 状況 -> 基礎

例: ユーザーを追加するアイコン（`user-add-icon`）

- 関心: ユーザー
- 状況: 追加する
- 基礎: アイコン

#speaker-note[
  まずは命名に必要な考え方の1つ目、一貫性についてです。一貫性とは、名前を構成している概念が、一定の順序で並んでいることを指します。コンポーネントだと3つの概念で構成されていて、それは関心・状況・基礎になります。例えば「ユーザーを追加するアイコン」というコンポーネントは、関心である「ユーザー」、状況である「追加する」、基礎である「アイコン」で構成されていて、これを実際のコンポーネント名にすると`user-add-icon`になります。
]

---

命名パターンは以下の4種類に分類できる

#let rp-base = rgb("#faf4ed")
#let rp-surface = rgb("#fffaf3")
#let rp-subtle = rgb("#797593")
#let rp-text = rgb("#575279")
#let rp-gold = rgb("#ea9d34")
#let rp-pine = rgb("#286983")
#let rp-foam = rgb("#56949f")
#let rp-highlight-med = rgb("#dfdad9")

#let c-border = rp-highlight-med
#let c-muted = rp-subtle
#let c-fg = rp-text
#let c-bg = rp-surface
#let c-panel-bg = rp-base

#let c-blue = rp-pine   // Domain / User(関心)
#let c-green = rp-foam   // Case / Search(状況)
#let c-amber = rp-gold   // Base / Icon(基礎)

// ---------- name box ----------
#let namebox(
  label,
  accent,
  width: 140pt,
  height: 42pt,
  text-size: 1em,
  offset: 6pt,
) = box(
  width: width,
  height: height,
  fill: c-bg,
  stroke: 1pt + c-border,
  radius: 8pt,
  inset: 0pt,
)[
  #align(center + horizon)[
    // #box(width: 6pt, height: 6pt, fill: accent, radius: 100%)
    #h(offset)
    #text(fill: c-fg, size: text-size)[#label]
  ]
]

#let sign(s) = align(center + horizon, text(size: 16pt, fill: c-muted)[#s])

// ---------- インライン要素にルビを振る ----------
#let rubytext(base, ruby) = box[
  #set align(center)
  #stack(
    dir: ttb,
    spacing: 4pt,
    text(size: 0.65em, fill: c-muted)[#ruby],
    base,
  )
]

// ---------- 幅の狭い箇所向けの小さいタグ ----------
#let tag(label, accent) = box(
  fill: c-bg,
  stroke: 1pt + c-border,
  radius: 6pt,
  inset: (x: 6pt, y: 3pt),
)[
  #text(fill: c-fg, size: 11pt)[#label]
]

// ---------- icons(実アセットのSVGを使用) ----------
#let icon-slot(path) = box(
  width: 42pt,
  height: 42pt,
  fill: c-bg,
  stroke: 1pt + c-border,
  radius: 8pt,
  align(center + horizon, image(path, width: 80%)),
)

// 基礎: icon.svg
// 状況 -> 基礎: add_icon.svg
// 関心 -> 基礎: user_icon.svg
// 関心 -> 状況 -> 基礎: user_add_icon.svg
#let icon-base = "assets/icon.svg"
#let icon-search = "assets/add_icon.svg"
#let icon-user = "assets/user_icon.svg"
#let icon-user-search = "assets/user_add_icon.svg"

// ---------- 図解本体を関数化 ----------
#let naming-diagram() = {
  let cols = (140pt, 22pt, 140pt, 22pt, 140pt, 22pt, 56pt)
  box(fill: c-panel-bg, radius: 16pt, inset: 12pt, stroke: 1pt + c-border)[
    #table(
      columns: cols,
      align: center + horizon,
      stroke: none,
      column-gutter: 6pt,
      row-gutter: 1pt,

      namebox("関心", c-blue), [], namebox("状況", c-green), [], namebox(
        "基礎",
        c-amber,
      ), [], [],

      table.cell(colspan: 7)[#line(length: 100%, stroke: 1pt + c-border)],

      // 基礎: アイコン
      [], [], [], [], namebox("アイコン", c-amber), sign("="), icon-slot(
        icon-base,
      ),

      // 状況 -> 基礎: 追加する + アイコン
      [], [], namebox("追加する", c-green), sign("+"), namebox(
        "アイコン",
        c-amber,
      ), sign("="), icon-slot(icon-search),

      // 関心 -> 基礎: ユーザー + アイコン
      namebox("ユーザー", c-blue), table.cell(colspan: 3, sign("+")), namebox(
        "アイコン",
        c-amber,
      ), sign("="), icon-slot(icon-user),

      // 関心 -> 状況 -> 基礎: ユーザー + 追加する + アイコン
      namebox("ユーザーを", c-blue), sign("+"), namebox(
        "追加する",
        c-green,
      ), sign("+"), namebox("アイコン", c-amber), sign("="), icon-slot(
        icon-user-search,
      ),
    )
  ]
}

#naming-diagram()

#speaker-note[
  命名パターンはこの4種類に分類できます。1つ目は基礎だけで構成されているコンポーネントで、アイコンとか、ボタンとかフォームとかが該当します。2つ目が状況と基礎で構成されているコンポーネントで、例えば追加するアイコンとかが該当します。3つ目が関心と基礎で構成されているコンポーネントで、これはユーザーアイコンとかですね。で、4つ目が関心と状況と基礎を全て含まれているコンポーネントで、ユーザーを追加するアイコンが当てはまります。
]

---

❌ `add-user-icon`のように順番が入れ替わってはいけない

⚠ 関心と状況は抜ける場合がある

⚠ 基礎は必ず存在する

== 対称性
*同じ粒度のコンポーネントが、同じ密度の名前になっていること*

#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  [名前の密度:],
  [関心・状況・基礎のうち、いくつの概念が \ 名前に含まれているか],
)

#v(2em)

- フォーム（`form`）: 密度1
- コメントフォーム（`comment-form`）: 密度2

---

新たに「コメントを編集するフォーム」を追加することになりました

`comment-edit-form`: 密度3

#v(1em)

しかし、#rubytext(`comment-form`, [投稿するフォーム])と#rubytext(`comment-edit-form`, [編集するフォーム])は \ 役割が対称的なので密度も揃えたい

`comment-post-form`とすることで、密度が3になり対称的になった

#speaker-note[
  ここで、新たに「コメントを編集するフォーム」を追加することになりました。これまでの話に基づくと、コンポーネント名は`comment-edit-form`になります。そして、関心・状況・基礎のすべての概念を含んでいるため、密度は3となります。ですが、`comment-form`と`comment-edit-form`は投稿するフォームと編集するフォームなので、役割が対称的になっていることが分かります。なので、密度も揃えたいということですね。`comment-form`というのは、ちゃんと意味を捉えるとコメントを投稿するフォームになっていて、暗黙的な状況が含まれています。そこで、`comment-post-form`とすることで、密度が3になり対称的になりました。
]

---

#par(
  hanging-indent: 1.4em,
)[⚠ 暗黙的な状況の概念をしっかりと名前に含めることが重要]

#par(
  hanging-indent: 1.4em,
)[⚠ 後から類似のコンポーネントがでてきたときに、 \ 密度が揃えられるように気をつける]

#par(hanging-indent: 1.4em)[⚠ 名前の密度は最初からできるだけ大きくする]

= 実際に命名するための \ テクニック
== 何の何をどうするUI

*簡単に一貫性と対称性を保った命名をするためのフレーズ*

#v(1em)

実はもうやってます！

#v(0.5em)

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center + horizon,
    stroke: none,
    column-gutter: 0.6em,
    row-gutter: 0.6em,
    namebox("何を", c-blue),
    namebox("どうする", c-green),
    namebox("UI", c-amber),

    [「ユーザー」を], [「追加」する], [「アイコン」],
    [「コメント」を], [「投稿」する], [「フォーム」],
  )
]

コンポーネントを見かけたら、このフレーズに沿って命名してみよう

---

練習問題

#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  [#image("assets/site_theme_switch_dropdown.png", height: 50%)],
  [
    #set text(size: 20pt)
    #table(
      columns: (auto, auto, auto, auto),
      align: center + horizon,
      stroke: none,
      column-gutter: 0.4em,
      row-gutter: 0.4em,
      namebox(
        "何の",
        c-blue,
        width: 74pt,
        height: 26pt,
        text-size: 14pt,
        offset: 0pt,
      ),
      namebox(
        "何を",
        c-blue,
        width: 74pt,
        height: 26pt,
        text-size: 14pt,
        offset: 0pt,
      ),
      namebox(
        "どうする",
        c-green,
        width: 94pt,
        height: 26pt,
        text-size: 14pt,
        offset: 0pt,
      ),
      namebox(
        "UI",
        c-amber,
        width: 90pt,
        height: 26pt,
        text-size: 14pt,
        offset: 0pt,
      ),

      [サイトの], [テーマを], [切替する], [ドロップ \ ダウン],
    )
    #v(0.5em)
    #align(center)[#text(size: 28pt)[`site_theme-switch-dropdown`]]
  ],
)

---

練習問題

#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  [#image("assets/past_event_list.png", height: 70%)],
  [
    #set text(size: 22pt)
    #table(
      columns: (auto, auto, auto),
      align: center + horizon,
      stroke: none,
      column-gutter: 0.4em,
      row-gutter: 0.4em,
      namebox(
        "何を",
        c-blue,
        width: 106pt,
        height: 28pt,
        text-size: 18pt,
        offset: 0pt,
      ),
      namebox(
        "どうする",
        c-green,
        width: 118pt,
        height: 28pt,
        text-size: 18pt,
        offset: 0pt,
      ),
      namebox(
        "UI",
        c-amber,
        width: 86pt,
        height: 28pt,
        text-size: 18pt,
        offset: 0pt,
      ),

      [終了した \ イベントを], [表示する], [リスト],
    )
    #v(0.5em)
    #align(center)[#text(size: 28pt)[`past_event-list`]]
    #v(1em)
    #text(size: 18pt)[⚠ 「表示する」は情報量が無いので省略可能]
  ],
)

== まとめ

- コンポーネント名は*関心*・*状況*・*基礎*の概念で構成されている
- 命名は*一貫性*と*対称性*を意識する
- いきなり英語で命名するのではなく、まずは \ 「何の何をどうするUI」のフレーズに沿って*日本語*で命名してみる

== 参考文献

- #link(
    "https://qiita.com/misuken/items/19f9f603ab165e228fe1",
  )[BCD Design によるコンポーネントの分類] \
  #text(size: 0.6em, fill: c-muted)[#link(
    "https://qiita.com/misuken/items/19f9f603ab165e228fe1",
  )[https://qiita.com/misuken/items/19f9f603ab165e228fe1]]

#v(1em)

- #link(
    "https://zenn.dev/misuken/articles/93f6f47eb05b94",
  )[ニコニコ生放送でBCD Designを4年運用した知見(導入編)] \
  #text(size: 0.6em, fill: c-muted)[#link(
    "https://zenn.dev/misuken/articles/93f6f47eb05b94",
  )[https://zenn.dev/misuken/articles/93f6f47eb05b94]]
