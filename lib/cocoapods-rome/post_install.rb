
Pod::HooksManager.register('cocoapods-rome', :post_install) do |installer_context|
	sandbox_root = installer_context.sandbox_root
  	sandbox = Pod::Sandbox.new(sandbox_root)

  	puts 'Building frameworks'

  	FileUtils.rmtree('build')
  	Dir.chdir(sandbox.project_path.dirname) do
  		`xcodebuild -project #{sandbox.project_path.basename} -scheme Pods -configuration Release`
  	end

  	`mv build/Release/Pods/*.framework build`
  	FileUtils.rmtree('build/Pods.build')
  	FileUtils.rmtree('build/Release')
  	`mv build Rome`
end
