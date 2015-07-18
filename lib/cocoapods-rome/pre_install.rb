Pod::HooksManager.register('cocoapods-rome', :pre_install) do |installer_context|
  installer_context.podfile.use_frameworks!
  Pod::Config.integrate_targets = false
end
