#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process Telseq {
    tag { "${person_id}" }

    input:
    tuple val(person_id), path(cram_uri), path(cram_index_uri)
    path reference
    path reference_fai

    output:
    path "${person_id}_telseq_output.txt"

    publishDir "${params.outdir}/telseq", mode: 'copy'

    script:
    """
    ls -lh
    samtools view -b -T ${reference} ${cram_uri} | telseq -o ${person_id}_telseq_output.txt -    
    """
}

workflow {
    Channel.fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> 
            [row.research_id, row.cram_uri, row.cram_index_uri] 
        }
        .set { input_channel }

    ref= params.reference
    ref_fai = "${params.reference}.fai"


    Telseq(input_channel, ref, ref_fai)
}