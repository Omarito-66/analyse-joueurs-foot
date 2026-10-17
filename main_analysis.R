library(tidyverse)
library(janitor)
library(ggrepel)
library(patchwork)


df <- read_csv("Dataplayers.csv") %>% clean_names()

df <- df %>%
  mutate(poste_principal = str_extract(pos, "^[A-Z]+"))

#  Top 5 Attaquants (FW)

top5_fw <- df %>%
  filter(poste_principal == "FW") %>%
  arrange(desc(g_a), desc(gls)) %>%
  select(player, squad, comp, min, gls, ast, g_a) %>%
  slice_head(n = 5)

#  Top 5 Milieux (MF)

top5_mf <- df %>%
  filter(poste_principal == "MF") %>%
  arrange(desc(g_a), desc(ast)) %>%
  select(player, squad, comp, min, gls, ast, g_a) %>%
  slice_head(n = 5)

#  Top 5 Défenseurs (DF) - Minimum 900 minutes jouées

top5_df <- df %>%
  filter(poste_principal == "DF", min >= 900) %>%
  mutate(actions_def = tkl_w + int) %>%
  arrange(desc(actions_def)) %>%
  select(player, squad, comp, min, tkl_w, int, actions_def) %>%
  slice_head(n = 5)

#  Top 5 Gardiens (GK) - Minimum 10 matchs joués

top5_gk <- df %>%
  filter(poste_principal == "GK", mp >= 10) %>%
  arrange(desc(save_percent), desc(cs)) %>%
  select(player, squad, comp, mp, save_percent, cs, ga90) %>%
  slice_head(n = 5)

print(top5_fw)
print(top5_mf)
print(top5_df)
print(top5_gk)

