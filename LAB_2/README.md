# Filtro de Coseno Alzado y Análisis de ISI en MATLAB

Este repositorio contiene una simulación completa en **MATLAB** sobre el uso de pulsos conformadores **Coseno Alzado** (*Raised Cosine*) para el control de la Interferencia Entre Símbolos (ISI) en sistemas de comunicaciones digitales.

## 📋 Descripción
El código permite visualizar cómo varía el comportamiento de una señal digital BPSK al modificar el factor de exceso (**roll-off factor** $\alpha$). Se analizan tres dominios críticos:
1.  **Dominio del Tiempo:** Respuesta al impulso del filtro.
2.  **Dominio de la Frecuencia:** Ancho de banda ocupado y eficiencia espectral.
3.  **Calidad de Señal:** Diagramas de ojo bajo condiciones de ruido AWGN.

## 🚀 Funcionalidades
* **Comparativa de Alphas:** Simulación automática para $\alpha = \{0, 0.25, 0.75, 1\}$.
* **Análisis de Espectro:** Cálculo de la respuesta en frecuencia mediante FFT.
* **Diagramas de Ojo:** Generación de diagramas de ojo para evaluar la apertura y sensibilidad al jitter/ruido.
* **Efecto de Muestreo:** Demo de qué sucede cuando la frecuencia de muestreo ($F_s$) es baja.

## 🛠️ Requisitos
* MATLAB R2020a o superior.
* **Communications Toolbox** (necesario para las funciones `rcosdesign`, `eyediagram` y `awgn`).

## 📁 Estructura del Código
* `Nbits`: $10^4$ bits para asegurar validez estadística.
* `Rb`: $1000$ bps (tasa de bits configurable).
* `SNR`: Ajustada a $20$ dB para observar el efecto del ruido sin perder la forma del pulso.

## 📊 Ejemplo de Resultados
Al ejecutar el script, se generan gráficas que demuestran que a menor $\alpha$, el ancho de banda es menor, pero el pulso es más largo en el tiempo (más propenso a errores de sincronismo), lo cual se evidencia claramente en la apertura del **diagrama de ojo**.

---
**Curso:** Comunicaciones Digitales  
**Autores:** J.Avello - J.Moya - A.Valdebenito
