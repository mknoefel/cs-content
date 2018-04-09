########################################################################################################################
#!!
#! @description: Generated flow description
#!
#! @input input_1: Generated description
#! @input input_2: Generated description
#!
#! @output output_1: Generated description
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: content.io.cloudslang.demo

flow:
    name: deploy_tomcat

    inputs:
      - hostname: "10.0.46.10"
      - username: "Capa1\\1286-capa1user"
      - password: "Automation123"
      - image: "Ubuntu"
      - folder: "Students"


    workflow:
      - uuid_generator:
          do:
            io.cloudslang.base.utils.uuid_generator:
          publish:
            - uuid: '${new_uuid}'
          navigate:
            - SUCCESS: trim

      - trim:
          do:
            io.cloudslang.base.strings.substring:
            - origin_string: '${markus-+uuid}'
            - end_index: '13'
          publish:
            - id: '${new_string}'
          navigate:
            - FAILURE: FAILURE
            - SUCCESS: SUCCESS

    results:
      - FAILURE
      - SUCCESS