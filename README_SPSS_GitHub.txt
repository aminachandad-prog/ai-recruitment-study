# SPSS syntax – AI recruitment study

This repository contains the SPSS syntax used for the article:

**Transformations in Talent Acquisition: Measuring AI’s Effects on Recruitment Efficiency and Bias**

## Files
- `analysis_spss.sps` — main SPSS syntax file
- `survey_data.csv` — anonymised survey data (to be added)
- `ai_recruitment_cleaned.sav` — cleaned SPSS dataset generated after running the syntax

## What the syntax does
- imports the CSV dataset
- labels variables
- computes the four composite dimensions:
  - Recruitment Efficiency
  - Candidate Experience
  - Bias Mitigation
  - Trust & Transparency
- runs Cronbach’s alpha reliability tests
- runs exploratory factor analysis (PAF, Varimax)
- runs regression models with controls
- produces basic descriptive outputs and diagnostics

## Important
The syntax assumes 28 Likert items, grouped as follows:
- `EFF1` to `EFF7`
- `CEX1` to `CEX7`
- `BIA1` to `BIA7`
- `TRU1` to `TRU7`

If your real variable names differ, edit the syntax before running it.

## Software
Developed for IBM SPSS Statistics v28+
