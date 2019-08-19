version development

task gatk4sortsam {
  input {
    Int? runtime_cpu
    Int? runtime_memory
    File bam
    String outputFilename = "generated-f77eebbc-c2d8-11e9-bae6-f218985ebfa7.bam"
    String sortOrder
    Array[File]? argumentsFile
    Int? compressionLevel
    Boolean? createIndex
    Boolean? createMd5File
    Int? maxRecordsInRam
    Boolean? quiet
    File? reference
    File? reference_amb
    File? reference_ann
    File? reference_bwt
    File? reference_pac
    File? reference_sa
    File? reference_fai
    File? reference_dict
    String? tmpDir
    Boolean? useJdkDeflater
    Boolean? useJdkInflater
    String? validationStringency
    String? verbosity
  }
  command {
    gatk SortSam \
      -I ${bam} \
      ${"-O " + if defined(outputFilename) then outputFilename else "generated-f77ef9a4-c2d8-11e9-bae6-f218985ebfa7.bam"} \
      -SO ${sortOrder} \
      ${if defined(argumentsFile) then "--arguments_file " else ""}${sep=" --arguments_file " argumentsFile} \
      ${"--COMPRESSION_LEVEL " + compressionLevel} \
      ${true="--CREATE_INDEX" false="" createIndex} \
      ${true="--CREATE_MD5_FILE" false="" createMd5File} \
      ${"--MAX_RECORDS_IN_RAM " + maxRecordsInRam} \
      ${true="--QUIET" false="" quiet} \
      ${"--reference " + reference} \
      ${"--TMP_DIR " + if defined(tmpDir) then tmpDir else "/tmp/"} \
      ${true="--use_jdk_deflater" false="" useJdkDeflater} \
      ${true="--use_jdk_inflater" false="" useJdkInflater} \
      ${"--VALIDATION_STRINGENCY " + validationStringency} \
      ${"--verbosity " + verbosity}
  }
  runtime {
    docker: "broadinstitute/gatk:4.0.12.0"
    cpu: if defined(runtime_cpu) then runtime_cpu else 1
    memory: if defined(runtime_memory) then "${runtime_memory}G" else "4G"
    preemptible: 2
  }
  output {
    File out = if defined(outputFilename) then outputFilename else "generated-f77eebbc-c2d8-11e9-bae6-f218985ebfa7.bam"
    File out_bai = sub(if defined(outputFilename) then outputFilename else "generated-f77eebbc-c2d8-11e9-bae6-f218985ebfa7.bam", "\\.bam$", ".bai")
  }
}