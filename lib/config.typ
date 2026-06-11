#import "@preview/touying:0.7.4": *

#let is-presentation = sys.inputs.at("presentation", default: "false") == "true"

#let presentation-config = config-common(
  show-notes-on-second-screen: if is-presentation { right } else { none },
)
