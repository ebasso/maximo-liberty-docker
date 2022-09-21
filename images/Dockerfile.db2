# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM busybox

LABEL org.opencontainers.image.authors="nishi2go@gmail.com,ebasso@ebasso.net"

ARG db_ver=11.1
ARG db_fp

ENV DB2_IMAGE=DB2_AWSE_REST_Svr_${db_ver}_Lnx_86-64.tar.gz
ENV DB2_FP_IMAGE=v${db_ver}.${db_fp}_linuxx64_server_t.tar.gz

COPY checkdb2.sh packages.list.db2 /
COPY ${DB2_IMAGE} ${DB2_FP_IMAGE} /images/

# Copy backup files
COPY backup/* /backup/

RUN chmod +x /checkdb2.sh && /checkdb2.sh -C /images

# Unpack the Db2 packages
RUN mkdir /db2 && tar zxpf /images/${DB2_IMAGE} -C /db2
RUN mkdir /db2fp && tar zxpf /images/${DB2_FP_IMAGE} -C /db2fp
