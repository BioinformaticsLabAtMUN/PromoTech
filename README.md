# PROMOTECH: A UNIVERSAL TOOL FOR PROMOTER DETECTION IN BACTERIAL GENOMES

Finding the location of bacterial promoter sequences is essential for microbiology since promoters play a central role in regulating gene expression.  Promotech is a machine-learning-based classifier trained to generate a model that generalizes and detects promoters in a wide range of bacterial species.  During the study, two model architectures  were  tested,  Random  Forest  and  Recurrent  Networks. The  Random Forest model, trained with promoter sequences with a binary encoded representation of  each  nucleotide,  achieved  the  highest  performance  across  nine  different  bacteria and was able to work with short 40bp sequences and whole bacterial genomes using a sliding window.  The selected model was evaluated on a validation set of four bacteria not used during training.

## Requirements

1. Download and Install Anaconda or Miniconda from [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html). 
   - `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh` for *Ubuntu 20.04*
   - `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh` for *Mac OS Big Sur V11.3*
   - `bash miniconda.sh`
2. Install conda environment from the prebuilt environment YAML file. 
   - `conda env create -f promotech_env.yml` for *Ubuntu 20.04*
   - `conda env create -f promotech_mac_env.yml` for *Mac OS Big Sur V11.3*
   - **Note:** The environment was made on Ubuntu 20.04, different versions of the packages could be required for different operating systems.
3. Activate environment
   - `conda activate promotech_env`
