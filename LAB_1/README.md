# Lab 1: Muestreo y Digitalización (PAM & PCM)

Este laboratorio se enfoca en la transición de señales analógicas a digitales mediante técnicas de modulación de amplitud de pulsos (**PAM**) y modulación por impulsos codificados (**PCM**).

## 👥 Autores
* Jose Avello
* Joaquin Moya
* Alvaro Valdebenito

## 🎯 Objetivos
1.  **Muestreo PAM:** Implementar y comparar el muestreo natural frente al muestreo de cresta plana (*Flat-top*).
2.  **Análisis Espectral:** Observar el efecto del muestreo en el dominio de la frecuencia.
3.  **Cuantización PCM:** Diseñar un cuantizador uniforme para transformar muestras analógicas en niveles discretos.
4.  **Análisis de Error:** Evaluar el error de cuantización y el Error Cuadrático Medio (MSE) según la resolución en bits.

## 💻 Contenido del Script

### 1. Generación de Señal y Muestreo
Se genera una señal senoidal de $1000$ Hz y se somete a un proceso de muestreo a $8000$ Hz ($F_s > 2 \cdot f_{signal}$), cumpliendo con el criterio de Nyquist.
* **PAM Natural:** El pulso sigue la forma de la señal original durante su duración.
* **PAM Instantáneo (Flat-top):** El pulso mantiene un nivel constante durante su ancho, facilitando la lectura en el receptor.

### 2. Cuantización (Función `cuantizador`)
Se incluye una función personalizada que realiza la cuantización uniforme:
* **Entradas:** Muestras, rango dinámico ($V_{min}, V_{max}$) y número de bits ($N$).
* **Salida:** Muestras cuantizadas y el error de cuantización asociado.

### 3. Análisis de Desempeño
El script calcula el **MSE** variando la resolución de $2$ a $8$ bits, permitiendo visualizar cómo aumentar la profundidad de bits reduce el ruido de cuantización.

## 📊 Visualizaciones Incluidas
* **Comparativa de señales:** Original vs PAM Natural vs Flat-top.
* **Espectros de magnitud:** Análisis mediante FFT para observar las réplicas espectrales.
* **Reconstrucción PCM:** Visualización de la señal "escalonada" resultante de la cuantización.
* **Error de Cuantización:** Gráfico de tipo `stem` que muestra la diferencia entre la muestra real y la cuantizada.

## 🛠️ Cómo ejecutar
1. Asegúrate de tener el archivo principal en tu directorio de MATLAB.
2. Ejecuta el script. La función `cuantizador` está incluida al final del archivo, por lo que no requiere archivos `.m` adicionales.
