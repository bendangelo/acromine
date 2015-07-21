require 'gli'

require 'acromine/version'
require 'acromine/core'

# a client for the Acromine REST service
class Acromine
  # the command line interface for the Chef AWS Infrastructure
  class CLI
    include GLI::App
    include GLI::DSL
    include GLI::AppSupport

    def initialize
      # info about the CLI
      program_desc 'a client for the Acromine REST Service'
      version Acromine::VERSION
      config_file '.acromine.conf'

      # global flags
      flag :uri,
           desc: 'the URI of the webservice',
           arg_name: 'URI',
           default_value: Acromine::DEFAULT_URI

      # lf (longform)
      desc 'expands acronym to its long form(s)'
      arg :acronym
      command [:longform, :lf] do |c|
        c.flag :limit,
               desc: 'limit number of long forms returned',
               arg_name: 'NUM'
        c.flag 'sort',
               desc: 'how to sort long forms',
               arg_name: 'SPEC',
               default_value: 'fd,ya'
        c.action do |gopts, opts, args|
          acro = Acromine.new(gopts[:uri])
          lfs = acro.longforms(args[0], lf_opts(opts))
          if lfs.empty?
            exit_now! "no long forms found for '#{args[0]}'"
          else
            $stdout.puts "#{args[0]} may refer to:"
            lfs.each do |lf|
              $stdout.puts "  #{lf.longform}"
            end
          end
        end
      end
    end

    private

    def lf_opts(in_opts)
      out_opts = { sort_spec: in_opts['sort'] }
      out_opts[:limit] = in_opts[:limit] if in_opts[:limit]
      out_opts
    end
  end
end
