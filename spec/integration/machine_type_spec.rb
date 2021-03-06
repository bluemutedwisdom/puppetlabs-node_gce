require 'spec_helper'
require 'yaml'

describe 'machine types' do
  let :face do
    Puppet::Face[:node_gce, :current]
  end

  let :options do
    YAML.load(File.read(fixture_path('project.yml')))
  end

  let :credentials do
    YAML.load(File.read(fixture_path('credentials.yml')))[:gce]
  end

  before do
    @handle = Puppet::GoogleCompute.new(options[:project])
    Puppet::GoogleCompute.stubs(:new).returns(@handle)
    @handle.stubs(:fetch_credentials).returns(credentials)
    options.merge!({})
  end

  describe 'when retrieving machine type list data' do
    it 'fails when there is no credentials data' do
      @handle.stubs(:fetch_credentials).returns({})
      lambda { face.machine_types(options) }.should raise_error
    end

    it 'fails when the credentials data does not include a client id' do
      credentials.delete(:client_id)
      lambda { face.machine_types(options) }.should raise_error
    end

    it 'fails when the credentials data does not include a client secret' do
      credentials.delete(:client_secret)
      lambda { face.machine_types(options) }.should raise_error
    end

    it 'fails when the credentials data does not include a refresh token' do
      credentials.delete(:refresh_token)
      lambda { face.machine_types(options) }.should raise_error
    end

    it 'fails when the credentials provided are invalid' do
      credentials[:client_id] = '1462647242-bad-id.apps.googleusercontent.com'
      lambda { face.machine_types(options) }.should raise_error
    end

    it 'returns the machine type list data from the Google Compute API' do
      json_result = face.machine_types(options)
      result = PSON.parse(json_result)
      result['kind'].should == "compute\#machineTypeList"
    end
  end
end