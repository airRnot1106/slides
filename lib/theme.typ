#import "@preview/touying:0.7.4": *
#import "./color.typ": *
#import "./helpers.typ": framed

/// 通常スライド
/// `== 見出し` ごとに自動で呼ばれる
#let body-slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(subslide-preamble: self.store.subslide-preamble),
  )
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: setting,
    composer: composer,
    ..bodies,
  )
})

/// 中央揃えスライド
/// 見出しを持たないため、上マージンを本文用の 1.5em から下と同じ 8pt に揃え、
/// コンテンツをページ中央に置く（既定の上下非対称マージンだと上に偏る）
#let centered-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-page(margin: (y: 8pt, x: 1.8em)),
  )
  touying-slide(
    self: self,
    ..args.named(),
    config: config,
    align(center + horizon, args.pos().sum(default: none)),
  )
})

/// タイトルスライド
#let title-slide(
  config: (:),
  title: none,
  author: none,
  date: none,
  venue: none,
  notes: none,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(footer: none, margin: 0pt),
  )
  touying-slide(
    self: self,
    config: config,
    {
      framed(align(
        center + horizon,
        grid(
          columns: 1,
          align: center,
          row-gutter: 1.2em,
          ..(
            (
              if title != none { text(2.8em, title) },
              if author != none {
                text(0.6em, weight: "regular", fill: color-subtle, author)
              },
              if date != none or venue != none {
                text(
                  0.8em,
                  weight: "regular",
                  fill: color-text,
                  (date, venue).filter(x => x != none).join(h(1em)),
                )
              },
            ).filter(x => x != none)
          ),
        ),
      ))
      if notes != none { speaker-note(notes) }
    },
  )
})

/// セクションスライド
/// `= 見出し` ごとに自動で呼ばれる
/// ページ番号は振らない（カウンタを凍結しフッターも消す）
#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(footer: none, margin: (y: 8pt, x: 1.8em)),
  )
  touying-slide(
    self: self,
    config: config,
    align(center + horizon, {
      text(2.3em, weight: "bold", utils.display-current-heading(level: 1))
      body
    }),
  )
})

/// 強調スライド
/// 背景を反転させて1メッセージを大きく見せる
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: color-pine, footer: none, margin: (y: 8pt, x: 1.8em)),
  )
  set text(fill: color-base, size: 1.5em)
  touying-slide(self: self, config: config, align(center + horizon, body))
})

/// Rosé Pine Dawn Theme
#let rose-pine-theme(
  aspect-ratio: "16-9",
  subslide-preamble: block(
    below: 1.5em,
    text(1.8em, weight: "bold", utils.display-current-heading(level: 2)),
  ),
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      fill: color-base,
      margin: (top: 1.5em, bottom: 8pt, x: 1.8em),
      footer: {
        place(
          right + bottom,
          dx: -0.5em,
          dy: -16pt,
          text(
            size: 0.6em,
            fill: color-subtle,
            context utils.slide-counter.display()
              + " / "
              + utils.last-slide-number,
          ),
        )
        rect(
          width: 100%,
          height: 8pt,
          fill: color-foam,
          stroke: none,
        )
      },
      footer-descent: 0em,
    ),
    config-common(
      slide-fn: body-slide,
      new-section-slide-fn: new-section-slide,
      zero-margin-header: false,
      zero-margin-footer: true,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(
          size: 25pt,
          font: "BIZ UDPGothic",
          lang: "ja",
          weight: "bold",
          fill: color-text,
        )
        show heading.where(level: 1): set text(1.4em)
        set list(spacing: 1.2em)
        body
      },
      alert: (self: none, it) => text(fill: color-love, it),
    ),
    config-colors(
      primary: color-foam,
      neutral-lightest: color-base,
      neutral-darkest: color-text,
    ),
    config-store(subslide-preamble: subslide-preamble),
    ..args,
  )
  body
}
