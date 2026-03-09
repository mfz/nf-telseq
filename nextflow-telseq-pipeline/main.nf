#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process Telseq {
    tag { "${person_id}" }

    input:
    tuple val(person_id), path(cram_uri), path(cram_index_uri)
    path reference

    output:
    path "${person_id}_telseq_output.txt"

    publishDir "${params.outdir}/telseq", mode: 'copy'

    script:
    """
    samtools view \
      -b -T ${reference} \
      ${cram_uri} \
      --index ${cram_index_uri} \
    | telseq -r 151 - \
      > ${person_id}_telseq_output.txt
    """
}

workflow {
    Channel.fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> 
            [row.research_id, row.cram_uri, row.cram_index_uri] 
        }
        .set { input_channel }

    reference_ch = Channel.value(params.reference)


    Telseq(input_channel, reference_ch)
}