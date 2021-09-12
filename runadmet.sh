#!/bin/bash

#==============================================================================
# Software locations
FPGEN="java -jar FINGERPRINTER/FingerprintGenerator.jar"
RSCRIPT="/usr/bin/Rscript"
PREDICTIONSCRIPTS="PREDICTORS"
FPOUT="RESULTS/fps.txt"
PREDOUT="RESULTS/predicted.txt"
#==============================================================================

NO_ARGS=0
E_OPTERROR=65


SCRIPTNAME=`basename "$0"`
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



function usage() {
   echo "Usage: $0 [-f <smi file>] [-p <property>] [-h <help>] [-a <calculate prediction uncertainty>]"; exit $E_OPTERROR;
   echo "=================================================================="
   echo "Provide the number corresponding to the property to be predicted"
   echo "=================================================================="
   echo " 1: Anticommensal Effect on Human Gut Microbiota"
   echo " 2: Blood-brain-barrier penetration"
   echo " 3: Oral Bioavailability"
   echo " 4: AMES Mutagenecity"
   echo " 5: Metabolic Intrinsic Clearance"
   echo " 6: Rat Acute LD50"
   echo " 7: Drug-Induced Liver Inhibition"
   echo " 8: HERG Cardiotoxicity"
   echo " 9: Haemolytic Toxicity"
   echo "10: Myelotoxicity"
   echo "11: Urinary Toxicity"
   echo "12: Human Intestinal Absorption"
   echo "13: Hepatic Steatosis"
   echo "14: Breast Cancer Resistance Protein Inhibition"
   echo "15: Drug-Induced Choleostasis"
   echo "16: Human multidrug and toxin extrusion Inhibition"
   echo "17: Toxic Myopathy"
   echo "18: Phospholipidosis"
   echo "19: Human Bile Salt Export Pump Inhibition"
   echo "20: Organic anion transporting polypeptide 1B1/1B3/2B1 binding"
   echo "23: Phototoxicity human/in vitro"
   echo "25: Respiratory Toxicity"
   echo "26: P-glycoprotein Inhibition"
   echo "27: P-glycoprotein Substrate"
   echo "28: Mitochondrial Toxicity"
   echo "29: Carcinogenecity"
   echo "30: DMSO Solubility"
   echo "31: Human Liver Microsomal Stability"
   echo "32: Human Plasma Protein Binding"
   echo "33: hERG Liability"
   echo "34: Organic Cation Transporter 2 Inhibition"
   echo "35: Drug-induced Ototoxicity"
   echo "36: Rhabdomyolysis"
   echo "37: T1/2 Human/Mouse/Rat"
   echo "40: Cytotoxicity HepG2/NIH cell line"
   echo "41: Cytotoxicity NIH-3T3 cell line"
   echo "42: Cytotoxicity HEK-293 cell line"
   echo "43: Cytotoxicity CRL-7250 cell line"
   echo "44: Cytotoxicity HaCat cell line"
   echo "45: CYP450 1A2 Inhibition"
   echo "46: CYP450 2C19 Inhibition"
   echo "47: CYP450 2D6 Inhibition"
   echo "48: CYP450 3A4 Inhibition"
   echo "49: CYP450 2C9 Inhibition"
   echo "50: pKa dissociation constant"
   echo "51: logD Distribution coefficient (pH 7.4)"
   echo "52: logS"
   echo "53: Drug affinity to human serum albumin"
   echo "54: MDCK permeability"
   echo "55: 50% hemolytic dose"
   echo "56: Skin Penetration"
   echo "57: CYP450 2C8 Inhibition"
   echo "58: Aqueous Solubility (in phosphate saline buffer)"
   echo "==================================================================="
}

adan=0

while getopts "f:p:ah" opt; do
    case $opt in
        h)
            usage
        ;;
        f)
            echo "-f was triggered, Parameter: $OPTARG" >&2
            molfile=${OPTARG}
        ;;
        p)
            echo "-p was triggered, Parameter: $OPTARG" >&2
            ptype=${OPTARG}
        ;;
        a)  echo "-a was triggered." >&2
            adan=1
        ;;
       \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
        ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
        ;;
        *)
            usage
        ;;
    esac
done
shift $((OPTIND-1))


## initialize
retcode=0


## choose property model option and run

