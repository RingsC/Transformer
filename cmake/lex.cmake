# Copyright (c) 2002-2017, By LeeHao. All rights reserved.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the BSD General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the BSD General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA 

#if we are under windows platform, perhaps, flex is more suitable not lex.
#or maybe we remove these code in future. here, we may need to check either flex or
#lex.
FIND_PROGRAM(LEX_EXECUTABLE flex DOC "path to the flex executable")
MARK_AS_ADVANCED(LEX_EXECUTABLE "")

IF(NOT LEX_EXECUTABLE)
  MESSAGE(WARNING "LEX/FLEX executable not found in PATH")
ELSEIF(LEX_EXECUTABLE AND NOT LEX_USABLE)
  # Check version as well
  EXEC_PROGRAM(${LEX_EXECUTABLE} ARGS --version OUTPUT_VARIABLE LEX_VERSION_STR)
   # Get first line in case it's multiline
   STRING(REGEX REPLACE "([^\n]+).*" "\\1" FIRST_LINE "${LEX_VERSION_STR}")
   # get version information
   STRING(REGEX REPLACE ".* ([0-9]+)\\.([0-9]+)" "\\1" LEX_VERSION_MAJOR "${FIRST_LINE}")
   STRING(REGEX REPLACE ".* ([0-9]+)\\.([0-9]+)" "\\2" LEX_VERSION_MINOR "${FIRST_LINE}")
   IF (LEX_VERSION_MAJOR LESS 2)
     MESSAGE(WARNING "lex/flex version is old. please update to version 2")
   ELSE()
     SET(LEX_USABLE 1 CACHE INTERNAL "lex/flex version 2 or higher")
   ENDIF()
ENDIF()


# Handle out-of-source build from source package with possibly broken 
# lex/flex. Copy lex/flex output to from source to build directory, if not already 
# there
MACRO(COPY_LEX_OUTPUT input_cc input_h output_cc output_h)
  IF(EXISTS ${input_cc} AND NOT EXISTS ${output_cc})
    CONFIGURE_FILE(${input_cc} ${output_cc} COPYONLY)
    CONFIGURE_FILE(${input_h}  ${output_h}  COPYONLY)
  ENDIF()
ENDMACRO()


# Use lex/flex to generate C++ and header file
MACRO (RUN_LEX input_lex output_cc output_h) 
  IF(LEX_USABLE)
    ADD_CUSTOM_COMMAND(
      OUTPUT ${output_cc}
      COMMAND ${LEX_EXECUTABLE} --outfile=${output_cc} --header-file=${output_h}	${input_lex}
      DEPENDS ${input_lex}
	)
  ELSE()
    # lex/flex is missing or not usable, e.g too old
    IF(EXISTS  ${output_cc} AND EXISTS ${output_h})
      IF(${input_lex} IS_NEWER_THAN ${output_cc}  OR  ${input_lex} IS_NEWER_THAN ${output_h})
        # Possibly timestamps are messed up in source distribution.
        MESSAGE(WARNING "No usable bison found, ${input_lex} will not be rebuilt.")
      ENDIF()
    ELSE()
      # Output files are missing, bail out.
      SET(ERRMSG 
         "flex/lex (GNU parser generator) is required to build Transformer." 
         "Please install flex/lex."
      )
      IF(WIN32)
       SET(ERRMSG ${ERRMSG} 
       "You can download lex from internet, but from where to download it, i do not know, ;-)"
       "Choose 'Complete package, except sources' installation. We recommend to "
       "install flex/lex into a directory without spaces, e.g C:\\GnuWin32.")
      ENDIF()
      MESSAGE(FATAL_ERROR ${ERRMSG})
    ENDIF()
  ENDIF()
ENDMACRO()

