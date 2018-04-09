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

namespace: io.cloudslang.demo
imports:
  base: io.cloudslang.base
  vm: io.cloudslang.vmware.vcenter.virtual_machines

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
            base.utils.uuid_generator:
          publish:
            - uuid: '${new_uuid}'
          navigate:
            - SUCCESS: trim
      - trim:
          do:
            base.strings.substring:
            - origin_string: '${"markus-"+uuid}'
            - end_index: '13'
          publish:
            - id: '${new_string}'
          navigate:
            - FAILURE: FAILURE
            - SUCCESS: SUCCESS
      - clone_vm:
        do:
          vm.clone_virtual_machine:
            - host: '${hostname}'
            - hostname: 'trnvc.eswdc.net'
            - username: '${username}'
            - password: '${password}'
            - clone_host: 'trnvc.eswdc.net'
            - data_center_name: 'CAPA1 Datacenter'
            - is_template: 'false'
            - virtual_machine_name: '${image}'
            - clone_name: '${id}'
            - folder_name: '${folder}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
    results:
      - FAILURE
      - SUCCESS
