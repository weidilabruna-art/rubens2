$c = Get-Content "css\post-19.css" -Raw -Encoding UTF8

# ================================================================
# 1. ZERA TODAS AS CLASSES DE ANIMAÇÃO DE SCROLL
#    Substitui os estados iniciais "invisíveis" por visíveis,
#    mantendo a transição suave apenas para o .ativo (já visível).
# ================================================================

# scroll-top
$c = $c -replace '(?s)\.scroll-top\{[^}]*\}', '.scroll-top { opacity: 1; transform: translate(0, 0); }'

# scroll-bottom
$c = $c -replace '(?s)\.scroll-bottom\{[^}]*\}', '.scroll-bottom { opacity: 1; transform: translate(0, 0); }'

# blur
$c = $c -replace '(?s)\.blur\{[^}]*\}', '.blur { opacity: 1; transform: scale(1); filter: blur(0); }'

# lista items - estado inicial invisível
$c = $c -replace '(?s)\.lista \.elementor-icon-list-item\{[^}]*\}', '.lista .elementor-icon-list-item { opacity: 1; transform: translate3d(0, 0, 0); filter: blur(0); }'

# faq items - estado inicial invisível
$c = $c -replace '(?s)\.faq \.e-n-accordion-item\{[^}]*\}', '.faq .e-n-accordion-item { opacity: 1; transform: translate3d(0, 0, 0); filter: blur(0); }'

# Remove os transition-delays pesados (e1-e5) que atrasam o aparecimento
$c = $c -replace '(?s)@media only screen and \(min-width: 600px\) \{[^}]*\}', '@media only screen and (min-width: 600px) { /* delays removidos para performance */ }'

Set-Content "css\post-19.css" $c -Encoding UTF8
Write-Output "CSS de animações de scroll zerado com sucesso."
