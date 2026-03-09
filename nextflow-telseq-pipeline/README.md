# Nextflow Telseq Pipeline

This project implements a Nextflow pipeline to run Telseq on CRAM files from the AllOfUs research platform. The pipeline processes multiple samples as specified in an input CSV file.

## Project Structure

```
nextflow-telseq-pipeline
├── main.nf        # Main Nextflow pipeline script
├── README.md      # Project documentation
```

## Requirements

- Nextflow
- Java (version 8 or higher)
- Container with Telseq and Samtools (recommended)
- Reference genome FASTA file (for CRAM to BAM conversion)

## Setup

1. Clone the repository:
   ```
   git clone <repository-url>
   cd nextflow-telseq-pipeline
   ```

2. Ensure you have Nextflow installed.

3. Prepare your input CSV file with columns: `research_id`, `cram_uri`, `cram_index_uri` and upload to workspace bucket

## Running the Pipeline

Run the pipeline with:

```
nextflow run main.nf -profile gcb,spot -with-report telseq.html
```


## Input Format

The input CSV file should have the following columns:

- `research_id`: Unique identifier for each sample.
- `cram_uri`: Path or URI of the CRAM file.
- `cram_index_uri`: Path or URI of the CRAM index file.

Example:
```
research_id,cram_uri,cram_index_uri
1234,/path/to/sample1.cram,/path/to/sample1.crai
5678,/path/to/sample2.cram,/path/to/sample2.crai
```

## Output

The output of the Telseq process will be generated in the directory specified by `${params.outdir}/telseq`. Each output file will be named `<research_id>_telseq_output.txt`.
