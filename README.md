# Course Timetable Optimization Using Biogeography-Based Optimization (BBO) in MATLAB

Welcome to the Course Timetable Optimization project! This project proposes a decision support system for solving the complex course timetable problem using the Biogeography-Based Optimization (BBO) algorithm implemented in MATLAB. The aim is to efficiently schedule courses, classrooms, and instructors while satisfying various constraints.

## Table of Contents
- [Project Overview](#project-overview)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

### About the Project
This project focuses on optimizing course timetables, a challenging problem faced by educational institutions. The Biogeography-Based Optimization (BBO) algorithm is employed to find optimal or near-optimal solutions by balancing exploration and exploitation of the search space.


### Features
- Use of the BBO algorithm for course timetable optimization.
- Support for multiple constraints such as classroom availability, instructor schedules, and student preferences.
- MATLAB-based implementation for ease of use and extensibility.

## Getting Started
git clone https://github.com/maziyar-gerami/timetable-problem-bbo.git
cd code
Select one of The folders: Ba , BBo and GA.
Run ba.m, bbo.m or ga.m for runneng the algorithm.
### Prerequisites
Before you begin, ensure you have the following prerequisites:
- MATLAB installed on your system.
- Knowledge of course scheduling constraints and requirements specific to your institution.

### Installation
1. Clone this repository:

2. Open the MATLAB project file `timetable_optimization.prj` to load the project environment.

## Usage

1. Configure Input Data:
- Prepare input data files specifying courses, classrooms, instructors, and constraints.
- Modify the parameters in the MATLAB script to customize the optimization process.

2. Run the Optimization:
- Execute the MATLAB script to start the BBO-based optimization process.
- The algorithm will attempt to generate an optimal course timetable considering all specified constraints.

3. Analyze Results:
- Evaluate the generated timetable for efficiency and compliance with constraints.
- Adjust input data and parameters if necessary and rerun the optimization.

## Simulating and Comparing Algorithms

In addition to the BBO algorithm, this project allows for simulating and comparing the performance of other optimization algorithms like Genetic Algorithm (GA) and Bat Algorithm (BA). You can find the corresponding code for GA and BA in separate scripts within this project. To run these simulations:

1. Locate the GA and BA simulation scripts (e.g., `ga_simulation.m` and `ba_simulation.m`).
2. Configure input parameters and constraints specific to each algorithm in the respective scripts.
3. Execute the scripts to simulate and compare the optimization performance of these algorithms with the BBO approach.


## Contributing

We welcome contributions to this project! If you'd like to contribute or report issues, please follow our [Contribution Guidelines](CONTRIBUTING.md).
