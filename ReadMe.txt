Active Programs: 
PHSA APPLICATION - Main File by which to run the analysis. Open this file in matlab to view dashboard application.

Backend functions within APP:
averageAnnualLoss - Computs average annual loss from hazard curve and loss deaggregation. Combines components of demo, collapse, and repair.
collapseFragility - Creates collapse fragility from structural analysis input
createPolyFit - Creates best fit polyfit for 3rd or 4th degree hazard fit to hazard curve
ExpectedLoss - Finds probability of demolition given IM
expectedLoss_EDP - Computes expected loss given EDP for repair components
expectedLoss_IM - Converts expectedLoss_EDP to expectedLoss_IM using PDF of IM|EDP
loadComputeDamageFragilities - Handles loaded fragility files, organizes to use to compute damage associated with structure
LoadStripeData - Loads structural analysis, sorts for later use in loss computation
loadStructure - Loads all structure cost data of components, replacement cost, demo cost
maxLikelihodd - Uses max likelihood probablistic method to fit lognormal distribution to values
repairCollapseDemoProb - Computes probabilities of collapse, demo, repair given a certain IM value
ResponseEstimation - Takes in structural analysis data of IM, EDP and finds median and std of response, creates distributions for each IM
saveStuff - Save callback for App, saves relevant information for access. 


Data:
Sample output is sample of what comes out of running response program. Upload to correponding positions within the application. 






