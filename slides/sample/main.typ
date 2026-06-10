#import "@preview/touying:0.7.4": *
#import "@preview/rose-pine:0.2.1": rose-pine-dawn

// ── スライド種別 ─────────────────────────────────────────────

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

#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(footer: none),
  )
  touying-slide(
    self: self,
    config: config,
    align(center + horizon, args.pos().sum(default: none)),
  )
})

#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: rose-pine-dawn.pine, footer: none),
  )
  set text(fill: rose-pine-dawn.base, size: 1.5em)
  touying-slide(self: self, config: config, align(center + horizon, body))
})

// ── テーマ ───────────────────────────────────────────────────

#show: touying-slides.with(
  config-page(
    paper: "presentation-16-9",
    fill: rose-pine-dawn.base,
    margin: (top: 1.5em, bottom: 5pt, x: 1.8em),
    footer: rect(
      width: 100%,
      height: 5pt,
      fill: rose-pine-dawn.foam,
      stroke: none,
    ),
    footer-descent: 0em,
  ),
  config-common(
    slide-fn: body-slide,
    zero-margin-header: false,
    zero-margin-footer: true,
  ),
  config-methods(
    init: (self: none, body) => {
      set text(
        size: 22pt,
        font: "Noto Sans CJK JP",
        lang: "ja",
        weight: "bold",
        fill: rose-pine-dawn.text,
      )
      body
    },
    alert: (self: none, it) => text(fill: rose-pine-dawn.love, it),
  ),
  config-colors(
    primary: rose-pine-dawn.foam,
    neutral-lightest: rose-pine-dawn.base,
    neutral-darkest: rose-pine-dawn.text,
  ),
  config-store(
    subslide-preamble: block(
      below: 1.5em,
      text(28pt, weight: "bold", utils.display-current-heading(level: 2)),
    ),
  ),
)

// ── コンテンツ ───────────────────────────────────────────────

#title-slide[
  #text(1.5em)[タイトル]
  #linebreak()
  著者名
]

== スライド1
内容

#pause

内容2
