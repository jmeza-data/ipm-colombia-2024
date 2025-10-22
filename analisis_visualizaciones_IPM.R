################################################################################
# ANÁLISIS DESCRIPTIVO Y VISUALIZACIONES IPM 2024
# Autor: Jhoan Sebastian Meza Garcia
# Universidad Nacional de Colombia
################################################################################

# CARGAR LIBRERÍAS ----
library(tidyverse)
library(readr)
library(scales)
library(gridExtra)

# Configurar tema general para gráficos
theme_set(theme_minimal(base_size = 12))

cat("╔════════════════════════════════════════════════════════════╗\n")
cat("║        ANÁLISIS DESCRIPTIVO IPM 2024 - COLOMBIA           ║\n")
cat("╚════════════════════════════════════════════════════════════╝\n\n")

# ==============================================================================
# CARGAR DATOS
# ==============================================================================

cat("Cargando datos...\n")
ipm_personas <- read_csv("IPM_personas_final.csv")
ipm_departamental <- read_csv("IPM_departamental_final.csv")
resumen_nacional <- read_csv("resumen_nacional_IPM.csv")

cat("✓ Datos cargados correctamente\n")
cat("  - Personas:", nrow(ipm_personas), "\n")
cat("  - Departamentos:", nrow(ipm_departamental), "\n\n")

# Crear carpeta para visualizaciones
if(!dir.exists("visualizaciones")) {
  dir.create("visualizaciones")
  cat("✓ Carpeta 'visualizaciones' creada\n\n")
}

# ==============================================================================
# CÓDIGOS DE DEPARTAMENTOS
# ==============================================================================

# Diccionario de códigos DANE a nombres de departamentos
departamentos_nombres <- c(
  "05" = "Antioquia", "08" = "Atlántico", "11" = "Bogotá D.C.", "13" = "Bolívar",
  "15" = "Boyacá", "17" = "Caldas", "18" = "Caquetá", "19" = "Cauca",
  "20" = "Cesar", "23" = "Córdoba", "25" = "Cundinamarca", "27" = "Chocó",
  "41" = "Huila", "44" = "La Guajira", "47" = "Magdalena", "50" = "Meta",
  "52" = "Nariño", "54" = "Norte de Santander", "63" = "Quindío", "66" = "Risaralda",
  "68" = "Santander", "70" = "Sucre", "73" = "Tolima", "76" = "Valle del Cauca",
  "81" = "Arauca", "85" = "Casanare", "86" = "Putumayo", "88" = "San Andrés",
  "91" = "Amazonas", "94" = "Guainía", "95" = "Guaviare", "97" = "Vaupés", "99" = "Vichada"
)

# Agregar nombres a datos departamentales
ipm_departamental <- ipm_departamental %>%
  mutate(nombre_depto = departamentos_nombres[as.character(DEPARTAMENTO)],
         nombre_depto = ifelse(is.na(nombre_depto), as.character(DEPARTAMENTO), nombre_depto))

