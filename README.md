![ants template](http://i.imgur.com/mLZ71Ai.png)
=========================================================
[![ci-docker](https://github.com/ANTsX/ANTs/actions/workflows/ci-docker.yml/badge.svg)](https://github.com/ANTsX/ANTs/actions/workflows/ci-docker.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/antsx/ants.svg)](https://hub.docker.com/repository/docker/antsx/ants)
![Downloads](https://img.shields.io/github/downloads/antsx/ants/total)
[![Anaconda-Server Badge](https://anaconda.org/aramislab/ants/badges/version.svg)](https://anaconda.org/aramislab/ants)
[![PubMed](https://img.shields.io/badge/ANTsX_paper-Open_Access-8DABFF?logo=pubmed)](https://pubmed.ncbi.nlm.nih.gov/33907199/)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code_of_conduct.md)

Advanced Normalization Tools (ANTs) is a C++ and command-line library that computes high-dimensional mappings to capture the statistics of brain structure and function. It allows one to organize, visualize and statistically explore large biomedical image sets. Additionally, it integrates imaging modalities and related information in space and time, as well as works across species or organ systems with minimal customization. 

The ANTs library is considered a state-of-the-art medical image registration and segmentation toolkit which depends on the Insight ToolKit [(ITK)](http://www.itk.org), a widely used medical image processing library to which ANTs developers contribute. ANTs and related tools have won several international and unbiased competitions.

You can also use ANTs in R ([ANTsR](https://github.com/antsx/antsr)) and Python ([ANTsPy](https://github.com/antsx/antsr)), with additional functionality for deep learning in R ([ANTsRNet](https://github.com/antsx/antsrnet)) and Python ([ANTsPyNet](https://github.com/antsx/antspynet)). These libraries also include additional functionality for interacting with the broader R and Python ecosystem.

<br />

## Installation

### Pre-compiled binaries

The easiest way to install ANTs is by downloading the latest binaries on the [Releases](https://github.com/ANTsX/ANTs/releases) page. Download the latest release under the "Assets" section, then unzip the archive. Next, add the ANTs library to your PATH:

```
export PATH=/path/to/ants/bin:$PATH
```

You can check that this worked by running a command to find the path to any ANTs function:

```
which antsRegistration
```

If that works, you should be able to use the full functionality of ANTs.

### Build from source

When necessary, you can also build ANTs from source. A minimal example on Linux or Mac looks like this:

```bash
workingDir=${PWD}
git clone https://github.com/ANTsX/ANTs.git
mkdir build install
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=${workingDir}/install \
    ../ANTs 2>&1 | tee cmake.log
make -j 4 2>&1 | tee build.log
cd ANTS-build
make install 2>&1 | tee install.log
```

More details and a full downloadable installation script can be found in the [Linux/MacOS Guide](https://github.com/ANTsX/ANTs/wiki/Compiling-ANTs-on-Linux-and-Mac-OS). Building from source will generally work on Windows as well with some additional steps explained in the [Windows Guide](https://github.com/ANTsX/ANTs/wiki/Compiling-ANTs-on-Windows-10). Alternatively, it is also possible to install ANTs via [Docker](https://hub.docker.com/r/antsx/ants) or [Conda](https://anaconda.org/aramislab/ants).

<br />

## Overview

## Examples

## Resources

There are many different resources for learning about how to use ANTs functions and the methodology behind them. 

<br />

## Contributing

If you have a question, feature request, or bug report the best way to get help is by posting an issue on the GitHub page. Please remember to give as much detail as possible to reproduce your environment. It is difficult to provide any help without being to reproduce your issue.

We welcome any new contributions and ideas to improve ANTs. If you want to contribute code, the best way to get started is by reading through the [Wiki](https://github.com/ANTsX/ANTs/wiki) to get an understanding of the project. ANTs relies heavily on ITK, so learning more about that project is also a good place to start.

<br />

## Team

Development of ANTs is led by the following people:

- [Brian B. Avants](http://stnava.github.io/Resume/) - UPENN (Creator, Algorithm Design, Implementation)
- [Nicholas J. Tustison](http://ntustison.github.io/CV/) - UVA (Compeller, Algorithm Design, Implementation Guru)
- Hans J. Johnson - UIowa (Large-Scale Application, Testing, Software design). 

The core development team consists of Gang Song (Originator), Philip A. Cook, Jeffrey T. Duda (DTI), Ben M. Kandel (Perfusion, multivariate analysis).

<br />

## References

A large collection of journal articles have been published using ANTs software. The following is a curated list of relevant articles that can be used as a guide for selecting the right methods when using ANTs.

### Image Registration

Brian B. Avants, et al. Symmetric diffeomorphic image registration with cross-correlation: evaluating automated labeling of elderly and neurodegenerative brain. Med Image Anal (2008). [[Link](http://www.ncbi.nlm.nih.gov/pubmed/17659998)]

Arno Klein, et al. Evaluation of 14 nonlinear deformation algorithms applied to human brain MRI registration. Neuroimage (2009). [[Link](http://www.ncbi.nlm.nih.gov/pubmed/19195496)]

Murphy, et al. Evaluation of registration methods on thoracic CT: the EMPIRE10 challenge. IEEE Trans Med Imaging (2011) [[Link](http://www.ncbi.nlm.nih.gov/pubmed/21632295)]


Independent Evaluation:
Template
Construction
[(2004)](http://www.ncbi.nlm.nih.gov/pubmed/15501083)[(2010)](http://www.ncbi.nlm.nih.gov/pubmed/19818860),
[Similarity Metrics](http://www.ncbi.nlm.nih.gov/pubmed/20851191),
[Multivariate
registration](http://www.ncbi.nlm.nih.gov/pubmed/18995188), [Multiple
modality analysis and statistical
bias](http://www.ncbi.nlm.nih.gov/pubmed/23151955)

### Image Segmentation

Atropos Multivar-EM Segmentation
[(link)](http://www.ncbi.nlm.nih.gov/pubmed/21373993), Multi-atlas
methods [(link)](https://scholar.google.com/scholar?q=joint+label+fusion+yushkevich&btnG=&hl=en&as_sdt=0%2C31) and [JLF](http://journal.frontiersin.org/article/10.3389/fninf.2013.00027/full), Bias
Correction [(link)](http://www.ncbi.nlm.nih.gov/pubmed/20378467), DiReCT
cortical thickness
[(link)](http://www.ncbi.nlm.nih.gov/pubmed/19150502), DiReCT in
[chimpanzees](http://www.ncbi.nlm.nih.gov/pubmed/23516289)

### Multivariate Analysis Eigenanatomy 

[(1)](http://www.ncbi.nlm.nih.gov/pubmed/23286132) [(2)](http://www.ncbi.nlm.nih.gov/pubmed/23475817)

### Prior-Based Eigenanatomy 
[(in
prep)](http://www.ncbi.nlm.nih.gov/pubmed/?), Sparse CCA
[(1)](http://www.ncbi.nlm.nih.gov/pubmed/20083207),
[(2)](http://www.ncbi.nlm.nih.gov/pubmed/20879247), Sparse Regression
[(link)](http://link.springer.com/chapter/10.1007%2F978-3-642-38868-2_8)


## Funding

Current support comes from R01-EB031722. Previous support includes R01-EB006266-01 and K01-ES025432-01.




The [ANTs handout](https://github.com/stnava/ANTsTutorial/raw/master/handout/antsHandout.pdf), part of forthcoming [ANTs tutorial](https://github.com/stnava/ANTsTutorial) material [here](https://github.com/stnava/ANTsTutorial) and [here](https://rpubs.com/antsr/).

[ANTsTalk - subject to change at any moment](http://stnava.github.io/ANTsTalk/)

[ANTsRegistrationTalk - subject to change at any moment](http://stnava.github.io/ANTsRegistrationTalk/)




ImageMath Useful!
-----------------

morphology, GetLargestComponent, CCA, FillHoles ... much more!

Application Domains
-------------------

### Frontotemporal degeneration [PENN FTD center](http://ftd.med.upenn.edu)

### Multimodality Neuroimaging

-   [Structural MRI](http://jeffduda.github.io/NeuroBattery/)
-   Functional MRI
-   Network Analysis

### Lung Imaging

-   Structure
-   Perfusion MRI
-   Branching

### Multiple sclerosis (lesion filling) [example](https://github.com/armaneshaghi/LesionFilling_example)

Background & Theory
----------------------------------------------------------

-   The
    [SyN](http://www.ncbi.nlm.nih.gov/pubmed/?term=%22SyN%22+AND+%22Avants+B%22)
    and [N4 bias
    correction](http://www.ncbi.nlm.nih.gov/pubmed/?term=%22N4%22+AND+%22Tustison+N4ITK%22)
    papers and other relevant references in
    [Pubmed](http://www.ncbi.nlm.nih.gov/pubmed/?term=%22Tustison+N%22+AND+%22Avants+B%22)

-   Visualization: e.g. [a gource of ANTs
    development](http://vimeo.com/66781467)

-   [DiReCT](http://www.ncbi.nlm.nih.gov/pubmed/?term=%22DIRECT%22+AND+%22Avants%22+AND+DAS)
    cortical thickness
    [papers](http://www.ncbi.nlm.nih.gov/pubmed/?term=%22Cortical+Thickness%22+AND+%22Avants%22)

-   A
    [folder](https://sourceforge.net/projects/advants/files/Documentation/)
    of relevant docs:
    [segmentation](http://sourceforge.net/projects/advants/files/Documentation/atropos.pdf/download),
    [registration](http://sourceforge.net/projects/advants/files/Documentation/antstheory.pdf/download),
    [usage(old)](http://sourceforge.net/projects/advants/files/Documentation/ants.pdf/download),
    [for clinical
    apps](http://sourceforge.net/projects/advants/files/Documentation/ANTSMethodologySummary.docx/download)

-   ANTs redesigned for generality, automation, multi-core computation
    with ITKv4

-   Dev'd ITKv4 with Kitware, GE, Natl. Lib of Medicine & Academia


ANTs has won several unbiased & international competitions
----------------------------------------------------------

-   ANTs finished in 1st rank in [Klein 2009 intl. brain mapping
    competition](http://www.ncbi.nlm.nih.gov/pubmed/19195496)

-   ANTs finished 1st overall in [EMPIRE10 intl. lung mapping
    competition](http://www.ncbi.nlm.nih.gov/pubmed/21632295)

-   ANTs is the standard registration for
    [MICCAI-2013](http://www.miccai2013.org/) segmentation competitions

-   Conducting ANTs-based R tutorial @ MICCAI-2013

-   ITK-focused Frontiers in Neuroinformatics research topic
    [here](http://www.frontiersin.org/neuroinformatics/researchtopics/neuroinformatics_with_the_insi/1580)

-   Won the [BRATS 2013 challenge](http://martinos.org/qtim/miccai2013/) with [ANTsR](http://stnava.github.io/ANTsR/)

-   Won the best paper award at the [STACOM 2014 challenge](http://www.cardiacatlas.org/web/stacom2014/home)

Learning about ANTs (examples, etc.)
----------------------------------------------------------

### General

* **antsRegistration** [bash example](https://github.com/stnava/ANTs/blob/master/Scripts/newAntsExample.sh)

* **antsRegistration with mask** [(bash, ANTsR and ANTsPy examples)](https://github.com/ntustison/antsRegistrationWithMaskExample)

* **ANTs and ITK** [paper](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4009425/)

* **Large deformation** [(bash, ANTsR and ANTsPy examples)](http://stnava.github.io/C/)

* **Automobile** [(bash and ANTsR examples)](http://stnava.github.io/cars/)

* **Asymmetry** [example](http://stnava.github.io/asymmetry/)

* **Point-set** [mapping](http://stnava.github.io/chicken/) which includes the PSE metric and affine and deformable registration with (labeled) pointsets or iterative closest point

* **Feature matching** [example](http://stnava.github.io/featureMatching/) ... not up to date ...

* **Global optimization** [example](http://stnava.github.io/butterfly/)

* **Patch-based super resolution** [example](https://github.com/ntustison/NonLocalSuperResolutionExample)

* **Image denoising** [(bash, ANTsR and ANTsPy examples)](https://github.com/ntustison/DenoiseImageExample)

* **Visualization** [example](https://github.com/ntustison/antsVisualizationExamples)

* **Morphing** [example](http://stnava.github.io/Morpheus/)

* **Bibliography** [bibtex of ANTs-related papers](https://github.com/stnava/ANTsBibliography)

* **ANTs** [google scholar page](http://scholar.google.com/citations?user=ox-mhOkAAAAJ&hl=en)

### Neuro

* **Basic Brain Mapping** [(bash and ANTsR examples)](http://stnava.github.io/BasicBrainMapping/)

* **Template construction** [(bash, ANTsR and ANTsPy examples)](http://ntustison.github.io/TemplateBuildingExample/)

* **Single subject template construction** [example](https://github.com/ntustison/SingleSubjectTemplateExample)

* **Pre-built ANTs templates with spatial priors** [download](http://figshare.com/articles/ANTs_ANTsR_Brain_Templates/915436) including an [MNI version](https://figshare.com/articles/ANTs_files_for_mni_icbm152_nlin_sym_09a/8061914).

* **Brain extraction** [(bash and ANTsR examples)](https://github.com/ntustison/antsBrainExtractionExample)

* **N4 bias correction <-> segmentation** [(bash, ANTsR and ANTsPy examples)](https://github.com/ntustison/antsAtroposN4Example)

* **Cortical thickness** [example](https://github.com/ntustison/antsCorticalThicknessExample)

* **"Cooking" tissue priors for templates**
  [example](https://github.com/ntustison/antsCookTemplatePriorsExample)
  (after you build your template)

* **Multi-atlas joint label/intensity fusion examples** [(bash and ANTsR examples 1)](https://github.com/ntustison/MalfLabelingExample) [example 2](https://github.com/qureai/Multi-Atlas-Segmentation) (thanks to @chsasank)

* **The ANTs Cortical Thickness Pipeline** [example](https://github.com/ntustison/KapowskiChronicles/blob/master/paper2.pdf?raw=true)

* **Chimpanzee cortical thickness** [example](https://github.com/stnava/WHopkinsNHP/)

* **Brain tumor segmentation** [example](https://github.com/ntustison/BRATS2013/tree/master/SimpleExample)

* **Eigenanatomy** for [multivariate neuroimage analysis](http://www.ncbi</a>.nlm.nih.gov/pubmed/23269595) via
    [PCA](http://www.ncbi.nlm.nih.gov/pubmed/23286132) &
    [CCA](http://www.ncbi.nlm.nih.gov/pubmed/20083207)

* **fMRI or Motion Correction** [example](http://stnava.github.io/fMRIANTs/)

* **fMRI reproducibility** [example](http://stnava.github.io/RfMRI/)

* **fMRI prediction** [example](http://stnava.github.io/Haxby2001/) ... WIP ...

* **Partial EPI slab to T1 image registration** [example](https://github.com/ntustison/PartialSlabEpiT1ImageRegistration)

### Lung

* **CT lung registration** [(bash and ANTsR examples)](https://github.com/ntustison/antsCtLungRegistrationExample)

* **Lung mask registration** [example](https://github.com/ntustison/ProtonCtLungMaskRegistration)

* **Lung and lobe estimation** [example](https://github.com/ntustison/LungAndLobeEstimationExample)

* **Lung ventilation-based segmentation** [example](https://github.com/ntustison/LungVentilationSegmentationExample)

### Cardiac

* **Cardiac** [example](http://stnava.github.io/LabelMyHeart)

### Misc.

Presentations: e.g. [a Prezi about
ANTs](http://prezi.com/mwrmcm-h9-w4/ants/?kw=view-mwrmcm-h9-w4&rc=ref-40024395)
(WIP)

Reproducible science as a teaching tool: e.g. [compilable ANTs
tutorial](https://github.com/stnava/ANTS_MultiModality) (WIP)

Other examples [slideshow](http://brianavants.wordpress.com)

Landmark-based mapping for e.g. hippocampus [discussed
here](https://sourceforge.net/p/advants/discussion/840261/thread/1cb7b165/?limit=50)

Brief ANTs segmentation [video](http://vimeo.com/67814201)

**Benchmarks** for expected memory and computation time: [results](https://github.com/gdevenyi/antsRegistration-benchmarking).  These
results are, of course, system and data dependent.

References
----------------------------------------------------------

[Google
Scholar](http://scholar.google.com/scholar?q=Advanced+Normalization+Tools+%22ANTs%22+-ant&hl=en&as_sdt=1%2C39&as_ylo=2008&as_yhi=)

[Pubmed](http://www.ncbi.nlm.nih.gov/pubmed?term=%22Avants%20B%22%20OR%20%22Tustison%20N%22)

Boilerplate ANTs
------------------

Here is some boilerplate regarding ants image processing:

We will analyze multiple modality neuroimaging data with Advanced
Normalization Tools (ANTs) version >= 2.1 [1]
(http://stnava.github.io/ANTs/).  ANTs has proven performance in
lifespan analyses of brain morphology [1] and function [2] in both
adult [1] and pediatric brain data [2,5,6] including infants [7].
ANTs employs both probabilistic tissue segmentation (via Atropos [3])
and machine learning methods based on expert labeled data (via joint
label fusion [4]) in order to maximize reliability and consistency of
multiple modality image segmentation.  These methods allow detailed
extraction of critical image-based biomarkers such as volumes
(e.g. hippocampus and amygdala), cortical thickness and area and
connectivity metrics derived from structural white matter [13] or
functional connectivity [12]. Critically, all ANTs components are
capable of leveraging multivariate image features as well as expert
knowledge in order to learn the best segmentation strategy available
for each individual image [3,4].  This flexibility in segmentation and
the underlying high-performance normalization methods have been
validated by winning several internationally recognized medical image
processing challenges conducted within the premier conferences within
the field and published in several accompanying articles
[8][9][10][11].

References

[1] http://www.ncbi.nlm.nih.gov/pubmed/24879923

[2] http://www.ncbi.nlm.nih.gov/pubmed/24817849

[3] http://www.ncbi.nlm.nih.gov/pubmed/21373993

[4] http://www.ncbi.nlm.nih.gov/pubmed/21237273

[5] http://www.ncbi.nlm.nih.gov/pubmed/22517961

[6] http://www.ncbi.nlm.nih.gov/pubmed/24033570

[7] http://www.ncbi.nlm.nih.gov/pubmed/24139564

[8]  http://www.ncbi.nlm.nih.gov/pubmed/21632295

[9] http://www.ncbi.nlm.nih.gov/pubmed/19195496

[10] http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3837555/

[11] http://nmr.mgh.harvard.edu/~koen/MenzeTMI2014.pdf

[12] http://www.ncbi.nlm.nih.gov/pubmed/23813017

[13] http://www.ncbi.nlm.nih.gov/pubmed/24830834


Current support:  
* R01-EB031722

Previous support: 
* R01-EB006266-01
* K01-ES025432-01


![ants chimp](http://i.imgur.com/4tPvy05.png)
