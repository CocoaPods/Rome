Pod::HooksManager.register('cocoapods-rome', :post_install) do |installer_context|
  sandbox_root = Pathname(installer_context.sandbox_root)
  sandbox = Pod::Sandbox.new(sandbox_root)

  build_dir = sandbox_root.parent + 'build'
  destination = sandbox_root.parent + 'Rome'

  Pod::UI.puts 'Building frameworks'

  build_dir.rmtree if build_dir.directory?
  Dir.chdir(sandbox.project_path.dirname) do
    targets = installer_context.umbrella_targets.select { |t| t.specs.any? }.map(&:cocoapods_target_label)
    targets.each do |target|
      Pod::Executable.execute_command 'xcodebuild', %(-project #{sandbox.project_path.basename} -scheme #{target} -configuration Release), true
    end
  end

  raise Pod::Informative 'The build directory was not found in the expected location.' unless build_dir.directory?

  frameworks = Pathname.glob(build_dir + 'Release*/Pods*/*.framework')
  frameworks_by_target = frameworks.group_by { |f| f.to_s =~ %r{build/Release[^/]*/Pods-?([^/]*)/} && destination + $1 }

  Pod::UI.puts "Built #{frameworks.count} #{'frameworks'.pluralize(frameworks.count)}"
  Pod::UI.puts "Copying frameworks to `#{destination.relative_path_from Pathname.pwd}`"

  destination.rmtree if destination.directory?
  frameworks_by_target.each do |dest, frameworks|
    FileUtils.mkdir_p dest
    FileUtils.mv frameworks, dest
  end
  build_dir.rmtree
end
