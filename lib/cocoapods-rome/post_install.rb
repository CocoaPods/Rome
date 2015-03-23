Pod::HooksManager.register('cocoapods-rome', :post_install) do |installer_context|
  sandbox_root = installer_context.sandbox_root
  sandbox = Pod::Sandbox.new(sandbox_root)

  build_dir = Pathname('build')
  destination = Pathname('Rome')

  Pod::UI.puts 'Building frameworks'

  build_dir.rmtree if build_dir.directory?
  Dir.chdir(sandbox.project_path.dirname) do
    targets = installer_context.umbrella_targets.select { |t| t.specs.any? }.map(&:cocoapods_target_label)
    targets.each do |target|
      Pod::Executable.execute_command 'xcodebuild', %(-project #{sandbox.project_path.basename} -scheme #{target} -configuration Release), true
    end
  end

  frameworks = Pathname.glob('build/Release*/Pods*/*.framework')
  frameworks_by_target = frameworks.group_by { |f| f.to_s =~ %r{^build/Release[^/]*/Pods-?([^/]*)/} && destination + $1 }

  Pod::UI.puts "Built #{frameworks.count} #{'frameworks'.pluralize(frameworks.count)}"
  Pod::UI.puts "Copying frameworks to `#{destination}`"

  destination.rmtree if destination.directory?
  frameworks_by_target.each do |dest, framework|
    FileUtils.mkdir_p dest
    FileUtils.mv framework, dest
  end
  build_dir.rmtree
end
