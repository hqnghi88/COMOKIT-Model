/***
* Name: COMOKIT
* Author: A. Drogoul
* Description: Serves as a bridge to import all of COMOKIT into this project. 
* Import in turn this file (for instance drag and drop it onto your file, or write `import "All COMOKIT.gaml";` as the first line of your model)
* into your own models or experiments to get access to all the species and abstract bases of GUI and batch experiments defined in COMOKIT. 
* Tags: Covid-19
***/
model COMOKIT

/**
 * Importation of all the species defined in COMOKIT. This import is not strictly necessary, as it is taken in charge 
 * by the import of abstract experiments below, but it shows how to do it in your model files if necessary .
 */
import "../../CoVid19 Modeling Kit/Model/Global.gaml"
/**
 * Importation of the basis for GUI experiments defined in COMOKIT, in particular the abstract experiment named ... 'Abstract Experiment'. 
 * This import is not strictly necessary, as it is taken in charge by the import of batch experiments below, but it shows how to do it in
 * your model or experiment files if necessary .
 */
import "../../CoVid19 Modeling Kit/Experiments/Abstract Experiment.gaml"
/**
 * Importation of the basis for batch experiments defined in COMOKIT, in particular the abstract experiment named 'Abstract Batch Experiment'
 */
import "../../CoVid19 Modeling Kit/Experiments/Abstract Batch Experiment.gaml"
