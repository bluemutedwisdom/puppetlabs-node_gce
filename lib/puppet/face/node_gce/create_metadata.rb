require 'puppet/face/node_gce'

Puppet::Face.define :node_gce, '0.0.1' do
  action :create_metadata do
    summary 'Create or update project metadata.'
    description <<-EOT
      Create or update project metadata.
      
      SSH keys may take 60 seconds to propogate.
    EOT

    option '--project=' do
      summary 'The name of the Google Compute project.'

      description <<-EOT
        The name of the Google Compute project to query.
      EOT

      required
    end

    option '--key=' do
      summary 'The metadata key.'

      description <<-EOT
        The medata key
      EOT

      required
    end

    option '--value=' do
      summary 'The metadata value.'

      description <<-EOT
        The medata value
      EOT

      required
    end

    when_invoked do |options|
      Puppet::GoogleCompute.new(options[:project]).metadata_create(options[:key], options[:value])
    end

    when_rendering :console do |value|
      value.to_s
    end
  end
end
