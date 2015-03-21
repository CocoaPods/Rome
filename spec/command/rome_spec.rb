require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Rome do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ rome }).should.be.instance_of Command::Rome
      end
    end
  end
end

