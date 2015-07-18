Pod::HooksManager.register('cocoapods-rome', :pre_install) do |installer_context|
  installer_context.podfile.use_frameworks!
  Pod::Config.instance.integrate_targets = false
end
