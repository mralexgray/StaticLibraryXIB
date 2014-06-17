#!/bin/sh

#  xib.compile.sh
#  test
#
#  Created by Alex Gray on 6/16/14.
#  Copyright (c) 2014 Niels Gabel. All rights reserved.

    INPUT_BASE_NIB="${TARGET_TEMP_DIR}/${INPUT_FILE_BASE}.nib"
        INPUT_FILE="${INPUT_FILE_DIR}/${INPUT_FILE_NAME}"
       IBTOOL_OPTS="--output-format human-readable-text --compile"

/usr/bin/ibtool "$IBTOOL_OPTS" "$INPUT_BASE_NIB" "$INPUT_FILE"

: '
         HEX_DUMP=$(hexdump -v -e '1 1 "0x%02x, "' "$INPUT_BASE_NIB")
      DATA_LENGTH=$(stat -f "%z" "$INPUT_BASE_NIB")

sed -e "s/HEX_DUMP/$HEX_DUMP/" \
    -e "s/NIB_NAME/${INPUT_FILE_BASE}/g" \
    -e "s/HEX_LENGTH/$DATA_LENGTH/g" "${SRCROOT}/CompiledNibTemplate.m" \
     > "$DERIVED_FILE_DIR/$INPUT_FILE_BASE.nib.m"
'