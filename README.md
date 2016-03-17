## EyetrackGrapher project for Analyasis of Neural Data course

This repostiory contains functions that help visualize and analyze timeseries eyetracking data collected by Eyetribe.

/EyetribeFX contains files from https://github.com/esdalmaijer/EyeTribe-Toolbox-for-Matlab.git under GNU lincense
All other files, folders under MIT LICENSE 

### Dependencies
	MATLAB
	PSYCHTOOLBOX (http://psychtoolbox.org/)

### Basic functions

importfile : import Eyetracking data from Eyetribe.
regret_study : Regret study on which data was collected
EyetrackGrapher : Function that plots eyetracking data 
EyetrackTracker(under construction) : Real time GUI for eyetracking data visualization
fourier_example : Example of applying Fourier to pupil size data ( will be using Pwelch in future)
hilbert_example : Example of applying Hilbert transform to pupil size data
visitation_example(under construction) : Compare number of visits to ROI. 

##Features: 

### Added by the first half of course
1. Allows user to cycle through eyetracking data (Gaze Location, Pupil Size, and Event) for each timepoint. 
2. Allows user to compare and view both raw and interpolated data.
3. Provides data integrity checks including sampling rate, number of samples, and interpolation rate (signal dropout).

### Added for second half of course
4. View actual images with gaze location from saved PNG files.
    
    	dat = importfile();
    	EyetrackGrapher(dat);

5. Implement a play button to view a movie of data. 

        press [Play Stream] to play; press again to stop    

6. Fourier transform on pupil size for different conditions

    	dat = importfile();
    	fourier_example(dat);

        This plots 4 Figures in the order of appearance 
        Figure 1: Plot raw pupil size data
        Figure 2: Compare two best(no signal loss) trials of regret and nonregret trials and their Fourier
        Figure 3: Average over three different conditions (see result, see counterfactual without regret, see counterfactual with regret) each 120 seconds long.
        Plots the average pupil size change and the fourier transform. 

7. Generalize spike-field relationship to pupil size and experiment condition by averaging pupil size changes over different trials of same condition (sort of...).

	    fourier_example(dat);

8. Hilbert transform on pupil size data. The unwrapped Hilbert phase plots the frequency as the slope so that an elbow or a jump in the line suggests a component change in the signal. These trajectories can suggest different temporal patterns of pupil data for different cognitive processes as in this paper : http://www.cv-foundation.org/openaccess/content_cvpr_workshops_2014/W09/papers/Hossain_Understanding_Effects_of_2014_CVPR_paper.pdf 

	    hilbert_example(dat);

        Figure 1: Plots unwrapped hilbert transform for the trial average of three conditions. 
        Figure 2: Plots unwrapped hilbert transform for each trials in three conditions. 

