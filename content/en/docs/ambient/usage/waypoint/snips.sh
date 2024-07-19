#!/bin/bash
# shellcheck disable=SC2034,SC2153,SC2155,SC2164

# Copyright Istio Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

####################################################################################################
# WARNING: THIS IS AN AUTO-GENERATED FILE, DO NOT EDIT. PLEASE MODIFY THE ORIGINAL MARKDOWN FILE:
#          docs/ambient/usage/waypoint/index.md
####################################################################################################

snip_install_k8s_gateway_api() {
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd/experimental?ref=v1.1.0" | kubectl apply -f -; }
}

snip_check_ns_label() {
kubectl get ns -L istio.io/dataplane-mode
}

! IFS=$'\n' read -r -d '' snip_check_ns_label_out <<\ENDSNIP
NAME              STATUS   AGE   DATAPLANE-MODE
istio-system      Active   24h
default           Active   24h   ambient
ENDSNIP

snip_gen_waypoint_resource() {
istioctl waypoint generate --for service -n default
}

! IFS=$'\n' read -r -d '' snip_gen_waypoint_resource_out <<\ENDSNIP
kind: Gateway
metadata:
  labels:
    istio.io/waypoint-for: service
  name: waypoint
  namespace: default
spec:
  gatewayClassName: istio-waypoint
  listeners:
  - name: mesh
    port: 15008
    protocol: HBONE
ENDSNIP

snip_apply_waypoint() {
istioctl waypoint apply -n default
}

! IFS=$'\n' read -r -d '' snip_apply_waypoint_out <<\ENDSNIP
waypoint default/namespace applied
ENDSNIP

snip_deploy_a_waypoint_proxy_5() {
kubectl apply -f - <<EOF
kind: Gateway
metadata:
  labels:
    istio.io/waypoint-for: service
  name: waypoint
  namespace: default
spec:
  gatewayClassName: istio-waypoint
  listeners:
  - name: mesh
    port: 15008
    protocol: HBONE
EOF
}

snip_enroll_ns_waypoint() {
istioctl waypoint apply -n default --enroll-namespace
}

! IFS=$'\n' read -r -d '' snip_enroll_ns_waypoint_out <<\ENDSNIP
waypoint default/waypoint applied
namespace default labeled with "istio.io/use-waypoint: waypoint"
ENDSNIP

snip_use_a_waypoint_proxy_2() {
kubectl label ns default istio.io/use-waypoint=waypoint
}

! IFS=$'\n' read -r -d '' snip_use_a_waypoint_proxy_2_out <<\ENDSNIP
namespace/default labeled
ENDSNIP

snip_configure_a_service_to_use_a_specific_waypoint_1() {
istioctl waypoint apply -n default --name reviews-svc-waypoint
}

! IFS=$'\n' read -r -d '' snip_configure_a_service_to_use_a_specific_waypoint_1_out <<\ENDSNIP
waypoint default/reviews-svc-waypoint applied
ENDSNIP

snip_configure_a_service_to_use_a_specific_waypoint_2() {
kubectl label service reviews istio.io/use-waypoint=reviews-svc-waypoint
}

! IFS=$'\n' read -r -d '' snip_configure_a_service_to_use_a_specific_waypoint_2_out <<\ENDSNIP
service/reviews labeled
ENDSNIP

snip_configure_a_pod_to_use_a_specific_waypoint_1() {
istioctl waypoint apply -n default --name reviews-v2-pod-waypoint --for workload
}

! IFS=$'\n' read -r -d '' snip_configure_a_pod_to_use_a_specific_waypoint_1_out <<\ENDSNIP
waypoint default/reviews-v2-pod-waypoint applied
ENDSNIP

snip_configure_a_pod_to_use_a_specific_waypoint_2() {
kubectl label pod -l version=v2,app=reviews istio.io/use-waypoint=reviews-v2-pod-waypoint
}

! IFS=$'\n' read -r -d '' snip_configure_a_pod_to_use_a_specific_waypoint_2_out <<\ENDSNIP
pod/reviews-v2-5b667bcbf8-spnnh labeled
ENDSNIP
