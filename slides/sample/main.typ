#import "../../lib/theme.typ": *
#import "../../lib/templates.typ": *
#import "../../lib/config.typ": presentation-config

#show: rose-pine-theme.with(
  aspect-ratio: "16-9",
  presentation-config,
)

#title-slide(
  title: [タイトル],
  author: [著者名],
  date: [1970/01/01],
  venue: [会場名],
)

= セクション1

== 通常スライド
本文は25ptで表示される

#pause

`#pause` でサブスライドに分割できる

#alert[アラート（強調）はこの色になる]

#speaker-note[
  + ここに話すことをメモしておく
  + 聴衆向けの PDF には表示されない
]

#self-intro-slide(
  name: "名前",
  items: (
    [フロントエンドエンジニア],
    [X: \@username],
    [GitHub: \@username],
  ),
  icon: "/assets/rabbirnot-v2-wave-bg-padding-1024.webp",
)

#centered-slide[
  centered-slide は内容を中央に配置する
]

#focus-slide[
  ここが一番伝えたいところ
]

= セクション2

== まとめ
- title-slide
- new-section-slide
- body-slide
- centered-slide
- focus-slide
