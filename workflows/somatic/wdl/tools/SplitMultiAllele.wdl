version development

task SplitMultiAllele {
  input {
    Int? runtime_cpu
    Int? runtime_memory
    File vcf
    File reference
    File reference_amb
    File reference_ann
    File reference_bwt
    File reference_pac
    File reference_sa
    File reference_fai
    File reference_dict
    String outputFilename = "generated-b6b47caa-b1b2-11e9-8bf3-acde48001122.norm.vcf"
  }
  command {
     \
      sed 's/ID=AD,Number=./ID=AD,Number=R/' < \
      ${vcf} \
      | \
      vt decompose -s - -o - \
      | \
      vt normalize -n -q - -o - \
      -r ${reference} \
      | \
      sed 's/ID=AD,Number=./ID=AD,Number=1/' \
      ${"> " + if defined(outputFilename) then outputFilename else "generated-b6b4842a-b1b2-11e9-8bf3-acde48001122.norm.vcf"}
  }
  runtime {
    docker: "heuermh/vt"
    cpu: if defined(runtime_cpu) then runtime_cpu else 1
    memory: if defined(runtime_memory) then "${runtime_memory}G" else "4G"
    preemptible: 2
  }
  output {
    File out = if defined(outputFilename) then outputFilename else "generated-b6b47caa-b1b2-11e9-8bf3-acde48001122.norm.vcf"
  }
}