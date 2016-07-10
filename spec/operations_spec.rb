require_relative 'spec_helper'

describe 'operations', :unit do
  include TmpDirIsolation

  let(:sysops_task) { Kaigara::Sysops }
  let(:sysops) { sysops_task.new }

  before(:each) do
    FileUtils.cp_r(fixture("refops"), ".")
    Dir.chdir "refops"
  end

  describe "script" do
    it 'generates and runs scripts' do
      expect { sysops_task.start(["exec", "01_script"]) }.to output(/perl/).to_stdout
      expect { sysops_task.start(["exec", "01_script"]) }.to output(/bash/).to_stdout
      expect { sysops_task.start(["exec", "01_script"]) }.to output(/ruby/).to_stdout
    end

    it 'renders the template' do
      sysops.exec
      expect(File.read("resources/script.sh")).to match(/echo 'bash'/)
    end

    it 'makes scripts executable' do
      sysops.exec
      expect(File.stat('resources/script.pl').executable?).to be true
      expect(File.stat('resources/script.rb').executable?).to be true
      expect(File.stat('resources/script.sh').executable?).to be true
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
