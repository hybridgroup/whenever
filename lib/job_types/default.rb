module Whenever
  module Job
    class Default
      
      attr_accessor :task, :at, :cron_log
    
      def initialize(options = {})
        @task        = options[:task]
        @at          = options[:at]
        @cron_log    = options[:cron_log]
        @environment = options[:environment] || :production
        @path        = options[:path] || Whenever.path
        @lockrun     = options[:lockrun]
      end
    
      def output
        output = wrap_task(task)
        if @lockrun
          lockrunify output
        else
          output
        end
      end

    protected
      
      def path_required
        raise ArgumentError, "No path available; set :path, '/your/path' in your schedule file" if @path.blank?
      end

      def wrap_task(task)
        task
      end

      def lockrunify(output)
        path_required
        escaped_output = output
        %Q{/usr/bin/env lockrun --lockfile=#{lockfile_path} -- sh -c "#{escaped_output}"}
      end

      def lockfile_path
        path_required
        filename_prefix = @lockrun == true ? "default" : @lockrun
        "#{@path}/log/#{filename_prefix}.lockrun"
      end
      
    end
  end
end
