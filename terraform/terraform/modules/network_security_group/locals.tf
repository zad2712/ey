locals {
  # Pre-compute conditional logic for each security rule to reduce duplication
  security_rules_with_conditionals = {
    for rule_key, rule_value in var.additional_security_rules : rule_key => {
      # Original rule values
      rule = rule_value

      # Computed presence flags for plural arrays
      src_port_ranges_present   = rule_value.source_port_ranges != null && length(rule_value.source_port_ranges) > 0
      dst_port_ranges_present   = rule_value.destination_port_ranges != null && length(rule_value.destination_port_ranges) > 0
      src_addr_prefixes_present = rule_value.source_address_prefixes != null && length(rule_value.source_address_prefixes) > 0
      dst_addr_prefixes_present = rule_value.destination_address_prefixes != null && length(rule_value.destination_address_prefixes) > 0
    }
  }
}