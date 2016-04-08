Pod::HooksManager.register('cocoapods-rome', :pre_install) do |installer_context|
  podfile = installer_context.podfile
  podfile.use_frameworks!
  podfile.install!('cocoapods', {
    :integrate_targets => false
  })
end
