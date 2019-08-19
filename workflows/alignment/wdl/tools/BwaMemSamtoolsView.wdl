version development

task BwaMemSamtoolsView {
  input {
    Int? runtime_cpu
    Int? runtime_memory
    File reference
    File reference_amb
    File reference_ann
    File reference_bwt
    File reference_pac
    File reference_sa
    File reference_fai
    File reference_dict
    Array[File] reads
    Array[File]? mates
    String outputFilename = "generated-f77eb016-c2d8-11e9-bae6-f218985ebfa7.bam"
    String sampleName
    Int? minimumSeedLength
    Int? bandwidth
    Int? offDiagonalXDropoff
    Float? reseedTrigger
    Int? occurenceDiscard
    Boolean? performSW
    Int? matchingScore
    Int? mismatchPenalty
    Int? openGapPenalty
    Int? gapExtensionPenalty
    Int? clippingPenalty
    Int? unpairedReadPenalty
    Boolean? assumeInterleavedFirstInput
    Int? outputAlignmentThreshold
    Boolean? outputAllElements
    Boolean? appendComments
    Boolean? hardClipping
    Boolean? markShorterSplits
    Int? verboseLevel
    String? skippedReadsOutputFilename
    File? referenceIndex
    File? intervals
    String? includeReadsInReadGroup
    File? includeReadsInFile
    Int? includeReadsWithQuality
    String? includeReadsInLibrary
    Int? includeReadsWithCIGAROps
    Array[Int]? includeReadsWithAllFLAGs
    Array[Int]? includeReadsWithoutFLAGs
    Array[Int]? excludeReadsWithAllFLAGs
    Boolean? useMultiRegionIterator
    String? readTagToStrip
    Boolean? collapseBackwardCIGAROps
    String? outputFmt
  }
  command {
     \
      bwa \
      mem \
      ${reference} \
      ${"-k " + minimumSeedLength} \
      ${"-w " + bandwidth} \
      ${"-d " + offDiagonalXDropoff} \
      ${"-r " + reseedTrigger} \
      ${"-c " + occurenceDiscard} \
      ${true="-P" false="" performSW} \
      ${"-A " + matchingScore} \
      ${"-B " + mismatchPenalty} \
      ${"-O " + openGapPenalty} \
      ${"-E " + gapExtensionPenalty} \
      ${"-L " + clippingPenalty} \
      ${"-U " + unpairedReadPenalty} \
      ${true="-p" false="" assumeInterleavedFirstInput} \
      ${"-T " + outputAlignmentThreshold} \
      ${true="-a" false="" outputAllElements} \
      ${true="-C" false="" appendComments} \
      ${true="-H" false="" hardClipping} \
      ${true="-M" false="" markShorterSplits} \
      ${"-v " + verboseLevel} \
      -R '@RG\tID:${sampleName}\tSM:${sampleName}\tLB:${sampleName}\tPL:ILLUMINA' \
      -t ${if defined(runtime_cpu) then runtime_cpu else 1} \
      ${sep=" " prefix("", reads)} \
      ${if defined(mates) then "" else ""}${sep=" " mates} \
      | \
      samtools \
      view \
      ${"-o " + if defined(outputFilename) then outputFilename else "generated-f77ec8d0-c2d8-11e9-bae6-f218985ebfa7.bam"} \
      ${"-U " + skippedReadsOutputFilename} \
      ${"-t " + referenceIndex} \
      ${"-L " + intervals} \
      ${"-r " + includeReadsInReadGroup} \
      ${"-R " + includeReadsInFile} \
      ${"-q " + includeReadsWithQuality} \
      ${"-l " + includeReadsInLibrary} \
      ${"-m " + includeReadsWithCIGAROps} \
      ${if defined(includeReadsWithAllFLAGs) then "-f " else ""}${sep=" -f " includeReadsWithAllFLAGs} \
      ${if defined(includeReadsWithoutFLAGs) then "-F " else ""}${sep=" -F " includeReadsWithoutFLAGs} \
      ${if defined(excludeReadsWithAllFLAGs) then "-G " else ""}${sep=" -G " excludeReadsWithAllFLAGs} \
      ${true="-M" false="" useMultiRegionIterator} \
      ${"-x " + readTagToStrip} \
      ${true="-B" false="" collapseBackwardCIGAROps} \
      ${"--output-fmt " + outputFmt} \
      -T ${reference} \
      --threads ${if defined(runtime_cpu) then runtime_cpu else 1} \
      -h \
      -b
  }
  runtime {
    docker: "michaelfranklin/bwasamtools:0.7.17-1.9"
    cpu: if defined(runtime_cpu) then runtime_cpu else 1
    memory: if defined(runtime_memory) then "${runtime_memory}G" else "4G"
    preemptible: 2
  }
  output {
    File out = if defined(outputFilename) then outputFilename else "generated-f77eb016-c2d8-11e9-bae6-f218985ebfa7.bam"
  }
}