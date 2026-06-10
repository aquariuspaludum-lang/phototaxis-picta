# ==============================================================
# GLM Analysis: Phototactic behavior of P. (L.) picta larvae
# Response variable: positive phototaxis (binary: 1 / 0)
# Package: emmeans, car
# Note: GLMM (cohort_group as random intercept) was initially
#       fitted but yielded a singular solution (random-effect
#       variance = 0), indicating negligible among-cohort
#       variation. GLM was therefore adopted for all analyses.
# ==============================================================

library(emmeans)    # 多重比較（ペアワイズ対比）
library(car)        # Anova() by Type III likelihood ratio test
library(dplyr)      # データ操作

# --------------------------------------------------------------
# 1. データ読み込みと前処理
# --------------------------------------------------------------
dat <- read.csv("repository_data.csv", stringsAsFactors = FALSE)

dat <- dat %>%
  mutate(
    response_bin = case_when(
      response == "positive" ~ 1L,
      response == "negative" ~ 0L,
      TRUE ~ NA_integer_
    ),
    treatment_label = factor(treatment_label,
                             levels = c("air_normoxia",
                                        "water_anoxia",
                                        "air_normoxia_LT",
                                        "air_anoxia")),
    trial_round  = factor(trial_round),
    cohort_group = factor(cohort_group),
    in_air       = factor(in_air,   levels = c("air", "water")),
    normoxia     = factor(normoxia, levels = c("normoxia", "anoxia"))
  ) %>%
  filter(!is.na(response_bin))

cat("解析対象行数:", nrow(dat), "\n")
cat("処理区別サンプルサイズ:\n")
print(table(dat$treatment_label))

# --------------------------------------------------------------
# 2. モデル 1（主モデル）: treatment_label の主効果
#    GLM: 二項分布、ロジットリンク
# --------------------------------------------------------------
model1 <- glm(
  response_bin ~ treatment_label,
  data   = dat,
  family = binomial(link = "logit")
)

cat("\n========== Model 1: treatment_label ==========\n")
print(summary(model1))

# Type III Wald カイ二乗検定（固定効果全体の有意性）
cat("\n--- Type III Wald Chi-square Test ---\n")
print(Anova(model1, type = "III"))

# --------------------------------------------------------------
# 3. 多重比較: treatment_label のペアワイズ対比
#    Holm 補正
# --------------------------------------------------------------
cat("\n--- Pairwise comparisons (Holm correction) ---\n")
emm1 <- emmeans(model1, ~ treatment_label, type = "response")
print(pairs(emm1, adjust = "holm"))

cat("\n--- Estimated probabilities per treatment ---\n")
print(emm1)

# --------------------------------------------------------------
# 4. モデル 2（順序効果の検定）: trial_round を固定効果に追加
#    treatment 1, 2 のみを対象
# --------------------------------------------------------------
dat_12 <- dat %>% filter(treatment %in% c(1, 2), !is.na(trial_round))

model2 <- glm(
  response_bin ~ treatment_label + trial_round,
  data   = dat_12,
  family = binomial(link = "logit")
)

cat("\n========== Model 2: 順序効果の検定 (treatment 1,2 のみ) ==========\n")
print(summary(model2))
cat("\n--- Type III Wald Chi-square Test ---\n")
print(Anova(model2, type = "III"))

# モデル比較（LRT）
model2_null <- glm(
  response_bin ~ treatment_label,
  data   = dat_12,
  family = binomial(link = "logit")
)

cat("\n--- LRT: trial_round の有無の比較 ---\n")
print(anova(model2_null, model2, test = "Chisq"))

# --------------------------------------------------------------
# 5. モデル 3（補足）: in_air × normoxia 交互作用モデル
# --------------------------------------------------------------
model3 <- glm(
  response_bin ~ in_air + normoxia,
  data   = dat,
  family = binomial(link = "logit")
)

cat("\n========== Model 3: in_air + normoxia ==========\n")
print(summary(model3))
cat("\n--- Type III Wald Chi-square Test ---\n")
print(Anova(model3, type = "III"))

# --------------------------------------------------------------
# 6. 結果の保存
# --------------------------------------------------------------
emm_df <- as.data.frame(emm1)
write.csv(emm_df, "GLM_emmeans_model1.csv", row.names = FALSE)

pairs_df <- as.data.frame(pairs(emm1, adjust = "holm"))
write.csv(pairs_df, "GLM_pairwise_holm.csv", row.names = FALSE)

cat("\n結果を GLM_emmeans_model1.csv, GLM_pairwise_holm.csv に保存しました。\n")
