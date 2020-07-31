/******************************************************************
* This file is part of COMOKIT, the GAMA CoVid19 Modeling Kit
* Relase 1.0, May 2020. See http://comokit.org for support and updates
* Author: Benoit Gaudou
* 
* Description: 
* 	The simplest baseline model: it creates one simulation with a no containment policy 
* 		and plots the evolution of the number of individuals in each epidemiological states.
* 
* Dataset: Default dataset (DEFAULT_CASE_STUDY_FOLDER_NAME in Parameters.gaml, i.e. Vinh Phuc)
* Tags: covid19,epidemiology
******************************************************************/
model CoVid19

import "../../Model/Global.gaml"
import "../Abstract Experiment.gaml"

global {

//	action define_policy {
//		ask Authority {
//			name <- "No containment policy";
//			policy <- create_no_containment_policy();
//		}
//
//	}

}

experiment "No Containment" parent: "Abstract Experiment" autorun: true {
	string shape_path <- self.ask_dataset_path();
	float simulation_seed <- rnd(2000.0);

	action _init_ {

	/*
		 * Initialize a simulation with a no containment policy  
		 */
		create simulation with: [dataset_path::shape_path, seed::simulation_seed] {
			name <- "No containment";
			ask Authority {
				policy <- create_no_containment_policy();
				create ActivitiesMonitor returns: result;
				act_monitor <- first(result);
			}

		}

	}

	output {
		layout #split consoles: false editors: false navigator: false tray: false tabs: false toolbars: false controls: true;
		display "Main" parent: default_display {
		}

		display "Plot" parent: states_evolution_chart refresh: every(#day) {
		}

		display "Population age" parent: demographics_age refresh: every(#week) {
		}

		display "Population gender" parent: demographics_sex refresh: every(#week) {
		}

		display "Population employment status" parent: demographics_employed refresh: every(#week) {
		}

		display "Household size" parent: demographics_household_size refresh: every(#week) {
		}

	}

}