cat("═══════════════════════════════════════════════════════════\n")
cat("ESTADÍSTICAS DESCRIPTIVAS GENERALES\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# ==============================================================================
# GRÁFICO 1: DISTRIBUCIÓN DEL IPM (HISTOGRAMA)
# ==============================================================================

cat("Generando Gráfico 1: Distribución del IPM...\n")

g1 <- ggplot(ipm_personas, aes(x = IPM)) +
  geom_histogram(aes(y = ..density..), bins = 50, fill = "#3498db", 
                 color = "white", alpha = 0.8) +
  geom_density(color = "#e74c3c", size = 1.2) +
  geom_vline(xintercept = 0.33, color = "#e74c3c", linetype = "dashed", size = 1) +
  geom_vline(xintercept = median(ipm_personas$IPM, na.rm = TRUE), 
             color = "#27ae60", linetype = "dashed", size = 1) +
  annotate("text", x = 0.33, y = Inf, label = "Umbral = 0.33", 
           vjust = 2, hjust = -0.1, color = "#e74c3c", size = 4, fontface = "bold") +
  annotate("text", x = median(ipm_personas$IPM, na.rm = TRUE), y = Inf, 
           label = paste0("Mediana = ", round(median(ipm_personas$IPM, na.rm = TRUE), 3)), 
           vjust = 4, hjust = -0.1, color = "#27ae60", size = 4, fontface = "bold") +
  labs(
    title = "Distribución del Índice de Pobreza Multidimensional",
    subtitle = "Colombia 2024 - Metodología DANE",
    x = "IPM",
    y = "Densidad",
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    panel.grid.minor = element_blank()
  )

ggsave("visualizaciones/01_distribucion_ipm.png", g1, width = 12, height = 7, dpi = 300)
cat("✓ Guardado: 01_distribucion_ipm.png\n\n")

# ==============================================================================
# GRÁFICO 2: POBREZA POR DEPARTAMENTO (TOP 15 MAYOR)
# ==============================================================================

cat("Generando Gráfico 2: Top 15 Departamentos con Mayor Pobreza...\n")

top15_mayor <- ipm_departamental %>%
  arrange(desc(tasa_pobreza)) %>%
  head(15) %>%
  mutate(nombre_depto = fct_reorder(nombre_depto, tasa_pobreza))

g2 <- ggplot(top15_mayor, aes(x = nombre_depto, y = tasa_pobreza)) +
  geom_col(aes(fill = tasa_pobreza), width = 0.7) +
  geom_text(aes(label = paste0(round(tasa_pobreza, 1), "%")), 
            hjust = -0.2, size = 4, fontface = "bold") +
  geom_hline(yintercept = 10.56, linetype = "dashed", color = "#e74c3c", size = 1) +
  annotate("text", x = 13, y = 10.56, label = "Promedio Nacional: 10.56%", 
           vjust = -0.5, color = "#e74c3c", size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#f39c12", high = "#c0392b", name = "Tasa (%)") +
  coord_flip() +
  scale_y_continuous(limits = c(0, 70), expand = c(0, 0)) +
  labs(
    title = "Top 15 Departamentos con Mayor Pobreza Multidimensional",
    subtitle = "Tasa de Pobreza IPM (%)",
    x = NULL,
    y = "Tasa de Pobreza (%)",
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "none",
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("visualizaciones/02_top15_mayor_pobreza.png", g2, width = 12, height = 10, dpi = 300)
cat("✓ Guardado: 02_top15_mayor_pobreza.png\n\n")

# ==============================================================================
# GRÁFICO 3: TOP 10 MENOR POBREZA
# ==============================================================================

cat("Generando Gráfico 3: Top 10 Departamentos con Menor Pobreza...\n")

top10_menor <- ipm_departamental %>%
  arrange(tasa_pobreza) %>%
  head(10) %>%
  mutate(nombre_depto = fct_reorder(nombre_depto, tasa_pobreza))

g3 <- ggplot(top10_menor, aes(x = nombre_depto, y = tasa_pobreza)) +
  geom_col(aes(fill = tasa_pobreza), width = 0.7) +
  geom_text(aes(label = paste0(round(tasa_pobreza, 1), "%")), 
            hjust = -0.2, size = 4, fontface = "bold") +
  geom_hline(yintercept = 10.56, linetype = "dashed", color = "#e74c3c", size = 1) +
  annotate("text", x = 8, y = 10.56, label = "Promedio Nacional: 10.56%", 
           vjust = -0.5, color = "#e74c3c", size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#27ae60", high = "#f39c12", name = "Tasa (%)") +
  coord_flip() +
  scale_y_continuous(limits = c(0, 15), expand = c(0, 0)) +
  labs(
    title = "Top 10 Departamentos con Menor Pobreza Multidimensional",
    subtitle = "Tasa de Pobreza IPM (%)",
    x = NULL,
    y = "Tasa de Pobreza (%)",
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "none",
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("visualizaciones/03_top10_menor_pobreza.png", g3, width = 12, height = 8, dpi = 300)
cat("✓ Guardado: 03_top10_menor_pobreza.png\n\n")

# ==============================================================================
# GRÁFICO 4: POBRES VS NO POBRES (PORCENTAJE)
# ==============================================================================

cat("Generando Gráfico 4: Distribución Pobres vs No Pobres...\n")

distribucion_pobreza <- ipm_personas %>%
  count(POBRE, wt = FEX_C) %>%
  mutate(
    porcentaje = n / sum(n) * 100,
    categoria = ifelse(POBRE == 1, "Pobre", "No Pobre"),
    categoria = factor(categoria, levels = c("No Pobre", "Pobre"))
  )

g4 <- ggplot(distribucion_pobreza, aes(x = categoria, y = porcentaje, fill = categoria)) +
  geom_col(width = 0.6, alpha = 0.9) +
  geom_text(aes(label = paste0(round(porcentaje, 2), "%\n", 
                                 "(", format(round(n), big.mark = ","), " personas)")), 
            vjust = -0.5, size = 6, fontface = "bold") +
  scale_fill_manual(values = c("No Pobre" = "#27ae60", "Pobre" = "#e74c3c")) +
  scale_y_continuous(limits = c(0, 100), expand = c(0, 0)) +
  labs(
    title = "Distribución de la Población según Pobreza Multidimensional",
    subtitle = "Colombia 2024",
    x = NULL,
    y = "Porcentaje (%)",
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("visualizaciones/04_distribucion_pobreza.png", g4, width = 10, height = 8, dpi = 300)
cat("✓ Guardado: 04_distribucion_pobreza.png\n\n")

# ==============================================================================
# GRÁFICO 5: FRECUENCIA DE PRIVACIONES
# ==============================================================================

cat("Generando Gráfico 5: Frecuencia de Privaciones...\n")

privaciones_freq <- ipm_personas %>%
  summarise(
    `Bajo logro educativo` = weighted.mean(LOGRO_2, FEX_C, na.rm = TRUE) * 100,
    `Analfabetismo` = weighted.mean(ALFA_2, FEX_C, na.rm = TRUE) * 100,
    `Inasistencia escolar` = weighted.mean(ASISTE_2, FEX_C, na.rm = TRUE) * 100,
    `Rezago escolar` = weighted.mean(REZAGO_2, FEX_C, na.rm = TRUE) * 100,
    `Barreras 1a infancia` = weighted.mean(A_INTEGRAL_2, FEX_C, na.rm = TRUE) * 100,
    `Trabajo infantil` = weighted.mean(TRABAJOINF_2, FEX_C, na.rm = TRUE) * 100,
    `Desempleo larga duración` = weighted.mean(DES_DURA_2, FEX_C, na.rm = TRUE) * 100,
    `Empleo informal` = weighted.mean(EFORMAL_2, FEX_C, na.rm = TRUE) * 100,
    `Sin aseguramiento salud` = weighted.mean(SEGURO_SALUD_2, FEX_C, na.rm = TRUE) * 100,
    `Barreras acceso salud` = weighted.mean(SALUD_NEC_2, FEX_C, na.rm = TRUE) * 100,
    `Sin acueducto` = weighted.mean(ACUEDUCTO, FEX_C, na.rm = TRUE) * 100,
    `Sin alcantarillado` = weighted.mean(ALCANTARILLADO, FEX_C, na.rm = TRUE) * 100,
    `Pisos inadecuados` = weighted.mean(PISOS, FEX_C, na.rm = TRUE) * 100,
    `Paredes inadecuadas` = weighted.mean(PAREDES, FEX_C, na.rm = TRUE) * 100,
    `Hacinamiento` = weighted.mean(HACINAMIENTO, FEX_C, na.rm = TRUE) * 100
  ) %>%
  pivot_longer(everything(), names_to = "Privacion", values_to = "Porcentaje") %>%
  arrange(desc(Porcentaje)) %>%
  mutate(
    Privacion = fct_reorder(Privacion, Porcentaje),
    Dimension = case_when(
      Privacion %in% c("Bajo logro educativo", "Analfabetismo") ~ "Educación",
      Privacion %in% c("Inasistencia escolar", "Rezago escolar", 
                       "Barreras 1a infancia", "Trabajo infantil") ~ "Niñez y Juventud",
      Privacion %in% c("Desempleo larga duración", "Empleo informal") ~ "Trabajo",
      Privacion %in% c("Sin aseguramiento salud", "Barreras acceso salud") ~ "Salud",
      TRUE ~ "Vivienda"
    )
  )

g5 <- ggplot(privaciones_freq, aes(x = Privacion, y = Porcentaje, fill = Dimension)) +
  geom_col(alpha = 0.9) +
  geom_text(aes(label = paste0(round(Porcentaje, 1), "%")), 
            hjust = -0.2, size = 3.5) +
  scale_fill_manual(values = c(
    "Educación" = "#3498db",
    "Niñez y Juventud" = "#9b59b6",
    "Trabajo" = "#e67e22",
    "Salud" = "#1abc9c",
    "Vivienda" = "#e74c3c"
  )) +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(privaciones_freq$Porcentaje) * 1.15), 
                     expand = c(0, 0)) +
  labs(
    title = "Frecuencia de Privaciones en la Población Colombiana",
    subtitle = "Porcentaje de población con cada privación (ponderado)",
    x = NULL,
    y = "Porcentaje de Población (%)",
    fill = "Dimensión",
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "top",
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("visualizaciones/05_frecuencia_privaciones.png", g5, width = 14, height = 10, dpi = 300)
cat("✓ Guardado: 05_frecuencia_privaciones.png\n\n")

# ==============================================================================
# GRÁFICO 6: MAPA DE CALOR - TODOS LOS DEPARTAMENTOS
# ==============================================================================

cat("Generando Gráfico 6: Mapa de Calor de Pobreza por Departamento...\n")

ipm_dept_ordenado <- ipm_departamental %>%
  arrange(desc(tasa_pobreza)) %>%
  mutate(
    nombre_depto = fct_reorder(nombre_depto, tasa_pobreza),
    clasificacion = case_when(
      tasa_pobreza > 30 ~ "Crítico (>30%)",
      tasa_pobreza > 20 ~ "Alto (20-30%)",
      tasa_pobreza > 10 ~ "Medio (10-20%)",
      TRUE ~ "Bajo (<10%)"
    ),
    clasificacion = factor(clasificacion, 
                           levels = c("Crítico (>30%)", "Alto (20-30%)", 
                                      "Medio (10-20%)", "Bajo (<10%)"))
  )

g6 <- ggplot(ipm_dept_ordenado, aes(x = 1, y = nombre_depto, fill = tasa_pobreza)) +
  geom_tile(color = "white", size = 1) +
  geom_text(aes(label = paste0(round(tasa_pobreza, 1), "%")), 
            color = "white", fontface = "bold", size = 3.5) +
  scale_fill_gradient2(
    low = "#27ae60", 
    mid = "#f39c12", 
    high = "#c0392b",
    midpoint = 20,
    name = "Tasa (%)",
    guide = guide_colorbar(barwidth = 15, barheight = 0.5)
  ) +
  labs(
    title = "Tasa de Pobreza Multidimensional por Departamento",
    subtitle = "Colombia 2024 - Todos los departamentos",
    x = NULL,
    y = NULL,
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(color = "gray40", hjust = 0.5),
    axis.text.x = element_blank(),
    panel.grid = element_blank(),
    legend.position = "bottom"
  )

ggsave("visualizaciones/06_mapa_calor_departamentos.png", g6, width = 10, height = 14, dpi = 300)
cat("✓ Guardado: 06_mapa_calor_departamentos.png\n\n")

# ==============================================================================
# GRÁFICO 7: BOX PLOT IPM POR CLASIFICACIÓN DE POBREZA
# ==============================================================================

cat("Generando Gráfico 7: Boxplot del IPM...\n")

g7 <- ipm_personas %>%
  mutate(categoria = ifelse(POBRE == 1, "Pobre", "No Pobre")) %>%
  ggplot(aes(x = categoria, y = IPM, fill = categoria)) +
  geom_boxplot(alpha = 0.7, outlier.alpha = 0.3) +
  geom_hline(yintercept = 0.33, linetype = "dashed", color = "#e74c3c", size = 1) +
  annotate("text", x = 1.5, y = 0.33, label = "Umbral = 0.33", 
           vjust = -0.5, color = "#e74c3c", size = 4, fontface = "bold") +
  scale_fill_manual(values = c("No Pobre" = "#27ae60", "Pobre" = "#e74c3c")) +
  labs(
    title = "Distribución del IPM según Clasificación de Pobreza",
    subtitle = "Diagrama de Caja y Bigotes",
    x = NULL,
    y = "Índice de Pobreza Multidimensional (IPM)",
    caption = "Fuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "none"
  )

ggsave("visualizaciones/07_boxplot_ipm.png", g7, width = 10, height = 8, dpi = 300)
cat("✓ Guardado: 07_boxplot_ipm.png\n\n")

# ==============================================================================
# GRÁFICO 8: COMPARACIÓN IPM PROMEDIO VS TASA DE POBREZA
# ==============================================================================

cat("Generando Gráfico 8: IPM Promedio vs Tasa de Pobreza...\n")

g8 <- ggplot(ipm_departamental, aes(x = ipm_promedio, y = tasa_pobreza)) +
  geom_point(aes(size = total_personas, color = tasa_pobreza), alpha = 0.7) +
  geom_text(aes(label = nombre_depto), vjust = -0.8, hjust = 0.5, 
            size = 3, check_overlap = TRUE) +
  geom_hline(yintercept = 10.56, linetype = "dashed", color = "gray40", alpha = 0.7) +
  geom_vline(xintercept = 0.1949, linetype = "dashed", color = "gray40", alpha = 0.7) +
  scale_color_gradient(low = "#27ae60", high = "#c0392b", name = "Tasa (%)") +
  scale_size_continuous(name = "Población", labels = comma) +
  labs(
    title = "Relación entre IPM Promedio y Tasa de Pobreza",
    subtitle = "Por Departamento - Tamaño indica población",
    x = "IPM Promedio",
    y = "Tasa de Pobreza (%)",
    caption = "Líneas punteadas indican promedios nacionales\nFuente: Cálculo propio con datos ECV 2024"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "right"
  )

ggsave("visualizaciones/08_scatter_ipm_tasa.png", g8, width = 14, height = 10, dpi = 300)
cat("✓ Guardado: 08_scatter_ipm_tasa.png\n\n")

# ==============================================================================
# RESUMEN DE ESTADÍSTICAS CLAVE
# ==============================================================================

cat("═══════════════════════════════════════════════════════════\n")
cat("RESUMEN DE ESTADÍSTICAS CLAVE\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat("NACIONAL:\n")
cat("  Tasa de pobreza:", round(resumen_nacional$Valor[3], 2), "%\n")
cat("  IPM promedio:", round(resumen_nacional$Valor[4], 4), "\n")
cat("  Población total:", resumen_nacional$Valor[1], "\n")
cat("  Personas pobres:", resumen_nacional$Valor[2], "\n\n")

cat("DEPARTAMENTAL:\n")
cat("  Mayor pobreza:", 
    ipm_departamental$nombre_depto[which.max(ipm_departamental$tasa_pobreza)],
    "-", round(max(ipm_departamental$tasa_pobreza), 2), "%\n")
cat("  Menor pobreza:", 
    ipm_departamental$nombre_depto[which.min(ipm_departamental$tasa_pobreza)],
    "-", round(min(ipm_departamental$tasa_pobreza), 2), "%\n\n")

cat("IPM:\n")
cat("  Mínimo:", round(min(ipm_personas$IPM, na.rm = TRUE), 4), "\n")
cat("  Mediana:", round(median(ipm_personas$IPM, na.rm = TRUE), 4), "\n")
cat("  Media:", round(mean(ipm_personas$IPM, na.rm = TRUE), 4), "\n")
cat("  Máximo:", round(max(ipm_personas$IPM, na.rm = TRUE), 4), "\n\n")

# Exportar tabla de privaciones
write_csv(privaciones_freq, "visualizaciones/tabla_privaciones.csv")
cat("✓ Tabla de privaciones exportada\n\n")

cat("╔════════════════════════════════════════════════════════════╗\n")
cat("║           ✓ VISUALIZACIONES GENERADAS EXITOSAMENTE ✓      ║\n")
cat("╚════════════════════════════════════════════════════════════╝\n\n")

cat("Total de gráficos generados: 8\n")
cat("Ubicación: carpeta 'visualizaciones/'\n\n")

cat("Archivos creados:\n")
cat("  01_distribucion_ipm.png\n")
cat("  02_top15_mayor_pobreza.png\n")
cat("  03_top10_menor_pobreza.png\n")
cat("  04_distribucion_pobreza.png\n")
cat("  05_frecuencia_privaciones.png\n")
cat("  06_mapa_calor_departamentos.png\n")
cat("  07_boxplot_ipm.png\n")
cat("  08_scatter_ipm_tasa.png\n")
cat("  tabla_privaciones.csv\n\n")
