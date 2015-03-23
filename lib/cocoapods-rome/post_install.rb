Pod::HooksManager.register('cocoapods-rome', :post_install) do |installer_context|
	sandbox_root = installer_context.sandbox_root
	sandbox = Pod::Sandbox.new(sandbox_root)

	build_dir = Pathname('build')
	destination = Pathname('Rome')

	Pod::UI.puts 'Building frameworks'

	build_dir.rmtree
	Dir.chdir(sandbox.project_path.dirname) do
		Pod::Executable.execute_command 'xcodebuild', %(-project #{sandbox.project_path.basename} -scheme Pods -configuration Release), true
	end

	frameworks = Pathname.glob('build/Release/Pods/*.framework')

	Pod::UI.puts "Built #{frameworks.count} #{'frameworks'.pluralize(frameworks.count)}"
	Pod::UI.puts 'Copying frameworks to `Rome`'

	destination.mkpath unless destination.directory?
	FileUtils.mv(frameworks, 'Rome')
	build_dir.rmtree
end
