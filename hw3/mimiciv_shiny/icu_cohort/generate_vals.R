
# This script generates the lists needed for the shiny app

# variable_categories <- c("Demographic", "Admission", 
#                          "Lab measurements", "Vitals")
# demographic_variables <- c("Insurance status" = "insurance", 
#                            "Language" = "language", 
#                            "Marital status" = "marital_status",
#                            "Ethnicity" ="ethnicity", 
#                            "Sex" = "gender", 
#                            "Age at admission" = "age_at_adm")
# 
# admission_variables <- c("First care unit" ="first_careunit",
#                          "Last care unit" = "last_careunit", 
#                          "Intime" = "intime", 
#                          "Outtime" = "outtime", 
#                          "Length of stay" = "los", 
#                          "Admit time" = "admittime", 
#                          "Discharge time" = "dischtime", 
#                          "Death time" = "deathtime",
#                          "Admission type" = "admission_type", 
#                          "Admission location" = "admission_location", 
#                          "Discharge location" = "discharge_location", 
#                          "Emergency dep. registration time" = "edregtime", 
#                          "Emergency dep. discharge time" = "edouttime", 
#                          "Death during hospitalization" = "hospital_expire_flag", 
#                          "Age during anchor year" = "anchor_age", 
#                          "Anchor year" = "anchor_year", 
#                          "Anchor year group" = "anchor_year_group", 
#                          "Date of death" = "dod", 
#                          "Death within 30 days" = "died_within_30_days")
# 
# lab_variables <- c("Bicarbonate" = "bicarbonate", 
#                    "Calcium" = "calcium", 
#                    "Chloride" = "chloride", 
#                    "Creatinine" = "creatinine",
#                    "Glucose" = "glucose", 
#                    "Magnesium" = "magnesium", 
#                    "Potassium" = "potassium", 
#                    "Sodium" = "sodium", 
#                    "Hematocrit" = "hematocrit",
#                    "White blood cell count" = "wbc", 
#                    "Lactate" = "lactate")
# vitals_variables <- c("Heart rate" = "heart_rate", 
#                       "Non-invasive sys. blood pressure" = "non_invasive_blood_pressure_systolic",
#                       "Non-invasive mean blood pressure" = "non_invasive_blood_pressure_mean",
#                       "Respiratory rate" = "respiratory_rate",
#                       "Temperature fahrenheit" = "temperature_fahrenheit",
#                       "Arterial systolic blood pressure" = "arterial_blood_pressure_systolic",
#                       "Arterial mean blood pressure" = "arterial_blood_pressure_mean")
# 
# 


variable_categories <- c("Demographic", "Admission", 
                         "Lab measurements", "Vitals")
demographic_variables <- c("Insurance status", 
                           "Language", 
                           "Marital status",
                           "Ethnicity", 
                           "Sex", 
                           "Age at admission")

admission_variables <- c("First care unit",
                         "Last care unit", 
                         "Intime", 
                         "Outtime", 
                         "Length of stay", 
                         "Admit time", 
                         "Discharge time", 
                         "Death time",
                         "Admission type", 
                         "Admission location", 
                         "Discharge location", 
                         "Emergency dep. registration time", 
                         "Emergency dep. discharge time", 
                         "Death during hospitalization", 
                         "Age during anchor year", 
                         "Anchor year", 
                         "Anchor year group", 
                         "Date of death", 
                         "Death within 30 days")

lab_variables <- c("Bicarbonate", 
                   "Calcium", 
                   "Chloride", 
                   "Creatinine",
                   "Glucose", 
                   "Magnesium", 
                   "Potassium", 
                   "Sodium", 
                   "Hematocrit",
                   "White blood cell count", 
                   "Lactate")
vitals_variables <- c("Heart rate", 
                      "Non-invasive sys. blood pressure",
                      "Non-invasive mean blood pressure",
                      "Respiratory rate",
                      "Temperature fahrenheit",
                      "Arterial systolic blood pressure",
                      "Arterial mean blood pressure")




