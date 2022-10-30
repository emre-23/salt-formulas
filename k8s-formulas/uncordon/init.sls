{% import 'roles/vars.sls' as roles with context -%}

{% if grains['roles']['_role'] == 'worker' && grain['roles']['_service'] == 'kubernetes' %}
# k8s_node_draim:
#     kubernetes.node_label_absent:
#       - node_name: {{ roles['hostname'] }}
#       - availability: drain

{% endif %}