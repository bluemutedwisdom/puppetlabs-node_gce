require 'puppet/face/node_gce'

Puppet::Face.define :node_gce, '0.0.1' do
  action :images do
    summary 'List images.'
    description <<-EOT
      Obtains a list of Google Compute images and displays them on the console.
    EOT

    option '--project=' do
      summary 'The name of the Google Compute project.'

      description <<-EOT
        The name of the Google Compute project to query.
      EOT

      required
    end

    when_invoked do |options|
      Puppet::GoogleCompute.new(options[:project]).image_list
    end

    when_rendering :console do |value|
      value.to_s
    end
  end
end
