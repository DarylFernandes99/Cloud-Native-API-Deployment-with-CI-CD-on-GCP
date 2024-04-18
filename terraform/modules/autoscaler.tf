resource "google_compute_region_autoscaler" "default" {
    for_each = {
        for idx, config in flatten([
            for instance_template_name, instance_template_config in var.instance_template_properties: flatten([
                for instance_target_pool_name, instance_target_pool_config in instance_template_config.instance_target_pool : flatten([
                    for instance_group_manager_name, instance_group_manager_config in instance_target_pool_config.instance_group_manager : flatten([
                        for autoscaler_name, autoscaler_config in instance_group_manager_config.autoscaler : {
                            "name"         : autoscaler_config.name
                            "autoscaling_policy"         : autoscaler_config.autoscaling_policy
                            "instance_group_manager_name": autoscaler_config.instance_group_manager_name
                        }
                    ])
                ])
            ])
        ]) : idx => config
    }

    name   = each.value.name
    region = var.region
    target = google_compute_region_instance_group_manager.default[each.value.instance_group_manager_name].self_link

    dynamic "autoscaling_policy" {
        for_each = each.value.autoscaling_policy

        content {
            max_replicas    = autoscaling_policy.value.max_replicas
            min_replicas    = autoscaling_policy.value.min_replicas
            cooldown_period = autoscaling_policy.value.cooldown_period

            cpu_utilization {
                target = autoscaling_policy.value.cpu_utilization_target
            }
        }
    }

    depends_on = [
        google_compute_region_instance_group_manager.default
    ]
}
