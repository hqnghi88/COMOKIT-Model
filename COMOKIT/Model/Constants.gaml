/***
* Part of the GAMA CoVid19 Modeling Kit
* see http://gama-platform.org/covid19
* Author: Benoit Gaudou, Patrick Taillandier
* Tags: covid19,epidemiology
***/

@no_experiment

model CoVid19


global {
	
	//State of an individual
	string susceptible <- "susceptible";
	string latent <- "latent";
	string presymptomatic <- "presymptomatic";
	string asymptomatic <- "asymptomatic";
	string symptomatic <- "symptomatic";
	string removed <- "removed";
	
	//Diagnostic status of the individual
	string not_tested <- "Not tested";
	string tested_positive <- "Positive";
	string tested_negative <- "Negative";
	
	//Clinical status of the individual
	string dead <- "Dead";
	string recovered <- "Recovered";
	string no_need_hospitalisation <- "Not needed";
	string need_hospitalisation <- "Need hospitalisation";
	string need_ICU <- "Need ICU";

	
	string act_neighbor <- "visiting neighbor";
	string act_friend <- "visiting friend";
	string act_home <- "staying at home";
	string act_working <- "working";
	string act_studying <- "studying";
	string act_eating <- "eating";
	string act_shopping <- "shopping";
	string act_leisure <- "leisure";
	string act_outside <- "outside activity";
	string act_sport <- "sport";
	string act_other <- "other activity";
	
	//Type of model for building choice during activity
	string random <- "random";
	string gravity <- "gravity";
	string closest <- "closest";
	
	// OSM Constant (type of building)
	list<string> OSM_eat <- ["restaurant","bakery"];
	list<string> OSM_home <- ["yes","house", "manor","apartments",'chocolate','shoes',"caravan"];
	list<string> OSM_shop <- ['commercial','supermarket',"bakery","frozen_food","alcohol","retail","furniture","bicycle"];
	list<string> OSM_outside_activity <- [];
	list<string> OSM_leisure <- [];
	list<string> OSM_sport <- ['tennis','multi','basketball','soccer','rugby_league','swimming','cycling','pelota','boules','skateboard','beachvolleyball','athletics'];
	list<string> OSM_other_activity <- ['car_repair','garages','church','hairdresser',"chapel","memorial","ruins"];
	list<string> OSM_work_place <- ['office',"estate_agent","public","civic","government","manufacture","company"];
	list<string> OSM_school <- ["school"];
	
	//number of the column for the epidemiological parameters CSV file
	int epidemiological_csv_column_name <- 0; //Name of the parameter
	int epidemiological_csv_column_age <- 1; //Lower bound of the age category
	int epidemiological_csv_column_detail <- 2; //Detail of the parameter (i.e. Fixed, or following a distribution)
	int epidemiological_csv_column_parameter_one <- 3; //Value of the parameter (only this one is used for fixed, else it is the first parameter of the distribution)
	int epidemiological_csv_column_parameter_two <- 4; //Value of the parameter (only used as the second parameter for distribution)
	
	//Keys of the map of epidemiological parameters, must also be used in the CSV
	string epidemiological_transmission_human <- "Transmission_human";
	string epidemiological_transmission_building <- "Transmission_building";
	string epidemiological_basic_viral_decrease <- "Basic_viral_decrease";
	string epidemiological_fixed <- "Fixed";
	string epidemiological_lognormal <- "Lognormal";
	string epidemiological_normal <- "Normal";
	string epidemiological_weibull <- "Weibull";
	string epidemiological_gamma <- "Gamma";
	string epidemiological_uniform <- "Uniform";
	string epidemiological_successful_contact_rate_human <- "Successful_contact_rate_human";
	string epidemiological_successful_contact_rate_building <- "Successful_contact_rate_building";
	string epidemiological_factor_asymptomatic <-"Factor_asymptomatic";
	string epidemiological_proportion_asymptomatic <- "Proportion_asymptomatic";
	string epidemiological_basic_viral_release <- "Basic_viral_release";
	string epidemiological_probability_true_positive <- "Probability_true_positive";
	string epidemiological_probability_true_negative <- "Probability_true_negative";
	string epidemiological_proportion_wearing_mask <- "Proportion_wearing_mask";
	string epidemiological_factor_wearing_mask <- "Factor_wearing_mask";
	string epidemiological_incubation_period_symptomatic <-"Incubation_period_symptomatic";
	string epidemiological_incubation_period_asymptomatic <-"Incubation_period_asymptomatic";
	string epidemiological_serial_interval <- "Serial_interval";
	string epidemiological_proportion_hospitalisation <- "Proportion_hospitalisation";
	string epidemiological_onset_to_hospitalisation <- "Onset_to_hospitalisation";
	string epidemiological_proportion_icu <- "Proportion_icu";
	string epidemiological_hospitalisation_to_ICU <- "Hospitalisation_to_ICU";
	string epidemiological_stay_ICU <- "Stay_ICU";
	string epidemiological_proportion_death_symptomatic <- "Proportion_death_symptomatic";
	string epidemiological_infectious_period_symptomatic <- "Infectious_period_symptomatic";
	string epidemiological_infectious_period_asymptomatic <- "Infectious_period_asymptomatic";
	
}