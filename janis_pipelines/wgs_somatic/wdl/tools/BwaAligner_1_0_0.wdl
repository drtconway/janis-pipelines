version development

import "cutadapt_2_6.wdl" as C
import "BwaMemSamtoolsView_0_7_17_1_9.wdl" as B
import "Gatk4SortSam_4_1_3_0.wdl" as G

workflow BwaAligner {
  input {
    String sample_name
    File reference
    File reference_fai
    File reference_amb
    File reference_ann
    File reference_bwt
    File reference_pac
    File reference_sa
    File reference_dict
    Array[File] fastq
    Array[String]? cutadapt_adapter
    Array[String]? cutadapt_removeMiddle3Adapter
    String? cutadapt_front
    String? cutadapt_removeMiddle5Adapter
    Int? cutadapt_qualityCutoff
    Int? cutadapt_minimumLength
    Boolean? bwamem_markShorterSplits
    String? sortsam_sortOrder
    Boolean? sortsam_createIndex
    String? sortsam_validationStringency
    Int? sortsam_maxRecordsInRam
    String? sortsam_tmpDir
  }
  call C.cutadapt as cutadapt {
    input:
      fastq=fastq,
      adapter=cutadapt_adapter,
      front=cutadapt_front,
      qualityCutoff=select_first([cutadapt_qualityCutoff, 15]),
      minimumLength=select_first([cutadapt_minimumLength, 50]),
      removeMiddle3Adapter=cutadapt_removeMiddle3Adapter,
      removeMiddle5Adapter=cutadapt_removeMiddle5Adapter
  }
  call B.BwaMemSamtoolsView as bwamem {
    input:
      reference_fai=reference_fai,
      reference_amb=reference_amb,
      reference_ann=reference_ann,
      reference_bwt=reference_bwt,
      reference_pac=reference_pac,
      reference_sa=reference_sa,
      reference_dict=reference_dict,
      reference=reference,
      reads=cutadapt.out,
      sampleName=sample_name,
      markShorterSplits=select_first([bwamem_markShorterSplits, true])
  }
  call G.Gatk4SortSam as sortsam {
    input:
      bam=bwamem.out,
      sortOrder=select_first([sortsam_sortOrder, "coordinate"]),
      createIndex=select_first([sortsam_createIndex, true]),
      maxRecordsInRam=select_first([sortsam_maxRecordsInRam, 5000000]),
      tmpDir=select_first([sortsam_tmpDir, "."]),
      validationStringency=select_first([sortsam_validationStringency, "SILENT"])
  }
  output {
    File out = sortsam.out
    File out_bai = sortsam.out_bai
  }
}