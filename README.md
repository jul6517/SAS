# Compared placebo to medication on health outcomes and patient characteristics by SAS <!-- omit in toc -->

## Introduction
This README file provides an overview of the SAS project completed by Hsiang-Ching Huang (Juliana). The project involved performing various tasks using SAS programming to analyze healthcare data.

## Project Description
The project tasks included data cleaning, statistical analysis, propensity score matching, survival analysis, and merging datasets. Each task was completed according to the provided instructions.

## File Structure
The main project file is named sas sample.pdf. It contains all the SAS code and results for the tasks assigned.

## Instructions for Running the Code
To run the SAS code provided in SAS, ensure that SAS software is installed on your computer. Open the file in SAS and execute each task sequentially.

## Results
Each task in SAS is numbered, and under each numbered task, you'll find the corresponding SAS code and results.

## Conclusion
The project yielded valuable insights into the healthcare data analyzed. Detailed findings for each task are provided in SAS.

## Contact Information
If you have any questions or need further clarification, feel free to contact us at jul6517@gmail.com.

# Dataset

## Study1 Dataset

- **Source**: data contains basic information on patients information in clinical trials (placebo vs medication) 
- **Description**: This dataset contains information about patients enrolled in a clinical study.
- **Format**: CSV (Comma-Separated Values)
- **Preprocessing Steps**: 
  - Removed duplicates and invalid records.
  - Imputed missing values using mean imputation for numerical variables and mode imputation for categorical variables.
  - Round up age to integer
- **Variables**:
  - **id**: Patient ID (Integer)
  - **rx**: Treatment received (Categorical: 1=placebo, 2=treatment)
  - **age**: Age of the patient (Numeric: Years)
  - **bmi**: Body Mass Index (Numeric: kg/m^2)
  - **female**: Gender of the patient (Binary: 0=male, 1=female)
  - **readmission**: 90-day readmission status (Binary: 0=No, 1=Yes)
  - **comorbidity_index**: Severity of comorbidity (Categorical: 1-2=light, 3=moderate, 4-5=severe)
  - **charges**: Total hospital charges (Numeric: USD)
  - **los**: Length of hospital stay (Numeric: Days)
  - **tract**: Census tract (String: Census tract identifier)
  - 
## Survival Dataset
- **Source**: data contains basic information on patients' outcomes in clinical trials (placebo vs medication) 
- **Description**: This dataset contains information about patients' outcomes enrolled in a clinical study.
- **Format**: CSV (Comma-Separated Values)
- **Preprocessing Steps**: 
  - Removed duplicates and invalid records.
  - Imputed missing values using mean imputation for numerical variables and mode imputation for categorical variables.
- **Variables**:
  - **id**: Patient ID (Integer)
  - **time**: true = event, false= censor
 
## Social_characteristics Dataset
- **Source**: data contains social characteristics information on patients in clinical trials (placebo vs medication) 
- **Description**: This dataset contains information about patients enrolled in a clinical study.
- **Format**: CSV (Comma-Separated Values)
- **Preprocessing Steps**: 
  - Removed first row
  - Substring GEO_ID to keep only characters after US (for example: 1400000US42001030101 – > 42001030101) and keep that to a new column called “tract”
  - Clean up name column separate them into columns by “,”
- **Variables**:
  - **GEO_ID**: Geographical ID (Integer)
  - **Name**: the name of the locaion
 
  
## data_dictionary_include Dataset
- **Source**: data contains social characteristics information on patients in clinical trials (placebo vs medication) 
- **Description**: This dataset contains information about patients enrolled in a clinical study.
- **Format**: CSV (Comma-Separated Values)
- **Preprocessing Steps**: 
  - Removed first row
  - Substring GEO_ID to keep only characters after US (for example: 1400000US42001030101 – > 42001030101) and keep that to a new column called “tract”
  - Clean up name column separate them into columns by “,”
- **Variables**: 
  - **Variable**: SELECTED SOCIAL CHARACTERISTICS IN THE UNITED STATES
