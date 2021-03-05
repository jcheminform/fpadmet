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
```
bash runadmet.sh -f molecule.smi -p ## -a 
```
where ## can be one of the following:

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
20: Organic anion transporting polypeptide 1B1/1B3/2B1 binding
23: Phototoxicity human/in vitro
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
37: T1/2 Human/Mouse/Rat
40: Cytotoxicity HepG2/NIH 3T3/HEK 293/CRL-7250/HaCat cell line
45: CYP450 1A2/2C19/2D6/3A4/2C9 Inhibition
50: pKa dissociation constant
51: logD Distribution coefficient (pH 7.4)
52: logS
53: Drug affinity to human serum albumin
54: MDCK permeability
```


