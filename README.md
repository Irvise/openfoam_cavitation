# Simulation of an imploding cavity in OpenFOAM

This project was realized by Ivan Lizat and Fernando Oleo Blanco as the final project of "Simulation of Thermofluids with Open Source Tools" in Technische Universität München (TUM).

## General description

The project employs the `cavitatingFoam` solver to simulate the case of an imploding cavity. Two cases are presented, the first one is the case of a bubble in the middle of an "infinite" pool of liquid. The second case is the implosion of a bubble close to a wall.

The properties of the fluid follow the `barotropicCompressibilityModel` thermophysical model. The initialization of the parameters, both for the barotropic model and the initial conditions were computed using [CoolProp](http://www.coolprop.org/); water and vapour at close to atmospheric pressure were taken as the reference fluid.

## Requirements

- The case only runs on the OpenFOAM.com version. We tried to run it with OpenFoam versions 6 and 8 to no avail. Only v2012 has been confirmed to work properly.
- The case needs the [swak4Foam](http://www.coolprop.org/) utility since the `funkySetFields` tool is used to initialize the initial boundary conditions.

## Project structure

The `baseCase` folder has the initial setup with which we started developing the geometry and the setup. This folder is currently useless and has been left for reference. The `baseCase_openspace` folder contains the case for the bubble in a free fluid. The folder `wallCase` contains the case for the bubble implosion close to a wall.

The geometry in both cases is different. For the `baseCase_openspace` case, a polar section with axis-symetrical and symmetry conditions is used. For the wall case, the geometry is a simple axis-symmetry wedge.

## References

Works used as a reference can be found in the presentation and report files.
