# (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# System property file for network operations
#
# io.cloudslang.base.network.trust_keystore: The pathname of the Java TrustStore file
# io.cloudslang.base.network.trust_password: The password associated with the TrustStore file
# io.cloudslang.base.network.keystore: The pathname of the Java KeyStore file
# io.cloudslang.base.network.keystore_password: The password associated with the KeyStore file
#
########################################################################################################################

namespace: io.cloudslang.base.network

properties:
  - trust_keystore: ''
  - trust_password:
      value: 'changeit'
      sensitive: true
  - keystore: ''
  - keystore_password:
      value: 'changeit'
      sensitive: true
