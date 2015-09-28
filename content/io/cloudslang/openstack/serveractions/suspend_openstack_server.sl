#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Suspends a running server (instance) and changes its status to SUSPENDED.
#
# Note:
#   - this operation stores the VM state on disk, writes all memory to disk, and stops the VM
#   - suspending an instance is similar to placing a device in hibernation, memory and vCPUs become available to create other instances
#
# Inputs:
#   - host - OpenStack host (instance)
#   - compute_port - port used for OpenStack computations - Default: "'8774'"
#   - tenant_name - name of the OpenStack project that contains the server (instance) to be stopped
#   - tenant_id - the id corresponding to tenant_name
#   - server_id - the id of the server (instance) to be stopped
#   - username - optional - username used for URL authentication; for NTLM authentication, the required format is 'domain\user'
#   - password - optional - password used for URL authentication
#   - proxy_host - optional - the proxy server used to access the OpenStack services
#   - proxy_port - optional - the proxy server port used to access the the OpenStack services - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not "202"
#   - return_code - "0" if success, "-1" otherwise
#   - status_code - the code returned by the operation
# Results:
#   - SUCCESS - OpenStack server (instance) was successfully suspended
#   - GET_AUTHENTICATION_FAILURE - the authentication step fail
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication step response
#   - SUSPEND_SERVER_FAILURE - OpenStack server (instance) cannot be suspended
####################################################

namespace: io.cloudslang.openstack.serveractions

imports:
  rest: io.cloudslang.base.network.rest
  auth: io.cloudslang.openstack
  json: io.cloudslang.base.json

flow:
  name: suspend_openstack_server
  inputs:
    - host
    - compute_port: "'8774'"
    - tenant_name
    - tenant_id
    - server_id
    - username:
        default: "''"
        required: false
    - password:
        default: "''"
        required: false
    - proxy_host:
        default: "''"
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        default: "''"
        required: false
    - proxy_password:
        default: "''"
        required: false

  workflow:
    - get_authentication:
        do:
          auth.get_authentication:
            - host
            - tenant_name
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - auth_response: return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: get_authentication_token
          FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value_from_json:
            - json_input: auth_response
            - key_list: ["'access'", "'token'", "'id'"]
        publish:
          - token: value
        navigate:
          SUCCESS: suspend_server
          FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - suspend_server:
        do:
          rest.http_client_post:
            - url: "'http://' + host + ':' + compute_port + '/v2/' + tenant_id + '/servers/'+ server_id + '/action'"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: "'X-AUTH-TOKEN:' + token"
            - body: "'{\"suspend\":null}'"
            - content_type: "'application/json'"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: SUSPEND_SERVER_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - token

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - SUSPEND_SERVER_FAILURE