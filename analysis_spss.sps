* ============================================================
* SPSS Syntax File
* Article: Transformations in Talent Acquisition:
*          Measuring AI’s Effects on Recruitment Efficiency and Bias
* Authors: Amina Chandad et al.
* Version: Reproducibility syntax for GitHub / repository deposit
* Software: IBM SPSS Statistics v28+
* ============================================================.

SET DECIMAL DOT.
SET PRINTBACK=ON.
SET MPRINT=ON.

* ------------------------------------------------------------
* 0. USER INSTRUCTIONS
* ------------------------------------------------------------
* Before running this syntax:
* 1) Place your dataset in the same folder as this syntax file.
* 2) Update the GET DATA path below if needed.
* 3) Ensure your CSV contains the variable names used here.
*
* Suggested item structure (28 survey items):
* Recruitment Efficiency      : EFF1 EFF2 EFF3 EFF4 EFF5 EFF6 EFF7
* Candidate Experience        : CEX1 CEX2 CEX3 CEX4 CEX5 CEX6 CEX7
* Bias Mitigation / Fairness  : BIA1 BIA2 BIA3 BIA4 BIA5 BIA6 BIA7
* Trust & Transparency        : TRU1 TRU2 TRU3 TRU4 TRU5 TRU6 TRU7
*
* Suggested control variables:
* firm_size      (0=SME, 1=Large enterprise)
* industry       (categorical numeric code)
* geo_region     (categorical numeric code)
* ai_maturity    (0=pilot/partial, 1=full deployment)
* role_level     (0=operational/mid, 1=managerial/senior)
*
* If your names differ, use RENAME VARIABLES or edit the syntax.
* ------------------------------------------------------------.


* ------------------------------------------------------------
* 1. IMPORT DATA
* ------------------------------------------------------------.

CD '.'.

GET DATA
  /TYPE=TXT
  /FILE='survey_data.csv'
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
    id F8.0
    firm_size F1.0
    industry F2.0
    geo_region F2.0
    ai_maturity F1.0
    role_level F1.0
    EFF1 TO EFF7 F8.2
    CEX1 TO CEX7 F8.2
    BIA1 TO BIA7 F8.2
    TRU1 TO TRU7 F8.2.
CACHE.
EXECUTE.

DATASET NAME ai_recruitment WINDOW=FRONT.

* ------------------------------------------------------------
* 2. VARIABLE LABELS
* ------------------------------------------------------------.

VARIABLE LABELS
  firm_size   'Company size (0=SME, 1=Large enterprise)'
  industry    'Industry sector'
  geo_region  'Geographic region'
  ai_maturity 'AI deployment maturity (0=pilot/partial, 1=full deployment)'
  role_level  'Respondent role level (0=operational/mid, 1=managerial/senior)'.

VALUE LABELS
  firm_size 0 'SME (<500 employees)' 1 'Large enterprise (>500 employees)'
  ai_maturity 0 'Pilot/partial AI use' 1 'Full AI deployment'
  role_level 0 'Operational or mid-level' 1 'Managerial or senior'.

VARIABLE LABELS
  EFF1 'AI reduces time-to-hire'
  EFF2 'AI improves screening speed'
  EFF3 'AI reduces administrative workload'
  EFF4 'AI improves recruiter productivity'
  EFF5 'AI helps prioritise candidates efficiently'
  EFF6 'AI improves consistency of initial screening'
  EFF7 'AI improves resource allocation in recruitment'

  CEX1 'AI improves response speed to candidates'
  CEX2 'AI improves communication clarity'
  CEX3 'AI improves application follow-up'
  CEX4 'AI creates a smoother application journey'
  CEX5 'AI improves scheduling responsiveness'
  CEX6 'AI helps maintain structured interactions'
  CEX7 'AI improves overall candidate experience'

  BIA1 'AI reduces subjectivity in screening'
  BIA2 'AI supports more equitable shortlisting'
  BIA3 'AI helps identify bias in recruitment decisions'
  BIA4 'AI contributes to fairer evaluations'
  BIA5 'AI reduces favouritism'
  BIA6 'AI helps standardise candidate assessment'
  BIA7 'AI contributes to diversity-sensitive screening'

  TRU1 'AI decisions are easy to explain'
  TRU2 'AI tools are transparent to recruiters'
  TRU3 'Candidates can understand AI-assisted decisions'
  TRU4 'AI recruitment tools are trustworthy'
  TRU5 'AI tools respect data privacy expectations'
  TRU6 'Recruiters feel confident using AI outputs'
  TRU7 'AI systems operate with sufficient transparency'.

FORMATS EFF1 TO TRU7 (F3.2).

* ------------------------------------------------------------
* 3. MISSING VALUES AND SCREENING
* ------------------------------------------------------------.

MISSING VALUES EFF1 TO TRU7 (99).
MISSING VALUES firm_size industry geo_region ai_maturity role_level (99).

FREQUENCIES VARIABLES=firm_size industry geo_region ai_maturity role_level
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=EFF1 TO TRU7
  /STATISTICS=MEAN STDDEV MIN MAX.

* ------------------------------------------------------------
* 4. SCALE CONSTRUCTION
* ------------------------------------------------------------.

