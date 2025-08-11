output "vm_ids" {
  value = { 
    for k, vm in azurerm_windows_virtual_machine.vm : k => vm.id }
}

output "nic_ids" {
  value = { for k, nic in azurerm_network_interface.nic : k => nic.id }
}

output "vm_shutdown_schedule_ids" {
  value = { for k, v in azurerm_dev_test_global_vm_shutdown_schedule.vm_shutdown_sched : k => v.id }
}
