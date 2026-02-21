# keep-digging

Ferramenta CLI que usa o [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) para fazer pesquisa iterativa e profunda sobre uma pergunta. A cada iteração, adota uma perspectiva diferente, gera novas sub-perguntas, e acumula conhecimento — até sintetizar tudo numa resposta final consolidada.

## Como funciona

1. Você faz uma pergunta
2. O loop executa N iterações, cada uma com uma **perspectiva diferente** (ex: Pensador de Primeiros Princípios, Crítico Cético, Analista Histórico...) e um **modelo diferente** (opus, sonnet, haiku em rotação)
3. Cada iteração recebe o contexto acumulado das anteriores, identifica gaps, gera sub-perguntas e aprofunda a análise
4. No final, uma chamada de síntese consolida tudo em: resposta final, achados-chave e perguntas em aberto

### As 10 perspectivas

| # | Perspectiva | Foco |
|---|-------------|------|
| 1 | First Principles Thinker | Decompor até os fundamentos |
| 2 | Skeptical Critic | Questionar evidências e lógica |
| 3 | Historical Analyst | Precedentes e padrões históricos |
| 4 | Systems Thinker | Conexões, feedback loops, efeitos de 2a ordem |
| 5 | Devil's Advocate | Argumentar o oposto do consenso |
| 6 | Empirical Scientist | Dados, evidências, falsificabilidade |
| 7 | Practical Pragmatist | O que funciona na prática |
| 8 | Creative Lateral Thinker | Conexões inesperadas entre domínios |
| 9 | Ethical Philosopher | Dimensões morais e humanas |
| 10 | Synthesis Integrator | Unificar tudo num framework coerente |

Com 3 modelos em rotação, são **30 combinações únicas** antes de repetir.

## Instalação

Requer o [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) instalado e autenticado.

```bash
git clone <repo-url> && cd keep-digging
chmod +x keep-digging
```

## Uso

```
./keep-digging [OPTIONS] <pergunta>
```

### Opções

| Flag | Descrição | Default |
|------|-----------|---------|
| `-n, --max-iterations <N>` | Número de iterações | 10 |
| `-o, --output-dir <path>` | Diretório de saída | auto-gerado |
| `-m, --models <list>` | Rotação de modelos (CSV) | `opus,sonnet,haiku` |
| `-q, --question-file <path>` | Ler pergunta de um arquivo | — |
| `-r, --resume` | Continuar de onde parou (requer `-o`) | — |
| `-s, --synthesize-only` | Só rodar síntese final (requer `-o`) | — |
| `-v, --verbose` | Modo verbose | — |
| `-h, --help` | Ajuda | — |

### Exemplos

```bash
# Pesquisa básica com 3 iterações
./keep-digging -n 3 "What caused the fall of the Roman Empire?"

# Usando só sonnet e haiku
./keep-digging -n 5 -m sonnet,haiku "How does mRNA vaccine technology work?"

# Pergunta a partir de um arquivo
./keep-digging -n 5 -q minha_pergunta.txt

# Retomar uma pesquisa interrompida
./keep-digging -r -o dig_roman-empire_20260220_150000/ -n 10

# Estender para mais iterações
./keep-digging -r -o dig_roman-empire_20260220_150000/ -n 20

# Re-sintetizar com os dados existentes
./keep-digging -s -o dig_roman-empire_20260220_150000/
```

## Saída

Cada execução gera um diretório com a seguinte estrutura:

```
dig_<slug>_<timestamp>/
  question.txt                  # Pergunta original
  config.json                   # Configuração da sessão
  iterations/
    iteration_01/
      perspective.txt           # Perspectiva usada
      model.txt                 # Modelo usado
      prompt.txt                # Prompt enviado
      questions.txt             # Sub-perguntas geradas
      answer.md                 # Resposta completa
      summary.txt               # Resumo compactado
    iteration_02/ ...
  synthesis/
    final_answer.md             # Resposta final sintetizada
    key_findings.md             # Achados-chave com nível de confiança
    open_questions.md           # Perguntas que ficaram em aberto
```

## Janela de contexto deslizante

Para evitar estourar o contexto em pesquisas longas, os resumos anteriores são compactados progressivamente:

- **Iterações 1-5:** todos os resumos completos
- **Iterações 6-10:** meta-resumo das antigas + resumos completos das 3 últimas
- **Iterações 11+:** meta-resumo condensado + resumos das 3 mais recentes