COMPUTE efficiency = MEAN(EFF1 TO EFF7).
COMPUTE candidate_experience = MEAN(CEX1 TO CEX7).
COMPUTE bias_mitigation = MEAN(BIA1 TO BIA7).
COMPUTE trust_transparency = MEAN(TRU1 TO TRU7).
EXECUTE.

VARIABLE LABELS
  efficiency 'Composite score: Recruitment Efficiency'
  candidate_experience 'Composite score: Candidate Experience'
  bias_mitigation 'Composite score: Bias Mitigation'
  trust_transparency 'Composite score: Trust and Transparency'.

DESCRIPTIVES VARIABLES=efficiency candidate_experience bias_mitigation trust_transparency
  /STATISTICS=MEAN STDDEV MIN MAX.

* ------------------------------------------------------------
* 5. RELIABILITY ANALYSIS (CRONBACH'S ALPHA)
* ------------------------------------------------------------.

RELIABILITY
  /VARIABLES=EFF1 EFF2 EFF3 EFF4 EFF5 EFF6 EFF7
  /SCALE('Recruitment Efficiency') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR.

RELIABILITY
  /VARIABLES=CEX1 CEX2 CEX3 CEX4 CEX5 CEX6 CEX7
  /SCALE('Candidate Experience') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR.

RELIABILITY
  /VARIABLES=BIA1 BIA2 BIA3 BIA4 BIA5 BIA6 BIA7
  /SCALE('Bias Mitigation') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR.

RELIABILITY
  /VARIABLES=TRU1 TRU2 TRU3 TRU4 TRU5 TRU6 TRU7
  /SCALE('Trust and Transparency') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR.

* ------------------------------------------------------------
* 6. EXPLORATORY FACTOR ANALYSIS (EFA)
* ------------------------------------------------------------.

FACTOR
  /VARIABLES EFF1 TO EFF7 CEX1 TO CEX7 BIA1 TO BIA7 TRU1 TO TRU7
  /MISSING LISTWISE
  /ANALYSIS EFF1 TO EFF7 CEX1 TO CEX7 BIA1 TO BIA7 TRU1 TO TRU7
  /PRINT INITIAL EXTRACTION ROTATION KMO UNIVARIATE CORRELATION
  /FORMAT BLANK(.30) SORT
  /CRITERIA FACTORS(4) ITERATE(25)
  /EXTRACTION PAF
  /ROTATION VARIMAX
  /METHOD=CORRELATION.

* ------------------------------------------------------------
* 7. CORRELATIONS
* ------------------------------------------------------------.

CORRELATIONS
  /VARIABLES=efficiency candidate_experience bias_mitigation trust_transparency ai_maturity
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* ------------------------------------------------------------
* 8. REGRESSION ANALYSES
* Main predictor: ai_maturity
* Controls: firm_size industry geo_region
* ------------------------------------------------------------.

REGRESSION
  /DEPENDENT efficiency
  /METHOD=ENTER ai_maturity firm_size industry geo_region
  /STATISTICS COEFF OUTS R ANOVA COLLIN CI(95)
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /SAVE PRED(pred_eff) RESID(res_eff) ZPRED(zpred_eff) ZRESID(zres_eff).

REGRESSION
  /DEPENDENT candidate_experience
  /METHOD=ENTER ai_maturity firm_size industry geo_region
  /STATISTICS COEFF OUTS R ANOVA COLLIN CI(95)
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /SAVE PRED(pred_cex) RESID(res_cex) ZPRED(zpred_cex) ZRESID(zres_cex).

REGRESSION
  /DEPENDENT bias_mitigation
  /METHOD=ENTER ai_maturity firm_size industry geo_region
  /STATISTICS COEFF OUTS R ANOVA COLLIN CI(95)
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /SAVE PRED(pred_bia) RESID(res_bia) ZPRED(zpred_bia) ZRESID(zres_bia).

REGRESSION
  /DEPENDENT trust_transparency
  /METHOD=ENTER ai_maturity firm_size industry geo_region
  /STATISTICS COEFF OUTS R ANOVA COLLIN CI(95)
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /SAVE PRED(pred_tru) RESID(res_tru) ZPRED(zpred_tru) ZRESID(zres_tru).

* ------------------------------------------------------------
* 9. REGRESSION DIAGNOSTICS
* ------------------------------------------------------------.

EXAMINE VARIABLES=res_eff res_cex res_bia res_tru
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE.

* ------------------------------------------------------------
* 10. DESCRIPTIVE TABLES FOR MANUSCRIPT
* ------------------------------------------------------------.

MEANS TABLES=efficiency candidate_experience bias_mitigation trust_transparency BY ai_maturity
  /CELLS=MEAN COUNT STDDEV.

FREQUENCIES VARIABLES=firm_size ai_maturity role_level
  /BARCHART FREQ
  /ORDER=ANALYSIS.

* ------------------------------------------------------------
* 11. SAVE CLEANED DATASET
* ------------------------------------------------------------.

SAVE OUTFILE='ai_recruitment_cleaned.sav'.

* ------------------------------------------------------------
* END OF FILE
* ------------------------------------------------------------.
