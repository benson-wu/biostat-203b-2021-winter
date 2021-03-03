library(shiny)
library(ggplot2)
library(plotly)
library(shinythemes)
library(shinydashboard)
library(tab)
library(Hmisc)
library(tidyverse)
library(shinyjs)
library(ggtext)

# This script generates the lists needed for the shiny app
variable_categories <- c("Demographic", "Admission",
                         "Lab measurements", "Vitals")
demographic_variables <- c("Insurance status" = "insurance",
                           "Language" = "language",
                           "Marital status" = "marital_status",
                           "Ethnicity" ="ethnicity",
                           "Sex" = "gender",
                           "Age at admission" = "age_at_adm")

admission_variables <- c("First care unit" ="first_careunit",
                         "Last care unit" = "last_careunit",
                         "Intime" = "intime",
                         "Outtime" = "outtime",
                         "Length of stay" = "los",
                         "Admit time" = "admittime",
                         "Discharge time" = "dischtime",
                         "Death time" = "deathtime",
                         "Admission type" = "admission_type",
                         "Admission location" = "admission_location",
                         "Discharge location" = "discharge_location",
                         "Emergency dep. registration time" = "edregtime",
                         "Emergency dep. discharge time" = "edouttime",
                         "Death during hospitalization" = "hospital_expire_flag",
                         "Age during anchor year" = "anchor_age",
                         "Anchor year" = "anchor_year",
                         "Anchor year group" = "anchor_year_group",
                         "Date of death" = "dod",
                         "Death within 30 days" = "died_within_30_days")

lab_variables <- c("Bicarbonate" = "bicarbonate",
                   "Calcium" = "calcium",
                   "Chloride" = "chloride",
                   "Creatinine" = "creatinine",
                   "Glucose" = "glucose",
                   "Magnesium" = "magnesium",
                   "Potassium" = "potassium",
                   "Sodium" = "sodium",
                   "Hematocrit" = "hematocrit",
                   "White blood cell count" = "wbc",
                   "Lactate" = "lactate")
vitals_variables <- c("Heart rate" = "heart_rate",
                      "Non-invasive sys. blood pressure" = "non_invasive_blood_pressure_systolic",
                      "Non-invasive mean blood pressure" = "non_invasive_blood_pressure_mean",
                      "Respiratory rate" = "respiratory_rate",
                      "Temperature fahrenheit" = "temperature_fahrenheit",
                      "Arterial systolic blood pressure" = "arterial_blood_pressure_systolic",
                      "Arterial mean blood pressure" = "arterial_blood_pressure_mean")

categorical_variables <- c("insurance",
                           "language",
                           "marital_status",
                           "ethnicity",
                           "gender", 
                           "first_careunit",
                           "last_careunit",
                                       "admission_type",
                                       "admission_location",
                                       "discharge_location",
                                       "hospital_expire_flag",
                                       "anchor_age",
                                       "anchor_year",
                                       "anchor_year_group",
                                       "died_within_30_days")

many_categories_variables<-c("ethnicity", "first_careunit", "last_careunit", 
                             "admission_type", "admission_location", 
                             "discharge_location")

continuous_variables <- c("age_at_adm", 
                          "intime",
                          "outtime",
                          "los",
                          "admittime",
                          "dischtime",
                          "deathtime",
                          "edregtime",
                          "edouttime",
                          "dod",
                          "bicarbonate",
                          "calcium",
                          "chloride",
                          "creatinine",
                          "glucose",
                          "magnesium",
                          "potassium",
                          "sodium",
                          "hematocrit",
                          "wbc",
                          "lactate",
                          "heart_rate",
                          "non_invasive_blood_pressure_systolic",
                          "non_invasive_blood_pressure_mean",
                          "respiratory_rate",
                          "temperature_fahrenheit",
                          "arterial_blood_pressure_systolic",
                          "arterial_blood_pressure_mean")

stratification_choices<-c("No", "Yes")

caption1<-"Note: Outliers that fall more than 1.5 times the interquartile range" 
caption2<-" above the third quartile or below the " 
caption3<-"first quartile are excluded from the plot"

#Data cleaning 
# We will make nonsensical values into NA
library(stringr)
if (str_detect(os, "Linux")) {
  working_path <- "/home/buwenson/biostat-203b-2021-winter"
} else if (str_detect(os, "macOS")) {
  working_path <- 
    "/Users/bensonwu/Documents/UCLA/2020-2021/Winter 2021/BIOSTAT_203B/biostat-203b-2021-winter"
}

#Read in data
icu_cohort <- readRDS(str_c(working_path, "/hw3/mimiciv_shiny/icu_cohort.rds"))

#Language
icu_cohort$language <- recode(icu_cohort$language, 
                                     "?" = "NOT ENGLISH")
#Marital status
icu_cohort$marital_status[icu_cohort$marital_status == ""] <- NA

#Ethnicity 
icu_cohort$ethnicity[icu_cohort$ethnicity == "UNKNOWN"] <- NA
icu_cohort$ethnicity[icu_cohort$ethnicity == "UNABLE TO OBTAIN"] <- NA

#Sex
icu_cohort$gender<-recode(icu_cohort$gender, `F` = "Female", `M` = "Male")

#Factorize death within 30 days 
icu_cohort$died_within_30_days <- factor(icu_cohort$died_within_30_days)
icu_cohort$died_within_30_days<-recode(icu_cohort$died_within_30_days,
                                       `0` = "Did not die within 30 days of ICU admission",
                                       `1` = "Died within 30 days of ICU admission")







