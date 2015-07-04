def xcodebuild(sandbox, target, sdk='macosx')
  Pod::Executable.execute_command 'xcodebuild', %W(-project #{sandbox.project_path.basename} -scheme #{target} -configuration Release -sdk #{sdk}), true
end

Pod::HooksManager.register('cocoapods-rome', :post_install) do |installer_context|
  sandbox_root = Pathname(installer_context.sandbox_root)
  sandbox = Pod::Sandbox.new(sandbox_root)

  build_dir = sandbox_root.parent + 'build'
  destination = sandbox_root.parent + 'Rome'

  Pod::UI.puts 'Building frameworks'

  build_dir.rmtree if build_dir.directory?
  Dir.chdir(sandbox.project_path.dirname) do
    targets = installer_context.umbrella_targets.select { |t| t.specs.any? }
    targets.each do |target|
      if target.platform_name == :ios
        xcodebuild(sandbox, target.cocoapods_target_label, 'iphoneos')
        xcodebuild(sandbox, target.cocoapods_target_label, 'iphonesimulator')

        target.specs.each do |spec|
          device_lib = "#{build_dir}/Release-iphoneos/#{spec.name}.framework/#{spec.name}"
          simulator_lib = "#{build_dir}/Release-iphonesimulator/#{spec.name}.framework/#{spec.name}"
          `lipo -create -output "#{build_dir}/#{spec.name}" #{device_lib} #{simulator_lib}`

          FileUtils.mv "#{build_dir}/#{spec.name}", device_lib
          Pathname.new("#{build_dir}/Release-iphonesimulator/#{spec.name}.framework").rmtree
        end
      else
        xcodebuild(sandbox, target.cocoapods_target_label)
      end
    end
  end

  raise Pod::Informative, 'The build directory was not found in the expected location.' unless build_dir.directory?

  frameworks = Pathname.glob(build_dir + 'Release*/*.framework').reject { |f| f.to_s =~ /Pods*\.framework/ }

  Pod::UI.puts "Built #{frameworks.count} #{'frameworks'.pluralize(frameworks.count)}"
  Pod::UI.puts "Copying frameworks to `#{destination.relative_path_from Pathname.pwd}`"

  destination.rmtree if destination.directory?
  frameworks.each do |framework|
    FileUtils.mkdir_p destination
    FileUtils.cp_r framework, destination, :remove_destination => true
  end
  build_dir.rmtree if build_dir.directory?
end
