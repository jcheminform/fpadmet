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

