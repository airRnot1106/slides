#import "./color.typ": *

/// 画像を円形に切り抜くヘルパー関数
#let circle-image(path, width: 100%) = box(
  clip: true,
  radius: 50%,
  image(path, width: width),
)

/// コンテンツを枠線で囲むヘルパー関数
#let framed(
  body,
  thickness: 16pt,
  radius: 0.5em,
  border-color: color-foam,
  fill-color: color-base,
) = rect(
  width: 100%,
  height: 100%,
  fill: border-color,
  inset: thickness,
  rect(
    width: 100%,
    height: 100%,
    fill: fill-color,
    radius: radius,
    body,
  ),
)
