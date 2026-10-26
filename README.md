# `findmingeom`

`findmingeom` is a `bash` utility script designed to parse **<a href="https://gaussian.com/input">Gaussian</a> output files (`.out`)**, extract molecular geometries and trajectories from geometry optimization and/or polarizability calculations, and convert them into standard file formats (`.xyz` and `.hin` are natively supported); for immediate insertion into a new input file, the default output is headless XYZ format (with `.gem` extension).

It supports multi-job output files, old-fashioned PES coordinate scan extractions (`Opt=ModRedundant`), and automatically parses atomic charge calculations (Mulliken, ESP, NPA, Hirshfeld, CM5, APT) to embed them directly into generated HIN files. Other file formats can be implemented on request (conversion via **<a href="https://openbabel.org">OpenBabel</a>**).

Various optimization coordinate types are supported (Cartesian, Z-matrix, internal coordinates).

Also, various orientations are supported: standard, input and dipole orientation (the latter is relevant for polarizability calculations).

Different optimization subroutines are supported as well (analytical and numerical, and the potential energy surface scans with `ModRedundant`).

---

## Requirements

* **bash** (shell environment)
* **`dos2unix`**: Utility tools for end-of-line conversion (extremely important, believe it or not; when it is unavailable, a simple replacement script is aliased).
* **`sed`**: Used for text parsing and formatting.
* **`gawk`** / **`awk`**: Also used for text parsing and formatting.
* **Open Babel (`obabel`)**: Required only when generating HyperChem (`.HIN`) files.

---

## Usage

```bash
./findmingeom [options] YOUR_GAUSSIAN_OUTPUT_FILE.out [FILE_TO_STORE_RESULTS]

```

### Options

| Flag | Argument | Description |
| --- | --- | --- |
| `-h` | — | Display help information and exit. |
| `-x` | — | Prepare a standard `.XYZ` file instead of plain coordinates (`.gem`). |
| `-n` | — | Prepare a standard `.HIN` file containing selected atomic charges (implies `-x`). |
| `-a` | `NAME` | Set `NAME` as the base output filename (without extension). |
| `-p` | `PLUSHINNAME` | Append `PLUSHINNAME` to the output base name when saving HIN files. |
| `-o` | `OLDHINNAME` | Manually specify the source geometry name in the HIN header. |
| `-i` | — | Use **Input Orientation** instead of Standard Orientation (available for first/last steps). |
| `-d` | — | Use **Dipole Orientation** instead of Standard Orientation (for polarizability jobs). |
| `-z` | — | Use **Z-matrix** data instead of Standard Orientation (first/last steps or NoSymm jobs). |
| `-l` | — | Extract the **last** available geometry within a job. |
| `-0` | — | Extract the **first** available geometry within a job. |
| `-s` | `NUM` | Process the `NUM`-th optimization step within the file (`0` = last step). |
| `-t` | `NUM` | Output a multi-frame trajectory for animation or investigation (`.xyz` format). |
| `-k` | `NUM` | Process old-style ModRedundant PES scan points:<br>`NUM = 0`: Extract trajectory from the last step of each scan point.<br>`NUM > 0`: Extract geometry from step `NUM`. |
| `-j` | `NUM` | Select the `NUM`-th job within multi-job Gaussian output files. |
| `-c` | `NUM` | Automatically select the `NUM`-th available atomic charge type. |
| `-r` | — | Automatically select the **last** available atomic charge type. |
| `-v` | — | Display debugging/verbose output. |

---

## Workflow & Examples

### 1. Extract the last geometry from an optimization job to plain `.gem` coordinates

```bash
./findmingeom -l optimization.out output.gem

```

### 2. Extract geometry as a standard `.XYZ` file

```bash
./findmingeom -xl optimization.out my_structure.xyz

```

### 3. Generate a HyperChem `.HIN` File with Atomic Charges

Interactively select charges:

```bash
./findmingeom -nl calculation.out

```

Automatically select the last charge set found in the file (the first one is always Mulliken, hence this is what most people want for, e.g., NBO or ESP):

```bash
./findmingeom -lrn calculation.out -a target_molecule.hin

```

### 4. Create an Optimization Trajectory File

Generate a trajectory across all optimization steps to look through (or animate) in some chemical viewing program such as <a href="https://avogadro.cc">Avogadro</a> or <a href="https://www.chemcraftprog.com">ChemCraft</a>:

```bash
./findmingeom -t optimization.out

```

### 5. Process Multi-Job Output Files

Extract step 5 from the 2nd internal job step in a Gaussian output file:

```bash
./findmingeom -j 2 -s 5 multi_job.out

```
This README was created with the help of Gemini and manually improved.