case $ptype in
    1)  echo "Anticommensal Effect on Human Gut Microbiota"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_anticommensal.R" $FPOUT $PREDOUT $adan 
        retcode=$?
        ;; 
    2)  echo "Blood-brain-barrier penetration"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_bbbp.R" $FPOUT $PREDOUT $adan 
        retcode=$?
        ;;
    3)  echo "Oral Bioavailability"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_bioavailability.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    4)  echo "AMES Mutagenecity"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_ames.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    5)  echo "Metabolic Intrinsic Clearance"
        $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_metabolicstability.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    6)  echo "Rat Acute LD50"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_rattoxicity.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    7)  echo "Drug-Induced Liver Inhibition"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_DILI.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    8)  echo "HERG Cardiotoxicity"
        $FPGEN -output $FPOUT -fptype FCFP6 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_hergcardiotox.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    9)  echo "Haemolytic Toxicity"
        $FPGEN -output $FPOUT -fptype FCFP6 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_hemotox.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    10) echo "Myelotoxicity"
        $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_myelotox.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    11) echo "Urinary Toxicity"
        $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_urinarytox.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    12) echo "Human Intestinal Absorption"
        $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_HIA.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    13) echo "Hepatic Steatosis"
        $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_steatosis.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    14) echo "Breast Cancer Resistance Protein Inhibition"
        $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_bcrpinhibition.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    15) echo "Drug-Induced Choleostasis"
        $FPGEN -output $FPOUT -fptype MOLPRINT2D -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_choleostasis.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    16) echo "Human multidrug and toxin extrusion Inhibition" # MATE1
        $FPGEN -output $FPOUT -fptype DFS -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_MATE1.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    17) echo "Toxic Myopathy"
        $FPGEN -output $FPOUT -fptype DFS -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_myopathy.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    18) echo "Phospholipidosis"
        $FPGEN -output $FPOUT -fptype FCFP2 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_phospholipidosis.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    19) echo "Human Bile Salt Export Pump Inhibition"
        $FPGEN -output $FPOUT -fptype ECFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_BSEP.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    20) echo "Organic anion transporting polypeptide 1B1 binding"
        $FPGEN -output $FPOUT -fptype ECFP6 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_OATP1B1.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    21) echo "Organic anion transporting polypeptide 1B3 binding"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_OATP1B3.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    22) echo "Organic anion transporting polypeptide 2B1 binding"
        $FPGEN -output $FPOUT -fptype ECFP6 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_OATP2B1.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    23) echo "Phototoxicity human"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_phototoxhuman.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    24) echo "Phototoxicity invitro"
        $FPGEN -output $FPOUT -fptype KR -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_phototoxinvitro.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    25) echo "Respiratory Toxicity"
        $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_respiratorytox.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    26) echo "P-glycoprotein Inhibition"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_pgpinhibition.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    27) echo "P-glycoprotein Substrate"
        $FPGEN -output $FPOUT -fptype ASP -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_pgpsubstrate.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    28) echo "Mitochondrial Toxicity"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_mitichondrialtox.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    29) echo "Carcinogenecity"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_carcinogenecity.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    30) echo "DMSO Solubility"
        $FPGEN -output $FPOUT -fptype ECFP2 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_DMSO.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    31) echo "Human Liver Microsomal Stability"
        $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_HLMstability.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    32) echo "Human Plasma Protein Binding"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_PPB.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    33) echo "hERG Liability"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_hergliability.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    34) echo "Organic Cation Transporter 2 Inhibition"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_OCT2inhibition.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    35) echo "Drug-induced Ototoxicity"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_ototoxicity.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    36) echo "Rhabdomyolysis"
        $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_rhabdomyolysis.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    37) echo "T1/2 Human"
        $FPGEN -output $FPOUT -fptype ASP -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_thalfhuman.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    38) echo "T1/2 Mouse"
        $FPGEN -output $FPOUT -fptype ECFP2 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_thalfmouse.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    39) echo "T1/2 Rat"
        $FPGEN -output $FPOUT -fptype KR -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_thalfrat.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    40) echo "Cytotoxicity HepG2 cell lines"
        $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicityhepg2.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    41) echo "Cytotoxicity NIH-3T3 cell lines"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicitynih.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    42) echo "Cytotoxicity HEK 293 cell lines"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicityhek.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    43) echo "Cytotoxicity CRL-7250 cell lines"
        $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicitycrl.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    44) echo "Cytotoxicity HaCat cell lines"
        $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicityhacat.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    45) echo "CYP450 1A2 Inhibition"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp1a2.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    46) echo "CYP450 2C19 Inhibition"
        $FPGEN -output $FPOUT -fptype ECFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2c19.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    47) echo "CYP450 2C9 Inhibition"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2c9.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    48) echo "CYP450 2D6 Inhibition"
        $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2d6.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    49) echo "CYP450 3A4 Inhibition"
        $FPGEN -output $FPOUT -fptype FCFP6 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp3a4.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    50) echo "pKa dissociation constant"
        $FPGEN -output $FPOUT -fptype ECFP2 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_pka.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    51) echo "logD Distribution coefficient (pH 7.4)"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_logD.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    52) echo "logS"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_logS.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    53) echo "Drug affinity to human serum albumin"
        $FPGEN -output $FPOUT -fptype AP2D -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_HSA.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    54) echo "MDCK permeability"
        $FPGEN -output $FPOUT -fptype ECFP4 -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_MDCKPerm.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    55) echo "50% hemolytic dose"
        $FPGEN -output $FPOUT -fptype ASP -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_HD50.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    56) echo "Skin penetration"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_skinpen.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    57) echo "CYP450 2C8 Inhibition"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2c8.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    58) echo "Aqueous Solubility (in phosphate saline buffer)"
        $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
        $RSCRIPT $PREDICTIONSCRIPTS"/predict_AQSOL.R" $FPOUT $PREDOUT $adan
        retcode=$?
        ;;
    *)  echo "ERROR: Ill-defined task number."
		usage;
        exit $E_OPTERROR
        ;;
esac


exit $retcode

