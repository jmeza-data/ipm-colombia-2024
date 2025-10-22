# Índice de Pobreza Multidimensional (IPM) - Colombia 2024

Implementación de la metodología oficial del DANE para el cálculo del Índice de Pobreza Multidimensional usando datos de la Encuesta Nacional de Calidad de Vida (ECV) 2024.

## 📊 Resultados Principales

- **Tasa Nacional de Pobreza**: 10.56%
- **Población Analizada**: 52,845,462 personas
- **Personas en Pobreza Multidimensional**: 5,579,960
- **Validación**: Diferencia de -0.94 p.p. respecto a la cifra oficial del DANE (11.5%)

## 🎯 Sobre el IPM

El Índice de Pobreza Multidimensional mide las privaciones que enfrentan los hogares en cinco dimensiones:

| Dimensión | Indicadores | Peso |
|-----------|-------------|------|
| 🎓 **Educación** | Bajo logro educativo, Analfabetismo | 20% |
| 👶 **Niñez y Juventud** | Inasistencia escolar, Rezago escolar, Barreras primera infancia, Trabajo infantil | 20% |
| 💼 **Trabajo** | Desempleo larga duración, Empleo informal | 20% |
| 🏥 **Salud** | Sin aseguramiento, Barreras de acceso | 20% |
| 🏠 **Vivienda** | Sin acueducto, Sin alcantarillado, Pisos/Paredes inadecuados, Hacinamiento | 20% |

**Un hogar es considerado pobre multidimensional si su IPM ≥ 0.33**

## 📁 Estructura del Proyecto

```
ipm-colombia-2024/
├── calculo_ipm_2024.R              # Script principal de cálculo
├── analisis_visualizaciones_IPM.R  # Script de análisis y gráficos
├── output/                          # Resultados generados
│   ├── IPM_personas_final.csv
│   ├── IPM_departamental_final.csv
│   └── resumen_nacional_IPM.csv
└── visualizaciones/                 # Gráficos generados
    ├── 01_distribucion_ipm.png
    ├── 02_top15_mayor_pobreza.png
    ├── 03_top10_menor_pobreza.png
    ├── 04_distribucion_pobreza.png
    ├── 05_frecuencia_privaciones.png
    ├── 06_mapa_calor_departamentos.png
    ├── 07_boxplot_ipm.png
    └── 08_scatter_ipm_tasa.png
```

## 🚀 Uso

### Prerrequisitos

```r
install.packages(c("tidyverse", "readr", "scales", "gridExtra"))
```

### Ejecución

1. **Calcular el IPM** (requiere bases de datos ECV 2024 del DANE):
```r
source("calculo_ipm_2024.R")
```

2. **Generar visualizaciones**:
```r
source("analisis_visualizaciones_IPM.R")
```

## 📈 Visualizaciones Generadas

El script `analisis_visualizaciones_IPM.R` genera 8 gráficos profesionales:

1. **Distribución del IPM**: Histograma con densidad
2. **Top 15 Mayor Pobreza**: Departamentos más afectados
3. **Top 10 Menor Pobreza**: Departamentos mejor posicionados
4. **Pobres vs No Pobres**: Distribución porcentual
5. **Frecuencia de Privaciones**: Por indicador y dimensión
6. **Mapa de Calor**: Todos los departamentos
7. **Boxplot del IPM**: Por clasificación
8. **Scatter Plot**: IPM promedio vs Tasa de pobreza

## 📊 Principales Hallazgos

### Departamentos con Mayor Pobreza
1. Vichada - 63.5%
2. Guainía - 40.8%
3. La Guajira - 30.7%

### Departamentos con Menor Pobreza
1. Bogotá D.C. - 4.3%
2. Valle del Cauca - 6.1%
3. Santander - 6.5%

### Privaciones Más Frecuentes
Las privaciones más comunes en la población colombiana son:
- Empleo informal
- Desempleo de larga duración
- Bajo logro educativo

## 🔍 Metodología

Este proyecto implementa fielmente la metodología oficial del DANE:
- **Umbral de pobreza**: IPM ≥ 0.33 (33%)
- **Ponderaciones**: Cada dimensión contribuye con 20%
- **Factores de expansión**: Resultados ponderados con FEX_C
- **Agregación**: Nacional y departamental

## 👨‍💻 Autor

**Jhoan Sebastian Meza Garcia**  
Universidad Nacional de Colombia

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 📚 Referencias

- DANE (2024). *Encuesta Nacional de Calidad de Vida (ECV) 2024*
- DANE (2018). *Metodología Índice de Pobreza Multidimensional*

---

⭐ Si este proyecto te fue útil, considera darle una estrella
