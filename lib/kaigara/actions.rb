module Kaigara
  module Actions
    def execute(cmd)
      @shell.say "Running: #{cmd}", :yellow
      stdin, stdout, stderr, wait_thr = Open3.popen3({}, "bash -e")
      stdin.puts(cmd)
      Thread.new do
        stdout.each { |l| @shell.say(l, :green) }
      end
      Thread.new do
        stderr.each { |l| @shell.say(l, :red) }
      end
      stdin.close

      exit_status = wait_thr.value.exitstatus
      if exit_status != 0
        raise "Command `#{ cmd }` returned status code #{ exit_status }"
      end
    end

    #
    # Return true if the `file` exists? and the content matches the `match`
    # If a block is given it's executed if the statement is true
    #
    def file_matches?(file, match)
      if File.exists?(file)
        if File.read(file).match(match)
          yield if block_given?
          return true
        end
      end
      false
    end

    #
    # Return true if the OS is Ubuntu or Debian
    # If a block is given it's executed if the statement is true
    #
    def debian_family?
      file_matches?("/etc/issue", /Ubuntu|Debian/i) do
        yield if block_given?
      end
    end

    #
    # Return true if the OS is CentOS or RedHat
    # If a block is given it's executed if the statement is true
    #
    def redhat_family?
      file_matches?("/etc/redhat-release", /CentOS|Red Hat/i) do
        yield if block_given?
      end
    end

    #
    # Add common additional repositories
    #
    def repo_extended
      redhat_family? do
        package("epel-release")
        package_update
      end
    end

    #
    # Update the local repository cache
    #
    def package_update
      if debian_family?
        execute("apt-get update")
      elsif redhat_family?
        execute("yum update")
      end
    end

    #
    # Install the package depending on OS
    #
    def package(name, version = nil)
      if debian_family?
        execute("apt-get install -y #{ name }")
      elsif redhat_family?
        execute("yum install -y #{ name }")
      else
        raise "OS not supported"
      end
    end

    def template(name, target = nil)
      tpl_file = name + '.erb'
      destination = target
      destination = "/#{tpl_file}" if destination.nil?
      destination.gsub!(/\.erb$/,'')

      @shell.say "Rendering template #{tpl_file} to #{destination}", :yellow
      Shell.source_root(File.join(@work_dir, 'resources'))
      @shell.template(tpl_file, destination)

      return destination
    end

    def script(name, path = nil)
      target = template(name, File.join( (path.nil? ? "" : path), name))
      @shell.chmod(target, 0755)
      target.prepend('./') unless target.match(/^\//)
      execute("#{target}")
    end
  end
end
