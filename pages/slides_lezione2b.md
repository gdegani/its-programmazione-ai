---
layout: cover

---

# 3 - Debug, refactoring e test con l'AI

---
level: 2

---

# Laboratorio guidato con AI su C

- Dal prompt al codice verificato
- Focus su debug, refactoring e test
- Tutto eseguibile in CLion

---
level: 2

---

# Collegamento con la lezione precedente

Nella lezione precedente avete visto:

- Prompt strutturati (CRISPE e CO-STAR)
- System prompt e istruzioni di progetto
- Setup strumenti (Copilot, agent, ambiente locale)

Oggi applichiamo tutto in pratica, su problemi C piccoli ma realistici.

---
level: 2

---

# Metodo di lavoro in 5 passi

```mermaid
flowchart LR
    A[1 Analizza il problema] --> B[2 Prompt mirato]
    B --> C[3 Patch minima]
    C --> D[4 Build e test]
    D --> E[5 Migliora il prompt]
```

Regola d'oro: un problema alla volta, una funzione alla volta.

---
level: 2

---

# Caso base: funzione con bug

```c
int sum_positive(const int *arr, int count) {
    int sum;
    for (int i = 0; i <= count; i++) {
        if (arr[i] > 0) sum += arr[i];
    }
    return sum;
}
```

Domanda guida:

- Quali bug vedi prima di chiedere aiuto all'AI?

---
level: 2

---

# Prompt efficace per debug

```text
Ho questa funzione C99.
Trova solo i bug reali e proponi la patch minima.
Non riscrivere tutto il file.
Spiega in 4 punti cosa hai corretto.
```

Checklist risposta utile:

- Inizializzazione variabili
- Limiti array
- Gestione input non validi
- Nessuna modifica non necessaria

---
level: 2

---

# Esercizio: Refactoring sicuro

Partenza:

```c
int clamp_int(int value, int min, int max) {
    if (min > max) {
        return value;
    }
    if (value < min) return min;
    if (value > max) return max;
    return value;
}
```

Consegna:

- Migliora leggibilita'
- Mantieni stessa firma e comportamento
- Chiedi all'AI una patch piccola, non una riscrittura completa

---
level: 2

---

# Prompt per refactoring

```text
Refactor this C99 function for readability.
Keep API and behavior unchanged.
No dynamic allocation.
Return only the updated function and 3 short comments.
```

Criteri di accettazione:

- Compila subito
- Stesso output sui casi noti
- Diff piccolo

---
level: 2

---

# Esercizio: separare .h e .c

## Consegna

Partendo da una funzione in `main.c`:

1. Sposta prototipi in `math_utils.h`
2. Sposta implementazione in `math_utils.c`
3. Aggiorna include in `main.c`

Obiettivo: organizzazione modulare senza cambiare logica.

---
level: 2

---

# Modello minimo dei file

```c
// math_utils.h
#ifndef MATH_UTILS_H
#define MATH_UTILS_H

int clamp_int(int value, int min, int max);

#endif
```

```c
// math_utils.c
#include "math_utils.h"

int clamp_int(int value, int min, int max) {
    if (min > max) return value;
    if (value < min) return min;
    if (value > max) return max;
    return value;
}
```

---
level: 2

---

# Prompt per generare test utili

```text
Generate C99 tests with assert for function clamp_int.
Include normal, boundary, and invalid-input behavior.
Keep tests short and runnable in one main file.
```

Errore da evitare:

- Chiedere "scrivi tanti test" senza vincoli sui casi

---
layout: section
level: 2

---

# Attivita' di gruppo: mini challenge

## Problema

Leggere N interi, calcolare min, max, media intera.

## Vincoli

- C99
- Niente librerie esterne
- Input invalidi gestiti
- Almeno 2 funzioni separate

Tempo: 20 minuti

---
level: 2

---

# Chiusura

## Takeaway

- Prompt chiaro -> patch migliore
- Refactoring piccolo -> rischio minore
- Test brevi -> fiducia maggiore
- AI utile se guidata con vincoli espliciti