4. Download the models from [here](http://www.cs.mun.ca/~lourdes/public/PromoTech_models/)
5. Uncompress the two Random Forest models with *.zip* format and save them at the [*models* folder](models/). The resulting files are *models/RF-HOT.model* and *models/RF-TETRA.model*

**Note:** A minimum of 24 GB of RAM memory is recommended to run the RF-HOT, LSTM, and GRU model on a whole-genome. Parsing a whole-genome to the RF-TETRA model's input format can produce the python "Memory Error" due to the high complexity and high RAM-memory demand required to obtain the tetra-nucleotide frequencies for millions of sequences in forward and inverse strand. An example of this process is shown in the examples section below. All models can run on lower-end systems, with at least 8GB of RAM, when predicting FASTA files with hundreds or thousands of sequences, 40 nt in length. 

The examples in the section below were tested in a desktop computer with the following specifications:

- **Processor      :** Intel(R) Core(TM) i5-9300H CPU @ 2.40GHz 2.40 GHz 
- **RAM            :** 24.0 GB (23.8 GB usable)
- **System Type    :** 64-bit Ubuntu 20.04 LTS
- **Graphic Memory :** NVIDIA GeForce RTX 2060 6GB GDDR6
- **Python Version :** Python 3.6


## Commands

1. `-v, --version` - Print Promotech's latest version.
2. `-gui, --gui`   - Use the interactive GUI interface for predicting 40 nucleotide sequences. The interface does not work for whole-genome prediction.
3. `-f, --fasta`   - Specify the location of the sequences or whole-genome FASTA file location in disk. This command is used together with the `-s, --predict-sequences` or `-PG, --parse-genome` arguments.
4. `-m, --model` - Indicates the type of model used for prediction and the target output data type used during the genome parsing stage. The default value is `RF-HOT`.
   - The available options for **40nt sequences prediction** are `RF-HOT`, `RF-TETRA`, `GRU`, `LSTM`. 
   - The available options for **whole-genome parsing and prediction** are `RF-HOT`, `GRU`, `LSTM`. 
5. `-ts, --test-samples` - Used for testing purposes during the genome parsing stage. A whole-genome can be made of 4 million+ nucleotides and can take hours, depending on your system configuration to parse and predict. This command limits the number of sequences the sliding window cuts from the genome. It is used only with the `-pg, --parse-genome` argument.
5. `-pg, --parse-genome` - Use a sliding window to cut 40 nucleotide sequences from the whole-genome in forward and reverse strand. The files are then saved to the "results" folder with a "[MODEL-TYPE].data" format, where MODEL-TYPE is the name of the model's desired input format, i.e. "RF-HOT.data" and "RF-HOT-INV.data". 
   - The **mandatory** argument used with this command is `-f, --fasta`. 
   - The **optional** arguments used with this command are `-m, --model`, and `--ts, --test-samples`. 
6. `-g, --predict-genome` -  This command uses the files generated using the `-pg, --parse-genome` argument and located in the "results" folder. 
   - The **optional** argument used with this command is `-m, --model`. Make sure to match the same model type used during the parsing stage.
7. `-s, --predict-sequences` - Used to parse and predict 40nt sequences from a FASTA file.
   - The **mandatory** argument used with this command is `-f, --fasta`. 
   - Make sure that the FASTA file has only 40-nt sequences as shown in the example below. If you require to use longer sequences, use the `-pg, --parse-genome` and `-g, --predict-genome` commands.
  <br />
  
  ```
    >chrom1
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    >chrom2
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    >chrom3
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   ```



## Examples

### 40 Nucleotide Sequences
1. Parse and predict using the `--predict-sequence, -s` command and specify the FASTA file using `--fasta, -f`. The FASTA file should only include 40nt sequences. If you require to predict longer sequences, use the "whole-genome" commands. An example of the command-line output obtained when running this command is found [HERE](examples/sequences/example.log.txt)

`python promotech.py -s -m RF-HOT -f examples/sequences/test.fasta -o results`

### Whole-Genome

1. Parse the whole-genome in the FASTA file (a single sequence is expected) by using `--parse-genome, -pg` and specifying the file using `--fasta, -f` . A smaller subset of the sliding window sequences can be used for testing purposes using the `--test-samples, -ts` parameter.  An example of the command-line output obtained when running this command is found [HERE](examples/genome/parse.example.log.txt)

`python promotech.py -pg -m RF-HOT -f examples/genome/ECOLI_2.fasta -o results` 

or 

`python promotech.py -pg -ts 20000 -m RF-HOT -f examples/genome/ECOLI_2.fasta -o results` 

- **Note:** Running one of the following commands will use a sliding window of 40nt size and 1nt step, pre-processed the sequences to meet the specified model's input requirement and create two files, **results/[MODEL_TYPE].data** and **results/[MODEL_TYPE]-INV.data**, for forward and inverse strand, where MODEL_TYPE specifies the type of model that will later be used for assessing the pre-processed 40nt sequences. **Do not delete the 'results' folder or the '.data' files**, because they will be used in the next step.
- **Note:** For comparison, the pipeline configured to generate data for the RF-HOT model, took 35 minutes and 42 seconds to cut 4,639,634 forward and 4,639,634 inverse sequences from the *E. coli* (NC_000913.2) genome with 4,639,675 nucleotides in length, pre-processed them to hot-encoded binary format, save them to two binary files and each file was 5.8 GB in size. During this time, it maintained around 18.5/24GB of RAM exclusively for the python running process.

2. Predict promoter sequences using the parsed sequences using `--predict-genome, -g`, assign a threshold using `--threshold, -t`, and select a model using `--model, -m`. The default threshold, and model are 0.5, and RF-HOT, respectively. An example of the command-line output obtained when running this command is found [HERE](examples/genome/predict.example.log.txt)

`python promotech.py -g -t 0.6 -i results -o results`

- **Note:** This command expects the user to have used the `--parse-genome, -pg` command before to generate the pre-processed sequences from the bacterial genome and stored in the files **results/[MODEL_TYPE].data** and **results/[MODEL_TYPE]-INV.data**. 
- **Note:** For comparison, it took 1 hour, 5 minutes, and 27 seconds to predict both, forward and inverse strand batches, each with 4,639,634 pre-processed sequences, with a total of 9,279,268 sequences as input and an output of 55,002 promoters sequences with a score above the 0.5 threshold.


### Benchmark
Promotech was compared against previous developed models. The models' linux executable files are located at the `./models/preceding/` folder. The instructions to run each program are the following:

1. **BPROM** 

Source: http://linux1.softberry.com/berry.phtml?topic=fdp.htm

- Setup and run the Ubuntu 16.04 32bits docker container
   - `docker pull 32bit/ubuntu:16.04`
   - `cd models/preceding/bprom`
   - `docker run -it --name ubuntu32 -v $(pwd):/project 32bit/ubuntu:16.04 /bin/bash`
- Run the program
   - `export TSS_DATA="/project/bprom_data/"`
   - `/project/linux/bprom /project/example_data/seq.fa /project/out.txt`
- Check the results
   - `head /project/out.txt`
- Stop the docker container
   - `docker rm ubuntu32`

         
2. **bTSSfinder**

Source: https://www.cbrc.kaust.edu.sa/btssfinder/about.php

- Setup and run the Ubuntu 18.04 64bits docker container
   - `docker pull ubuntu/18.04`
   - `cd models/preceding/btssfinder`
   - `docker run -it --name ubuntu64 -v $(pwd):/project ubuntu:18.04 /bin/bash`
- Run the program
   - `sudo chmod +x /project/bTSSfinder`
   - `export bTSSfinder_Data="/project/Data/"`
   - `project/bTSSfinder -i /project/example.fasta -o /project/out`
- Check the results
   - `head /project/out.txt`
- Check the results. The program will generate two files called `out.bed`, `out.gff`, and `out.out`.

3. **G4Promfinder**

Source: https://github.com/MarcoDiSalvo90/G4PromFinder

- Setup libraries

   - `pip3 install numpy pandas matplotlib biopython openpyxl`

- Run the program
    - `cd models/preceding/g4promfinder`
    - `python3 g4promfinder.py`
- The program will ask to input the name and location of the FASTA file. Inside the `models/preceding/g4promfinder` folder, there is an example file called `example.fasta` you can use to test the program.
   
   ```G4PromFinder is a genome-wide predictor of transcription promoters in bacterial genomes. It analyzes both the strands. It is recommended for GC-rich genomes
   Input: Genome file
   Output: a text file containing promoter coordinates and a file containing informations about them
   Genome file must be in fasta format
   Enter the input genome file name: example.fasta
   G4PromFinder is working, please wait...
   Work finished, see output files in the current directory
   ```

- Check the results. The program will generate two files called `ABOUT PROMOTERS.txt` and `promoter coordinates.txt`.

4. **MULTiPLy**

Source code: http://flagshipnt.erc.monash.edu/MULTiPly/ (Not working)

Article: https://academic.oup.com/bioinformatics/article/35/17/2957/5288244

- Download and install the latest version of Matlab. https://uk.mathworks.com/downloads/web_downloads/
- `cd models/preceding/multiply`
- Edit the `MULTiPLy.md` file and change the 12th line, `[head,seq]=fastaread('sample.fasta');`, with the fasta file you want to test. You can use `sample.fasta` for testing.
- Run the `MULTiPLy.md` file from the Matlab's GUI command line.

         
5. **iPromoter-2L**

http://bioinformatics.hitsz.edu.cn/iPromoter-2L/data/

`python promotech.py -b -bm iPromoter2L -m RF-HOT -o results`
