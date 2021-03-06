version development

task Gatk4ApplyBQSR {
  input {
    Int? runtime_cpu
    Int? runtime_memory
    File bam
    File bam_bai
    File reference
    File reference_fai
    File reference_amb
    File reference_ann
    File reference_bwt
    File reference_pac
    File reference_sa
    File reference_dict
    String? outputFilename
    File? recalFile
    File? intervals
    String? tmpDir
  }
  command <<<
    ln -f ~{bam_bai} `echo '~{bam}' | sed 's/\.[^.]*$//'`.bai
    gatk ApplyBQSR \
      -R ~{reference} \
      ~{if defined(select_first([outputFilename, "~{basename(bam, ".bam")}.recalibrated.bam"])) then ("-O " +  '"' + select_first([outputFilename, "~{basename(bam, ".bam")}.recalibrated.bam"]) + '"') else ""} \
      ~{if defined(recalFile) then ("--bqsr-recal-file " +  '"' + recalFile + '"') else ""} \
      ~{if defined(intervals) then ("--intervals " +  '"' + intervals + '"') else ""} \
      -I ~{bam} \
      ~{if defined(select_first([tmpDir, "/tmp/"])) then ("--tmp-dir " +  '"' + select_first([tmpDir, "/tmp/"]) + '"') else ""}
    ln -f `echo '~{select_first([outputFilename, "~{basename(bam, ".bam")}.recalibrated.bam"])}' | sed 's/\.[^.]*$//'`.bai `echo '~{select_first([outputFilename, "~{basename(bam, ".bam")}.recalibrated.bam"])}' `.bai
  >>>
  runtime {
    cpu: select_first([runtime_cpu, 1])
    docker: "broadinstitute/gatk:4.1.3.0"
    memory: "~{select_first([runtime_memory, 4])}G"
    preemptible: 2
  }
  output {
    File out = select_first([outputFilename, "~{basename(bam, ".bam")}.recalibrated.bam"])
    File out_bai = (select_first([outputFilename, "~{basename(bam, ".bam")}.recalibrated.bam"])) + ".bai"
  }
}