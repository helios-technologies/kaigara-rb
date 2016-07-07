module Kaigara
  module DSL
    include Thor::Base
    include Thor::Actions
    include Thor::Shell

    def self.included(receiver)
      receiver.send :include, Thor::Actions
      receiver.send :include, Thor::Base
      receiver.send :include, Thor::Shell
    end

    # One of the most important parts of DSL. You can use it directly in your operations.
    def execute(cmd)
      Environment.load_variables(self)
      say "Running: #{cmd}", :yellow
      stdin, stdout, stderr, wait_thr = Open3.popen3({}, "bash -e")
      stdin.puts(cmd)
      Thread.new do
        stdout.each { |l| say(l, :green) }
      end
      Thread.new do
        stderr.each { |l| say(l, :red) }
      end
      stdin.close

      exit_status = wait_thr.value.exitstatus
      if exit_status != 0
        raise "Command `#{ cmd }` returned status code #{ exit_status }"
      end
    end

    #
    # Templates ERB template. You can use variables from metadata.rb in your templates.
    # <tt>name</tt> - template name, without '.erb'
    # <tt>-p</tt> - destination file. If you don't use it, the file renders to +/path-in-resources/+
    #
    def template(source, target)
      Environment.load_variables(self)
      tpl_file = 'resources/' + source + '.erb'
      destination = target
      destination = "/#{tpl_file}" if destination.nil?
      destination.gsub!(/\.erb$/,'')
      context = instance_eval("binding")

      say "Rendering template #{tpl_file} to #{destination}", :yellow
      File.write(destination, ERB.new(File.read(tpl_file), nil, "-", "@output_buffer").result(context))

      return destination
    end

    #
    # Renders a template, then executes the script.
    # You should add shebang to your script.
    #
    def script(name, path = nil)
      target = template(name, File.join( (path.nil? ? "" : path), name))
      File.chmod(0755, target)
      target.prepend('./') unless target.match(/^\//)
      execute("#{target}")
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
        execute("yum update -y")
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

    #
    # Creates a file with the specified content
    #
    def file(filepath, content, opts = {overwrite: true})
      if !opts[:overwrite] and File.exists?(filepath)
        raise "File #{filepath} exists"
      end

      File.open(filepath, "w") do |fd|
        fd.write(content)
      end
    end

    #
    # Configure the hostname of the machine
    #
    def hostname(hostname)
      file("/etc/hostname", hostname)
    end
  end
end
