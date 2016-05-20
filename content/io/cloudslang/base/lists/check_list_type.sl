#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Check if the list is int or string.
#! @input list: Type of list
#! @output result: STR or INT elements.
#! @result SUCCESS: all elements in the list are STR or INT.
#! @result FAILURE: list contains STR and INT elements.
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: check_list_type
  inputs:
    - list

  python_action:
    script: |
      error_message = ""
      message = ""
      if all(isinstance(item, basestring) for item in list):
        message = "All elements in list are STR"
      elif all(isinstance(item, int) for item in list):
        message = "All elements in list are INT"
      else:
        if any(isinstance(item, (str, int)) for item in list):
          error_message = "List contains STR and INT elements"
      
  outputs:
    - result: ${message}
    - error_message
    
  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE
