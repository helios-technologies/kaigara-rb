require_relative 'spec_helper'

describe 'operations', :unit do
  include TmpDirIsolation

  let(:sysops_task) { Kaigara::Sysops }

  before(:each) do
    FileUtils.cp_r(fixture("refops"), ".")
    Dir.chdir "refops"
  end

  describe "script" do
    it 'generate and run any script' do
      expect { sysops_task.start(["exec", "01_script"]) }.to output(/perl/).to_stdout
      expect { sysops_task.start(["exec", "01_script"]) }.to output(/bash/).to_stdout
      expect { sysops_task.start(["exec", "01_script"]) }.to output(/ruby/).to_stdout
    end
  end

  describe "template" do
    it "generate files from templates" do
      sysops_task.start(["exec", "02_template"])
      expect(File).to exist("resources/script.pl")
      expect(File).to exist("resources/script.rb")
      expect(File).to exist("resources/script.sh")

      expect(`perl resources/script.pl`).to include("perl")
      expect(`ruby resources/script.rb`).to include("ruby")
      expect(`bash resources/script.sh`).to include("bash")
    end
  end
end
