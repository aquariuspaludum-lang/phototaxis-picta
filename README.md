# Data and code for: "Water Immersion Triggers Reversal of Phototaxis Sign in Larvae of the Sap Beetle *Phenolia* (*Lasiodites*) *picta*"

## Author
Manabu Kishi  
Persimmon and Peach Laboratory, Wakayama Fruit Tree Experiment Station, Japan  
E-mail: kishi@hotmail.co.jp

## Description
This repository contains the dataset and R analysis code supporting the above manuscript submitted to *Biology Letters*.

The study investigated the phototactic responses of third-instar larvae of the sap beetle *Phenolia* (*Lasiodites*) *picta* (MacLeay) (Coleoptera: Nitidulidae) under four environmental conditions: normal air (cond. A), water immersion (cond. B), cold air (cond. C), and air replaced with 95% CO₂ (cond. D).

---

## Files

### `repository_data.csv`
The dataset used for all statistical analyses. Each row represents one individual larva.

| Column | Description |
|--------|-------------|
| `individual_id` | Individual identifier |
| `treatment` | Treatment number (1 = air_normoxia, 2 = water_anoxia, 3 = air_normoxia_LT, 4 = air_anoxia) |
| `treatment_label` | Treatment label (air_normoxia, water_anoxia, air_normoxia_LT, air_anoxia) |
| `response` | Phototactic response (positive / negative / NA) |
| `in_air` | Medium (air / water) |
| `normoxia` | Oxygen availability (normoxia / anoxia) |
| `temperature_C` | Temperature during the trial (°C) |
| `response_time_s` | Time to reach pitfall (seconds); NA if larva did not respond within 15 min |
| `trial_round` | Trial order in crossover design (round1 / round2); NA for cond. C and D |
| `cohort_group` | Cohort group identifier (1–24; 4 individuals per cohort) |

NA in the `response` column indicates that the larva did not reach either pitfall within the 15-minute observation period and was excluded from analysis.

### `GLM_phototaxis.R`
R script for all statistical analyses reported in the manuscript, including:
- Model 1: Primary GLM (effect of treatment condition on phototactic response)
- Model 2: Test of order effect in the crossover design (cond. A and B only)
- Model 3: Supplementary GLM decomposing effects of medium and oxygen availability

---

## Requirements

### R version
R 4.5.1 (R Core Team, 2025)

### R packages
| Package | Version | Purpose |
|---------|---------|---------|
| `emmeans` | 2.0.1 | Pairwise comparisons with Holm correction |
| `car` | — | Type III likelihood ratio tests |
| `dplyr` | — | Data manipulation |

Install packages with:
```r
install.packages(c("emmeans", "car", "dplyr"))
```

---

## Usage

1. Place `repository_data.csv` and `GLM_phototaxis.R` in the same working directory.
2. Open `GLM_phototaxis.R` in R or RStudio.
3. Run the script. Output files `GLM_emmeans_model1.csv` and `GLM_pairwise_holm.csv` will be generated in the working directory.

---

## Note on GLMM
A generalized linear mixed model (GLMM) with cohort group as a random intercept was initially fitted using the `lme4` package, but yielded a singular solution (random-effect variance = 0), indicating negligible among-cohort variation. A generalized linear model (GLM) was therefore adopted for all analyses reported in the manuscript.

---

## License
This dataset and code are made available under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

---

## Citation
Kishi M. Water immersion triggers reversal of phototaxis sign in larvae of the sap beetle *Phenolia* (*Lasiodites*) *picta*. *Biology Letters* (submitted).
