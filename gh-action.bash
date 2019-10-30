#!/bin/bash

# Checking format
check_format()
{
  format_fails=0
  numSrcFiles="$(echo "$SRC_FILES" | wc -l)"
  for src_file in "$SRC_FILES" ;
  do
    diff="$(clang-format "$src_file" | diff "$src_file" -)"
    var="$(echo "${diff}" | wc -l)"
    if [ "$var" -ne 0 ];
    then
      format_fails=$((format_fails + 1))
      echo "${src_file} does not respect the coding format (diff: ${var} lines)"
      echo "==================================================================="
      echo "$diff"
      echo "==================================================================="
    fi
  done
  if [ $format_fails -eq 0 ];
  then
    echo "All format checks passed!"
  else
    echo "Failed ${format_fails}/${numSrcFiles} "
  fi
}
# Auto format
auto_format()
{
  for src_file in "$SRC_FILES" ;
  do
    echo "Auto formatting: ${src_file}"
    clang-format -i "$src_file"

  done
}
# Checking Style
check_style()
{
  for src_file in "$SRC_FILES" ;
  do
    echo "Checking style of: ${src_file}"
            clang-tidy -checks=* \
            -header-filter=.* \
            -config="{CheckOptions: [ \
            { key: readability-identifier-naming.NamespaceCase, value: lower_case },\
            { key: readability-identifier-naming.ClassCase, value: CamelCase  },\
            { key: readability-identifier-naming.StructCase, value: CamelCase  },\
            { key: readability-identifier-naming.FunctionCase, value: camelBack },\
            { key: readability-identifier-naming.VariableCase, value: lower_case },\
            { key: readability-identifier-naming.GlobalConstantCase, value: UPPER_CASE }\
            ]}" "$src_file" -- ;
  done
}


main()
{
  echo "$CODEDIR"
  if [[ -z ${CODE_DIR+x} ]];
  then
    echo "\$CODEDIR not set, bailing."
    exit 1
  fi

  # Gather files
  SRC_FILES="$(find "${CODE_DIR}"/* -name '*.cpp' -or -name '*.c' -or -name '*.h' -or -name '*.s')"
# Acquire SCL paths
  source /opt/rh/llvm-toolset-7/enable

  # Action determination
  case "$1" in
    "check-format")
      check_format
      ;;
    "auto-format")
      auto_format
      ;;
    "check-style")
      check_style
      ;;
    *)
      echo "Action [${1}] not found!"
      exit 2
      ;;
  esac

  return
}


main "$@"

