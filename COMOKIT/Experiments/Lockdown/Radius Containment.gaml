/******************************************************************
* This file is part of COMOKIT, the GAMA CoVid19 Modeling Kit
* Relase 1.0, May 2020. See http://comokit.org for support and updates
* Author: Huynh Quang Nghi
* 
* Description: 
* 	Model illustrating a local lockdown policy applied with a given tolerance:
* 		initially, a local lockdown is decided around each infected Individual (i.e. in a circle of a given radius, no activity is allowed).
*	In the application area, a rate of the population is nevertheless allowed to do its activities.
* 	Outside of the application areas, Individuals are free to act following their agenda.
* 
* Parameters:
* 	- tolerance: defines the rate of the population who is allowed to do its activities. (default value: 0.2)
* 	- radius_lockdown: the radius of the policy application area (default value: 200 #m)
* 
* Dataset: Default dataset (DEFAULT_CASE_STUDY_FOLDER_NAME in Parameters.gaml, i.e. Vinh Phuc)
* Tags: covid19,epidemiology,lockdown
******************************************************************/
model CoVid19

import "../../Model/Global.gaml"
import "../Abstract Experiment.gaml"

global {
	list<Individual> sources <- [];
	float tolerance <- 0.2;
	float radius_lockdown <- 200 #m;
	int number_of_tests_ <- 200;
	/*
	 * Initialize the radius lockdown policy (around infected Individuals) with a given tolerance.
	 */
//	action define_policy {
	//		name <- "Radius lockdown with " + int(tolerance * 100) + "% of tolerance";
	//		ask Authority {
	//			ask all_individuals where (each.state != susceptible) {
	//				sources << self;
	//				state <- symptomatic;
	//			}
	//
	//			list<AbstractPolicy> policies <- [];
	//			loop i over: sources {
	//				policies << with_tolerance(create_lockdown_policy_in_radius(i.location, radius_lockdown), tolerance);
	//			}
	//
	//			policy <- combination(policies);
	//		}
	//
	//	}
	reflex ss {
	//		if (cnt1 > data1.rows - 1) {
	//			cnt1 <- 0;
	//		}
		if (cnt1 < data1.rows) {
			point p1 <- to_GAMA_CRS({float(data1[2, cnt1]), float(data1[1, cnt1])}, "4326").location;
			if (Patient1 = nil) {
			//			Patient1 <- first(all_individuals closest_to p1);
				Patient1 <- first(all_individuals where (not (each.is_outside) and each.state = latent));
				//				write Patient1;
			}

			Patient1.location <- p1;
			if (Patient1.is_infectious) {
				ask Patient1 {
					list<Individual> nei <- (all_individuals at_distance 1 #m); //closest_to Patient1;
					ask nei {
						if (flip(0.1)) {
							do define_new_case;
						}

					}

				}

			}

			cnt1 <- cnt1 + 1;
		}

		//		if (cnt2 > data2.rows - 1) {
		//			cnt2 <- 0;
		//		}
		if (cnt2 < data2.rows) {
			point p2 <- to_GAMA_CRS({float(data2[2, cnt2]), float(data2[1, cnt2])}, "4326").location;
			if (Patient2 = nil) {
			//			Patient2 <- first(all_individuals closest_to p2);
				Patient2 <- last(all_individuals where (not (each.is_outside) and each.state = latent));
				//				write Patient2;
			}

			Patient2.location <- p2;
			if (Patient2.is_infectious) {
				ask Patient2 {
					list<Individual> nei <- (all_individuals at_distance 1 #m); //closest_to Patient2;
					ask nei {
						if (flip(0.1)) {
							do define_new_case;
						}

					}

				}

			}

			cnt2 <- cnt2 + 1;
		}

	}

}

experiment "Radius Quarantine" parent: "Abstract Experiment" autorun: false {

	action _init_ {
		string shape_path <- self.ask_dataset_path();
		float simulation_seed <- 695.41733930762;//rnd(2000.0);
//				loop r over: [   5000] {
//		loop r over: [50, 200, 500, 1000, 5000] {
		loop r over: [200, 500, 1000] {
			create simulation with:
			[dataset_path::shape_path, num_infected_init::2, seed::simulation_seed, init_all_ages_proportion_wearing_mask::0.75, force_parameters::list(epidemiological_proportion_wearing_mask, epidemiological_factor_wearing_mask)]
			{
				name <- "Dynamic spatial lockdown radius: " + r + "m";
				allow_transmission_building <- true;
				ask Authority {
					AbstractPolicy d <- create_detection_policy(number_of_tests_, true, false);
					AbstractPolicy lock <- create_lockdown_policy();
					create DynamicSpatialPolicy returns: spaceP {
						radius <- r #m;
						target <- first(lock);
					}

					policy <- combination([d, first(spaceP)]);
					create ActivitiesMonitor returns: result;
					act_monitor <- first(result);
				}

			}

		}

	}

	permanent {
		display "charts" parent: infected_cases refresh: every(1 #cycle){
		}

	}

	output {
	//			 layout horizontal([vertical([0::5000,1::5000])::3651,vertical([horizontal([2::5000,3::5000])::5000,horizontal([4::5000,5::5000])::5000])::6349]) tabs:true toolbars:false controls:true editors: false;
		layout #split consoles: false editors: false navigator: false tray: false tabs: false toolbars: false controls: true;
		display "Main" synchronized: true type: opengl background: background draw_env: false { //type: java2D parent: default_display {
		//			species SpatialPolicy transparency: 0.85 {
		//				draw application_area empty: false color: #red;
		//			}
			overlay position: {5, 5} size: {700 #px, 200 #px} transparency: 1 position: {0, 0, 0.001}{
				draw world.name font: default at: {20 #px, 20 #px} anchor: #top_left color: text_color;
				draw ("" + current_date) + " | " + ("Cases " + world.number_of_infectious) font: default at: {20 #px, 50 #px} anchor: #top_left color: text_color;
			}

			image file: file_exists(dataset_path + "/satellite.png") ? (dataset_path + "/satellite.png") : "../Utilities/white.png" transparency: 0.5 refresh: false;
			agents "BB" value: Building {
				if (#zoom > 3) {
					draw VARNAME_3 color: #yellow perspective: false;
				}

				draw shape color: viral_load > 0 ? rgb(255 * viral_load, 0, 0) : #grey empty: true;
			}
			//			species Individual;
			species SpatialPolicy transparency: 0.85 {
				draw application_area  empty: false color: #red;
			}

			agents "Individual" value: all_individuals where (not (each.is_outside)) {
				draw square(state = susceptible or clinical_status = recovered ? 25 #m : 100 #m) color: state = latent ? #yellow : (self.is_infectious ?
				#orangered : (clinical_status = recovered ? #blue : #green));
			}

		}

		//				display "Chart" parent: states_evolution_chart {
		//				}

	}

}