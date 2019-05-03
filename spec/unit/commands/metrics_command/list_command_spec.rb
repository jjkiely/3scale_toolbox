RSpec.describe ThreeScaleToolbox::Commands::MetricsCommand::List::ListSubcommand do
  let(:arguments) do
    {
      service_ref: 'someservice', remote: 'https://destination_key@destination.example.com'
    }
  end
  let(:options) { {} }
  let(:service_class) { class_double(ThreeScaleToolbox::Entities::Service).as_stubbed_const }
  let(:service) { instance_double('ThreeScaleToolbox::Entities::Service') }
  let(:remote) { instance_double('ThreeScale::API::Client', 'remote') }
  subject { described_class.new(options, arguments, nil) }

  context '#run' do
    before :example do
      expect(service_class).to receive(:find).and_return(service)
      expect(subject).to receive(:threescale_client).and_return(remote)
    end

    context 'when service not found' do
      let(:service) { nil }

      it 'error raised' do
        expect { subject.run }.to raise_error(ThreeScaleToolbox::Error,
                                              /Service someservice does not exist/)
      end
    end

    context 'when metric list is returned' do
      let(:hits_metric) { { 'id' => '0', 'friendly_name' => 'hits' } }
      let(:metric_1) { { 'id' => '1', 'friendly_name' => 'metric 1' } }
      let(:metric_2) { { 'id' => '2', 'friendly_name' => 'metric 2' } }
      let(:method_0) { { 'id' => '3', 'friendly_name' => 'method 0' } }
      let(:method_1) { { 'id' => '4', 'friendly_name' => 'method 1' } }
      let(:methods) { [method_0, method_1] }
      # metrics include methods
      let(:metrics) { [hits_metric, metric_1, metric_2] + methods }

      before :example do
        expect(service).to receive(:hits).and_return(hits_metric)
        expect(service).to receive(:metrics).and_return(metrics)
        expect(service).to receive(:methods).with(hits_metric['id']).and_return(methods)
      end

      it 'method_0 not in the list' do
        expect { subject.run }.not_to output(/method 0/).to_stdout
      end

      it 'method_1 not in the list' do
        expect { subject.run }.not_to output(/method 1/).to_stdout
      end

      it 'hits metric in the list' do
        expect { subject.run }.to output(/hits/).to_stdout
      end

      it 'metric_1 in the list' do
        expect { subject.run }.to output(/metric 1/).to_stdout
      end

      it 'metric_2 in the list' do
        expect { subject.run }.to output(/metric 2/).to_stdout
      end
    end
  end
end
