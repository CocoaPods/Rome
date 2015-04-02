module Pod
  class Installer
    alias_method :real_prepare, :prepare
    def prepare
      real_prepare

      return unless podfile.plugins.keys.include?('cocoapods-rome')

      config.integrate_targets = false
      config.skip_repo_update = true
    end
  end

  class Podfile
  	class TargetDefinition
  	  alias_method :real_use_frameworks?, :uses_frameworks?
  	  def uses_frameworks?
  	  	podfile.plugins.keys.include?('cocoapods-rome') ? true : real_use_frameworks?
  	  end
  	end
  end
end
