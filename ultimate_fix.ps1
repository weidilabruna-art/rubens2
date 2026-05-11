$c = Get-Content "index.html" -Raw -Encoding UTF8

# ===================================================
# 1. Desabilitar Lenis completamente para todos (não só mobile)
#    Substitui o script que só desativava no mobile por um que desativa sempre
# ===================================================
$oldLenisBlock = @'
		(function () {
			const isMobile = 'ontouchstart' in window ||
				window.matchMedia("(max-width: 1024px)").matches;

			if (!isMobile) return; // Desktop: não faz nada
'@

$newLenisBlock = @'
		(function () {
			// Desativa Lenis em TODOS os dispositivos para garantir scroll nativo
			const isMobile = true; // forçado para sempre executar
			if (false) return;
'@

$c = $c.Replace($oldLenisBlock, $newLenisBlock)

# ===================================================
# 2. Substituir o IntersectionObserver de animação de scroll
#    por um script que apenas adiciona a classe .ativo em TODOS
#    os elementos logo após o DOM carregar (sem esperar scroll)
# ===================================================
$oldAnimScript = @'
				(function () {
					const observerOptions = {
						root: null,
						rootMargin: '0px 0px -10% 0px',
						threshold: 0.05
					};

					const observer = new IntersectionObserver((entries) => {
						entries.forEach(entry => {
							if (entry.isIntersecting) {
								entry.target.classList.add("ativo");
								observer.unobserve(entry.target);
							}
						});
					}, observerOptions);

					function initScrollAnimations() {
						const selectors = ".scroll-left, .scroll-right, .scroll-top, .scroll-bottom, .blur, .lista .elementor-icon-list-item, .faq .e-n-accordion-item";
						document.querySelectorAll(selectors).forEach(el => {
							observer.observe(el);
						});
					}

					if (document.readyState === 'loading') {
						document.addEventListener('DOMContentLoaded', initScrollAnimations);
					} else {
						initScrollAnimations();
					}
				})();
'@

$newAnimScript = @'
				(function () {
					// Adiciona .ativo em todos os elementos imediatamente
					// Sem delays, sem IntersectionObserver, sem travamentos
					function activateAll() {
						const selectors = ".scroll-left, .scroll-right, .scroll-top, .scroll-bottom, .blur, .lista .elementor-icon-list-item, .faq .e-n-accordion-item";
						document.querySelectorAll(selectors).forEach(el => {
							el.classList.add("ativo");
						});
					}
					if (document.readyState === 'loading') {
						document.addEventListener('DOMContentLoaded', activateAll);
					} else {
						activateAll();
					}
				})();
'@

$c = $c.Replace($oldAnimScript, $newAnimScript)

# ===================================================
# 3. Remover o CSS redundante de "Otimização de Performance"
#    que foi adicionado em edições anteriores (está duplicado)
# ===================================================
# Remover regra will-change que não é mais necessária e que pode travar GPU
$c = $c -replace '(?s)/\* Otimização de Performance e Fluidez \*/.*?</style>', '</style>'

Set-Content "index.html" $c -Encoding UTF8
Write-Output "index.html atualizado com sucesso."
