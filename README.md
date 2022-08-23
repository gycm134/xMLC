# xMLC
# Guy Y. Cornejo Maceda, 2022/07/01
# Copyright: 2022 Guy Y. Cornejo Maceda (yoslan@hit.edu.cn)
# MIT License


Machine Learning Control.
How to use the xMLC software.
This software is based on a Genetic Programming framework to build control laws for dynamical systems.

## For reference
@Book{dbbs_mods_00071130,
  author = 	{Cornejo Maceda, Guy Y.
		and Lusseyran, Fran\c{c}ois
		and Noack, Bernd R.},
  editor = 	{Semaan, Richard
		and Noack, Bernd R.},
  title = 	{xMLC - A Toolkit for Machine Learning Control},
  series = 	{Machine Learning Tools in Fluid Mechanics},
  year = 	{2022},
  edition = 	{First edition},
  publisher = 	{Technische Universit{\"a}t Braunschweig},
  address = 	{Braunschweig},
  volume = 	{2},
  doi = 	{10.24355/dbbs.084-202208220937-0},
  url = 	{https://publikationsserver.tu-braunschweig.de/receive/dbbs_mods_00071130},
  file = 	{:https://publikationsserver.tu-braunschweig.de/servlets/MCRFileNodeServlet/dbbs_derivate_00049782/2022_xMLC_CornejoMaceda.pdf:PDF}
}

## Getting Started

Unzip the tar.gz file.

### Prerequisites

The software needs MATLAB or Octave.
No additional packages are needed.
This version has been developped on MATLAB version 9.5.0.944444 (R2018b) and Octave version 4.2.2.
Please contact the author (gy.cornejo.maceda@gmail.com) in case of error.

### Content
The main folder should contain the following folders and files:
- *README.md*
- *Initialization.m*, *Restart.m*, to initialize and restart the toy problem.
- *@MLC/*, *@MLCind/*, *@MLCpop/*, *@MLCtable/* contains the object definition files for the MLC algorithm.
- *MLC_tools/* contains functions and scripts that are not methods used by the MLC class objects.
- *ODE_Solvers/* contains other functions such ODE solvers
- *Plant/* contains all the problems and associated parameters. One folder for each problem. Default parameters are in *MLC_tools/*.
- *save_runs/* contains the savings.

### Initialization and run
To start, run matlab in the main folder, then run Initialization.m to load the folders and class object.

```
Initialization;
```

A *mlc* object is created containing the toy problem.
The toy problem is the stabilization of a damped Landau oscillator.
To load a different problem, just specify it when the MLC object is created.

```
mlc=MLC('GMFM');
```

To start the optimization process of the toy problem, run the *go.m* method.
Run alone it process one generation of optimization.
For the first iteration, it will initialize the data base with new individiduals.
Then it will create the new generations by evolving the last population thanks to genetic operators.

```
mlc.go;
```

To run several generations, precise it.

```
mlc.go(10); %To run 10 generations.
```

## Post processing and analysis.

To visualize the best individual, use :

```
mlc.best_individual;
```

To visualize the learning process, use : 

```
mlc.learning_process;
```

The current figure can be directly saved in save_runs/NameOfMyRun/Figures/ thanks to the following command:
```
mlc.print('NameOfMyFigure');
mlc.print('NameOfMyFigure',1); % to overwrite an existing figure
```
### Useful parameters

```
mlc.parameters.name = 'NameOfMyRun'; % This is the used to save;
mlc.parameters.Elitism = 1;
mlc.parameters.CrossoverProb = 0.3;
mlc.parameters.MutationProb = 0.4;
mlc.parameters.ReplicationProb = 0.7;
mlc.parameters.PopulationSize = 50; % Size of the population

```

### Save/Load

One can save and load one run.
/!\ When loading, the current mlc object will be overwritten, be careful!

```
mlc.save_matlab;
mlc.load_matlab('NameOfMyRun');
```

See the CheatSheet.m file for a quick start.

## Versioning

Version 0.10 - First public GitHub release.
If you experience compatibility issues with previous versions, please contact the author.

## Authors

* **Guy Y. Cornejo Maceda** 
Yoslan@hit.edu.cn
* **François Lusseyran** 
Francois.Lusseyran@limsi.fr
* **Bernd R. Noack** 
Bernd.Noack@hit.edu.cn