# --- GRAPHIQUE : ATTAQUANTS (FW) ---
g_fw <- ggplot() +
  geom_point(
    data = df %>% filter(poste_principal == "FW", min >= 300),
    aes(x = ast, y = gls, color = comp),
    alpha = 0.45, size = 2.5
  ) +

  geom_point(
    data = top5_fw,
    aes(x = ast, y = gls),
    color = "black", size = 5.5, shape = 21, fill = "red", stroke = 1.2
  ) +
  geom_text_repel(
    data = top5_fw,
    aes(x = ast, y = gls, label = player),
    fontface = "bold", size = 3.8,
    box.padding = 0.8, point.padding = 0.5,
    max.overlaps = Inf, seed = 42
  ) +
  labs(
    title = "Top 5 Attaquants (FW) ",
    x = "Passes Décisives (Ast)",
    y = "Buts Marqués (Gls)",
    color = "Championnat"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"))

# --- GRAPHIQUE : MILIEUX DE TERRAIN (MF) ---
g_mf <- ggplot() +
  geom_point(
    data = df %>% filter(poste_principal == "MF", min >= 300),
    aes(x = ast, y = gls, color = comp),
    alpha = 0.45, size = 2.5
  ) +
  geom_point(
    data = top5_mf,
    aes(x = ast, y = gls),
    color = "black", size = 5.5, shape = 21, fill = "red", stroke = 1.2
  ) +
  geom_text_repel(
    data = top5_mf,
    aes(x = ast, y = gls, label = player),
    fontface = "bold", size = 3.8,
    box.padding = 0.8, point.padding = 0.5,
    max.overlaps = Inf, seed = 42
  ) +
  labs(
    title = "Top 5 Milieux de terrain (MF) ",
    x = "Passes Décisives (Ast)",
    y = "Buts Marqués (Gls)",
    color = "Championnat"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"))

# --- GRAPHIQUE : DÉFENSEURS (DF) ---
g_df <- ggplot() +
  geom_point(
    data = df %>% filter(poste_principal == "DF", min >= 900),
    aes(x = tkl_w, y = int, color = comp),
    alpha = 0.45, size = 2.5
  ) +
  geom_point(
    data = top5_df,
    aes(x = tkl_w, y = int),
    color = "black", size = 5.5, shape = 21, fill = "red", stroke = 1.2
  ) +
  geom_text_repel(
    data = top5_df,
    aes(x = tkl_w, y = int, label = player),
    fontface = "bold", size = 3.8,
    box.padding = 0.8, point.padding = 0.5,
    max.overlaps = Inf, seed = 42
  ) +
  labs(
    title = "Top 5 Défenseurs (DF) ",
    x = "Tacles Gagnés (TklW)",
    y = "Interceptions (Int)",
    color = "Championnat"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"))

# --- GRAPHIQUE : GARDIENS (GK) ---
g_gk <- ggplot() +
  geom_point(
    data = df %>% filter(poste_principal == "GK", mp >= 10),
    aes(x = ga90, y = save_percent, color = comp),
    alpha = 0.55, size = 2.8
  ) +
  geom_point(
    data = top5_gk,
    aes(x = ga90, y = save_percent),
    color = "black", size = 5.5, shape = 21, fill = "red", stroke = 1.2
  ) +
  geom_text_repel(
    data = top5_gk,
    aes(x = ga90, y = save_percent, label = player),
    fontface = "bold", size = 3.8,
    box.padding = 0.8, point.padding = 0.5,
    max.overlaps = Inf, seed = 42
  ) +
  labs(
    title = "Top 5 Gardiens (GK) ",
    x = "Buts Concédés par 90 min ",
    y = "Pourcentage d'arrêts (Save %)",
    color = "Championnat"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold"))


print(g_fw)
print(g_mf)
print(g_df)
print(g_gk)


g_grille_complete <- (g_fw + g_mf) / (g_df + g_gk) +
  plot_layout(guides = "collect") & 
  theme(legend.position = "bottom")

print(g_grille_complete)

ggsave("1_comparaison_attaquants.png", g_fw, width = 10, height = 6, dpi = 300)
ggsave("2_comparaison_milieux.png", g_mf, width = 10, height = 6, dpi = 300)
ggsave("3_comparaison_defenseurs.png", g_df, width = 10, height = 6, dpi = 300)
ggsave("4_comparaison_gardiens.png", g_gk, width = 10, height = 6, dpi = 300)
ggsave("grille_complete_4_postes.png", g_grille_complete, width = 15, height = 11, dpi = 300)

# Ballon d'or

min_max_0_10 <- function(x) {
  x_clean <- replace_na(x, mean(x, na.rm = TRUE))
  return((x_clean - min(x_clean)) / (max(x_clean) - min(x_clean)) * 10)
}

# Calcul du score multi-critères (Min >= 1500 min)
df_ballon <- df %>%
  filter(min >= 1500) %>%
  mutate(
    ga_90       = (g_a / min) * 90,
    actions_def = tkl_w + int,
    sot_pct     = replace_na(so_t_percent, 0),
    
    # Normalisation des notes sur 10
    note_ga90   = min_max_0_10(ga_90),
    note_sot    = min_max_0_10(sot_pct),
    note_ppm    = min_max_0_10(ppm),
    note_def    = min_max_0_10(actions_def),
    note_min    = min_max_0_10(min),
    
    # Score global sur 100
    score_global = (note_ga90 * 3.5) + (note_ppm * 2.0) + (note_sot * 1.5) + 
      (note_def * 1.5) + (note_min * 1.5)
  ) %>%
  arrange(desc(score_global))

# Isolement du Top 5 (en conservant toutes les colonnes)
top5_candidates <- df_ballon %>%
  slice_head(n = 5)

# Affichage du classement dans la console
print("=== CLASSEMENT MULTI-CRITÈRES BALLON D'OR ===")
print(
  top5_candidates %>% 
    select(player, squad, comp, pos, g_a, ga_90, ppm, so_t_percent, actions_def, score_global)
)

# Préparation et affichage du graphique
df_graph <- top5_candidates %>%
  select(player, note_ga90, note_sot, note_ppm, note_def, note_min) %>%
  pivot_longer(
    cols = starts_with("note_"),
    names_to = "critere",
    values_to = "note"
  ) %>%
  mutate(
    critere_label = case_when(
      critere == "note_ga90" ~ "1. Rendement Offensif\n(G+A/90)",
      critere == "note_sot"  ~ "2. Précision au Tir\n(SoT%)",
      critere == "note_ppm"  ~ "3. Impact Équipe\n(Points/Match)",
      critere == "note_def"  ~ "4. Travail Défensif\n(Tacles + Int)",
      critere == "note_min"  ~ "5. Régularité\n(Minutes)",
      TRUE ~ critere
    )
  )

g_multicritere <- ggplot(df_graph, aes(x = critere_label, y = note, fill = player)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_text(
    aes(label = round(note, 1)),
    position = position_dodge(width = 0.8),
    vjust = -0.4,
    fontface = "bold",
    size = 3.2
  ) +
  scale_y_continuous(limits = c(0, 11), breaks = seq(0, 10, 2)) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Analyse Multi-Critères des Prétendants au Ballon d'Or",
    subtitle = "Notes normalisées sur 10 selon chaque critère",
    x = "Critères d'Évaluation",
    y = "Note Normalisée (/10)",
    fill = "Joueur"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "grey30"),
    axis.text.x = element_text(face = "bold"),
    legend.position = "bottom"
  )

print(g_multicritere)
ggsave("ballon_dor_multicritere.png", g_multicritere, width = 12, height = 7, dpi = 300)