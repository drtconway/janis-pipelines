#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: 'BCFTools: Sort'
doc: "About:   Sort VCF/BCF file.\nUsage:   bcftools sort [OPTIONS] <FILE.vcf>"

requirements:
- class: ShellCommandRequirement
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: michaelfranklin/bcftools:1.9

inputs:
- id: vcf
  label: vcf
  doc: The VCF file to sort
  type: File
  inputBinding:
    position: 1
- id: outputFilename
  label: outputFilename
  doc: (-o) output file name [stdout]
  type:
  - string
  - 'null'
  default: generated.sorted.vcf.gz
  inputBinding:
    prefix: --output-file
- id: outputType
  label: outputType
  doc: |-
    (-O) b: compressed BCF, u: uncompressed BCF, z: compressed VCF, v: uncompressed VCF [v]
  type: string
  default: z
  inputBinding:
    prefix: --output-type
- id: tempDir
  label: tempDir
  doc: (-T) temporary files [/tmp/bcftools-sort.XXXXXX/]
  type:
  - string
  - 'null'
  inputBinding:
    prefix: --temp-dir

outputs:
- id: out
  label: out
  type: File
  outputBinding:
    glob: generated.sorted.vcf.gz

baseCommand:
- bcftools
- sort
arguments: []
id: bcftoolssort
