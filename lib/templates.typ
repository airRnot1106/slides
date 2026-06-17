#import "@preview/touying:0.7.4": speaker-note
#import "./color.typ": *
#import "./helpers.typ": *

/// 自己紹介スライドテンプレート
/// アイコンのパスはプロジェクトルートからの絶対パス（例: "/assets/icon.png"）で指定する
#let self-intro-slide(
  title: "自己紹介",
  name: none,
  items: (),
  icon: none,
  icon-width: 100%,
  item-spacing: auto,
  notes: none,
) = {
  [== #title]

  grid(
    columns: (2fr, 1fr),
    gutter: 2em,
    align: (top, center + horizon),
    {
      if name != none {
        text(1.2em, weight: "bold", name)
        v(1.5em, weak: true)
      }
      if item-spacing == auto {
        list(..items)
      } else {
        list(spacing: item-spacing, ..items)
      }
    },
    if icon != none {
      circle-image(icon, width: icon-width)
    },
  )
  if notes != none { speaker-note(notes) }
}
