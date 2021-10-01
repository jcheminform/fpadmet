# FPADMET

FPADMET is a compilation of molecular fingerprint-based predictive models for ADMET properties. The software uses a combination of R and Java. To use FPADMET, please follow the instructions below:

## Java installation
```
sudo apt install default-jre
sudo apt install default-jdk
```
## R installation
For the Ubuntu 18.04 server
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
sudo apt update
sudo apt install r-base
```

## R package installation
```
bash installpackages.sh ranger
bash installpackages.sh caret
bash installpackages.sh quantregForest
bash installpackages.sh randomForest
```

## Using FPADMET

Usage of FPADMET is governed by a bash script. The input to the script is a file containing SMILES strings. The "-a" option allows for the calculation of prediction uncertainty (in the case of regression) and confidence (for classification). The output files are written to the **RESULTS** directory. For regression, a prediction uncertainty is calculated using quantile regression. For classification, conformal prediction is used to calculate a confidence (how certain the model is that the prediction is a singleton) and a credibility. If the credibility is low this means that any existing hypothesis about the label of the new object is unlikely i.e. we are dealing with an unknown testing label.
```
bash runadmet.sh -f molecule.smi -p ## -a 
```
**where "##" can be one of the following:**



```
 1: Anticommensal Effect on Human Gut Microbiota
 2: Blood–brain-barrier penetration
 3: Oral Bioavailability
 4: AMES Mutagenecity
 5: Metabolic Stability
 6: Rat Acute LD50
 7: Drug-Induced Liver Inhibition
 8: HERG Cardiotoxicity
 9: Haemolytic Toxicity
10: Myelotoxicity
11: Urinary Toxicity
12: Human Intestinal Absorption
13: Hepatic Steatosis
14: Breast Cancer Resistance Protein Inhibition
15: Drug-Induced Choleostasis
16: Human multidrug and toxin extrusion Inhibition
17: Toxic Myopathy
18: Phospholipidosis
19: Human Bile Salt Export Pump Inhibition
20: Organic anion transporting polypeptide 1B1 binding
21: Organic anion transporting polypeptide 1B3 binding
22: Organic anion transporting polypeptide 2B1 binding
23: Phototoxicity human
24: Phototoxicity in vitro
25: Respiratory Toxicity
26: P-glycoprotein Inhibition
27: P-glycoprotein Substrate
28: Mitochondrial Toxicity
29: Carcinogenecity
30: DMSO Solubility
31: Human Liver Microsomal Stability
32: Human Plasma Protein Binding
33: hERG Liability
34: Organic Cation Transporter 2 Inhibition
35: Drug-induced Ototoxicity
36: Rhabdomyolysis
37: T1/2 Human
38: T1/2 Mouse
39: T1/2 Rat
40: Cytotoxicity HepG2 cell line
41: Cytotoxicity NIH 3T3 cell line
42: Cytotoxicity HEK 293 cell line
43: Cytotoxicity CRL-7250 cell line
44: Cytotoxicity HaCat cell line
45: CYP450 1A2 Inhibition
46: CYP450 2C19 Inhibition
47: CYP450 2C9 Inhibition
48: CYP450 2D6 Inhibition
49: CYP450 3A4 Inhibition
50: pKa dissociation constant
51: logD Distribution coefficient (pH 7.4)
52: logS
53: Drug affinity to human serum albumin
54: MDCK permeability
55: 50% hemolytic dose
56: Skin penetration
```

## Citing FP-ADMET
If you use FP-ADMET in your work, kindly cite the following paper 

Venkatraman, V. FP-ADMET: a compendium of fingerprint-based ADMET prediction models. J Cheminform 13, 75 (2021). https://doi.org/10.1186/s13321-021-00557-5


