require 'spec_helper'

describe Kaish do
  describe 'sysops' do
    before do
      system 'mkdir tmp'
      system 'bin/kaish sysops create -p tmp'
      system 'bin/kaish sysops generate hello -p tmp'
    end

    describe 'sysops create' do
      it 'creates basic project' do
        expect(Dir.entries 'tmp').to eq %w(. operations resources Vagrantfile metadata.rb ..)
      end
    end

    describe 'generate' do
      it 'creates operations' do
        File.exist? Dir['tmp/operations/*_hello.rb'].first
      end
    end

    describe 'sysops exec' do
      before do
        system 'echo "puts \'Hello world!\'" > tmp/operations/*hello.rb'
        system 'cd tmp && ../bin/kaish sysops exec'
      end

      it 'prints \'Hello world!\'' do
        true
      end
    end

    after do
      system 'cd ..'
      system 'rm -r tmp'
    end
  end
end
